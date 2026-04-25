"""VT52 graphics character library for the Ampex D-175.

Provides:
  - Box drawing (sharp or rounded corners) and isolated H/V line runs.
  - A virtual pixel buffer (SextantBuffer) rendered as 2x3 pseudo-pixel
    block characters, with diff rendering.

Graphics-mode toggling is caller-managed: library bytes contain only
VT52 cursor addresses (ESC Y r c) plus graphics glyph bytes. Bracket
writes with `graphics_mode(writer)` or ENTER_GFX / EXIT_GFX.

Sextant encoding (see VT52_graphics.md):
  code = 0x20 + bitmask
    bit 0 (0x01): TL   bit 1 (0x02): TR
    bit 2 (0x04): ML   bit 3 (0x08): MR
    bit 4 (0x10): BL   bit 5 (0x20): BR
"""

import math


ENTER_GFX = b"\x1b\x46"
EXIT_GFX = b"\x1b\x47"


class graphics_mode:
    """Context manager that writes ENTER_GFX on enter, EXIT_GFX on exit."""

    def __init__(self, writer):
        self._writer = writer

    def __enter__(self):
        self._writer.write(ENTER_GFX)
        return self

    def __exit__(self, *exc):
        self._writer.write(EXIT_GFX)
        return False


def _goto(row, col):
    return b"\x1bY" + bytes([row + 0x20, col + 0x20])


# Box-drawing glyph codes (observed on the D-175, see VT52_graphics.md)
_CORNERS_SHARP = (0x60, 0x61, 0x62, 0x63)  # UL, UR, LL, LR
# Rounded corners: empirically, 0x6B=LL, 0x6E=LR, 0x6C=UL, 0x6D=UR on the D-175.
_CORNERS_ROUNDED = (0x6C, 0x6D, 0x6B, 0x6E)  # UL, UR, LL, LR
_HLINE = 0x68
_VLINE = 0x69


def draw_box(row, col, width, height, rounded=False):
    """Draw a rectangular outline at terminal (row, col) of the given
    cell dimensions. Returns bytes (ESC Y positioning + glyph bytes).
    Caller must be in graphics mode when writing these bytes."""
    if width < 2 or height < 2:
        raise ValueError("box needs width >= 2 and height >= 2")
    ul, ur, ll, lr = _CORNERS_ROUNDED if rounded else _CORNERS_SHARP
    buf = bytearray()
    buf += _goto(row, col)
    buf.append(ul)
    buf += bytes([_HLINE] * (width - 2))
    buf.append(ur)
    for r in range(1, height - 1):
        buf += _goto(row + r, col)
        buf.append(_VLINE)
        buf += _goto(row + r, col + width - 1)
        buf.append(_VLINE)
    buf += _goto(row + height - 1, col)
    buf.append(ll)
    buf += bytes([_HLINE] * (width - 2))
    buf.append(lr)
    return bytes(buf)


def draw_hline(row, col, length):
    """Horizontal line of `length` cells starting at (row, col)."""
    if length < 1:
        raise ValueError("length >= 1")
    return _goto(row, col) + bytes([_HLINE] * length)


def draw_vline(row, col, length):
    """Vertical line of `length` cells starting at (row, col)."""
    if length < 1:
        raise ValueError("length >= 1")
    buf = bytearray()
    for i in range(length):
        buf += _goto(row + i, col)
        buf.append(_VLINE)
    return bytes(buf)


# 3x5 uppercase bitmap font. Unknown glyphs render as blanks.
_FONT = {
    "A": [".#.", "#.#", "###", "#.#", "#.#"],
    "B": ["##.", "#.#", "##.", "#.#", "##."],
    "C": [".##", "#..", "#..", "#..", ".##"],
    "D": ["##.", "#.#", "#.#", "#.#", "##."],
    "E": ["###", "#..", "##.", "#..", "###"],
    "F": ["###", "#..", "##.", "#..", "#.."],
    "G": [".##", "#..", "#.#", "#.#", ".##"],
    "H": ["#.#", "#.#", "###", "#.#", "#.#"],
    "I": ["###", ".#.", ".#.", ".#.", "###"],
    "J": ["..#", "..#", "..#", "#.#", ".#."],
    "K": ["#.#", "#.#", "##.", "#.#", "#.#"],
    "L": ["#..", "#..", "#..", "#..", "###"],
    "M": ["#.#", "###", "###", "#.#", "#.#"],
    "N": ["#.#", "###", "###", "###", "#.#"],
    "O": [".#.", "#.#", "#.#", "#.#", ".#."],
    "P": ["##.", "#.#", "##.", "#..", "#.."],
    "Q": [".#.", "#.#", "#.#", "###", ".##"],
    "R": ["##.", "#.#", "##.", "#.#", "#.#"],
    "S": [".##", "#..", ".#.", "..#", "##."],
    "T": ["###", ".#.", ".#.", ".#.", ".#."],
    "U": ["#.#", "#.#", "#.#", "#.#", ".#."],
    "V": ["#.#", "#.#", "#.#", ".#.", ".#."],
    "W": ["#.#", "#.#", "###", "###", "#.#"],
    "X": ["#.#", "#.#", ".#.", "#.#", "#.#"],
    "Y": ["#.#", "#.#", ".#.", ".#.", ".#."],
    "Z": ["###", "..#", ".#.", "#..", "###"],
    "0": [".#.", "#.#", "#.#", "#.#", ".#."],
    "1": [".#.", "##.", ".#.", ".#.", "###"],
    "2": ["##.", "..#", ".#.", "#..", "###"],
    "3": ["##.", "..#", ".#.", "..#", "##."],
    "4": ["#.#", "#.#", "###", "..#", "..#"],
    "5": ["###", "#..", "##.", "..#", "##."],
    "6": [".##", "#..", "##.", "#.#", ".#."],
    "7": ["###", "..#", ".#.", "#..", "#.."],
    "8": [".#.", "#.#", ".#.", "#.#", ".#."],
    "9": [".#.", "#.#", ".##", "..#", "##."],
    " ": ["...", "...", "...", "...", "..."],
    ".": ["...", "...", "...", "...", ".#."],
    ",": ["...", "...", "...", ".#.", "#.."],
    ":": ["...", ".#.", "...", ".#.", "..."],
    ";": ["...", ".#.", "...", ".#.", "#.."],
    "!": [".#.", ".#.", ".#.", "...", ".#."],
    "?": ["##.", "..#", ".#.", "...", ".#."],
    "-": ["...", "...", "###", "...", "..."],
    "+": ["...", ".#.", "###", ".#.", "..."],
    "=": ["...", "###", "...", "###", "..."],
    "/": ["..#", "..#", ".#.", "#..", "#.."],
    "\\": ["#..", "#..", ".#.", "..#", "..#"],
    "(": [".#.", "#..", "#..", "#..", ".#."],
    ")": [".#.", "..#", "..#", "..#", ".#."],
    "[": ["##.", "#..", "#..", "#..", "##."],
    "]": [".##", "..#", "..#", "..#", ".##"],
    "<": ["..#", ".#.", "#..", ".#.", "..#"],
    ">": ["#..", ".#.", "..#", ".#.", "#.."],
    "*": ["...", "#.#", ".#.", "#.#", "..."],
}

FONT_WIDTH = 3
FONT_HEIGHT = 5
FONT_ADVANCE = 4  # 3 pixels + 1 column gap


class SextantBuffer:
    """2D bit buffer, rendered as 2x3 pseudo-pixel sextant characters.

    pixel_width is padded up to the next multiple of 2.
    pixel_height is padded up to the next multiple of 3.
    """

    def __init__(self, pixel_width, pixel_height):
        if pixel_width < 1 or pixel_height < 1:
            raise ValueError("buffer must be at least 1x1")
        w = ((pixel_width + 1) // 2) * 2
        h = ((pixel_height + 2) // 3) * 3
        self._w = w
        self._h = h
        self._cw = w // 2
        self._ch = h // 3
        self._px = bytearray(w * h)
        self._committed = None

    @property
    def width_px(self):
        return self._w

    @property
    def height_px(self):
        return self._h

    @property
    def cell_size(self):
        return (self._cw, self._ch)

    # --- primitives ---

    def clear(self):
        for i in range(len(self._px)):
            self._px[i] = 0

    def fill(self, on=True):
        v = 1 if on else 0
        for i in range(len(self._px)):
            self._px[i] = v

    def set_pixel(self, x, y, on=True):
        if 0 <= x < self._w and 0 <= y < self._h:
            self._px[y * self._w + x] = 1 if on else 0

    def get_pixel(self, x, y):
        if 0 <= x < self._w and 0 <= y < self._h:
            return self._px[y * self._w + x] == 1
        return False

    def line(self, x0, y0, x1, y1, on=True):
        dx = abs(x1 - x0)
        dy = abs(y1 - y0)
        sx = 1 if x0 < x1 else -1
        sy = 1 if y0 < y1 else -1
        err = dx - dy
        while True:
            self.set_pixel(x0, y0, on)
            if x0 == x1 and y0 == y1:
                break
            e2 = 2 * err
            if e2 > -dy:
                err -= dy
                x0 += sx
            if e2 < dx:
                err += dx
                y0 += sy

    def rect(self, x, y, w, h, on=True):
        if w < 1 or h < 1:
            return
        self.line(x, y, x + w - 1, y, on)
        self.line(x, y + h - 1, x + w - 1, y + h - 1, on)
        self.line(x, y, x, y + h - 1, on)
        self.line(x + w - 1, y, x + w - 1, y + h - 1, on)

    def fill_rect(self, x, y, w, h, on=True):
        if w < 1 or h < 1:
            return
        v = 1 if on else 0
        x0 = max(0, x)
        y0 = max(0, y)
        x1 = min(self._w, x + w)
        y1 = min(self._h, y + h)
        for yy in range(y0, y1):
            base = yy * self._w
            for xx in range(x0, x1):
                self._px[base + xx] = v

    def circle(self, cx, cy, r, on=True):
        if r <= 0:
            self.set_pixel(cx, cy, on)
            return
        x = r
        y = 0
        d = 1 - r
        while x >= y:
            self.set_pixel(cx + x, cy + y, on)
            self.set_pixel(cx - x, cy + y, on)
            self.set_pixel(cx + x, cy - y, on)
            self.set_pixel(cx - x, cy - y, on)
            self.set_pixel(cx + y, cy + x, on)
            self.set_pixel(cx - y, cy + x, on)
            self.set_pixel(cx + y, cy - x, on)
            self.set_pixel(cx - y, cy - x, on)
            if d < 0:
                d += 2 * y + 3
            else:
                d += 2 * (y - x) + 5
                x -= 1
            y += 1

    def fill_circle(self, cx, cy, r, on=True):
        if r <= 0:
            self.set_pixel(cx, cy, on)
            return
        for dy in range(-r, r + 1):
            dx = int(math.sqrt(r * r - dy * dy))
            y = cy + dy
            for x in range(cx - dx, cx + dx + 1):
                self.set_pixel(x, y, on)

    def arc(self, cx, cy, r, start_deg, end_deg, on=True):
        """Sampled parametric arc. 0 deg = east, 90 deg = up, counter-clockwise."""
        if r <= 0:
            self.set_pixel(cx, cy, on)
            return
        if end_deg < start_deg:
            end_deg += 360.0
        span = end_deg - start_deg
        n = max(8, int(2 * math.pi * r * span / 360.0))
        for i in range(n + 1):
            t = math.radians(start_deg + span * i / n)
            x = cx + int(round(r * math.cos(t)))
            y = cy - int(round(r * math.sin(t)))
            self.set_pixel(x, y, on)

    def draw_text(self, x, y, text, on=True):
        """Render uppercase ASCII via the 3x5 font. Unknown chars draw blank."""
        blank = _FONT[" "]
        for ch in text.upper():
            glyph = _FONT.get(ch, blank)
            for dy, row in enumerate(glyph):
                for dx, px in enumerate(row):
                    if px == "#":
                        self.set_pixel(x + dx, y + dy, on)
            x += FONT_ADVANCE

    # --- output ---

    def _sextant_at(self, cx, cy):
        w = self._w
        base = (3 * cy) * w + (2 * cx)
        p = self._px
        mask = (
            (p[base] << 0)
            | (p[base + 1] << 1)
            | (p[base + w] << 2)
            | (p[base + w + 1] << 3)
            | (p[base + 2 * w] << 4)
            | (p[base + 2 * w + 1] << 5)
        )
        return 0x20 + mask

    def render_full(self, row, col):
        """Return bytes to paint the full buffer at terminal (row, col).
        Also seeds the committed snapshot for subsequent render_diff."""
        buf = bytearray()
        committed = [[0] * self._cw for _ in range(self._ch)]
        for cy in range(self._ch):
            buf += _goto(row + cy, col)
            for cx in range(self._cw):
                code = self._sextant_at(cx, cy)
                buf.append(code)
                committed[cy][cx] = code
        self._committed = committed
        return bytes(buf)

    def render_diff(self, row, col):
        """Emit only cells whose sextant code differs from the committed
        snapshot; updates the snapshot. Returns b'' if no changes."""
        if self._committed is None:
            return self.render_full(row, col)
        buf = bytearray()
        last_r, last_c = -2, -2
        for cy in range(self._ch):
            for cx in range(self._cw):
                code = self._sextant_at(cx, cy)
                if code == self._committed[cy][cx]:
                    continue
                self._committed[cy][cx] = code
                if not (cy == last_r and cx == last_c + 1):
                    buf += _goto(row + cy, col + cx)
                buf.append(code)
                last_r, last_c = cy, cx
        return bytes(buf)

    def invalidate(self):
        """Drop the committed snapshot so the next render_diff does a full paint."""
        self._committed = None
