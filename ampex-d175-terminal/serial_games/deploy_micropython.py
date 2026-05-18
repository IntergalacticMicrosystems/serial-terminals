"""Copy the files needed to run serial_games on MicroPython to a drive.

Usage: python deploy_micropython.py <destination>

The destination can be any directory: a mounted MicroPython/CircuitPython
drive, a path used with mpremote's `fs cp -r`, or a staging folder.

Existing files at the destination are overwritten; existing files not
listed here (e.g. zgames/*.sav save states) are left alone.
"""

import os
import shutil
import sys


SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

FILES = [
    "main.py",
    "compat.py",
    "menu.py",
    "graphics.py",
    "serial_tetris.py",
    "tetris.py",
    "ampex.py",
    "demo.py",
    "serial_zork.py",
    "term_ampex.py",
]

DIRS = [
    "xyppy",
    "zgames",
]

SKIP_DIRS = {"__pycache__"}


def copy_one(src, dst):
    parent = os.path.dirname(dst)
    if parent:
        os.makedirs(parent, exist_ok=True)
    shutil.copy2(src, dst)
    print("  " + dst)


def copy_tree(src, dst):
    for root, dirs, files in os.walk(src):
        dirs[:] = [d for d in dirs if d not in SKIP_DIRS]
        rel = os.path.relpath(root, src)
        target = dst if rel == "." else os.path.join(dst, rel)
        os.makedirs(target, exist_ok=True)
        for name in files:
            copy_one(os.path.join(root, name), os.path.join(target, name))


def main(argv):
    if len(argv) != 2:
        print("usage: {} <destination>".format(argv[0]))
        return 2
    dst_root = argv[1]
    if not os.path.isdir(dst_root):
        print("error: {!r} is not a directory".format(dst_root))
        return 1

    print("Copying serial_games to " + dst_root)
    for name in FILES:
        copy_one(os.path.join(SCRIPT_DIR, name), os.path.join(dst_root, name))
    for name in DIRS:
        copy_tree(os.path.join(SCRIPT_DIR, name), os.path.join(dst_root, name))
    print("Done.")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
