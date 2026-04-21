"""Pure Tetris game logic. No I/O."""

import random

WIDTH = 10
HEIGHT = 20

PIECES = {
    'I': [
        [(1, 0), (1, 1), (1, 2), (1, 3)],
        [(0, 2), (1, 2), (2, 2), (3, 2)],
        [(2, 0), (2, 1), (2, 2), (2, 3)],
        [(0, 1), (1, 1), (2, 1), (3, 1)],
    ],
    'O': [
        [(0, 1), (0, 2), (1, 1), (1, 2)],
        [(0, 1), (0, 2), (1, 1), (1, 2)],
        [(0, 1), (0, 2), (1, 1), (1, 2)],
        [(0, 1), (0, 2), (1, 1), (1, 2)],
    ],
    'T': [
        [(0, 1), (1, 0), (1, 1), (1, 2)],
        [(0, 1), (1, 1), (1, 2), (2, 1)],
        [(1, 0), (1, 1), (1, 2), (2, 1)],
        [(0, 1), (1, 0), (1, 1), (2, 1)],
    ],
    'S': [
        [(0, 1), (0, 2), (1, 0), (1, 1)],
        [(0, 1), (1, 1), (1, 2), (2, 2)],
        [(1, 1), (1, 2), (2, 0), (2, 1)],
        [(0, 0), (1, 0), (1, 1), (2, 1)],
    ],
    'Z': [
        [(0, 0), (0, 1), (1, 1), (1, 2)],
        [(0, 2), (1, 1), (1, 2), (2, 1)],
        [(1, 0), (1, 1), (2, 1), (2, 2)],
        [(0, 1), (1, 0), (1, 1), (2, 0)],
    ],
    'J': [
        [(0, 0), (1, 0), (1, 1), (1, 2)],
        [(0, 1), (0, 2), (1, 1), (2, 1)],
        [(1, 0), (1, 1), (1, 2), (2, 2)],
        [(0, 1), (1, 1), (2, 0), (2, 1)],
    ],
    'L': [
        [(0, 2), (1, 0), (1, 1), (1, 2)],
        [(0, 1), (1, 1), (2, 1), (2, 2)],
        [(1, 0), (1, 1), (1, 2), (2, 0)],
        [(0, 0), (0, 1), (1, 1), (2, 1)],
    ],
}

KINDS = 'IOTSZJL'
LINE_SCORES = {1: 40, 2: 100, 3: 300, 4: 1200}


class Piece:
    __slots__ = ('kind', 'row', 'col', 'rotation')

    def __init__(self, kind, row=0, col=3, rotation=0):
        self.kind = kind
        self.row = row
        self.col = col
        self.rotation = rotation

    def cells(self):
        return [(self.row + dr, self.col + dc)
                for dr, dc in PIECES[self.kind][self.rotation]]


class Game:
    def __init__(self, rng=None):
        # MicroPython's `random` has no `Random` class, but the module
        # itself exposes `.choice()`, so it works as a drop-in rng.
        self._rng = rng if rng is not None else random
        self.board = [[0] * WIDTH for _ in range(HEIGHT)]
        self.piece = self._new_piece()
        self.next_piece = self._new_piece()
        self.score = 0
        self.level = 1
        self.lines = 0
        self.paused = False
        self.game_over = False

    def _new_piece(self):
        return Piece(self._rng.choice(KINDS))

    def tick_interval(self):
        return max(0.05, 0.5 - 0.05 * (self.level - 1))

    def _collides(self, kind, row, col, rotation):
        for dr, dc in PIECES[kind][rotation]:
            r = row + dr
            c = col + dc
            if r < 0 or r >= HEIGHT or c < 0 or c >= WIDTH:
                return True
            if self.board[r][c]:
                return True
        return False

    def is_filled(self, r, c):
        if self.board[r][c]:
            return True
        return (r, c) in self.piece.cells()

    def toggle_pause(self):
        if not self.game_over:
            self.paused = not self.paused

    def move(self, dx):
        if self.paused or self.game_over:
            return set()
        old = set(self.piece.cells())
        if not self._collides(self.piece.kind, self.piece.row,
                              self.piece.col + dx, self.piece.rotation):
            self.piece.col += dx
        return old | set(self.piece.cells())

    def rotate(self):
        if self.paused or self.game_over:
            return set()
        old = set(self.piece.cells())
        new_rot = (self.piece.rotation + 1) % 4
        if not self._collides(self.piece.kind, self.piece.row,
                              self.piece.col, new_rot):
            self.piece.rotation = new_rot
        return old | set(self.piece.cells())

    def step(self):
        if self.paused or self.game_over:
            return set()
        old = set(self.piece.cells())
        if not self._collides(self.piece.kind, self.piece.row + 1,
                              self.piece.col, self.piece.rotation):
            self.piece.row += 1
            return old | set(self.piece.cells())
        return self._lock_and_advance(old)

    def soft_drop(self):
        return self.step()

    def hard_drop(self):
        if self.paused or self.game_over:
            return set()
        old = set(self.piece.cells())
        while not self._collides(self.piece.kind, self.piece.row + 1,
                                 self.piece.col, self.piece.rotation):
            self.piece.row += 1
        return self._lock_and_advance(old)

    def _lock_and_advance(self, old_cells):
        piece_id = KINDS.index(self.piece.kind) + 1
        for r, c in self.piece.cells():
            if 0 <= r < HEIGHT and 0 <= c < WIDTH:
                self.board[r][c] = piece_id
        cleared = self._clear_lines()
        if cleared:
            self._score_lines(cleared)
            dirty = {(r, c) for r in range(HEIGHT) for c in range(WIDTH)}
        else:
            dirty = set(old_cells)
            dirty |= {(r, c) for r, c in self.piece.cells()
                      if 0 <= r < HEIGHT and 0 <= c < WIDTH}
        self.piece = self.next_piece
        self.next_piece = self._new_piece()
        if self._collides(self.piece.kind, self.piece.row,
                          self.piece.col, self.piece.rotation):
            self.game_over = True
        dirty |= {(r, c) for r, c in self.piece.cells()
                  if 0 <= r < HEIGHT and 0 <= c < WIDTH}
        return dirty

    def _clear_lines(self):
        full = [r for r in range(HEIGHT) if all(self.board[r])]
        for r in full:
            del self.board[r]
            self.board.insert(0, [0] * WIDTH)
        return len(full)

    def _score_lines(self, n):
        self.score += LINE_SCORES.get(n, 0) * self.level
        self.lines += n
        self.level = self.lines // 10 + 1
