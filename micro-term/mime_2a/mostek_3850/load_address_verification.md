# Load address verification

Phase-1 evidence for each ROM. Each load address is independently verified
before symbol curation begins.

## Status legend

- **HYPOTHESIS** — guessed from socket position or ROM size; not yet verified
- **EVIDENCE GATHERED** — at least one piece of evidence supports the address
- **CONFIRMED** — 2+ pieces of independent evidence
- **DATA-ONLY** — ROM does not contain executable code; all bytes treated as `DB`

---

## `U1` — base `H'0000'` — STATUS: **CONFIRMED**

- **Byte 0..2**: `29 08 00` → `JMP H'0800'` — F8 reset vector hands off to U22.
- **First instructions** at H'0003' onward: `LI H'7F'`, `NS 4`, `LR 4,A`,
  `BR H'004E'`, … — coherent F8 instruction stream, no illegal opcodes.
- **Cross-ROM references** detected in `jump_tables_U1.txt` (PI tables):
  - `H'00EC'` → `H'06F8'`, `H'0703'` (in U12)
  - `H'013B'` → `H'0612'`, `H'04DB'` (in U12)
  - `H'0159'` → `H'058F'`, `H'05F5'` (in U12)
  - `H'0188'` → `H'058F'`, `H'05FB'` (in U12)
  - `H'0195'` → `H'058F'`, `H'0601'` (in U12)
  - All targets land in U12's hypothesised range — strong corroboration that
    both U1 and U12 are placed correctly.
- **Round-trip**: `make verify` reports `✓ U1: round-trip exact`
  (sha256 `b47fd0b0…ca48d67`).

## `U12` — base `H'0400'` — STATUS: **CONFIRMED**

- **Byte 0..2** disassembles cleanly as F8 instructions; no illegal opcodes
  scattered through the ROM (a wrong base would produce widespread invalid
  opcodes from mid-instruction landings).
- **Inbound cross-ROM references** from U1 (8 distinct PI targets, see U1
  section) and U22:
  - U22 `H'0A19'` → `H'05FB'`, `H'0624'` (in U12)
  - U22 `H'0B47'` → `H'0593'`, `H'0793'` (in U12)
- **Internal PI tables** stay within U12's range:
  - `H'0450'` → `H'0612'`, `H'05B4'`
  - `H'04E7'` → `H'0712'`, `H'05E9'`
  - `H'04F0'` → `H'0712'`, `H'05FB'`
- **Trailing 0xFF padding** at `H'07F0..H'07FF'` is consistent with an
  unprogrammed-EPROM tail (visible as `DB H'FF' / LR A,KU` pairs in
  `U12.asm`); a 1 KB EPROM ending exactly at `H'07FF'` matches a base of
  `H'0400'`.
- **Round-trip**: `make verify` reports `✓ U12: round-trip exact`
  (sha256 `60a23709…29b8f54d`).

## `U22` — base `H'0800'` — STATUS: **CONFIRMED**

- **Byte 0..2** = `29 08 18` → `JMP H'0818'` — first entry of an 8-entry
  primary dispatch table at `H'0800'..H'0817'`.
- **Primary jump table** (from `jump_tables_U22.txt`): all 8 entries land
  in U22's range, indicating intra-ROM dispatch:
  - `H'0818'` (boot init), `H'09F9'`, `H'0A10'`, `H'0A19'`, `H'0A1F'`,
    `H'0A31'`, `H'0B81'`, `H'0B41'`.
- **Cold-init signature** at `H'0818'`: `70 B0 B1` = `LIS 0 ; OUTS 0 ; OUTS 1`
  — the canonical F8 boot sequence (zero A, clear both CPU ports).
  Subsequent bytes are scratchpad-init (`LISU/LISL/LR S,A`).
- **Inbound reference**: U1 reset (`H'0000'`) → `JMP H'0800'`, lands exactly
  on the dispatch table.
- **Outbound cross-ROM references**: U22 PI calls reach U12 at `H'0593'`,
  `H'05FB'`, `H'0624'`, `H'0793'` — proves U22 talks to U12, consistent
  with a layered system architecture (boot/main code in U22, ESC handlers
  and helpers in U12).
- **Round-trip**: `make verify` reports `✓ U22: round-trip exact`
  (sha256 `cd71f42e…be6f208`).

## `U55` — base `H'0C00'` — STATUS: **DATA-ONLY** (re-classified)

The README hypothesised U55 holds video display code, but the byte
distribution and string analysis say otherwise:

- **Byte distribution** (from a quick histogram): 621 zeros, 512 `0xFF`, only
  915 "other" bytes out of 2048. A code ROM is not that sparse.
- **Glyph-bitmap signature** in `strings_U55.txt`: periodic short ASCII runs
  every ~64 bytes (e.g. `<\<:<` at `H'0E61'`, `>B@B~` at `H'1061'`,
  `IBBBB@` at `H'106D'`). Each run is a column-of-bits row pattern from a
  raster glyph — exactly the shape of a 64-byte-per-glyph font table.
- **No inbound `JMP`/`PI` from U1, U12, or U22 land in `H'0C00..H'13FF'`.**
  (Confirmed by grepping the relabelled `.asm` files for `H'0C..`/`H'10..`/
  `H'13..` literals — none appear as code targets.) The only way U55 is
  read is via `DCI <addr>` + `LM`, the F8 data-counter mechanism for
  reading non-CPU-mapped tables.
- **Inference**: U55 is a second character-generator / attribute / glyph
  table extending what U39 (the masked char-gen ROM, not in CPU map)
  already provides. The CPU loads `DC` to a U55 address and reads
  via `LM` to fetch glyph rows for the video shift register.

Despite being data, U55 round-trips through `make verify` because every
byte happens to disassemble and re-assemble identically when treated as
F8 opcodes. No re-classification work in the assembly listing is required
for round-trip success; semantic understanding of U55 is deferred to
Phase 2 (it will be re-presented as `DB` blocks once we identify the
glyph stride and any embedded keyboard/attribute tables).

- **Round-trip**: `make verify` reports `✓ U55: round-trip exact`
  (sha256 `b2597868…059c7135`).

---

## `U39` — char-gen + keyboard ROM, **NOT CPU-MAPPED**

Bundled here for completeness. Not part of the disassembly project.

- **Strings**: `QWERTY`, `ASDFGH`, repeated keyboard-layout fragments
  visible in raw `strings` output of the binary. These are keyboard
  decode tables and 5×7 (or similar) glyph patterns.
- **Hardware position** (from `mainboard/README.md`): adjacent to the
  video shift-register chain and the keyboard connector — not on the
  CPU's data bus.
- **Implication**: not addressable by the F8 CPU; not loadable via DCI.
  Read in parallel by the dot-clock chain (for character glyphs) and
  by the keyboard scanner (for ASCII-from-row/col lookup). Treated as
  passive hardware data — disassembly N/A.
- File: `../roms/ea_8316e244_mask_rom_u39_f12e73c0.bin` (sha256 see
  `checksums.txt`).
