"""Blinks the Ampex D-175 screen: 2s of full-fill, 2s blank, repeat."""

import sys

from compat import open_serial, sleep
import graphics as gfx

ESC = b"\x1b"
ROWS = 23
COLS = 80
BLOCK = 0x5F  # VT52 graphics-mode full block on the D-175
LEFTSIDE = 0x35
BLANK = 0x00
RIGHTSIDE = 0x4A


def _goto(r, c):
    return ESC + b"Y" + bytes([r + 0x20, c + 0x20])


def _clear():
    return ESC + b"Y" + bytes([0x20, 0x20]) + ESC + b"J"


def _fill():
    buf = bytearray(gfx.ENTER_GFX)
    row = bytes([LEFTSIDE]) * COLS
    for r in range(ROWS):
        buf += _goto(r, 0)
        buf += row
    buf += gfx.EXIT_GFX
    return bytes(buf)


def parse_args(argv=None):
    import argparse

    p = argparse.ArgumentParser(description="Blink D-175 screen between fill and blank")
    p.add_argument("--port", default="COM8", help="serial port (default: COM7)")
    p.add_argument("--baud", type=int, default=19200, help="baud rate (default: 19200)")
    p.add_argument("--xonxoff", default=True, action="store_true")
    p.add_argument("--rtscts", action="store_true")
    return p.parse_args(argv)


def main(argv=None):
    args = parse_args(argv)
    ser = open_serial(
        port=args.port,
        baudrate=args.baud,
        xonxoff=args.xonxoff,
        rtscts=args.rtscts,
    )
    fill = _fill()
    clear = _clear()
    try:
        while True:
            # ser.write(fill)
            ser.write(gfx.ENTER_GFX)
            ser.write(bytes([LEFTSIDE]))
            ser.write(_goto(1, 0))
            ser.write(bytes([RIGHTSIDE]))
            sleep(40.0)
            # sleep(2.0)
            ser.write(clear)
    finally:
        ser.close()


if __name__ == "__main__":
    sys.exit(main() or 0)
