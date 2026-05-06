# Ampex D-175 Keyboard EPROM Disassembly

MCS-48 (8039) disassembly of `../U2-D2716.bin` — the program ROM that runs on
the keyboard's INS8039N-11 microcontroller. See `../REVERSE_ENGINEERING_PLAN.md`
for the broader plan.

## Regenerating

```sh
# Tool: tools/mcs48dasm.py (in this repo). Python 3 + GNU make required.
make clean && make
```

`U2.asm` is generated; hand edits belong in `U2.sym` (label overlay).

## File inventory

| File | Purpose |
|---|---|
| `Makefile` | Regenerates `U2.asm` and `strings_U2.txt` |
| `checksums.txt` | SHA-256 of `../U2-D2716.bin` |
| `U2.asm` | mcs48dasm listing (regenerable) |
| `U2.sym` | Curated labels (the editable artifact) |
| `strings_U2.txt` | Printable-ASCII runs with offset/load address |
| `keymap_tables.md` | (TBD, Phase 2) Reconstructed keymap planes |
| `protocol.md` | (TBD, Phase 1) Keyboard ↔ host serial framing |

## Load address (Phase 1 verified — initial pass)

| ROM | File | Origin | Evidence |
|---|---|---|---|
| U2 | `U2-D2716.bin` (2 KB) | `0x0000` | The 8039 has no internal program memory, so external ROM must answer at $0000. The byte at offset 0 decodes to `DIS I ; JMP $0100`, a standard MCS-48 reset sequence. The byte at $0007 (timer-ISR vector) decodes to `SEL RB0 ; MOV R1,#$4C ; ...`, plausible ISR entry. |

## CPU summary (orientation for readers)

- Intel **MCS-48** instruction set; the chip is a National Semi
  **INS8039N-11** (ROM-less 8049-compatible) clocked at 11 MHz.
- 12-bit program counter, but the 2 KB ROM only fills bank 0 (`$000-$7FF`).
  No `SEL MB1` is expected; if the disassembly shows one, that's a flag.
- Reset vector: `$0000`. External-IRQ vector: `$0003`. Timer/CNT IRQ: `$0007`.
- Internal RAM, register banks: two banks switched by `SEL RB0/RB1`. The
  firmware uses plain `MOV @R0,A` to addresses up to `$7F` (the boot path
  clears `$01-$7F` in a `DJNZ R0` loop at `$0109`). That requires **128
  bytes** of internal RAM, which is 8049-class — so this part is almost
  certainly NSC's 128-byte INS8039 variant (sold ROM-less but pin- and
  RAM-compatible with the 8049), not the Intel 64-byte 8039. Worth
  confirming against the actual NSC datasheet for `INS8039N-11` in Phase 1.
- External data memory: only **two MOVX instructions** in the entire ROM,
  back-to-back at `$00EE` (`MOVX @R0,A`) and `$00EF` (`MOVX A,@R0`). This
  is a single write-then-read of *one* external bus location — exactly the
  shape of a host-side latched register on the GI U1 keyboard-scanner chip
  (write a command, read the resulting data). See the `XBUS_PORT` label in
  `U2.sym` and Phase 2/3 of the plan.
- No `SEL MB1` appears anywhere — execution stays in bank 0, matching the
  2 KB ROM size.
- Ports: `BUS` (P00-P07, multiplexed with low address), `P1` (8 bits),
  `P2` (low nibble = upper address bits A8-A11; upper nibble = GP I/O).

## What the boot path tells us so far

```
$0000  DIS  I            ; reset entry
$0001  JMP  $0100        ; -> MAIN_INIT
$0003  DIS  I            ; ext IRQ (currently only DIS I + RETR — unused?)
$0007  SEL  RB0          ; timer ISR; saves nothing, switches to bank 0
$0008  MOV  R1,#$4C ...  ; uses RAM byte $4C as a state variable
```

The ISR clearly drives a periodic scan / autorepeat tick. The reset path
falls into the main loop at `$0100`, which begins with `DIS TCNTI ; CLR A ;
MOV PSW,A ; ...` (standard cold-init). Detailed labelling of these blocks is
the next pass — see `../REVERSE_ENGINEERING_PLAN.md` Phase 2.

## Notable string anchors (from `strings_U2.txt`)

The ROM's tail ($06C0-$07F0) is dominated by **keymap translation tables**.
A few are easy to spot in raw form:

| Offset | Excerpt | Likely role |
|---|---|---|
| `$034B` | `xcvbn` | bottom QWERTY row (unshifted plane) |
| `$0353` | `sdfgh` | middle QWERTY row (unshifted plane) |
| `$03B3` | `XCVBN` | bottom row (shifted plane) |
| `$03BB` | `SDFGH` | middle row (shifted plane) |
| `$0475` | `0[_-~M%./+7wyWY3!\\@,;:qaz&{"'(]}89?QAZ12456+*` | scan-order plane |
| `$063B` | `` `~-[;'/)_+={:"<>?&zyZY#890m,.aqw1234567*(MAQW!@$%^ `` | another full plane |
| `$071A` | `\|]}@\`:^;[/_*=-~+{<>?'zyZY#890m,.aqw1234567()MAQW!"$%&` | another full plane |

Reconstructing each table byte-for-byte (and naming them in `U2.sym`) is the
Phase 2 deliverable for `keymap_tables.md`.
