"""Probe the VT52 graphics-mode character set.

Sends ESC F (enter graphics mode), then every byte 0x20..0x6E separated by
spaces, 16 per line, wrapped with CR+LF, then ESC G (exit graphics mode).
Use this to see which glyph each code prints when the D-175 is in VT52
emulation mode with graphics mode active.
"""

import argparse
import sys

import serial


def parse_args(argv=None):
    p = argparse.ArgumentParser(
        description="Send a VT52 graphics-mode character-set probe to the terminal",
    )
    p.add_argument("--port", default="COM7", help="serial port (default: COM7)")
    p.add_argument("--baud", type=int, default=19200, help="baud rate (default: 19200)")
    p.add_argument(
        "--xonxoff",
        action="store_true",
        help="enable software (XON/XOFF) flow control",
    )
    p.add_argument(
        "--rtscts",
        action="store_true",
        help="enable hardware (RTS/CTS) flow control",
    )
    return p.parse_args(argv)


def build_payload():
    SEP = b"  "  # 2 spaces between each char
    BLANK = b"\r\n"  # end-of-line + 1 extra CR+LF for spacing
    buf = bytearray()
    buf += b"\x1bY  \x1bJ"  # VT52 clear: position to (0,0) then erase to end of screen
    # Header row: column labels 0..F in normal text so they're readable.
    buf += b"    " + SEP.join(
        bytes([0x30 + n if n < 10 else 0x37 + n]) for n in range(16)
    )
    buf += BLANK
    # Data rows: row label in normal mode, then ESC F ... ESC G around chars
    # so the label is readable regardless of the graphics glyph for digits.
    for high in range(0x2, 0x7):  # high nibble 2..6
        buf.append(0x30 + high if high < 10 else 0x37 + high)  # '2'..'6'
        buf += b":  "
        buf += b"\x1b\x46"  # ESC F — enter graphics mode
        for low in range(0x10):
            c = (high << 4) | low
            if c > 0x6E:
                break
            buf.append(c)
            buf += SEP
        buf += b"\x1b\x47"  # ESC G — exit graphics mode
        if high < 0x6:
            buf += BLANK
    return bytes(buf)


def main(argv=None):
    args = parse_args(argv)
    ser = serial.Serial(
        port=args.port,
        baudrate=args.baud,
        bytesize=8,
        parity="N",
        stopbits=1,
        timeout=0,
        xonxoff=args.xonxoff,
        rtscts=args.rtscts,
    )
    try:
        ser.write(build_payload())
        ser.flush()
    finally:
        ser.close()


if __name__ == "__main__":
    sys.exit(main() or 0)
