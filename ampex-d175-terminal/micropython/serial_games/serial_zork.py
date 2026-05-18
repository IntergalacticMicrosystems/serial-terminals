"""SerialZork — drives Zork I on an Ampex D-175 via the vendored xyppy
Z-machine interpreter.

Mirrors the serial_tetris launcher shape so menu.py can dispatch to
`play(ser, block_on, keydebug)` and return when the game exits (QUIT
in-game raises SystemExit from xyppy's `Env.quit`).
"""

import sys


# Default story directory. Resolved per-platform in _story_path().
STORY_DIR = "zgames"


class _Options:
    """Minimum surface xyppy's vterm / zenv read off env.options."""
    no_slow_scroll = True


def _here():
    # Directory containing this module. Works on both CPython and
    # MicroPython when the source is on the filesystem.
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


def _story_path(story_filename):
    base = _here()
    if base:
        return _join(base, STORY_DIR, story_filename)
    return "/" + _join(STORY_DIR, story_filename)


def _save_path(story_filename):
    save_filename = story_filename.rsplit(".", 1)[0] + ".sav"
    base = _here()
    if base:
        return _join(base, STORY_DIR, save_filename)
    return "/" + _join(STORY_DIR, save_filename)


def play(ser, block_on=None, keydebug=False, story_filename="zork1.z5"):
    """Run a Z-machine story to completion or until the player types QUIT."""
    import term_ampex
    term_ampex.set_serial(ser, keydebug=keydebug)

    # Banner before xyppy's first_draw (which sits the screen and starts
    # writing the title page).
    term_ampex.clear_screen()

    with open(_story_path(story_filename), "rb") as f:
        mem = f.read()

    # Late import: xyppy modules import each other and the term shim,
    # which itself imports term_ampex. Doing this after set_serial
    # avoids any chance of a getch call hitting a None serial object
    # during module init.
    from xyppy import zenv, ops

    env = zenv.Env(mem, _Options())
    env.save_path = _save_path(story_filename)

    ops.setup_opcodes(env)
    env.screen.first_draw()

    try:
        while True:
            zenv.step(env)
    except SystemExit:
        # xyppy's Env.quit() raises SystemExit. Catch so the menu can
        # take over again instead of the process exiting.
        pass
    finally:
        term_ampex.clear_screen()


# ----- CPython CLI entry (for smoke-testing without going through menu) -----

def _parse_args(argv=None):
    import argparse
    p = argparse.ArgumentParser(description="SerialZork — Ampex terminal Zork I")
    p.add_argument("--port", default="COM7", help="serial port (default: COM7)")
    p.add_argument("--baud", type=int, default=19200, help="baud rate (default: 19200)")
    p.add_argument("--xonxoff", default=True, action="store_true",
                   help="enable software (XON/XOFF) flow control (default: enabled)")
    p.add_argument("--rtscts", action="store_true",
                   help="enable hardware (RTS/CTS) flow control")
    p.add_argument("--keydebug", action="store_true",
                   help="print incoming serial bytes in hex to the console")
    return p.parse_args(argv)


def main(argv=None):
    from compat import open_serial
    args = _parse_args(argv)
    ser = open_serial(
        port=args.port,
        baudrate=args.baud,
        xonxoff=args.xonxoff,
        rtscts=args.rtscts,
    )
    try:
        play(ser, keydebug=args.keydebug)
    finally:
        ser.close()


if __name__ == "__main__":
    sys.exit(main() or 0)
