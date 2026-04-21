"""MicroPython auto-boot entry point for SerialTetris on RP2350.

Wire UART0 TX (GP0) to the Ampex D-175 RxD, UART0 RX (GP1) to the
Ampex TxD, and a common ground. Terminal set to 19200 8N1 with
software XON/XOFF. On power-up the Pico runs this and the Tetris
demo appears on the Ampex.
"""

from compat import open_serial
from serial_tetris import play


ser = open_serial(
    port=0,
    baudrate=19200,
    xonxoff=True,
    flow_debug=True,
    disable_fifo=True,
)
try:
    play(ser, block_on=b"__", keydebug=False)
finally:
    ser.close()
