; Relabelled disassembly. Origin H'0400'.
; Symbols loaded from: U12.sym (20 addr, 10 port)
; Idempotent — re-run after editing U12.sym to refresh.
;
        CPU MK3850
;
; --- Symbol table (from .sym file; needed for asl reassembly) ---
pi_table_0450:          EQU H'0450'
sub_04DB:               EQU H'04DB'
pi_table_04E7:          EQU H'04E7'
pi_table_04F0:          EQU H'04F0'
sub_058F:               EQU H'058F'
sub_0593:               EQU H'0593'
sub_05B4:               EQU H'05B4'
sub_05E9:               EQU H'05E9'
sub_05F5:               EQU H'05F5'
sub_05FB:               EQU H'05FB'
sub_0601:               EQU H'0601'
sub_0612:               EQU H'0612'
sub_0624:               EQU H'0624'
sub_06F8:               EQU H'06F8'
sub_0703:               EQU H'0703'
sub_0712:               EQU H'0712'
sub_0793:               EQU H'0793'
ext_charrom_data:       EQU H'0C00'
ext_workram_2000:       EQU H'2000'
ext_peripheral_8000:    EQU H'8000'
PORT_CPU_0:             EQU H'00'
PORT_CPU_1:             EQU H'01'
PORT_PIO_04:            EQU H'04'
PORT_PIO_05:            EQU H'05'
PORT_PIO_06:            EQU H'06'
PORT_PIO_07:            EQU H'07'
PORT_SMI_VEC_HI:        EQU H'0C'
PORT_SMI_VEC_LO:        EQU H'0D'
PORT_SMI_ICP:           EQU H'0E'
PORT_SMI_TIMER:         EQU H'0F'
;
        ORG H'0400'
;
        NS   6                          ; 400: f6
        LISL 5                          ; 401: 6d
        LR   A,S                        ; 402: 4c
        OUTS 0                          ; 403: b0
        BR   H'045F'                    ; 404: 90 5a
        PI   sub_058F                   ; 406: 28 05 8f
        LR   A,HL                       ; 409: 4b
        CI   H'4F'                      ; 40a: 25 4f
        BT   4,H'03A1'                  ; 40c: 84 94
        CI   H'47'                      ; 40e: 25 47
        BF   1,H'0416'                  ; 410: 91 05
        NI   H'F8'                      ; 412: 21 f8
        AI   H'07'                      ; 414: 24 07
        INC                             ; 416: 1f
        LR   HL,A                       ; 417: 5b
        BR   H'03A1'                    ; 418: 90 88
        PI   sub_058F                   ; 41a: 28 05 8f
        LR   DC,H                       ; 41d: 10
        XDC                             ; 41e: 2c
        PI   H'061F'                    ; 41f: 28 06 1f
        BF   1,H'0429'                  ; 422: 91 06
        PI   sub_0624                   ; 424: 28 06 24
        BT   1,H'0418'                  ; 427: 81 f0
        INS  1                          ; 429: a1
        NI   H'03'                      ; 42a: 21 03
        BF   4,H'045F'                  ; 42c: 94 32
        JMP  H'0809'                    ; 42e: 29 08 09
        LI   H'80'                      ; 431: 20 80
        LR   8,A                        ; 433: 58
        LR   DC,H                       ; 434: 10
        LR   Q,DC                       ; 435: 0e
        PI   sub_05E9                   ; 436: 28 05 e9
        DS   5                          ; 439: 35
        BT   4,H'045A'                  ; 43a: 84 1f
        XS   8                          ; 43c: e8
        BF   1,H'0441'                  ; 43d: 91 03
        LR   A,2                        ; 43f: 42
        LR   HU,A                       ; 440: 5a
        CLR                             ; 441: 70
        LR   HL,A                       ; 442: 5b
        LI   H'50'                      ; 443: 20 50
        LR   7,A                        ; 445: 57
        LR   DC,H                       ; 446: 10
        XDC                             ; 447: 2c
        XS   8                          ; 448: e8
        BM   pi_table_0450              ; 449: 91 06
        PI   sub_05F5                   ; 44b: 28 05 f5
        BR   H'0453'                    ; 44e: 90 04
        PI   sub_0612                   ; 450: 28 06 12
        LR   DC,H                       ; 453: 10
        PI   sub_05B4                   ; 454: 28 05 b4
        DS   5                          ; 457: 35
        BF   4,H'0443'                  ; 458: 94 ea
        LR   DC,Q                       ; 45a: 0f
        XDC                             ; 45b: 2c
        PI   sub_04DB                   ; 45c: 28 04 db
        XDC                             ; 45f: 2c
        LR   H,DC                       ; 460: 11
        BR   H'0418'                    ; 461: 90 b6
        LR   A,HL                       ; 463: 4b
        AI   H'B0'                      ; 464: 24 b0
        COM                             ; 466: 18
        LR   7,A                        ; 467: 57
        LR   DC,H                       ; 468: 10
        LR   Q,DC                       ; 469: 0e
        XDC                             ; 46a: 2c
        BT   4,H'0473'                  ; 46b: 84 07
        LR   DC,H                       ; 46d: 10
        LIS  H'01'                      ; 46e: 71
        ADC                             ; 46f: 8e
        PI   sub_05B4                   ; 470: 28 05 b4
        XDC                             ; 473: 2c
        LI   H'FF'                      ; 474: 20 ff
        ADC                             ; 476: 8e
        INS  0                          ; 477: a0
        LR   8,A                        ; 478: 58
        NI   H'0E'                      ; 479: 21 0e
        OUTS 0                          ; 47b: b0
        PI   H'0723'                    ; 47c: 28 07 23
        INS  0                          ; 47f: a0
        INC                             ; 480: 1f
        OUTS 0                          ; 481: b0
        LI   H'20'                      ; 482: 20 20
        LR   3,A                        ; 484: 53
        PI   H'0754'                    ; 485: 28 07 54
        LR   A,8                        ; 488: 48
        OUTS 0                          ; 489: b0
        JMP  H'0333'                    ; 48a: 29 03 33
        LR   A,HU                       ; 48d: 4a
        LR   QU,A                       ; 48e: 06
        LI   H'4E'                      ; 48f: 20 4e
        LR   QL,A                       ; 491: 07
        PI   H'0815'                    ; 492: 28 08 15
        BF   1,H'04CB'                  ; 495: 91 35
        LR   8,A                        ; 497: 58
        CI   H'1F'                      ; 498: 25 1f
        BT   1,H'04D1'                  ; 49a: 81 36
        INC                             ; 49c: 1f
        BF   1,H'04D1'                  ; 49d: 91 33
        INS  0                          ; 49f: a0
        LR   7,A                        ; 4a0: 57
        LR   A,HL                       ; 4a1: 4b
        AI   H'B0'                      ; 4a2: 24 b0
        COM                             ; 4a4: 18
        LR   5,A                        ; 4a5: 55
        LR   DC,Q                       ; 4a6: 0f
        INS  0                          ; 4a7: a0
        NI   H'0E'                      ; 4a8: 21 0e
        OUTS 0                          ; 4aa: b0
        DS   5                          ; 4ab: 35
        BF   1,H'04BF'                  ; 4ac: 91 12
        PI   H'0723'                    ; 4ae: 28 07 23
        SL   1                          ; 4b1: 13
        SR   1                          ; 4b2: 12
        LR   3,A                        ; 4b3: 53
        INS  0                          ; 4b4: a0
        INC                             ; 4b5: 1f
        OUTS 0                          ; 4b6: b0
        PI   H'0754'                    ; 4b7: 28 07 54
        LI   H'FD'                      ; 4ba: 20 fd
        ADC                             ; 4bc: 8e
        BR   H'04A7'                    ; 4bd: 90 e9
        LR   A,7                        ; 4bf: 47
        OUTS 0                          ; 4c0: b0
        LR   A,8                        ; 4c1: 48
        LR   3,A                        ; 4c2: 53
        PI   H'0735'                    ; 4c3: 28 07 35
        LR   A,HL                       ; 4c6: 4b
        CI   H'4F'                      ; 4c7: 25 4f
        BF   4,H'04CE'                  ; 4c9: 94 04
        JMP  H'029F'                    ; 4cb: 29 02 9f
        LR   H,DC                       ; 4ce: 11
        BR   H'0492'                    ; 4cf: 90 c2
        PI   sub_0703                   ; 4d1: 28 07 03
        JMP  H'080F'                    ; 4d4: 29 08 0f
        LR   K,P                        ; 4d7: 08
        LR   DC,H                       ; 4d8: 10
        BR   H'04DF'                    ; 4d9: 90 05
        LR   K,P                        ; 4db: 08
        LR   DC,H                       ; 4dc: 10
        CLR                             ; 4dd: 70
        LR   HL,A                       ; 4de: 5b
        PI   sub_0712                   ; 4df: 28 07 12
        LIS  H'01'                      ; 4e2: 71
        BR   H'04FA'                    ; 4e3: 90 16
        LR   K,P                        ; 4e5: 08
        LR   DC,H                       ; 4e6: 10
        PI   sub_0712                   ; 4e7: 28 07 12
        PI   sub_05E9                   ; 4ea: 28 05 e9
        BR   H'04FA'                    ; 4ed: 90 0c
        LR   K,P                        ; 4ef: 08
        PI   sub_0712                   ; 4f0: 28 07 12
        PI   sub_05FB                   ; 4f3: 28 05 fb
        LR   DC,H                       ; 4f6: 10
        COM                             ; 4f7: 18
        LI   H'18'                      ; 4f8: 20 18
        LR   5,A                        ; 4fa: 55
        LR   Q,DC                       ; 4fb: 0e
        BF   1,H'051D'                  ; 4fc: 91 20
        PI   H'07DD'                    ; 4fe: 28 07 dd
        BF   1,H'051D'                  ; 501: 91 1b
        PI   sub_0793                   ; 503: 28 07 93
        BT   4,H'050B'                  ; 506: 84 04
        LISU 3                          ; 508: 63
        LR   S,A                        ; 509: 5c
        LISU 2                          ; 50a: 62
        LISL 2                          ; 50b: 6a
        LR   A,S                        ; 50c: 4c
        LR   3,A                        ; 50d: 53
        LR   DC,H                       ; 50e: 10
        LR   A,HL                       ; 50f: 4b
        COM                             ; 510: 18
        AI   H'51'                      ; 511: 24 51
        LR   8,A                        ; 513: 58
        PI   H'0754'                    ; 514: 28 07 54
        DS   8                          ; 517: 38
        BF   4,H'0514'                  ; 518: 94 fb
        BR   H'0583'                    ; 51a: 90 68
        LR   H,DC                       ; 51c: 11
        LR   A,HL                       ; 51d: 4b
        AI   H'33'                      ; 51e: 24 33
        LR   KL,A                       ; 520: 05
        LIS  H'05'                      ; 521: 75
        LNK                             ; 522: 19
        LR   KU,A                       ; 523: 04
        LR   DC,H                       ; 524: 10
        LR   8,A                        ; 525: 58
        LISL 2                          ; 526: 6a
        LR   A,S                        ; 527: 4c
        PK                              ; 528: 0c
        PI   sub_0612                   ; 529: 28 06 12
        CLR                             ; 52c: 70
        LR   HL,A                       ; 52d: 5b
        AS   8                          ; 52e: c8
        BT   4,H'04FE'                  ; 52f: 84 ce
        LR   DC,H                       ; 531: 10
        LR   A,S                        ; 532: 4c
        ST                              ; 533: 17
        ST                              ; 534: 17
        ST                              ; 535: 17
        ST                              ; 536: 17
        ST                              ; 537: 17
        ST                              ; 538: 17
        ST                              ; 539: 17
        ST                              ; 53a: 17
        ST                              ; 53b: 17
        ST                              ; 53c: 17
        ST                              ; 53d: 17
        ST                              ; 53e: 17
        ST                              ; 53f: 17
        ST                              ; 540: 17
        ST                              ; 541: 17
        ST                              ; 542: 17
        ST                              ; 543: 17
        ST                              ; 544: 17
        ST                              ; 545: 17
        ST                              ; 546: 17
        ST                              ; 547: 17
        ST                              ; 548: 17
        ST                              ; 549: 17
        ST                              ; 54a: 17
        ST                              ; 54b: 17
        ST                              ; 54c: 17
        ST                              ; 54d: 17
        ST                              ; 54e: 17
        ST                              ; 54f: 17
        ST                              ; 550: 17
        ST                              ; 551: 17
        ST                              ; 552: 17
        ST                              ; 553: 17
        ST                              ; 554: 17
        ST                              ; 555: 17
        ST                              ; 556: 17
        ST                              ; 557: 17
        ST                              ; 558: 17
        ST                              ; 559: 17
        ST                              ; 55a: 17
        ST                              ; 55b: 17
        ST                              ; 55c: 17
        ST                              ; 55d: 17
        ST                              ; 55e: 17
        ST                              ; 55f: 17
        ST                              ; 560: 17
        ST                              ; 561: 17
        ST                              ; 562: 17
        ST                              ; 563: 17
        ST                              ; 564: 17
        ST                              ; 565: 17
        ST                              ; 566: 17
        ST                              ; 567: 17
        ST                              ; 568: 17
        ST                              ; 569: 17
        ST                              ; 56a: 17
        ST                              ; 56b: 17
        ST                              ; 56c: 17
        ST                              ; 56d: 17
        ST                              ; 56e: 17
        ST                              ; 56f: 17
        ST                              ; 570: 17
        ST                              ; 571: 17
        ST                              ; 572: 17
        ST                              ; 573: 17
        ST                              ; 574: 17
        ST                              ; 575: 17
        ST                              ; 576: 17
        ST                              ; 577: 17
        ST                              ; 578: 17
        ST                              ; 579: 17
        ST                              ; 57a: 17
        ST                              ; 57b: 17
        ST                              ; 57c: 17
        ST                              ; 57d: 17
        ST                              ; 57e: 17
        ST                              ; 57f: 17
        ST                              ; 580: 17
        ST                              ; 581: 17
        ST                              ; 582: 17
        DS   5                          ; 583: 35
        BF   4,H'0529'                  ; 584: 94 a4
        LI   H'20'                      ; 586: 20 20
        LR   S,A                        ; 588: 5c
        LR   DC,Q                       ; 589: 0f
        LR   H,DC                       ; 58a: 11
        PI   H'0709'                    ; 58b: 28 07 09
        PK                              ; 58e: 0c
        LR   K,P                        ; 58f: 08
        CLR                             ; 590: 70
        BR   H'059B'                    ; 591: 90 09
        LR   K,P                        ; 593: 08
        INS  1                          ; 594: a1
        NI   H'20'                      ; 595: 21 20
        BF   4,H'05B3'                  ; 597: 94 1b
        LI   H'80'                      ; 599: 20 80
        LR   3,A                        ; 59b: 53
        INS  0                          ; 59c: a0
        LR   8,A                        ; 59d: 58
        NI   H'0E'                      ; 59e: 21 0e
        OUTS 0                          ; 5a0: b0
        PI   H'0721'                    ; 5a1: 28 07 21
        NI   H'7F'                      ; 5a4: 21 7f
        XS   3                          ; 5a6: e3
        LR   3,A                        ; 5a7: 53
        INS  0                          ; 5a8: a0
        INC                             ; 5a9: 1f
        OUTS 0                          ; 5aa: b0
        BR   H'05AE'                    ; 5ab: 90 02
        LR   K,P                        ; 5ad: 08
        PI   H'0752'                    ; 5ae: 28 07 52
        LR   A,8                        ; 5b1: 48
        OUTS 0                          ; 5b2: b0
        PK                              ; 5b3: 0c
        LR   K,P                        ; 5b4: 08
        LISL 5                          ; 5b5: 6d
        INS  0                          ; 5b6: a0
        LR   S,A                        ; 5b7: 5c
        PI   H'07DD'                    ; 5b8: 28 07 dd
        BF   1,H'05D5'                  ; 5bb: 91 19
        INS  0                          ; 5bd: a0
        NI   H'0E'                      ; 5be: 21 0e
        OUTS 0                          ; 5c0: b0
        PI   H'0723'                    ; 5c1: 28 07 23
        XDC                             ; 5c4: 2c
        NI   H'7F'                      ; 5c5: 21 7f
        LR   3,A                        ; 5c7: 53
        INS  0                          ; 5c8: a0
        INC                             ; 5c9: 1f
        OUTS 0                          ; 5ca: b0
        PI   H'0754'                    ; 5cb: 28 07 54
        XDC                             ; 5ce: 2c
        DS   7                          ; 5cf: 37
        BF   4,H'05B8'                  ; 5d0: 94 e7
        LR   A,I                        ; 5d2: 4d
        OUTS 0                          ; 5d3: b0
        PK                              ; 5d4: 0c
        INS  0                          ; 5d5: a0
        NI   H'0E'                      ; 5d6: 21 0e
        OUTS 0                          ; 5d8: b0
        LM                              ; 5d9: 16
        XDC                             ; 5da: 2c
        SL   1                          ; 5db: 13
        SR   1                          ; 5dc: 12
        LR   3,A                        ; 5dd: 53
        INS  0                          ; 5de: a0
        INC                             ; 5df: 1f
        OUTS 0                          ; 5e0: b0
        LR   A,3                        ; 5e1: 43
        ST                              ; 5e2: 17
        XDC                             ; 5e3: 2c
        DS   7                          ; 5e4: 37
        BF   4,H'05D5'                  ; 5e5: 94 ef
        BR   H'05D2'                    ; 5e7: 90 ea
        LR   K,P                        ; 5e9: 08
        LR   A,HU                       ; 5ea: 4a
        COM                             ; 5eb: 18
        INC                             ; 5ec: 1f
        AS   2                          ; 5ed: c2
        BT   1,H'05F2'                  ; 5ee: 81 03
        AI   H'18'                      ; 5f0: 24 18
        INC                             ; 5f2: 1f
        LR   5,A                        ; 5f3: 55
        PK                              ; 5f4: 0c
        LR   K,P                        ; 5f5: 08
        LR   A,HU                       ; 5f6: 4a
        AI   H'17'                      ; 5f7: 24 17
        BR   H'0615'                    ; 5f9: 90 1b
        LR   K,P                        ; 5fb: 08
        CLR                             ; 5fc: 70
        LR   HL,A                       ; 5fd: 5b
        LR   A,2                        ; 5fe: 42
        BR   H'0614'                    ; 5ff: 90 14
        LR   K,P                        ; 601: 08
        LR   A,HL                       ; 602: 4b
        INC                             ; 603: 1f
        CI   H'CF'                      ; 604: 25 cf
        BF   1,H'0610'                  ; 606: 91 09
        LR   A,HU                       ; 608: 4a
        XS   2                          ; 609: e2
        BT   4,H'0611'                  ; 60a: 84 06
        CLR                             ; 60c: 70
        LR   HL,A                       ; 60d: 5b
        BR   H'0613'                    ; 60e: 90 04
        LR   HL,A                       ; 610: 5b
        PK                              ; 611: 0c
        LR   K,P                        ; 612: 08
        LR   A,HU                       ; 613: 4a
        INC                             ; 614: 1f
        CI   H'57'                      ; 615: 25 57
        BT   1,H'061B'                  ; 617: 81 03
        AI   H'E8'                      ; 619: 24 e8
        LR   HU,A                       ; 61b: 5a
        SL   1                          ; 61c: 13
        SR   1                          ; 61d: 12
        PK                              ; 61e: 0c
        LR   K,P                        ; 61f: 08
        LI   H'80'                      ; 620: 20 80
        BR   H'0626'                    ; 622: 90 03
        LR   K,P                        ; 624: 08
        CLR                             ; 625: 70
        LR   5,A                        ; 626: 55
        LR   DC,H                       ; 627: 10
        LR   Q,DC                       ; 628: 0e
        PI   H'0721'                    ; 629: 28 07 21
        XS   5                          ; 62c: e5
        BT   1,H'0653'                  ; 62d: 81 25
        PI   H'07DD'                    ; 62f: 28 07 dd
        BF   1,H'0654'                  ; 632: 91 21
        PI   H'0721'                    ; 634: 28 07 21
        XS   5                          ; 637: e5
        BT   1,H'0653'                  ; 638: 81 1a
        LR   H,DC                       ; 63a: 11
        LI   H'50'                      ; 63b: 20 50
        XS   HL                         ; 63d: eb
        BF   4,H'0634'                  ; 63e: 94 f5
        LR   HL,A                       ; 640: 5b
        LR   A,HU                       ; 641: 4a
        XS   2                          ; 642: e2
        BT   4,H'0650'                  ; 643: 84 0c
        LR   A,HU                       ; 645: 4a
        INC                             ; 646: 1f
        CI   H'58'                      ; 647: 25 58
        BF   4,H'064D'                  ; 649: 94 03
        LI   H'40'                      ; 64b: 20 40
        LR   HU,A                       ; 64d: 5a
        BR   H'062F'                    ; 64e: 90 e0
        COM                             ; 650: 18
        LR   DC,Q                       ; 651: 0f
        LR   H,DC                       ; 652: 11
        PK                              ; 653: 0c
        LR   DC,H                       ; 654: 10
        PI   sub_0712                   ; 655: 28 07 12
        LR   A,HL                       ; 658: 4b
        AI   H'F0'                      ; 659: 24 f0
        BT   1,H'0659'                  ; 65b: 81 fd
        AI   H'83'                      ; 65d: 24 83
        LR   KL,A                       ; 65f: 05
        CLR                             ; 660: 70
        AS   5                          ; 661: c5
        LIS  H'06'                      ; 662: 76
        BF   1,H'066A'                  ; 663: 91 06
        LR   A,KL                       ; 665: 01
        AI   H'2B'                      ; 666: 24 2b
        LR   KL,A                       ; 668: 05
        LIS  H'06'                      ; 669: 76
        LR   KU,A                       ; 66a: 04
        LR   A,5                        ; 66b: 45
        COM                             ; 66c: 18
        PK                              ; 66d: 0c
        LI   H'FF'                      ; 66e: 20 ff
        XS   5                          ; 670: e5
        BF   1,H'069E'                  ; 671: 91 2c
        OM                              ; 673: 8b
        OM                              ; 674: 8b
        OM                              ; 675: 8b
        OM                              ; 676: 8b
        OM                              ; 677: 8b
        OM                              ; 678: 8b
        OM                              ; 679: 8b
        OM                              ; 67a: 8b
        OM                              ; 67b: 8b
        OM                              ; 67c: 8b
        OM                              ; 67d: 8b
        OM                              ; 67e: 8b
        OM                              ; 67f: 8b
        OM                              ; 680: 8b
        OM                              ; 681: 8b
        OM                              ; 682: 8b
        BF   1,H'06B0'                  ; 683: 91 2c
        LR   H,DC                       ; 685: 11
        LI   H'50'                      ; 686: 20 50
        XS   HL                         ; 688: eb
        BF   4,H'066E'                  ; 689: 94 e4
        LR   HL,A                       ; 68b: 5b
        LR   A,HU                       ; 68c: 4a
        XS   2                          ; 68d: e2
        BT   4,H'06B9'                  ; 68e: 84 2a
        LR   A,HU                       ; 690: 4a
        INC                             ; 691: 1f
        CI   H'58'                      ; 692: 25 58
        BF   4,H'0698'                  ; 694: 94 03
        LI   H'40'                      ; 696: 20 40
        LR   HU,A                       ; 698: 5a
        LR   DC,H                       ; 699: 10
        COM                             ; 69a: 18
        XS   5                          ; 69b: e5
        BT   1,H'0673'                  ; 69c: 81 d6
        NM                              ; 69e: 8a
        NM                              ; 69f: 8a
        NM                              ; 6a0: 8a
        NM                              ; 6a1: 8a
        NM                              ; 6a2: 8a
        NM                              ; 6a3: 8a
        NM                              ; 6a4: 8a
        NM                              ; 6a5: 8a
        NM                              ; 6a6: 8a
        NM                              ; 6a7: 8a
        NM                              ; 6a8: 8a
        NM                              ; 6a9: 8a
        NM                              ; 6aa: 8a
        NM                              ; 6ab: 8a
        NM                              ; 6ac: 8a
        NM                              ; 6ad: 8a
        BF   1,H'0685'                  ; 6ae: 91 d6
        LR   DC,H                       ; 6b0: 10
        LR   A,5                        ; 6b1: 45
        XM                              ; 6b2: 8c
        BF   1,H'06B1'                  ; 6b3: 91 fd
        CLR                             ; 6b5: 70
        COM                             ; 6b6: 18
        ADC                             ; 6b7: 8e
        LR   Q,DC                       ; 6b8: 0e
        LR   5,A                        ; 6b9: 55
        PI   H'0709'                    ; 6ba: 28 07 09
        LISL 3                          ; 6bd: 6b
        LR   A,5                        ; 6be: 45
        BR   H'0650'                    ; 6bf: 90 90
        LR   K,P                        ; 6c1: 08
        LISL 3                          ; 6c2: 6b
        LI   H'20'                      ; 6c3: 20 20
        NS   S                          ; 6c5: fc
        BF   4,H'06CC'                  ; 6c6: 94 05
        INS  0                          ; 6c8: a0
        OI   H'02'                      ; 6c9: 22 02
        OUTS 0                          ; 6cb: b0
        DCI  ext_peripheral_8000        ; 6cc: 2a 80 00
        EI                              ; 6cf: 1b
        INS  1                          ; 6d0: a1
        SL   4                          ; 6d1: 15
        DI                              ; 6d2: 1a
        BF   1,H'06CF'                  ; 6d3: 91 fb
        LR   A,3                        ; 6d5: 43
        ST                              ; 6d6: 17
        EI                              ; 6d7: 1b
        LIS  H'03'                      ; 6d8: 73
        XS   3                          ; 6d9: e3
        BT   4,H'06E0'                  ; 6da: 84 05
        LIS  H'0D'                      ; 6dc: 7d
        XS   3                          ; 6dd: e3
        BF   4,H'06E4'                  ; 6de: 94 05
        INS  0                          ; 6e0: a0
        NI   H'FD'                      ; 6e1: 21 fd
        OUTS 0                          ; 6e3: b0
        PK                              ; 6e4: 0c
        LR   K,P                        ; 6e5: 08
        DCI  ext_peripheral_8000        ; 6e6: 2a 80 00
        EI                              ; 6e9: 1b
        INS  1                          ; 6ea: a1
        SL   4                          ; 6eb: 15
        DI                              ; 6ec: 1a
        BF   1,H'06E9'                  ; 6ed: 91 fb
        LR   A,3                        ; 6ef: 43
        ST                              ; 6f0: 17
        EI                              ; 6f1: 1b
        PK                              ; 6f2: 0c
        LR   K,P                        ; 6f3: 08
        LI   H'11'                      ; 6f4: 20 11
        BR   H'0700'                    ; 6f6: 90 09
        LR   K,P                        ; 6f8: 08
        LI   H'13'                      ; 6f9: 20 13
        BR   H'0700'                    ; 6fb: 90 04
        LR   K,P                        ; 6fd: 08
        LI   H'1B'                      ; 6fe: 20 1b
        LR   3,A                        ; 700: 53
        BR   H'06C2'                    ; 701: 90 c0
        LR   K,P                        ; 703: 08
        DCI  ext_charrom_data           ; 704: 2a 0c 00
        LM                              ; 707: 16
        PK                              ; 708: 0c
        DI                              ; 709: 1a
        LISU 2                          ; 70a: 62
        LISL 1                          ; 70b: 69
        LR   A,D                        ; 70c: 4e
        LR   KL,A                       ; 70d: 05
        LR   A,S                        ; 70e: 4c
        LR   KU,A                       ; 70f: 04
        EI                              ; 710: 1b
        POP                             ; 711: 1c
        DI                              ; 712: 1a
        LISU 2                          ; 713: 62
        LISL 0                          ; 714: 68
        LR   A,KU                       ; 715: 00
        LR   I,A                        ; 716: 5d
        LR   A,KL                       ; 717: 01
        LR   I,A                        ; 718: 5d
        EI                              ; 719: 1b
        POP                             ; 71a: 1c
        DI                              ; 71b: 1a
        INS  0                          ; 71c: a0
        LR   8,A                        ; 71d: 58
        NI   H'0E'                      ; 71e: 21 0e
        OUTS 0                          ; 720: b0
        DI                              ; 721: 1a
        LR   DC,H                       ; 722: 10
        DI                              ; 723: 1a
        INS  1                          ; 724: a1
        BT   1,H'0724'                  ; 725: 81 fe
        INS  1                          ; 727: a1
        BF   1,H'0727'                  ; 728: 91 fe
        INS  1                          ; 72a: a1
        CLR                             ; 72b: 70
        BT   1,H'0731'                  ; 72c: 81 04
        AM                              ; 72e: 88
        BR   H'0733'                    ; 72f: 90 03
        DI                              ; 731: 1a
        AM                              ; 732: 88
        EI                              ; 733: 1b
        POP                             ; 734: 1c
        LR   K,P                        ; 735: 08
        LR   A,3                        ; 736: 43
        SL   1                          ; 737: 13
        SR   1                          ; 738: 12
        LR   3,A                        ; 739: 53
        INC                             ; 73a: 1f
        BF   1,H'0750'                  ; 73b: 91 14
        LR   A,4                        ; 73d: 44
        SL   1                          ; 73e: 13
        SL   1                          ; 73f: 13
        BT   1,H'0750'                  ; 740: 81 0f
        LR   A,3                        ; 742: 43
        CI   H'5D'                      ; 743: 25 5d
        BT   1,H'0750'                  ; 745: 81 0a
        CI   H'5F'                      ; 747: 25 5f
        BF   1,H'074D'                  ; 749: 91 03
        LI   H'80'                      ; 74b: 20 80
        AI   H'A0'                      ; 74d: 24 a0
        LR   3,A                        ; 74f: 53
        DI                              ; 750: 1a
        LR   P,K                        ; 751: 09
        DI                              ; 752: 1a
        LR   DC,H                       ; 753: 10
        DI                              ; 754: 1a
        INS  1                          ; 755: a1
        BT   1,H'0755'                  ; 756: 81 fe
        INS  1                          ; 758: a1
        BF   1,H'0758'                  ; 759: 91 fe
        INS  1                          ; 75b: a1
        LR   A,3                        ; 75c: 43
        BT   1,H'0762'                  ; 75d: 81 04
        ST                              ; 75f: 17
        BR   H'0764'                    ; 760: 90 03
        DI                              ; 762: 1a
        ST                              ; 763: 17
        EI                              ; 764: 1b
        POP                             ; 765: 1c
        LR   K,P                        ; 766: 08
        LI   H'BF'                      ; 767: 20 bf
        NS   4                          ; 769: f4
        BR   H'0770'                    ; 76a: 90 05
        LR   K,P                        ; 76c: 08
        LR   A,4                        ; 76d: 44
        OI   H'40'                      ; 76e: 22 40
        LR   4,A                        ; 770: 54
        BR   H'0778'                    ; 771: 90 06
        LR   K,P                        ; 773: 08
        CLR                             ; 774: 70
        BR   H'077A'                    ; 775: 90 04
        LR   K,P                        ; 777: 08
        LI   H'40'                      ; 778: 20 40
        LISL 3                          ; 77a: 6b
        NS   S                          ; 77b: fc
        NS   4                          ; 77c: f4
        LR   QL,A                       ; 77d: 07
        PI   H'0788'                    ; 77e: 28 07 88
        OI   H'E0'                      ; 781: 22 e0
        LR   QU,A                       ; 783: 06
        LR   DC,Q                       ; 784: 0f
        ST                              ; 785: 17
        BR   H'07AF'                    ; 786: 90 28
        DI                              ; 788: 1a
        LR   A,2                        ; 789: 42
        INC                             ; 78a: 1f
        CI   H'58'                      ; 78b: 25 58
        BF   4,H'0791'                  ; 78d: 94 03
        LI   H'40'                      ; 78f: 20 40
        EI                              ; 791: 1b
        POP                             ; 792: 1c
        LR   K,P                        ; 793: 08
        LISU 3                          ; 794: 63
        LISL 3                          ; 795: 6b
        LR   A,S                        ; 796: 4c
        LR   3,A                        ; 797: 53
        CI   H'FB'                      ; 798: 25 fb
        LI   H'FB'                      ; 79a: 20 fb
        LR   S,A                        ; 79c: 5c
        LISU 2                          ; 79d: 62
        BF   4,H'07C3'                  ; 79e: 94 24
        DI                              ; 7a0: 1a
        INS  1                          ; 7a1: a1
        SL   1                          ; 7a2: 13
        LR   A,S                        ; 7a3: 4c
        BF   1,H'07B2'                  ; 7a4: 91 0d
        NI   H'FE'                      ; 7a6: 21 fe
        LR   S,A                        ; 7a8: 5c
        LI   H'1B'                      ; 7a9: 20 1b
        XS   3                          ; 7ab: e3
        BT   4,H'076D'                  ; 7ac: 84 c0
        EI                              ; 7ae: 1b
        NI   H'00'                      ; 7af: 21 00
        PK                              ; 7b1: 0c
        NI   H'01'                      ; 7b2: 21 01
        BF   4,H'07AE'                  ; 7b4: 94 f9
        DCI  ext_workram_2000           ; 7b6: 2a 20 00
        LM                              ; 7b9: 16
        LR   3,A                        ; 7ba: 53
        EI                              ; 7bb: 1b
        LR   A,S                        ; 7bc: 4c
        INC                             ; 7bd: 1f
        LR   S,A                        ; 7be: 5c
        LR   A,4                        ; 7bf: 44
        SL   1                          ; 7c0: 13
        BT   1,H'07A9'                  ; 7c1: 81 e7
        LR   A,3                        ; 7c3: 43
        PK                              ; 7c4: 0c
        LR   K,P                        ; 7c5: 08
        INS  1                          ; 7c6: a1
        NI   H'03'                      ; 7c7: 21 03
        LR   5,A                        ; 7c9: 55
        NI   H'01'                      ; 7ca: 21 01
        LR   A,5                        ; 7cc: 45
        BT   4,H'07DC'                  ; 7cd: 84 0e
        NI   H'02'                      ; 7cf: 21 02
        BT   4,H'07CC'                  ; 7d1: 84 fa
        BR   H'07C9'                    ; 7d3: 90 f5
        LR   K,P                        ; 7d5: 08
        LISL 5                          ; 7d6: 6d
        INS  0                          ; 7d7: a0
        LR   S,A                        ; 7d8: 5c
        OI   H'F0'                      ; 7d9: 22 f0
        OUTS 0                          ; 7db: b0
        PK                              ; 7dc: 0c
        DI                              ; 7dd: 1a
        INS  1                          ; 7de: a1
        NI   H'03'                      ; 7df: 21 03
        BT   4,H'07EA'                  ; 7e1: 84 08
        DI                              ; 7e3: 1a
        LR   A,1                        ; 7e4: 41
        COM                             ; 7e5: 18
        INC                             ; 7e6: 1f
        AS   0                          ; 7e7: c0
        BT   1,H'07EC'                  ; 7e8: 81 03
        AI   H'20'                      ; 7ea: 24 20
        CI   H'08'                      ; 7ec: 25 08
        EI                              ; 7ee: 1b
        POP                             ; 7ef: 1c
        DB   H'FF'                      ; 7f0: ff
        LR   A,KU                       ; 7f1: 00
        DB   H'FF'                      ; 7f2: ff
        LR   A,KU                       ; 7f3: 00
        DB   H'FF'                      ; 7f4: ff
        LR   A,KU                       ; 7f5: 00
        DB   H'FF'                      ; 7f6: ff
        LR   A,KU                       ; 7f7: 00
        DB   H'FF'                      ; 7f8: ff
        LR   A,KU                       ; 7f9: 00
        DB   H'FF'                      ; 7fa: ff
        LR   A,KU                       ; 7fb: 00
        DB   H'FF'                      ; 7fc: ff
        LR   A,KU                       ; 7fd: 00
        DB   H'FF'                      ; 7fe: ff
        LR   A,KU                       ; 7ff: 00
