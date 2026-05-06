# Ampex D-175 Keyboard — Reverse Engineering Plan

The keyboard is an Ampex P/N **3512622-02 Rev A** (TA-120047, date code 8349 =
week 49 of 1983) sitting on PCB **PWB 3512615-01**. It is the detached
serial-cable keyboard that mates with the D-175 main logic board.

This plan covers two parallel tracks — **hardware reverse engineering** (chip
identification, schematic, signal capture) and **firmware reverse engineering**
(disassembly and analysis of the on-board EPROM).

---

## 1. What we know from the photos

Five photos in this directory; here is what each one establishes:

| Photo | Establishes |
|---|---|
| `2025-08-23 16.17.56.jpg` | Whole-keyboard front view; layout (QWERTY + edit cluster + numeric keypad with TOTAL key, PROG A/B, HELP/INS/PRINT/CNCL row). Star Technologies badge on monitor. |
| `2025-08-23 17.10.22.jpg` | Top-down with case open; the active electronics live on a **vertical PCB strip down the left edge**, not under the matrix. |
| `2025-08-23 17.10.29.jpg` | Mid-resolution chip strip — 4 ICs visible plus a 14-pin DIP near the top. |
| `2025-08-23 14.52.17.jpg` | **Solder-side** view: PWB 3512615-01, key positions silkscreened (1-25 across the top row; numbering continues 40-46 / 62-68 — implies ~84 key positions). PCB stamp `900 207 002` and revision E sticker. |
| `2025-07-29 15.51.11.jpg` | Component-side closeup of the matrix: discrete keyswitch sleeves with **springs and a foam puck** — these are **Ampex/Stackpole foam-and-foil capacitive** keyswitches (typical of D-series). No diodes per key, so the matrix is sensed capacitively, not by simple X×Y matrix. |
| `2025-07-29 15.58.57.jpg` | Bottom case label (Ampex P/N + date). |

### 1.1 ICs identified (from `2025-08-23 17.10.29.jpg`, top → bottom)

| Ref | Marking | Function | Notes |
|---|---|---|---|
| U5 (small, top) | `SN7437N` (TI, El Salvador, "33XD") | Quad 2-input NAND buffer (high-current driver) | Likely buffers strobe outputs from the 8039 / serial-output line back to host. |
| (top large) | `INS8039N-11` / `P8039L` (NSC, "B8216" = wk 16/82) | **MCS-48 family CPU, ROM-less** | This is the firmware engine. 11 MHz crystal version. Needs external program ROM addressed via an octal latch on the multiplexed BUS port. |
| U3 | `74LS373N` ("M833 SA") | Octal transparent latch | The address-low latch latched by ALE from the 8039 — confirms external-ROM topology. |
| U2 | `1983 AMPEX CORP` paper sticker over UV window, hand-marked "Aug 31[?] '83" | **2716 EPROM, 2 KiB** — the ROM dumped as `U2-D2716.bin` | sha256 `9e421d7f5724185014e28d99864a2cfbec5201ff7aa78d76ce167f892a8b32e1`. Holds the 8039 program. |
| U1 (40-pin, bottom) | `GI 321299007 / 2209-00C-37 / 8311 C-U / TAIWAN`, marker-pen "3.0" with date sticker `8312` | **General Instrument 40-pin custom-marked IC**, role TBD | Position next to the matrix-flex cable suggests a **capacitive matrix sense / scan front-end** (probable AY-5-3600-family encoder, or a GI-fab MCU). Marker "3.0" hints at internal firmware revision — i.e., it's a masked-ROM MCU, not a logic part. |

Decoupling caps `C5/C6/C8/C11/C13`, several pull-up SIP-style resistor packs,
and `R8/R9/R12` discretes are visible — typical for an MCU board, no exotica.

### 1.2 What the chip lineup implies architecturally

Two-MCU split is the most likely topology:

```
+--------------+       +-------------------+        +-------------+
| Capacitive   |  raw  |   GI U1 40-pin    | parallel/serial |  INS8039  |
| key matrix   |  cap  |   (matrix scan +  | =====>  |  + 2716   | ===> serial out
| (foam-and-   | sense |    encode)        |        |    (U2)   |     to host
|  foil)       |       |                   |        |           |
+--------------+       +-------------------+        +-------------+
```

The 8039 owns the **serial protocol to the host** (D-175 main board), the
**HELP / PROG A / PROG B / TOTAL function logic**, and probably **autorepeat
and click**. The GI part owns **capacitive sense** (which is too tight for a
generic MCU GPIO loop) and hands cooked keycodes off to the 8039.

This needs to be **confirmed by tracing PCB nets**, not assumed.

---

## 2. Reverse engineering plan

Phased so each phase produces a reviewable artifact and de-risks the next.

### Phase 0 — Inventory (DONE)

- [x] Dump the 2716 (`U2-D2716.bin`)
- [x] Photograph component side, solder side, bottom label
- [x] Identify visible chip markings

### Phase 1 — Pin out & schematic (HARDWARE)

Goal: a one-page schematic of the active strip.

1. **High-res photos** of:
   - the entire component-side PCB strip (one shot, well lit, no parallax),
   - the entire solder-side strip (the existing `14.52.17.jpg` is the right
     framing — repeat for the rest of the strip),
   - close-ups of the GI U1 markings under raking light (current marker-pen
     scrawl is partially obscuring it),
   - the matrix-flex / ribbon cable at both ends (host-side connector pinout).
2. **Continuity-trace** with the board powered off:
   - 8039 pins → 74LS373 → 2716 (verify the standard MCS-48 multiplexed-bus
     wiring: BUS lines latched by ALE feed 2716 A0-A7; P20-P23 feed A8-A11;
     /PSEN gates 2716 /OE; /EA tied high or low?).
   - 8039 P10-P17 and remaining P24-P27 → either GI U1 or external connector.
   - GI U1 pins → matrix flex / sense lines.
   - Strobe / clock lines between 8039 and GI U1.
   - 7437 — figure out which 8039 pin it buffers and where the buffered output
     goes (most likely: the keyboard-to-host serial line, possibly TTL-level
     into the coiled cable visible in photo 17.10.29).
3. Identify the **host connector pinout** (it's a coiled cable, 4 wires
   visible — almost certainly +5V, GND, KBD->HOST data, HOST->KBD data or
   click/LED control).
4. Capture **logic-analyzer traces** at power-on with `clcapture` (the project
   already uses Pico Logic Analyzer; see `ampex-d175-terminal/disassembly` for
   the existing toolchain). Sample on the cable wires + ALE + /PSEN to confirm
   serial baud rate, framing, and whether the host→keyboard direction carries
   commands.

**Deliverable:** `keyboard/SCHEMATIC.md` with a hand-drawn or text schematic,
the host-cable pinout, and the captured serial framing.

### Phase 2 — Firmware disassembly (FIRMWARE)

Goal: a maintained, regenerable disassembly under `keyboard/disassembly/`,
mirroring the structure already established in
`ampex-d175-terminal/disassembly/` for the main-board ROMs.

1. Disassemble `U2-D2716.bin` as **MCS-48** (8039) at origin `0x0000`.
   Reset = `0x0000`, external IRQ = `0x0003`, timer/counter IRQ = `0x0007`.
2. Validate boot path: byte 0 should decode to a sensible reset sequence.
   (Current: `15 24 00` = `DIS I` ; `JMP 0x100` — checks out.)
3. Walk the call/jump graph; label:
   - the reset/init block,
   - the timer ISR (autorepeat / scan tick),
   - the external-IRQ handler (most likely "byte ready from GI U1"),
   - the serial-output routine,
   - the function-key (HELP / PROG A / PROG B / SETUP combo) handlers.
4. Identify lookup tables. The tail of the ROM (`0x6C0-0x7E0`) contains
   obvious printable-ASCII runs — keymap tables for unshifted / shifted /
   control / shifted-control planes. Reconstruct each table byte-for-byte
   into `xlate_tables.txt`-style files, matching the existing project pattern.
5. Cross-reference any handshake bytes the firmware emits against the cable
   captures from Phase 1.

**Deliverables (mirrors main-board layout):**

```
keyboard/disassembly/
  README.md            — load address, regen instructions, file inventory
  Makefile             — regenerates U2.asm + strings from the .bin + .sym
  U2.asm               — generated MCS-48 listing
  U2.sym               — hand-curated labels (the editable artifact)
  strings_U2.txt       — printable-ASCII runs (regenerable)
  checksums.txt        — sha256 of U2-D2716.bin
  keymap_tables.md     — reconstructed unshifted/shifted/ctrl tables
  protocol.md          — keyboard↔host protocol once Phase 1 captures land
```

### Phase 3 — Identify the GI U1 chip

The custom GI marking blocks straightforward datasheet lookup. Three
non-destructive tactics:

1. **Pinout fingerprint:** with the strip schematic in hand, compare U1's pin
   roles (Vcc/GND, oscillator, sense lines, output strobes) against:
   - GI AY-5-3600 / AY-5-3600-PRO keyboard encoder,
   - GI AY-5-2376 keyboard encoder,
   - GI 6500-series MCU (possible — GI second-sourced 6502 cores in custom
     packages),
   - common 8048/8049 second-source pinout.
   The 40-pin DIP + position next to a capacitive matrix strongly favours
   the AY-5-3600-PRO family.
2. **Behavioural probe:** wiggle the cable, watch what U1 outputs to U2's
   8039 with the analyzer. If a clean serial nibble/byte stream appears on
   keypress, this is an encoder; if you see a continuous matrix scan with no
   keypress filtering, this is a raw scanner.
3. **Worst case** — if it really is a custom-mask GI MCU we cannot identify
   without die-shot work, document the pin behaviour in `U1_blackbox.md` and
   model it as a black-box encoder. The 8039 firmware will still be fully
   intelligible; we will simply describe U1 by its observed protocol.

**Deliverable:** `keyboard/U1_identification.md`.

### Phase 4 — Functional model + emulator hooks (optional)

Once the protocol is documented, integrate with the existing
`serial_games` / `trs80-serial` infrastructure so the keyboard can be:

- exercised standalone against a host emulator,
- used as a generic serial keyboard by other projects in this repo.

Out of scope for the initial pass — listed here so the deliverables in
phases 1-3 are structured to make this straightforward later.

---

## 3. Tooling

| Tool | Purpose | Status |
|---|---|---|
| Python 3 | MCS-48 disassembler (`tools/mcs48dasm.py`) | Custom, in this repo. |
| `extract_strings.py` | Already in `ampex-d175-terminal/tools/` — reused. | Existing. |
| GNU make | Drives regen | Existing. |
| Pico Logic Analyzer + `clcapture` | Phase 1 signal capture | Existing in repo. |
| Multimeter / continuity tester | Phase 1 net tracing | Bench. |

We deliberately do **not** depend on MAME's `unidasm` or Macro Assembler AS
here: neither ships in the Ubuntu repos as a usable MCS-48 toolchain, and the
ROM is small enough that a focused 8039 disassembler in this repo is cheaper
than building either from source. The disassembler emits z80dasm-style output
(label-overlay via a `.sym` file, addresses, hex bytes, mnemonic) so the
listing format matches the existing `disassembly/U*.asm` files.

---

## 4. Risks / open questions

- **GI U1 unidentified.** Single biggest unknown. Phase 3 addresses it but
  may not fully resolve without bench probing.
- **Keyswitch type unconfirmed.** Photos *strongly* suggest foam-and-foil
  capacitive (matches the era and the spring+plunger geometry, and explains
  the GI front-end). Worth confirming with a scope on one sense line.
- **Serial line direction.** The 7437 buffer suggests at least one
  high-current open-collector driver — typically the keyboard→host line.
  Whether the host can talk back (for click / LED / autorepeat config) is
  unknown until Phase 1.
- **Boot timing.** The 11 MHz `INS8039N-11` runs the standard MCS-48 at
  ~458 kHz machine cycle. Anything in the disassembly that looks like a tight
  bit-bang loop should be checked against this number for plausibility.

---

## 5. Where the artifacts live

```
ampex-d175-terminal/
  keyboard/
    REVERSE_ENGINEERING_PLAN.md   ← this file
    U2-D2716.bin                  ← ROM dump (input)
    *.jpg                         ← photos (input)
    SCHEMATIC.md                  ← Phase 1 output
    U1_identification.md          ← Phase 3 output
    disassembly/
      README.md
      Makefile
      U2.asm                      ← generated
      U2.sym                      ← hand-edited labels
      strings_U2.txt              ← generated
      checksums.txt
      keymap_tables.md
      protocol.md
  tools/
    mcs48dasm.py                  ← MCS-48 disassembler used by the Makefile
```
