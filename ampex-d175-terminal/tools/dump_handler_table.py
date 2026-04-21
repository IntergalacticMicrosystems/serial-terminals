#!/usr/bin/env python3
"""Dump the master handler jump table at U5:0x20AA.

The dispatcher at U4:0x0AAF does:
    ld a, c               ; C = byte from 0xA800 ring (with bit 7 set)
    and 0x7F              ; strip bit 7 -> command letter
    ld c, a
    ld hl, 0xA983         ; translation table (RAM, per-emulation)
    ld b, 0
    add hl, bc            ; HL = &RAM[cmd]
    ld a, (hl)            ; A = handler index (the value in the tbl)
    ld hl, 0x20AA         ; master jump table (ROM, U5)
    ld e, a
    ld d, 0
    add hl, de
    add hl, de            ; HL = 0x20AA + 2*A
    ld e, (hl); inc hl; ld d, (hl)
    ex de, hl
    jp (hl)               ; DISPATCH to handler in U5

So tbl-value N resolves to the handler at U5 address *(0x20AA + 2*N).
This script walks the jump table and prints each index with its handler
address. Cross-referenced with the translation tables, this lets us
name every (command, emulation) pair's concrete action routine.
"""
import os

U5 = open(os.path.join(os.path.dirname(__file__), "..", "EPROM_dumps",
                      "U5-TMS2764JL.bin"), "rb").read()

JUMP_TABLE_ADDR = 0x20AA
U5_BASE = 0x2000

# Inspect tbl-values actually used anywhere in the 11 reconstructed tables
# to decide how far the jump-table extends.
MAX_INDEX = 0x84  # covers observed values through 0x83

def read_word_le(rom, off):
    return rom[off] | (rom[off + 1] << 8)


def main():
    print(f"Master handler jump table at U5:0x{JUMP_TABLE_ADDR:04X}")
    print(f"({MAX_INDEX} entries × 2 bytes = 0x{MAX_INDEX*2:X} bytes, ending 0x{JUMP_TABLE_ADDR + 2*MAX_INDEX - 1:04X})")
    print()
    print("  idx   handler    location   comment")
    print("  ---   --------   --------   -------")
    rom_off = JUMP_TABLE_ADDR - U5_BASE
    for i in range(MAX_INDEX):
        handler = read_word_le(U5, rom_off + 2 * i)
        if U5_BASE <= handler < U5_BASE + len(U5):
            loc = "U5"
        elif 0x0000 <= handler < 0x2000:
            loc = "U4"
        elif 0x4000 <= handler < 0x5000:
            loc = "U6"
        elif 0xB000 <= handler < 0xC000:
            loc = "U8"
        else:
            loc = "???"
        # Annotate well-known indices from VT52 cross-check
        comments = {
            0x01: "arity 5", 0x02: "arity 5", 0x03: "arity 5",
            0x04: "arity 5", 0x05: "arity 5",
            0x06: "arity 4", 0x07: "arity 4", 0x08: "arity 4",
            0x09: "arity 4", 0x0A: "arity 4",
            0x0B: "arity 3", 0x0C: "arity 3 (VT52 ESC Y = cursor address)",
            0x0D: "arity 3", 0x0E: "arity 3", 0x0F: "arity 3",
            0x10: "arity 3", 0x11: "arity 3", 0x12: "arity 3",
            0x13: "arity 3", 0x14: "arity 3",
            0x15: "arity 2", 0x16: "arity 2", 0x17: "arity 2",
            0x18: "arity 2",
            0x36: "AMPEX ESC t alt / VT52 ESC K",
            0x37: "VT52 ESC J (erase to end of screen)",
            0x3A: "VT52 ESC F (graphics on)",
            0x3B: "VT52 ESC G (graphics off)",
            0x3C: "VT52 ESC A (cursor up)",
            0x3D: "VT52 ESC B (cursor down)",
            0x3E: "VT52 ESC H (home)",
            0x4D: "VT52 ESC C (cursor right)",
            0x52: "VT52 ESC D (cursor left)",
            0x6B: "VT52 ESC Z (identify)",
            0x81: "Ampex ESC t (erase to EOL)",
        }.get(i, "")
        print(f"  0x{i:02X}   0x{handler:04X}     {loc}         {comments}")


if __name__ == "__main__":
    main()
