# MIME-2A — F8 ROM disassembly

Hand-curated, round-trip-verified disassembly of the four CPU-side ROMs of
the Micro-Term Inc. MIME-2A serial terminal. The terminal is built on a
**Mostek/Fairchild MK3850 + MK3853 SMI** F8 platform with an AY-5-1013A
UART; mainboard hardware identification and photos live one directory up
in `../mainboard/`.

Every byte of every CPU-side ROM round-trips byte-for-byte through
`unidasm → relabel.py → asl → p2bin`, so changes to `.sym` symbol naming
never affect the binary; the `.asm` listings are derived artefacts.

## ROMs

| Label | File                                      | Base       | Size  | Status        |
|-------|-------------------------------------------|------------|-------|---------------|
| U1    | `../roms/f2708_eprom_u1_6eaf59ae.bin`     | `H'0000'`  | 1 KB  | code, CONFIRMED |
| U12   | `../roms/mm2708q_eprom_u12_7162a6cc.bin`  | `H'0400'`  | 1 KB  | code, CONFIRMED |
| U22   | `../roms/mm2708q_eprom_u22_7c7cc3dd.bin`  | `H'0800'`  | 1 KB  | code, CONFIRMED |
| U55   | `../roms/mm2716q_eprom_u55_08658dd6.bin`  | `H'0C00'`  | 2 KB  | data-only (round-trips)|

The fifth ROM, `U39` (EA 8316E244 mask ROM), is **not in the CPU address
space** — it is wired to the video shift-register chain and the keyboard
scanner. See `load_address_verification.md` for evidence.

## Files

- `Makefile` — disasm + round-trip pipeline (uses `unidasm`, `asl`, `p2bin`)
- `*.sym` — hand-curated labels (one per code ROM) — **source of truth**
- `*.asm` — relabelled disassembly listings — **regenerable**, committed
  for review without rebuilds
- `tools/relabel.py` — converts unidasm raw output into asl-compatible
  source: strips bytes prefix, retags `R0..R11` → numeric, `DC H'NN' (?)`
  → `DB H'NN'`, branch-mnemonic-to-explicit-`BT`/`BF` keyed on opcode,
  trims phantom multi-byte instructions at ROM boundary
- `tools/extract_strings.py`, `tools/f8_jump_tables.py` — analysis helpers
- `strings_*.txt`, `jump_tables_*.txt` — extracted analysis artefacts
- `checksums.txt` — sha256 of the source ROMs in `../roms/`
- `load_address_verification.md` — Phase-1 evidence per ROM
- `memory_map.md` — system-wide address map and I/O port table
- `handlers.md` — Phase-3 catalogue of identified routines

## Quick commands

```bash
make              # regenerate all .asm listings from .sym + ROM
make strings      # extract printable runs into strings_*.txt
make verify       # round-trip: re-assemble each .asm and hash-compare to ROM
make clean        # remove all generated artefacts
```

`make verify` reports one ✓ line per ROM with the rebuilt sha256 — the
round-trip is the primary correctness signal for any change to `.sym`
or to `tools/relabel.py`.

## Toolchain

- **unidasm** — MAME's universal disassembler with `-arch f8`. Use any
  recent MAME build; this project was developed against `0.264`.
- **asl** — Macroassembler AS by Alfred Arnold. Build from
  <https://github.com/Macroassembler-AS/asl-releases> (`upstream`
  branch). The Makefile passes `-cpu MK3850 -relaxed` so AS accepts the
  Mostek `H'NN'` literal syntax that unidasm emits.
- **p2bin** — bundled with AS.

## Status — current findings

### What's confirmed

- **Reset path**: U1:H'0000' → `JMP H'0800'` → U22:`dispatch_table[0]` →
  U22:`boot_init` (H'0818').
- **Boot init body** (lines 818..85a in `U22.asm`): zeroes the CPU ports,
  reads CPU-port-0 bit 1 into a configuration shadow, programs the SMI
  interrupt vector to `H'0B99'`, clears the screen via a `DCI H'5062'` /
  `LR H,DC` / `LI H'20' ; ST` loop, then jumps into `H'029F'` in U1
  (the running-state main loop).
- **SMI ISR** at U22:`H'0B99'`. Prologue saves A/W/ISAR/QU/QL/DC, then
  `DCI H'8000'` and `LM` to read the byte that triggered the interrupt
  — almost certainly the **AY-5-1013A's received-data register**.
- **Cross-ROM call structure**: U1 is the byte-translation / decoder
  layer, U12 is the helper library, U22 holds dispatch + boot + ISR.
- **U55 is glyph/attribute data** (not code).
- **MK3853 SMI strap** = ports `H'0C..H'0F'` (default), confirmed by the
  `OUTS H'0C' / OUTS H'0D' / OUTS H'0E'` sequence at U22:`H'083D'..H'0843'`.

### What's open (next-pass priorities)

1. Trace the main loop starting at U1:`H'029F'`.
2. Identify the body of `smi_isr` past the prologue — the dispatched
   target almost certainly leads to a UART-RX-byte → ESC-state-machine
   handler, mirroring the Ampex emulation_codes structure.
3. Map the per-mode `mode_entry_*` targets in U22 (indices 1..7 of the
   primary dispatch table).
4. Confirm `H'5062'` as the VRAM cursor base and identify the screen extent
   (e.g. by following the cursor-advance helper at U12:`H'0612'`).
5. Identify the role of CPU port 0 / port 1 bit assignments (UART data
   path vs status latch) and the meaning of long-form `IN H'32'` /
   `OUT H'93'` external accesses.
