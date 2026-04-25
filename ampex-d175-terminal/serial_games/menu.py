"""Startup menu for the Ampex D-175 serial games launcher.

Draws a titled, boxed menu in VT52 mode, reads a single digit from the
terminal, and dispatches to the selected game. When the game returns
(the user pressed `q`), the menu is redrawn and the cycle repeats.
"""

import sys

from compat import open_serial, sleep
import graphics as gfx


ESC = b"\x1b"


def _launch_tetris(ser, block_on, keydebug):
    from serial_tetris import play
    play(ser, block_on=block_on, keydebug=keydebug)


# (label, launcher). Position in this list is the 1-based menu key.
GAMES = [
    ("TETRIS", _launch_tetris),
]


def _goto(row, col):
    return ESC + b"Y" + bytes([row + 0x20, col + 0x20])


def _clear():
    return ESC + b"Y" + bytes([0x20, 0x20]) + ESC + b"J"


def _center_col(text, screen_width=80):
    return (screen_width - len(text)) // 2


def draw_menu(ser):
    box_row, box_col, box_w, box_h = 5, 20, 40, 12
    buf = bytearray()
    buf += _clear()
    buf += gfx.ENTER_GFX
    buf += gfx.draw_box(box_row, box_col, box_w, box_h, rounded=True)
    buf += gfx.EXIT_GFX

    title = "S E R I A L   G A M E S"
    buf += _goto(box_row + 2, _center_col(title)) + title.encode("ascii")

    for i, (label, _) in enumerate(GAMES):
        line = "{}) {}".format(i + 1, label)
        buf += _goto(box_row + 5 + i * 2, _center_col(line)) + line.encode("ascii")

    prompt = "Press a number to begin."
    buf += _goto(box_row + box_h + 1, _center_col(prompt)) + prompt.encode("ascii")
    ser.write(bytes(buf))


def _read_menu_key(ser):
    """Block until a digit matching a menu entry is received. Returns
    the 0-based index into GAMES."""
    while True:
        data = ser.read(16)
        if data:
            for byte in data:
                b = byte & 0x7F
                if 0x31 <= b <= 0x39:
                    idx = b - 0x31
                    if idx < len(GAMES):
                        return idx
        sleep(0.02)


def run_menu(ser, block_on=b"__", keydebug=False):
    from serial_tetris import attract_mode
    attract_mode(ser, block_on=block_on, keydebug=keydebug)
    while True:
        draw_menu(ser)
        idx = _read_menu_key(ser)
        _, launcher = GAMES[idx]
        launcher(ser, block_on, keydebug)


def parse_args(argv=None):
    import argparse  # Lazy — absent on MicroPython.

    p = argparse.ArgumentParser(
        description="Serial games launcher for the Ampex D-175"
    )
    p.add_argument("--port", default="COM7", help="serial port (default: COM7)")
    p.add_argument("--baud", type=int, default=19200, help="baud rate (default: 19200)")
    p.add_argument(
        "--block",
        default="__",
        help="2 bytes (graphics-mode) for filled cells (default: __)",
    )
    p.add_argument(
        "--xonxoff",
        default=True,
        action="store_true",
        help="enable software (XON/XOFF) flow control (default: enabled)",
    )
    p.add_argument(
        "--rtscts",
        action="store_true",
        help="enable hardware (RTS/CTS) flow control",
    )
    p.add_argument(
        "--keydebug",
        action="store_true",
        help="print incoming serial bytes in hex to the console",
    )
    args = p.parse_args(argv)
    if len(args.block) != 2:
        p.error("--block must be exactly 2 characters")
    return args


def main(argv=None):
    args = parse_args(argv)
    ser = open_serial(
        port=args.port,
        baudrate=args.baud,
        xonxoff=args.xonxoff,
        rtscts=args.rtscts,
    )
    try:
        run_menu(ser, block_on=args.block.encode("ascii"), keydebug=args.keydebug)
    finally:
        ser.close()


if __name__ == "__main__":
    sys.exit(main() or 0)
