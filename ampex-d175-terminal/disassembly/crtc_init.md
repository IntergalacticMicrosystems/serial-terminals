# SCN2672 CRTC — initialization and decoded timing

The Ampex D-175's video timing controller is a Signetics SCN2672 PVTC. This
document captures (a) how the firmware brings it up, (b) the eleven
initialization-register bytes the firmware writes, and (c) the resulting
display geometry and refresh timing, decoded against the SCN2672 datasheet
(`Docs/SCN2672-datasheet.pdf`, Table 2 — Initialization Register Bit Formats).

## 1. Address map (memory-mapped)

The SCN2672 is reached via plain `LD (nn),A` / `LD (nn),HL` writes (not
Z80 `OUT`). Eight bytes of address space at `0x6000..0x6007`.

| Address | Role | Evidence |
|---|---|---|
| `0x6000` | **IR Data port** — writes here store into the IR pointed to by the IR Pointer and auto-increment the pointer. | 11× `ld (0x6000), a` in `U4:0x0235` init loop. |
| `0x6001` | **Command / Status register** — single-byte command writes; bit 5 polled for "CRTC ready". | `ld a,(0x6001) ; and 0x20` wait loop at `U4:0x011B`. Command writes scattered across U4/U5. |
| `0x6002/3` | **Screen Start register 1** (16-bit). | `ld (0x6002), bc` at `U4:0x0202` writes `0x0080`. |
| `0x6004/5` | **Display Pointer / Screen Start 2** (16-bit). | Heavy use in U5 (e.g. `U5:0x29A4`, `U5:0x3A6F`, `U5:0x3B81`). |
| `0x6006/7` | **Cursor Address register** (16-bit). | Every cursor-position update lands here — `ld (0x6006), hl` at `U4:0x0011`'s `crtc_write_cursor` and many U5 callers. |

## 2. Boot initialization sequence

Bringup is split across three routines: stage ROM defaults into RAM, patch
the staged copy from SET-UP state, then walk the result into the chip.

### 2a. Stage RAM defaults (`U4:0x0173`)

```
ld hl, 0x02BC        ; ROM table (11 IR bytes)
ld de, 0xAA8E        ; RAM destination (NVRAM-adjacent, SET-UP-overridable)
ld bc, 11
ldir
```

`0xAA8E` sits in the same NVRAM-window region as other SET-UP-backed state,
so a SET-UP screen can overwrite these defaults before the next phase-2
program cycle.

### 2b. SET-UP patch — LINE FREQ override (`U4:0x02DB`)

`sub_02DBh` rewrites RAM byte `0xAA91` (the IR3 slot) based on bit 0 of the
SET-UP byte at `0xAAB8`:

```
ld hl, 0xAAB8
ld c, (hl)
ld de, 0xAA91        ; IR3 slot in staged copy
ld a, 0x28           ; default = 60 Hz timing
bit 0, (hl)          ; opcode CB 46
jr z, l0307h         ; if bit 0 clear, keep 0x28
ld a, 0xFD           ; if bit 0 set, switch to 50 Hz timing
l0307h:
ld (de), a           ; (0xAA91) := A
```

Bit-0 mapping (matches menu choice order `:.60.50` in the SET-UP text at
`U6:0x4A9F`):

| `0xAAB8` bit 0 | SET-UP "D LINE FREQ" | IR3 value written |
|---|---|---|
| 0 | **60** | `0x28` |
| 1 | 50 | `0xFD` |

The full SET-UP menu's A–V key dispatcher (`U4:0x070E..0x07C8`) is
table-driven by a packed option table at `U4:0x1FF8`. Walking the table:

| Table offset | Byte | Decoded |
|---|---|---|
| `0x1FF8` | `0x04` | opt A (CURSOR) — 3-bit field at bit 0 of `0xAAB7` |
| `0x1FF9` | `0x43` | opt B (STATUS) — 2-bit field at bit 4 of `0xAAB7` |
| `0x1FFA` | `0x71` | opt C (AUTO NEW LINE) — 1-bit field at bit 7 of `0xAAB7` |
| `0x1FFB` | `0x00` | advance to next RAM byte (`0xAAB8`) |
| `0x1FFC` | `0x01` | **opt D (LINE FREQ) — 1-bit field at bit 0 of `0xAAB8`** |
| `0x1FFD` | `0x21` | opt E (CRT SAVER) — 1-bit at bit 2 of `0xAAB8` |
| `0x1FFE` | `0x31` | opt F (XON/XOFF) — 1-bit at bit 3 of `0xAAB8` |
| `0x1FFF` | `0x43` | opt G (PARITY) — 2-bit at bit 4 of `0xAAB8` |

Pressing `D` in SET-UP toggles bit 0 of `0xAAB8`; the change does not reach
the CRTC until SET-UP is exited and the post-SET-UP reinit chain at
`U6:0x4E70` re-runs `sub_02DBh` (override) then `sub_022Bh` (program).

Two software timers also branch on `0xAAB8` bit 0 so wall-clock behaviour
stays constant across the frame-rate change:

- `U4:0x0100` reloads the down-counter at `0xAC48` to `0x1E` (30) for 60 Hz
  vs. `0x19` (25) for 50 Hz — a ~0.5 s period regardless of frame rate.
- `U4:0x0098` selects bell/click duration table `l0BB9h` (60 Hz) vs.
  `l0E0Fh` (50 Hz).

### 2c. Program the chip (`U4:0x022B`)

```
ld a, 0x10
ld (0x6001), a       ; command 0x10 → "Reset IR Pointer to 0"
ld b, 11
ld hl, 0xAA8E
loop:
    ld a, (hl)
    ld (0x6000), a   ; write IR_n; pointer auto-increments
    inc hl
    djnz loop
```

Surrounding command writes to `0x6001` during full bringup
(`U4:0x016A..0x0172`, `U4:0x0209..0x020B`, `U4:0x01E8`): `0x00`, `0x00`,
`0x28`, `0x9F`, `0x78`, `0x29`, `0x31`. These are SCN2672 control commands
(display enable / cursor enable / interrupt setup) — exact decode requires
the SCN2672 command-byte tables.

## 3. The 11 IR bytes

Stored in ROM at `U4:0x02BC..0x02C6`:

```
58 24 1B FD 98 4F 0B 2B 00 10 97
```

This ROM sequence is the 50 Hz default. After `sub_02DBh` patches IR3, the
sequence actually clocked into the CRTC is:

| LINE FREQ | IR3 | 11 IR bytes clocked into CRTC |
|---|---|---|
| **60** (this unit) | `0x28` | `58 24 1B 28 98 4F 0B 2B 00 10 97` |
| 50 | `0xFD` | `58 24 1B FD 98 4F 0B 2B 00 10 97` |

## 4. Bit-level decode

### IR0 = `0x58` = `0 1011 0 00`

| Bits | Field | Raw | Decoded |
|---|---|---|---|
| 7 | NOT USED | 0 | — |
| 6:3 | Scan lines per character row (non-interlaced) | `1011` | **12 scan lines / char row** |
| 2 | Sync Select | 0 | **VSYNC** (separate) |
| 1:0 | Buffer Mode | `00` | **Independent** |

The font ROM (U52) holds 16 scan-line glyphs; only the top 12 are used per
character cell.

### IR1 = `0x24` = `0 0100100`

| Bits | Field | Raw | Decoded |
|---|---|---|---|
| 7 | Interlace Enable | 0 | **Non-interlaced** |
| 6:0 | Equalizing Constant (N+1 CCLK) | 36 | **EC = 37 CCLK** (indirectly sets HFP — see §5) |

### IR2 = `0x1B` = `0 0011 011`

| Bits | Field | Raw | Decoded |
|---|---|---|---|
| 7 | NOT USED | 0 | — |
| 6:3 | Horizontal Sync Width (2N+2 CCLK) | 3 | **HSW = 8 CCLK** |
| 2:0 | Horizontal Back Porch (4N+1 CCLK) | 3 | **HBP = 13 CCLK** |

### IR3 — overwritten by SET-UP "D LINE FREQ"

IR3 is the only IR byte the firmware patches between LDIR-staging and
CRTC-programming. Both possible values:

**60 Hz mode** (`0x28` = `001 01000`, written when `0xAAB8` bit 0 = 0):

| Bits | Field | Raw | Decoded |
|---|---|---|---|
| 7:5 | Vertical Front Porch (4N+4 lines) | 1 | **VFP = 8 scan lines** |
| 4:0 | Vertical Back Porch (2N+4 lines) | 8 | **VBP = 20 scan lines** |

**50 Hz mode** (`0xFD` = `111 11101`, written when `0xAAB8` bit 0 = 1):

| Bits | Field | Raw | Decoded |
|---|---|---|---|
| 7:5 | Vertical Front Porch (4N+4 lines) | 7 | **VFP = 32 scan lines** |
| 4:0 | Vertical Back Porch (2N+4 lines) | 29 | **VBP = 62 scan lines** |

### IR4 = `0x98` = `1 0011000`

| Bits | Field | Raw | Decoded |
|---|---|---|---|
| 7 | Character Blink Rate | 1 | **1/32 VSYNC** (slow) |
| 6:0 | Active Character Rows per Screen (N+1) | 24 | **25 rows** |

### IR5 = `0x4F` = `01001111`

| Bits | Field | Raw | Decoded |
|---|---|---|---|
| 7:0 | Active Characters per Row (N+1) | 79 | **80 columns** |

### IR6 = `0x0B` = `0000 1011`

| Bits | Field | Raw | Decoded |
|---|---|---|---|
| 7:4 | First Scan Line of Cursor | 0 | Scan line 0 |
| 3:0 | Last Scan Line of Cursor | 11 | Scan line 11 |

Cursor occupies the full 12-line character cell — a block cursor.

### IR7 = `0x2B` = `00 1 0 1011`

| Bits | Field | Raw | Decoded |
|---|---|---|---|
| 7:6 | Light Pen Line Position | 0 | Scan line 0 |
| 5 | Cursor Blink Enable | 1 | **Cursor blinks** |
| 4 | Double-Height Char Row Enable | 0 | Disabled |
| 3:0 | Underline Position | 11 | **Underline at scan line 11** (bottom) |

### IR8 = `0x00`

Display Buffer First Address — low 8 bits = `0x00`.

### IR9 = `0x10` = `0001 0000`

| Bits | Field | Raw | Decoded |
|---|---|---|---|
| 7:4 | Display Buffer Last Address ((N+1)×1024 − 1) | 1 | **Last = 2,047** (2 KB ceiling) |
| 3:0 | Display Buffer First Address (high 4 bits) | 0 | First addr MSBs = 0 |

Combined first address = `0x000`; buffer spans `0x000..0x7FF` (2 KB —
exactly enough for 80 × 25 = 2,000 characters).

### IR10 = `0x97` = `1 0010111`

| Bits | Field | Raw | Decoded |
|---|---|---|---|
| 7 | Cursor Blink Rate | 1 | **1/32 VSYNC** |
| 6:0 | Split-Screen Interrupt Row | 23 | **Interrupt at row 23** |

Row 23 in a 25-row display fires the split-screen interrupt at the boundary
of the bottom two rows — consistent with a status-line region.

## 5. Derived horizontal timing

`HFP` (horizontal front porch) is not directly programmed. IR1's
Equalizing Constant encodes it via the datasheet formula:

```
EC  =  (HACT + HFP + HSW + HBP) / 2  −  2·HSW

37  =  (80  + HFP + 8   + 13) / 2  −  2·8
                            ⇒ HFP = 5 CCLK
```

Datasheet-stated minimum HFP is 2 CCLK; the programmed 5 leaves margin.
If the design pairs the SCN2672 with the companion 2673/2677 VAC, BLANK is
delayed 3 CCLKs, making **effective HFP = 2 CCLK and effective HBP = 16 CCLK**
(total period unchanged).

| Phase | CCLK |
|---|---|
| HACT (active video) | 80 |
| HFP (front porch) | 5 |
| HSW (sync) | 8 |
| HBP (back porch) | 13 |
| **Horizontal period** | **106 CCLK** |

## 6. Derived vertical timing

Vertical Sync Width is fixed by the chip at 3 scan lines (datasheet, IR3
description). Only the porches change between LINE FREQ modes:

| Phase | 60 Hz mode | 50 Hz mode |
|---|---|---|
| VACT = 25 rows × 12 lines | 300 | 300 |
| VFP | 8 | 32 |
| VSW (fixed) | 3 | 3 |
| VBP | 20 | 62 |
| **Vertical period** | **331 scan lines** | **397 scan lines** |

## 7. Refresh rate

Measured on the running board:

| Signal | Frequency |
|---|---|
| Dot clock | 14.736 MHz |
| CCLK | 2.105 MHz |
| Dots per character | 7 (= 14.736 / 2.105) |

The horizontal period is identical in both modes (LINE FREQ patches only
the vertical porches), so HSYNC stays at 19.86 kHz; only the frame rate
changes.

| Period | 60 Hz mode (this unit) | 50 Hz mode |
|---|---|---|
| Line | 106 CCLK / 2.105 MHz = 50.36 μs (19.86 kHz horizontal) | (same) |
| Frame | 331 × 50.36 μs = **16.67 ms** (**~60.0 Hz** vertical) | 397 × 50.36 μs = 19.99 ms (~50.0 Hz) |

The unit being characterised here has SET-UP "D LINE FREQ" set to **60**,
so IR3 = `0x28` and frame rate is ~60.0 Hz. CCLK at 2.105 MHz is well
under the SCN2672's 6 MHz ceiling in either mode.

## 8. Summary

This unit's SET-UP "D LINE FREQ" is set to **60**, so the figures below
reflect the 60 Hz IR3 (`0x28`); the 50 Hz column shows the alternative.

| Property | 60 Hz (this unit) | 50 Hz |
|---|---|---|
| Resolution | 80 × 25 characters | 80 × 25 characters |
| Character cell | 7 dots × 12 scan lines (out of 16-line font ROM) | (same) |
| Active pixels | 560 × 300 | 560 × 300 |
| Mode | Non-interlaced, separate VSYNC | (same) |
| Horizontal period | 106 CCLK | 106 CCLK |
| Vertical period | 331 scan lines | 397 scan lines |
| Frame rate | ~60.0 Hz @ 14.736 MHz dot clock, 2.105 MHz CCLK | ~50.0 Hz |
| Display buffer | 2 KB at offset 0 (first 2,047 bytes) | (same) |
| Cursor | Block, scan lines 0–11, blinks at 1/32 VSYNC | (same) |
| Underline | Scan line 11 (bottom row) | (same) |
| Status line | Split-screen interrupt at row 23 (bottom 2 rows) | (same) |
| Char blink attribute rate | 1/32 VSYNC | (same) |
