#!/usr/bin/env python3
"""Extract printable-ASCII runs from a binary, annotated with offset and load address.

Used to build ground-truth anchors for the Ampex D-175 disassembly: matched strings
give verified labels and back-pointers from whatever code loads them.
"""
import argparse
import sys

MIN_LEN = 4
PRINTABLE = set(range(0x20, 0x7F)) | {0x09}  # printable + TAB


def runs(data, min_len):
    start = None
    for i, b in enumerate(data):
        if b in PRINTABLE:
            if start is None:
                start = i
        else:
            if start is not None and i - start >= min_len:
                yield start, data[start:i]
            start = None
    if start is not None and len(data) - start >= min_len:
        yield start, data[start:]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("binary")
    ap.add_argument("--base", default="0x0000",
                    help="Load address (hex, e.g. 0x2000) to add to offsets.")
    ap.add_argument("--min", type=int, default=MIN_LEN)
    args = ap.parse_args()

    base = int(args.base, 0)
    with open(args.binary, "rb") as f:
        data = f.read()

    for off, run in runs(data, args.min):
        addr = base + off
        text = run.decode("ascii", errors="replace")
        print(f"{addr:04X}  {off:04X}  {len(run):3d}  {text!r}")


if __name__ == "__main__":
    main()
