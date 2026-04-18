"""VT52-mode renderer for the Ampex D-175 terminal.

Every escape sequence emitted here is ✓-implemented in the D-175's VT52
dispatch per the tables in ../agents.md. We never emit a sequence that
routes to the RET-no-op handler at 0x2798.

Sequences used:
  ESC Y r c   direct cursor address (r, c with +0x20 bias)
  ESC J       erase to end of screen
  ESC K       erase to end of line

Notes:
  - D-175 VT52 has no ESC H (home), so a full clear is emitted as
    "ESC Y 0x20 0x20" followed by "ESC J" (cursor-to-origin, then
    erase-to-end-of-screen).
  - VT52 has no hide/restore-screen primitive, so pause clears the
    screen and writes PAUSED text; resume redraws chrome and does a
    full repaint.

The terminal must be in VT52 emulation mode (SET-UP parameter R) for
these sequences to be interpreted correctly.
"""

from tetris import PIECES, HEIGHT, WIDTH
import graphics as gfx

ESC = b'\x1b'


class Renderer:
    # Playfield is 22 cols wide (2 border + 20 cells); centered on an
    # 80-col screen at (80-22)/2 = col 29. Next box sits 4 cols to its right.
    PLAYFIELD_ROW = 1
    PLAYFIELD_COL = 30
    NEXT_BOX_ROW = 2
    NEXT_BOX_COL = 56
    SCORE_ROW = 22
    HELP_ROW = 23

    def __init__(self, ser, block_on=b'##'):
        if len(block_on) != 2:
            raise ValueError('block_on must be exactly 2 bytes')
        self.ser = ser
        self.block_on = block_on
        self.block_off = b'  '
        self.shadow = [[False] * WIDTH for _ in range(HEIGHT)]
        self.shadow_next = [[False] * 4 for _ in range(4)]
        self.last_score = None
        self.last_level = None
        self.last_lines = None
        self.last_next_kind = None

    def _write(self, data):
        if data:
            self.ser.write(data)

    def _screen_pos(self, r, c):
        return self.PLAYFIELD_ROW + r, self.PLAYFIELD_COL + 2 * c

    def _goto(self, r, c):
        return ESC + b'Y' + bytes([r + 0x20, c + 0x20])

    def _clear(self):
        return ESC + b'Y' + bytes([0x20, 0x20]) + ESC + b'J'

    def _erase_eol(self):
        return ESC + b'K'

    def draw_chrome(self):
        buf = bytearray()
        buf += self._clear()
        # Box borders use VT52 graphics-mode line-drawing glyphs.
        buf += gfx.ENTER_GFX
        buf += gfx.draw_box(0, 29, 22, HEIGHT + 2, rounded=True)
        buf += gfx.draw_box(1, 55, 10, 6, rounded=True)
        buf += gfx.EXIT_GFX
        # Labels stay in normal text mode.
        buf += self._goto(0, 55) + b'NEXT'
        buf += self._goto(self.HELP_ROW, 12)
        buf += b'arrows/hjkl move+rotate  space=hard drop  p pause  q quit'
        self._write(bytes(buf))

    def full_repaint(self, game):
        all_cells = {(r, c) for r in range(HEIGHT) for c in range(WIDTH)}
        self.shadow = [[False] * WIDTH for _ in range(HEIGHT)]
        self.apply_dirty(game, all_cells)
        self.shadow_next = [[False] * 4 for _ in range(4)]
        self.last_next_kind = None
        self.draw_next(game)
        self.last_score = self.last_level = self.last_lines = None
        self.draw_score(game)

    def apply_dirty(self, game, dirty):
        if not dirty:
            return
        cells = sorted(
            (r, c) for r, c in dirty
            if 0 <= r < HEIGHT and 0 <= c < WIDTH
        )
        buf = bytearray()
        last_r, last_c = -2, -2
        for r, c in cells:
            fill = game.is_filled(r, c)
            if fill == self.shadow[r][c]:
                continue
            self.shadow[r][c] = fill
            if not (r == last_r and c == last_c + 1):
                sr, sc = self._screen_pos(r, c)
                buf += self._goto(sr, sc)
            buf += self.block_on if fill else self.block_off
            last_r, last_c = r, c
        if buf:
            self._write(gfx.ENTER_GFX + bytes(buf) + gfx.EXIT_GFX)

    def draw_score(self, game):
        key = (game.score, game.level, game.lines)
        if key == (self.last_score, self.last_level, self.last_lines):
            return
        self.last_score, self.last_level, self.last_lines = key
        text = 'SCORE: {:05d}   LEVEL: {:02d}   LINES: {:03d}'.format(
            game.score, game.level, game.lines
        )
        col = (80 - len(text)) // 2
        buf = self._goto(self.SCORE_ROW, 0) + self._erase_eol()
        buf += self._goto(self.SCORE_ROW, col) + text.encode('ascii')
        self._write(buf)

    def draw_next(self, game):
        kind = game.next_piece.kind
        if kind == self.last_next_kind:
            return
        self.last_next_kind = kind
        offsets = set(PIECES[kind][0])
        buf = bytearray()
        last_r, last_c = -2, -2
        for r in range(4):
            for c in range(4):
                fill = (r, c) in offsets
                if fill == self.shadow_next[r][c]:
                    continue
                self.shadow_next[r][c] = fill
                if not (r == last_r and c == last_c + 1):
                    buf += self._goto(self.NEXT_BOX_ROW + r,
                                      self.NEXT_BOX_COL + 2 * c)
                buf += self.block_on if fill else self.block_off
                last_r, last_c = r, c
        if buf:
            self._write(gfx.ENTER_GFX + bytes(buf) + gfx.EXIT_GFX)

    def pause(self):
        self._write(self._clear() + self._goto(10, 32) + b'P A U S E D')

    def resume(self, game):
        self.draw_chrome()
        self.full_repaint(game)

    def draw_game_over(self, game):
        buf = bytearray()
        buf += self._clear()
        buf += self._goto(10, 30) + b'G A M E   O V E R'
        buf += self._goto(12, 30) + ' Final score: {:05d}'.format(game.score).encode('ascii')
        buf += self._goto(14, 30) + b' r to restart'
        self._write(bytes(buf))

    def farewell(self):
        self._write(self._clear() + self._goto(0, 0))
