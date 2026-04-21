"""Attract-mode auto-player. Runs until any byte is received on the serial port."""

from compat import monotonic, sleep
from tetris import Game, PIECES, WIDTH, HEIGHT


# Colin Fahey heuristic weights.
W_HEIGHT = -0.510066
W_LINES = 0.760666
W_HOLES = -0.35663
W_BUMPINESS = -0.184483

# Seconds between bot inputs. Fast enough to look purposeful, slow enough to read.
ACTION_INTERVAL_S = 0.12


def _column_heights(board):
    heights = [0] * WIDTH
    for c in range(WIDTH):
        for r in range(HEIGHT):
            if board[r][c]:
                heights[c] = HEIGHT - r
                break
    return heights


def _count_holes(board, heights):
    holes = 0
    for c in range(WIDTH):
        top = HEIGHT - heights[c]
        for r in range(top + 1, HEIGHT):
            if not board[r][c]:
                holes += 1
    return holes


def _score_board(board, lines_cleared):
    heights = _column_heights(board)
    aggregate = sum(heights)
    holes = _count_holes(board, heights)
    bumpiness = sum(abs(heights[c] - heights[c + 1]) for c in range(WIDTH - 1))
    return (
        W_HEIGHT * aggregate
        + W_LINES * lines_cleared
        + W_HOLES * holes
        + W_BUMPINESS * bumpiness
    )


def _simulate(game, kind, rotation, col):
    """Return score for locking `kind` at (rotation, col), or None if it can't fit."""
    if game._collides(kind, 0, col, rotation):
        return None
    row = 0
    while not game._collides(kind, row + 1, col, rotation):
        row += 1
    board = [r[:] for r in game.board]
    for dr, dc in PIECES[kind][rotation]:
        rr, cc = row + dr, col + dc
        if 0 <= rr < HEIGHT and 0 <= cc < WIDTH:
            board[rr][cc] = 1
    lines_cleared = 0
    rr = HEIGHT - 1
    while rr >= 0:
        if all(board[rr]):
            del board[rr]
            board.insert(0, [0] * WIDTH)
            lines_cleared += 1
        else:
            rr -= 1
    return _score_board(board, lines_cleared)


def _plan(game):
    """Choose the best (rotation, col) for the current piece."""
    kind = game.piece.kind
    best = None
    best_score = None
    for rotation in range(4):
        for col in range(-2, WIDTH + 2):
            score = _simulate(game, kind, rotation, col)
            if score is None:
                continue
            if best_score is None or score > best_score:
                best_score = score
                best = (rotation, col)
    return best


def _next_action(game, target):
    """Apply one input toward `target`. Returns the dirty-cell set."""
    target_rot, target_col = target
    if game.piece.rotation != target_rot:
        return game.rotate()
    if game.piece.col < target_col:
        return game.move(+1)
    if game.piece.col > target_col:
        return game.move(-1)
    return game.soft_drop()


def run_demo(ser, r, keydebug=False):
    """Auto-play Tetris until any byte arrives on `ser`."""
    while True:
        game = Game()
        r.draw_chrome()
        r.full_repaint(game)
        r.draw_demo_banner()

        target = _plan(game)
        planned_piece = game.piece

        now = monotonic()
        next_tick = now + game.tick_interval()
        next_action = now + ACTION_INTERVAL_S

        while not game.game_over:
            data = ser.read(64)
            if (
                b"\x53" in data or b"\x73" in data or b"\x20" in data
            ):  # 'S' or 's' or space to skip demo
                return
            if data:
                if keydebug:
                    print(
                        "rx: " + " ".join("{:02X}".format(b) for b in data), flush=True
                    )

            if game.piece is not planned_piece:
                target = _plan(game)
                planned_piece = game.piece

            now = monotonic()
            if target is not None and now >= next_action:
                dirty = _next_action(game, target)
                if dirty:
                    r.apply_dirty(game, dirty)
                    r.draw_score(game)
                    r.draw_next(game)
                next_action = now + ACTION_INTERVAL_S

            if now >= next_tick and not game.game_over:
                dirty = game.step()
                r.apply_dirty(game, dirty)
                r.draw_score(game)
                r.draw_next(game)
                next_tick = now + game.tick_interval()

            sleep(0.01)
