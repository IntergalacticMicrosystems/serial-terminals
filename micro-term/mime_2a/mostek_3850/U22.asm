; Relabelled disassembly. Origin H'0800'.
; Symbols loaded from: U22.sym (22 addr, 15 port)
; Idempotent — re-run after editing U22.sym to refresh.
;
        CPU MK3850
;
; --- Symbol table (from .sym file; needed for asl reassembly) ---
dispatch_table:         EQU H'0800'
dispatch_entry_1:       EQU H'0803'
dispatch_entry_2:       EQU H'0806'
dispatch_entry_3:       EQU H'0809'
dispatch_entry_4:       EQU H'080C'
dispatch_entry_5:       EQU H'080F'
dispatch_entry_6:       EQU H'0812'
dispatch_entry_7:       EQU H'0815'
boot_init:              EQU H'0818'
boot_smi_vector_setup:  EQU H'083D'
boot_screen_clear:      EQU H'0847'
mode_entry_1:           EQU H'09F9'
mode_entry_2:           EQU H'0A10'
mode_entry_3:           EQU H'0A19'
mode_entry_4:           EQU H'0A1F'
mode_entry_5:           EQU H'0A31'
mode_entry_6:           EQU H'0B41'
mode_entry_7:           EQU H'0B81'
smi_isr:                EQU H'0B99'
smi_isr_save_done:      EQU H'0BA4'
ext_screen_base:        EQU H'5062'
ext_peripheral_8000:    EQU H'8000'
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
isr_save_isar:          EQU H'18'
isr_save_qu:            EQU H'19'
isr_save_ql:            EQU H'1A'
;
        ORG H'0800'
;
        JMP  boot_init                  ; 800: 29 08 18
        JMP  mode_entry_1               ; 803: 29 09 f9
        JMP  mode_entry_2               ; 806: 29 0a 10
        JMP  mode_entry_3               ; 809: 29 0a 19
        JMP  mode_entry_4               ; 80c: 29 0a 1f
        JMP  mode_entry_5               ; 80f: 29 0a 31
        JMP  mode_entry_7               ; 812: 29 0b 81
        JMP  mode_entry_6               ; 815: 29 0b 41
        CLR                             ; 818: 70
        OUTS 0                          ; 819: b0
        OUTS 1                          ; 81a: b1
        LI   H'40'                      ; 81b: 20 40
        LR   4,A                        ; 81d: 54
        LISU 3                          ; 81e: 63
        LISL 3                          ; 81f: 6b
        LI   H'FB'                      ; 820: 20 fb
        LR   S,A                        ; 822: 5c
        LISU 2                          ; 823: 62
        INS  0                          ; 824: a0
        NI   H'02'                      ; 825: 21 02
        SL   4                          ; 827: 15
        AS   4                          ; 828: c4
        LR   D,A                        ; 829: 5e
        LI   H'20'                      ; 82a: 20 20
        LR   S,A                        ; 82c: 5c
        PI   H'07C5'                    ; 82d: 28 07 c5
        SL   4                          ; 830: 15
        SR   1                          ; 831: 12
        SL   4                          ; 832: 15
        XI   H'F0'                      ; 833: 23 f0
        OUTS 0                          ; 835: b0
        LI   H'3F'                      ; 836: 20 3f
        LR   0,A                        ; 838: 50
        LR   1,A                        ; 839: 51
        LI   H'57'                      ; 83a: 20 57
        LR   2,A                        ; 83c: 52
        LIS  H'0B'                      ; 83d: 7b
        OUTS PORT_SMI_VEC_HI            ; 83e: bc
        LI   H'99'                      ; 83f: 20 99
        OUTS PORT_SMI_VEC_LO            ; 841: bd
        LIS  H'01'                      ; 842: 71
        OUTS PORT_SMI_ICP               ; 843: be
        PI   H'0777'                    ; 844: 28 07 77
        DCI  ext_screen_base            ; 847: 2a 50 62
        LR   H,DC                       ; 84a: 11
        LR   DC,H                       ; 84b: 10
        LI   H'20'                      ; 84c: 20 20
        ST                              ; 84e: 17
        PI   H'0612'                    ; 84f: 28 06 12
        XI   H'40'                      ; 852: 23 40
        BF   4,H'084B'                  ; 854: 94 f6
        LR   HL,A                       ; 856: 5b
        PI   H'04EF'                    ; 857: 28 04 ef
        JMP  H'029F'                    ; 85a: 29 02 9f
        LR   J,W                        ; 85d: 1e
        LISU 6                          ; 85e: 66
        LISL 0                          ; 85f: 68
        LISL 2                          ; 860: 6a
        LISL 4                          ; 861: 6c
        LIS  H'06'                      ; 862: 76
        LISU 4                          ; 863: 64
        LISL 6                          ; 864: 6e
        CLR                             ; 865: 70
        INS  PORT_PIO_04                ; 866: a4
        DB   H'A2'                      ; 867: a2
        BT   2,H'07E9'                  ; 868: 82 80
        BF   14,H'080B'                 ; 86a: 9e a0
        BNZ  dispatch_entry_1           ; 86c: 94 96
        INS  PORT_SMI_ICP               ; 86e: ae
        ADC                             ; 86f: 8e
        LR   A,S                        ; 870: 4c
        LIS  H'02'                      ; 871: 72
        LISU 2                          ; 872: 62
        LIS  H'0E'                      ; 873: 7e
        AI   H'92'                      ; 874: 24 92
        LR   0,A                        ; 876: 50
        LI   H'88'                      ; 877: 20 88
        DS   6                          ; 879: 36
        DCI  H'9C44'                    ; 87a: 2a 9c 44
        LISU 4                          ; 87d: 64
        LISU 2                          ; 87e: 62
        LISU 0                          ; 87f: 60
        LR   D,A                        ; 880: 5e
        LR   A,D                        ; 881: 4e
        LR   A,6                        ; 882: 46
        LR   A,4                        ; 883: 44
        LR   0,A                        ; 884: 50
        DS   4                          ; 885: 34
        LR   HU,A                       ; 886: 5a
        LR   J,W                        ; 887: 1e
        LR   J,W                        ; 888: 1e
        LR   J,W                        ; 889: 1e
        LR   J,W                        ; 88a: 1e
        LR   J,W                        ; 88b: 1e
        LR   J,W                        ; 88c: 1e
        LR   J,W                        ; 88d: 1e
        LR   J,W                        ; 88e: 1e
        OUTS PORT_PIO_0A                ; 88f: ba
        OUTS PORT_PIO_08                ; 890: b8
        LISU 6                          ; 891: 66
        LISL 0                          ; 892: 68
        LISL 2                          ; 893: 6a
        LISL 4                          ; 894: 6c
        LISL 6                          ; 895: 6e
        CLR                             ; 896: 70
        BF   14,H'0848'                 ; 897: 9e b0
        LIS  H'02'                      ; 899: 72
        LIS  H'04'                      ; 89a: 74
        LIS  H'0C'                      ; 89b: 7c
        LR   2,A                        ; 89c: 52
        INS  PORT_PIO_06                ; 89d: a6
        INS  PORT_PIO_08                ; 89e: a8
        DS   HU                         ; 89f: 3a
        DS   S                          ; 8a0: 3c
        NM                              ; 8a1: 8a
        XM                              ; 8a2: 8c
        DS   6                          ; 8a3: 36
        BR   H'0837'                    ; 8a4: 90 92
        BNZ  boot_smi_vector_setup      ; 8a6: 94 96
        BF   8,H'0843'                  ; 8a8: 98 9a
        BF   12,H'08E9'                 ; 8aa: 9c 3e
        LR   A,HU                       ; 8ac: 4a
        DB   H'A2'                      ; 8ad: a2
        INS  PORT_PIO_04                ; 8ae: a4
        AS   S                          ; 8af: cc
        INS  0                          ; 8b0: a0
        LR   J,W                        ; 8b1: 1e
        LR   J,W                        ; 8b2: 1e
        LR   J,W                        ; 8b3: 1e
        AS   HU                         ; 8b4: ca
        LIS  H'0E'                      ; 8b5: 7e
        OUTS PORT_PIO_04                ; 8b6: b4
        OUTS PORT_PIO_06                ; 8b7: b6
        LR   IS,A                       ; 8b8: 0b
        LR   A,IS                       ; 8b9: 0a
        LR   K,P                        ; 8ba: 08
        PK                              ; 8bb: 0c
        XM                              ; 8bc: 8c
        OM                              ; 8bd: 8b
        LR   K,P                        ; 8be: 08
        LR   DC,H                       ; 8bf: 10
        AS   1                          ; 8c0: c1
        AS   2                          ; 8c1: c2
        AS   4                          ; 8c2: c4
        AS   3                          ; 8c3: c3
        BT   H'00',boot_screen_clear    ; 8c4: 80 82
        INS  PORT_SMI_VEC_HI            ; 8c6: ac
        INS  PORT_PIO_0A                ; 8c7: aa
        BT   0,H'084B'                  ; 8c8: 80 82
        BT   6,H'084F'                  ; 8ca: 86 84
        OUTS PORT_SMI_ICP               ; 8cc: be
        OUTS PORT_SMI_ICP               ; 8cd: be
        OUTS PORT_SMI_VEC_HI            ; 8ce: bc
        AS   8                          ; 8cf: c8
        DS   S                          ; 8d0: 3c
        DS   HU                         ; 8d1: 3a
        AS   0                          ; 8d2: c0
        AS   4                          ; 8d3: c4
        OUTS PORT_SMI_ICP               ; 8d4: be
        OUTS PORT_SMI_ICP               ; 8d5: be
        OUTS PORT_SMI_ICP               ; 8d6: be
        OUTS PORT_SMI_VEC_HI            ; 8d7: bc
        AS   8                          ; 8d8: c8
        LI   H'4C'                      ; 8d9: 20 4c
        AS   2                          ; 8db: c2
        AS   6                          ; 8dc: c6
        OUTS PORT_SMI_ICP               ; 8dd: be
        LR   J,W                        ; 8de: 1e
        LI   H'22'                      ; 8df: 20 22
        AI   H'30'                      ; 8e1: 24 30
        PI   H'2A2C'                    ; 8e3: 28 2a 2c
        BT   6,H'090D'                  ; 8e6: 86 26
        DS   2                          ; 8e8: 32
        BT   0,H'086E'                  ; 8e9: 80 84
        DS   8                          ; 8eb: 38
        LR   J,W                        ; 8ec: 1e
        LR   J,W                        ; 8ed: 1e
        LR   J,W                        ; 8ee: 1e
        LR   A,0                        ; 8ef: 40
        LR   A,2                        ; 8f0: 42
        LR   J,W                        ; 8f1: 1e
        LR   J,W                        ; 8f2: 1e
        LR   A,8                        ; 8f3: 48
        LR   J,W                        ; 8f4: 1e
        LR   A,S                        ; 8f5: 4c
        LR   J,W                        ; 8f6: 1e
        LR   J,W                        ; 8f7: 1e
        LR   2,A                        ; 8f8: 52
        AS   D                          ; 8f9: ce
        LR   6,A                        ; 8fa: 56
        LR   8,A                        ; 8fb: 58
        ADC                             ; 8fc: 8e
        LR   S,A                        ; 8fd: 5c
        LR   J,W                        ; 8fe: 1e
        DS   D                          ; 8ff: 3e
        OI   H'30'                      ; 900: 22 30
        DS   HU                         ; 902: 3a
        DS   S                          ; 903: 3c
        BF   8,H'0931'                  ; 904: 98 2c
        INS  PORT_SMI_VEC_HI            ; 906: ac
        IN   H'32'                      ; 907: 26 32
        NM                              ; 909: 8a
        XM                              ; 90a: 8c
        DS   8                          ; 90b: 38
        INS  PORT_PIO_06                ; 90c: a6
        OUTS PORT_PIO_04                ; 90d: b4
        INS  PORT_PIO_0A                ; 90e: aa
        LR   A,0                        ; 90f: 40
        LR   A,2                        ; 910: 42
        BR   H'0958'                    ; 911: 90 46
        LR   A,8                        ; 913: 48
        LR   A,HU                       ; 914: 4a
        INS  PORT_PIO_08                ; 915: a8
        LR   A,D                        ; 916: 4e
        LIS  H'0C'                      ; 917: 7c
        LR   2,A                        ; 918: 52
        OUTS PORT_PIO_06                ; 919: b6
        LR   6,A                        ; 91a: 56
        LR   8,A                        ; 91b: 58
        LIS  H'04'                      ; 91c: 74
        LR   S,A                        ; 91d: 5c
        LIS  H'0A'                      ; 91e: 7a
        INC                             ; 91f: 1f
        AI   H'33'                      ; 920: 24 33
        LR   A,QL                       ; 922: 03
        LR   I,A                        ; 923: 5d
        XI   H'6D'                      ; 924: 23 6d
        DS   4                          ; 926: 34
        DI                              ; 927: 1a
        LR   A,QU                       ; 928: 02
        AS   0                          ; 929: c0
        XI   H'B0'                      ; 92a: 23 b0
        LIS  H'02'                      ; 92c: 72
        BF   15,H'096F'                 ; 92d: 9f 41
        LISL 7                          ; 92f: 6f
        LISU 4                          ; 930: 64
        LR   QU,A                       ; 931: 06
        CLR                             ; 932: 70
        ASD  4                          ; 933: d4
        BF   3,H'09AF'                  ; 934: 93 7a
        XI   H'9E'                      ; 936: 23 9e
        CLR                             ; 938: 70
        AS   4                          ; 939: c4
        LR   KU,A                       ; 93a: 04
        LISU 3                          ; 93b: 63
        LR   KU,A                       ; 93c: 04
        CM                              ; 93d: 8d
        LR   H,DC                       ; 93e: 11
        AS   7                          ; 93f: c7
        LR   A,KU                       ; 940: 00
        EI                              ; 941: 1b
        LR   A,KL                       ; 942: 01
        INS  PORT_PIO_07                ; 943: a7
        DS   0                          ; 944: 30
        LR   A,HU                       ; 945: 4a
        LR   A,KU                       ; 946: 00
        LR   A,QL                       ; 947: 03
        LR   P,K                        ; 948: 09
        ASD  0                          ; 949: d0
        LR   A,KL                       ; 94a: 01
        AS   J                          ; 94b: c9
        AI   H'31'                      ; 94c: 24 31
        LR   A,KL                       ; 94e: 01
        BT   4,H'0980'                  ; 94f: 84 30
        LR   1,A                        ; 951: 51
        LR   DC,H                       ; 952: 10
        OUTS 0                          ; 953: b0
        LR   A,HU                       ; 954: 4a
        BF   9,H'0956'                  ; 955: 99 00
        XI   H'00'                      ; 957: 23 00
        OUT  H'93'                      ; 959: 27 93
        DB   H'A3'                      ; 95b: a3
        LR   DC,H                       ; 95c: 10
        AS   1                          ; 95d: c1
        LR   A,KL                       ; 95e: 01
        LR   A,D                        ; 95f: 4e
        LR   A,KL                       ; 960: 01
        LR   A,8                        ; 961: 48
        DS   1                          ; 962: 31
        DB   H'A2'                      ; 963: a2
        DS   1                          ; 964: 31
        BF   13,H'0966'                 ; 965: 9d 00
        LISL 7                          ; 967: 6f
        LR   A,KU                       ; 968: 00
        LISU 0                          ; 969: 60
        LR   A,KU                       ; 96a: 00
        LIS  H'09'                      ; 96b: 79
        LR   A,KU                       ; 96c: 00
        LIS  H'04'                      ; 96d: 74
        LR   A,KU                       ; 96e: 00
        BT   3,H'0970'                  ; 96f: 83 00
        LIS  H'0E'                      ; 971: 7e
        LR   A,KU                       ; 972: 00
        DS   5                          ; 973: 35
        LR   A,KU                       ; 974: 00
        DS   HU                         ; 975: 3a
        DB   H'A2'                      ; 976: a2
        INS  PORT_PIO_05                ; 977: a5
        LR   A,0                        ; 978: 40
        XDC                             ; 979: 2c
        LR   A,0                        ; 97a: 40
        DS   1                          ; 97b: 31
        LR   DC,H                       ; 97c: 10
        AM                              ; 97d: 88
        LR   A,KU                       ; 97e: 00
        CM                              ; 97f: 8d
        LIS  H'01'                      ; 980: 71
        LR   3,A                        ; 981: 53
        CLR                             ; 982: 70
        ASD  0                          ; 983: d0
        LR   1,A                        ; 984: 51
        BR   H'09D7'                    ; 985: 90 51
        LISL 7                          ; 987: 6f
        LR   A,QL                       ; 988: 03
        OUTS PORT_PIO_06                ; 989: b6
        LR   A,0                        ; 98a: 40
        LR   P,K                        ; 98b: 09
        LR   A,0                        ; 98c: 40
        LR   Q,DC                       ; 98d: 0e
        LIS  H'01'                      ; 98e: 71
        AM                              ; 98f: 88
        LR   A,1                        ; 990: 41
        LR   J,A                        ; 991: 59
        LISU 3                          ; 992: 63
        BF   3,H'0A07'                  ; 993: 93 73
        BF   8,H'0999'                  ; 995: 98 03
        BT   7,H'099B'                  ; 997: 87 03
        BT   3,H'099D'                  ; 999: 83 03
        BT   6,H'099E'                  ; 99b: 86 02
        ASD  6                          ; 99d: d6
        LR   A,QL                       ; 99e: 03
        LR   D,A                        ; 99f: 5e
        LR   A,QL                       ; 9a0: 03
        LISL 6                          ; 9a1: 6e
        LR   A,QU                       ; 9a2: 02
        ASD  I                          ; 9a3: dd
        LR   A,KU                       ; 9a4: 00
        OUTS PORT_PIO_05                ; 9a5: b5
        LR   A,KU                       ; 9a6: 00
        SR   1                          ; 9a7: 12
        LR   A,KU                       ; 9a8: 00
        LM                              ; 9a9: 16
        INS  1                          ; 9aa: a1
        BF   5,H'094D'                  ; 9ab: 95 a1
        LIS  H'03'                      ; 9ad: 73
        DB   H'A3'                      ; 9ae: a3
        DS   7                          ; 9af: 37
        LR   3,A                        ; 9b0: 53
        PK                              ; 9b1: 0c
        LR   A,2                        ; 9b2: 42
        XS   I                          ; 9b3: ed
        LR   A,0                        ; 9b4: 40
        DS   I                          ; 9b5: 3d
        LR   A,0                        ; 9b6: 40
        LR   A,5                        ; 9b7: 45
        LR   H,DC                       ; 9b8: 11
        DB   H'DF'                      ; 9b9: df
        LR   H,DC                       ; 9ba: 11
        XS   1                          ; 9bb: e1
        LIS  H'01'                      ; 9bc: 71
        XS   2                          ; 9bd: e2
        LR   A,2                        ; 9be: 42
        NS   HU                         ; 9bf: fa
        CLR                             ; 9c0: 70
        LR   6,A                        ; 9c1: 56
        CLR                             ; 9c2: 70
        LR   HL,A                       ; 9c3: 5b
        CLR                             ; 9c4: 70
        LISL 2                          ; 9c5: 6a
        CLR                             ; 9c6: 70
        LISU 5                          ; 9c7: 65
        LIS  H'01'                      ; 9c8: 71
        AS   HU                         ; 9c9: ca
        SL   1                          ; 9ca: 13
        OUTS PORT_PIO_08                ; 9cb: b8
        SL   1                          ; 9cc: 13
        XS   HL                         ; 9cd: eb
        DI                              ; 9ce: 1a
        OUTS PORT_PIO_06                ; 9cf: b6
        PI   H'071B'                    ; 9d0: 28 07 1b
        SL   1                          ; 9d3: 13
        SR   1                          ; 9d4: 12
        LR   3,A                        ; 9d5: 53
        INS  0                          ; 9d6: a0
        INC                             ; 9d7: 1f
        OUTS 0                          ; 9d8: b0
        INS  0                          ; 9d9: a0
        NI   H'EE'                      ; 9da: 21 ee
        OUTS 0                          ; 9dc: b0
        PI   H'05AD'                    ; 9dd: 28 05 ad
        BR   H'09FC'                    ; 9e0: 90 1b
        PI   H'058F'                    ; 9e2: 28 05 8f
        DS   HL                         ; 9e5: 3b
        BF   1,H'09FC'                  ; 9e6: 91 15
        CLR                             ; 9e8: 70
        XS   4                          ; 9e9: e4
        BT   1,H'09F1'                  ; 9ea: 81 06
        PI   H'0721'                    ; 9ec: 28 07 21
        BF   1,H'09FC'                  ; 9ef: 91 0c
        LI   H'20'                      ; 9f1: 20 20
        LR   3,A                        ; 9f3: 53
        PI   H'0752'                    ; 9f4: 28 07 52
        BR   mode_entry_4               ; 9f7: 90 27
        PI   H'0735'                    ; 9f9: 28 07 35
        LR   A,HL                       ; 9fc: 4b
        CI   H'4F'                      ; 9fd: 25 4f
        BF   4,H'0A0E'                  ; 9ff: 94 0e
        LR   A,4                        ; a01: 44
        NI   H'08'                      ; a02: 21 08
        BF   4,H'0A0B'                  ; a04: 94 06
        INS  1                          ; a06: a1
        NI   H'02'                      ; a07: 21 02
        BNZ  mode_entry_2               ; a09: 94 06
        JMP  H'00C1'                    ; a0b: 29 00 c1
        INC                             ; a0e: 1f
        LR   HL,A                       ; a0f: 5b
        CLR                             ; a10: 70
        AS   4                          ; a11: c4
        BP   mode_entry_4               ; a12: 81 0c
        PI   H'0624'                    ; a14: 28 06 24
        BP   mode_entry_4               ; a17: 81 07
        PI   H'05FB'                    ; a19: 28 05 fb
        PI   H'0624'                    ; a1c: 28 06 24
        LIS  H'01'                      ; a1f: 71
        NS   4                          ; a20: f4
        BF   4,H'0A99'                  ; a21: 94 77
        PI   dispatch_entry_7           ; a23: 28 08 15
        BM   mode_entry_4               ; a26: 91 f8
        LR   A,4                        ; a28: 44
        SL   4                          ; a29: 15
        LR   A,3                        ; a2a: 43
        BP   mode_entry_5               ; a2b: 81 05
        CI   H'91'                      ; a2d: 25 91
        BNZ  mode_entry_1               ; a2f: 94 c9
        LR   A,3                        ; a31: 43
        INC                             ; a32: 1f
        BT   4,H'09E2'                  ; a33: 84 ae
        SL   1                          ; a35: 13
        SR   1                          ; a36: 12
        BZ   mode_entry_4               ; a37: 84 e7
        INC                             ; a39: 1f
        BF   1,H'0A84'                  ; a3a: 91 49
        CI   H'21'                      ; a3c: 25 21
        BM   mode_entry_1               ; a3e: 91 ba
        DCI  H'08DE'                    ; a40: 2a 08 de
        LR   A,3                        ; a43: 43
        SL   1                          ; a44: 13
        BF   1,H'0A83'                  ; a45: 91 3d
        SR   1                          ; a47: 12
        LR   8,A                        ; a48: 58
        INS  1                          ; a49: a1
        NI   H'03'                      ; a4a: 21 03
        BT   4,H'0A56'                  ; a4c: 84 09
        CI   H'01'                      ; a4e: 25 01
        LI   H'20'                      ; a50: 20 20
        ADC                             ; a52: 8e
        BT   1,H'0A56'                  ; a53: 81 02
        ADC                             ; a55: 8e
        LR   A,8                        ; a56: 48
        BT   1,H'0A5A'                  ; a57: 81 02
        ADC                             ; a59: 8e
        ADC                             ; a5a: 8e
        BF   1,H'0A62'                  ; a5b: 91 06
        LM                              ; a5d: 16
        LR   QL,A                       ; a5e: 07
        LIS  H'09'                      ; a5f: 79
        LR   QU,A                       ; a60: 06
        LR   DC,Q                       ; a61: 0f
        LM                              ; a62: 16
        LR   8,A                        ; a63: 58
        INS  1                          ; a64: a1
        NI   H'03'                      ; a65: 21 03
        BT   4,H'0A6F'                  ; a67: 84 07
        NI   H'02'                      ; a69: 21 02
        LIS  H'01'                      ; a6b: 71
        BT   4,H'0A6F'                  ; a6c: 84 02
        LIS  H'0B'                      ; a6e: 7b
        INC                             ; a6f: 1f
        SL   4                          ; a70: 15
        NS   8                          ; a71: f8
        BF   1,H'0A83'                  ; a72: 91 10
        BF   4,H'0A7B'                  ; a74: 94 06
        INS  1                          ; a76: a1
        SL   1                          ; a77: 13
        SL   4                          ; a78: 15
        BF   1,H'0A83'                  ; a79: 91 09
        LR   A,8                        ; a7b: 48
        SL   4                          ; a7c: 15
        SR   4                          ; a7d: 14
        LR   KU,A                       ; a7e: 04
        LM                              ; a7f: 16
        LR   KL,A                       ; a80: 05
        CLR                             ; a81: 70
        LISL 3                          ; a82: 6b
        PK                              ; a83: 0c
        PI   H'07C5'                    ; a84: 28 07 c5
        DS   5                          ; a87: 35
        BF   4,H'0A2F'                  ; a88: 94 a6
        PI   dispatch_entry_7           ; a8a: 28 08 15
        BM   mode_entry_4               ; a8d: 91 91
        DCI  H'085D'                    ; a8f: 2a 08 5d
        CI   H'1F'                      ; a92: 25 1f
        BM   mode_entry_4               ; a94: 91 8a
        ADC                             ; a96: 8e
        BR   H'0A5D'                    ; a97: 90 c5
        LR   A,4                        ; a99: 44
        OI   H'01'                      ; a9a: 22 01
        LR   4,A                        ; a9c: 54
        PI   dispatch_entry_7           ; a9d: 28 08 15
        BF   1,H'0A99'                  ; aa0: 91 f8
        CI   H'1F'                      ; aa2: 25 1f
        BP   mode_entry_5               ; aa4: 81 8c
        CI   H'5C'                      ; aa6: 25 5c
        BF   1,H'0A9D'                  ; aa8: 91 f4
        AI   H'D0'                      ; aaa: 24 d0
        BF   1,H'0A9D'                  ; aac: 91 f0
        DCI  H'095E'                    ; aae: 2a 09 5e
        ADC                             ; ab1: 8e
        ADC                             ; ab2: 8e
        DS   4                          ; ab3: 34
        BR   H'0A62'                    ; ab4: 90 ad
        PI   dispatch_entry_7           ; ab6: 28 08 15
        BF   1,H'0A8D'                  ; ab9: 91 d3
        CI   H'5C'                      ; abb: 25 5c
        BF   1,H'0A94'                  ; abd: 91 d6
        AI   H'DE'                      ; abf: 24 de
        DCI  H'087D'                    ; ac1: 2a 08 7d
        BR   H'0A94'                    ; ac4: 90 cf
        PI   H'07C5'                    ; ac6: 28 07 c5
        DS   5                          ; ac9: 35
        LR   A,3                        ; aca: 43
        BF   4,H'0ACF'                  ; acb: 94 03
        AI   H'FC'                      ; acd: 24 fc
        LR   7,A                        ; acf: 57
        INS  1                          ; ad0: a1
        NI   H'10'                      ; ad1: 21 10
        BF   4,H'0AF1'                  ; ad3: 94 1d
        LR   A,3                        ; ad5: 43
        DCI  H'08BC'                    ; ad6: 2a 08 bc
        ADC                             ; ad9: 8e
        LR   A,5                        ; ada: 45
        INC                             ; adb: 1f
        SL   1                          ; adc: 13
        SL   1                          ; add: 13
        ADC                             ; ade: 8e
        CLR                             ; adf: 70
        AM                              ; ae0: 88
        LR   8,A                        ; ae1: 58
        BT   1,H'0AE7'                  ; ae2: 81 04
        PI   H'06FD'                    ; ae4: 28 06 fd
        LR   A,8                        ; ae7: 48
        LR   3,A                        ; ae8: 53
        PI   H'06C1'                    ; ae9: 28 06 c1
        LI   H'20'                      ; aec: 20 20
        NS   S                          ; aee: fc
        BF   4,H'0B47'                  ; aef: 94 57
        LR   A,7                        ; af1: 47
        BR   H'0B35'                    ; af2: 90 42
        INS  1                          ; af4: a1
        NS   4                          ; af5: f4
        NI   H'02'                      ; af6: 21 02
        BT   4,H'0B56'                  ; af8: 84 5d
        INS  1                          ; afa: a1
        NI   H'10'                      ; afb: 21 10
        BF   4,H'0B56'                  ; afd: 94 58
        LR   A,3                        ; aff: 43
        NI   H'7F'                      ; b00: 21 7f
        OI   H'40'                      ; b02: 22 40
        LR   7,A                        ; b04: 57
        PI   H'06FD'                    ; b05: 28 06 fd
        LI   H'3F'                      ; b08: 20 3f
        LR   3,A                        ; b0a: 53
        PI   H'06C1'                    ; b0b: 28 06 c1
        LR   A,7                        ; b0e: 47
        LR   3,A                        ; b0f: 53
        PI   H'06C1'                    ; b10: 28 06 c1
        BR   H'0B47'                    ; b13: 90 33
        CI   H'FB'                      ; b15: 25 fb
        BF   1,H'0AC6'                  ; b17: 91 ae
        SR   1                          ; b19: 12
        SL   4                          ; b1a: 15
        BF   1,H'0AF4'                  ; b1b: 91 d8
        SL   1                          ; b1d: 13
        BT   1,H'0B29'                  ; b1e: 81 0a
        SL   1                          ; b20: 13
        BF   1,H'0AF4'                  ; b21: 91 d2
        LR   A,3                        ; b23: 43
        NI   H'01'                      ; b24: 21 01
        LIS  H'08'                      ; b26: 78
        BF   4,H'0B53'                  ; b27: 94 2b
        LR   A,3                        ; b29: 43
        NI   H'60'                      ; b2a: 21 60
        SL   1                          ; b2c: 13
        LR   7,A                        ; b2d: 57
        CLR                             ; b2e: 70
        BT   1,H'0B32'                  ; b2f: 81 02
        LIS  H'09'                      ; b31: 79
        AS   3                          ; b32: c3
        NI   H'1F'                      ; b33: 21 1f
        DCI  H'08CC'                    ; b35: 2a 08 cc
        ADC                             ; b38: 8e
        LIS  H'0B'                      ; b39: 7b
        LR   KU,A                       ; b3a: 04
        LI   H'4A'                      ; b3b: 20 4a
        LR   KL,A                       ; b3d: 05
        JMP  H'0A5D'                    ; b3e: 29 0a 5d
        LR   K,P                        ; b41: 08
        PI   H'0712'                    ; b42: 28 07 12
        BR   H'0B4A'                    ; b45: 90 04
        PI   H'0593'                    ; b47: 28 05 93
        PI   H'0793'                    ; b4a: 28 07 93
        BT   4,H'0B6F'                  ; b4d: 84 21
        CLR                             ; b4f: 70
        AS   3                          ; b50: c3
        BF   1,H'0B15'                  ; b51: 91 c3
        OI   H'80'                      ; b53: 22 80
        LR   3,A                        ; b55: 53
        INS  1                          ; b56: a1
        NI   H'10'                      ; b57: 21 10
        BF   4,H'0B91'                  ; b59: 94 37
        LR   A,3                        ; b5b: 43
        NI   H'7F'                      ; b5c: 21 7f
        LR   3,A                        ; b5e: 53
        CI   H'13'                      ; b5f: 25 13
        BF   4,H'0B67'                  ; b61: 94 05
        LI   H'FD'                      ; b63: 20 fd
        NS   S                          ; b65: fc
        LR   S,A                        ; b66: 5c
        PI   H'06C1'                    ; b67: 28 06 c1
        LI   H'20'                      ; b6a: 20 20
        NS   S                          ; b6c: fc
        BT   4,H'0B91'                  ; b6d: 84 23
        PI   H'07E3'                    ; b6f: 28 07 e3
        BM   mode_entry_7               ; b72: 91 0e
        LIS  H'02'                      ; b74: 72
        NS   S                          ; b75: fc
        BT   4,H'0B7D'                  ; b76: 84 06
        XS   S                          ; b78: ec
        LR   S,A                        ; b79: 5c
        PI   H'06F3'                    ; b7a: 28 06 f3
        LR   A,0                        ; b7d: 40
        XS   1                          ; b7e: e1
        BT   4,H'0B47'                  ; b7f: 84 c7
        LR   A,0                        ; b81: 40
        LR   IS,A                       ; b82: 0b
        LR   A,D                        ; b83: 4e
        LR   3,A                        ; b84: 53
        LR   A,IS                       ; b85: 0a
        BR7  H'0B90'                    ; b86: 8f 09
        AI   H'F8'                      ; b88: 24 f8
        CI   H'1F'                      ; b8a: 25 1f
        BF   4,H'0B90'                  ; b8c: 94 03
        LISU 7                          ; b8e: 67
        LR   A,IS                       ; b8f: 0a
        LR   0,A                        ; b90: 50
        PI   H'0709'                    ; b91: 28 07 09
        LISL 3                          ; b94: 6b
        LR   A,3                        ; b95: 43
        SL   1                          ; b96: 13
        SR   1                          ; b97: 12
        PK                              ; b98: 0c
        LR   6,A                        ; b99: 56
        LR   J,W                        ; b9a: 1e
        LR   A,IS                       ; b9b: 0a
        LISU 3                          ; b9c: 63
        LISL 0                          ; b9d: 68
        LR   I,A                        ; b9e: 5d
        LR   A,QU                       ; b9f: 02
        LR   I,A                        ; ba0: 5d
        LR   A,QL                       ; ba1: 03
        LR   S,A                        ; ba2: 5c
        LR   Q,DC                       ; ba3: 0e
        DCI  ext_peripheral_8000        ; ba4: 2a 80 00
        CLR                             ; ba7: 70
        AS   1                          ; ba8: c1
        LR   IS,A                       ; ba9: 0b
        LM                              ; baa: 16
        BT   4,H'0BF3'                  ; bab: 84 47
        NI   H'7F'                      ; bad: 21 7f
        LR   D,A                        ; baf: 5e
        BT   4,H'0BB5'                  ; bb0: 84 04
        INC                             ; bb2: 1f
        BT   1,H'0BC0'                  ; bb3: 81 0c
        INS  1                          ; bb5: a1
        NI   H'03'                      ; bb6: 21 03
        XI   H'01'                      ; bb8: 23 01
        BT   4,H'0BC0'                  ; bba: 84 05
        LR   A,4                        ; bbc: 44
        SL   4                          ; bbd: 15
        BT   1,H'0BF3'                  ; bbe: 81 34
        LR   A,IS                       ; bc0: 0a
        BR7  H'0BCB'                    ; bc1: 8f 09
        AI   H'F8'                      ; bc3: 24 f8
        CI   H'1F'                      ; bc5: 25 1f
        BF   4,H'0BCB'                  ; bc7: 94 03
        LISU 7                          ; bc9: 67
        LR   A,IS                       ; bca: 0a
        LR   1,A                        ; bcb: 51
        INS  1                          ; bcc: a1
        NI   H'06'                      ; bcd: 21 06
        XI   H'04'                      ; bcf: 23 04
        BT   4,H'0BF3'                  ; bd1: 84 21
        LR   A,1                        ; bd3: 41
        COM                             ; bd4: 18
        INC                             ; bd5: 1f
        AS   0                          ; bd6: c0
        BT   1,H'0BDB'                  ; bd7: 81 03
        AI   H'20'                      ; bd9: 24 20
        CI   H'18'                      ; bdb: 25 18
        BT   1,H'0BF3'                  ; bdd: 81 15
        INS  1                          ; bdf: a1
        SL   4                          ; be0: 15
        BF   1,H'0BE6'                  ; be1: 91 04
        LI   H'13'                      ; be3: 20 13
        ST                              ; be5: 17
        LISU 2                          ; be6: 62
        LISL 3                          ; be7: 6b
        LR   A,S                        ; be8: 4c
        OI   H'02'                      ; be9: 22 02
        LR   S,A                        ; beb: 5c
        NI   H'10'                      ; bec: 21 10
        BT   4,H'0BF3'                  ; bee: 84 04
        JMP  H'0111'                    ; bf0: 29 01 11
        LISU 3                          ; bf3: 63
        LISL 2                          ; bf4: 6a
        LR   DC,Q                       ; bf5: 0f
        LR   A,D                        ; bf6: 4e
        LR   QL,A                       ; bf7: 07
        LR   A,D                        ; bf8: 4e
        LR   QU,A                       ; bf9: 06
        LR   A,S                        ; bfa: 4c
        LR   IS,A                       ; bfb: 0b
        LR   W,J                        ; bfc: 1d
        LR   A,6                        ; bfd: 46
        EI                              ; bfe: 1b
        POP                             ; bff: 1c
