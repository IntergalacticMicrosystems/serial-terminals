"""SerialTetris — drives a Tetris game on an Ampex D-175 in VT52 mode."""

import sys

from compat import monotonic, open_serial, sleep
from tetris import Game
from ampex import Renderer
from demo import run_demo


KEY_ACTIONS = {
    "h": lambda g: g.move(-1),
    "l": lambda g: g.move(+1),
    "j": lambda g: g.soft_drop(),
    "k": lambda g: g.rotate(),
    " ": lambda g: g.hard_drop(),
}

VT52_ARROW_ACTIONS = {
    0x44: lambda g: g.move(-1),  # ESC D = left
    0x43: lambda g: g.move(+1),  # ESC C = right
    0x41: lambda g: g.rotate(),  # ESC A = up
    0x42: lambda g: g.soft_drop(),  # ESC B = down
}

# Minimum interval between hard-drops — suppresses keyboard auto-repeat
# that would otherwise drop a freshly-spawned piece immediately.
HARD_DROP_COOLDOWN_S = 0.25


def parse_args(argv=None):
    import argparse  # Lazy — absent on MicroPython; only needed for the CLI entry point.

    p = argparse.ArgumentParser(
        description="SerialTetris — Ampex terminal Tetris server"
    )
    p.add_argument("--port", default="COM7", help="serial port (default: COM7)")
    p.add_argument("--baud", type=int, default=19200, help="baud rate (default: 19200)")
    p.add_argument(
        "--block",
        default="__",
        help="2 bytes (graphics-mode) for filled cells (default: __ = two 0x5F full blocks)",
    )
    p.add_argument(
        "--xonxoff",
        default=True,
        action="store_true",
        help="enable software (XON/XOFF) flow control (defualt: enabled)",
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


def decode_key(byte):
    b = byte & 0x7F
    if 0x20 <= b < 0x7F:
        return chr(b).lower()
    return None


def attract_mode(ser, block_on, keydebug=False):
    """Run Tetris auto-play as attract mode until any byte arrives."""
    r = Renderer(ser, block_on=block_on)
    run_demo(ser, r, keydebug=keydebug, any_key_exits=True)


def play(ser, block_on, keydebug=False):
    r = Renderer(ser, block_on=block_on)
    run_demo(ser, r, keydebug=keydebug)
    while True:
        game = Game()
        r.draw_chrome()
        r.full_repaint(game)

        next_tick = monotonic() + game.tick_interval()
        user_quit = False
        esc_pending = False
        last_hard_drop = 0.0
        while not game.game_over and not user_quit:
            data = ser.read(64)
            if data and keydebug:
                print("rx: " + " ".join("{:02X}".format(b) for b in data), flush=True)
            for byte in data:
                if esc_pending:
                    esc_pending = False
                    action = VT52_ARROW_ACTIONS.get(byte)
                    if action is not None:
                        dirty = action(game)
                        r.apply_dirty(game, dirty)
                        r.draw_score(game)
                        r.draw_next(game)
                    continue
                if byte == 0x1B:
                    esc_pending = True
                    continue
                ch = decode_key(byte)
                if ch is None:
                    continue
                if ch == "q":
                    user_quit = True
                    break
                if ch == "p":
                    game.toggle_pause()
                    if game.paused:
                        r.pause()
                    else:
                        r.resume(game)
                    continue
                if ch == " ":
                    now = monotonic()
                    if now - last_hard_drop < HARD_DROP_COOLDOWN_S:
                        continue
                    last_hard_drop = now
                action = KEY_ACTIONS.get(ch)
                if action:
                    dirty = action(game)
                    r.apply_dirty(game, dirty)
                    r.draw_score(game)
                    r.draw_next(game)

            now = monotonic()
            if now >= next_tick and not game.paused and not game.game_over:
                dirty = game.step()
                r.apply_dirty(game, dirty)
                r.draw_score(game)
                r.draw_next(game)
                next_tick = now + game.tick_interval()

            sleep(0.01)

        r.draw_game_over(game)
        while True:
            data = ser.read(64)
            if data and keydebug:
                print("rx: " + " ".join("{:02X}".format(b) for b in data), flush=True)
            keys = [decode_key(b) for b in data]
            if "q" in keys:
                return
            if "r" in keys:
                break
            if "d" in keys:
                run_demo(ser, r, keydebug=keydebug)
                break
            sleep(0.05)


def main(argv=None):
    args = parse_args(argv)
    ser = open_serial(
        port=args.port,
        baudrate=args.baud,
        xonxoff=args.xonxoff,
        rtscts=args.rtscts,
    )
    try:
        play(ser, args.block.encode("ascii"), keydebug=args.keydebug)
    finally:
        ser.close()


if __name__ == "__main__":
    sys.exit(main() or 0)
