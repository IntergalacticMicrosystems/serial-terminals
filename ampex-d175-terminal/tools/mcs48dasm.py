#!/usr/bin/env python3
"""MCS-48 (8039 / 8048 / 8049) disassembler.

Produces a z80dasm-style listing (label overlay via a .sym file, hex bytes,
mnemonics) so the output integrates with the existing disassembly layout in
this repo.

Usage:
    mcs48dasm.py [-S sym] [-g origin] [-o out.asm] in.bin

The .sym file format (compatible with the conventions used by the project's
existing z80dasm .sym files):
    # comments allowed
    NAME EQU $HHHH         ; alias for an absolute address
    HHHH NAME              ; label at that address (preferred form)
    HHHH NAME ; comment    ; label + trailing comment

When a label exists for an address, jump/call targets render as the label;
otherwise as 'L_HHHH'. Bytes the disassembler decides are data (because
nothing flowed there) render as `db $hh,$hh,...` lines, sixteen per line.

The decoder follows control flow from a set of entry points (reset vector
plus the two MCS-48 hardware interrupt vectors, plus any addresses the .sym
file marks with `+entry`). Reachable bytes get instructions; unreachable
bytes get a `db` block with offset/ASCII gutter.
"""

from __future__ import annotations

import argparse
import sys
from dataclasses import dataclass, field
from pathlib import Path


# ---------------------------------------------------------------------------
# Opcode table.
#
# Each entry is (mnemonic_template, length, kind).
#   length: 1 or 2 bytes
#   kind:   'normal' | 'jmp' | 'call' | 'cjmp' | 'ret' | 'jmppage'
#
# Mnemonic template substitutions performed at decode time:
#   {imm}   -> '#$hh'   (8-bit immediate; second byte)
#   {addr}  -> 11-bit absolute address rendered as label or '$hhh'
#              (page-in-PC instructions: 'JMP', 'CALL', 'JMPP @A')
#   {paddr} -> 8-bit page address inside current 256-byte page (JFx, JNT0...)
#   {bus}   -> 'BUS'
#   {p1}/{p2} -> 'P1'/'P2'
#
# References cross-checked against:
#  - Intel MCS-48 Family of Single-Chip Microcomputers User's Manual (1979)
#  - Intel "MCS-48 Microcomputer User's Manual" Sep 1980 reprint (Order 9800270)
#  - Donnelly's "8048 Instruction Set Summary" (matches MAME mcs48 disasm)
#
# Gaps marked '???' (illegal/undefined) are kept for completeness so that
# unreachable / data bytes never crash the decoder.
# ---------------------------------------------------------------------------

NORMAL = 'normal'
JMP    = 'jmp'        # unconditional, transfer-of-control, no fall-through
CALL   = 'call'       # transfer + fall-through
CJMP   = 'cjmp'       # conditional, fall-through + branch target
RET    = 'ret'        # no fall-through
JMPP   = 'jmppage'    # JMPP @A — jumps inside the current 256-byte page
                      # (we cannot statically resolve the table, so we treat
                      # this like RET for fall-through and emit a comment)

# JMP addr11   opcode = aaa00100, second byte = a7..a0
# CALL addr11  opcode = aaa10100, second byte = a7..a0
# Address hi 3 bits live in opcode; combined with 8-bit second byte give an
# 11-bit address (0..0x7FF). For 8039 with /MB selector the same encoding
# addresses 0x000-0x7FF in MB0 or 0x800-0xFFF in MB1.

OP = [None] * 256

# ---- direct per-opcode entries ----

def _set(code, mnem, length, kind=NORMAL):
    OP[code] = (mnem, length, kind)

# 0x00 .. 0x0F
_set(0x00, 'NOP',           1)
_set(0x02, 'OUTL BUS,A',    1)
_set(0x03, 'ADD  A,{imm}',  2)
_set(0x04, 'JMP  {addr}',   2, JMP)     # JMP 0xx (page 0, current bank)
_set(0x05, 'EN   I',        1)
_set(0x07, 'DEC  A',        1)
_set(0x08, 'INS  A,BUS',    1)
_set(0x09, 'IN   A,P1',     1)
_set(0x0A, 'IN   A,P2',     1)
_set(0x0C, 'MOVD A,P4',     1)
_set(0x0D, 'MOVD A,P5',     1)
_set(0x0E, 'MOVD A,P6',     1)
_set(0x0F, 'MOVD A,P7',     1)

# 0x10 .. 0x1F
_set(0x10, 'INC  @R0',      1)
_set(0x11, 'INC  @R1',      1)
_set(0x12, 'JB0  {paddr}',  2, CJMP)
_set(0x13, 'ADDC A,{imm}',  2)
_set(0x14, 'CALL {addr}',   2, CALL)    # CALL 0xx
_set(0x15, 'DIS  I',        1)
_set(0x16, 'JTF  {paddr}',  2, CJMP)
_set(0x17, 'INC  A',        1)
_set(0x18, 'INC  R0',       1)
_set(0x19, 'INC  R1',       1)
_set(0x1A, 'INC  R2',       1)
_set(0x1B, 'INC  R3',       1)
_set(0x1C, 'INC  R4',       1)
_set(0x1D, 'INC  R5',       1)
_set(0x1E, 'INC  R6',       1)
_set(0x1F, 'INC  R7',       1)

# 0x20 .. 0x2F
_set(0x20, 'XCH  A,@R0',    1)
_set(0x21, 'XCH  A,@R1',    1)
_set(0x23, 'MOV  A,{imm}',  2)
_set(0x24, 'JMP  {addr}',   2, JMP)     # JMP 1xx
_set(0x25, 'EN   TCNTI',    1)
_set(0x26, 'JNT0 {paddr}',  2, CJMP)
_set(0x27, 'CLR  A',        1)
_set(0x28, 'XCH  A,R0',     1)
_set(0x29, 'XCH  A,R1',     1)
_set(0x2A, 'XCH  A,R2',     1)
_set(0x2B, 'XCH  A,R3',     1)
_set(0x2C, 'XCH  A,R4',     1)
_set(0x2D, 'XCH  A,R5',     1)
_set(0x2E, 'XCH  A,R6',     1)
_set(0x2F, 'XCH  A,R7',     1)

# 0x30 .. 0x3F
_set(0x30, 'XCHD A,@R0',    1)
_set(0x31, 'XCHD A,@R1',    1)
_set(0x32, 'JB1  {paddr}',  2, CJMP)
_set(0x34, 'CALL {addr}',   2, CALL)    # CALL 1xx
_set(0x35, 'DIS  TCNTI',    1)
_set(0x36, 'JT0  {paddr}',  2, CJMP)
_set(0x37, 'CPL  A',        1)
_set(0x39, 'OUTL P1,A',     1)
_set(0x3A, 'OUTL P2,A',     1)
_set(0x3C, 'MOVD P4,A',     1)
_set(0x3D, 'MOVD P5,A',     1)
_set(0x3E, 'MOVD P6,A',     1)
_set(0x3F, 'MOVD P7,A',     1)

# 0x40 .. 0x4F
_set(0x40, 'ORL  A,@R0',    1)
_set(0x41, 'ORL  A,@R1',    1)
_set(0x42, 'MOV  A,T',      1)
_set(0x43, 'ORL  A,{imm}',  2)
_set(0x44, 'JMP  {addr}',   2, JMP)     # JMP 2xx
_set(0x45, 'STRT CNT',      1)
_set(0x46, 'JNT1 {paddr}',  2, CJMP)
_set(0x47, 'SWAP A',        1)
_set(0x48, 'ORL  A,R0',     1)
_set(0x49, 'ORL  A,R1',     1)
_set(0x4A, 'ORL  A,R2',     1)
_set(0x4B, 'ORL  A,R3',     1)
_set(0x4C, 'ORL  A,R4',     1)
_set(0x4D, 'ORL  A,R5',     1)
_set(0x4E, 'ORL  A,R6',     1)
_set(0x4F, 'ORL  A,R7',     1)

# 0x50 .. 0x5F
_set(0x50, 'ANL  A,@R0',    1)
_set(0x51, 'ANL  A,@R1',    1)
_set(0x52, 'JB2  {paddr}',  2, CJMP)
_set(0x53, 'ANL  A,{imm}',  2)
_set(0x54, 'CALL {addr}',   2, CALL)    # CALL 2xx
_set(0x55, 'STRT T',        1)
_set(0x56, 'JT1  {paddr}',  2, CJMP)
_set(0x57, 'DA   A',        1)
_set(0x58, 'ANL  A,R0',     1)
_set(0x59, 'ANL  A,R1',     1)
_set(0x5A, 'ANL  A,R2',     1)
_set(0x5B, 'ANL  A,R3',     1)
_set(0x5C, 'ANL  A,R4',     1)
_set(0x5D, 'ANL  A,R5',     1)
_set(0x5E, 'ANL  A,R6',     1)
_set(0x5F, 'ANL  A,R7',     1)

# 0x60 .. 0x6F
_set(0x60, 'ADD  A,@R0',    1)
_set(0x61, 'ADD  A,@R1',    1)
_set(0x62, 'MOV  T,A',      1)
_set(0x64, 'JMP  {addr}',   2, JMP)     # JMP 3xx
_set(0x65, 'STOP TCNT',     1)
_set(0x67, 'RRC  A',        1)
_set(0x68, 'ADD  A,R0',     1)
_set(0x69, 'ADD  A,R1',     1)
_set(0x6A, 'ADD  A,R2',     1)
_set(0x6B, 'ADD  A,R3',     1)
_set(0x6C, 'ADD  A,R4',     1)
_set(0x6D, 'ADD  A,R5',     1)
_set(0x6E, 'ADD  A,R6',     1)
_set(0x6F, 'ADD  A,R7',     1)

# 0x70 .. 0x7F
_set(0x70, 'ADDC A,@R0',    1)
_set(0x71, 'ADDC A,@R1',    1)
_set(0x72, 'JB3  {paddr}',  2, CJMP)
_set(0x74, 'CALL {addr}',   2, CALL)    # CALL 3xx
_set(0x75, 'ENT0 CLK',      1)
_set(0x76, 'JF1  {paddr}',  2, CJMP)
_set(0x77, 'RR   A',        1)
_set(0x78, 'ADDC A,R0',     1)
_set(0x79, 'ADDC A,R1',     1)
_set(0x7A, 'ADDC A,R2',     1)
_set(0x7B, 'ADDC A,R3',     1)
_set(0x7C, 'ADDC A,R4',     1)
_set(0x7D, 'ADDC A,R5',     1)
_set(0x7E, 'ADDC A,R6',     1)
_set(0x7F, 'ADDC A,R7',     1)

# 0x80 .. 0x8F
_set(0x80, 'MOVX A,@R0',    1)
_set(0x81, 'MOVX A,@R1',    1)
_set(0x83, 'RET',           1, RET)
_set(0x84, 'JMP  {addr}',   2, JMP)     # JMP 4xx
_set(0x85, 'CLR  F0',       1)
_set(0x86, 'JNI  {paddr}',  2, CJMP)
_set(0x88, 'ORL  BUS,{imm}',2)
_set(0x89, 'ORL  P1,{imm}', 2)
_set(0x8A, 'ORL  P2,{imm}', 2)
_set(0x8C, 'ORLD P4,A',     1)
_set(0x8D, 'ORLD P5,A',     1)
_set(0x8E, 'ORLD P6,A',     1)
_set(0x8F, 'ORLD P7,A',     1)

# 0x90 .. 0x9F
_set(0x90, 'MOVX @R0,A',    1)
_set(0x91, 'MOVX @R1,A',    1)
_set(0x92, 'JB4  {paddr}',  2, CJMP)
_set(0x93, 'RETR',          1, RET)
_set(0x94, 'CALL {addr}',   2, CALL)    # CALL 4xx
_set(0x95, 'CPL  F0',       1)
_set(0x96, 'JNZ  {paddr}',  2, CJMP)
_set(0x97, 'CLR  C',        1)
_set(0x98, 'ANL  BUS,{imm}',2)
_set(0x99, 'ANL  P1,{imm}', 2)
_set(0x9A, 'ANL  P2,{imm}', 2)
_set(0x9C, 'ANLD P4,A',     1)
_set(0x9D, 'ANLD P5,A',     1)
_set(0x9E, 'ANLD P6,A',     1)
_set(0x9F, 'ANLD P7,A',     1)

# 0xA0 .. 0xAF
_set(0xA0, 'MOV  @R0,A',    1)
_set(0xA1, 'MOV  @R1,A',    1)
_set(0xA3, 'MOVP A,@A',     1, NORMAL)  # in-page table read
_set(0xA4, 'JMP  {addr}',   2, JMP)     # JMP 5xx
_set(0xA5, 'CLR  F1',       1)
_set(0xA7, 'CPL  C',        1)
_set(0xA8, 'MOV  R0,A',     1)
_set(0xA9, 'MOV  R1,A',     1)
_set(0xAA, 'MOV  R2,A',     1)
_set(0xAB, 'MOV  R3,A',     1)
_set(0xAC, 'MOV  R4,A',     1)
_set(0xAD, 'MOV  R5,A',     1)
_set(0xAE, 'MOV  R6,A',     1)
_set(0xAF, 'MOV  R7,A',     1)

# 0xB0 .. 0xBF
_set(0xB0, 'MOV  @R0,{imm}',2)
_set(0xB1, 'MOV  @R1,{imm}',2)
_set(0xB2, 'JB5  {paddr}',  2, CJMP)
_set(0xB3, 'JMPP @A',       1, JMPP)
_set(0xB4, 'CALL {addr}',   2, CALL)    # CALL 5xx
_set(0xB5, 'CPL  F1',       1)
_set(0xB6, 'JF0  {paddr}',  2, CJMP)
_set(0xB8, 'MOV  R0,{imm}', 2)
_set(0xB9, 'MOV  R1,{imm}', 2)
_set(0xBA, 'MOV  R2,{imm}', 2)
_set(0xBB, 'MOV  R3,{imm}', 2)
_set(0xBC, 'MOV  R4,{imm}', 2)
_set(0xBD, 'MOV  R5,{imm}', 2)
_set(0xBE, 'MOV  R6,{imm}', 2)
_set(0xBF, 'MOV  R7,{imm}', 2)

# 0xC0 .. 0xCF
_set(0xC4, 'JMP  {addr}',   2, JMP)     # JMP 6xx
_set(0xC5, 'SEL  RB0',      1)
_set(0xC6, 'JZ   {paddr}',  2, CJMP)
_set(0xC7, 'MOV  A,PSW',    1)
_set(0xC8, 'DEC  R0',       1)
_set(0xC9, 'DEC  R1',       1)
_set(0xCA, 'DEC  R2',       1)
_set(0xCB, 'DEC  R3',       1)
_set(0xCC, 'DEC  R4',       1)
_set(0xCD, 'DEC  R5',       1)
_set(0xCE, 'DEC  R6',       1)
_set(0xCF, 'DEC  R7',       1)

# 0xD0 .. 0xDF
_set(0xD0, 'XRL  A,@R0',    1)
_set(0xD1, 'XRL  A,@R1',    1)
_set(0xD2, 'JB6  {paddr}',  2, CJMP)
_set(0xD3, 'XRL  A,{imm}',  2)
_set(0xD4, 'CALL {addr}',   2, CALL)    # CALL 6xx
_set(0xD5, 'SEL  RB1',      1)
_set(0xD7, 'MOV  PSW,A',    1)
_set(0xD8, 'XRL  A,R0',     1)
_set(0xD9, 'XRL  A,R1',     1)
_set(0xDA, 'XRL  A,R2',     1)
_set(0xDB, 'XRL  A,R3',     1)
_set(0xDC, 'XRL  A,R4',     1)
_set(0xDD, 'XRL  A,R5',     1)
_set(0xDE, 'XRL  A,R6',     1)
_set(0xDF, 'XRL  A,R7',     1)

# 0xE0 .. 0xEF
_set(0xE3, 'MOVP3 A,@A',    1)          # cross-bank table read (page 3)
_set(0xE4, 'JMP  {addr}',   2, JMP)     # JMP 7xx
_set(0xE5, 'SEL  MB0',      1)
_set(0xE6, 'JNC  {paddr}',  2, CJMP)
_set(0xE7, 'RL   A',        1)
_set(0xE8, 'DJNZ R0,{paddr}', 2, CJMP)
_set(0xE9, 'DJNZ R1,{paddr}', 2, CJMP)
_set(0xEA, 'DJNZ R2,{paddr}', 2, CJMP)
_set(0xEB, 'DJNZ R3,{paddr}', 2, CJMP)
_set(0xEC, 'DJNZ R4,{paddr}', 2, CJMP)
_set(0xED, 'DJNZ R5,{paddr}', 2, CJMP)
_set(0xEE, 'DJNZ R6,{paddr}', 2, CJMP)
_set(0xEF, 'DJNZ R7,{paddr}', 2, CJMP)

# 0xF0 .. 0xFF
_set(0xF0, 'MOV  A,@R0',    1)
_set(0xF1, 'MOV  A,@R1',    1)
_set(0xF2, 'JB7  {paddr}',  2, CJMP)
_set(0xF4, 'CALL {addr}',   2, CALL)    # CALL 7xx
_set(0xF5, 'SEL  MB1',      1)
_set(0xF6, 'JC   {paddr}',  2, CJMP)
_set(0xF7, 'RLC  A',        1)
_set(0xF8, 'MOV  A,R0',     1)
_set(0xF9, 'MOV  A,R1',     1)
_set(0xFA, 'MOV  A,R2',     1)
_set(0xFB, 'MOV  A,R3',     1)
_set(0xFC, 'MOV  A,R4',     1)
_set(0xFD, 'MOV  A,R5',     1)
_set(0xFE, 'MOV  A,R6',     1)
_set(0xFF, 'MOV  A,R7',     1)

# Fill remaining slots with 1-byte unknown sentinel so decoder is total.
for i, slot in enumerate(OP):
    if slot is None:
        OP[i] = (f'?    ; ${i:02X} undefined', 1, NORMAL)


# ---------------------------------------------------------------------------
# Symbol table loader.
# Format mirrors what the project's z80dasm .sym files use, plus a small
# extension: lines starting with '+entry HHHH' add an extra decode entry.
# ---------------------------------------------------------------------------

@dataclass
class Symbols:
    labels:   dict[int, str]    = field(default_factory=dict)
    comments: dict[int, str]    = field(default_factory=dict)
    entries:  list[int]         = field(default_factory=list)

    def label_for(self, addr: int) -> str:
        return self.labels.get(addr, f'L_{addr:04X}')


def load_symbols(path: Path | None) -> Symbols:
    syms = Symbols()
    if path is None or not path.exists():
        return syms
    for raw in path.read_text().splitlines():
        line = raw.split(';', 1)
        body = line[0].strip()
        comment = line[1].strip() if len(line) > 1 else ''
        if not body:
            continue
        toks = body.split()
        if toks[0] == '+entry' and len(toks) >= 2:
            syms.entries.append(int(toks[1], 16))
            continue
        # Form 1:  HHHH NAME
        if len(toks) >= 2 and all(c in '0123456789abcdefABCDEF' for c in toks[0]):
            addr = int(toks[0], 16)
            name = toks[1]
            syms.labels[addr] = name
            if comment:
                syms.comments[addr] = comment
            continue
        # Form 2:  NAME EQU $HHHH
        if len(toks) >= 3 and toks[1].upper() == 'EQU':
            val = toks[2].lstrip('$')
            try:
                addr = int(val, 16)
            except ValueError:
                continue
            syms.labels[addr] = toks[0]
            if comment:
                syms.comments[addr] = comment
    return syms


# ---------------------------------------------------------------------------
# Decoder.
# ---------------------------------------------------------------------------

@dataclass
class Decoded:
    addr: int
    length: int
    bytes_: bytes
    text: str
    kind: str = NORMAL
    is_inst: bool = True
    target: int | None = None   # resolved branch target if applicable


def decode_one(rom: bytes, origin: int, pc: int, syms: Symbols) -> Decoded:
    """Decode one instruction at absolute address `pc`. Returns Decoded."""
    off = pc - origin
    op = rom[off]
    mnem, length, kind = OP[op]

    target: int | None = None
    text = mnem

    if length == 2:
        if off + 1 >= len(rom):
            # Truncated — render as a data byte instead.
            return Decoded(pc, 1, bytes([op]),
                           f'db   ${op:02X}    ; truncated, no second byte',
                           NORMAL, is_inst=False)
        b1 = rom[off + 1]
    else:
        b1 = None

    if '{imm}' in text:
        text = text.replace('{imm}', f'#${b1:02X}')

    if '{addr}' in text:
        # 11-bit addr: top 3 bits from opcode bits 7:5, low 8 bits from b1.
        hi3 = (op >> 5) & 0x07
        target = (hi3 << 8) | b1
        text = text.replace('{addr}', _addr_token(target, syms))

    if '{paddr}' in text:
        # In-page conditional branches encode an 8-bit offset within the
        # 256-byte page that holds the *byte after* the branch. High bits
        # come from (pc+2). Mask 0xF00 covers both 8048 (PC = 11 bits) and
        # 8049/8039 with MB1 (PC = 12 bits); within our 2 KB ROM only bits
        # 8..10 are ever set.
        page = (pc + 2) & 0x0F00
        target = page | b1
        text = text.replace('{paddr}', _addr_token(target, syms))

    bytes_ = rom[off:off + length]
    return Decoded(pc, length, bytes_, text, kind, is_inst=True, target=target)


def _addr_token(addr: int, syms: Symbols) -> str:
    if addr in syms.labels:
        return syms.labels[addr]
    return f'L_{addr:04X}'


def trace(rom: bytes, origin: int, syms: Symbols) -> tuple[dict[int, Decoded], set[int]]:
    """Recursive descent from reset + IRQ vectors.

    Returns (decoded_map, label_addresses).
    """
    end = origin + len(rom)
    decoded: dict[int, Decoded] = {}
    labels: set[int] = set()

    # Standard MCS-48 entry points.
    entries = [origin, origin + 0x03, origin + 0x07]
    entries.extend(syms.entries)
    # Also add anything explicitly labeled via the .sym, in case a code
    # block is reached only by a JMPP @A table (unresolvable statically).
    entries.extend(a for a in syms.labels.keys() if origin <= a < end)

    work = list(entries)
    seen_pc: set[int] = set()

    while work:
        pc = work.pop()
        if pc in seen_pc or not (origin <= pc < end):
            continue
        # Walk linearly until we hit RET / unconditional JMP / out of bounds.
        while True:
            if pc in seen_pc:
                break
            if not (origin <= pc < end):
                break
            seen_pc.add(pc)
            d = decode_one(rom, origin, pc, syms)
            decoded[pc] = d

            if d.target is not None and origin <= d.target < end:
                labels.add(d.target)

            if not d.is_inst:
                break

            if d.kind == RET:
                break
            if d.kind == JMP:
                if d.target is not None and origin <= d.target < end:
                    work.append(d.target)
                break
            if d.kind == JMPP:
                # JMPP @A — table jump within current page; we cannot resolve
                # the table statically. Treat as a stop here; surrounding
                # code lives via .sym labels or by being reached from
                # elsewhere.
                break
            if d.kind == CALL:
                if d.target is not None and origin <= d.target < end:
                    work.append(d.target)
                pc += d.length
                continue
            if d.kind == CJMP:
                if d.target is not None and origin <= d.target < end:
                    work.append(d.target)
                pc += d.length
                continue
            # NORMAL
            pc += d.length

    return decoded, labels


# ---------------------------------------------------------------------------
# Listing emission.
# ---------------------------------------------------------------------------

def emit(rom: bytes, origin: int, decoded: dict[int, Decoded],
         labels: set[int], syms: Symbols, src_name: str) -> str:
    end = origin + len(rom)
    lines: list[str] = []
    lines.append(f'; Disassembly of {src_name}')
    lines.append(f'; Origin: ${origin:04X}   Length: ${len(rom):04X} ({len(rom)} bytes)')
    lines.append(f'; CPU:    Intel MCS-48 (8039 / 8048)')
    lines.append('')
    lines.append(f'        ORG  ${origin:04X}')
    lines.append('')

    pc = origin
    while pc < end:
        if pc in decoded:
            d = decoded[pc]
            lbl_addr = pc
            if lbl_addr in syms.labels or lbl_addr in labels:
                name = syms.labels.get(lbl_addr) or f'L_{lbl_addr:04X}'
                trail = ''
                if lbl_addr in syms.comments:
                    trail = '  ; ' + syms.comments[lbl_addr]
                lines.append(f'{name}:{trail}')
            byts = ' '.join(f'{b:02X}' for b in d.bytes_)
            byts = f'{byts:<8}'
            comment = ''
            if d.target is not None and not (origin <= d.target < end):
                comment = f'   ; off-rom target ${d.target:04X}'
            lines.append(f'  {pc:04X}  {byts}    {d.text}{comment}')
            pc += d.length
        else:
            # Unreachable — emit as data, sixteen per line, ASCII gutter.
            run_start = pc
            while pc < end and pc not in decoded:
                if pc - run_start >= 16:
                    break
                # Stop at the next labelled location so labels still anchor.
                if pc != run_start and (pc in labels or pc in syms.labels):
                    break
                pc += 1
            chunk = rom[run_start - origin: pc - origin]
            if run_start in syms.labels or run_start in labels:
                name = syms.labels.get(run_start) or f'D_{run_start:04X}'
                trail = ''
                if run_start in syms.comments:
                    trail = '  ; ' + syms.comments[run_start]
                lines.append(f'{name}:{trail}')
            data = ','.join(f'${b:02X}' for b in chunk)
            ascii_g = ''.join(chr(b) if 32 <= b < 127 else '.' for b in chunk)
            byts = ' '.join(f'{b:02X}' for b in chunk)
            byts = f'{byts:<47}'  # pad to 16*3-1
            lines.append(f'  {run_start:04X}  {byts}    db   {data}   ; {ascii_g}')

    return '\n'.join(lines) + '\n'


# ---------------------------------------------------------------------------
# CLI.
# ---------------------------------------------------------------------------

def main(argv=None) -> int:
    p = argparse.ArgumentParser(description='MCS-48 disassembler.')
    p.add_argument('input', type=Path, help='input binary (raw image)')
    p.add_argument('-S', '--sym', type=Path, default=None,
                   help='symbol/label overlay file')
    p.add_argument('-g', '--origin', default='0x0000',
                   help='load address of the binary (hex, e.g. 0x0000)')
    p.add_argument('-o', '--output', type=Path, default=None,
                   help='output file (default: stdout)')
    args = p.parse_args(argv)

    rom = args.input.read_bytes()
    origin = int(args.origin, 16)
    syms = load_symbols(args.sym)
    decoded, labels = trace(rom, origin, syms)
    text = emit(rom, origin, decoded, labels, syms, args.input.name)

    if args.output:
        args.output.write_text(text)
    else:
        sys.stdout.write(text)
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
