# Phase 1 — Load-Address Verification

Goal: confirm the `org` used for each ROM in the Makefile is correct, before
investing effort in labeling. A wrong origin makes branch targets land
mid-instruction and string references point at garbage, so this check is
prerequisite to everything downstream.

## Method

Each ROM is disassembled at a candidate origin. The origin is accepted if:

1. At least one intra-ROM jump/call target from an *external* ROM resolves to a
   sensible routine head (not mid-instruction, not inside a string).
2. At least one embedded string, located by scanning printable-ASCII runs, matches
   known on-screen UI text (SET-UP menu, status-line vocabulary, version string,
   baud-rate list, screen-photo labels).

Both conditions must hold. String matching alone is insufficient (strings are
relocatable data), and cross-ROM jump targets alone only prove *relative*
alignment.

## Evidence per ROM

### U4 @ 0x0000  — confirmed

- Cold-start bytes `F3 ED 56 DD 21 30 30 11 30 30 AF C3 3D 24` disassemble as
  `DI ; IM 1 ; LD IX,3030h ; LD DE,3030h ; XOR A ; JP 243Dh` — canonical Z80
  reset. The reset vector is fixed by CPU architecture; this alignment is not
  negotiable.
- The cold-start target `0x243D` lies in U5's range, matching the expected
  `U4 boot → U5 main` handoff.
- `RST 0` through `RST 38h` landing addresses (0x08, 0x10, 0x18, 0x20, 0x28, 0x30,
  0x38) contain instruction-aligned handler preludes (`push bc ; call ... ; pop
  bc ; ret`), consistent with normal RST-table usage.
- String-concat table at 0x08B7 contains exactly the baud-rate, SET-UP, copyright,
  and display-attribute vocabulary seen on real screen photos.
- Status-line vocabulary at 0x0E67 contains `XMIT / TIME: / MODE: / PAR OVR / FRA
  / DWLD / PROG / CURS / PROT / BAD / COMP: / OPER ERR: / COMM ERR: / ROM DIS /
  RAMDAT / RAMCMO / RAM` — matches the status bar visible in `../Screen_photos/`.

### U5 @ 0x2000  — confirmed

- The quick-SET-UP top-line banner at 0x23DF is `C=1=HDX 2=SILENT 3=BELL-OFF
  4=NOR 5=SMOOTH 6=9600 7=RESET 8=MENU 9=LOCE JUMP SMOOTH`. Exact match to the
  top of screen in menu mode.
- U4's cold-start target `0x243D` is 14 bytes past this banner, landing on
  executable code, not on the string.

### U6 @ 0x4000  — confirmed

- Address `0x4A9F` holds the entire SET-UP menu text (736 bytes), starting
  `A CURSOR :.FLASH-BLK.BLK.FLASH-UL.UL.OFF*B STATUS :.ON.DISP-ON-ERR.OFF*...`
  and ending `TYPE CTRL/HOME TO EXIT, CTRL/S TO SAVE AND EXIT, AND A-V TO CHANGE
  :?`. The `*` is the line separator; `.` separates values within a line.
- Address `0x4F00` holds the version string `AMPEX D175 TERMINAL  V 3.5=!`.
- First instruction at 0x400A (`LD HL,0AC4Fh ; LD DE,(0AC03h) ; LD A,(0AC07h) ;
  LD C,A ; LD B,0 ; LDIR ; RET`) is a clean block-copy primitive that reads its
  source/length from RAM pointers in the 0xAC00 region, consistent with a
  menu-text renderer being called with RAM-staged parameters.

### U8 @ 0xB000  — confirmed

- Entry `JR +0x2E` at 0xB000 lands on 0xB030.
- Jump table from 0xB009 through 0xB01F contains eight `C3 xx xx` entries, all
  pointing to addresses in the 0xB000–0xB6xx range (i.e., internal to U8).
- Splash text at 0xB6E5: `Version No. 63.3   Copyright (C) 1983   Star
  Technologies, Inc.`

## Emulation-list ordering (noted from U6 0x4A9F)

The SET-UP menu line R enumerates the emulations in this order:

```
0: AMPEX    1: IQ120    2: REG25    3: ADM5     4: VIEWP (VIEWPOINT)
5: VT52     6: TV920    7: TV950    8: H1500    9: H1410    10: H1420
```

The byte stored in NVRAM (or wherever the menu writes) when the user picks an
emulation is almost certainly this index. Locating the write site in the SET-UP
code (U6) will identify the **active-emulation state variable** needed by Phase 3.
