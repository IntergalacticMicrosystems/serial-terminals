In these folders are photos and EPROM dumps from an Ampex / Star Technologies terminal.

This file is the **hardware / outer-context reference** (PCB chips, on-screen
UI, file inventory, outgoing-ESC literals). For all firmware analysis —
load addresses, memory/RAM/I-O map, RST syscalls, ESC dispatch chain,
per-emulation translation tables, handler catalogue — see the
regenerable `disassembly/` tree. `disassembly/README.md` is the index.

## MAME Source Code
- mame source code is in `/root/mame-amdex/mame`

## Model info (from Model_info/phototempPXL_20250728_163912291.jpg)
- Manufacturer: AMPEX ATL
- Model: D-175 SP
- P/N: 3513000-06
- Rev: A

## Main PCB (from PCB_photos/left.jpg and right.jpg)

Board assembly: AMPEX **3512050-02 REV E**, date code 8350 (1983, week 50).

### CPU / system
- **Z80A CPU** — SGS Z8400AB1, 2B323-ITALY (designator A1)
- **Z80A CTC** — SGS Z8430AB1, 2B332-ITALY (U3)
- **8251A USART** × 2 — AMD P8251A, 8325EM (U1, U2)
- **CRTC** — Signetics SCN2672 (partial read, 8338 date code) — video display controller
- Crystal oscillator (silver can near U area, exact frequency not readable)
- Coin-cell battery + "NEL FLECQ RTC" area (battery-backed RTC/NVRAM)

### Memory
- **Toshiba TMM2016P** (2K × 8 SRAM) — multiple, 8335AEA date code
- **Fujitsu MB8128-15** (2K × 8 SRAM, 150 ns) — 8337 C03 RA
- **NEC μPD444C-1** (1K × 4 CMOS SRAM) — 8329X (U19), likely battery-backed
- Several empty 28-pin sockets (U10, U11, U23, U27) — optional RAM/ROM expansion

### Ampex-custom ROMs (UV-window ceramic EPROMs)
Four visible, all labeled "© 1983 AMPEX CORP", hand-dated "3/31/05 p1" or "3/30/05 p1" (likely reprogram dates). Approximate locations: U52, plus three more along the right-edge ROM column.

### TTL logic (identified markings)
Mix of TI SN74LS*, National DM74LS*, mostly MALAYSIA / INDONESIA assembly, 1983–1985 date codes:

- **74LS08** — DM74LS08N (U56, plus others)
- **74LS04** — DM74LS04N (U29)
- **74S04** — SN74S04N
- **74S05** — DM74S05N (U10)
- **74LS32** — SN74LS32N (U53 and others)
- **74LS86** — SN74LS86N (U28, U57)
- **74LS138** — SN74LS138N (U54)
- **74LS174** — DM74LS174N / SN74LS174N (U34, U38, U39, U40)
- **74LS257** — 74LS257N PC (U18, U35, U36)
- **74LS374** — SN74LS374N (U19, U20)
- **74LS17x** — DM74LS17xN (U58, etc.)
- **74LS537** — SN74LS537N (U20-area, MALAYSIA 332B)

### Interface / line drivers
- **LM556CN** (SM8327) — dual timer
- **MC1488 / MC1489** RS-232 line driver / receiver (partial reads; expected given two 8251 UARTs and the KYBD / PRIMARY / PRINTER DB-25 ports)

### Connectors
- Two DB-25 ports on rear apron (PRIMARY + PRINTER)
- Modular RJ-style jack (KYBD)
- 10-pin header (display / video cable)

### Notes on readability
- Several chips on the left half of `left.jpg` are mounted rotated 180°, so markings appear mirrored in the crops.
- The crystal's frequency, exact SCN2672 speed grade, and the Ampex ROM part numbers (beyond the copyright line) were not legible at this resolution — a straight-on close-up of each would be needed to confirm.

## Screens (from Screen_photos/)

### `start.jpg` — power-on splash
Large asterisk-art logo (likely "STAR" text), followed by:
```
Version No. 63.3
Copyright (C) 1983
Star Technologies, Inc.
```
(Bezel badge on the unit also reads "STAR TECHNOLOGIES" — the Ampex D-175 SP appears to have been rebadged/OEM'd by Star Technologies. Firmware copyright is 1983.)

### `status_bar.jpg` — idle status line (top of screen, yellow bar)
```
D175   US   TIME:00-02          ATB:          MODE:FDX          1-01-01
```
Fields (left-to-right): model indicator `D175`, keyboard/nat-char set `US`, `TIME:HH-MM` clock (reading `00-02`), `ATB:` (answerback?), communication `MODE:FDX` (full duplex), and page/row/col position `1-01-01`.

### `setup_menu.jpg` — SET-UP MENU (entered by dedicated key)
Header lines:
```
...HOME TO EXIT, CTRL/S TO SAVE AND EXIT, AND A-V TO CHANGE :B
                    SET-UP MENU                COPYRIGHT 1983
                                                AMPEX CORP
```
Parameters (current selection shown in reverse video, markedtest
 here in **bold**):

| ID | Parameter               | Options (current in **bold**)                                                                   |
|----|-------------------------|--------------------------------------------------------------------------------------------------|
| A  | CURSOR                  | FLASH-BLK · **BLK** · FLASH-UL · UL · OFF                                                        |
| B  | STATUS                  | **(on)** · DISP-ON-ERR · OFF                                                                     |
| C  | AUTO NEW LINE           | **Y** · N                                                                                         |
| D  | LINE FREQ               | **60** · 50                                                                                       |
| E  | CRT SAVER               | **Y** · N                                                                                         |
| F  | XON/XOFF                | ON · **OFF**                                                                                      |
| G  | PARITY                  | **OFF** · ODD · EVEN                                                                              |
| H  | STOP BIT                | **1** · 2                                                                                         |
| I  | BIT/CHAR                | **8** · 7                                                                                         |
| J  | TAB SAVE                | **Y** · N                                                                                         |
| K  | LEAD-IN CODE            | **ESC** · TILDE                                                                                   |
| L  | FUNC KEY                | **ESC-CODE** · ESC-CODE-CR · STX-CODE · STX-CODE-CR                                               |
| M  | XMIT ESC SEQ FOR CLEAR KEY | Y · **N**                                                                                     |
| N  | U/C WHEN POWER UP       | **Y** · N                                                                                         |
| O  | KEYBD LOCK WHEN PRINT   | Y · **N**                                                                                         |
| P  | AUTO LF ON CR           | **N** · Y                                                                                         |
| Q  | NAT CHAR                | **US** · UK · FRE · GER · SWD · NRW · SPN · ITL · GRA                                             |
| R  | EMULATION               | **AMPEX** · IQ120 · REG25 · ADM5 · VIEWP · VT52 · TV920 · TV950 · H1500 · H1410 · H142x           |
| S  | 8TH BIT OF PRIMARY      | **0** · 1                                                                                         |
| T  | 8TH BIT OF PRINTER      | **0** · 1                                                                                         |
| U  | EOM CODE                | NO-CODE · ETX · EOT · **CR**                                                                      |
| V  | PRINTER BAUD RATE       | **9600**                                                                                          |

Emulation list confirms this is a multi-personality terminal with Ampex-native plus Soroc IQ120, Regent 25, Lear-Siegler ADM-5, ADDS Viewpoint, DEC VT52, TeleVideo 920/950, and Hazeltine 1500/1410/142x modes.

### `ctrl-home_menu.jpg` — Ctrl+Home pop-up menu (yellow bar at top)
```
1=FDX   2=CLICK   3=BELL-OFF   4=NOR   5=JUMP   6=9600   7=RESET   8=MENU   9=DUPE
```
Quick toggles: duplex, key click, bell, attribute mode (normal/reverse?), smooth/jump scroll, baud rate, reset, enter SET-UP, and duplicate (send-to-printer?).

## EPROM dumps (from EPROM_dumps/)

Total firmware: **28 KB** across five EPROMs.

| File | Device | Size | Role |
|------|--------|------|------|
| `U4-TMS2764JL.bin`  | TI TMS2764  | 8 KB | **Z80 firmware — boot / primary code** |
| `U5-TMS2764JL.bin`  | TI TMS2764  | 8 KB | **Z80 firmware — main body / emulation parser** |
| `U6-AM2732-1DC.bin` | AMD Am2732  | 4 KB | **Z80 code + SET-UP menu text** |
| `U8-AM2732-1DC.bin` | AMD Am2732  | 4 KB | **Z80 code — splash / Star Technologies overlay** |
| `U52-AM2732-1DC.bin`| AMD Am2732  | 4 KB | **Character-generator ROM** (bitmap fonts) |

### Per-ROM analysis — **superseded by `disassembly/`**

Detailed structure, load-address evidence, entry points, string anchors, and
the full annotated memory/RAM/I-O map now live in the `disassembly/` tree.
The content that used to be here was folded into:

- `disassembly/load_address_verification.md` — cold-start vector, ground-truth
  string matches confirming U4 @ `0x0000`, U5 @ `0x2000`, U6 @ `0x4000`,
  U8 @ `0xB000`.
- `disassembly/memory_map.md` — ROM map, RAM control-plane slots
  (0xA800 local ring, 0xA900 TX queue, 0xA930 RX queue, 0xA983 xlate table,
  0xAA23/25/26/29/99, 0xAAB9, 0xAABB, 0xAC18, 0xAC28, 0xABD0, etc.),
  memory-mapped I/O (0x8000/0x8001 UART, 0x6006 CRTC, 0xC000 video,
  0xD000 attr, 0xF000 NVRAM), cross-ROM call map, RST syscall table, and
  the full ESC command dispatch chain.
- `disassembly/strings_U{4,5,6,8}.txt` — string anchors with offsets.
- `disassembly/README.md` — how to regenerate the listings.

### U52 — character generator ROM (out of scope for disassembly/)
- 4 KB, entropy **3.55 b/B** (very low), only **91 unique byte values**;
  48 % of bytes are `0x00`, rest dominated by bitmap-like values (`0x0E`,
  `0xF0`, `0xFE`, `0x08`, etc.).
- Exactly 4096 bytes = **256 characters × 16 scanlines** — the standard
  layout for an SCN2672-driven font.
- Verified as bitmap data: the ASCII-printable string extract shows
  obvious glyph patterns, e.g. the sequence `(DDD|DDD`
  (bytes `28 44 44 44 7C 44 44 44`) renders as a capital "A"-like shape
  when plotted.
- Single font — no duplicated copy visible, so the alternate-font features
  (inverse/underline/flash) are likely done by attribute bits on the CRTC
  side, not by a second font bank.

### What's NOT in these dumps
- A separate "terminal-translation" ROM isn't present on the board — the
  per-emulation dispatch is a **RAM-resident 160-byte table at `0xA983`**,
  rebuilt from ROM-resident base tables + patch records on every
  emulation change. See `disassembly/emulation_codes.md` §2 for the
  full mechanism.
- **No keyboard scancode table ROM** visible in these dumps — that lookup
  is embedded in U4/U5. A separate dump `keyboard/U2-D2716.bin` exists
  but was explicitly out of scope for the current disassembly pass.

## Supported incoming ESC sequences — **superseded by `disassembly/`**

> **Warning.** The tables that used to live here were built by hand from
> early disassembly notes and contain errors — including several commands
> flagged as "ignored" in VT52 mode that are in fact implemented
> (`ESC A`, `ESC D`, `ESC H`, `ESC Z`), and several Ampex-vs-VT52 handler
> addresses that were swapped. Do not rebuild the tables from this file.

The authoritative, code-derived reference lives under `disassembly/`:

- `disassembly/emulation_codes.md` — full dispatch architecture
  (lead-in detection, state machine, per-emulation RAM translation table,
  master jump table, 8-bit command convention), plus the VT52 case study
  with the handler addresses that SerialTetris validates against.
- `disassembly/handlers.md` — semantic catalogue of ~110 of 132 master
  jump-table slots with their concrete roles (cursor motion, cursor
  address, erase variants, attribute pairs, Ampex display-mode toggles,
  tab toggles, mode-bit pairs, CPP reporting, ESC M sub-dispatch, etc.).
- `disassembly/resolved_handlers.txt` — per-emulation `(command letter →
  arity, handler index, handler address, ROM)` mapping for all 11
  emulations. Regenerated by `tools/resolve_handlers.py`.
- `disassembly/handler_jump_table.txt` — the 132 entries of the master
  jump table at `U5:0x20AA`. Regenerated by `tools/dump_handler_table.py`.
- `disassembly/xlate_tables.txt` — raw byte-level contents of the 11
  reconstructed translation tables. Regenerated by
  `tools/dump_xlate_tables.py`.
- `disassembly/patch_records.txt` — every per-emulation patch record
  with addresses and command-byte cross-references. Regenerated by
  `tools/dump_patch_records.py`.

The "this command is not implemented in this mode" verdict is defined as
`handler == U5:0x2798` (a single `RET`) or `handler == U4:0x19A6` (also
a single `RET`). See `disassembly/handlers.md` §"Universal no-ops".

### Outgoing ESC sequences (what the D-175 transmits)

Literals found in U4/U5/U8. Without full context these are labels only; identifying exact function-key / answerback bindings would require more tracing.

| ROM @ offset | Hex | Printable |
|--------------|-----|-----------|
| U4 @ 0x0335 | `1B 4F` | `ESC O` |
| U4 @ 0x0598 | `1B 32` | `ESC 2` |
| U4 @ 0x0B03 | `1B 21 5E` | `ESC ! ^` |
| U4 @ 0x1879 | `1B 79 21` | `ESC y !` |
| U5 @ 0x014D | `1B 59 2F` | `ESC Y /` |
| U5 @ 0x0153 | `1B 20` | `ESC SP` |
| U5 @ 0x0155 | `1B 24` | `ESC $` |
| U5 @ 0x0157 | `1B 44` | `ESC D` |
| U5 @ 0x015F | `1B 34 29 3D 29 41 29 45 29` | `ESC 4 ) = ) A ) E )` |
| U5 @ 0x016D | `1B 42` | `ESC B` |
| U5 @ 0x016F | `1B 72` | `ESC r` |
| U5 @ 0x09DE | `1B 27 3A` | `ESC ' :` |
| U5 @ 0x0B2D | `1B 3D` | `ESC =` |
| U5 @ 0x11BF | `1B 45 3E` | `ESC E >` |
| U5 @ 0x13B5 | `1B 45 30` | `ESC E 0` |
| U5 @ 0x156F | `1B 4F 78` | `ESC O x` |
| U5 @ 0x16AC | `1B 3F` | `ESC ?` |
| U5 @ 0x1E81 | `1B 60` | `` ESC ` `` |
| U8 @ 0x0642 | `1B 25 2A 2F 2D 3D 3D 3D` | `ESC % * / - = = =` |
| U8 @ 0x06AC | `1B 73` | `ESC s` |
