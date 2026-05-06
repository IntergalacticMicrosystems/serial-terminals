; Disassembly of U2-D2716.bin
; Origin: $0000   Length: $0800 (2048 bytes)
; CPU:    Intel MCS-48 (8039 / 8048)

        ORG  $0000

RESET:  ; cold-start: DIS I ; JMP MAIN_INIT
  0000  15          DIS  I
  0001  24 00       JMP  MAIN_INIT
IRQ_EXT:  ; external (INT) — currently DIS I ; RETR (unused?)
  0003  15          DIS  I
  0004  93          RETR
  0005  FF FF                                              db   $FF,$FF   ; ..
IRQ_TIMER:  ; timer/counter ISR — heart of the scan/tick loop
  0007  C5          SEL  RB0
  0008  B9 4C       MOV  R1,#$4C
  000A  A1          MOV  @R1,A
  000B  23 FD       MOV  A,#$FD
  000D  62          MOV  T,A
  000E  55          STRT T
  000F  14 40       CALL L_0040
  0011  14 82       CALL L_0082
  0013  14 C0       CALL L_00C0
  0015  B9 49       MOV  R1,#$49
  0017  F1          MOV  A,@R1
  0018  96 36       JNZ  L_0036
  001A  B9 4A       MOV  R1,#$4A
  001C  F1          MOV  A,@R1
  001D  96 28       JNZ  L_0028
  001F  B9 4B       MOV  R1,#$4B
  0021  F1          MOV  A,@R1
  0022  C6 2D       JZ   L_002D
  0024  11          INC  @R1
  0025  B9 4A       MOV  R1,#$4A
  0027  F1          MOV  A,@R1
L_0028:
  0028  12 32       JB0  L_0032
L_002A:
  002A  99 BF       ANL  P1,#$BF
L_002C:
  002C  11          INC  @R1
L_002D:
  002D  B9 4C       MOV  R1,#$4C
  002F  F1          MOV  A,@R1
  0030  25          EN   TCNTI
  0031  93          RETR
L_0032:
  0032  89 40       ORL  P1,#$40
  0034  04 2C       JMP  L_002C
L_0036:
  0036  52 3C       JB2  L_003C
  0038  12 32       JB0  L_0032
  003A  04 2A       JMP  L_002A
L_003C:
  003C  32 32       JB1  L_0032
  003E  04 2A       JMP  L_002A
L_0040:
  0040  B9 48       MOV  R1,#$48
  0042  F1          MOV  A,@R1
  0043  96 7F       JNZ  L_007F
  0045  B9 47       MOV  R1,#$47
  0047  F1          MOV  A,@R1
  0048  C6 61       JZ   L_0061
  004A  D3 0A       XRL  A,#$0A
  004C  C6 6F       JZ   L_006F
  004E  F1          MOV  A,@R1
  004F  D3 01       XRL  A,#$01
  0051  C6 68       JZ   L_0068
  0053  D5          SEL  RB1
  0054  97          CLR  C
  0055  46 58       JNT1 L_0058
  0057  A7          CPL  C
L_0058:
  0058  FC          MOV  A,R4
  0059  67          RRC  A
  005A  AC          MOV  R4,A
  005B  C5          SEL  RB0
L_005C:
  005C  11          INC  @R1
  005D  19          INC  R1
  005E  B1 07       MOV  @R1,#$07
  0060  83          RET
L_0061:
  0061  56 67       JT1  L_0067
  0063  11          INC  @R1
  0064  19          INC  R1
  0065  B1 03       MOV  @R1,#$03
L_0067:
  0067  83          RET
L_0068:
  0068  46 5C       JNT1 L_005C
L_006A:
  006A  B9 47       MOV  R1,#$47
  006C  B1 00       MOV  @R1,#$00
  006E  83          RET
L_006F:
  006F  D5          SEL  RB1
  0070  FC          MOV  A,R4
  0071  C5          SEL  RB0
  0072  56 76       JT1  L_0076
  0074  C6 67       JZ   L_0067
L_0076:
  0076  B9 4D       MOV  R1,#$4D
  0078  A1          MOV  @R1,A
  0079  FF          MOV  A,R7
  007A  43 04       ORL  A,#$04
  007C  AF          MOV  R7,A
  007D  04 6A       JMP  L_006A
L_007F:
  007F  07          DEC  A
  0080  A1          MOV  @R1,A
  0081  83          RET
L_0082:
  0082  FB          MOV  A,R3
  0083  DC          XRL  A,R4
  0084  C6 A4       JZ   L_00A4
  0086  B9 40       MOV  R1,#$40
  0088  F1          MOV  A,@R1
  0089  96 7F       JNZ  L_007F
  008B  B1 07       MOV  @R1,#$07
  008D  19          INC  R1
  008E  F1          MOV  A,@R1
  008F  C6 A5       JZ   L_00A5
  0091  D3 09       XRL  A,#$09
  0093  C6 AD       JZ   L_00AD
  0095  F1          MOV  A,@R1
  0096  D3 0A       XRL  A,#$0A
  0098  C6 B5       JZ   L_00B5
  009A  FD          MOV  A,R5
  009B  67          RRC  A
  009C  AD          MOV  R5,A
  009D  F6 B1       JC   L_00B1
L_009F:
  009F  99 7F       ANL  P1,#$7F
L_00A1:
  00A1  B9 41       MOV  R1,#$41
  00A3  11          INC  @R1
L_00A4:
  00A4  83          RET
L_00A5:
  00A5  FC          MOV  A,R4
  00A6  03 60       ADD  A,#$60
  00A8  A9          MOV  R1,A
  00A9  F1          MOV  A,@R1
  00AA  AD          MOV  R5,A
  00AB  04 9F       JMP  L_009F
L_00AD:
  00AD  B9 40       MOV  R1,#$40
  00AF  B1 0F       MOV  @R1,#$0F
L_00B1:
  00B1  89 80       ORL  P1,#$80
  00B3  04 A1       JMP  L_00A1
L_00B5:
  00B5  B1 00       MOV  @R1,#$00
  00B7  C9          DEC  R1
  00B8  B1 00       MOV  @R1,#$00
  00BA  1C          INC  R4
  00BB  FC          MOV  A,R4
  00BC  53 07       ANL  A,#$07
  00BE  AC          MOV  R4,A
  00BF  83          RET
L_00C0:
  00C0  B6 C3       JF0  L_00C3
  00C2  83          RET
L_00C3:
  00C3  B9 42       MOV  R1,#$42
  00C5  F1          MOV  A,@R1
  00C6  C6 CA       JZ   L_00CA
  00C8  11          INC  @R1
  00C9  83          RET
L_00CA:
  00CA  B1 2E       MOV  @R1,#$2E
  00CC  19          INC  R1
  00CD  F1          MOV  A,@R1
  00CE  C6 D2       JZ   L_00D2
  00D0  11          INC  @R1
  00D1  83          RET
L_00D2:
  00D2  FB          MOV  A,R3
  00D3  03 60       ADD  A,#$60
  00D5  A9          MOV  R1,A
  00D6  FE          MOV  A,R6
  00D7  A1          MOV  @R1,A
  00D8  1B          INC  R3
  00D9  FB          MOV  A,R3
  00DA  53 07       ANL  A,#$07
  00DC  AB          MOV  R3,A
  00DD  76 E3       JF1  L_00E3
  00DF  B9 49       MOV  R1,#$49
  00E1  B1 DF       MOV  @R1,#$DF
L_00E3:
  00E3  83          RET
SCAN_GI_PORT:  ; CALL site for the scan loop (called from main)
  00E4  D5          SEL  RB1
  00E5  BF 30       MOV  R7,#$30
  00E7  BB 67       MOV  R3,#$67
  00E9  B9 20       MOV  R1,#$20
SCAN_GI_PORT_LOOP:
  00EB  FF          MOV  A,R7
  00EC  A8          MOV  R0,A
  00ED  F0          MOV  A,@R0
  00EE  90          MOVX @R0,A
  00EF  80          MOVX A,@R0
  00F0  AD          MOV  R5,A
  00F1  34 D0       CALL PROC_SCAN_BYTE
  00F3  1F          INC  R7
  00F4  19          INC  R1
  00F5  FF          MOV  A,R7
  00F6  D3 3D       XRL  A,#$3D
  00F8  96 EB       JNZ  SCAN_GI_PORT_LOOP
  00FA  83          RET
  00FB  FF FF FF FF FF                                     db   $FF,$FF,$FF,$FF,$FF   ; .....
MAIN_INIT:  ; entered from RESET via JMP at $0001
  0100  35          DIS  TCNTI
  0101  27          CLR  A
  0102  D7          MOV  PSW,A
  0103  E5          SEL  MB0
  0104  A5          CLR  F1
  0105  23 8F       MOV  A,#$8F
  0107  39          OUTL P1,A
  0108  27          CLR  A
  0109  B8 7F       MOV  R0,#$7F
L_010B:
  010B  A0          MOV  @R0,A
  010C  E8 0B       DJNZ R0,L_010B
  010E  23 FD       MOV  A,#$FD
  0110  62          MOV  T,A
  0111  55          STRT T
  0112  25          EN   TCNTI
L_0113:
  0113  14 E4       CALL SCAN_GI_PORT
  0115  C5          SEL  RB0
  0116  B8 53       MOV  R0,#$53
  0118  F0          MOV  A,@R0
  0119  C6 23       JZ   L_0123
  011B  B8 54       MOV  R0,#$54
  011D  10          INC  @R0
  011E  F0          MOV  A,@R0
  011F  D2 28       JB6  L_0128
  0121  99 EF       ANL  P1,#$EF
L_0123:
  0123  FF          MOV  A,R7
  0124  52 2C       JB2  L_012C
  0126  24 13       JMP  L_0113
L_0128:
  0128  89 10       ORL  P1,#$10
  012A  24 23       JMP  L_0123
L_012C:
  012C  53 FB       ANL  A,#$FB
  012E  AF          MOV  R7,A
  012F  B8 50       MOV  R0,#$50
  0131  F0          MOV  A,@R0
  0132  96 8B       JNZ  L_018B
  0134  B8 4D       MOV  R0,#$4D
  0136  F0          MOV  A,@R0
  0137  D3 4D       XRL  A,#$4D
  0139  C6 54       JZ   L_0154
  013B  F0          MOV  A,@R0
  013C  03 BF       ADD  A,#$BF
  013E  E6 13       JNC  L_0113
  0140  F0          MOV  A,@R0
  0141  03 B4       ADD  A,#$B4
  0143  E6 52       JNC  L_0152
  0145  F0          MOV  A,@R0
  0146  03 A4       ADD  A,#$A4
  0148  F6 13       JC   L_0113
  014A  F0          MOV  A,@R0
  014B  03 B2       ADD  A,#$B2
  014D  E6 13       JNC  L_0113
  014F  03 5E       ADD  A,#$5E
  0151  B3          JMPP @A
L_0152:
  0152  44 ED       JMP  L_02ED
L_0154:
  0154  27          CLR  A
  0155  B8 45       MOV  R0,#$45
  0157  A0          MOV  @R0,A
  0158  37          CPL  A
  0159  B8 52       MOV  R0,#$52
  015B  A0          MOV  @R0,A
  015C  24 13       JMP  L_0113
  015E  6C 72 78 7E 85 9E A2 A6 B1 B7 BD C0 C4 CA B8 55    db   $6C,$72,$78,$7E,$85,$9E,$A2,$A6,$B1,$B7,$BD,$C0,$C4,$CA,$B8,$55   ; lrx~...........U
  016E  B0 FF 24 13 B8 55 B0 00 24 13 B8 53 B0 FF 24 13    db   $B0,$FF,$24,$13,$B8,$55,$B0,$00,$24,$13,$B8,$53,$B0,$FF,$24,$13   ; ..$..U..$..S..$.
  017E  B8 53 B0 00 FF 24 1F B8 50 B0 FF 24 13             db   $B8,$53,$B0,$00,$FF,$24,$1F,$B8,$50,$B0,$FF,$24,$13   ; .S...$..P..$.
L_018B:
  018B  B8 50       MOV  R0,#$50
  018D  B0 00       MOV  @R0,#$00
  018F  B8 4D       MOV  R0,#$4D
  0191  F0          MOV  A,@R0
  0192  F2 98       JB7  L_0198
  0194  03 E0       ADD  A,#$E0
  0196  F6 13       JC   L_0113
L_0198:
  0198  F0          MOV  A,@R0
  0199  B8 4F       MOV  R0,#$4F
  019B  A0          MOV  @R0,A
  019C  24 AA       JMP  L_01AA
  019E  23 FE 24 B3 23 01 24 AD B8 4F B0 FF                db   $23,$FE,$24,$B3,$23,$01,$24,$AD,$B8,$4F,$B0,$FF   ; #.$.#.$..O..
L_01AA:
  01AA  85          CLR  F0
  01AB  23 02       MOV  A,#$02
  01AD  4F          ORL  A,R7
  01AE  AF          MOV  R7,A
  01AF  24 13       JMP  L_0113
  01B1  23 FD 5F AF 24 13 B8 4B B0 FE 24 13 A5 24 13 A5    db   $23,$FD,$5F,$AF,$24,$13,$B8,$4B,$B0,$FE,$24,$13,$A5,$24,$13,$A5   ; #._.$..K..$..$..
  01C1  B5 24 13 89 10 23 40 24 AD 99 EF 23 BF 24 B3       db   $B5,$24,$13,$89,$10,$23,$40,$24,$AD,$99,$EF,$23,$BF,$24,$B3   ; .$...#@$...#.$.
PROC_SCAN_BYTE:  ; consumes one byte returned from the GI scanner
  01D0  F0          MOV  A,@R0
  01D1  DD          XRL  A,R5
  01D2  37          CPL  A
  01D3  AA          MOV  R2,A
  01D4  FD          MOV  A,R5
  01D5  A0          MOV  @R0,A
  01D6  D1          XRL  A,@R1
  01D7  5A          ANL  A,R2
  01D8  AA          MOV  R2,A
  01D9  B8 51       MOV  R0,#$51
  01DB  FB          MOV  A,R3
  01DC  A0          MOV  @R0,A
  01DD  FA          MOV  A,R2
  01DE  C6 F8       JZ   L_01F8
  01E0  D1          XRL  A,@R1
  01E1  A1          MOV  @R1,A
  01E2  FA          MOV  A,R2
  01E3  5D          ANL  A,R5
L_01E4:
  01E4  AA          MOV  R2,A
  01E5  C6 F6       JZ   L_01F6
  01E7  F2 EE       JB7  L_01EE
L_01E9:
  01E9  FA          MOV  A,R2
  01EA  E7          RL   A
  01EB  CB          DEC  R3
  01EC  24 E4       JMP  L_01E4
L_01EE:
  01EE  53 7F       ANL  A,#$7F
  01F0  AA          MOV  R2,A
  01F1  54 00       CALL L_0200
  01F3  D5          SEL  RB1
  01F4  24 E9       JMP  L_01E9
L_01F6:
  01F6  54 BA       CALL L_02BA
L_01F8:
  01F8  B8 51       MOV  R0,#$51
  01FA  F0          MOV  A,@R0
  01FB  03 F8       ADD  A,#$F8
  01FD  AB          MOV  R3,A
  01FE  83          RET
  01FF  FF                                                 db   $FF   ; .
L_0200:
  0200  FB          MOV  A,R3
  0201  D3 50       XRL  A,#$50
  0203  C5          SEL  RB0
  0204  C6 A8       JZ   L_02A8
  0206  B8 23       MOV  R0,#$23
  0208  F0          MOV  A,@R0
  0209  32 79       JB1  L_0279
  020B  B8 24       MOV  R0,#$24
  020D  F0          MOV  A,@R0
  020E  B2 79       JB5  L_0279
L_0210:
  0210  B8 22       MOV  R0,#$22
  0212  F0          MOV  A,@R0
  0213  32 7F       JB1  L_027F
  0215  B8 24       MOV  R0,#$24
  0217  F0          MOV  A,@R0
  0218  52 92       JB2  L_0292
  021A  F2 96       JB7  L_0296
L_021C:
  021C  FF          MOV  A,R7
  021D  D5          SEL  RB1
  021E  F2 23       JB7  L_0223
  0220  FB          MOV  A,R3
  0221  44 26       JMP  L_0226
L_0223:
  0223  FB          MOV  A,R3
  0224  03 68       ADD  A,#$68
L_0226:
  0226  E3          MOVP3 A,@A
  0227  C5          SEL  RB0
  0228  AA          MOV  R2,A
  0229  C6 3C       JZ   L_023C
  022B  F2 5F       JB7  L_025F
  022D  03 F5       ADD  A,#$F5
  022F  F6 42       JC   L_0242
  0231  FA          MOV  A,R2
  0232  D3 09       XRL  A,#$09
  0234  C6 3E       JZ   L_023E
  0236  FA          MOV  A,R2
  0237  03 DF       ADD  A,#$DF
  0239  AA          MOV  R2,A
  023A  A4 00       JMP  L_0500
L_023C:
  023C  A4 1B       JMP  L_051B
L_023E:
  023E  BA 0D       MOV  R2,#$0D
  0240  A4 0D       JMP  L_050D
L_0242:
  0242  FA          MOV  A,R2
  0243  03 E0       ADD  A,#$E0
  0245  F6 67       JC   L_0267
  0247  FF          MOV  A,R7
  0248  F2 59       JB7  L_0259
  024A  B8 55       MOV  R0,#$55
  024C  F0          MOV  A,@R0
  024D  96 55       JNZ  L_0255
L_024F:
  024F  23 26       MOV  A,#$26
L_0251:
  0251  6A          ADD  A,R2
  0252  AA          MOV  R2,A
  0253  A4 00       JMP  L_0500
L_0255:
  0255  23 E6       MOV  A,#$E6
  0257  44 51       JMP  L_0251
L_0259:
  0259  12 4F       JB0  L_024F
  025B  23 96       MOV  A,#$96
  025D  44 51       JMP  L_0251
L_025F:
  025F  03 50       ADD  A,#$50
  0261  F6 69       JC   L_0269
  0263  FA          MOV  A,R2
  0264  03 30       ADD  A,#$30
  0266  AA          MOV  R2,A
L_0267:
  0267  A4 00       JMP  L_0500
L_0269:
  0269  AA          MOV  R2,A
  026A  B8 45       MOV  R0,#$45
  026C  F0          MOV  A,@R0
  026D  03 70       ADD  A,#$70
  026F  B3          JMPP @A
  0270  73 75 77 E4 9D E4 A7 E4 C4                         db   $73,$75,$77,$E4,$9D,$E4,$A7,$E4,$C4   ; suw......
L_0279:
  0279  23 80       MOV  A,#$80
  027B  4F          ORL  A,R7
  027C  AF          MOV  R7,A
  027D  44 10       JMP  L_0210
L_027F:
  027F  D5          SEL  RB1
  0280  FB          MOV  A,R3
  0281  C5          SEL  RB0
  0282  AA          MOV  R2,A
  0283  C6 9C       JZ   L_029C
  0285  D3 FF       XRL  A,#$FF
  0287  C6 A0       JZ   L_02A0
  0289  FA          MOV  A,R2
  028A  D3 1D       XRL  A,#$1D
  028C  C6 A4       JZ   L_02A4
  028E  23 20       MOV  A,#$20
  0290  44 98       JMP  L_0298
L_0292:
  0292  23 10       MOV  A,#$10
  0294  44 98       JMP  L_0298
L_0296:
  0296  23 08       MOV  A,#$08
L_0298:
  0298  4F          ORL  A,R7
  0299  AF          MOV  R7,A
  029A  44 1C       JMP  L_021C
L_029C:
  029C  BA B4       MOV  R2,#$B4
  029E  A4 0D       JMP  L_050D
L_02A0:
  02A0  BA B1       MOV  R2,#$B1
  02A2  A4 0D       JMP  L_050D
L_02A4:
  02A4  BA E8       MOV  R2,#$E8
  02A6  A4 0D       JMP  L_050D
L_02A8:
  02A8  FF          MOV  A,R7
  02A9  D3 40       XRL  A,#$40
  02AB  AF          MOV  R7,A
  02AC  D2 B4       JB6  L_02B4
  02AE  99 EF       ANL  P1,#$EF
  02B0  BA BE       MOV  R2,#$BE
  02B2  A4 0D       JMP  L_050D
L_02B4:
  02B4  89 10       ORL  P1,#$10
  02B6  BA BD       MOV  R2,#$BD
  02B8  A4 0D       JMP  L_050D
L_02BA:
  02BA  B8 44       MOV  R0,#$44
  02BC  F0          MOV  A,@R0
  02BD  53 07       ANL  A,#$07
  02BF  AA          MOV  R2,A
  02C0  F0          MOV  A,@R0
  02C1  53 F8       ANL  A,#$F8
  02C3  77          RR   A
  02C4  77          RR   A
  02C5  77          RR   A
  02C6  37          CPL  A
  02C7  03 2D       ADD  A,#$2D
  02C9  A8          MOV  R0,A
  02CA  1A          INC  R2
  02CB  23 80       MOV  A,#$80
L_02CD:
  02CD  E7          RL   A
  02CE  EA CD       DJNZ R2,L_02CD
  02D0  50          ANL  A,@R0
  02D1  96 D4       JNZ  L_02D4
  02D3  85          CLR  F0
L_02D4:
  02D4  83          RET
L_02D5:
  02D5  D5          SEL  RB1
  02D6  AE          MOV  R6,A
  02D7  C5          SEL  RB0
L_02D8:
  02D8  FB          MOV  A,R3
  02D9  17          INC  A
  02DA  53 07       ANL  A,#$07
  02DC  DC          XRL  A,R4
  02DD  C6 D8       JZ   L_02D8
  02DF  FB          MOV  A,R3
  02E0  03 60       ADD  A,#$60
  02E2  A8          MOV  R0,A
  02E3  D5          SEL  RB1
  02E4  FE          MOV  A,R6
  02E5  C5          SEL  RB0
  02E6  A0          MOV  @R0,A
  02E7  1B          INC  R3
  02E8  FB          MOV  A,R3
  02E9  53 07       ANL  A,#$07
  02EB  AB          MOV  R3,A
  02EC  83          RET
L_02ED:
  02ED  F0          MOV  A,@R0
  02EE  03 B7       ADD  A,#$B7
  02F0  E6 F7       JNC  L_02F7
  02F2  B8 45       MOV  R0,#$45
  02F4  A0          MOV  @R0,A
  02F5  24 13       JMP  L_0113
L_02F7:
  02F7  F0          MOV  A,@R0
  02F8  03 BF       ADD  A,#$BF
  02FA  B8 46       MOV  R0,#$46
  02FC  A0          MOV  @R0,A
  02FD  24 13       JMP  L_0113
  02FF  FF 82 98 97 96 F8 F9 9C 00 99 13 12 11 9D 90 9B    db   $FF,$82,$98,$97,$96,$F8,$F9,$9C,$00,$99,$13,$12,$11,$9D,$90,$9B   ; ................
  030F  00 81 10 0F 0E 94 01 03 00 09 0D 0C 0B 04 05 BA    db   $00,$81,$10,$0F,$0E,$94,$01,$03,$00,$09,$0D,$0C,$0B,$04,$05,$BA   ; ................
  031F  00 00 B6 B4 B5 9F 02 95 00 DD DE DF C8 D0 C6 C0    db   $00,$00,$B6,$B4,$B5,$9F,$02,$95,$00,$DD,$DE,$DF,$C8,$D0,$C6,$C0   ; ................
  032F  FA 69 6F 70 C9 BE B8 92 93 6A 6B 6C CA CB C4 B9    db   $FA,$69,$6F,$70,$C9,$BE,$B8,$92,$93,$6A,$6B,$6C,$CA,$CB,$C4,$B9   ; .iop.....jkl....
  033F  9E E0 E1 00 E2 CC 00 20 00 BD 00 D8 78 63 76 62    db   $9E,$E0,$E1,$00,$E2,$CC,$00,$20,$00,$BD,$00,$D8,$78,$63,$76,$62   ; ....... ....xcvb
  034F  6E 00 00 E3 73 64 66 67 68 BB E4 E5 65 72 74 D9    db   $6E,$00,$00,$E3,$73,$64,$66,$67,$68,$BB,$E4,$E5,$65,$72,$74,$D9   ; n...sdfgh...ert.
  035F  75 C1 E6 E7 E8 E9 EA EB EC 83 98 97 96 FB F9 9C    db   $75,$C1,$E6,$E7,$E8,$E9,$EA,$EB,$EC,$83,$98,$97,$96,$FB,$F9,$9C   ; u...............
  036F  00 99 13 12 11 9D 90 9B 00 81 10 0F 0E 94 87 89    db   $00,$99,$13,$12,$11,$9D,$90,$9B,$00,$81,$10,$0F,$0E,$94,$87,$89   ; ................
  037F  00 08 0D 0C 0B 8A 0A FC 00 00 B1 B2 B3 9F 88 95    db   $00,$08,$0D,$0C,$0B,$8A,$0A,$FC,$00,$00,$B1,$B2,$B3,$9F,$88,$95   ; ................
  038F  00 ED EE CD CE CF C7 C2 FD 49 4F 50 D1 BF B8 92    db   $00,$ED,$EE,$CD,$CE,$CF,$C7,$C2,$FD,$49,$4F,$50,$D1,$BF,$B8,$92   ; .........IOP....
  039F  93 4A 4B 4C D2 D3 C5 B9 9E EF D4 00 D5 D6 00 20    db   $93,$4A,$4B,$4C,$D2,$D3,$C5,$B9,$9E,$EF,$D4,$00,$D5,$D6,$00,$20   ; .JKL........... 
  03AF  00 BD 00 DA 58 43 56 42 4E 00 00 F0 53 44 46 47    db   $00,$BD,$00,$DA,$58,$43,$56,$42,$4E,$00,$00,$F0,$53,$44,$46,$47   ; ....XCVBN...SDFG
  03BF  48 BC F1 F2 45 52 54 DB 55 C3 F3 F4 DC F5 F6 F7    db   $48,$BC,$F1,$F2,$45,$52,$54,$DB,$55,$C3,$F3,$F4,$DC,$F5,$F6,$F7   ; H...ERT.U.......
  03CF  D7 E5 E5 5C EA 7C EF E5 E5 3C EA 3E EF 60 40 2B    db   $D7,$E5,$E5,$5C,$EA,$7C,$EF,$E5,$E5,$3C,$EA,$3E,$EF,$60,$40,$2B   ; ...\.|...<.>.`@+
  03DF  2A 27 7D 7C 7B 2D 3D 3F 5E 7E 5D 5C 5B 3B 3A 5F    db   $2A,$27,$7D,$7C,$7B,$2D,$3D,$3F,$5E,$7E,$5D,$5C,$5B,$3B,$3A,$5F   ; *'}|{-=?^~]\[;:_
  03EF  2F A0 AB A0 AA F0 FA FB F0 B5 C2 C0 B6 C3 C1 FF    db   $2F,$A0,$AB,$A0,$AA,$F0,$FA,$FB,$F0,$B5,$C2,$C0,$B6,$C3,$C1,$FF   ; /...............
  03FF  FF FA 03 F2 E6 17 B8 46 F0 03 0B B3 17 19 27 35    db   $FF,$FA,$03,$F2,$E6,$17,$B8,$46,$F0,$03,$0B,$B3,$17,$19,$27,$35   ; .......F......'5
  040F  45 13 55 15 E4 63 E4 55 E4 00 FA 03 EC F6 17 FA    db   $45,$13,$55,$15,$E4,$63,$E4,$55,$E4,$00,$FA,$03,$EC,$F6,$17,$FA   ; E.U..c.U........
  041F  03 F2 03 D0 E3 AA A4 00 FA 03 B8 F6 17 FA 03 F2    db   $03,$F2,$03,$D0,$E3,$AA,$A4,$00,$FA,$03,$B8,$F6,$17,$FA,$03,$F2   ; ................
  042F  03 70 A3 AA A4 00 FA 03 D3 F6 17 FA 03 F2 03 AA    db   $03,$70,$A3,$AA,$A4,$00,$FA,$03,$D3,$F6,$17,$FA,$03,$F2,$03,$AA   ; .p..............
  043F  A3 AA B4 52 A4 00 FA 03 D8 F6 17 FA 03 F2 03 C9    db   $A3,$AA,$B4,$52,$A4,$00,$FA,$03,$D8,$F6,$17,$FA,$03,$F2,$03,$C9   ; ...R............
  044F  A3 AA F4 8D A4 00 FA 03 D8 F6 17 FA 03 F2 03 E3    db   $A3,$AA,$F4,$8D,$A4,$00,$FA,$03,$D8,$F6,$17,$FA,$03,$F2,$03,$E3   ; ................
  045F  A3 AA FF D2 66 A4 00 FA D3 7C 96 6E 23 5C AA A4    db   $A3,$AA,$FF,$D2,$66,$A4,$00,$FA,$D3,$7C,$96,$6E,$23,$5C,$AA,$A4   ; ....f....|.n#\..
  046F  00 E5 E5 EA 60 EF 2A 24 23 3C 3E 29 5E 6D 7C 3D    db   $00,$E5,$E5,$EA,$60,$EF,$2A,$24,$23,$3C,$3E,$29,$5E,$6D,$7C,$3D   ; ....`.*$#<>)^m|=
  047F  30 5B 5F 2D 7E 4D 25 2E 2F 2B 37 77 79 57 59 33    db   $30,$5B,$5F,$2D,$7E,$4D,$25,$2E,$2F,$2B,$37,$77,$79,$57,$59,$33   ; 0[_-~M%./+7wyWY3
  048F  21 5C 40 2C 3B 3A 71 61 7A 26 7B 22 27 28 5D 7D    db   $21,$5C,$40,$2C,$3B,$3A,$71,$61,$7A,$26,$7B,$22,$27,$28,$5D,$7D   ; !\@,;:qaz&{"'(]}
  049F  38 39 3F 51 41 5A 31 32 34 35 36 2B 2A E5 EA E5    db   $38,$39,$3F,$51,$41,$5A,$31,$32,$34,$35,$36,$2B,$2A,$E5,$EA,$E5   ; 89?QAZ12456+*...
  04AF  EF 23 5E 3C 3E 7E 7D 7C 7B 2D 3D 3F 60 27 5D 5C    db   $EF,$23,$5E,$3C,$3E,$7E,$7D,$7C,$7B,$2D,$3D,$3F,$60,$27,$5D,$5C   ; .#^<>~}|{-=?`']\
  04BF  5B 3B 3A 5F 2F 79 7A 59 5A 40 7E 5E E5 EA E5 EF    db   $5B,$3B,$3A,$5F,$2F,$79,$7A,$59,$5A,$40,$7E,$5E,$E5,$EA,$E5,$EF   ; [;:_/yzYZ@~^....
  04CF  27 2A 3C 3E 2B 7D 7C 7B 2D 3D 3F 40 60 5D 5C 5B    db   $27,$2A,$3C,$3E,$2B,$7D,$7C,$7B,$2D,$3D,$3F,$40,$60,$5D,$5C,$5B   ; '*<>+}|{-=?@`]\[
  04DF  3B 3A 5F 2F E5 E5 3C EA 3E EF 7D 5D 40 60 27 2B    db   $3B,$3A,$5F,$2F,$E5,$E5,$3C,$EA,$3E,$EF,$7D,$5D,$40,$60,$27,$2B   ; ;:_/..<.>.}]@`'+
  04EF  7C 7B 2D 3D 3F 7E 5E 2A 5C 5B 3B 3A 5F 2F FF FF    db   $7C,$7B,$2D,$3D,$3F,$7E,$5E,$2A,$5C,$5B,$3B,$3A,$5F,$2F,$FF,$FF   ; |{-=?~^*\[;:_/..
  04FF  FF                                                 db   $FF   ; .
L_0500:
  0500  FA          MOV  A,R2
  0501  C6 1B       JZ   L_051B
  0503  FF          MOV  A,R7
  0504  D2 4B       JB6  L_054B
L_0506:
  0506  B2 65       JB5  L_0565
  0508  FF          MOV  A,R7
  0509  92 A3       JB4  L_05A3
  050B  72 A3       JB3  L_05A3
L_050D:
  050D  FF          MOV  A,R7
  050E  32 20       JB1  L_0520
  0510  FA          MOV  A,R2
  0511  54 D5       CALL L_02D5
  0513  B4 BC       CALL L_05BC
L_0515:
  0515  76 1B       JF1  L_051B
  0517  B8 49       MOV  R0,#$49
  0519  B0 DF       MOV  @R0,#$DF
L_051B:
  051B  FF          MOV  A,R7
  051C  53 47       ANL  A,#$47
  051E  AF          MOV  R7,A
  051F  83          RET
L_0520:
  0520  FA          MOV  A,R2
  0521  D3 B0       XRL  A,#$B0
  0523  C6 3A       JZ   L_053A
  0525  FA          MOV  A,R2
  0526  F2 1B       JB7  L_051B
  0528  D3 1B       XRL  A,#$1B
  052A  C6 3F       JZ   L_053F
  052C  B8 4E       MOV  R0,#$4E
  052E  F0          MOV  A,@R0
  052F  4A          ORL  A,R2
  0530  B0 00       MOV  @R0,#$00
  0532  B8 4F       MOV  R0,#$4F
  0534  D0          XRL  A,@R0
  0535  96 1B       JNZ  L_051B
  0537  F0          MOV  A,@R0
  0538  F2 45       JB7  L_0545
L_053A:
  053A  FA          MOV  A,R2
  053B  54 D5       CALL L_02D5
  053D  A4 15       JMP  L_0515
L_053F:
  053F  B8 4E       MOV  R0,#$4E
  0541  B0 80       MOV  @R0,#$80
  0543  A4 1B       JMP  L_051B
L_0545:
  0545  23 1B       MOV  A,#$1B
  0547  54 D5       CALL L_02D5
  0549  A4 3A       JMP  L_053A
L_054B:
  054B  23 85       MOV  A,#$85
  054D  B4 58       CALL L_0558
  054F  FF          MOV  A,R7
  0550  A4 06       JMP  L_0506
  0552  FF D2 56 83 23 82                                  db   $FF,$D2,$56,$83,$23,$82   ; ..V.#.
L_0558:
  0558  6A          ADD  A,R2
  0559  F6 64       JC   L_0564
  055B  FA          MOV  A,R2
  055C  03 9F       ADD  A,#$9F
  055E  E6 64       JNC  L_0564
  0560  FA          MOV  A,R2
  0561  53 DF       ANL  A,#$DF
  0563  AA          MOV  R2,A
L_0564:
  0564  83          RET
L_0565:
  0565  FA          MOV  A,R2
  0566  03 C0       ADD  A,#$C0
  0568  E6 75       JNC  L_0575
  056A  FA          MOV  A,R2
  056B  03 85       ADD  A,#$85
  056D  F6 75       JC   L_0575
  056F  FA          MOV  A,R2
  0570  53 1F       ANL  A,#$1F
  0572  AA          MOV  R2,A
  0573  A4 0D       JMP  L_050D
L_0575:
  0575  D5          SEL  RB1
  0576  FB          MOV  A,R3
  0577  D3 0D       XRL  A,#$0D
  0579  96 80       JNZ  L_0580
  057B  C5          SEL  RB0
  057C  BA B0       MOV  R2,#$B0
  057E  A4 0D       JMP  L_050D
L_0580:
  0580  FB          MOV  A,R3
  0581  D3 36       XRL  A,#$36
  0583  C5          SEL  RB0
  0584  96 8A       JNZ  L_058A
  0586  BA BF       MOV  R2,#$BF
  0588  A4 0D       JMP  L_050D
L_058A:
  058A  FA          MOV  A,R2
  058B  D3 31       XRL  A,#$31
  058D  96 93       JNZ  L_0593
  058F  BA BB       MOV  R2,#$BB
  0591  A4 0D       JMP  L_050D
L_0593:
  0593  FA          MOV  A,R2
  0594  D3 32       XRL  A,#$32
  0596  96 9C       JNZ  L_059C
  0598  BA BC       MOV  R2,#$BC
  059A  A4 0D       JMP  L_050D
L_059C:
  059C  FA          MOV  A,R2
  059D  03 E0       ADD  A,#$E0
  059F  E6 0D       JNC  L_050D
  05A1  C4 E2       JMP  L_06E2
L_05A3:
  05A3  FA          MOV  A,R2
  05A4  03 D0       ADD  A,#$D0
  05A6  E6 1B       JNC  L_051B
  05A8  FA          MOV  A,R2
  05A9  03 C6       ADD  A,#$C6
  05AB  F6 1B       JC   L_051B
  05AD  FF          MOV  A,R7
  05AE  72 B6       JB3  L_05B6
  05B0  FA          MOV  A,R2
  05B1  03 50       ADD  A,#$50
  05B3  AA          MOV  R2,A
  05B4  A4 0D       JMP  L_050D
L_05B6:
  05B6  FA          MOV  A,R2
  05B7  03 5A       ADD  A,#$5A
  05B9  AA          MOV  R2,A
  05BA  A4 0D       JMP  L_050D
L_05BC:
  05BC  FA          MOV  A,R2
  05BD  03 50       ADD  A,#$50
  05BF  F6 D4       JC   L_05D4
L_05C1:
  05C1  85          CLR  F0
  05C2  FA          MOV  A,R2
  05C3  AE          MOV  R6,A
  05C4  D5          SEL  RB1
  05C5  FB          MOV  A,R3
  05C6  C5          SEL  RB0
  05C7  B8 44       MOV  R0,#$44
  05C9  A0          MOV  @R0,A
  05CA  B8 42       MOV  R0,#$42
  05CC  B0 2E       MOV  @R0,#$2E
  05CE  B8 43       MOV  R0,#$43
  05D0  B0 F8       MOV  @R0,#$F8
  05D2  95          CPL  F0
  05D3  83          RET
L_05D4:
  05D4  FA          MOV  A,R2
  05D5  03 2F       ADD  A,#$2F
  05D7  E6 E3       JNC  L_05E3
  05D9  FA          MOV  A,R2
  05DA  03 2B       ADD  A,#$2B
  05DC  E6 C1       JNC  L_05C1
  05DE  FA          MOV  A,R2
  05DF  03 21       ADD  A,#$21
  05E1  F6 C1       JC   L_05C1
L_05E3:
  05E3  FA          MOV  A,R2
  05E4  D3 B1       XRL  A,#$B1
  05E6  C6 C1       JZ   L_05C1
  05E8  FA          MOV  A,R2
  05E9  D3 B7       XRL  A,#$B7
  05EB  C6 C1       JZ   L_05C1
  05ED  FA          MOV  A,R2
  05EE  D3 B8       XRL  A,#$B8
  05F0  C6 C1       JZ   L_05C1
  05F2  85          CLR  F0
  05F3  83          RET
  05F4  FF FF FF FF FF FF FF FF FF FF FF FF FA 03 F2 E6    db   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FA,$03,$F2,$E6   ; ................
  0604  21 B8 46 F0 C6 21 FA 03 E8 F6 17 FA 03 F2 AA F0    db   $21,$B8,$46,$F0,$C6,$21,$FA,$03,$E8,$F6,$17,$FA,$03,$F2,$AA,$F0   ; !.F..!..........
  0614  03 19 B3 84 00 21 73 77 7E 8B 82 94 98 23 25 C4    db   $03,$19,$B3,$84,$00,$21,$73,$77,$7E,$8B,$82,$94,$98,$23,$25,$C4   ; .....!sw~....#%.
  0624  79 2D 2E 00 30 00 30 2E 2D E5 00 EA D1 D1 D2 5D    db   $79,$2D,$2E,$00,$30,$00,$30,$2E,$2D,$E5,$00,$EA,$D1,$D1,$D2,$5D   ; y-..0.0.-......]
  0634  7D 5C D0 7C CA 0D 0D 60 7E 2D 5B 3B 27 2F 29 5F    db   $7D,$5C,$D0,$7C,$CA,$0D,$0D,$60,$7E,$2D,$5B,$3B,$27,$2F,$29,$5F   ; }\.|...`~-[;'/)_
  0644  2B 3D 7B 3A 22 3C 3E 3F 26 7A 79 5A 59 23 38 39    db   $2B,$3D,$7B,$3A,$22,$3C,$3E,$3F,$26,$7A,$79,$5A,$59,$23,$38,$39   ; +={:"<>?&zyZY#89
  0654  30 6D 2C 2E 61 71 77 31 32 33 34 35 36 37 2A 28    db   $30,$6D,$2C,$2E,$61,$71,$77,$31,$32,$33,$34,$35,$36,$37,$2A,$28   ; 0m,.aqw1234567*(
  0664  4D 41 51 57 21 40 24 25 5E C1 D3 D4 C1 EF D4 23    db   $4D,$41,$51,$57,$21,$40,$24,$25,$5E,$C1,$D3,$D4,$C1,$EF,$D4,$23   ; MAQW!@$%^......#
  0674  9C C4 79 23 A6 6A A3 AA A4 00 23 B0 C4 84 23 C4    db   $9C,$C4,$79,$23,$A6,$6A,$A3,$AA,$A4,$00,$23,$B0,$C4,$84,$23,$C4   ; ..y#.j....#...#.
  0684  6A A3 AA B4 52 A4 00 FA 03 BA A3 AA F4 8D A4 00    db   $6A,$A3,$AA,$B4,$52,$A4,$00,$FA,$03,$BA,$A3,$AA,$F4,$8D,$A4,$00   ; j...R...........
  0694  23 CE C4 79 23 D8 C4 79 5D 7D 5C D0 7C CA 0D 0D    db   $23,$CE,$C4,$79,$23,$D8,$C4,$79,$5D,$7D,$5C,$D0,$7C,$CA,$0D,$0D   ; #..y#..y]}\.|...
  06A4  40 60 24 23 60 D0 2A CA 0D 0D 3C 3E 23 5E 3C D0    db   $40,$60,$24,$23,$60,$D0,$2A,$CA,$0D,$0D,$3C,$3E,$23,$5E,$3C,$D0   ; @`$#`.*...<>#^<.
  06B4  3E CA 0D 0D 2B 2A 7E 5E 27 D0 2A CA 0D 0D 3C 3E    db   $3E,$CA,$0D,$0D,$2B,$2A,$7E,$5E,$27,$D0,$2A,$CA,$0D,$0D,$3C,$3E   ; >...+*~^'.*...<>
  06C4  60 2A 3C D0 3E CA 0D 0D 7E 5E 7D 5D 3C D0 3E CA    db   $60,$2A,$3C,$D0,$3E,$CA,$0D,$0D,$7E,$5E,$7D,$5D,$3C,$D0,$3E,$CA   ; `*<.>...~^}]<.>.
  06D4  0D 0D 40 60 60 40 3C D0 3E CA 0D 0D 2B 2A          db   $0D,$0D,$40,$60,$60,$40,$3C,$D0,$3E,$CA,$0D,$0D,$2B,$2A   ; ..@``@<.>...+*
L_06E2:
  06E2  FA          MOV  A,R2
  06E3  03 1C       ADD  A,#$1C
  06E5  F6 F0       JC   L_06F0
  06E7  03 1A       ADD  A,#$1A
  06E9  E6 F0       JNC  L_06F0
  06EB  03 D5       ADD  A,#$D5
  06ED  AA          MOV  R2,A
  06EE  A4 0D       JMP  L_050D
L_06F0:
  06F0  A4 1B       JMP  L_051B
  06F2  FF FF FF FF FF FF FF FF FF FF FF FF FF FF FA 03    db   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FA,$03   ; ................
  0702  07 A3 AA A4 00 2D 2E 30 2C 30 2C 2E 2D 0D D2 D1    db   $07,$A3,$AA,$A4,$00,$2D,$2E,$30,$2C,$30,$2C,$2E,$2D,$0D,$D2,$D1   ; .....-.0,0,.-...
  0712  D0 CA 00 E5 E5 EA 5C EF 7C 5D 7D 40 60 3A 5E 3B    db   $D0,$CA,$00,$E5,$E5,$EA,$5C,$EF,$7C,$5D,$7D,$40,$60,$3A,$5E,$3B   ; ......\.|]}@`:^;
  0722  5B 2F 5F 2A 3D 2D 7E 2B 7B 3C 3E 3F 27 7A 79 5A    db   $5B,$2F,$5F,$2A,$3D,$2D,$7E,$2B,$7B,$3C,$3E,$3F,$27,$7A,$79,$5A   ; [/_*=-~+{<>?'zyZ
  0732  59 23 38 39 30 6D 2C 2E 61 71 77 31 32 33 34 35    db   $59,$23,$38,$39,$30,$6D,$2C,$2E,$61,$71,$77,$31,$32,$33,$34,$35   ; Y#890m,.aqw12345
  0742  36 37 28 29 4D 41 51 57 21 22 24 25 26 C1 D3 D4    db   $36,$37,$28,$29,$4D,$41,$51,$57,$21,$22,$24,$25,$26,$C1,$D3,$D4   ; 67()MAQW!"$%&...
  0752  C1 EF D4 FA 03 D8 F6 00 FA 03 F2 03 D6 E3 AA A4    db   $C1,$EF,$D4,$FA,$03,$D8,$F6,$00,$FA,$03,$F2,$03,$D6,$E3,$AA,$A4   ; ................
  0762  00 FA 03 D8 F6 00 FA 03 F2 03 73 A3 AA B4 52 A4    db   $00,$FA,$03,$D8,$F6,$00,$FA,$03,$F2,$03,$73,$A3,$AA,$B4,$52,$A4   ; ..........s...R.
  0772  00 E5 E5 3C EA 3E EF 60 2A 7E 5E 2B 7D 7C 7B 2D    db   $00,$E5,$E5,$3C,$EA,$3E,$EF,$60,$2A,$7E,$5E,$2B,$7D,$7C,$7B,$2D   ; ...<.>.`*~^+}|{-
  0782  3D 3F 27 40 5D 5C 5B 3B 3A 5F 2F FF D2 91 83 23    db   $3D,$3F,$27,$40,$5D,$5C,$5B,$3B,$3A,$5F,$2F,$FF,$D2,$91,$83,$23   ; =?'@]\[;:_/....#
  0792  81 6A F6 90 FA 03 A0 E6 90 A4 60 FA 03 B8 F6 DA    db   $81,$6A,$F6,$90,$FA,$03,$A0,$E6,$90,$A4,$60,$FA,$03,$B8,$F6,$DA   ; .j........`.....
  07A2  B8 52 F0 96 C4 FA C6 C0 03 FC F6 B4 FF 12 B6 FA    db   $B8,$52,$F0,$96,$C4,$FA,$C6,$C0,$03,$FC,$F6,$B4,$FF,$12,$B6,$FA   ; .R..............
  07B2  E4 E1 FA 03 F9 F6 BE B8 55 F0 96 B1 84 00 BA 9F    db   $E4,$E1,$FA,$03,$F9,$F6,$BE,$B8,$55,$F0,$96,$B1,$84,$00,$BA,$9F   ; ........U.......
  07C2  A4 0D FA 03 FC F6 CE FF 12 D8 E4 B1 FA 03 F8 F6    db   $A4,$0D,$FA,$03,$FC,$F6,$CE,$FF,$12,$D8,$E4,$B1,$FA,$03,$F8,$F6   ; ................
  07D2  D8 B8 55 F0 96 B1 C4 00 AA FF B2 E7 FA 03 08 03    db   $D8,$B8,$55,$F0,$96,$B1,$C4,$00,$AA,$FF,$B2,$E7,$FA,$03,$08,$03   ; ..U.............
  07E2  F0 E3 AA A4 0D D5 FB D3 2F 96 F2 C5 BA B0 A4 0D    db   $F0,$E3,$AA,$A4,$0D,$D5,$FB,$D3,$2F,$96,$F2,$C5,$BA,$B0,$A4,$0D   ; ......../.......
  07F2  FB D3 05 C5 96 DE BA BF A4 0D FF FF FF FF          db   $FB,$D3,$05,$C5,$96,$DE,$BA,$BF,$A4,$0D,$FF,$FF,$FF,$FF   ; ..............
