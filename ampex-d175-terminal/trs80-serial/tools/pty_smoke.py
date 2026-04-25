#!/usr/bin/env python3
"""Smoke-test harness: forks the emulator with a pty and captures output.

Reads master for 2 seconds, dumps bytes as hex + decoded escape stream.
Requires a Model I ROM path as first arg so the emulator can boot.
"""
import os
import pty
import select
import subprocess
import sys
import time


def decode_chunk(data):
    lines = []
    i = 0
    while i < len(data):
        b = data[i]
        if b == 0x1B and i + 1 < len(data):
            nxt = data[i + 1]
            if nxt == ord('Y') and i + 3 < len(data):
                r = data[i + 2] - 0x20
                c = data[i + 3] - 0x20
                lines.append(f"ESC Y row={r} col={c}")
                i += 4
                continue
            if nxt in (ord('F'), ord('G'), ord('J'), ord('K')):
                lines.append(f"ESC {chr(nxt)}")
                i += 2
                continue
            lines.append(f"ESC 0x{nxt:02x}")
            i += 2
            continue
        if 0x20 <= b < 0x7f:
            lines.append(f"'{chr(b)}' (0x{b:02x})")
        else:
            lines.append(f"0x{b:02x}")
        i += 1
    return lines


def main():
    if len(sys.argv) < 2:
        print("usage: pty_smoke.py <rom-path> [extra-args...]", file=sys.stderr)
        sys.exit(2)
    rom = sys.argv[1]
    extra = sys.argv[2:]
    master, slave = pty.openpty()
    slave_name = os.ttyname(slave)
    bin_path = os.path.join(os.path.dirname(__file__), '..', 'build', 'trs80-ampex')
    cmd = [bin_path, '--serial-port', slave_name, '-romfile', rom, '-model', '1', *extra]
    print(f"launching: {' '.join(cmd)}", file=sys.stderr)
    env = os.environ.copy()
    env['HOME'] = '/tmp'
    p = subprocess.Popen(cmd, stdin=slave, stdout=sys.stderr, stderr=sys.stderr, env=env, close_fds=True)
    os.close(slave)
    received = bytearray()
    deadline = time.monotonic() + 3.0
    while time.monotonic() < deadline and p.poll() is None:
        r, _, _ = select.select([master], [], [], 0.2)
        if master in r:
            try:
                chunk = os.read(master, 4096)
            except OSError:
                break
            if not chunk:
                break
            received.extend(chunk)
    p.terminate()
    try:
        p.wait(timeout=2)
    except subprocess.TimeoutExpired:
        p.kill()
    print(f"\n=== received {len(received)} bytes ===", file=sys.stderr)
    for line in decode_chunk(received):
        print(line)


if __name__ == '__main__':
    main()
