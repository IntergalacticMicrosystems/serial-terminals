# Semantic handler reference

The master jump table at `U5:0x20AA` holds 132 slots (indices `0x00..0x83`).
This document names what each slot *does*, derived by reading the code at
the resolved address and identifying memory touches
(`0xABD7` cursor column, `0xABD8` cursor row, `0xAC28` fill char,
UART `0x8000`, etc). Authoritative command *names* for the Ampex native
emulation are cross-referenced against the Ampex 230 plus Operation
Manual (`Docs/3515844-01_AMPEX_230_plus_Operation_Manual_Mar86.pdf`).

Legend: **ACT** = action routine; **MODE±** = mode-bit set/clear pair;
**SUB** = sub-dispatcher (reads more bytes); **PARM** = parameter-reader
that stores to a RAM slot.

## Universal no-ops

Two addresses are no-op sinks where handlers go when a command is
intentionally unimplemented:

- `U5:0x2798` — single `RET` (used by 16 indices: `0x00, 0x01, 0x02, 0x05, 0x08..0x0A, 0x12..0x14, 0x28, 0x58, 0x68..0x6A, 0x71`).
- `U4:0x19A6` — single `RET` (handler index `0x1E`).

## Classified handlers (idx → role)

Grouped by structural kinship. Arity is from the state-machine classifier.

### Cursor motion (single-byte)

| idx | ar | handler | role / command |
|---|---|---|---|
| `0x3C` | 1 | `U5:0x2F65` | **Cursor up** (VT52 `ESC A`) |
| `0x3D` | 1 | `U5:0x2F61` | **Cursor down** (VT52 `ESC B`) |
| `0x4D` | 1 | `U5:0x2F54` | **Cursor right** (VT52 `ESC C`) |
| `0x52` | 1 | `U5:0x2F59` | **Cursor left** (VT52 `ESC D`) |
| `0x3E` | 1 | `U5:0x33AF` | **Home** (VT52 `ESC H`) |

Cursor-motion quad `U5:0x2F54..0x2F65` is a tightly packed block of 4
adjacent handlers sharing a common tail.

### Cursor addressing

| idx | ar | handler | role / command |
|---|---|---|---|
| `0x0C` | 3 | `U5:0x3523` | **Cursor address** (row, col). VT52 `ESC Y <r+32><c+32>`, AMPEX `ESC = <r+32><c+32>`. |
| `0x16` | 2 | `U5:0x34CB` | **Set cursor row** from 5-bit byte. Stores to `0xABD8`. |
| `0x17` | 2 | `U5:0x34B3` | **Set cursor column** from BCD-packed byte. Stores to `0xABD7`. |
| `0x03` | 5 | `U5:0x2250` | **4-coordinate cursor/region**. Reads 4 bytes (row/col pair × 2). |

### Cursor-position reporting

| idx | ar | handler | role / command |
|---|---|---|---|
| `0x76` | 1 | `U4:0x09F1` | **Cursor position report** (AMPEX `ESC ?`). Emits `<row+0x20><col+0x20>`. |
| `0x4B` | 1 | `U4:0x0A08` | **Extended CPP** (AMPEX `ESC a`). Emits `<col+0x60><row+0x60>`. |
| `0x64` | 1 | `U4:0x0A1D` | **Multi-page CPP**. Emits `<page+0x2F>` then standard cursor report. |

### Erase / clear

| idx | ar | handler | role / command |
|---|---|---|---|
| `0x36` | 1 | `U6:0x43D5` | **Erase to EOL** (unprotected fill). VT52 `ESC K`, AMPEX `ESC T`. |
| `0x37` | 1 | `U6:0x4445` | **Erase to end of screen** (PROT OFF). VT52 `ESC J`, AMPEX `ESC Y`. |
| `0x81` | 1 | `U6:0x43CB` | **Erase to EOL** (protected fill, bit 7 set). AMPEX/VT52 `ESC t`. |
| `0x83` | 1 | `U6:0x44B0` | Erase variant. Entry into same common body as `0x43D5`. |
| `0x82` | 1 | `U6:0x4465` | Erase variant. |

Shared body `U6:0x43D8` is reached from multiple entry points with
different `E` pre-sets (controlling fill-char semantics).

### Attributes / video

| idx | ar | handler | role / command |
|---|---|---|---|
| `0x40` | 1 | `U4:0x1A3B` | **Attribute set 0x55** with flag `0xABC7=0xFF`. AMPEX `ESC #`. |
| `0x41` | 1 | `U4:0x1A48` | **Attribute set 0x56** with flag `0xABC7=0x00`. AMPEX `ESC "`. |
| `0x3A` | 1 | `U5:0x28ED` | **Graphics mode ON** (AMPEX `ESC $`, VT52 `ESC F`). |
| `0x3B` | 1 | `U5:0x2903` | **Graphics mode OFF** (AMPEX `ESC %`, VT52 `ESC G`). |
| `0x15` | 2 | `U4:0x1914` | **Emit graphic glyph by letter** (AMPEX `ESC G <A..O>`). |
| `0x1A` | 2 | `U5:0x280C` | **Select attribute by hex digit** (AMPEX `ESC G <0..F>` per table at `0x2EE2`). |
| `0x6D` | 1 | `U6:0x448E` | Attribute-set handler. AMPEX/VT52 `ESC *`. |

### Ampex display-mode toggles on `0xABD0`

A tightly symmetric 4-bit set/clear cluster at `U4:0x1C73..0x1CAE`. Each
letter is `ld c, <mask> ; jr <set|clr>_displaymode_bit`. The tail
routines are `set_displaymode_bit` (`U4:0x1C83`, `OR`) and
`clr_displaymode_bit` (`U4:0x1C91`, `AND-NOT`).

| idx | ar | handler | cmd | bit |
|---|---|---|---|---|
| `0x79` | 1 | `U4:0x1C73` | `ESC j` | **SET** bit 3 |
| `0x7A` | 1 | `U4:0x1C8A` | `ESC k` | **CLEAR** bit 3 |
| `0x7B` | 1 | `U4:0x1C99` | `ESC l` | **SET** bit 1 |
| `0x7C` | 1 | `U4:0x1C9D` | `ESC m` | **CLEAR** bit 1 |
| `0x7D` | 1 | `U4:0x1CA1` | `ESC n` | **SET** bit 2 |
| `0x7E` | 1 | `U4:0x1CA5` | `ESC o` | **CLEAR** bit 2 |
| `0x7F` | 1 | `U4:0x1CA9` | `ESC p` | **SET** bit 0 |
| `0x80` | 1 | `U4:0x1CAD` | `ESC q` | **CLEAR** bit 0 |

(Per the manual, ESC m/p are double-height / double-wide character
modes. `ESC j..q` bit assignments are consistent with that — four
orthogonal single-bit flags.)

### Tab and mode-bit toggles on `0xAC18`

A parallel cluster at `U5:0x2934..0x2955` — four set/clear pairs on a
different state byte at `0xAC18`. The tail `l2937` does `(0xAC18) |= A`
or (via `cpl`) clear.

| idx | ar | handler | action |
|---|---|---|---|
| `0x5B` | 1 | `U5:0x2934` | SET bit 2 of `0xAC18` |
| `0x5C` | 1 | `U5:0x293D` | SET bit 0 |
| `0x5D` | 1 | `U5:0x2941` | SET bit 3 |
| `0x5E` | 1 | `U5:0x2945` | CLEAR bits 0 + 2 |
| `0x5F` | 1 | `U5:0x2949` | SET bit 1 |
| `0x60` | 1 | `U5:0x294D` | CLEAR bit 1 |
| `0x66` | 1 | `U5:0x2951` | CLEAR bit 3 |

### 0xAA2A mode-flag pairs

| idx | ar | handler | action |
|---|---|---|---|
| `0x50` | 1 | `U4:0x1AFE` | CLEAR bit 2 of `0xAA2A` |
| `0x51` | 1 | `U4:0x1B05` | SET bit 2 of `0xAA2A` |
| `0x61` | 1 | `U4:0x1B37` | SET bit 3 of `0xAA2A` |
| `0x62` | 1 | `U4:0x1B42` | CLEAR bit 3 of `0xAA2A` |
| `0x34` | 1 | `U4:0x19DC` | SET bit 2 of `0xAA2A` + post-action (AMPEX `ESC R` = LINE INSERT per manual) |

### `0xABDD`-gated mode pairs on `0xABD3`

| idx | ar | handler | action |
|---|---|---|---|
| `0x53` | 1 | `U4:0x1B0D` | Mode off (`C=0`) — writes to `0xABD3` if `0xABDD=0` |
| `0x55` | 1 | `U4:0x1B20` | Mode on (`C=0xFF`) — same gate |
| `0x3F` | 1 | `U4:0x1A2D` | Pair: `C=0xFF` variant |
| `0x54` | 1 | `U4:0x1B1B` | Pair: `C=0x00` variant |

### Other mode toggles and flags

| idx | ar | handler | role |
|---|---|---|---|
| `0x78` | 1 | `U4:0x09E0` | **Clear mode-flag bit 7** and flag at `0xAD79` (AMPEX `ESC '`). |
| `0x2C` | 1 | `U4:0x19B0` | Set flag `0xABD2 = 0xFF` (AMPEX `ESC O`). |
| `0x30` | 1 | `U4:0x19CB` | Toggle byte `0xAB2C` (XOR 0xFF). |
| `0x59` | 1 | `U5:0x33E4` | PROT ON: clear bit 5 of `0xAA2A`, set bit 7 of mode-flags (AMPEX `ESC &`). |
| `0x72` | 1 | `U4:0x0AAB` | Mode clear (`C=0`) at `l0a5e` — AMPEX `ESC 2` = tab clear at column. |
| — | 1 | `U4:0x0AA7` | Sibling: mode set (`C=0xFF`) — AMPEX `ESC 1` / sibling. |
| `0x6C` | 1 | `U4:0x0A55` | Pair-mode `A=0`. Sibling `U4:0x0A59` sets `A=1`. AMPEX `ESC 3` = clear all tab stops. |
| `0x4E` | 1 | `U4:0x1AF6` | Scroll/page op with `C=2`. AMPEX `ESC @`. |
| `0x35` | 1 | `U4:0x19E4` | Scroll/page op with `C=1`, stores to `0xABF7`. AMPEX `ESC J` = previous page. |
| `0x33` | 1 | `U4:0x19D4` | Conditional call — if `0xABD1=0`, invoke `sub_1276`. AMPEX `ESC P`. |
| `0x4F` | 1 | `U6:0x462A` | Various mode. AMPEX/VT52 `ESC i`. |

### Attribute response / "N vs O" pair

| idx | ar | handler | role |
|---|---|---|---|
| `0x2E` | 1 | `U4:0x19C2` | **Transmit 'N'** (VT52 `ESC =` / keypad-numeric response). |
| `0x2F` | 1 | `U4:0x19C7` | **Transmit 'O'** (VT52 `ESC >` / keypad-application response). |

(VT52 `ESC =` / `ESC >` toggle keypad mode on the host side. The
terminal simply echoes N or O as the canonical response byte.)

### Parameter-reading handlers

| idx | ar | handler | role |
|---|---|---|---|
| `0x04` | 5 | `U4:0x18B4` | **Set time** HH:MM. Range-checks, writes `0xAAA6`/`0xAAA8`. AMPEX `ESC }`. |
| `0x07` | 4 | `U4:0x18FA` | **Set 2-digit BCD** into a 5-entry table at `0xAD6B`. |
| `0x18` | 2 | `U4:0x1920` | **Sub-dispatcher** `ESC M <letter>`: reads a byte, dispatches via jump table at `U5:0x21DC`. |
| `0x1B` | 2 | `U4:0x1972` | **Switch emulation** `ESC 8 <n>`: reads byte 0x20..0x2A, maps via `U4:0x199B`, writes `0xAABB[3:0]`. |
| `0x20` | 2 | `U5:0x28C7` | **Read 1 param** (-0x20 encoding), call `l3720`. VT52 `ESC {`. |
| `0x21` | 2 | `U5:0x28CE` | **Bit-0 dispatch** on 1 param: routes to `l24a4` or `l2545`. |
| `0x22` | 2 | `U5:0x28D7` | **Sub-dispatcher** on `'1'`/`'2'`. |
| `0x23` | 2 | `U5:0x28E3` | **Set variable `0xAB2F`** from 1 byte. |
| `0x24` | 2 | `U5:0x28E8` | **Set variable `0xABED`** from 1 byte. |
| `0x1C` | 2 | `U5:0x2840` | Read 1 digit (`SUB 0x20`), tests < 9. |
| `0x1D` | 2 | `U5:0x285E` | Read 1 byte, compare to `'1'`. |
| `0x1F` | 2 | `U5:0x28BB` | **Sub-dispatcher** on `'H'` / `'F'`. |
| `0x06` | 4 | `U5:0x34E8` | Read digit (`SUB 0x30`), compare against `0xABF9`. |
| `0x0E` | 3 | `U5:0x2799` | **Region command** — reads 2 position params to `0xAC16`/`0xAC17`, then action at `sub_27D5`. |
| `0x0B` | 3 | `U5:0x36DF` | Mode-gated 3-byte command. |
| `0x0F` | 3 | `U5:0x3519` | Companion to `0x0C` — alternate cursor-address variant. |
| `0x10` | 3 | `U5:0x27DC` | 3-byte command (bit-0 tested). |
| `0x11` | 3 | `U5:0x27EB` | **Cursor address alt**: reads 2 bytes into B, C. |
| `0x19` | 2 | `U4:0x192C` | Read byte, store to cursor col via `0xABD0`. |
| `0x27` | 1 | `U4:0x19A7` | **Write 1 byte with current attribute** to screen (via `sub_177F`). |
| `0x2D` | 1 | `U4:0x19B6` | **Read char under cursor + CR** back to host (`sub_179C`, `(0xC000)`, `RST 18h`). |

### Triplet mode-state setters

A three-handler group at `U4:0x1A75..0x1A83` that all jump to `l1A79` /
`l1A5C` with different `(D, C, E)` preloads. Each writes a different
combination of bits to `0xAA2E` (NVRAM-backed) and `0xABD0` (display
mode):

| idx | ar | handler | preload |
|---|---|---|---|
| `0x45` | 1 | `U4:0x1A75` | `D=0, C=0, E=0x0F` — clears all three bits |
| `0x46` | 1 | `U4:0x1A7D` | `D=0x08, C=0x04, E=0x0F` — sets bit 3 of 0xAA2E, bit 2 of 0xABD0 |
| `0x47` | 1 | `U4:0x1A83` | `D=0x02, C=0x01, E=0x0F` — sets bit 1 / bit 0 |

Likely "set screen type 0/1/2" (40-col / 80-col / 132-col) or a scroll-
mode triplet.

### Conditional action (cursor-dependent)

| idx | ar | handler | role |
|---|---|---|---|
| `0x48` | 1 | `U4:0x1A89` | **Cursor-right** if `sub_0b79h` returns 0; else fall through to complex insert-line body. |
| `0x63` | 1 | `U4:0x1B72` | Dual action: if `(rst08_handler) & mode = 0` → set `0xAA2A` bit 6 and display-mode bit 4; else call `sub_1b49`. |
| `0x6F` | 1 | `U4:0x1B97` | Sibling pair with 0x63 (clear-variant). |

### Minor / miscellaneous

| idx | ar | handler | role |
|---|---|---|---|
| `0x32` | 2 | `U5:0x2A39` | Page counter read/inc via `0xAD77`. |
| `0x42` | 1 | `U5:0x340C` | Mode-gated action. AMPEX `ESC I`, VT52 `ESC /`. |
| `0x49` | 1 | `U5:0x2924` | `sub_388d` then cursor apply. AMPEX `ESC N`. |
| `0x4A` | 1 | `U6:0x4645` | Save/restore cursor (uses `0xABD7`/`0xABD8`). AMPEX `ESC 1`. |
| `0x4C` | 1 | `U5:0x2737` | Clear attribute `0xAC19`; read `0xAC1D`. AMPEX `ESC z`. |
| `0x56` | 1 | `U4:0x1B24` | Call `l1d4e` with `C=3`. |
| `0x57` | 1 | `U4:0x1D44` | Conditional transmit based on SET-UP flags bit 1. |
| `0x5A` | 1 | `U4:0x1B2A` | Mode `0xABD1`-gated write to `0xAA8B`. |
| `0x65` | 1 | `U6:0x46D5` | AMPEX `ESC X` (CTRL2 start per manual). |
| `0x67` | 1 | `U6:0x4714` | AMPEX `ESC F` / VT52 `ESC .` — likely "select char set". |
| `0x6B` | 1 | `U5:0x2A0F` | **Identify response** — transmit terminal ID. VT52 `ESC Z`. |
| `0x6E` | 1 | `U5:0x2957` | Cursor-up with bounds check (AMPEX `ESC I` — reverse linefeed / cursor up). |
| `0x29` | 1 | `U6:0x446F` | Paired with `0x44E8` family. |
| `0x2A` | 1 | `U6:0x4588` | Fill / erase variant. |
| `0x2B` | 1 | `U6:0x44E8` | **Attribute bit-7 set** on `0xAC28`. AMPEX `ESC +`. |
| `0x31` | 1 | `U6:0x46CE` | AMPEX `ESC 0`. |
| `0x38` | 1 | `U4:0x1A0A` | Transmit literal char. |
| `0x39` | 1 | `U4:0x1A21` | OR 0x40 into `0xAA2E`, clear mode-flag bit 5. |
| `0x44` | 1 | `U4:0x1A4D` | OR 0x01 into `0xAA2E` + NVRAM, OR 0x10 into `0xABD0`. |
| `0x43` | 1 | `U6:0x452E` | AMPEX `ESC C`. |

### Ampex `ESC a..q` single-letter mode cluster

In addition to the bit-toggle cluster at `j..q`, letters `a..i` map
to a scattered set of single-byte mode handlers. These aren't a visual
cluster — each letter maps to an independent small routine for that
mode. See `resolved_handlers.txt` for the full mapping per emulation.

## Cross-emulation handler aliasing

The same handler can be reached by *different* letters in different
emulations. The most common examples (each worth one line of
documentation):

- `U5:0x3523` — reached by AMPEX `ESC =`, VT52 `ESC Y`, REG25/VIEWP `ESC Y`.
- `U6:0x4445` — reached by AMPEX `ESC Y`, VT52 `ESC J`, REG25/VIEWP `ESC J`.
- `U6:0x43D5` — reached by AMPEX `ESC T`, VT52 `ESC K`, REG25 `ESC K`.
- `U6:0x43CB` — reached by AMPEX `ESC t`, VT52 `ESC t`.

This is the whole point of the per-emulation translation table:
re-letter the pool of ~50 action routines.

## The `ESC M <letter>` sub-dispatch (U5:0x21DC)

`ESC M` (handler index `0x18` at `U4:0x1920`) reads one parameter byte,
subtracts `'/' (0x2F)`, and — if the result is `< 0x26` — indexes into
a 16-bit little-endian jump table at `U5:0x21DC`. The table provides
an alternate entry-point to many of the same action routines:

| Offset | ASCII of param | Target | Role |
|---|---|---|---|
| 0x00 | `/` | `U4:0x1CC2` | (unclassified small handler) |
| 0x01 | `0` | `U5:0x29D8` | — |
| 0x02 | `1` | `U4:0x1CC2` | — |
| 0x03 | `2` | `U4:0x1CC2` | — |
| 0x04 | `3` | `U5:0x270E` | — |
| 0x05 | `4` | `U5:0x2705` | — |
| 0x06 | `5` | `U4:0x19C2` | **transmit 'N'** (same as idx 0x2E) |
| 0x07 | `6` | `U4:0x19C7` | **transmit 'O'** (same as idx 0x2F) |
| 0x08 | `7` | `U4:0x1CC3` | — |
| 0x09 | `8` | `U5:0x28ED` | **graphics ON** (same as idx 0x3A) |
| 0x0A | `9` | `U5:0x2903` | **graphics OFF** (same as idx 0x3B) |
| 0x0B | `:` | `U5:0x2A0F` | **identify response** (same as idx 0x6B) |
| 0x0C | `;` | `U5:0x2A39` | page counter op |
| 0x0D | `<` | `U4:0x1CCF` | — |
| 0x0E | `=` | `U5:0x292A` | — |
| 0x0F | `>` | `U4:0x1CD9` | — |
| 0x10 | `?` | `U8:0xB000` | **Star overlay entry** |
| 0x11 | `@` | `U5:0x2A53` | — |
| 0x12 | `A` | `U5:0x2A9E` | — |

`ESC M` therefore acts as an emulation-neutral alias for core handlers
— useful when an emulation has re-purposed the single-letter command
that normally reaches the action.

## What is still unclassified

Approximately 20 of the 132 jump-table slots remain with only a coarse
description (e.g. "mode-gated action", "sub-dispatcher") and no
authoritative name. Most are in the `U5:0x28xx..0x29xx` range (VT52-
specific variants) and the `U6:0x46xx..0x47xx` range (SET-UP-adjacent
handlers). Naming them precisely requires either (a) tracing their
RAM writes against specific emulation behavior on a live terminal, or
(b) access to per-emulation reference manuals (TV920 / H1500 / ADM5).

For operational purposes — driving the D-175 from SerialTetris-style
code — the classified handlers cover all the cursor-motion, erase,
cursor-address, attribute and mode-toggle primitives, which is the
useful surface area.
