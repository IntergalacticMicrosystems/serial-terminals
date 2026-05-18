"""Ampex D-175 terminal driver for the vendored xyppy Z-machine.

Implements the surface that xyppy's `vterm.Screen` and `ops_impl_compat`
expect from the upstream `xyppy.term` module, but emits D-175 VT52
escape sequences (with the Ampex quirks — ESC t for clear-to-EOL, ESC Y
for absolute positioning) and routes all I/O through the serial object
opened by `compat.open_serial`.

`xyppy/term.py` is a shim that does `from term_ampex import *`, so
existing `xyppy.term.<name>` references inside vterm/ops_impl_compat
land here without per-site edits.
"""

from compat import sleep

ESC = b"\x1b"

_SCREEN_W = 80
_SCREEN_TOP = 1
_SCREEN_H = 23

# Module-level cursor tracking. xyppy moves the cursor by relative
# offsets (cursor_down(n), cursor_right(n), ...); we map each call to
# an absolute ESC Y row col so we don't need a VT52 relative move.
_row = 0
_col = 0

_SER = None
_KEYDEBUG = False

# Pushback buffer for bytes peeked during ESC-sequence decoding.
_pending = bytearray()

# Xyppy's vterm checks `term.is_windows` in slow_scroll_effect. We
# disable slow-scroll via env.options.no_slow_scroll anyway, but the
# attribute must exist.
is_windows = False


def set_serial(ser, keydebug=False):
    global _SER, _KEYDEBUG, _row, _col, _pending
    _SER = ser
    _KEYDEBUG = keydebug
    _row = 0
    _col = 0
    _pending = bytearray()


# --- helpers ----------------------------------------------------------

def _emit_pos():
    _SER.write(ESC + b"Y" + bytes([_row + _SCREEN_TOP + 0x20, _col + 0x20]))


def _advance_col(n=1):
    global _col
    _col += n
    if _col >= _SCREEN_W:
        _col = _SCREEN_W - 1


# --- xyppy term API ---------------------------------------------------

def init():
    pass


def flush():
    pass


def get_size():
    return _SCREEN_W, _SCREEN_H


def home_cursor():
    global _row, _col
    _row, _col = 0, 0
    _emit_pos()


def cursor_up(count=1):
    global _row
    _row = max(0, _row - count)
    _emit_pos()


def cursor_down(count=1):
    global _row
    _row = min(_SCREEN_H - 1, _row + count)
    _emit_pos()


def cursor_left(count=1):
    global _col
    _col = max(0, _col - count)
    _emit_pos()


def cursor_right(count=1):
    global _col
    _col = min(_SCREEN_W - 1, _col + count)
    _emit_pos()


def cursor_to_left_side():
    global _col
    _col = 0
    _emit_pos()


def scroll_down():
    # No VT52 scroll-up primitive on the D-175. Park the cursor at the
    # bottom row and emit LF — most terminals scroll in this case.
    # vterm's flush() repaints the whole buffer anyway, so any visual
    # glitch from a missed scroll is corrected by the next flush.
    global _row, _col
    _row = _SCREEN_H - 1
    _col = 0
    _emit_pos()
    _SER.write(b"\n")


def clear_screen():
    global _row, _col
    _row, _col = 0, 0
    _emit_pos()
    _SER.write(ESC + b"J")


def clear_line():
    global _col
    _col = 0
    _emit_pos()
    _SER.write(ESC + b"t")  # D-175 quirk: ESC t (not ESC K)


def fill_to_eol_with_bg_color():
    _SER.write(ESC + b"t")


# --- colors and cursor visibility (no-ops on monochrome Ampex) -------

def set_color(fg, bg):
    pass


def reset_color():
    pass


def show_cursor():
    pass


def hide_cursor():
    pass


def supports_unicode():
    return False


# --- output -----------------------------------------------------------

def write_char_with_color(char, fg_col, bg_col):
    global _row, _col
    if char == "\n":
        # The D-175 auto-wraps past column 80, so after vterm.flush()
        # has written a full row the hardware cursor may already be on
        # the next row. Emitting \r\n on top of that produces a blank
        # line between every row. Resync with ESC Y instead.
        _emit_pos()
        _SER.write(ESC + b"t")
        _row = min(_SCREEN_H - 1, _row + 1)
        _col = 0
        _emit_pos()
    else:
        _SER.write(char.encode("ascii", "replace"))
        _advance_col(1)


def puts(s):
    global _row, _col
    _SER.write(s.encode("ascii", "replace"))
    for c in s:
        if c == "\n":
            _row = min(_SCREEN_H - 1, _row + 1)
            _col = 0
        elif c == "\r":
            _col = 0
        elif c == "\b":
            _col = max(0, _col - 1)
        else:
            _advance_col(1)


# --- input ------------------------------------------------------------

_used_esc_char_list = [
    "[A", "[B", "[C", "[D",
    "OP", "OQ", "OR", "OS", "[15~", "[17~",
    "[18~", "[19~", "[20~", "[21~", "[23~", "[24~",
]


def is_zscii_special_key(seq):
    return len(seq) >= 2 and seq[0] == "\x1b" and seq[1:] in _used_esc_char_list


def _read_byte_blocking():
    if _pending:
        b = _pending[0]
        del _pending[0]
        return b
    while True:
        data = _SER.read(1)
        if data:
            if _KEYDEBUG:
                print("[key] 0x{:02x}".format(data[0]))
            return data[0]
        sleep(0.005)


def _read_byte_with_timeout(timeout_s):
    if _pending:
        b = _pending[0]
        del _pending[0]
        return b
    # Poll a few times totalling ~timeout_s. Coarse is fine — used only
    # to detect whether ESC stands alone or starts a VT52 sequence.
    waited = 0.0
    step = 0.01
    while waited < timeout_s:
        data = _SER.read(1)
        if data:
            if _KEYDEBUG:
                print("[key] 0x{:02x}".format(data[0]))
            return data[0]
        sleep(step)
        waited += step
    return None


def getch_or_esc_seq():
    """Block until we have a char or escape sequence. Returns a string.

    Translates D-175 VT52 arrows (ESC A/B/C/D) into the ANSI forms
    `\\x1b[A`-`\\x1b[D` that xyppy's CursorLine recognises, so the
    in-game line editor (left/right/home/end) works unchanged.
    """
    b = _read_byte_blocking()
    # D-175's BACK SPACE key sends 0x01 (SOH), not the ASCII BS (0x08)
    # xyppy's CursorLine looks for. Translate at the input boundary.
    if b == 0x01:
        return "\b"
    if b != 0x1B:
        return chr(b)

    # ESC received. Peek the next byte; if it's A/B/C/D, this is a
    # VT52 arrow — translate to ANSI. Otherwise hand back a bare ESC
    # and stash the trailing byte for the next call.
    n1 = _read_byte_with_timeout(0.05)
    if n1 is None:
        return "\x1b"
    if n1 in (0x41, 0x42, 0x43, 0x44):
        return "\x1b[" + chr(n1)
    _pending.append(n1)
    return "\x1b"
