# Ampex D-175 Memory & I/O Map

Derived from the disassembly. Uses only what the code actually reads or writes;
nothing is copied from `../agents.md` without independent confirmation.

## 1. Code ROM

| Range | Device | Size | Role |
|---|---|---|---|
| `0x0000..0x1FFF` | U4 (TMS2764) | 8 KB | Boot ROM, reset/RST/NMI vectors, lead-in detector, emulation-loader, base translation tables, status-line vocabulary, baud-rate + SET-UP string pool. |
| `0x2000..0x3FFF` | U5 (TMS2764) | 8 KB | Main firmware entry (0x243D). TV950 base translation table at 0x2014. Quick-SET-UP banner at 0x23DF. |
| `0x4000..0x4FFF` | U6 (AM2732) | 4 KB | SET-UP menu driver, ESC state machine (0x4A10), translation-table lookup (0x4A37), full SET-UP menu text (0x4A9F), version string `AMPEX D175 TERMINAL V 3.5` (0x4F00). |
| `0x5000..0xAFFF` | — | — | Unused / RAM window. |
| `0xB000..0xBFFF` | U8 (AM2732) | 4 KB | Star Technologies overlay. Entry JR at 0xB000 → 0xB030. Eight-slot JP table at 0xB009. Splash `Version No. 63.3 ... Copyright (C) 1983 Star Technologies, Inc.` at 0xB6E5. |

## 2. RAM — control-plane slots observed in the code

Addresses marked ★ are central to the ESC-sequence subsystem and are
described more fully in `emulation_codes.md`.

| Address | Width | Role |
|---|---|---|
| `0xA800..0xA8FF` | 256 B | ★ Processed-input / local-echo ring. Producers: `U4:sub_17B6` (data chars) and `U4:sub_13AF` (ESC sequences — command letter has bit 7 set). Consumer: `U4:sub_159C` via `RST 28h`. Drainer `U4:l1319` expands bit-7 entries into `<lead-in><letter>` and pushes them to the UART TX queue at `0xA900`. |
| `0xA900..0xA91F` | 32 B | UART transmit queue. Written by `U4:sub_1540` (enqueue); drained to I/O `0x8000` by the TX-ready loop. |
| `0xA930..0xA93F` | 16 B | UART receive queue. RST 38h ISR enqueues incoming bytes; `U4:sub_17F7` (called from `sub_17CF`) dequeues. |
| `0xA944` | 1 B | ★ 0xA800 ring TAIL (producer write-position). Incremented at `U4:0x13B5` and `U4:0x17C2`. |
| `0xA945` | 1 B | ★ 0xA800 ring HEAD (consumer read-position). Incremented at `U4:0x15B9` inside `sub_159C`. |
| `0xA946` | 1 B | 0xA900 TX-queue tail. Incremented at `U4:0x154E` inside `sub_1540`. |
| `0xA948`, `0xA949` | 2 B | UART receive queue pointers (pair with `0xA930`). |
| `0xA94A`, `0xA94B` | 2 B | Keyboard queue pointers (pair with a key-queue I/O buffer at `0xA930+` as well — note pointer reuse in `sub_17F7`). |
| `0xA94C..0xA951` | 6 B | ★ ESC-sequence parameter stash (up to 5 bytes + the command). |
| `0xA983..0xAA22` | 160 B | ★ ESC-command translation table (indexed by command byte 0x00..0x9F). Reloaded on emulation change by `U4:0x0381`. |
| `0xAA23` | 1 B | ★ Current ESC input byte (command, then each successive param). |
| `0xAA25` | 1 B | ★ ESC state counter (0 = idle, 0xFF = expect-command, 1..5 = collect-params). |
| `0xAA26` | 1 B | ★ Saved arity (total bytes in the active ESC sequence). |
| `0xAA29` | 1 B | Terminal mode-flags byte — 63 references across all ROMs. Bit 5 gates lead-in interpretation; bits 0/2/3 gate lead-in detection. |
| `0xAA2A` | 1 B | Secondary mode flags (e.g. local/online). |
| `0xAA2B` | 1 B | Third mode flags. `ld (0AA2Bh), hl` at `U4:0x04FD` writes a 16-bit bitmask built from the SET-UP byte. |
| `0xAA8A..0xAA8C` | 3 B | Printer / comms state bits (bit 7 = busy, etc. — see `U4:0x13D5`). |
| `0xAA99` | 1 B | ★ Current lead-in byte (0x1B or 0x7E). Seeded from `0xAAB9` bit 7 at `U4:0x058E`. |
| `0xAAB9` | 1 B | SET-UP flags: bit 7 = TILDE lead-in mode; bit 6 = lock?; bits 0..1 = printer config; bit 2 referenced at `U4:0x051B`. |
| `0xAABB` | 1 B | ★ Primary SET-UP byte. Low nibble = active emulation (0..10). Upper nibble = 16-state CRTC-config selector; `U4:sub_05CB` rotates it right 3 bits, indexes a 32-byte CRTC-register table at `U4:0x029C`, and emits two `OUTI` writes. Preserved across emulation changes (`U4:0x1980`). Likely printer-baud-rate / display-timing. |
| `0xAC03, 0xAC07` | 2 × 2 B | Scratch slots consumed by the block-copy primitive at `U6:0x400A` (destination & length, caller-seeded). |
| `0xAB2C` | 1 B | Mode toggle byte (`XOR 0xFF` at `U4:0x19CB`, AMPEX `ESC O`-family). |
| `0xABD0` | 1 B | **Ampex display-mode register**. Bits 0..3 toggled by `ESC j/k/l/m/n/o/p/q` (8 handlers at `U4:0x1C73..0x1CAE`). Bit 4 set by `ESC )` line-insert path. |
| `0xABD2` | 1 B | Flag set by AMPEX `ESC O` (`U4:0x19B0`). |
| `0xABD3` | 1 B | Mode byte, gated by `0xABDD` — written by multiple ESC-pair handlers at `0x1B0D/0x1B20`, `0x1A2D/0x1B1B`, `0x1BDF/0x1BE3`. |
| `0xABD7` | 2 B | **Cursor column** (byte) / combined (row, col) when accessed as word. |
| `0xABD8` | 1 B | **Cursor row**. |
| `0xABDD` | 1 B | Gate flag for the `0xABD3` pairs — when non-zero, those pair handlers no-op. |
| `0xABF7` | 1 B | Scroll/page mode-flag (written by `U4:0x19E4`, read in display loop). |
| `0xAC18` | 1 B | Tab / mode state register with its own 4-bit set/clear cluster at `U5:0x2934..0x2955`. |
| `0xAC19` | 1 B | Attribute selector from `ESC G <hex>` (hex-digit indexed into table at `U5:0x2EE2`). |
| `0xAC28` | 1 B | Default fill character used by erase handlers. |
| `0xAC3B` | 1 B | UART control-register shadow. `ld a,(0AC3Bh) ; ld (0x8001), a` pattern appears multiple times. |
| `0xAC45` | 2 B | A monotonic counter (inc/cmp at `U4:0x00A5`). |
| `0xAC47` | 1 B | Mode selector byte tested at `U4:0x0072`. |
| `0xAD61..0xAD65` | ~5 B | Edit / buffer-cursor pointer used by the character renderer (`U5:0x250F`). `0xAD61` gates translation (`U6:0x4A22`). |
| `0xAE1E` | — | ★ Stack top. `ld sp, 0AE1Eh` at `main_entry` (`U5:0x243E`). |

RAM is physically provided by TMM2016P + MB8128-15 chips on the PCB. The code
treats 0xA000–0xAFFF as read/write, with the control-plane concentrated in
the 0xA9xx–0xACxx range. Whether 0xAD–0xAE is covered by the same RAM chip
or a separate buffer has not been confirmed from the code — it is treated as
RAM either way.

## 3. I/O (memory-mapped)

Z80 `IN`/`OUT` is **not** used for these peripherals. The 8251 UARTs, CRTC
and related registers are reached via ordinary `LD (nn), A` / `LD A, (nn)`.

| Address | Peripheral | Evidence |
|---|---|---|
| `0x8000` | PRIMARY 8251 — data port. | Write at `U4:0x13ED` (`ld (0x8000), a`) inside the "echo char" path after the TX-ready poll. |
| `0x8001` | PRIMARY 8251 — command/status. | RST 38h handler starts `ld a, (0x8001)` at `U4:0x003C`. Also `ld (0x8001), a` at `U4:0x05C0`, `0x054E` etc. (mode writes). Bit 0 = TX-ready (polled at `U4:0x13E5` before writing data). |
| `0x6006` | CRTC cursor-register pair? | `ld (0x6006), hl` at `U5:0x251B`, `U5:0x2551`. 16-bit write, consistent with a cursor-position register on the SCN2672. |
| `0xC000` | Video RAM? | `ld a, (0xC000)` at `U5:0x2557` inside the text-rendering loop. Range and size not independently verified. |
| `0xF000` | NVRAM / battery-backed CMOS? | `ld (0xF000), a` at `U4:0x0607` right after a SET-UP flag update — consistent with writing through to the MB8128 + battery backup region. |

Ports for the second UART (printer), the Z80 CTC, and the CRTC's register
file have not yet been isolated in this pass. Candidate regions to sweep
next time: the other three quadrants of the `0x8000..0x8FFF` window and any
remaining `ld (nn),a` immediates with `nn >= 0x8000` that haven't been
accounted for above.

## 3a. ESC command dispatch chain (resolved)

```
  ring byte with bit 7 set
           │
           ▼
   U6:sub_4981 (display dispatcher)
           │  ram_mode_flags & 0x20 selects command path
           ▼
   U6:l49dd → jp U4:0x0AAF (master_dispatcher)
           │  strips bit 7 → cmd
           │  looks up RAM[0xA983 + cmd] → handler index
           │  2×index into U5:0x20AA → handler address
           ▼
         JP (HL) → concrete action routine in U4/U5/U6
           │  reads any remaining parameter bytes via RST 28h
           ▼
   updates cursor / screen / mode state
```

Translation table `0xA983` is per-emulation (loaded by `U4:0x0381`);
master jump table `U5:0x20AA` is fixed and shared across all emulations.
Handler index values `0..0x83` resolve via the jump table; several
indices route to `U5:0x2798` (a single `RET`) — those are declared no-ops.

Verified by tracing VT52 `ESC Y` row col: translation table
`[0x59] = 0x0C` → jump table `[0x0C] = 0x3523` → `U5:0x3523` reads two
bytes via the ring and writes `(B, C)` to `0xABD7` as the new cursor
position, then jumps to the cursor-apply routine.

## 4. Cross-ROM call map (observed)

| Caller | Callee | Notes |
|---|---|---|
| `U4:0x000B` (cold-start `JP`) | `U5:0x243D` (`main_entry`) | Boot hand-off after CPU init. |
| `U4:0x1891` | `U6:0x4A10` (`esc_state_machine`) | Entered on every received byte once lead-in has been matched. |
| `U4:0x17EB` | `U8:0xB00F` (Star overlay 8-bit gate) | Every input byte `>= 0x80` is routed to the Star overlay's 8-bit command validator at `U8:0xB521`. |
| `U5:0x2456` | `U8:0xB01E` (Star overlay jump-slot) | Star overlay hook from main loop at entry + 25 bytes. |
| `U6:0x4A83, 0x4A96` | `U4:0x13AF` (`sub_13AF`) | ESC state machine's replay loop enqueues each sequence byte (command with bit 7 set, then parameters) to the 0xA800 ring. |
| `U6:0x499F` (`l49dd`) | `U4:0x0AAF` (`master_dispatcher`) | Display dispatcher routes bit-7-flagged bytes to the master dispatcher, which resolves `tbl[cmd]` → master jump table at `U5:0x20AA` → concrete action handler. |
| `U4:0x0AC6` (`JP (HL)`) | `U4/U5/U6:<various>` | Tail-call dispatch. Target is one of 132 entries in `U5:0x20AA..0x21B1`; `U5:0x2798` is the universal no-op. |

## 5. RST syscall table

The Z80 RST instructions are used as compact entry points into runtime
primitives. Reserved targets fall at `0x0000`, `0x0008`, `0x0010`, etc.;
all resolve in U4.

| RST | Target | Behavior |
|---|---|---|
| `RST 00h` | `U4:0x0000` | Cold reset: `DI ; IM 1 ; LD IX,3030h ; LD DE,3030h ; XOR A ; JP U5:0x243D`. |
| `RST 08h` | `U4:0x0008` | Unconfirmed — bytes decode as `30 30 30 30 30 30 30 30` (pad); probably unused. |
| `RST 10h` | `U4:0x0010` | `PUSH HL ; CALL sub_1768h ; POP HL ; RET`. `sub_1768h` waits for CRTC ready, then writes `DE` to video RAM `0xC000` / attribute RAM `0xD000`. **"Emit char + attribute to screen at current cursor position."** |
| `RST 18h` | `U4:0x0018` | `JP sub_1552h`. Triggers a "reset XOFF" flag-update path. |
| `RST 20h` | `U4:0x0020` | `PUSH BC ; CALL sub_1592h ; POP BC ; RET`. `sub_1592h` masks (0xAA2B) 16-bit flags against `HL`. Used for feature-flag tests. |
| `RST 28h` | `U4:0x0028` | `PUSH BC ; CALL sub_159Ch ; POP BC ; RET`. **"Pull next byte from 0xA800 ring."** Blocks until a byte is available; returns with byte in `A`. |
| `RST 30h` | `U4:0x0030` | `JP l0117h`. (Behavior not decoded in this pass.) |
| `RST 38h` | `U4:0x0038` | Maskable-interrupt handler (IM 1). Saves registers, reads UART status at `0x8001`, enqueues received byte into 0xA930 ring via `sub_1387h`. |
