"""Platform compatibility shim.

Exposes a uniform surface for the bits of the stdlib/pyserial that differ
between CPython and MicroPython (RP2350):
  - `monotonic()` / `sleep()` — time helpers.
  - `open_serial(port, baud, *, xonxoff=True, rtscts=False)` — returns an
    object with `.read(n) -> bytes`, `.write(data)`, `.close()`.

On CPython the serial object is a pyserial Serial (pyserial already
implements XON/XOFF natively). On MicroPython we wrap `machine.UART` and
implement XON/XOFF in Python: reads strip 0x11/0x13 and update state;
writes block while XOFF is active until XON arrives or a timeout fires.
"""

try:
    import machine  # noqa: F401  — sentinel: present only on MicroPython

    _MICROPYTHON = True
except ImportError:
    _MICROPYTHON = False


if _MICROPYTHON:
    import time as _time
    from machine import UART, Pin

    def monotonic():
        # ticks_ms rolls over every ~12 days on the RP2350; fine for a
        # Tetris session since all comparisons are short-window relative.
        return _time.ticks_ms() / 1000.0

    def sleep(seconds):
        _time.sleep(seconds)

    _XON = 0x11
    _XOFF = 0x13
    _XOFF_WRITE_TIMEOUT_S = 2.0
    # Chunk size for writes under xonxoff. Must be small enough that a
    # full chunk on the wire gives the Ampex time to send XOFF before
    # we overflow its receive buffer — at 19200 baud each chunk is ~17ms.
    _WRITE_CHUNK = 2
    # Oversize the RX buffer so XON/XOFF bytes don't get dropped if we
    # fall behind on reads during a long render burst.
    _RX_BUF = 256

    # PL011 UART register map. Base addresses are RP2350-specific (APB
    # peripheral memory map). Register offsets and bit layout are the
    # standard ARM PL011 and match RP2040.
    _UART_BASES = {0: 0x40070000, 1: 0x40078000}
    _UART_ATOMIC_CLR = 0x3000
    _UARTLCR_H_OFFSET = 0x2C
    _UARTCR_OFFSET = 0x30
    _FEN_BIT = 1 << 4  # LCR_H: FIFO enable
    _UARTEN_BIT = 1 << 0  # CR: UART enable

    def _disable_hw_fifo(uart_id):
        """Clear the FEN bit in UARTLCR_H so the TX/RX FIFOs shrink to
        1-byte holding registers. Reduces worst-case in-flight TX bytes
        from 32 to 1, so XOFF can halt us almost instantly. ARM PL011
        requires UARTEN to be 0 while LCR_H is modified."""
        base = _UART_BASES[uart_id]
        cr = base + _UARTCR_OFFSET
        lcr_h_clr = base + _UART_ATOMIC_CLR + _UARTLCR_H_OFFSET
        cr_clr = base + _UART_ATOMIC_CLR + _UARTCR_OFFSET
        cr_set = base + 0x2000 + _UARTCR_OFFSET  # atomic-set alias
        prev_cr = machine.mem32[cr]
        machine.mem32[cr_clr] = _UARTEN_BIT
        machine.mem32[lcr_h_clr] = _FEN_BIT
        if prev_cr & _UARTEN_BIT:
            machine.mem32[cr_set] = _UARTEN_BIT

    class _UartSerial:
        """machine.UART wrapped in a pyserial-compatible surface."""

        def __init__(
            self, uart_id, baudrate, xonxoff, flow_debug=False, disable_fifo=False
        ):
            # UART0 default pins on Pico 2: TX=GP0, RX=GP1.
            # UART1 default pins: TX=GP4, RX=GP5.
            if uart_id == 0:
                tx, rx = Pin(0), Pin(1)
            elif uart_id == 1:
                tx, rx = Pin(4), Pin(5)
            else:
                raise ValueError("unsupported UART id: {}".format(uart_id))
            # txbuf=0 disables the MicroPython software TX buffer so
            # uart.write() blocks on the 32-byte hardware FIFO. Without
            # this, the default 256-byte software buffer lets us dump
            # hundreds of bytes into the pipeline before any XOFF from
            # the terminal can reach us, and the terminal overflows.
            self._uart = UART(
                uart_id,
                baudrate=baudrate,
                tx=tx,
                rx=rx,
                rxbuf=_RX_BUF,
                txbuf=0,
            )
            if disable_fifo:
                _disable_hw_fifo(uart_id)
            self._xonxoff = xonxoff
            self._xoff = False
            self._rx_buf = bytearray()
            self._flow_debug = flow_debug
            self._flow_xoff_count = 0
            self._flow_xon_count = 0

        def _drain(self):
            chunk = self._uart.read()
            if not chunk:
                return
            if not self._xonxoff:
                self._rx_buf.extend(chunk)
                return
            for b in chunk:
                if b == _XOFF:
                    if not self._xoff:
                        self._flow_xoff_count += 1
                        if self._flow_debug:
                            print("[flow] XOFF #{}".format(self._flow_xoff_count))
                    self._xoff = True
                elif b == _XON:
                    if self._xoff:
                        self._flow_xon_count += 1
                        if self._flow_debug:
                            print("[flow] XON #{}".format(self._flow_xon_count))
                    self._xoff = False
                else:
                    self._rx_buf.append(b)

        def read(self, n=1):
            self._drain()
            if not self._rx_buf:
                return b""
            out = bytes(self._rx_buf[:n])
            # bytearray on MicroPython doesn't support slice deletion,
            # so reassign the tail instead of `del self._rx_buf[:n]`.
            self._rx_buf = self._rx_buf[n:]
            return out

        def _wait_for_xon(self):
            deadline = _time.ticks_add(
                _time.ticks_ms(), int(_XOFF_WRITE_TIMEOUT_S * 1000)
            )
            while self._xoff:
                self._drain()
                if not self._xoff:
                    return
                if _time.ticks_diff(_time.ticks_ms(), deadline) >= 0:
                    # Safety valve: assume terminal missed an XON and
                    # keep going, rather than hang forever.
                    self._xoff = False
                    return
                _time.sleep_ms(5)

        def write(self, data):
            if not self._xonxoff:
                return self._uart.write(data)
            # Chunk writes and drain RX between chunks so an XOFF sent
            # mid-burst can actually pause us before we overflow the
            # Ampex's receive buffer.
            mv = data if isinstance(data, (bytes, bytearray)) else bytes(data)
            i = 0
            total = 0
            n = len(mv)
            while i < n:
                self._drain()
                if self._xoff:
                    self._wait_for_xon()
                end = i + _WRITE_CHUNK
                if end > n:
                    end = n
                written = self._uart.write(mv[i:end]) or 0
                total += written
                i = end
                _time.sleep_ms(1)
            return total

        def close(self):
            self._uart.deinit()

    def open_serial(
        port,
        baudrate,
        *,
        xonxoff=True,
        rtscts=False,
        flow_debug=False,
        disable_fifo=False,
        **_,
    ):
        if rtscts:
            raise ValueError(
                "RTS/CTS flow control is not supported on MicroPython build"
            )
        return _UartSerial(
            port, baudrate, xonxoff, flow_debug=flow_debug, disable_fifo=disable_fifo
        )

else:
    from time import monotonic, sleep  # noqa: F401 — re-exported
    import serial

    def open_serial(
        port,
        baudrate,
        *,
        xonxoff=True,
        rtscts=False,
        flow_debug=False,
        disable_fifo=False,
        **_,
    ):
        # flow_debug / disable_fifo are no-ops on CPython — pyserial
        # handles flow control; hardware FIFO is managed by the USB-serial
        # adapter and OS driver, not accessible from Python.
        _ = flow_debug, disable_fifo
        return serial.Serial(
            port=port,
            baudrate=baudrate,
            bytesize=8,
            parity="N",
            stopbits=1,
            timeout=0,
            xonxoff=xonxoff,
            rtscts=rtscts,
        )
