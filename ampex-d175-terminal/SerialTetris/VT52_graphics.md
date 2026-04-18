# Ampex D-175 VT52 Graphics-Mode Character Map

Observed by switching the terminal to VT52 emulation (SET-UP parameter R =
VT52) and running `vt52_graphics.py`, which sends every code from `0x20`
through `0x6E` wrapped in `ESC F` / `ESC G`. Visual reference:
`Ampex_D175_VT52_Graphics.jpg` in this folder.

## Enter / exit graphics mode

| Sequence | Bytes | Meaning |
|----------|-------|---------|
| `ESC F`  | `0x1B 0x46` | Enter VT52 graphics mode |
| `ESC G`  | `0x1B 0x47` | Exit VT52 graphics mode |

Both are ✓-implemented in the D-175's VT52 dispatch (firmware addresses
`0x4714` and `0x1914` respectively, per `../agents.md`).

## Two character families

| Range | Count | Type |
|-------|-------|------|
| `0x20`–`0x5F` | 64 | 2-wide × 3-high pseudo-pixel **block characters** (sextants) |
| `0x60`–`0x6E` | 15 | **Box / line-drawing** characters |
| `0x6F`–`0x7E` | — | Not tested; behavior unknown |

## Block characters (0x20 – 0x5F)

Each cell is a **2-wide × 3-high grid of pseudo-pixels**. The character
code equals `0x20 + bitmask`, where each bit of the mask toggles one
pixel:

```
  bit 0 (0x01): top-left        bit 1 (0x02): top-right
  bit 2 (0x04): middle-left     bit 3 (0x08): middle-right
  bit 4 (0x10): bottom-left     bit 5 (0x20): bottom-right
```

All 64 combinations of the six pixels are reachable, giving a complete
sextant set (equivalent to Unicode's *Symbols for Legacy Computing*
sextants U+1FB00–U+1FB3B, though the bit ordering differs from
Unicode's).

### Useful landmark codes

| Code | Pattern (`TL TR / ML MR / BL BR`) | Meaning |
|------|-----------------------------------|---------|
| `0x20` | `.. / .. / ..` | blank (empty cell) |
| `0x23` | `## / .. / ..` | top-row bar |
| `0x2C` | `.. / ## / ..` | middle-row bar |
| `0x50` | `.. / .. / ##` | bottom-row bar |
| `0x35` | `#. / #. / #.` | full left column |
| `0x4A` | `.# / .# / .#` | full right column |
| `0x2F` | `## / ## / ..` | top two rows filled |
| `0x5C` | `.. / ## / ##` | bottom two rows filled |
| `0x5F` | `## / ## / ##` | full solid 2×3 block |

### Complete table

Laid out to match the on-screen probe image — rows = high nibble,
columns = low nibble. Each cell shows the 2×3 pattern on three stacked
lines (top-row, middle-row, bottom-row; `#` = pixel on, `.` = off).

```
         0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F

  2:    ..  #.  .#  ##  ..  #.  .#  ##  ..  #.  .#  ##  ..  #.  .#  ##
        ..  ..  ..  ..  #.  #.  #.  #.  .#  .#  .#  .#  ##  ##  ##  ##
        ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..

  3:    ..  #.  .#  ##  ..  #.  .#  ##  ..  #.  .#  ##  ..  #.  .#  ##
        ..  ..  ..  ..  #.  #.  #.  #.  .#  .#  .#  .#  ##  ##  ##  ##
        #.  #.  #.  #.  #.  #.  #.  #.  #.  #.  #.  #.  #.  #.  #.  #.

  4:    ..  #.  .#  ##  ..  #.  .#  ##  ..  #.  .#  ##  ..  #.  .#  ##
        ..  ..  ..  ..  #.  #.  #.  #.  .#  .#  .#  .#  ##  ##  ##  ##
        .#  .#  .#  .#  .#  .#  .#  .#  .#  .#  .#  .#  .#  .#  .#  .#

  5:    ..  #.  .#  ##  ..  #.  .#  ##  ..  #.  .#  ##  ..  #.  .#  ##
        ..  ..  ..  ..  #.  #.  #.  #.  .#  .#  .#  .#  ##  ##  ##  ##
        ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##  ##
```

### Implications for graphics work

- Text cells are **taller than wide** on this hardware, so each sextant
  pixel is roughly 1:1 visually (since the 2×3 pixels fill a cell that
  is approximately 2× as tall as wide).
- For filled rectangles, `0x5F` is the fastest choice: a single byte per
  text cell fills a solid 2×3 pixel area.
- For half-height fills, `0x2F` (top half) and `0x5C` (bottom half) are
  useful. `0x23` / `0x50` give top / bottom bars.

## Line-drawing characters (0x60 – 0x6E)

The final 15 codes draw standard single-line box/branch glyphs. Glyphs
identified by comparison against the photo:

| Code | Glyph | Unicode | Description |
|------|:-----:|---------|-------------|
| `0x60` | `┌` | U+250C | upper-left corner |
| `0x61` | `┐` | U+2510 | upper-right corner |
| `0x62` | `└` | U+2514 | lower-left corner |
| `0x63` | `┘` | U+2518 | lower-right corner |
| `0x64` | `┬` | U+252C | T down (top tee) |
| `0x65` | `┴` | U+2534 | T up (bottom tee) |
| `0x66` | `├` | U+251C | T right (left tee) |
| `0x67` | `┤` | U+2524 | T left (right tee) |
| `0x68` | `─` | U+2500 | horizontal line |
| `0x69` | `│` | U+2502 | vertical line |
| `0x6A` | `┼` | U+253C | cross / four-way |
| `0x6B` | `╰` | U+2570 | rounded lower-left corner |
| `0x6C` | `╭` | U+256D | rounded upper-left corner |
| `0x6D` | `╮` | U+256E | rounded upper-right corner |
| `0x6E` | `╯` | U+256F | rounded lower-right corner |

The last four (`0x6B`–`0x6E`) were confirmed by drawing a rounded box
and reading back the corner glyphs from hardware. Note that the rounded
corners are ordered (LL, UL, UR, LR) — *not* the (UL, UR, LL, LR) order
that the sharp corners use. The sharp corner order was verified from the
probe photo directly; the rounded order from the Tetris chrome render.

## Quick reference: picking a block glyph from desired pixels

To pick a block character for an arbitrary 2×3 pixel pattern, sum the
bit values for the pixels you want lit and add `0x20`:

```
         col0        col1
row0     0x01        0x02
row1     0x04        0x08
row2     0x10        0x20
```

Examples:
- All six pixels → `0x01+0x02+0x04+0x08+0x10+0x20 = 0x3F`, so send
  `0x20 + 0x3F = 0x5F` (full block).
- Just top-left and bottom-right (diagonal) → `0x01+0x20 = 0x21`, so
  send `0x20 + 0x21 = 0x41`.
- Middle-row only → `0x04+0x08 = 0x0C`, so send `0x2C`.
