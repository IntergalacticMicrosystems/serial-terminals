#!/usr/bin/env python3
"""Dump the emulation patch records at U4:0x0433, 0x0441, 0x0445.

Each pointer table holds one 16-bit little-endian address per emulation
index. The address points to a record of the form:
  <count>  <off1> <val1>  <off2> <val2>  ...

The patch applier at U4:0x040D overwrites RAM[base+offN] = valN for each pair.
"""
import os

U4 = open(os.path.join(os.path.dirname(__file__), "..", "EPROM_dumps",
                      "U4-TMS2764JL.bin"), "rb").read()


def read_word_le(rom, off):
    return rom[off] | (rom[off + 1] << 8)


def follow_record(rom, ptr):
    """Read the patch record at `ptr`. Returns list of (off, val)."""
    off = ptr
    count = rom[off]
    pairs = []
    for i in range(count):
        pairs.append((rom[off + 1 + 2 * i], rom[off + 2 + 2 * i]))
    return pairs, off + 1 + 2 * count  # return pairs + end-offset


def dump_table(name, table_addr, num_entries, apply_base, emul_names):
    print(f"\n=== Patch table {name} at U4:0x{table_addr:04X}"
          f" ({num_entries} entries, applied at RAM 0x{apply_base:04X}) ===")
    end = 0
    for i in range(num_entries):
        ptr = read_word_le(U4, table_addr + 2 * i)
        pairs, rec_end = follow_record(U4, ptr)
        end = max(end, rec_end)
        label = emul_names[i] if i < len(emul_names) else f"idx{i}"
        print(f"\n  [{i}] {label}: record at 0x{ptr:04X}, {len(pairs)} patch(es):")
        for off, val in pairs:
            cmd = apply_base + off - 0xA983 if apply_base == 0xA983 else None
            ctx = ""
            if apply_base == 0xA983:
                # offset is raw into RAM starting at 0xA983
                cmd_idx = off
                if 0x20 <= cmd_idx < 0x7F:
                    ctx = f"  (cmd 0x{cmd_idx:02X} = {chr(cmd_idx)!r})"
                elif 0x80 <= cmd_idx < 0xA0:
                    ctx = f"  (cmd 0x{cmd_idx:02X} extended)"
                else:
                    ctx = f"  (cmd 0x{cmd_idx:02X})"
            elif apply_base == 0xAA03:
                cmd_idx = 0x80 + off
                ctx = f"  (cmd 0x{cmd_idx:02X} extended)"
            print(f"       offset 0x{off:02X}  val 0x{val:02X}{ctx}")
    print(f"\n  (highest record byte used: 0x{end:04X})")


FULL_NAMES = [
    "AMPEX", "IQ120", "REG25", "ADM5", "VIEWP", "VT52", "TV920",
    "TV950", "H1500", "H1410", "H1420",
]


def main():
    # Table at 0x0433: first-pass patches applied at 0xA983 for emuls 0..6 (7 entries)
    dump_table("first-pass (0x0433)", 0x0433, 7, 0xA983, FULL_NAMES[:7])

    # Table at 0x0445: second-pass patches applied at 0xAA03.
    # AMPEX skips the second pass ("ret z" at U4:0x03B2), so the table
    # contains entries for emuls 1..6 (6 entries).
    dump_table("second-pass (0x0445)", 0x0445, 6, 0xAA03, FULL_NAMES[1:7])

    # Table at 0x0441: applied at 0xA983 (third base's patch table).
    # Used for emuls 9..10 (H1410, H1420). H1500 (emul 8) uses the unpatched base.
    dump_table("third-base (0x0441)", 0x0441, 2, 0xA983, FULL_NAMES[9:11])

    # TV950 (emul 7) special case. The loader at U4:0x03BF does:
    #   call sub_0428h         ; clear 0xA983..0xA9A2
    #   ld de, 0x2014 ; ex de,hl ; ld bc,0x60 ; ldir   ; copy TV950 base to 0xA9A3
    #   ld hl, 0x1D61 ; ld de,0xAA03 ; ld bc,0x20 ; ldir
    #   jr l03b3h
    # Falling into l03b3h with A = 7 (via jr l03b3h after `cp 007h; jr z, l03bfh`)
    # executes:
    #   dec a             ; A = 6
    #   ld hl, 0x0445
    #   call sub_041fh    ; index table by A=6 -> fetch 7th entry
    #   ld hl, 0xAA03
    #   jr sub_040dh
    # So TV950 reads one-past-the-end of the 6-entry 0x0445 table.
    # Print what actually lives at that offset so the caller can judge if it
    # is a benign no-op record or garbage.
    print("\n=== TV950 second-pass quirk ===")
    tv950_ptr = read_word_le(U4, 0x0445 + 2 * 6)
    print(f"  Pointer slot at 0x{0x0445 + 2*6:04X} (one past 6-entry table):"
          f" 0x{tv950_ptr:04X}")
    try:
        pairs, end = follow_record(U4, tv950_ptr)
        print(f"  Record at 0x{tv950_ptr:04X}: {len(pairs)} pair(s)")
        for off, val in pairs[:10]:
            print(f"       offset 0x{off:02X}  val 0x{val:02X}")
    except IndexError:
        print("  (pointer out of ROM range — would read garbage)")


if __name__ == "__main__":
    main()
