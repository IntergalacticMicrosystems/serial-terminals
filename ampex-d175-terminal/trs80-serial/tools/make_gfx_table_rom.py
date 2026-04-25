#!/usr/bin/env python3
"""Assemble a TRS-80 Model I ROM that lays out graphic chars 0x80-0xBF in a
labelled table — analogous to SerialTetris/vt52_graphics_table.py, but
written from the TRS-80 side so the whole emulator->Ampex rendering path
is exercised.

Layout produced in VRAM (64x16):

    row 0:     0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
    row 1:   (blank)
    row 2:  8: [80][81][82][83][84]...[8F]
    row 3:   (blank)
    row 4:  9: [90]...[9F]
    row 5:   (blank)
    row 6:  A: [A0]...[AF]
    row 7:   (blank)
    row 8:  B: [B0]...[BF]

Usage:  python3 make_gfx_table_rom.py [-o path]
Default output path: gfx_table.rom in the cwd.
"""
import sys
from pathlib import Path

ROM_SIZE = 12 * 1024           # matches a typical Model I Level II ROM
VRAM     = 0x3C00
STACK    = 0x4100              # top of our small stack (below BASIC RAM area)


def assemble() -> bytes:
    rom = bytearray()

    def emit(*bs):
        for b in bs:
            assert 0 <= b <= 0xFF, f"byte out of range: {b:#x}"
        rom.extend(bs)

    def emit_word_le(w):
        emit(w & 0xFF, (w >> 8) & 0xFF)

    def djnz_back(target):
        # DJNZ: opcode 0x10, then signed 8-bit offset from the byte
        # following the DJNZ instruction (PC after consuming the 2 bytes).
        pc_after = len(rom) + 2
        off = target - pc_after
        assert -128 <= off <= 127, f"DJNZ out of range: {off}"
        emit(0x10, off & 0xFF)

    def jr_back(target):
        pc_after = len(rom) + 2
        off = target - pc_after
        assert -128 <= off <= 127, f"JR out of range: {off}"
        emit(0x18, off & 0xFF)

    # ---- init ----
    emit(0xF3)                        # DI
    emit(0x31); emit_word_le(STACK)   # LD SP, STACK

    # ---- clear VRAM with space (0x20) ----
    emit(0x21); emit_word_le(VRAM)    # LD HL, VRAM
    emit(0x36, 0x20)                  # LD (HL), 0x20
    emit(0x11); emit_word_le(VRAM+1)  # LD DE, VRAM+1
    emit(0x01, 0xFF, 0x03)            # LD BC, 0x03FF   (1023)
    emit(0xED, 0xB0)                  # LDIR

    # ---- header row 0: labels at cols 3, 6, 9, ... ----
    # aligned with the data-row columns below.
    emit(0x21); emit_word_le(VRAM + 3)  # LD HL, 0x3C03
    emit(0x06, 0x10)                    # LD B, 16
    emit(0x3E, 0x30)                    # LD A, '0'
    hdr_top = len(rom)
    emit(0x77)                          # LD (HL), A
    emit(0x23, 0x23, 0x23)              # INC HL x3   (step 3 cols)
    emit(0x3C)                          # INC A
    emit(0xFE, 0x3A)                    # CP ':'
    emit(0x20, 0x02)                    # JR NZ, +2
    emit(0x3E, 0x41)                    # LD A, 'A'   (skip past ':')
    djnz_back(hdr_top)                  # DJNZ hdr_top

    # ---- four data rows: 8:, 9:, A:, B: ----
    def data_row(vram_row: int, label: int, gfx_base: int):
        addr = VRAM + vram_row * 64
        emit(0x21); emit_word_le(addr)     # LD HL, addr
        emit(0x36, label)                   # LD (HL), label
        emit(0x23)                          # INC HL
        emit(0x36, 0x3A)                    # LD (HL), ':'
        emit(0x23, 0x23)                    # INC HL x2  (now col 3)
        emit(0x1E, gfx_base)                # LD E, gfx_base
        emit(0x06, 0x10)                    # LD B, 16
        top = len(rom)
        emit(0x73)                          # LD (HL), E
        emit(0x23, 0x23, 0x23)              # INC HL x3
        emit(0x1C)                          # INC E
        djnz_back(top)

    data_row(2, ord('8'), 0x80)
    data_row(4, ord('9'), 0x90)
    data_row(6, ord('A'), 0xA0)
    data_row(8, ord('B'), 0xB0)

    # ---- hang forever ----
    hang = len(rom)
    jr_back(hang)

    assert len(rom) <= ROM_SIZE, f"ROM too large: {len(rom)} bytes"
    rom.extend(bytes(ROM_SIZE - len(rom)))
    return bytes(rom)


def main():
    out = Path(sys.argv[sys.argv.index("-o") + 1]) if "-o" in sys.argv else Path("gfx_table.rom")
    data = assemble()
    out.write_bytes(data)
    print(f"wrote {out} ({len(data)} bytes)")


if __name__ == "__main__":
    main()
