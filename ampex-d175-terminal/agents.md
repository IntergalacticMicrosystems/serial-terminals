In these folders are photos and EPROM dumps from an Ampex / Star Technologies terminal.

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

### U4 — boot ROM (Z80)
- First instructions: `F3 ED 56` = `DI ; IM 1` — classic Z80 cold-start, followed by `LD IX,3030h`, `LD DE,3030h`, `XOR A`, `JP 243Dh` (jumps into U5).
- Entropy 7.07 b/B; Z80 opcode histogram (many `CD`/CALL, `3A`/LD A,(nn), `21`/LD HL,nn).
- Embedded strings: the full status-line vocabulary (`TIME:`, `ATB:`, `MODE:`, `PAR OVR FRA DWL`, `XMIT WPT ATB FLP …`), baud-rate list (`50 75 110 134 150 300 600 1200 1800 2400 3600 4800 7200 9600 19.2`), mode words (`HDX FDX LCL`, `BLK CLICK SILENT`, `ON OFF`, `NOR REV`, `LOCE DUPE`), error messages (`BAD COMP:`, `OPER ERR:`, `COMM ERR:`, `ROM DIS`, `RAM DAT`, `RAM CMO`), and the banner `SET-UP MENU / COPYRIGHT 1983 / AMPEX CORP=`.
- Maps at Z80 address **0x0000–0x1FFF**.

### U5 — main firmware / emulation dispatch (Z80)
- 8 KB, entropy 7.06 b/B, highest code density of any ROM (345× `CD`, 110× `C3`, 63× `ED`).
- Contains **14 ESC-lead-in sequences** — this is where the per-emulation escape-sequence parsers live (VT52, TV920/950, ADM5, VIEWPOINT, H1500/1410/1420, IQ120, REG25, plus Ampex native).
- Ctrl+Home quick-toggle string present here: `1=HDX 2=SILENT 3=BELL-OFF 4=NOR 5=SMOOTH 6=9600 7=RESET 8=MENU 9=LOCE` (note: the live screen showed `5=JUMP`, so that field toggles between `JUMP` and `SMOOTH` — both words are in this ROM).
- Maps at Z80 address **0x2000–0x3FFF** (target of U4's JP 243Dh).

### U6 — SET-UP menu text + driver (Z80 code + data)
- Starts `AC 4F 06 00 ED B0` — `LDIR` block-copy, so this ROM contains code that blits its own text tables onto the screen.
- Contains the **exact SET-UP menu text** (parameters A–V, all options, including the `AMPEX · IQ120 · REG25 · ADM5 · VIEWP · VT52 · TV920 · TV950 · H1500 · H1410 · H1420` emulation list — matches `setup_menu.jpg` letter-for-letter).
- Version tag at the end: `AMPEX D175 TERMINAL V 3.5=` (SET-UP ROM revision, separate from the splash-screen version).
- 44× `C3`, 122× `CD` — solidly executable.

### U8 — splash / Star Technologies personality ROM (Z80)
- 45 % full (rest `0xFF`), non-empty region 0x0000–0x0731.
- Starts `18 2E` (JR +0x2E) then a **jump table** of `C3 xx xx` entries targeting addresses in 0xB0xx–0xB6xx — so this ROM is mapped at **0xB000-ish** and exposes a fixed entry-point table, the way an optional overlay/personality ROM would.
- Contains the splash text: ` Version No. 63.3 / Copyright (C) 1983 / Star Technologies, Inc.` — exactly what appears on `start.jpg`.
- The Star Technologies branding only appears in this ROM; the other four are all Ampex-authored. Fits the theory that Star Technologies OEM'd the D-175 from Ampex and added this overlay.

### U52 — character generator ROM
- 4 KB, entropy **3.55 b/B** (very low), only **91 unique byte values**; 48 % of bytes are `0x00`, rest dominated by bitmap-like values (`0x0E`, `0xF0`, `0xFE`, `0x08`, etc.).
- Exactly 4096 bytes = **256 characters × 16 scanlines** — the standard layout for an SCN2672-driven font.
- Verified as bitmap data: the ASCII-printable string extract shows obvious glyph patterns, e.g. the sequence `(DDD|DDD` (bytes `28 44 44 44 7C 44 44 44`) renders as a capital "A"-like shape when plotted.
- Single font — no duplicated copy visible, so the alternate-font features (inverse/underline/flash) are likely done by attribute bits on the CRTC side, not by a second font bank.

### What's NOT in these dumps
- **No dedicated "terminal-translation" ROM.** The per-emulation behavior lives inside U5 as code + inline tables, not as a separate data ROM. If the board supports pluggable emulation ROMs, they'd go into the empty sockets seen on the PCB (U10/U11/U23/U27), not in U52 or U6.
- **No keyboard scancode table ROM** visible — that lookup is also almost certainly embedded in U4/U5.

### Memory-map reconstruction (best guess from reset vectors + jump-table targets)
| Z80 range | Contents |
|-----------|----------|
| 0x0000 – 0x1FFF | **U4** (boot + primary code) |
| 0x2000 – 0x3FFF | **U5** (main firmware / emulation) |
| 0x4000 – 0x4FFF | **U6** (SET-UP driver + text) — provisional; U6 starts with data, so exact base needs confirmation from a disassembly |
| 0xB000 – 0xBFFF | **U8** (splash / Star overlay) |
| (CRTC side) | **U52** (character generator, on the video data path, not in Z80 address space) |

## Supported incoming ESC sequences

Sources:
- **Ampex native mode**: transcribed from *AMPEX 230 plus Operation Manual*, Appendix C (P/N 3515844-01, March 1986) — same Ampex Dialogue command family as the D-175.
- **VT52 mode**: DEC VT52 standard (per Wikipedia's VT52 entry).

Verification status: **verified by disassembly**. The tables below list what's documented in the Ampex manual / VT52 spec, then annotate each with "✓ implemented" or "✗ NOT in firmware" based on which chars route to a real handler (not the `RET` no-op at `0x2798`) in the verified per-mode dispatch table.

### Firmware dispatch architecture (verified)

Each emulation mode uses a **128-byte translation table in RAM** at `0xA983`, built at mode-change time:

1. A baseline is copied from one of three ROM tables in U4:
   - Modes with internal ID 0–6 (AMPEX, IQ120, REG25, ADM5, VIEWP, TV920, VT52): baseline at **`0x1DEE`** (chars 0x20–0x7F) + **`0x1D61`** (chars 0x00–0x1F).
   - Internal ID 7 (H1420): baseline at **`0x2014`** (U5) + **`0x1D61`** (U4).
   - Internal IDs 8–10 (TV950, H1500, H1410): baseline at **`0x1F1E`** + **`0x1DCB`** (U4).
2. Per-mode overrides are then applied from an 11-entry pointer table at **`0x0433`**, each pointer targeting a short `[count, (offset, value)×count]` diff table in the `0x1D80`–`0x1FFE` range.
3. At runtime, the dispatcher at **`0x0ABD`** takes the incoming char, reads `RAM[0xA983 + char]` to get an index, then jumps to `main_dispatch[index]` — a 256-entry address table at **`0x20AA`** in U5.

SET-UP index → internal ID remap (at `0x199B` in U4): `00 01 02 03 04 06 05 08 09 0A 07`. So "VT52" (SET-UP index 5) is internal ID 6 and uses diff table at `0x1EF7`. "TV920" (SET-UP 6) is internal 5 at `0x1EBE`.

Handler `0x2798` is a single `RET` — any char whose translation lands on it is a **no-op / ignored**. That's the ground truth for "this command is not implemented in this mode."

### Ampex native mode — incoming ESC commands (verified)

Status column: **✓** = dispatch lands on a real handler (shown as `0x****`). **✗** = falls through to `0x2798` (`RET`, no-op) — **the command is silently ignored** in this firmware. Status for control codes is inferred from the same table.

**Cursor control**
| Sequence | Bytes | Action | Status |
|----------|-------|--------|--------|
| `CTRL/^` | `0x1E` | Home | ✗ ignored |
| `CTRL/V` | `0x16` | Cursor down (no scroll) | ✗ ignored |
| `CTRL/J` | `0x0A` | Line feed (scrolls) | ✓ `0x18b4` |
| `CTRL/H` | `0x08` | Cursor left | ✗ ignored |
| `CTRL/L` | `0x0C` | Cursor right | ✓ `0x34e8` |
| `CTRL/K` | `0x0B` | Cursor up | ✗ ignored |
| `CTRL/M` | `0x0D` | Carriage return | ✓ `0x18fa` |
| `CTRL/_` | `0x1F` | Newline | ✗ ignored |
| `CTRL/I` | `0x09` | Tab | ✓ `0x2250` |
| `ESC i` | `0x1B 0x69` | Field tab | ✓ `0x462a` |
| `ESC I` | `0x1B 0x49` | Back tab | ✓ `0x340c` |
| `ESC j` | `0x1B 0x6A` | Reverse line feed | ✓ `0x1c73` |
| `ESC =` *rc* | `0x1B 0x3D` *r c* | Address cursor (row, col); *r, c* = ASCII + `SPACE` | ✓ `0x3523` |
| `ESC ?` | `0x1B 0x3F` | Read cursor → host sends back (r, c) | ✓ `0x09f1` |
| `ESC -` *prc* | `0x1B 0x2D` *p r c* | Address cursor (page, row, col) | ✗ ignored |
| `ESC |` | `0x1B 0x7C` | Read cursor (page, row, col) | ✗ ignored |
| `ESC . 9` *rrRcccC* | `0x1B 0x2E 0x39` … | Address cursor, decimal encoding | ✗ ignored (`ESC .` not dispatched) |
| `ESC . D` | `0x1B 0x2E 0x44` | Write at hidden cursor | ✗ ignored |

**Cursor appearance** — entire `ESC .` family routes to `0x2798` (no-op)

| Sequence | Bytes | Action | Status |
|----------|-------|--------|--------|
| `ESC . 1` | `0x1B 0x2E 0x31` | Flashing block cursor | ✗ ignored |
| `ESC . 2` | `0x1B 0x2E 0x32` | Steady block cursor | ✗ ignored |
| `ESC . 3` | `0x1B 0x2E 0x33` | Flashing underline cursor | ✗ ignored |
| `ESC . 4` | `0x1B 0x2E 0x34` | Steady underline cursor | ✗ ignored |
| `ESC . 0` | `0x1B 0x2E 0x30` | Cursor off | ✗ ignored |

**Edit / erase**
| Sequence | Bytes | Action | Status |
|----------|-------|--------|--------|
| `ESC '` | `0x1B 0x27` | Clear all to nulls | ✓ `0x09e0` |
| `ESC +` | `0x1B 0x2B` | Clear unprotected to space | ✓ `0x44e8` |
| `CTRL/Z` | `0x1A` | Clear unprotected to space (alt) | ✗ ignored |
| `ESC :` | `0x1B 0x3A` | Clear unprotected to null | ✓ `0x44e8` (same handler as `ESC +`) |
| `ESC ,` | `0x1B 0x2C` | Clear unprotected to half-intensity | ✗ ignored |
| `CTRL/X` | `0x18` | Clear unprotected fields to spaces | ✗ ignored |
| `ESC . <ch>` | `0x1B 0x2E` *ch* | Load blank character (non-space fill) | ✗ ignored |
| `ESC T` | `0x1B 0x54` | Erase to end of line (spaces) | ✓ `0x43d5` |
| `ESC t` | `0x1B 0x74` | Erase to end of line (nulls) | ✓ `0x43cb` |
| `ESC Y` | `0x1B 0x59` | Erase to end of page (spaces) | ✓ `0x4445` |
| `ESC y` | `0x1B 0x79` | Erase to end of page (nulls) | ✓ `0x4465` |
| `ESC O` | `0x1B 0x4F` | Line mode | ✓ `0x19b0` |
| `ESC N` | `0x1B 0x4E` | Page mode | ✓ `0x2924` |
| `ESC q` | `0x1B 0x71` | Insert mode | ✓ `0x1cad` |
| `ESC r` | `0x1B 0x72` | Edit (replace) mode | ✗ ignored |
| `ESC Q` | `0x1B 0x51` | Character insert | ✓ `0x1afe` |
| `ESC W` | `0x1B 0x57` | Character delete | ✓ `0x1b05` |
| `ESC E` | `0x1B 0x45` | Line insert | ✓ `0x1c6b` |
| `ESC R` | `0x1B 0x52` | Line delete | ✓ `0x19dc` |
| `ESC 1` | `0x1B 0x31` | Set column tab | ✓ `0x4645` |
| `ESC 2` | `0x1B 0x32` | Clear column tab | ✓ `0x0aab` |
| `ESC 3` | `0x1B 0x33` | Clear all tabs | ✓ `0x0a55` |

**Display / video attributes**
| Sequence | Bytes | Action | Status |
|----------|-------|--------|--------|
| `ESC G 0…?` | `0x1B 0x47` *code* | Character-attribute set | ✓ `0x1914` |
| `ESC b` | `0x1B 0x62` | Black-on-white | ✗ ignored |
| `ESC d` | `0x1B 0x64` | White-on-black | ✗ ignored |
| `ESC n` | `0x1B 0x6E` | Normal screen | ✓ `0x1ca1` |
| `ESC o` | `0x1B 0x6F` | Blank screen | ✓ `0x1ca5` |
| `ESC "` | `0x1B 0x22` | Define block of graphics | ✓ `0x1a48` |
| `ESC p 0` / `ESC p 1` | `0x1B 0x70` *n* | Reset / set double-wide | ✓ `0x1ca9` |
| `ESC m 0` / `m 1` / `m 2` | `0x1B 0x6D` *n* | Double-high line control | ✓ `0x1c9d` |
| `ESC . 7` / `ESC . 8` / `ESC . S` | `0x1B 0x2E` *x* | Attribute / embed controls | ✗ ignored |

**Mode control**
| Sequence | Bytes | Action | Status |
|----------|-------|--------|--------|
| `ESC B` | `0x1B 0x42` | Block mode on | ✓ `0x1b24` |
| `ESC C` | `0x1B 0x43` | Conversation mode on | ✓ `0x1d44` |
| `ESC D F` / `ESC D H` | `0x1B 0x44` *x* | Full / half duplex | ✗ ignored (ESC D routes to no-op) |
| `ESC k` | `0x1B 0x6B` | Local edit | ✓ `0x1c8a` |
| `ESC l` | `0x1B 0x6C` | Duplex edit | ✓ `0x1c99` |
| `ESC &` | `0x1B 0x26` | Protect mode on | ✓ `0x33e4` |
| `ESC )` / `ESC (` | `0x1B 0x29` / `0x1B 0x28` | Write-protect on / off | ✓ `0x1b72` / `0x1b97` |
| `ESC $` / `ESC %` | `0x1B 0x24` / `0x1B 0x25` | Graphics mode on / off | ✗ ignored |
| `ESC U` | `0x1B 0x55` | Monitor mode on | ✓ `0x1b2a` |
| `ESC u` | `0x1B 0x75` | Monitor mode off | ✗ ignored |
| `ESC X` | `0x1B 0x58` | Monitor mode off (alt) | ✓ `0x46d5` |
| `ESC ! 1` / `ESC ! 2` | `0x1B 0x21` *n* | Line lock / clear | ✗ ignored (ESC ! no-op) |
| `ESC #` | `0x1B 0x23` | Lock keyboard | ✓ `0x1a3b` |
| `ESC >` / `ESC <` | `0x1B 0x3E` / `0x1B 0x3C` | Key click on / off | ✗ ignored |
| `CTRL/G` | `0x07` | Bell | ✗ ignored |
| `ESC . C` | `0x1B 0x2E 0x43` | Load / read time | ✗ ignored |

**Transmission to host**
| Sequence | Bytes | Action | Status |
|----------|-------|--------|--------|
| `CTRL/O` / `CTRL/N` | `0x0F` / `0x0E` | Enable / disable XON/XOFF | ✓ `0x36df` / ✓ `0x3523` |
| `ESC 4` | `0x1B 0x34` | Send line — unprotected | ✓ `0x1b1b` |
| `ESC 5` | `0x1B 0x35` | Send page — unprotected | ✓ `0x1b0d` |
| `ESC 6` | `0x1B 0x36` | Send line — all | ✓ `0x1a2d` |
| `ESC 7` | `0x1B 0x37` | Send page — all | ✓ `0x1b20` |
| `ESC S` | `0x1B 0x53` | Send message — unprotected | ✗ ignored |
| `ESC s` | `0x1B 0x73` | Send message — all | ✗ ignored |
| `ESC Z 1` / `ESC Z 0` | `0x1B 0x5A` *n* | Send status / user line | ✗ ignored (ESC Z no-op) |
| `ESC M` | `0x1B 0x4D` | Send terminal state | ✓ `0x1920` |

**Printer**
| Sequence | Bytes | Action | Status |
|----------|-------|--------|--------|
| `ESC P` | `0x1B 0x50` | Local print | ✓ `0x19d4` |
| `ESC @` | `0x1B 0x40` | Extension print (CCP) on | ✓ `0x1af6` |
| `ESC A` | `0x1B 0x41` | Extension print (CCP) off | ✓ `0x1bbc` |
| `ESC a` | `0x1B 0x61` | Transparent print (TPR) off | ✓ `0x1bd0` |
| `CTRL/R` / `CTRL/T` | `0x12` / `0x14` | Bidirectional print on / off | ✗ ignored |
| `ESC L` | `0x1B 0x4C` | Unformatted print | ✗ ignored |

**Terminal control**
| Sequence | Bytes | Action | Status |
|----------|-------|--------|--------|
| `ESC 8` | `0x1B 0x38` | Smooth scroll on | ✓ `0x1972` |
| `ESC 9` | `0x1B 0x39` | Jump scroll on | ✓ `0x2840` |
| `ESC v` / `ESC w` | `0x1B 0x76` / `0x1B 0x77` | Flip mode on / off | ✓ `0x1b37` / `0x1b42` |
| `ESC \ 1..3` | `0x1B 0x5C` *n* | 24 / 48 / 96 lines per page | ✗ ignored |
| `ESC J` | `0x1B 0x4A` | Previous page | ✓ `0x19e4` |
| `ESC K` | `0x1B 0x4B` | Next page | ✗ ignored |
| `ESC . 5` / `ESC . 6` | `0x1B 0x2E` *n* | 80-col / 132-col | ✗ ignored |

**Special / programming**
| Sequence | Bytes | Action | Status |
|----------|-------|--------|--------|
| `ESC !` | `0x1B 0x21` | Load user line | ✗ ignored |
| `ESC g` | `0x1B 0x67` | Display user line | ✓ `0x2799` |
| `ESC h` | `0x1B 0x68` | Blank user line | ✓ `0x3519` |
| `ESC F` | `0x1B 0x46` | Display control character (next byte literal) | ✓ `0x4714` |
| `ESC x 0..4` | `0x1B 0x78` *n* | Program terminators | ✗ ignored |
| `ESC {` | `0x1B 0x7B` | Configure host port | ✓ `0x28c7` |
| `ESC }` | `0x1B 0x7D` | Configure aux port | ✓ `0x18b4` |
| `ESC 0` | `0x1B 0x30` | Program one edit key | ✗ ignored |
| `ESC ] 0` / `ESC ] 1` | `0x1B 0x5D` *n* | Program all edit keys | ✗ ignored |
| `ESC |` | `0x1B 0x7C` | Program function key / read cursor | ✗ ignored |
| `ESC 0 1` / `ESC 0 2` | `0x1B 0x30` *n* | Program send key | ✗ ignored |
| `ESC . A` | `0x1B 0x2E 0x41` | Execute programmed function key | ✗ ignored |

**Summary for Ampex native mode:** of ~60 documented commands, roughly **43 are actually implemented** and **~17 are silently ignored**. The notable gaps are: cursor-appearance `ESC . n` family, extended cursor addressing `ESC -` / `ESC |` / `ESC . 9`, tab/terminal-control `ESC \ n`, column-mode switching, all `ESC D` duplex and `ESC Z` send-line, the key-click `ESC >` / `ESC <`, line-lock `ESC !`, graphics-mode `ESC $` / `ESC %`, and all the programming/function-key `ESC 0`/`ESC ]`/`ESC |`/`ESC x` commands.

### VT52 mode — incoming ESC commands (verified)

Surprising finding: the D-175's VT52 emulation is **partial**. Standard VT52 cursor-movement commands `ESC A` (up), `ESC D` (left), `ESC H` (home), and the identify / hold-screen / print-screen commands are **not implemented** — they fall through to `0x2798` (`RET`). Only about **half of the documented VT52 command set** has real handlers in this firmware.

| Sequence | Bytes | Action | Status |
|----------|-------|--------|--------|
| `ESC A` | `0x1B 0x41` | Cursor up (no scroll) | ✗ **ignored** |
| `ESC B` | `0x1B 0x42` | Cursor down | ✓ `0x1b24` |
| `ESC C` | `0x1B 0x43` | Cursor right | ✓ `0x1d44` |
| `ESC D` | `0x1B 0x44` | Cursor left | ✗ **ignored** |
| `ESC H` | `0x1B 0x48` | Home | ✗ **ignored** |
| `ESC I` | `0x1B 0x49` | Reverse line feed (scroll down at top) | ✓ `0x340c` |
| `ESC J` | `0x1B 0x4A` | Erase to end of screen | ✓ `0x19e4` |
| `ESC K` | `0x1B 0x4B` | Erase to end of line | ✓ `0x2924` |
| `ESC Y` *rc* | `0x1B 0x59` *r c* | Direct cursor address; *r* = row + 0x20, *c* = col + 0x20 | ✓ `0x4445` |
| `ESC Z` | `0x1B 0x5A` | Identify (should reply `ESC / K`) | ✗ **ignored** |
| `ESC =` | `0x1B 0x3D` | Enter alternate keypad mode | ✓ `0x3523` |
| `ESC >` | `0x1B 0x3E` | Exit alternate keypad mode | ✗ ignored |
| `ESC F` | `0x1B 0x46` | Enter graphics (special-character) mode | ✓ `0x4714` |
| `ESC G` | `0x1B 0x47` | Exit graphics mode | ✓ `0x1914` |
| `ESC [` | `0x1B 0x5B` | Enter hold-screen mode | ✗ ignored |
| `ESC \` | `0x1B 0x5C` | Exit hold-screen mode | ✗ ignored |
| `ESC ]` | `0x1B 0x5D` | Print screen | ✗ ignored |
| `ESC ^` | `0x1B 0x5E` | Auto-copy on (print every line) | ✓ `0x2934` |
| `ESC _` | `0x1B 0x5F` | Auto-copy off | ✓ `0x293d` |

**Caveat:** the ✓-marked VT52 handlers share address space with the Ampex native handlers (e.g. `ESC B` → `0x1b24` is the same handler used by Ampex's `ESC B` = Block Mode On). Whether each handler's actual behavior matches the VT52 semantic (versus the Ampex semantic) would require tracing each handler body. That's a reasonable additional concern: the presence of a handler confirms the char is *recognized*, not necessarily that it does what VT52 expects.

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
