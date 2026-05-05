#!/usr/bin/env python3
"""Substitute .sym labels into unidasm raw F8 disassembly output.

Reads `unidasm -arch f8 -basepc <base>` output on stdin, replaces 16-bit
hex address references with labels from the supplied .sym file, and writes
the relabelled listing to stdout.

Idempotent — running twice produces identical output. The relabelled .asm
file is intended to assemble back to the original ROM with `asl + p2bin`,
forming the basis of round-trip verification (see references/disassembly-workflow.md).

Usage:
    relabel.py --sym U1.sym --base 0x0000 < raw.asm > U1.asm
"""

from __future__ import annotations

import argparse
import re
import sys


SYM_LINE_RE = re.compile(
    r"""^\s*([A-Za-z_][A-Za-z0-9_]*):?  # label name (optional trailing colon)
        \s+EQU\s+
        H'([0-9A-Fa-f]+)'              # AS-style hex H'NNNN'
        \s*(?:;.*)?$                   # optional comment
    """,
    re.VERBOSE,
)

# unidasm emits hex addresses as Mostek-style H'NNNN' (the F8 backend
# default). Other forms appear in some unidasm modes.
ADDR_REFS = [
    re.compile(r"H'([0-9A-Fa-f]{4})'"),
    re.compile(r"\$([0-9A-Fa-f]{4})\b"),
    re.compile(r"\b0x([0-9A-Fa-f]{4})\b"),
    re.compile(r"\b([0-9A-Fa-f]{4})h\b"),
]


def load_symbols(path: str) -> tuple[dict[int, str], dict[int, str]]:
    """Parse a .sym file. Splits labels into two dicts based on scope:

    - 16-bit address labels (value >= 0x100, OR hex literal had >= 3 digits):
      substituted for H'NNNN' / 0xNNNN / etc. address references.
    - 8-bit port labels (value < 0x100 AND hex literal had 1-2 digits):
      substituted for H'NN' references — typically only in INS/OUTS/IN/OUT.
    """
    addr_syms: dict[int, str] = {}
    port_syms: dict[int, str] = {}
    with open(path) as f:
        for lineno, line in enumerate(f, 1):
            stripped = line.strip()
            if not stripped or stripped.startswith(";"):
                continue
            m = SYM_LINE_RE.match(stripped)
            if not m:
                print(
                    f"warning: {path}:{lineno}: skipping unparseable line: {stripped}",
                    file=sys.stderr,
                )
                continue
            name, hex_value = m.group(1), m.group(2)
            addr = int(hex_value, 16)
            target = port_syms if (addr < 0x100 and len(hex_value) <= 2) else addr_syms
            if addr in target and target[addr] != name:
                print(
                    f"warning: {path}:{lineno}: address {addr:04X} already labelled "
                    f"{target[addr]!r}; overriding with {name!r}",
                    file=sys.stderr,
                )
            target[addr] = name
    return addr_syms, port_syms


PORT_REFS = [
    re.compile(r"H'([0-9A-Fa-f]{1,2})'"),
]


def relabel_line(
    line: str,
    addr_syms: dict[int, str],
    port_syms: dict[int, str],
) -> str:
    """Substitute address references in one line.

    addr_syms: 16-bit address labels (substituted for H'NNNN' or 0xNNNN)
    port_syms: 8-bit port labels (substituted for H'NN' — typically only
    appear in INS/OUTS/IN/OUT instructions; substituted independently to
    avoid collision with addresses < 0x100 used as branch targets)
    """
    out = line
    for pat in ADDR_REFS:
        def addr_sub(m: re.Match) -> str:
            addr = int(m.group(1), 16)
            if addr in addr_syms:
                return addr_syms[addr]
            return m.group(0)
        out = pat.sub(addr_sub, out)
    # Port substitution applies only to lines whose mnemonic is an I/O
    # instruction. LIS/LI/AI/etc. also take 1- or 2-digit hex literals
    # but those are not port references and must not get rewritten.
    if re.search(r"\b(?:INS|OUTS|IN|OUT)\b", out):
        for pat in PORT_REFS:
            def port_sub(m: re.Match) -> str:
                port = int(m.group(1), 16)
                if port in port_syms:
                    return port_syms[port]
                return m.group(0)
            out = pat.sub(port_sub, out)
    return out


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--sym", required=True, help="path to .sym file")
    ap.add_argument(
        "--base",
        default="0x0000",
        help="origin address as passed to unidasm -basepc (informational)",
    )
    ap.add_argument(
        "--rom",
        default=None,
        help="path to source ROM binary; if given, trims trailing instructions "
        "that overlap the ROM-end (replacing with DB) so round-trip succeeds",
    )
    args = ap.parse_args()

    addr_syms, port_syms = load_symbols(args.sym)
    base = int(args.base, 0)
    rom_size = None
    if args.rom:
        import os
        rom_size = os.path.getsize(args.rom)

    print(f"; Relabelled disassembly. Origin H'{base:04X}'.")
    print(
        f"; Symbols loaded from: {args.sym} "
        f"({len(addr_syms)} addr, {len(port_syms)} port)"
    )
    print(f"; Idempotent — re-run after editing {args.sym} to refresh.")
    print(";")
    print("        CPU MK3850")
    print(";")
    print("; --- Symbol table (from .sym file; needed for asl reassembly) ---")
    for addr in sorted(addr_syms):
        print(f"{addr_syms[addr]+':':<24}EQU H'{addr:04X}'")
    for port in sorted(port_syms):
        print(f"{port_syms[port]+':':<24}EQU H'{port:02X}'")
    print(";")
    print(f"        ORG H'{base:04X}'")
    print(";")

    # unidasm emits "  ADDR: BB BB BB  MNEMONIC OPS" — strip the addr/bytes
    # prefix so asl can re-assemble the mnemonics. Preserve them as a
    # trailing comment for human reading.
    # The bytes field is single-space-separated hex pairs (1..4); the
    # mnemonic that follows is preceded by 2+ spaces. Without that lookahead
    # the regex eats hex-looking mnemonics like DC into the bytes group.
    UNIDASM_PREFIX = re.compile(
        r"^\s*([0-9A-Fa-f]+):\s+"
        r"((?:[0-9A-Fa-f]{2})(?:\s[0-9A-Fa-f]{2}){0,3})\s{2,}"
        r"(.*)$"
    )
    # unidasm uses "R0..R11" for direct scratchpad slots; ASL F8 wants the
    # bare numeric form ("0..11"). The ISAR synonyms S/I/D match between
    # the two tools, as do KU/KL/QU/QL/HU/HL/J.
    REG_REF = re.compile(r"\bR(1[01]|[0-9])\b")
    # unidasm emits invalid opcodes as "DC   H'FF' (?)"; ASL needs DB.
    INVALID_OPCODE = re.compile(r"\bDC\s+H'([0-9A-Fa-f]+)'\s*\(\?\)")
    # unidasm uses friendly aliases (BM/BP/BC/...) and also emits the test
    # mask in hex (`BF H'0E',target`) which doesn't always round-trip via
    # ASL — sometimes the friendly alias maps to a different opcode, and
    # the hex mask trips ASL when the friendly alias is BR7 territory.
    # The robust fix is: always rebuild the mnemonic from the opcode byte
    # alone, extracting only the branch target (last H'NNNN' on the line).
    BRANCH_TARGET = re.compile(r"H'([0-9A-Fa-f]{4})'\s*$")

    def fix_branch(mnem: str, opcode: int) -> str:
        m = BRANCH_TARGET.search(mnem)
        if not m:
            return mnem
        target_hex = m.group(1).upper()
        target = f"H'{target_hex}'"
        # 0x8F is BR7 (branch if ISARL != 7) — special opcode, not BT 15
        if opcode == 0x8F:
            return f"BR7  {target}"
        # 0x90 is unconditional BR (= BF 0) — ASL accepts BR directly
        if opcode == 0x90:
            return f"BR   {target}"
        if 0x80 <= opcode <= 0x8F:
            mask = opcode & 0x0F
            return f"BT   {mask},{target}"
        if 0x90 <= opcode <= 0x9F:
            mask = opcode & 0x0F
            return f"BF   {mask},{target}"
        return mnem

    def fix_mnem(mnem: str, opcode: int | None) -> str:
        mnem = REG_REF.sub(lambda m: m.group(1), mnem)
        mnem = INVALID_OPCODE.sub(lambda m: f"DB   H'{m.group(1)}'", mnem)
        if opcode is not None and (0x80 <= opcode <= 0x9F):
            mnem = fix_branch(mnem, opcode)
        return mnem

    for raw_line in sys.stdin:
        line = raw_line.rstrip("\n")
        m = UNIDASM_PREFIX.match(line)
        if m:
            addr_str, bytes_str, mnem = m.group(1), m.group(2).strip(), m.group(3)
            instr_addr = int(addr_str, 16)
            instr_bytes = bytes_str.split()
            opcode = int(instr_bytes[0], 16) if instr_bytes else None
            mnem_relabelled = fix_mnem(relabel_line(mnem, addr_syms, port_syms), opcode)

            # If known ROM size and this instruction's bytes extend past EOF,
            # replace it with DB declarations for the bytes that ARE in ROM.
            # unidasm wraps reads past ROM end, producing phantom multi-byte
            # instructions; emit only real bytes as data.
            offset = instr_addr - base
            if rom_size is not None and offset + len(instr_bytes) > rom_size:
                in_rom = rom_size - offset
                if in_rom > 0:
                    real_bytes = instr_bytes[:in_rom]
                    for i, b in enumerate(real_bytes):
                        sys.stdout.write(
                            f"        DB   H'{b.upper()}'                    "
                            f"; {(instr_addr + i):03x}: {b} (ROM-end trim)\n"
                        )
                continue

            sys.stdout.write(
                f"        {mnem_relabelled:<32}; {addr_str}: {bytes_str}\n"
            )
        else:
            sys.stdout.write(relabel_line(line, addr_syms, port_syms) + "\n")

    return 0


if __name__ == "__main__":
    sys.exit(main())
