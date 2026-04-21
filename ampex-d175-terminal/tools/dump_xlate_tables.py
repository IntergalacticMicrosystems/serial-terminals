#!/usr/bin/env python3
"""Extract and reconstruct the per-emulation ESC-command translation tables.

Background (re-derived from disassembly, NOT from agents.md):

  The firmware dispatches ESC sequences via a 160-byte RAM table at 0xA983..0xAA22,
  indexed by the received command byte (0x00..0x9F).  The table holds an
  arity/handler code:

      tbl[cmd] == 0          -> unimplemented  (arity 1, no-op handler)
      tbl[cmd] in  1..5      -> arity 5 (command + 4 params)
      tbl[cmd] in  6..10     -> arity 4
      tbl[cmd] in 11..20     -> arity 3
      tbl[cmd] in 21..40     -> arity 2
      tbl[cmd] >= 41         -> arity 1 (the value itself is a handler index)

  On emulation change the firmware loader at U4:0x0381 copies one of three
  *base* tables from ROM to RAM, then applies a small per-emulation "patch
  record" that overwrites a handful of slots.  That's why shared-letter
  commands (e.g. ESC Y) behave differently per emulation: only the patched
  entries in the active table drive dispatch.

Sources (addresses are ROM-relative):

  Base 1  -- emulations 0..6  (AMPEX IQ120 REG25 ADM5 VIEWP VT52 TV920)
     U4 0x1DEE..0x1E4D  ->  RAM 0xA9A3..0xAA02  (96 B, commands 0x20..0x7F)
     U4 0x1D61..0x1D80  ->  RAM 0xAA03..0xAA22  (32 B, commands 0x80..0x9F)

  Base 2  -- emulation 7       (TV950)
     U5 0x2014..0x2073  ->  RAM 0xA9A3..0xAA02  (96 B)
     U4 0x1D61..0x1D80  ->  RAM 0xAA03..0xAA22  (32 B)

  Base 3  -- emulations 8..10  (H1500, H1410, H1420)
     U4 0x1F1E..0x1F9D  ->  RAM 0xA983..0xAA02  (128 B, commands 0x00..0x7F)
     U4 0x1DCB..0x1DEA  ->  RAM 0xAA03..0xAA22  (32 B, commands 0x80..0x9F)

  Patch pointer tables (each entry is the address of a patch record):
     U4 0x0433    -- emuls 0..6 first-pass patches into 0xA983 region
     U4 0x0445    -- emuls 1..6 second-pass patches into 0xAA03 region
     U4 0x0441    -- emuls 9..10 patches

  A patch record is `<count> <off> <val> <off> <val> ...` -- for each pair the
  byte at `base + off` is overwritten with `val`.

This script reads the raw ROM dumps and prints:

  * Each reconstructed RAM table (0xA983..0xAA22, 160 B) per emulation.
  * A concise per-command summary: byte, letter, arity, raw value.
"""
import os

ROM_DIR = os.path.join(os.path.dirname(__file__), "..", "EPROM_dumps")

def load(name):
    with open(os.path.join(ROM_DIR, name), "rb") as f:
        return f.read()

U4 = load("U4-TMS2764JL.bin")  # base 0x0000, 8 KB
U5 = load("U5-TMS2764JL.bin")  # base 0x2000, 8 KB

EMULATIONS = [
    "AMPEX",  "IQ120",  "REG25",  "ADM5",
    "VIEWP",  "VT52",   "TV920",  "TV950",
    "H1500",  "H1410",  "H1420",
]


def read_patch_record(rom, rom_base, ptr_table_addr, index):
    """Read the patch record for the given index out of a ROM pointer table."""
    off = ptr_table_addr - rom_base + 2 * index
    addr = rom[off] | (rom[off + 1] << 8)
    rec_off = addr - rom_base
    count = rom[rec_off]
    pairs = []
    for i in range(count):
        o = rom[rec_off + 1 + 2 * i]
        v = rom[rec_off + 2 + 2 * i]
        pairs.append((o, v))
    return addr, pairs


def build_ram_table(emul_index):
    """Reconstruct the 160-byte RAM table at 0xA983 for the given emulation."""
    ram = bytearray(160)  # covers 0xA983..0xAA22
    if emul_index <= 6:
        # Base 1
        ram[0x00:0x20] = b"\x00" * 0x20                         # 0xA983..0xA9A2 cleared
        ram[0x20:0x80] = U4[0x1DEE:0x1DEE + 0x60]               # 0xA9A3..0xAA02
        ram[0x80:0xA0] = U4[0x1D61:0x1D61 + 0x20]               # 0xAA03..0xAA22
        # First-pass patch into the 0xA983 region
        _, first = read_patch_record(U4, 0, 0x0433, emul_index)
        for off, val in first:
            ram[off] = val  # patch offset is relative to 0xA983
        # Second-pass patch into the 0xAA03 region -- only for emuls 1..6
        if emul_index >= 1:
            _, second = read_patch_record(U4, 0, 0x0445, emul_index - 1)
            for off, val in second:
                ram[0x80 + off] = val
    elif emul_index == 7:
        # TV950 -- base 2
        ram[0x00:0x20] = b"\x00" * 0x20
        ram[0x20:0x80] = U5[0x0014:0x0014 + 0x60]               # U5:0x2014 -> offset 0x14 within U5
        ram[0x80:0xA0] = U4[0x1D61:0x1D61 + 0x20]
        # TV950 uses the 7th entry of the 0x0445 pointer table (emuls 1..6 use entries 0..5).
        # Loader flow: cp 007h; jr z, l03bfh; ... ; jr l03b3h; dec a (A=6);
        #              ld hl, l0445h; call sub_041fh  -> fetches table[6] = 0x1DBE.
        # Record at 0x1DBE is a legitimate 6-pair patch into the 0xAA03 region.
        _, patch = read_patch_record(U4, 0, 0x0445, 6)
        for off, val in patch:
            ram[0x80 + off] = val
    else:
        # Emul 8..10 -- base 3
        ram[0x00:0x80] = U4[0x1F1E:0x1F1E + 0x80]               # 0xA983..0xAA02
        ram[0x80:0xA0] = U4[0x1DCB:0x1DCB + 0x20]               # 0xAA03..0xAA22
        if emul_index >= 9:
            # Patch table at 0x0441 for emuls 9..10 (index = emul - 9)
            _, patch = read_patch_record(U4, 0, 0x0441, emul_index - 9)
            for off, val in patch:
                ram[off] = val
    return ram


def arity_of(val):
    if val == 0: return 1, "unimpl"
    if val < 6:  return 5, f"idx{val}"
    if val < 11: return 4, f"idx{val}"
    if val < 21: return 3, f"idx{val}"
    if val < 41: return 2, f"idx{val}"
    return 1, f"h{val:02X}"


def print_table(emul_index):
    name = EMULATIONS[emul_index]
    ram = build_ram_table(emul_index)
    print(f"\n== Emulation {emul_index}: {name} ==")
    print("  cmd  chr  val  arity  note")
    for cmd in range(0xA0):
        v = ram[cmd]
        if v == 0:
            continue
        ar, note = arity_of(v)
        ch = chr(cmd) if 0x20 <= cmd < 0x7F else "."
        print(f"  0x{cmd:02X}  {ch:>3}  0x{v:02X}   {ar}     {note}")


def main():
    for i in range(len(EMULATIONS)):
        print_table(i)


if __name__ == "__main__":
    main()
