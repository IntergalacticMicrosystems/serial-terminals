#!/usr/bin/env python3
"""Detect F8 jump and call tables in a binary ROM.

Scans for runs of fixed-stride entries of the form

    JMP H'iijj'    (opcode 29, 3 bytes total)
    PI  H'iijj'    (opcode 28, 3 bytes total)

at consistent stride (typically 3 bytes per entry, but the script also
detects strided variants where each entry is followed by padding/data).

For each candidate table, reports:
    - starting address (in the loaded address space)
    - number of entries
    - target list (hex)

Use to seed Phase-2 anchors: every confirmed jump-table entry is a function
entry-point. See references/disassembly-workflow.md.

Usage:
    f8_jump_tables.py --base 0x0000 rom.bin
"""

from __future__ import annotations

import argparse
import sys


JMP = 0x29
PI = 0x28


def is_jmp_or_pi(byte: int) -> bool:
    return byte in (JMP, PI)


def opcode_name(byte: int) -> str:
    if byte == JMP:
        return "JMP"
    if byte == PI:
        return "PI"
    return f"H'{byte:02X}'"


def find_tables(data: bytes, base: int, min_entries: int = 3, max_stride: int = 8):
    """Yield (start_addr, stride, opcode, [targets]) for each candidate table."""
    n = len(data)
    i = 0
    while i < n - 2:
        if not is_jmp_or_pi(data[i]):
            i += 1
            continue
        # Try every plausible stride. Smallest plausible is 3 (back-to-back JMPs);
        # larger strides cover entries with trailing padding.
        for stride in range(3, max_stride + 1):
            if i + stride > n:
                continue
            entries = []
            opc = data[i]
            j = i
            while j + 2 < n and data[j] == opc:
                tgt = data[j + 2] | (data[j + 1] << 8)
                entries.append(tgt)
                j += stride
                if j + 2 >= n:
                    break
            if len(entries) >= min_entries:
                yield (base + i, stride, opc, entries)
                i = j  # advance past the table
                break
        else:
            i += 1
            continue
    # exhausted


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("binary")
    ap.add_argument(
        "--base", default="0x0000",
        help="Load address (hex). Used to report absolute addresses."
    )
    ap.add_argument(
        "--min-entries", type=int, default=3,
        help="Minimum consecutive matching entries to call a table (default 3)."
    )
    ap.add_argument(
        "--max-stride", type=int, default=4,
        help="Maximum stride to consider (default 4). 3 is the standard."
    )
    args = ap.parse_args()

    base = int(args.base, 0)
    with open(args.binary, "rb") as f:
        data = f.read()

    rom_end = base + len(data)
    found_any = False
    for start, stride, opc, entries in find_tables(
        data, base, args.min_entries, args.max_stride
    ):
        found_any = True
        in_rom = sum(1 for t in entries if base <= t < rom_end)
        out_rom = len(entries) - in_rom
        print(
            f"H'{start:04X}'  stride={stride}  {opcode_name(opc):3s}  "
            f"entries={len(entries)}  in_this_rom={in_rom}  cross={out_rom}"
        )
        for k, tgt in enumerate(entries):
            scope = "" if base <= tgt < rom_end else "  (cross-ROM)"
            print(f"    [{k:3d}]  H'{tgt:04X}'{scope}")
        print()

    if not found_any:
        print("(no jump/call tables detected with the given parameters)", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
