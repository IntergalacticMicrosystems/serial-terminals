"""Startup menu for the Ampex D-175 serial games launcher.

Draws a titled, boxed menu in VT52 mode, reads a menu key from the
terminal, and dispatches to the selected game. When the game returns
(the user pressed `q`), the menu is redrawn and the cycle repeats.
"""

import sys

from compat import open_serial, sleep
import graphics as gfx


ESC = b"\x1b"
ZGAME_DIR = "zgames"
ZGAME_EXTENSIONS = (".z3", ".z4", ".z5", ".z6", ".z7", ".z8")
MENU_KEYS = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"


def _launch_tetris(ser, block_on, keydebug):
    from serial_tetris import play
    play(ser, block_on=block_on, keydebug=keydebug)


def _launch_zgame(story_filename):
    def launch(ser, block_on, keydebug):
        from serial_zork import play
        play(
            ser,
            block_on=block_on,
            keydebug=keydebug,
            story_filename=story_filename,
        )

    return launch


def _here():
    try:
        import os
        return os.path.dirname(os.path.abspath(__file__))
    except Exception:
        return ""


def _join(*parts):
    try:
        import os
        return os.path.join(*parts)
    except Exception:
        return "/".join(parts)


def _zgames_dir():
    base = _here()
    if base:
        return _join(base, ZGAME_DIR)
    return ZGAME_DIR


def _zgame_label(filename):
    stem = filename.rsplit(".", 1)[0]
    label = stem.replace("_", " ").replace("-", " ")
    chars = []
    prev = ""
    for ch in label:
        if ch.isdigit() and prev and prev != " " and not prev.isdigit():
            chars.append(" ")
        chars.append(ch)
        prev = ch
    return "".join(chars).upper()


def _zgame_filenames():
    try:
        import os
        names = os.listdir(_zgames_dir())
    except Exception:
        return []

    games = [
        name for name in names
        if name.lower().endswith(ZGAME_EXTENSIONS)
    ]
    return sorted(games, key=lambda name: name.lower())


def _build_games():
    games = [("TETRIS", _launch_tetris)]
    for filename in _zgame_filenames():
        games.append((_zgame_label(filename), _launch_zgame(filename)))
    return games


# (label, launcher). Position in this list maps to MENU_KEYS.
GAMES = _build_games()[:len(MENU_KEYS)]


def _goto(row, col):
    return ESC + b"Y" + bytes([row + 0x20, col + 0x20])


def _clear():
    return ESC + b"Y" + bytes([0x20, 0x20]) + ESC + b"J"


def _center_col(text, screen_width=80):
    return (screen_width - len(text)) // 2


def draw_menu(ser):
    box_row, box_col, box_w = 2, 18, 44
    box_h = max(12, len(GAMES) + 6)
    buf = bytearray()
    buf += _clear()
    buf += gfx.ENTER_GFX
    buf += gfx.draw_box(box_row, box_col, box_w, box_h, rounded=True)
    buf += gfx.EXIT_GFX

    title = "S E R I A L   G A M E S"
    buf += _goto(box_row + 2, _center_col(title)) + title.encode("ascii")

    for i, (label, _) in enumerate(GAMES):
        line = "{}) {}".format(MENU_KEYS[i], label)
        buf += _goto(box_row + 5 + i, _center_col(line)) + line.encode("ascii")

    prompt = "Press a menu key to begin."
    buf += _goto(box_row + box_h + 1, _center_col(prompt)) + prompt.encode("ascii")
    ser.write(bytes(buf))


def _read_menu_key(ser):
    """Block until a key matching a menu entry is received. Returns
    the 0-based index into GAMES."""
    while True:
        data = ser.read(16)
        if data:
            for byte in data:
                ch = chr(byte & 0x7F).upper()
                idx = MENU_KEYS.find(ch)
                if 0 <= idx < len(GAMES):
                    return idx
        sleep(0.02)


def run_menu(ser, block_on=b"__", keydebug=False):
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
