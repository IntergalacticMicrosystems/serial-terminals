; Relabelled disassembly. Origin H'0000'.
; Symbols loaded from: U1.sym (3 addr, 12 port)
; Idempotent — re-run after editing U1.sym to refresh.
;
        CPU MK3850
;
; --- Symbol table (from .sym file; needed for asl reassembly) ---
reset_vector:           EQU H'0000'
poll_or_xlate_loop:     EQU H'0005'
xlate_helper_004E:      EQU H'004E'
PORT_CPU_0:             EQU H'00'
PORT_CPU_1:             EQU H'01'
PORT_PIO_04:            EQU H'04'
PORT_PIO_05:            EQU H'05'
PORT_PIO_06:            EQU H'06'
PORT_PIO_07:            EQU H'07'
PORT_PIO_08:            EQU H'08'
PORT_PIO_0A:            EQU H'0A'
PORT_SMI_VEC_HI:        EQU H'0C'
PORT_SMI_VEC_LO:        EQU H'0D'
PORT_SMI_ICP:           EQU H'0E'
PORT_SMI_TIMER:         EQU H'0F'
;
        ORG H'0000'
;
        JMP  H'0800'                    ; 000: 29 08 00
        LI   H'7F'                      ; 003: 20 7f
        NS   4                          ; 005: f4
        LR   4,A                        ; 006: 54
        BR   xlate_helper_004E          ; 007: 90 46
        LR   A,4                        ; 009: 44
        OI   H'20'                      ; 00a: 22 20
        BR   H'0006'                    ; 00c: 90 f9
        LI   H'DF'                      ; 00e: 20 df
        BR   poll_or_xlate_loop         ; 010: 90 f4
        LI   H'EF'                      ; 012: 20 ef
        BR   poll_or_xlate_loop         ; 014: 90 f0
        LR   A,4                        ; 016: 44
        OI   H'10'                      ; 017: 22 10
        BR   H'0006'                    ; 019: 90 ec
        XS   3                          ; 01b: e3
        BP   xlate_helper_004E          ; 01c: 81 31
        LR   A,4                        ; 01e: 44
        XI   H'08'                      ; 01f: 23 08
        BR   H'0006'                    ; 021: 90 e4
        LI   H'FB'                      ; 023: 20 fb
        BR   poll_or_xlate_loop         ; 025: 90 df
        LR   A,4                        ; 027: 44
        OI   H'04'                      ; 028: 22 04
        BR   H'0006'                    ; 02a: 90 db
        LR   A,4                        ; 02c: 44
        OI   H'02'                      ; 02d: 22 02
        BR   H'0006'                    ; 02f: 90 d6
        LI   H'FD'                      ; 031: 20 fd
        BR   poll_or_xlate_loop         ; 033: 90 d1
        LR   A,S                        ; 035: 4c
        OI   H'04'                      ; 036: 22 04
        BR   H'0042'                    ; 038: 90 09
        LIS  H'04'                      ; 03a: 74
        BR   H'0046'                    ; 03b: 90 0a
        LISL 4                          ; 03d: 6c
        LR   D,A                        ; 03e: 5e
        LR   A,S                        ; 03f: 4c
        OI   H'08'                      ; 040: 22 08
        LR   S,A                        ; 042: 5c
        BR   xlate_helper_004E          ; 043: 90 0a
        LIS  H'08'                      ; 045: 78
        COM                             ; 046: 18
        NS   S                          ; 047: fc
        BR   H'0042'                    ; 048: 90 f9
        INS  0                          ; 04a: a0
        OI   H'80'                      ; 04b: 22 80
        OUTS 0                          ; 04d: b0
        JMP  H'080C'                    ; 04e: 29 08 0c
        INS  0                          ; 051: a0
        NI   H'7F'                      ; 052: 21 7f
        BR   H'004D'                    ; 054: 90 f8
        INS  0                          ; 056: a0
        XI   H'80'                      ; 057: 23 80
        BR   H'004D'                    ; 059: 90 f3
        INS  0                          ; 05b: a0
        XI   H'10'                      ; 05c: 23 10
        BR   H'004D'                    ; 05e: 90 ee
        INS  0                          ; 060: a0
        OI   H'10'                      ; 061: 22 10
        BR   H'004D'                    ; 063: 90 e9
        INS  0                          ; 065: a0
        XI   H'40'                      ; 066: 23 40
        BR   H'004D'                    ; 068: 90 e4
        INS  0                          ; 06a: a0
        XI   H'20'                      ; 06b: 23 20
        BR   H'004D'                    ; 06d: 90 df
        INS  0                          ; 06f: a0
        NI   H'EF'                      ; 070: 21 ef
        BR   H'004D'                    ; 072: 90 da
        INS  0                          ; 074: a0
        OI   H'40'                      ; 075: 22 40
        BR   H'004D'                    ; 077: 90 d5
        INS  0                          ; 079: a0
        NI   H'BF'                      ; 07a: 21 bf
        BR   H'004D'                    ; 07c: 90 d0
        INS  0                          ; 07e: a0
        OI   H'20'                      ; 07f: 22 20
        BR   H'004D'                    ; 081: 90 cb
        INS  0                          ; 083: a0
        NI   H'DF'                      ; 084: 21 df
        BR   H'004D'                    ; 086: 90 c6
        INS  0                          ; 088: a0
        OI   H'08'                      ; 089: 22 08
        BR   H'004D'                    ; 08b: 90 c1
        PI   H'0766'                    ; 08d: 28 07 66
        INS  0                          ; 090: a0
        OI   H'08'                      ; 091: 22 08
        OUTS 0                          ; 093: b0
        LISL 0                          ; 094: 68
        CLR                             ; 095: 70
        LR   I,A                        ; 096: 5d
        LI   H'A8'                      ; 097: 20 a8
        LR   S,A                        ; 099: 5c
        PI   H'0793'                    ; 09a: 28 07 93
        LR   A,4                        ; 09d: 44
        SL   1                          ; 09e: 13
        BF   1,H'00B0'                  ; 09f: 91 10
        LR   A,0                        ; 0a1: 40
        XS   1                          ; 0a2: e1
        BT   4,H'009A'                  ; 0a3: 84 f6
        JMP  H'0812'                    ; 0a5: 29 08 12
        LR   A,3                        ; 0a8: 43
        CI   H'1A'                      ; 0a9: 25 1a
        BF   4,H'009A'                  ; 0ab: 94 ee
        PI   H'076C'                    ; 0ad: 28 07 6c
        INS  0                          ; 0b0: a0
        NI   H'F7'                      ; 0b1: 21 f7
        BR   H'004D'                    ; 0b3: 90 99
        PI   H'0815'                    ; 0b5: 28 08 15
        COM                             ; 0b8: 18
        SL   4                          ; 0b9: 15
        LR   3,A                        ; 0ba: 53
        INS  0                          ; 0bb: a0
        NI   H'0F'                      ; 0bc: 21 0f
        AS   3                          ; 0be: c3
        BR   H'004D'                    ; 0bf: 90 8d
        CLR                             ; 0c1: 70
        COM                             ; 0c2: 18
        LR   3,A                        ; 0c3: 53
        LR   A,3                        ; 0c4: 43
        LR   7,A                        ; 0c5: 57
        PI   H'058F'                    ; 0c6: 28 05 8f
        CLR                             ; 0c9: 70
        LR   HL,A                       ; 0ca: 5b
        AS   7                          ; 0cb: c7
        BT   1,H'0145'                  ; 0cc: 81 78
        BR   H'00D7'                    ; 0ce: 90 08
        LR   A,HU                       ; 0d0: 4a
        XS   2                          ; 0d1: e2
        BT   4,H'0145'                  ; 0d2: 84 72
        PI   H'058F'                    ; 0d4: 28 05 8f
        LR   A,HU                       ; 0d7: 4a
        XS   2                          ; 0d8: e2
        BF   4,H'00E0'                  ; 0d9: 94 06
        LR   A,4                        ; 0db: 44
        NI   H'90'                      ; 0dc: 21 90
        BT   4,H'00E5'                  ; 0de: 84 06
        PI   H'0612'                    ; 0e0: 28 06 12
        BR   H'0145'                    ; 0e3: 90 61
        LR   A,I                        ; 0e5: 4d
        SL   4                          ; 0e6: 15
        BT   1,H'0115'                  ; 0e7: 81 2d
        DS   D                          ; 0e9: 3e
        BT   1,H'0115'                  ; 0ea: 81 2a
        PI   H'06F8'                    ; 0ec: 28 06 f8
        PI   H'0703'                    ; 0ef: 28 07 03
        LR   A,S                        ; 0f2: 4c
        OI   H'12'                      ; 0f3: 22 12
        LR   S,A                        ; 0f5: 5c
        PI   H'0793'                    ; 0f6: 28 07 93
        BT   4,H'00F6'                  ; 0f9: 84 fc
        CI   H'1B'                      ; 0fb: 25 1b
        BF   4,H'0103'                  ; 0fd: 94 05
        LIS  H'08'                      ; 0ff: 78
        XS   S                          ; 100: ec
        BR   H'0112'                    ; 101: 90 10
        CI   H'C2'                      ; 103: 25 c2
        BF   4,H'010B'                  ; 105: 94 05
        LI   H'17'                      ; 107: 20 17
        BR   H'010F'                    ; 109: 90 05
        XI   H'82'                      ; 10b: 23 82
        BF   4,H'00F6'                  ; 10d: 94 e8
        LISL 4                          ; 10f: 6c
        LR   D,A                        ; 110: 5e
        LR   A,S                        ; 111: 4c
        NI   H'EF'                      ; 112: 21 ef
        LR   S,A                        ; 114: 5c
        PI   H'0793'                    ; 115: 28 07 93
        BT   4,H'0120'                  ; 118: 84 07
        LISU 3                          ; 11a: 63
        LR   S,A                        ; 11b: 5c
        LISU 2                          ; 11c: 62
        PI   H'0773'                    ; 11d: 28 07 73
        INS  1                          ; 120: a1
        NI   H'20'                      ; 121: 21 20
        BF   4,H'0115'                  ; 123: 94 f1
        LIS  H'04'                      ; 125: 74
        NS   S                          ; 126: fc
        BT   4,H'013B'                  ; 127: 84 13
        DI                              ; 129: 1a
        DCI  reset_vector               ; 12a: 2a 00 00
        INS  1                          ; 12d: a1
        BT   1,H'012D'                  ; 12e: 81 fe
        INS  1                          ; 130: a1
        BF   1,H'0130'                  ; 131: 91 fe
        INS  1                          ; 133: a1
        BF   1,H'0138'                  ; 134: 91 03
        BF   1,H'0138'                  ; 136: 91 01
        CLR                             ; 138: 70
        ST                              ; 139: 17
        EI                              ; 13a: 1b
        PI   H'0612'                    ; 13b: 28 06 12
        LR   2,A                        ; 13e: 52
        PI   H'04DB'                    ; 13f: 28 04 db
        PI   H'0777'                    ; 142: 28 07 77
        JMP  H'0806'                    ; 145: 29 08 06
        LR   A,S                        ; 148: 4c
        OI   H'40'                      ; 149: 22 40
        LR   S,A                        ; 14b: 5c
        BR   H'0142'                    ; 14c: 90 f5
        LI   H'BF'                      ; 14e: 20 bf
        NS   S                          ; 150: fc
        BR   H'014B'                    ; 151: 90 f9
        PI   H'0788'                    ; 153: 28 07 88
        XS   HU                         ; 156: ea
        BT   4,H'0145'                  ; 157: 84 ed
        PI   H'058F'                    ; 159: 28 05 8f
        PI   H'05F5'                    ; 15c: 28 05 f5
        XS   2                          ; 15f: e2
        BF   4,H'0145'                  ; 160: 94 e4
        LR   A,4                        ; 162: 44
        NI   H'10'                      ; 163: 21 10
        BF   4,H'0145'                  ; 165: 94 df
        LR   DC,H                       ; 167: 10
        PI   H'05F5'                    ; 168: 28 05 f5
        LR   2,A                        ; 16b: 52
        LR   H,DC                       ; 16c: 11
        BR   H'013F'                    ; 16d: 90 d1
        CLR                             ; 16f: 70
        AS   HL                         ; 170: cb
        BT   4,H'0145'                  ; 171: 84 d3
        PI   H'058F'                    ; 173: 28 05 8f
        DS   HL                         ; 176: 3b
        BT   1,H'0145'                  ; 177: 81 cd
        LI   H'4F'                      ; 179: 20 4f
        LR   HL,A                       ; 17b: 5b
        PI   H'05F5'                    ; 17c: 28 05 f5
        XS   2                          ; 17f: e2
        BF   4,H'0145'                  ; 180: 94 c4
        BR   H'0188'                    ; 182: 90 05
        LR   A,4                        ; 184: 44
        OI   H'80'                      ; 185: 22 80
        LR   4,A                        ; 187: 54
        PI   H'058F'                    ; 188: 28 05 8f
        PI   H'05FB'                    ; 18b: 28 05 fb
        BR   H'0145'                    ; 18e: 90 b6
        LR   A,HL                       ; 190: 4b
        CI   H'4F'                      ; 191: 25 4f
        BT   4,H'0145'                  ; 193: 84 b1
        PI   H'058F'                    ; 195: 28 05 8f
        PI   H'0601'                    ; 198: 28 06 01
        BR   H'0145'                    ; 19b: 90 a9
        PI   H'076C'                    ; 19d: 28 07 6c
        BR   H'0145'                    ; 1a0: 90 a4
        PI   H'0766'                    ; 1a2: 28 07 66
        BR   H'0145'                    ; 1a5: 90 9f
        PI   H'058F'                    ; 1a7: 28 05 8f
        CLR                             ; 1aa: 70
        LR   8,A                        ; 1ab: 58
        DS   HL                         ; 1ac: 3b
        BT   1,H'01B8'                  ; 1ad: 81 0a
        PI   H'05F5'                    ; 1af: 28 05 f5
        XS   2                          ; 1b2: e2
        BT   4,H'01C4'                  ; 1b3: 84 10
        LI   H'4F'                      ; 1b5: 20 4f
        LR   HL,A                       ; 1b7: 5b
        PI   H'0721'                    ; 1b8: 28 07 21
        XS   8                          ; 1bb: e8
        BF   1,H'01AC'                  ; 1bc: 91 ef
        COM                             ; 1be: 18
        XS   8                          ; 1bf: e8
        BF   1,H'01AB'                  ; 1c0: 91 ea
        BR   H'0198'                    ; 1c2: 90 d5
        JMP  H'0809'                    ; 1c4: 29 08 09
        LI   H'80'                      ; 1c7: 20 80
        LR   7,A                        ; 1c9: 57
        PI   H'06F8'                    ; 1ca: 28 06 f8
        LR   A,S                        ; 1cd: 4c
        OI   H'02'                      ; 1ce: 22 02
        LR   S,A                        ; 1d0: 5c
        INS  1                          ; 1d1: a1
        SL   4                          ; 1d2: 15
        BF   1,H'01D1'                  ; 1d3: 91 fd
        LISL 7                          ; 1d5: 6f
        INS  0                          ; 1d6: a0
        LR   D,A                        ; 1d7: 5e
        OI   H'04'                      ; 1d8: 22 04
        NI   H'F7'                      ; 1da: 21 f7
        OUTS 0                          ; 1dc: b0
        BR   H'01F3'                    ; 1dd: 90 15
        LI   H'80'                      ; 1df: 20 80
        LR   7,A                        ; 1e1: 57
        CLR                             ; 1e2: 70
        LR   1,A                        ; 1e3: 51
        LISL 7                          ; 1e4: 6f
        INS  0                          ; 1e5: a0
        NI   H'FD'                      ; 1e6: 21 fd
        LR   D,A                        ; 1e8: 5e
        OI   H'02'                      ; 1e9: 22 02
        OUTS 0                          ; 1eb: b0
        LR   A,4                        ; 1ec: 44
        NI   H'04'                      ; 1ed: 21 04
        LI   H'FF'                      ; 1ef: 20 ff
        BT   4,H'01F5'                  ; 1f1: 84 03
        LI   H'7F'                      ; 1f3: 20 7f
        LR   5,A                        ; 1f5: 55
        PI   H'058F'                    ; 1f6: 28 05 8f
        LR   DC,H                       ; 1f9: 10
        LR   Q,DC                       ; 1fa: 0e
        CLR                             ; 1fb: 70
        LR   8,A                        ; 1fc: 58
        LR   A,7                        ; 1fd: 47
        SL   1                          ; 1fe: 13
        BF   1,H'0208'                  ; 1ff: 91 08
        XS   7                          ; 201: e7
        BF   1,H'0225'                  ; 202: 91 22
        CLR                             ; 204: 70
        LR   HL,A                       ; 205: 5b
        BR   H'0228'                    ; 206: 90 21
        LIS  H'01'                      ; 208: 71
        LR   8,A                        ; 209: 58
        LR   3,A                        ; 20a: 53
        PI   H'0752'                    ; 20b: 28 07 52
        BR   H'0219'                    ; 20e: 90 0a
        PI   H'0721'                    ; 210: 28 07 21
        SL   1                          ; 213: 13
        SR   1                          ; 214: 12
        CI   H'01'                      ; 215: 25 01
        BT   4,H'0228'                  ; 217: 84 10
        DS   HL                         ; 219: 3b
        BT   1,H'0210'                  ; 21a: 81 f5
        LI   H'4F'                      ; 21c: 20 4f
        LR   HL,A                       ; 21e: 5b
        PI   H'05F5'                    ; 21f: 28 05 f5
        XS   2                          ; 222: e2
        BF   4,H'0210'                  ; 223: 94 ec
        PI   H'05FB'                    ; 225: 28 05 fb
        INS  0                          ; 228: a0
        NI   H'0E'                      ; 229: 21 0e
        OUTS 0                          ; 22b: b0
        PI   H'0721'                    ; 22c: 28 07 21
        LR   S,A                        ; 22f: 5c
        OI   H'80'                      ; 230: 22 80
        LR   3,A                        ; 232: 53
        INS  0                          ; 233: a0
        INC                             ; 234: 1f
        OUTS 0                          ; 235: b0
        PI   H'0752'                    ; 236: 28 07 52
        SL   1                          ; 239: 13
        SR   1                          ; 23a: 12
        LR   3,A                        ; 23b: 53
        INS  0                          ; 23c: a0
        NI   H'FE'                      ; 23d: 21 fe
        OUTS 0                          ; 23f: b0
        LR   A,S                        ; 240: 4c
        NS   5                          ; 241: f5
        BF   1,H'0256'                  ; 242: 91 13
        BF   4,H'024C'                  ; 244: 94 07
        INS  1                          ; 246: a1
        NI   H'03'                      ; 247: 21 03
        BT   4,H'0256'                  ; 249: 84 0c
        CLR                             ; 24b: 70
        CI   H'01'                      ; 24c: 25 01
        BF   4,H'0253'                  ; 24e: 94 04
        XS   8                          ; 250: e8
        BT   4,H'0256'                  ; 251: 84 04
        PI   H'06E5'                    ; 253: 28 06 e5
        PI   H'0752'                    ; 256: 28 07 52
        LR   A,QL                       ; 259: 03
        XS   HL                         ; 25a: eb
        BF   4,H'0263'                  ; 25b: 94 07
        LR   A,QU                       ; 25d: 02
        XS   HU                         ; 25e: ea
        LISL 7                          ; 25f: 6f
        BT   4,H'0272'                  ; 260: 84 11
        LISL 6                          ; 262: 6e
        PI   H'0601'                    ; 263: 28 06 01
        BF   1,H'0228'                  ; 266: 91 c1
        INS  1                          ; 268: a1
        NI   H'03'                      ; 269: 21 03
        BF   4,H'0272'                  ; 26b: 94 06
        INS  0                          ; 26d: a0
        NI   H'01'                      ; 26e: 21 01
        BT   4,H'0228'                  ; 270: 84 b7
        LIS  H'0D'                      ; 272: 7d
        LR   3,A                        ; 273: 53
        PI   H'06E5'                    ; 274: 28 06 e5
        INS  0                          ; 277: a0
        NI   H'04'                      ; 278: 21 04
        BT   4,H'0285'                  ; 27a: 84 0a
        LIS  H'0A'                      ; 27c: 7a
        LR   3,A                        ; 27d: 53
        PI   H'06E5'                    ; 27e: 28 06 e5
        BR7  H'0228'                    ; 281: 8f a6
        BR   H'0292'                    ; 283: 90 0e
        BR7  H'0228'                    ; 285: 8f a2
        LR   A,0                        ; 287: 40
        LR   1,A                        ; 288: 51
        CLR                             ; 289: 70
        AS   8                          ; 28a: c8
        BT   4,H'0292'                  ; 28b: 84 06
        LIS  H'04'                      ; 28d: 74
        LR   3,A                        ; 28e: 53
        PI   H'06E5'                    ; 28f: 28 06 e5
        CLR                             ; 292: 70
        AS   8                          ; 293: c8
        BT   4,H'0299'                  ; 294: 84 04
        PI   H'0601'                    ; 296: 28 06 01
        INS  1                          ; 299: a1
        SL   4                          ; 29a: 15
        BF   1,H'0299'                  ; 29b: 91 fd
        LR   A,S                        ; 29d: 4c
        OUTS 0                          ; 29e: b0
        PI   H'0703'                    ; 29f: 28 07 03
        JMP  H'0806'                    ; 2a2: 29 08 06
        LR   A,HL                       ; 2a5: 4b
        CI   H'1F'                      ; 2a6: 25 1f
        BF   1,H'02AC'                  ; 2a8: 91 03
        AI   H'60'                      ; 2aa: 24 60
        LR   3,A                        ; 2ac: 53
        PI   H'06C1'                    ; 2ad: 28 06 c1
        LR   A,2                        ; 2b0: 42
        COM                             ; 2b1: 18
        AS   HU                         ; 2b2: ca
        BT   1,H'02B7'                  ; 2b3: 81 03
        AI   H'18'                      ; 2b5: 24 18
        AI   H'60'                      ; 2b7: 24 60
        LR   3,A                        ; 2b9: 53
        PI   H'06C1'                    ; 2ba: 28 06 c1
        LIS  H'0D'                      ; 2bd: 7d
        BR   H'02D0'                    ; 2be: 90 11
        LR   A,2                        ; 2c0: 42
        COM                             ; 2c1: 18
        AS   HU                         ; 2c2: ca
        BT   1,H'02C7'                  ; 2c3: 81 03
        AI   H'18'                      ; 2c5: 24 18
        AI   H'20'                      ; 2c7: 24 20
        LR   3,A                        ; 2c9: 53
        PI   H'06C1'                    ; 2ca: 28 06 c1
        LR   A,HL                       ; 2cd: 4b
        AI   H'20'                      ; 2ce: 24 20
        LR   3,A                        ; 2d0: 53
        PI   H'06C1'                    ; 2d1: 28 06 c1
        BR   H'0335'                    ; 2d4: 90 60
        PI   H'0721'                    ; 2d6: 28 07 21
        SL   1                          ; 2d9: 13
        SR   1                          ; 2da: 12
        BR   H'02B9'                    ; 2db: 90 dd
        PI   H'071B'                    ; 2dd: 28 07 1b
        INS  0                          ; 2e0: a0
        INC                             ; 2e1: 1f
        OUTS 0                          ; 2e2: b0
        INS  0                          ; 2e3: a0
        COM                             ; 2e4: 18
        SR   4                          ; 2e5: 14
        AI   H'40'                      ; 2e6: 24 40
        LR   3,A                        ; 2e8: 53
        LR   A,8                        ; 2e9: 48
        OUTS 0                          ; 2ea: b0
        BR   H'02BA'                    ; 2eb: 90 ce
        PI   H'06FD'                    ; 2ed: 28 06 fd
        LI   H'2F'                      ; 2f0: 20 2f
        LR   3,A                        ; 2f2: 53
        PI   H'06C1'                    ; 2f3: 28 06 c1
        LI   H'4B'                      ; 2f6: 20 4b
        BR   H'02D0'                    ; 2f8: 90 d7
        LR   A,3                        ; 2fa: 43
        NI   H'0F'                      ; 2fb: 21 0f
        LR   8,A                        ; 2fd: 58
        PI   H'06FD'                    ; 2fe: 28 06 fd
        LR   A,8                        ; 301: 48
        SL   4                          ; 302: 15
        LI   H'50'                      ; 303: 20 50
        BT   1,H'0309'                  ; 305: 81 03
        AI   H'FA'                      ; 307: 24 fa
        AS   8                          ; 309: c8
        BR   H'02D0'                    ; 30a: 90 c5
        LR   DC,H                       ; 30c: 10
        LR   Q,DC                       ; 30d: 0e
        PI   H'0815'                    ; 30e: 28 08 15
        AI   H'E0'                      ; 311: 24 e0
        BF   1,H'0322'                  ; 313: 91 0e
        CI   H'17'                      ; 315: 25 17
        BF   1,H'0322'                  ; 317: 91 0a
        AS   2                          ; 319: c2
        INC                             ; 31a: 1f
        CI   H'57'                      ; 31b: 25 57
        BT   1,H'0321'                  ; 31d: 81 03
        AI   H'E8'                      ; 31f: 24 e8
        LR   QU,A                       ; 321: 06
        PI   H'0815'                    ; 322: 28 08 15
        AI   H'E0'                      ; 325: 24 e0
        BF   1,H'0330'                  ; 327: 91 08
        CI   H'4F'                      ; 329: 25 4f
        BT   1,H'032F'                  ; 32b: 81 03
        LI   H'4F'                      ; 32d: 20 4f
        LR   QL,A                       ; 32f: 07
        PI   H'058F'                    ; 330: 28 05 8f
        LR   DC,Q                       ; 333: 0f
        LR   H,DC                       ; 334: 11
        BR   H'039B'                    ; 335: 90 65
        PI   H'0815'                    ; 337: 28 08 15
        CI   H'5F'                      ; 33a: 25 5f
        BT   1,H'0340'                  ; 33c: 81 03
        NI   H'1F'                      ; 33e: 21 1f
        CI   H'4F'                      ; 340: 25 4f
        BT   1,H'0346'                  ; 342: 81 03
        LI   H'4F'                      ; 344: 20 4f
        LR   QL,A                       ; 346: 07
        PI   H'0815'                    ; 347: 28 08 15
        NI   H'1F'                      ; 34a: 21 1f
        CI   H'17'                      ; 34c: 25 17
        BT   1,H'0352'                  ; 34e: 81 03
        LI   H'17'                      ; 350: 20 17
        INC                             ; 352: 1f
        AS   2                          ; 353: c2
        CI   H'57'                      ; 354: 25 57
        BT   1,H'035A'                  ; 356: 81 03
        AI   H'E8'                      ; 358: 24 e8
        LR   QU,A                       ; 35a: 06
        BR   H'0330'                    ; 35b: 90 d4
        LIS  H'08'                      ; 35d: 78
        SL   4                          ; 35e: 15
        LR   8,A                        ; 35f: 58
        PI   H'07D5'                    ; 360: 28 07 d5
        XS   8                          ; 363: e8
        OUTS 0                          ; 364: b0
        PI   H'04D7'                    ; 365: 28 04 d7
        LISL 5                          ; 368: 6d
        LR   A,S                        ; 369: 4c
        OUTS 0                          ; 36a: b0
        BR   H'039B'                    ; 36b: 90 2f
        LIS  H'08'                      ; 36d: 78
        SL   4                          ; 36e: 15
        LR   8,A                        ; 36f: 58
        PI   H'07D5'                    ; 370: 28 07 d5
        XS   8                          ; 373: e8
        OUTS 0                          ; 374: b0
        PI   H'04E5'                    ; 375: 28 04 e5
        BR   H'0368'                    ; 378: 90 ef
        LISL 2                          ; 37a: 6a
        LR   S,A                        ; 37b: 5c
        LR   A,4                        ; 37c: 44
        NI   H'7F'                      ; 37d: 21 7f
        LR   4,A                        ; 37f: 54
        CLR                             ; 380: 70
        BR   H'0387'                    ; 381: 90 05
        LIS  H'08'                      ; 383: 78
        BR   H'0387'                    ; 384: 90 02
        LIS  H'02'                      ; 386: 72
        SL   4                          ; 387: 15
        LR   8,A                        ; 388: 58
        PI   H'07D5'                    ; 389: 28 07 d5
        XS   8                          ; 38c: e8
        OUTS 0                          ; 38d: b0
        PI   H'04EF'                    ; 38e: 28 04 ef
        BR   H'0368'                    ; 391: 90 d6
        PI   H'04E5'                    ; 393: 28 04 e5
        BR   H'039B'                    ; 396: 90 04
        PI   H'04D7'                    ; 398: 28 04 d7
        JMP  H'0806'                    ; 39b: 29 08 06
        PI   H'04EF'                    ; 39e: 28 04 ef
        BR   H'039B'                    ; 3a1: 90 f9
        PI   H'058F'                    ; 3a3: 28 05 8f
        PI   H'05FB'                    ; 3a6: 28 05 fb
        CLR                             ; 3a9: 70
        AS   4                          ; 3aa: c4
        CLR                             ; 3ab: 70
        BF   1,H'03B8'                  ; 3ac: 91 0b
        BR   H'0387'                    ; 3ae: 90 d8
        PI   H'058F'                    ; 3b0: 28 05 8f
        PI   H'05FB'                    ; 3b3: 28 05 fb
        LI   H'20'                      ; 3b6: 20 20
        LR   7,A                        ; 3b8: 57
        PI   H'058F'                    ; 3b9: 28 05 8f
        PI   H'07D5'                    ; 3bc: 28 07 d5
        LR   DC,H                       ; 3bf: 10
        XDC                             ; 3c0: 2c
        BR   H'03C9'                    ; 3c1: 90 07
        LR   H,DC                       ; 3c3: 11
        LR   A,HL                       ; 3c4: 4b
        CI   H'50'                      ; 3c5: 25 50
        BT   4,H'03E0'                  ; 3c7: 84 18
        PI   H'0624'                    ; 3c9: 28 06 24
        BF   1,H'0401'                  ; 3cc: 91 34
        LR   A,HL                       ; 3ce: 4b
        COM                             ; 3cf: 18
        AI   H'51'                      ; 3d0: 24 51
        LR   5,A                        ; 3d2: 55
        LR   DC,H                       ; 3d3: 10
        CLR                             ; 3d4: 70
        XM                              ; 3d5: 8c
        BF   1,H'03C3'                  ; 3d6: 91 ec
        LI   H'FF'                      ; 3d8: 20 ff
        ADC                             ; 3da: 8e
        LR   A,7                        ; 3db: 47
        ST                              ; 3dc: 17
        DS   5                          ; 3dd: 35
        BF   4,H'03D4'                  ; 3de: 94 f5
        CLR                             ; 3e0: 70
        LR   HL,A                       ; 3e1: 5b
        LR   A,HU                       ; 3e2: 4a
        XS   2                          ; 3e3: e2
        BT   4,H'0401'                  ; 3e4: 84 1c
        PI   H'0612'                    ; 3e6: 28 06 12
        BR   H'03CE'                    ; 3e9: 90 e4
        PI   H'07D5'                    ; 3eb: 28 07 d5
        LR   DC,H                       ; 3ee: 10
        XDC                             ; 3ef: 2c
        LR   DC,H                       ; 3f0: 10
        LR   A,HL                       ; 3f1: 4b
        COM                             ; 3f2: 18
        AI   H'51'                      ; 3f3: 24 51
        LR   5,A                        ; 3f5: 55
        XM                              ; 3f6: 8c
        BF   1,H'0401'                  ; 3f7: 91 09
        LI   H'FF'                      ; 3f9: 20 ff
        ADC                             ; 3fb: 8e
        CLR                             ; 3fc: 70
        ST                              ; 3fd: 17
        DS   5                          ; 3fe: 35
        DB   H'94'                    ; 3ff: 94 (ROM-end trim)
