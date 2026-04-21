#!/usr/bin/env python3
"""Resolve each (emulation, command) to its concrete U4/U5/U6 handler address.

Combines:
  - dump_xlate_tables logic: reconstructs the 160-byte RAM xlate table
    per emulation.
  - dump_handler_table logic: walks the U5:0x20AA master jump table.

For every non-no-op entry, prints `cmd letter -> (arity, handler addr)` so
a human can cross-reference against the raw disassembly.

The "no-op" handler is U5:0x2798 (a single RET). Any tbl-value whose jump
slot holds 0x2798 is suppressed here — that's the dispatcher's built-in
default for unimplemented commands.
"""
import os
import sys

HERE = os.path.dirname(__file__)
ROM_DIR = os.path.join(HERE, "..", "EPROM_dumps")

U4 = open(os.path.join(ROM_DIR, "U4-TMS2764JL.bin"), "rb").read()
U5 = open(os.path.join(ROM_DIR, "U5-TMS2764JL.bin"), "rb").read()

NOOP = 0x2798

EMULATIONS = [
    "AMPEX", "IQ120", "REG25", "ADM5", "VIEWP", "VT52",
    "TV920", "TV950", "H1500", "H1410", "H1420",
]


def wle(rom, off):
    return rom[off] | (rom[off + 1] << 8)


def read_patch_record(rom, ptr_table_addr, index):
    off = ptr_table_addr + 2 * index
    addr = wle(rom, off)
    count = rom[addr]
    return [(rom[addr + 1 + 2 * i], rom[addr + 2 + 2 * i]) for i in range(count)]


def build_ram_table(emul_index):
    ram = bytearray(0xA0)
    if emul_index <= 6:
        ram[0x00:0x20] = b"\x00" * 0x20
        ram[0x20:0x80] = U4[0x1DEE:0x1E4E]
        ram[0x80:0xA0] = U4[0x1D61:0x1D81]
        for off, val in read_patch_record(U4, 0x0433, emul_index):
            ram[off] = val
        if emul_index >= 1:
            for off, val in read_patch_record(U4, 0x0445, emul_index - 1):
                ram[0x80 + off] = val
    elif emul_index == 7:
        ram[0x00:0x20] = b"\x00" * 0x20
        ram[0x20:0x80] = U5[0x0014:0x0074]
        ram[0x80:0xA0] = U4[0x1D61:0x1D81]
        for off, val in read_patch_record(U4, 0x0445, 6):
            ram[0x80 + off] = val
    else:
        ram[0x00:0x80] = U4[0x1F1E:0x1F9E]
        ram[0x80:0xA0] = U4[0x1DCB:0x1DEB]
        if emul_index >= 9:
            for off, val in read_patch_record(U4, 0x0441, emul_index - 9):
                ram[off] = val
    return ram


def arity_from_value(v):
    if v == 0: return 1
    if v < 0x06: return 5
    if v < 0x0B: return 4
    if v < 0x15: return 3
    if v < 0x29: return 2
    return 1


def handler_addr(idx):
    # Jump table at U5:0x20AA, each entry 2 bytes little-endian
    off = 0x20AA - 0x2000 + 2 * idx
    if off + 1 >= len(U5):
        return None
    return wle(U5, off)


def resolve(emul_index, cmd):
    ram = build_ram_table(emul_index)
    v = ram[cmd]
    if v == 0:
        return None
    arity = arity_from_value(v)
    h = handler_addr(v)
    if h == NOOP:
        return (arity, v, h, "NOOP")
    if h is None:
        return (arity, v, h, "out-of-range")
    return (arity, v, h, "active")


def rom_of(addr):
    if 0x0000 <= addr < 0x2000: return "U4"
    if 0x2000 <= addr < 0x4000: return "U5"
    if 0x4000 <= addr < 0x5000: return "U6"
    if 0xB000 <= addr < 0xC000: return "U8"
    return "??"


def letter(c):
    return chr(c) if 0x20 <= c < 0x7F else "."


def print_emul(emul_index, include_noop=False):
    name = EMULATIONS[emul_index]
    print(f"\n=== {emul_index}: {name} ===")
    ram = build_ram_table(emul_index)
    print("  cmd  chr  v     ar  handler    loc   status")
    for cmd in range(0xA0):
        v = ram[cmd]
        if v == 0:
            continue
        ar = arity_from_value(v)
        h = handler_addr(v)
        status = "NOOP" if h == NOOP else "ACTIVE"
        if status == "NOOP" and not include_noop:
            continue
        print(f"  0x{cmd:02X}  {letter(cmd):>3}  0x{v:02X}  {ar}   0x{h:04X}     {rom_of(h)}    {status}")


def main():
    include_noop = "--all" in sys.argv
    if "--emul" in sys.argv:
        i = sys.argv.index("--emul")
        targets = [int(sys.argv[i + 1])]
    else:
        targets = range(len(EMULATIONS))
    for i in targets:
        print_emul(i, include_noop)


if __name__ == "__main__":
    main()
