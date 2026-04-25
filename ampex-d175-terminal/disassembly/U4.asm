; z80dasm 1.1.6
; command line: z80dasm -a -l -t -z -g 0x0000 -S U4.sym -o U4.asm ../EPROM_dumps/U4-TMS2764JL.bin

	org	00000h
rst08_handler:	equ 0x0008
rst20_handler:	equ 0x0020
patch_ptrs_emul_9_10:	equ 0x0441
main_entry_in_u5:	equ 0x243d
esc_state_machine:	equ 0x4a10
io_uart_primary:	equ 0x8001
ram_local_ring:	equ 0xa800
ram_tx_queue:	equ 0xa900
ram_rx_queue:	equ 0xa930
ram_local_tail:	equ 0xa944
ram_local_head:	equ 0xa945
ram_tx_tail:	equ 0xa946
ram_rx_head:	equ 0xa948
ram_rx_tail:	equ 0xa949
ram_kb_head:	equ 0xa94a
ram_kb_tail:	equ 0xa94b
ram_xlate_table:	equ 0xa983
ram_esc_byte:	equ 0xaa23
ram_esc_state:	equ 0xaa25
ram_mode_flags:	equ 0xaa29
ram_leadin_byte:	equ 0xaa99
ram_setup_flags_b9:	equ 0xaab9
ram_setup_emul_bb:	equ 0xaabb
ram_displaymode:	equ 0xabd0

reset_vector:
	di			;0000	f3 	. 
l0001h:
	im 1		;0001	ed 56 	. V 
	ld ix,03030h		;0003	dd 21 30 30 	. ! 0 0 
	ld de,03030h		;0007	11 30 30 	. 0 0 
l000ah:
	xor a			;000a	af 	. 
cold_start_jp:
	jp main_entry_in_u5		;000b	c3 3d 24 	. = $ 
l000eh:
	nop			;000e	00 	. 
l000fh:
	nop			;000f	00 	. 
rst10_handler:
	push hl			;0010	e5 	. 
	call crtc_write_cursor		;0011	cd 68 17 	. h . 
l0014h:
	pop hl			;0014	e1 	. 
	ret			;0015	c9 	. 
	jr nc,l0048h		;0016	30 30 	0 0 
rst18_handler:
	jp l1552h		;0018	c3 52 15 	. R . 
	jr nc,50		;001b	30 30 	0 0 
l001dh:
	jr nc,50		;001d	30 30 	0 0 
l001fh:
	jr nc,-57		;001f	30 c5 	0 . 
	call sub_1592h		;0021	cd 92 15 	. . . 
	pop bc			;0024	c1 	. 
	ret			;0025	c9 	. 
	jr nc,50		;0026	30 30 	0 0 
rst28_handler:
	push bc			;0028	c5 	. 
	call ring_get_next		;0029	cd 9c 15 	. . . 
	pop bc			;002c	c1 	. 
	ret			;002d	c9 	. 
	rst 38h			;002e	ff 	. 
	rst 38h			;002f	ff 	. 
rst30_handler:
	jp l0117h		;0030	c3 17 01 	. . . 
	jr nc,l0065h		;0033	30 30 	0 0 
	jr nc,50		;0035	30 30 	0 0 
	jr nc,l000eh		;0037	30 d5 	0 . 
	push bc			;0039	c5 	. 
l003ah:
	push hl			;003a	e5 	. 
	push af			;003b	f5 	. 
	ld a,(io_uart_primary)		;003c	3a 01 80 	: . . 
	ld c,a			;003f	4f 	O 
	and 002h		;0040	e6 02 	. . 
	jr z,l004eh		;0042	28 0a 	( . 
	call uart_rx_isr_body		;0044	cd 87 13 	. . . 
l0047h:
	pop af			;0047	f1 	. 
l0048h:
	pop hl			;0048	e1 	. 
l0049h:
	pop bc			;0049	c1 	. 
	pop de			;004a	d1 	. 
	ei			;004b	fb 	. 
	reti		;004c	ed 4d 	. M 
l004eh:
	ld a,(09001h)		;004e	3a 01 90 	: . . 
	bit 1,a		;0051	cb 4f 	. O 
	ld d,a			;0053	57 	W 
	jr z,l0069h		;0054	28 13 	( . 
	jp l140ah		;0056	c3 0a 14 	. . . 
l0059h:
	ld a,(io_uart_primary)		;0059	3a 01 80 	: . . 
	and 004h		;005c	e6 04 	. . 
	di			;005e	f3 	. 
	push bc			;005f	c5 	. 
l0060h:
	call nz,sub_148fh		;0060	c4 8f 14 	. . . 
	pop bc			;0063	c1 	. 
	ei			;0064	fb 	. 
l0065h:
	ret			;0065	c9 	. 
nmi_vector:
	jp 047b7h		;0066	c3 b7 47 	. . G 
l0069h:
	bit 0,c		;0069	cb 41 	. A 
	call nz,sub_148fh		;006b	c4 8f 14 	. . . 
	bit 2,d		;006e	cb 52 	. R 
	jr nz,l007ah		;0070	20 08 	  . 
	ld a,(0ac47h)		;0072	3a 47 ac 	: G . 
	and a			;0075	a7 	. 
	jr nz,l007fh		;0076	20 07 	  . 
	bit 0,d		;0078	cb 42 	. B 
l007ah:
	call nz,sub_14e2h		;007a	c4 e2 14 	. . . 
	jr l0047h		;007d	18 c8 	. . 
l007fh:
	call sub_1524h		;007f	cd 24 15 	. $ . 
	jr l0047h		;0082	18 c3 	. . 
sub_0084h:
	ld hl,0aa8ch		;0084	21 8c aa 	! . . 
	bit 2,(hl)		;0087	cb 56 	. V 
	ret nz			;0089	c0 	. 
l008ah:
	ld hl,0aa8ch		;008a	21 8c aa 	! . . 
	bit 7,(hl)		;008d	cb 7e 	. ~ 
	ret z			;008f	c8 	. 
	set 2,(hl)		;0090	cb d6 	. . 
	res 3,(hl)		;0092	cb 9e 	. . 
	ld c,011h		;0094	0e 11 	. . 
	rst 18h			;0096	df 	. 
	ret			;0097	c9 	. 
	ld a,(0aab8h)		;0098	3a b8 aa 	: . . 
	bit 0,a		;009b	cb 47 	. G 
	ld hl,l0bb9h		;009d	21 b9 0b 	! . . 
	jr nz,l00a5h		;00a0	20 03 	  . 
	ld hl,l0e0fh		;00a2	21 0f 0e 	! . . 
l00a5h:
	ld de,(0ac45h)		;00a5	ed 5b 45 ac 	. [ E . 
	and a			;00a9	a7 	. 
	sbc hl,de		;00aa	ed 52 	. R 
	jr z,l00b4h		;00ac	28 06 	( . 
	inc de			;00ae	13 	. 
	ld (0ac45h),de		;00af	ed 53 45 ac 	. S E . 
	ret			;00b3	c9 	. 
l00b4h:
	ld (0ac45h),hl		;00b4	22 45 ac 	" E . 
	ld hl,0abf6h		;00b7	21 f6 ab 	! . . 
	inc (hl)			;00ba	34 	4 
	ld hl,0aaa9h		;00bb	21 a9 aa 	! . . 
	ld a,039h		;00be	3e 39 	> 9 
	call sub_00e2h		;00c0	cd e2 00 	. . . 
	ret nc			;00c3	d0 	. 
	ld a,035h		;00c4	3e 35 	> 5 
	call sub_00e2h		;00c6	cd e2 00 	. . . 
	ret nc			;00c9	d0 	. 
	ld a,039h		;00ca	3e 39 	> 9 
	call sub_00e2h		;00cc	cd e2 00 	. . . 
	jr nc,l00d3h		;00cf	30 02 	0 . 
	inc (hl)			;00d1	34 	4 
	ret			;00d2	c9 	. 
l00d3h:
	ld a,034h		;00d3	3e 34 	> 4 
	cp (hl)			;00d5	be 	. 
	ret nz			;00d6	c0 	. 
	dec hl			;00d7	2b 	+ 
	ld a,032h		;00d8	3e 32 	> 2 
	cp (hl)			;00da	be 	. 
	ret nz			;00db	c0 	. 
	ld (hl),030h		;00dc	36 30 	6 0 
	inc hl			;00de	23 	# 
	ld (hl),030h		;00df	36 30 	6 0 
	ret			;00e1	c9 	. 
sub_00e2h:
	inc (hl)			;00e2	34 	4 
	cp (hl)			;00e3	be 	. 
	ret nc			;00e4	d0 	. 
	push af			;00e5	f5 	. 
	ld (hl),030h		;00e6	36 30 	6 0 
	dec hl			;00e8	2b 	+ 
	pop af			;00e9	f1 	. 
	ret			;00ea	c9 	. 
	ld hl,00714h		;00eb	21 14 07 	! . . 
	rst 20h			;00ee	e7 	. 
	jr z,l00f7h		;00ef	28 06 	( . 
	ld a,(ram_displaymode)		;00f1	3a d0 ab 	: . . 
	and 004h		;00f4	e6 04 	. . 
	ret z			;00f6	c8 	. 
l00f7h:
	ld hl,0ac48h		;00f7	21 48 ac 	! H . 
	ld a,(hl)			;00fa	7e 	~ 
	and a			;00fb	a7 	. 
	jr z,l0100h		;00fc	28 02 	( . 
	dec (hl)			;00fe	35 	5 
	ret			;00ff	c9 	. 
l0100h:
	ld a,(0aab8h)		;0100	3a b8 aa 	: . . 
	bit 0,a		;0103	cb 47 	. G 
	ld (hl),019h		;0105	36 19 	6 . 
	jr nz,l010bh		;0107	20 02 	  . 
	ld (hl),01eh		;0109	36 1e 	6 . 
l010bh:
	ld a,(0aa2eh)		;010b	3a 2e aa 	: . . 
	xor 008h		;010e	ee 08 	. . 
	ld (0aa2eh),a		;0110	32 2e aa 	2 . . 
	ld (0f000h),a		;0113	32 00 f0 	2 . . 
	ret			;0116	c9 	. 
l0117h:
	push hl			;0117	e5 	. 
	ld hl,0acfdh		;0118	21 fd ac 	! . . 
l011bh:
	ld a,(06001h)		;011b	3a 01 60 	: . ` 
	and 020h		;011e	e6 20 	.   
	or (hl)			;0120	b6 	. 
	cp 020h		;0121	fe 20 	.   
	jp nz,l011bh		;0123	c2 1b 01 	. . . 
	pop hl			;0126	e1 	. 
	ret			;0127	c9 	. 
	call sub_02c7h		;0128	cd c7 02 	. . . 
	ld a,05fh		;012b	3e 5f 	> _ 
	out (000h),a		;012d	d3 00 	. . 
	out (040h),a		;012f	d3 40 	. @ 
	out (080h),a		;0131	d3 80 	. . 
	ld a,006h		;0133	3e 06 	> . 
	out (000h),a		;0135	d3 00 	. . 
	out (040h),a		;0137	d3 40 	. @ 
	ld a,09ah		;0139	3e 9a 	> . 
	out (080h),a		;013b	d3 80 	. . 
	ld hl,io_uart_primary		;013d	21 01 80 	! . . 
	ld de,09001h		;0140	11 01 90 	. . . 
	ld a,080h		;0143	3e 80 	> . 
	ld (hl),a			;0145	77 	w 
	ld (de),a			;0146	12 	. 
	ld a,080h		;0147	3e 80 	> . 
	ld (hl),a			;0149	77 	w 
	ld (de),a			;014a	12 	. 
	ld a,040h		;014b	3e 40 	> @ 
	ld (hl),a			;014d	77 	w 
	nop			;014e	00 	. 
	ld a,06eh		;014f	3e 6e 	> n 
	ld (io_uart_primary),a		;0151	32 01 80 	2 . . 
	ld a,010h		;0154	3e 10 	> . 
	ld (io_uart_primary),a		;0156	32 01 80 	2 . . 
	ld a,040h		;0159	3e 40 	> @ 
	ld (de),a			;015b	12 	. 
	ld a,06eh		;015c	3e 6e 	> n 
	ld (09001h),a		;015e	32 01 90 	2 . . 
	ld a,030h		;0161	3e 30 	> 0 
	ld (09001h),a		;0163	32 01 90 	2 . . 
	xor a			;0166	af 	. 
	ld hl,06001h		;0167	21 01 60 	! . ` 
	ld (hl),a			;016a	77 	w 
	ld (hl),a			;016b	77 	w 
	rst 10h			;016c	d7 	. 
	ld a,028h		;016d	3e 28 	> ( 
	ld (hl),a			;016f	77 	w 
	ld a,09fh		;0170	3e 9f 	> . 
	ld (hl),a			;0172	77 	w 
	ld hl,l02bch		;0173	21 bc 02 	! . . 
	ld de,0aa8eh		;0176	11 8e aa 	. . . 
	ld bc,cold_start_jp		;0179	01 0b 00 	. . . 
	ldir		;017c	ed b0 	. . 
	ret			;017e	c9 	. 
	ld a,0ffh		;017f	3e ff 	> . 
	call sub_15d3h		;0181	cd d3 15 	. . . 
	ld a,06fh		;0184	3e 6f 	> o 
	call sub_15ddh		;0186	cd dd 15 	. . . 
	ld c,04fh		;0189	0e 4f 	. O 
	call aux_ring_enq		;018b	cd 75 14 	. u . 
	ld a,018h		;018e	3e 18 	> . 
	ld (0ac1dh),a		;0190	32 1d ac 	2 . . 
	ld b,05ch		;0193	06 5c 	. \ 
	ld a,023h		;0195	3e 23 	> # 
	ld hl,0ac6ah		;0197	21 6a ac 	! j . 
l019ah:
	ld (hl),a			;019a	77 	w 
	inc a			;019b	3c 	< 
	inc hl			;019c	23 	# 
	djnz l019ah		;019d	10 fb 	. . 
	ld a,010h		;019f	3e 10 	> . 
	ld (0aa8ah),a		;01a1	32 8a aa 	2 . . 
	ld a,020h		;01a4	3e 20 	>   
	ld (0ab2fh),a		;01a6	32 2f ab 	2 / . 
	ld a,006h		;01a9	3e 06 	> . 
	ld (0abedh),a		;01ab	32 ed ab 	2 . . 
	ret			;01ae	c9 	. 
	call sub_023dh		;01af	cd 3d 02 	. = . 
	call sub_1d55h		;01b2	cd 55 1d 	. U . 
	ld hl,0aa8ah		;01b5	21 8a aa 	! . . 
	ld a,(hl)			;01b8	7e 	~ 
	and 010h		;01b9	e6 10 	. . 
	or 0c0h		;01bb	f6 c0 	. . 
	ld (hl),a			;01bd	77 	w 
	push af			;01be	f5 	. 
	ld hl,0aab7h		;01bf	21 b7 aa 	! . . 
	ld a,(hl)			;01c2	7e 	~ 
	and 030h		;01c3	e6 30 	. 0 
	cp 020h		;01c5	fe 20 	.   
	jr nz,l01cbh		;01c7	20 02 	  . 
	res 5,(hl)		;01c9	cb ae 	. . 
l01cbh:
	ld a,018h		;01cb	3e 18 	> . 
	bit 4,(hl)		;01cd	cb 66 	. f 
	jr z,l01d3h		;01cf	28 02 	( . 
	xor 019h		;01d1	ee 19 	. . 
l01d3h:
	ld (0abc5h),a		;01d3	32 c5 ab 	2 . . 
	call sub_0d4bh		;01d6	cd 4b 0d 	. K . 
	ld hl,0ac68h		;01d9	21 68 ac 	! h . 
	ld (hl),001h		;01dc	36 01 	6 . 
	call sub_0d7bh		;01de	cd 7b 0d 	. { . 
	pop af			;01e1	f1 	. 
	ld (0aa8ah),a		;01e2	32 8a aa 	2 . . 
	rst 10h			;01e5	d7 	. 
	ld a,031h		;01e6	3e 31 	> 1 
	ld (06001h),a		;01e8	32 01 60 	2 . ` 
	ld a,(ram_mode_flags)		;01eb	3a 29 aa 	: ) . 
	and 004h		;01ee	e6 04 	. . 
	ret nz			;01f0	c0 	. 
	jp l008ah		;01f1	c3 8a 00 	. . . 
	call sub_0d4bh		;01f4	cd 4b 0d 	. K . 
	xor a			;01f7	af 	. 
	inc a			;01f8	3c 	< 
	ex af,af'			;01f9	08 	. 
	ld bc,0a951h		;01fa	01 51 a9 	. Q . 
	exx			;01fd	d9 	. 
	rst 10h			;01fe	d7 	. 
	ld bc,l007fh+1		;01ff	01 80 00 	. . . 
	ld (06002h),bc		;0202	ed 43 02 60 	. C . ` 
	ld hl,06001h		;0206	21 01 60 	! . ` 
l0209h:
	ld (hl),078h		;0209	36 78 	6 x 
	ld (hl),029h		;020b	36 29 	6 ) 
	ld a,036h		;020d	3e 36 	> 6 
	ld (09001h),a		;020f	32 01 90 	2 . . 
	ld (0ac3ch),a		;0212	32 3c ac 	2 < . 
	ld a,(0ac3bh)		;0215	3a 3b ac 	: ; . 
	ld (io_uart_primary),a		;0218	32 01 80 	2 . . 
	ld a,(io_uart_primary)		;021b	3a 01 80 	: . . 
	ld a,(08000h)		;021e	3a 00 80 	: . . 
	ld a,(09001h)		;0221	3a 01 90 	: . . 
	ld a,(09000h)		;0224	3a 00 90 	: . . 
	im 1		;0227	ed 56 	. V 
	ei			;0229	fb 	. 
	ret			;022a	c9 	. 
	ld hl,0aa8eh		;022b	21 8e aa 	! . . 
	ld a,010h		;022e	3e 10 	> . 
	ld (06001h),a		;0230	32 01 60 	2 . ` 
	ld b,00bh		;0233	06 0b 	. . 
l0235h:
	ld a,(hl)			;0235	7e 	~ 
	ld (06000h),a		;0236	32 00 60 	2 . ` 
	inc hl			;0239	23 	# 
	djnz l0235h		;023a	10 f9 	. . 
	ret			;023c	c9 	. 
sub_023dh:
	ld a,(ram_setup_emul_bb)		;023d	3a bb aa 	: . . 
	and 00fh		;0240	e6 0f 	. . 
	cp 008h		;0242	fe 08 	. . 
	jr c,l0248h		;0244	38 02 	8 . 
l0246h:
	ld a,008h		;0246	3e 08 	> . 
l0248h:
	ld hl,l0280h		;0248	21 80 02 	! . . 
	call resolve_patch_ptr		;024b	cd 1f 04 	. . . 
	ld a,e			;024e	7b 	{ 
	ld (0abf4h),a		;024f	32 f4 ab 	2 . . 
	ld a,d			;0252	7a 	z 
	ld (0abf5h),a		;0253	32 f5 ab 	2 . . 
	ld hl,l0292h		;0256	21 92 02 	! . . 
	ld de,0ad6bh		;0259	11 6b ad 	. k . 
	ld bc,l000ah		;025c	01 0a 00 	. . . 
	ldir		;025f	ed b0 	. . 
	ld a,0f8h		;0261	3e f8 	> . 
	ld (0aac4h),a		;0263	32 c4 aa 	2 . . 
	ld a,(0aa2bh)		;0266	3a 2b aa 	: + . 
	and 080h		;0269	e6 80 	. . 
	ld hl,0aabdh		;026b	21 bd aa 	! . . 
	jr z,l027dh		;026e	28 0d 	( . 
	ld a,019h		;0270	3e 19 	> . 
	ld (0aac4h),a		;0272	32 c4 aa 	2 . . 
	ld a,(0500ch)		;0275	3a 0c 50 	: . P 
	and 002h		;0278	e6 02 	. . 
	or (hl)			;027a	b6 	. 
	ld (hl),a			;027b	77 	w 
	ret			;027c	c9 	. 
l027dh:
	res 1,(hl)		;027d	cb 8e 	. . 
	ret			;027f	c9 	. 
l0280h:
	call nz,0c1cbh		;0280	c4 cb c1 	. . . 
	rl h		;0283	cb 14 	. . 
	or h			;0285	b4 	. 
	call nz,0c4cbh		;0286	c4 cb c4 	. . . 
	or h			;0289	b4 	. 
	xor l			;028a	ad 	. 
	cp h			;028b	bc 	. 
	pop bc			;028c	c1 	. 
	and c			;028d	a1 	. 
	pop bc			;028e	c1 	. 
	pop hl			;028f	e1 	. 
	cp a			;0290	bf 	. 
	cp a			;0291	bf 	. 
l0292h:
	inc e			;0292	1c 	. 
	add a,b			;0293	80 	. 
	rra			;0294	1f 	. 
	add a,b			;0295	80 	. 
	inc e			;0296	1c 	. 
	add hl,hl			;0297	29 	) 
	inc e			;0298	1c 	. 
	jr z,15		;0299	28 0d 	( . 
	nop			;029b	00 	. 
crtc_config_table:
	ld e,l			;029c	5d 	] 
	ld b,03dh		;029d	06 3d 	. = 
	ld (de),a			;029f	12 	. 
	dec a			;02a0	3d 	= 
	inc c			;02a1	0c 	. 
	dec e			;02a2	1d 	. 
	add a,e			;02a3	83 	. 
	dec e			;02a4	1d 	. 
	ld l,e			;02a5	6b 	k 
	dec a			;02a6	3d 	= 
	ld b,05dh		;02a7	06 5d 	. ] 
	ret nz			;02a9	c0 	. 
	ld e,l			;02aa	5d 	] 
	ld h,b			;02ab	60 	` 
	ld e,l			;02ac	5d 	] 
	jr nc,95		;02ad	30 5d 	0 ] 
	jr nz,95		;02af	20 5d 	  ] 
	jr 95		;02b1	18 5d 	. ] 
	djnz 95		;02b3	10 5d 	. ] 
	inc c			;02b5	0c 	. 
	ld e,l			;02b6	5d 	] 
	ex af,af'			;02b7	08 	. 
	ld e,l			;02b8	5d 	] 
	ld b,05dh		;02b9	06 5d 	. ] 
	inc bc			;02bb	03 	. 
l02bch:
	ld e,b			;02bc	58 	X 
	inc h			;02bd	24 	$ 
	dec de			;02be	1b 	. 
	defb 0fdh,098h,04fh	;illegal sequence		;02bf	fd 98 4f 	. . O 
	dec bc			;02c2	0b 	. 
	dec hl			;02c3	2b 	+ 
	nop			;02c4	00 	. 
	djnz -103		;02c5	10 97 	. . 
sub_02c7h:
	ld b,007h		;02c7	06 07 	. . 
	ld hl,0aab7h		;02c9	21 b7 aa 	! . . 
	ld de,05000h		;02cc	11 00 50 	. . P 
l02cfh:
	ld a,(de)			;02cf	1a 	. 
	rrd		;02d0	ed 67 	. g 
	inc de			;02d2	13 	. 
	ld a,(de)			;02d3	1a 	. 
	rrd		;02d4	ed 67 	. g 
	inc de			;02d6	13 	. 
	inc hl			;02d7	23 	# 
	djnz l02cfh		;02d8	10 f5 	. . 
	ret			;02da	c9 	. 
	ld hl,0aab7h		;02db	21 b7 aa 	! . . 
	ld a,(hl)			;02de	7e 	~ 
	and 007h		;02df	e6 07 	. . 
	cp 005h		;02e1	fe 05 	. . 
	jr c,l02e9h		;02e3	38 04 	8 . 
	ld a,(hl)			;02e5	7e 	~ 
	and 0f8h		;02e6	e6 f8 	. . 
	ld (hl),a			;02e8	77 	w 
l02e9h:
	call sub_04c2h		;02e9	cd c2 04 	. . . 
	ld a,010h		;02ec	3e 10 	> . 
	bit 3,c		;02ee	cb 59 	. Y 
	push af			;02f0	f5 	. 
	call z,sub_15d3h		;02f1	cc d3 15 	. . . 
	pop af			;02f4	f1 	. 
	call nz,sub_15ddh		;02f5	c4 dd 15 	. . . 
	ld hl,0aab8h		;02f8	21 b8 aa 	! . . 
	ld c,(hl)			;02fb	4e 	N 
	ld de,0aa91h		;02fc	11 91 aa 	. . . 
	ld a,028h		;02ff	3e 28 	> ( 
	bit 0,(hl)		;0301	cb 46 	. F 
	jr z,l0307h		;0303	28 02 	( . 
	ld a,0fdh		;0305	3e fd 	> . 
l0307h:
	ld (de),a			;0307	12 	. 
	ld hl,0aa8ch		;0308	21 8c aa 	! . . 
	res 7,(hl)		;030b	cb be 	. . 
	bit 3,c		;030d	cb 59 	. Y 
	jr nz,l0313h		;030f	20 02 	  . 
	set 7,(hl)		;0311	cb fe 	. . 
l0313h:
	call sub_059dh		;0313	cd 9d 05 	. . . 
	call sub_04e4h		;0316	cd e4 04 	. . . 
	call sub_0524h		;0319	cd 24 05 	. $ . 
	call sub_0516h		;031c	cd 16 05 	. . . 
	ld hl,ram_setup_flags_b9		;031f	21 b9 aa 	! . . 
	bit 3,(hl)		;0322	cb 5e 	. ^ 
	jr nz,l0331h		;0324	20 0b 	  . 
	ld b,00ah		;0326	06 0a 	. . 
	ld hl,0ab3bh		;0328	21 3b ab 	! ; . 
	ld de,05010h		;032b	11 10 50 	. . P 
	call l02cfh		;032e	cd cf 02 	. . . 
l0331h:
	call sub_0588h		;0331	cd 88 05 	. . . 
	call 04f1bh		;0334	cd 1b 4f 	. . O 
	call crtc_upper_config		;0337	cd cb 05 	. . . 
	ld a,(0aabch)		;033a	3a bc aa 	: . . 
	and 0c0h		;033d	e6 c0 	. . 
	rlca			;033f	07 	. 
	rlca			;0340	07 	. 
	ld c,a			;0341	4f 	O 
	ld b,000h		;0342	06 00 	. . 
	ld hl,l034fh		;0344	21 4f 03 	! O . 
	add hl,bc			;0347	09 	. 
	ld a,(hl)			;0348	7e 	~ 
	ld (0ad60h),a		;0349	32 60 ad 	2 ` . 
	jp l05d7h		;034c	c3 d7 05 	. . . 
l034fh:
	nop			;034f	00 	. 
	inc bc			;0350	03 	. 
	inc b			;0351	04 	. 
	dec c			;0352	0d 	. 
sub_0353h:
	call emul_table_loader		;0353	cd 81 03 	. . . 
	call 0b012h		;0356	cd 12 b0 	. . . 
	ld hl,l0500h		;0359	21 00 05 	! . . 
	rst 20h			;035c	e7 	. 
	jr z,l036eh		;035d	28 0f 	( . 
	ld a,(0aabah)		;035f	3a ba aa 	: . . 
	bit 3,a		;0362	cb 5f 	. _ 
	ret z			;0364	c8 	. 
	ld ix,0aa03h		;0365	dd 21 03 aa 	. ! . . 
	ld (ix+00ah),000h		;0369	dd 36 0a 00 	. 6 . . 
	ret			;036d	c9 	. 
l036eh:
	ld a,(0aa2bh)		;036e	3a 2b aa 	: + . 
	and 004h		;0371	e6 04 	. . 
	ret z			;0373	c8 	. 
	ld ix,ram_xlate_table		;0374	dd 21 83 a9 	. ! . . 
	ld (ix+040h),000h		;0378	dd 36 40 00 	. 6 @ . 
	ld (ix+05ah),027h		;037c	dd 36 5a 27 	. 6 Z ' 
	ret			;0380	c9 	. 
emul_table_loader:
	ld a,(ram_setup_emul_bb)		;0381	3a bb aa 	: . . 
	and 00fh		;0384	e6 0f 	. . 
	cp 007h		;0386	fe 07 	. . 
	jr z,l03bfh		;0388	28 35 	( 5 
	jr nc,l03d8h		;038a	30 4c 	0 L 
	call clear_xlate_table		;038c	cd 28 04 	. ( . 
	ld de,xlate_base_emul_0_6		;038f	11 ee 1d 	. . . 
	ex de,hl			;0392	eb 	. 
	ld bc,l0060h		;0393	01 60 00 	. ` . 
	ldir		;0396	ed b0 	. . 
	ld hl,xlate_aux_emul_0_7		;0398	21 61 1d 	! a . 
	ld de,0aa03h		;039b	11 03 aa 	. . . 
	ld bc,rst20_handler		;039e	01 20 00 	.   . 
	ldir		;03a1	ed b0 	. . 
	push af			;03a3	f5 	. 
	ld hl,patch_ptrs_emul_0_6		;03a4	21 33 04 	! 3 . 
	call resolve_patch_ptr		;03a7	cd 1f 04 	. . . 
	ld hl,ram_xlate_table		;03aa	21 83 a9 	! . . 
	call apply_patch_record		;03ad	cd 0d 04 	. . . 
	pop af			;03b0	f1 	. 
	and a			;03b1	a7 	. 
	ret z			;03b2	c8 	. 
l03b3h:
	dec a			;03b3	3d 	= 
	ld hl,patch_ptrs_emul_1_6		;03b4	21 45 04 	! E . 
	call resolve_patch_ptr		;03b7	cd 1f 04 	. . . 
	ld hl,0aa03h		;03ba	21 03 aa 	! . . 
	jr apply_patch_record		;03bd	18 4e 	. N 
l03bfh:
	call clear_xlate_table		;03bf	cd 28 04 	. ( . 
	ld de,02014h		;03c2	11 14 20 	. .   
	ex de,hl			;03c5	eb 	. 
	ld bc,l0060h		;03c6	01 60 00 	. ` . 
	ldir		;03c9	ed b0 	. . 
	ld hl,xlate_aux_emul_0_7		;03cb	21 61 1d 	! a . 
	ld de,0aa03h		;03ce	11 03 aa 	. . . 
	ld bc,rst20_handler		;03d1	01 20 00 	.   . 
	ldir		;03d4	ed b0 	. . 
	jr l03b3h		;03d6	18 db 	. . 
l03d8h:
	ld hl,xlate_base_emul_8_10		;03d8	21 1e 1f 	! . . 
	ld de,ram_xlate_table		;03db	11 83 a9 	. . . 
	ld bc,l007fh+1		;03de	01 80 00 	. . . 
	ldir		;03e1	ed b0 	. . 
	ld hl,xlate_aux_emul_8_10		;03e3	21 cb 1d 	! . . 
	ld de,0aa03h		;03e6	11 03 aa 	. . . 
	ld bc,rst20_handler		;03e9	01 20 00 	.   . 
	ldir		;03ec	ed b0 	. . 
	sub 008h		;03ee	d6 08 	. . 
	ret z			;03f0	c8 	. 
	dec a			;03f1	3d 	= 
	push af			;03f2	f5 	. 
	ld hl,patch_ptrs_emul_9_10		;03f3	21 41 04 	! A . 
	call resolve_patch_ptr		;03f6	cd 1f 04 	. . . 
	ld hl,ram_xlate_table		;03f9	21 83 a9 	! . . 
	call apply_patch_record		;03fc	cd 0d 04 	. . . 
	pop af			;03ff	f1 	. 
	cp 001h		;0400	fe 01 	. . 
	ret nz			;0402	c0 	. 
	xor a			;0403	af 	. 
	ld hl,l0453h		;0404	21 53 04 	! S . 
	call resolve_patch_ptr		;0407	cd 1f 04 	. . . 
	ld hl,0aa03h		;040a	21 03 aa 	! . . 
apply_patch_record:
	ld a,(de)			;040d	1a 	. 
	ld b,a			;040e	47 	G 
l040fh:
	push bc			;040f	c5 	. 
	push hl			;0410	e5 	. 
	inc de			;0411	13 	. 
	ld a,(de)			;0412	1a 	. 
	ld b,000h		;0413	06 00 	. . 
	ld c,a			;0415	4f 	O 
	add hl,bc			;0416	09 	. 
	inc de			;0417	13 	. 
	ld a,(de)			;0418	1a 	. 
	ld (hl),a			;0419	77 	w 
	pop hl			;041a	e1 	. 
	pop bc			;041b	c1 	. 
	djnz l040fh		;041c	10 f1 	. . 
	ret			;041e	c9 	. 
resolve_patch_ptr:
	rlca			;041f	07 	. 
	ld d,000h		;0420	16 00 	. . 
	ld e,a			;0422	5f 	_ 
	add hl,de			;0423	19 	. 
	ld e,(hl)			;0424	5e 	^ 
	inc hl			;0425	23 	# 
	ld d,(hl)			;0426	56 	V 
	ret			;0427	c9 	. 
clear_xlate_table:
	ld b,020h		;0428	06 20 	.   
	ld hl,ram_xlate_table		;042a	21 83 a9 	! . . 
l042dh:
	ld (hl),000h		;042d	36 00 	6 . 
	inc hl			;042f	23 	# 
	djnz l042dh		;0430	10 fb 	. . 
	ret			;0432	c9 	. 
patch_ptrs_emul_0_6:
	ld c,(hl)			;0433	4e 	N 
	ld e,067h		;0434	1e 67 	. g 
	ld e,091h		;0436	1e 91 	. . 
	ld e,084h		;0438	1e 84 	. . 
	ld e,091h		;043a	1e 91 	. . 
	ld e,0beh		;043c	1e be 	. . 
	ld e,0f7h		;043e	1e f7 	. . 
	ld e,09eh		;0440	1e 9e 	. . 
	rra			;0442	1f 	. 
	or c			;0443	b1 	. 
	rra			;0444	1f 	. 
patch_ptrs_emul_1_6:
	add a,c			;0445	81 	. 
	dec e			;0446	1d 	. 
	adc a,b			;0447	88 	. 
	dec e			;0448	1d 	. 
	and e			;0449	a3 	. 
	dec e			;044a	1d 	. 
	and (hl)			;044b	a6 	. 
	dec e			;044c	1d 	. 
	add a,c			;044d	81 	. 
	dec e			;044e	1d 	. 
	or a			;044f	b7 	. 
	dec e			;0450	1d 	. 
	cp (hl)			;0451	be 	. 
	dec e			;0452	1d 	. 
l0453h:
	ex de,hl			;0453	eb 	. 
	dec e			;0454	1d 	. 
	nop			;0455	00 	. 
	ld bc,0381dh		;0456	01 1d 38 	. . 8 
	add hl,sp			;0459	39 	9 
	ld a,(03d3bh)		;045a	3a 3b 3d 	: ; = 
	ld e,b			;045d	58 	X 
	ld e,c			;045e	59 	Y 
	ld e,d			;045f	5a 	Z 
	ld e,e			;0460	5b 	[ 
	rst 38h			;0461	ff 	. 
	inc hl			;0462	23 	# 
	inc h			;0463	24 	$ 
	ld b,b			;0464	40 	@ 
	ld e,e			;0465	5b 	[ 
	ld e,h			;0466	5c 	\ 
	ld e,l			;0467	5d 	] 
	ld e,(hl)			;0468	5e 	^ 
	ld h,b			;0469	60 	` 
	ld a,e			;046a	7b 	{ 
	ld a,h			;046b	7c 	| 
	ld a,l			;046c	7d 	} 
	ld a,(hl)			;046d	7e 	~ 
	ret nc			;046e	d0 	. 
	inc h			;046f	24 	$ 
	ld b,b			;0470	40 	@ 
	ld e,e			;0471	5b 	[ 
	ld e,h			;0472	5c 	\ 
	ld e,l			;0473	5d 	] 
	ld e,(hl)			;0474	5e 	^ 
	ld h,b			;0475	60 	` 
	ld a,e			;0476	7b 	{ 
	ld a,h			;0477	7c 	| 
	ld a,l			;0478	7d 	} 
	ld a,(hl)			;0479	7e 	~ 
	ret nc			;047a	d0 	. 
	inc h			;047b	24 	$ 
	call nc,0ddd8h		;047c	d4 d8 dd 	. . . 
	jp po,0605eh		;047f	e2 5e 60 	. ^ ` 
	defb 0edh;next byte illegal after ed		;0482	ed 	. 
	jp p,0fcf8h		;0483	f2 f8 fc 	. . . 
	inc hl			;0486	23 	# 
	inc h			;0487	24 	$ 
	push de			;0488	d5 	. 
	exx			;0489	d9 	. 
	sbc a,0e3h		;048a	de e3 	. . 
	ld e,(hl)			;048c	5e 	^ 
	ld h,b			;048d	60 	` 
	xor 0f3h		;048e	ee f3 	. . 
	ld sp,hl			;0490	f9 	. 
	inc iy		;0491	fd 23 	. # 
	jp nc,0d9d6h		;0493	d2 d6 d9 	. . . 
	sbc a,0e4h		;0496	de e4 	. . 
	ret pe			;0498	e8 	. 
	jp pe,0f3eeh		;0499	ea ee f3 	. . . 
	jp m,023feh		;049c	fa fe 23 	. . # 
	inc h			;049f	24 	$ 
	ld b,b			;04a0	40 	@ 
	jp c,0e4dfh		;04a1	da df e4 	. . . 
	ld e,(hl)			;04a4	5e 	^ 
	ld h,b			;04a5	60 	` 
	rst 28h			;04a6	ef 	. 
	call p,07efah		;04a7	f4 fa 7e 	. . ~ 
	inc hl			;04aa	23 	# 
	inc h			;04ab	24 	$ 
	ld b,b			;04ac	40 	@ 
	in a,(0e0h)		;04ad	db e0 	. . 
	push hl			;04af	e5 	. 
	ld e,(hl)			;04b0	5e 	^ 
	ld h,b			;04b1	60 	` 
	ld a,e			;04b2	7b 	{ 
	push af			;04b3	f5 	. 
	ld a,l			;04b4	7d 	} 
	ld a,(hl)			;04b5	7e 	~ 
	ret nc			;04b6	d0 	. 
	inc h			;04b7	24 	$ 
	push de			;04b8	d5 	. 
	ret c			;04b9	d8 	. 
	defb 0ddh,0e6h,05eh	;illegal sequence		;04ba	dd e6 5e 	. . ^ 
	ex de,hl			;04bd	eb 	. 
	ret p			;04be	f0 	. 
	or 0f8h		;04bf	f6 f8 	. . 
	rst 38h			;04c1	ff 	. 
sub_04c2h:
	ld a,0cch		;04c2	3e cc 	> . 
	ld (0aa94h),a		;04c4	32 94 aa 	2 . . 
	ld hl,0aab7h		;04c7	21 b7 aa 	! . . 
	ld c,(hl)			;04ca	4e 	N 
	bit 2,c		;04cb	cb 51 	. Q 
	ret nz			;04cd	c0 	. 
	ld hl,0aa95h		;04ce	21 95 aa 	! . . 
	set 5,(hl)		;04d1	cb ee 	. . 
	bit 0,c		;04d3	cb 41 	. A 
	jr z,l04d9h		;04d5	28 02 	( . 
	res 5,(hl)		;04d7	cb ae 	. . 
l04d9h:
	ld hl,0aa94h		;04d9	21 94 aa 	! . . 
	ld (hl),00bh		;04dc	36 0b 	6 . 
	bit 1,c		;04de	cb 49 	. I 
	ret z			;04e0	c8 	. 
	ld (hl),0bbh		;04e1	36 bb 	6 . 
	ret			;04e3	c9 	. 
sub_04e4h:
	ld de,ram_setup_emul_bb		;04e4	11 bb aa 	. . . 
	ld a,(de)			;04e7	1a 	. 
	and 00fh		;04e8	e6 0f 	. . 
	cp 00bh		;04ea	fe 0b 	. . 
	jr c,l04f3h		;04ec	38 05 	8 . 
	ld a,(de)			;04ee	1a 	. 
	and 0f0h		;04ef	e6 f0 	. . 
	ld (de),a			;04f1	12 	. 
	xor a			;04f2	af 	. 
l04f3h:
	inc a			;04f3	3c 	< 
	ld b,a			;04f4	47 	G 
	ld hl,l0001h		;04f5	21 01 00 	! . . 
	jr l04fbh		;04f8	18 01 	. . 
l04fah:
	add hl,hl			;04fa	29 	) 
l04fbh:
	djnz l04fah		;04fb	10 fd 	. . 
	ld (0aa2bh),hl		;04fd	22 2b aa 	" + . 
l0500h:
	ld a,0ffh		;0500	3e ff 	> . 
	ld (0ab2ch),a		;0502	32 2c ab 	2 , . 
	ld a,(0aa2bh)		;0505	3a 2b aa 	: + . 
	and 014h		;0508	e6 14 	. . 
	ret z			;050a	c8 	. 
	ld hl,ram_setup_flags_b9		;050b	21 b9 aa 	! . . 
	bit 6,(hl)		;050e	cb 76 	. v 
	ret nz			;0510	c0 	. 
	xor a			;0511	af 	. 
	ld (0ab2ch),a		;0512	32 2c ab 	2 , . 
	ret			;0515	c9 	. 
sub_0516h:
	ld hl,ram_setup_flags_b9		;0516	21 b9 aa 	! . . 
	ld a,058h		;0519	3e 58 	> X 
	bit 2,(hl)		;051b	cb 56 	. V 
	jr z,l0520h		;051d	28 01 	( . 
	inc a			;051f	3c 	< 
l0520h:
	ld c,a			;0520	4f 	O 
	jp aux_ring_enq		;0521	c3 75 14 	. u . 
sub_0524h:
	ld a,(ram_setup_flags_b9)		;0524	3a b9 aa 	: . . 
	and 003h		;0527	e6 03 	. . 
	inc a			;0529	3c 	< 
	ld b,a			;052a	47 	G 
	xor a			;052b	af 	. 
	scf			;052c	37 	7 
l052dh:
	rla			;052d	17 	. 
	djnz l052dh		;052e	10 fd 	. . 
	ld b,a			;0530	47 	G 
	ld a,(ram_mode_flags)		;0531	3a 29 aa 	: ) . 
	and 0f0h		;0534	e6 f0 	. . 
	or b			;0536	b0 	. 
	ld (ram_mode_flags),a		;0537	32 29 aa 	2 ) . 
	ld hl,0ac3bh		;053a	21 3b ac 	! ; . 
	ld (hl),010h		;053d	36 10 	6 . 
	and 00bh		;053f	e6 0b 	. . 
	jr z,l054dh		;0541	28 0a 	( . 
	set 1,(hl)		;0543	cb ce 	. . 
	set 2,(hl)		;0545	cb d6 	. . 
	and 002h		;0547	e6 02 	. . 
	jr z,l054dh		;0549	28 02 	( . 
	set 5,(hl)		;054b	cb ee 	. . 
l054dh:
	ld a,(hl)			;054d	7e 	~ 
	ld (io_uart_primary),a		;054e	32 01 80 	2 . . 
	ret			;0551	c9 	. 
l0552h:
	ld a,(ram_mode_flags)		;0552	3a 29 aa 	: ) . 
	and 0efh		;0555	e6 ef 	. . 
	ld (ram_mode_flags),a		;0557	32 29 aa 	2 ) . 
	ld a,(0aa2ah)		;055a	3a 2a aa 	: * . 
	and 0bfh		;055d	e6 bf 	. . 
	ld (0aa2ah),a		;055f	32 2a aa 	2 * . 
	ld a,02fh		;0562	3e 2f 	> / 
	call sub_15d3h		;0564	cd d3 15 	. . . 
	ld hl,00514h		;0567	21 14 05 	! . . 
	rst 20h			;056a	e7 	. 
	ld a,027h		;056b	3e 27 	> ' 
	ld c,000h		;056d	0e 00 	. . 
	jr z,l057dh		;056f	28 0c 	( . 
	ld hl,l0014h		;0571	21 14 00 	! . . 
	rst 20h			;0574	e7 	. 
	ld a,000h		;0575	3e 00 	> . 
	jr nz,l057dh		;0577	20 04 	  . 
	ld a,001h		;0579	3e 01 	> . 
	ld c,010h		;057b	0e 10 	. . 
l057dh:
	call sub_15ddh		;057d	cd dd 15 	. . . 
	ld a,c			;0580	79 	y 
	ld (0ac28h),a		;0581	32 28 ac 	2 ( . 
	ld (ram_displaymode),a		;0584	32 d0 ab 	2 . . 
	ret			;0587	c9 	. 
sub_0588h:
	ld hl,00700h		;0588	21 00 07 	! . . 
	rst 20h			;058b	e7 	. 
	jr z,l0597h		;058c	28 09 	( . 
set_leadin_byte:
	ld hl,ram_setup_flags_b9		;058e	21 b9 aa 	! . . 
	bit 7,(hl)		;0591	cb 7e 	. ~ 
	ld a,07eh		;0593	3e 7e 	> ~ 
	jr nz,l0599h		;0595	20 02 	  . 
l0597h:
	ld a,01bh		;0597	3e 1b 	> . 
l0599h:
	ld (ram_leadin_byte),a		;0599	32 99 aa 	2 . . 
	ret			;059c	c9 	. 
sub_059dh:
	ld c,04ah		;059d	0e 4a 	. J 
	ld hl,0aab8h		;059f	21 b8 aa 	! . . 
	ld a,(hl)			;05a2	7e 	~ 
	and 030h		;05a3	e6 30 	. 0 
	cp 020h		;05a5	fe 20 	.   
	jr nz,l05adh		;05a7	20 04 	  . 
	set 4,(hl)		;05a9	cb e6 	. . 
	ld a,030h		;05ab	3e 30 	> 0 
l05adh:
	or c			;05ad	b1 	. 
	ld c,a			;05ae	4f 	O 
	ld a,(hl)			;05af	7e 	~ 
	and 040h		;05b0	e6 40 	. @ 
	rlca			;05b2	07 	. 
	or c			;05b3	b1 	. 
	ld c,a			;05b4	4f 	O 
	bit 7,(hl)		;05b5	cb 7e 	. ~ 
	jr nz,l05bbh		;05b7	20 02 	  . 
	set 2,c		;05b9	cb d1 	. . 
l05bbh:
	ld a,040h		;05bb	3e 40 	> @ 
	ld hl,io_uart_primary		;05bd	21 01 80 	! . . 
	ld (hl),a			;05c0	77 	w 
	ld a,c			;05c1	79 	y 
	ld (0ac3ah),a		;05c2	32 3a ac 	2 : . 
	ld (hl),a			;05c5	77 	w 
	ld a,(0ac3bh)		;05c6	3a 3b ac 	: ; . 
	ld (hl),a			;05c9	77 	w 
	ret			;05ca	c9 	. 
crtc_upper_config:
	ld a,(ram_setup_emul_bb)		;05cb	3a bb aa 	: . . 
	and 0f0h		;05ce	e6 f0 	. . 
	rrca			;05d0	0f 	. 
	rrca			;05d1	0f 	. 
	rrca			;05d2	0f 	. 
	ld c,000h		;05d3	0e 00 	. . 
	jr l05dfh		;05d5	18 08 	. . 
l05d7h:
	ld a,(0aabch)		;05d7	3a bc aa 	: . . 
	and 00fh		;05da	e6 0f 	. . 
	rlca			;05dc	07 	. 
	ld c,040h		;05dd	0e 40 	. @ 
l05dfh:
	ld e,a			;05df	5f 	_ 
	ld d,000h		;05e0	16 00 	. . 
	ld hl,crtc_config_table		;05e2	21 9c 02 	! . . 
	add hl,de			;05e5	19 	. 
	outi		;05e6	ed a3 	. . 
	nop			;05e8	00 	. 
	outi		;05e9	ed a3 	. . 
	ret			;05eb	c9 	. 
l05ech:
	ld hl,0aa8ah		;05ec	21 8a aa 	! . . 
	set 7,(hl)		;05ef	cb fe 	. . 
	ret			;05f1	c9 	. 
	ld hl,0ab2fh		;05f2	21 2f ab 	! / . 
	ld a,(hl)			;05f5	7e 	~ 
	ld (0ac16h),a		;05f6	32 16 ac 	2 . . 
	ld (hl),020h		;05f9	36 20 	6   
	call 0457fh		;05fb	cd 7f 45 	.  E 
	ld hl,0aa2eh		;05fe	21 2e aa 	! . . 
	ld a,(hl)			;0601	7e 	~ 
	or 02fh		;0602	f6 2f 	. / 
	and 0efh		;0604	e6 ef 	. . 
	ld (hl),a			;0606	77 	w 
	ld (0f000h),a		;0607	32 00 f0 	2 . . 
	ld hl,ram_displaymode		;060a	21 d0 ab 	! . . 
	ld a,(hl)			;060d	7e 	~ 
	or 004h		;060e	f6 04 	. . 
	ld (hl),a			;0610	77 	w 
	xor a			;0611	af 	. 
	ld (0aaach),a		;0612	32 ac aa 	2 . . 
	inc a			;0615	3c 	< 
	ld (0aaafh),a		;0616	32 af aa 	2 . . 
	ld de,l1ff8h		;0619	11 f8 1f 	. . . 
	ld (0aab1h),de		;061c	ed 53 b1 aa 	. S . . 
	ld de,0aab7h		;0620	11 b7 aa 	. . . 
	ld (0aab3h),de		;0623	ed 53 b3 aa 	. S . . 
	xor a			;0627	af 	. 
	call 03d20h		;0628	cd 20 3d 	.   = 
	ld hl,l001dh		;062b	21 1d 00 	! . . 
	add hl,de			;062e	19 	. 
	ld (06004h),hl		;062f	22 04 60 	" . ` 
	ld hl,l0928h		;0632	21 28 09 	! ( . 
	ld b,00bh		;0635	06 0b 	. . 
l0637h:
	ld e,(hl)			;0637	5e 	^ 
	ld d,040h		;0638	16 40 	. @ 
	call sub_177fh		;063a	cd 7f 17 	.  . 
	ld d,060h		;063d	16 60 	. ` 
	call sub_177fh		;063f	cd 7f 17 	.  . 
	inc hl			;0642	23 	# 
	djnz l0637h		;0643	10 f2 	. . 
	ld a,002h		;0645	3e 02 	> . 
	call 03d20h		;0647	cd 20 3d 	.   = 
	ld hl,00041h		;064a	21 41 00 	! A . 
	add hl,de			;064d	19 	. 
	ld de,l0933h		;064e	11 33 09 	. 3 . 
	ld c,000h		;0651	0e 00 	. . 
	call sub_094dh		;0653	cd 4d 09 	. M . 
	push hl			;0656	e5 	. 
	ld a,003h		;0657	3e 03 	> . 
	call 03d20h		;0659	cd 20 3d 	.   = 
	ld hl,00043h		;065c	21 43 00 	! C . 
	add hl,de			;065f	19 	. 
	pop de			;0660	d1 	. 
	inc de			;0661	13 	. 
	ld c,000h		;0662	0e 00 	. . 
	call sub_094dh		;0664	cd 4d 09 	. M . 
	ld hl,04a9fh		;0667	21 9f 4a 	! . J 
	dec hl			;066a	2b 	+ 
l066bh:
	xor a			;066b	af 	. 
	ld (0aabeh),a		;066c	32 be aa 	2 . . 
	ld (0aabfh),a		;066f	32 bf aa 	2 . . 
	ld (0aac2h),a		;0672	32 c2 aa 	2 . . 
	inc hl			;0675	23 	# 
	push hl			;0676	e5 	. 
	ld hl,0aaafh		;0677	21 af aa 	! . . 
	inc (hl)			;067a	34 	4 
	ld a,(hl)			;067b	7e 	~ 
	cp 018h		;067c	fe 18 	. . 
	jr nc,l0692h		;067e	30 12 	0 . 
	cp 003h		;0680	fe 03 	. . 
	jr z,l0688h		;0682	28 04 	( . 
	cp 008h		;0684	fe 08 	. . 
	jr nz,l068dh		;0686	20 05 	  . 
l0688h:
	ld hl,0aac2h		;0688	21 c2 aa 	! . . 
	ld (hl),0ffh		;068b	36 ff 	6 . 
l068dh:
	call 03d20h		;068d	cd 20 3d 	.   = 
	jr l069ah		;0690	18 08 	. . 
l0692h:
	ld a,008h		;0692	3e 08 	> . 
	ld (0aabfh),a		;0694	32 bf aa 	2 . . 
	ld de,reset_vector		;0697	11 00 00 	. . . 
l069ah:
	ld (06004h),de		;069a	ed 53 04 60 	. S . ` 
	call sub_0829h		;069e	cd 29 08 	. ) . 
	pop hl			;06a1	e1 	. 
	inc a			;06a2	3c 	< 
	ld b,a			;06a3	47 	G 
	ld a,(0aac2h)		;06a4	3a c2 aa 	: . . 
	and a			;06a7	a7 	. 
	jr z,l06b1h		;06a8	28 07 	( . 
	ld a,b			;06aa	78 	x 
	cp 004h		;06ab	fe 04 	. . 
	jr nz,l06b1h		;06ad	20 02 	  . 
	dec a			;06af	3d 	= 
	ld b,a			;06b0	47 	G 
l06b1h:
	ld a,(hl)			;06b1	7e 	~ 
	cp 021h		;06b2	fe 21 	. ! 
	jr nz,l06d0h		;06b4	20 1a 	  . 
	dec b			;06b6	05 	. 
	sla b		;06b7	cb 20 	.   
	sla b		;06b9	cb 20 	.   
	ld e,b			;06bb	58 	X 
	ld d,000h		;06bc	16 00 	. . 
	ld hl,l08e8h		;06be	21 e8 08 	! . . 
	add hl,de			;06c1	19 	. 
	ld b,004h		;06c2	06 04 	. . 
l06c4h:
	ld e,(hl)			;06c4	5e 	^ 
	ld d,008h		;06c5	16 08 	. . 
	call sub_177fh		;06c7	cd 7f 17 	.  . 
	inc hl			;06ca	23 	# 
	djnz l06c4h		;06cb	10 f7 	. . 
	ld hl,04d39h		;06cd	21 39 4d 	! 9 M 
l06d0h:
	ld a,(hl)			;06d0	7e 	~ 
	ld e,a			;06d1	5f 	_ 
	cp 02eh		;06d2	fe 2e 	. . 
	jr nz,l06e5h		;06d4	20 0f 	  . 
	xor a			;06d6	af 	. 
	ld (0aabfh),a		;06d7	32 bf aa 	2 . . 
	ld d,001h		;06da	16 01 	. . 
	djnz l06fah		;06dc	10 1c 	. . 
	ld a,008h		;06de	3e 08 	> . 
	ld (0aabfh),a		;06e0	32 bf aa 	2 . . 
	jr l06fah		;06e3	18 15 	. . 
l06e5h:
	cp 02ah		;06e5	fe 2a 	. * 
	jr nz,l06f2h		;06e7	20 09 	  . 
	ld a,001h		;06e9	3e 01 	> . 
	ld (0aabeh),a		;06eb	32 be aa 	2 . . 
	ld d,001h		;06ee	16 01 	. . 
	jr l06fah		;06f0	18 08 	. . 
l06f2h:
	cp 03fh		;06f2	fe 3f 	. ? 
	jr z,l0709h		;06f4	28 13 	( . 
	ld a,(0aabfh)		;06f6	3a bf aa 	: . . 
	ld d,a			;06f9	57 	W 
l06fah:
	call sub_177fh		;06fa	cd 7f 17 	.  . 
	rst 10h			;06fd	d7 	. 
	ld a,(0aabeh)		;06fe	3a be aa 	: . . 
	and a			;0701	a7 	. 
	jp nz,l066bh		;0702	c2 6b 06 	. k . 
	inc hl			;0705	23 	# 
	jp l06b1h		;0706	c3 b1 06 	. . . 
l0709h:
	ld a,041h		;0709	3e 41 	> A 
	ld (0aaabh),a		;070b	32 ab aa 	2 . . 
l070eh:
	ld a,001h		;070e	3e 01 	> . 
	ld (0aaach),a		;0710	32 ac aa 	2 . . 
	ld de,0aab7h		;0713	11 b7 aa 	. . . 
	ld (0aab3h),de		;0716	ed 53 b3 aa 	. S . . 
	ld de,l1ff8h		;071a	11 f8 1f 	. . . 
	ld (0aab1h),de		;071d	ed 53 b1 aa 	. S . . 
	xor a			;0721	af 	. 
	ld (0aac1h),a		;0722	32 c1 aa 	2 . . 
	ld (0aac2h),a		;0725	32 c2 aa 	2 . . 
	push bc			;0728	c5 	. 
	call sub_184dh		;0729	cd 4d 18 	. M . 
	ld a,c			;072c	79 	y 
	pop bc			;072d	c1 	. 
	cp 0e8h		;072e	fe e8 	. . 
	jr z,l0772h		;0730	28 40 	( @ 
	cp 060h		;0732	fe 60 	. ` 
	jr c,l0738h		;0734	38 02 	8 . 
	sub 020h		;0736	d6 20 	.   
l0738h:
	ld c,a			;0738	4f 	O 
	cp 013h		;0739	fe 13 	. . 
	jr z,l076fh		;073b	28 32 	( 2 
	cp 057h		;073d	fe 57 	. W 
	jr nc,l070eh		;073f	30 cd 	0 . 
	cp 041h		;0741	fe 41 	. A 
	jr c,l070eh		;0743	38 c9 	8 . 
	ld a,(0aaabh)		;0745	3a ab aa 	: . . 
	cp c			;0748	b9 	. 
	jr z,l078bh		;0749	28 40 	( @ 
	sub 03fh		;074b	d6 3f 	. ? 
	call 03d20h		;074d	cd 20 3d 	.   = 
	ex de,hl			;0750	eb 	. 
l0751h:
	ld (06006h),hl		;0751	22 06 60 	" . ` 
	call sub_17a0h		;0754	cd a0 17 	. . . 
	ld a,(0c000h)		;0757	3a 00 c0 	: . . 
	cp 02ah		;075a	fe 2a 	. * 
	jr z,l0781h		;075c	28 23 	( # 
	ld e,a			;075e	5f 	_ 
	ld a,(0d000h)		;075f	3a 00 d0 	: . . 
	cp 00ch		;0762	fe 0c 	. . 
	inc hl			;0764	23 	# 
	jr nz,l0751h		;0765	20 ea 	  . 
	ld d,008h		;0767	16 08 	. . 
	call sub_1777h		;0769	cd 77 17 	. w . 
	rst 10h			;076c	d7 	. 
	jr l0751h		;076d	18 e2 	. . 
l076fh:
	call sub_1cc3h		;076f	cd c3 1c 	. . . 
l0772h:
	call 0457fh		;0772	cd 7f 45 	.  E 
	ld a,(0ac16h)		;0775	3a 16 ac 	: . . 
	ld (0ab2fh),a		;0778	32 2f ab 	2 / . 
	call 04e70h		;077b	cd 70 4e 	. p N 
	jp l0552h		;077e	c3 52 05 	. R . 
l0781h:
	ld a,c			;0781	79 	y 
	ld (0aaabh),a		;0782	32 ab aa 	2 . . 
	ld e,a			;0785	5f 	_ 
	ld d,008h		;0786	16 08 	. . 
	call sub_177bh		;0788	cd 7b 17 	. { . 
l078bh:
	ld a,c			;078b	79 	y 
	cp 042h		;078c	fe 42 	. B 
	jr z,l079fh		;078e	28 0f 	( . 
	cp 047h		;0790	fe 47 	. G 
	jr z,l079fh		;0792	28 0b 	( . 
	cp 056h		;0794	fe 56 	. V 
	jr nz,l07a4h		;0796	20 0c 	  . 
	ld a,001h		;0798	3e 01 	> . 
	ld (0aac1h),a		;079a	32 c1 aa 	2 . . 
	jr l07a4h		;079d	18 05 	. . 
l079fh:
	ld a,001h		;079f	3e 01 	> . 
	ld (0aac2h),a		;07a1	32 c2 aa 	2 . . 
l07a4h:
	ld a,c			;07a4	79 	y 
	sub 040h		;07a5	d6 40 	. @ 
	ld b,a			;07a7	47 	G 
	ld hl,(0aab1h)		;07a8	2a b1 aa 	* . . 
	dec hl			;07ab	2b 	+ 
	ld (0aab1h),hl		;07ac	22 b1 aa 	" . . 
l07afh:
	ld hl,(0aab1h)		;07af	2a b1 aa 	* . . 
	inc hl			;07b2	23 	# 
	ld (0aab1h),hl		;07b3	22 b1 aa 	" . . 
	ld c,(hl)			;07b6	4e 	N 
	xor a			;07b7	af 	. 
	cp c			;07b8	b9 	. 
	jr nz,l07c6h		;07b9	20 0b 	  . 
	inc hl			;07bb	23 	# 
	ld (0aab1h),hl		;07bc	22 b1 aa 	" . . 
	ld hl,(0aab3h)		;07bf	2a b3 aa 	* . . 
	inc hl			;07c2	23 	# 
	ld (0aab3h),hl		;07c3	22 b3 aa 	" . . 
l07c6h:
	djnz l07afh		;07c6	10 e7 	. . 
	call sub_0829h		;07c8	cd 29 08 	. ) . 
	inc a			;07cb	3c 	< 
	ld b,a			;07cc	47 	G 
	ld a,(0aaabh)		;07cd	3a ab aa 	: . . 
	sub 03fh		;07d0	d6 3f 	. ? 
	call 03d20h		;07d2	cd 20 3d 	.   = 
	ex de,hl			;07d5	eb 	. 
	ld d,000h		;07d6	16 00 	. . 
	ld a,(0aac2h)		;07d8	3a c2 aa 	: . . 
	and a			;07db	a7 	. 
	jr z,l07e7h		;07dc	28 09 	( . 
	ld a,b			;07de	78 	x 
	cp 004h		;07df	fe 04 	. . 
	jr nz,l0807h		;07e1	20 24 	  $ 
	dec a			;07e3	3d 	= 
	ld b,a			;07e4	47 	G 
	jr l0807h		;07e5	18 20 	.   
l07e7h:
	ld a,(0aac1h)		;07e7	3a c1 aa 	: . . 
	and a			;07ea	a7 	. 
	jr z,l0807h		;07eb	28 1a 	( . 
	ld a,l			;07ed	7d 	} 
	add a,017h		;07ee	c6 17 	. . 
	ld l,a			;07f0	6f 	o 
	push hl			;07f1	e5 	. 
	dec b			;07f2	05 	. 
	sla b		;07f3	cb 20 	.   
	sla b		;07f5	cb 20 	.   
	ld e,b			;07f7	58 	X 
	ld hl,l08e8h		;07f8	21 e8 08 	! . . 
	add hl,de			;07fb	19 	. 
	pop de			;07fc	d1 	. 
	ld b,004h		;07fd	06 04 	. . 
	ld a,00ch		;07ff	3e 0c 	> . 
	call sub_0d68h		;0801	cd 68 0d 	. h . 
	jp l070eh		;0804	c3 0e 07 	. . . 
l0807h:
	rst 10h			;0807	d7 	. 
	ld (06006h),hl		;0808	22 06 60 	" . ` 
	call sub_17a0h		;080b	cd a0 17 	. . . 
	ld a,(0c000h)		;080e	3a 00 c0 	: . . 
	cp 02eh		;0811	fe 2e 	. . 
	inc hl			;0813	23 	# 
	jr nz,l081eh		;0814	20 08 	  . 
	ld d,000h		;0816	16 00 	. . 
	djnz l0807h		;0818	10 ed 	. . 
	ld d,00ch		;081a	16 0c 	. . 
	jr l0807h		;081c	18 e9 	. . 
l081eh:
	cp 02ah		;081e	fe 2a 	. * 
	jp z,l070eh		;0820	ca 0e 07 	. . . 
	ld e,a			;0823	5f 	_ 
	call sub_1777h		;0824	cd 77 17 	. w . 
	jr l0807h		;0827	18 de 	. . 
sub_0829h:
	ld a,(0aaach)		;0829	3a ac aa 	: . . 
	ld b,a			;082c	47 	G 
	ld hl,(0aab1h)		;082d	2a b1 aa 	* . . 
	ld de,(0aab3h)		;0830	ed 5b b3 aa 	. [ . . 
	xor a			;0834	af 	. 
	ld c,(hl)			;0835	4e 	N 
	bit 3,c		;0836	cb 59 	. Y 
	jr nz,l0848h		;0838	20 0e 	  . 
	bit 2,c		;083a	cb 51 	. Q 
	jr nz,l084ah		;083c	20 0c 	  . 
	bit 1,c		;083e	cb 49 	. I 
	jr nz,l084ch		;0840	20 0a 	  . 
	bit 0,c		;0842	cb 41 	. A 
	jr nz,l084eh		;0844	20 08 	  . 
	jr l08abh		;0846	18 63 	. c 
l0848h:
	set 3,a		;0848	cb df 	. . 
l084ah:
	set 2,a		;084a	cb d7 	. . 
l084ch:
	set 1,a		;084c	cb cf 	. . 
l084eh:
	set 0,a		;084e	cb c7 	. . 
	ld (0aaadh),a		;0850	32 ad aa 	2 . . 
	cpl			;0853	2f 	/ 
	ld c,a			;0854	4f 	O 
	ld a,(de)			;0855	1a 	. 
	push de			;0856	d5 	. 
	ld d,c			;0857	51 	Q 
	ld c,a			;0858	4f 	O 
	ld a,(hl)			;0859	7e 	~ 
	and 0f0h		;085a	e6 f0 	. . 
	jr z,l0868h		;085c	28 0a 	( . 
l085eh:
	srl c		;085e	cb 39 	. 9 
	sla b		;0860	cb 20 	.   
	rlc d		;0862	cb 02 	. . 
	sub 010h		;0864	d6 10 	. . 
	jr nz,l085eh		;0866	20 f6 	  . 
l0868h:
	ld a,d			;0868	7a 	z 
	ld (0aaaeh),a		;0869	32 ae aa 	2 . . 
	pop de			;086c	d1 	. 
	push bc			;086d	c5 	. 
	ld a,(0aaadh)		;086e	3a ad aa 	: . . 
	and c			;0871	a1 	. 
	ld c,a			;0872	4f 	O 
	ld a,(0aac2h)		;0873	3a c2 aa 	: . . 
	and a			;0876	a7 	. 
	jr z,l087eh		;0877	28 05 	( . 
	ld a,c			;0879	79 	y 
	cp 001h		;087a	fe 01 	. . 
	jr z,l0897h		;087c	28 19 	( . 
l087eh:
	ld a,(hl)			;087e	7e 	~ 
	and 00fh		;087f	e6 0f 	. . 
	sub c			;0881	91 	. 
	pop bc			;0882	c1 	. 
	jr c,l088dh		;0883	38 08 	8 . 
	jr nz,l089ah		;0885	20 13 	  . 
	ld a,(0aaach)		;0887	3a ac aa 	: . . 
	and a			;088a	a7 	. 
	jr z,l089ah		;088b	28 0d 	( . 
l088dh:
	ld a,(0aaaeh)		;088d	3a ae aa 	: . . 
	ld b,a			;0890	47 	G 
	ld a,(de)			;0891	1a 	. 
	and b			;0892	a0 	. 
	ld (de),a			;0893	12 	. 
	xor a			;0894	af 	. 
	jr l08a6h		;0895	18 0f 	. . 
l0897h:
	pop bc			;0897	c1 	. 
	sla b		;0898	cb 20 	.   
l089ah:
	ld a,(0aaach)		;089a	3a ac aa 	: . . 
	add a,c			;089d	81 	. 
	ld c,a			;089e	4f 	O 
	ld a,(de)			;089f	1a 	. 
	add a,b			;08a0	80 	. 
	ld (de),a			;08a1	12 	. 
	ld a,(0aaadh)		;08a2	3a ad aa 	: . . 
	and c			;08a5	a1 	. 
l08a6h:
	inc hl			;08a6	23 	# 
	ld (0aab1h),hl		;08a7	22 b1 aa 	" . . 
	ret			;08aa	c9 	. 
l08abh:
	inc de			;08ab	13 	. 
	ld (0aab3h),de		;08ac	ed 53 b3 aa 	. S . . 
	inc hl			;08b0	23 	# 
	ld (0aab1h),hl		;08b1	22 b1 aa 	" . . 
	jp sub_0829h		;08b4	c3 29 08 	. ) . 
tbl_duplex:
	ld c,b			;08b7	48 	H 
	ld b,h			;08b8	44 	D 
	ld e,b			;08b9	58 	X 
	jr nz,l0902h		;08ba	20 46 	  F 
	ld b,h			;08bc	44 	D 
	ld e,b			;08bd	58 	X 
	jr nz,78		;08be	20 4c 	  L 
	ld b,e			;08c0	43 	C 
	ld c,h			;08c1	4c 	L 
	jr nz,l0906h		;08c2	20 42 	  B 
	ld c,h			;08c4	4c 	L 
	ld c,e			;08c5	4b 	K 
l08c6h:
	ld b,e			;08c6	43 	C 
	ld c,h			;08c7	4c 	L 
	ld c,c			;08c8	49 	I 
	ld b,e			;08c9	43 	C 
	ld c,e			;08ca	4b 	K 
	jr nz,l0920h		;08cb	20 53 	  S 
	ld c,c			;08cd	49 	I 
tbl_on_off:
	ld c,h			;08ce	4c 	L 
	ld b,l			;08cf	45 	E 
	ld c,(hl)			;08d0	4e 	N 
	ld d,h			;08d1	54 	T 
l08d2h:
	ld c,a			;08d2	4f 	O 
	ld c,(hl)			;08d3	4e 	N 
tbl_nor_rev:
	jr nz,l08f6h		;08d4	20 20 	    
	ld c,a			;08d6	4f 	O 
	ld b,(hl)			;08d7	46 	F 
	ld b,(hl)			;08d8	46 	F 
l08d9h:
	ld c,(hl)			;08d9	4e 	N 
tbl_loc_edupe:
	ld c,a			;08da	4f 	O 
	ld d,d			;08db	52 	R 
	jr nz,l0930h		;08dc	20 52 	  R 
	ld b,l			;08de	45 	E 
	ld d,(hl)			;08df	56 	V 
	ld c,h			;08e0	4c 	L 
	ld c,a			;08e1	4f 	O 
tbl_baud_strings:
	ld b,e			;08e2	43 	C 
	ld b,l			;08e3	45 	E 
	ld b,h			;08e4	44 	D 
	ld d,l			;08e5	55 	U 
	ld d,b			;08e6	50 	P 
	ld b,l			;08e7	45 	E 
l08e8h:
	add hl,sp			;08e8	39 	9 
	ld (hl),030h		;08e9	36 30 	6 0 
	jr nc,l090dh		;08eb	30 20 	0   
	jr nz,55		;08ed	20 35 	  5 
	jr nc,l0911h		;08ef	30 20 	0   
	jr nz,l092ah		;08f1	20 37 	  7 
	dec (hl)			;08f3	35 	5 
	jr nz,51		;08f4	20 31 	  1 
l08f6h:
	ld sp,02030h		;08f6	31 30 20 	1 0   
	ld sp,03433h		;08f9	31 33 34 	1 3 4 
	jr nz,51		;08fc	20 31 	  1 
	dec (hl)			;08fe	35 	5 
	jr nc,l0921h		;08ff	30 20 	0   
	inc sp			;0901	33 	3 
l0902h:
	jr nc,l0934h		;0902	30 30 	0 0 
	jr nz,l093ch		;0904	20 36 	  6 
l0906h:
	jr nc,l0938h		;0906	30 30 	0 0 
	ld sp,03032h		;0908	31 32 30 	1 2 0 
	jr nc,l093eh		;090b	30 31 	0 1 
l090dh:
	jr c,l093fh		;090d	38 30 	8 0 
	jr nc,l0943h		;090f	30 32 	0 2 
l0911h:
	inc (hl)			;0911	34 	4 
	jr nc,l0944h		;0912	30 30 	0 0 
	inc sp			;0914	33 	3 
	ld (hl),030h		;0915	36 30 	6 0 
	jr nc,sub_094dh		;0917	30 34 	0 4 
	jr c,l094bh		;0919	38 30 	8 0 
	jr nc,l0954h		;091b	30 37 	0 7 
	ld (03030h),a		;091d	32 30 30 	2 0 0 
l0920h:
	add hl,sp			;0920	39 	9 
l0921h:
	ld (hl),030h		;0921	36 30 	6 0 
	jr nc,l0956h		;0923	30 31 	0 1 
	add hl,sp			;0925	39 	9 
	ld l,032h		;0926	2e 32 	. 2 
l0928h:
	ld d,e			;0928	53 	S 
	ld b,l			;0929	45 	E 
l092ah:
	ld d,h			;092a	54 	T 
	dec l			;092b	2d 	- 
	ld d,l			;092c	55 	U 
str_copyright:
	ld d,b			;092d	50 	P 
	jr nz,79		;092e	20 4d 	  M 
l0930h:
	ld b,l			;0930	45 	E 
	ld c,(hl)			;0931	4e 	N 
	ld d,l			;0932	55 	U 
l0933h:
	ld b,e			;0933	43 	C 
l0934h:
	ld c,a			;0934	4f 	O 
	ld d,b			;0935	50 	P 
	ld e,c			;0936	59 	Y 
	ld d,d			;0937	52 	R 
l0938h:
	ld c,c			;0938	49 	I 
	ld b,a			;0939	47 	G 
	ld c,b			;093a	48 	H 
	ld d,h			;093b	54 	T 
l093ch:
	jr nz,51		;093c	20 31 	  1 
l093eh:
	add hl,sp			;093e	39 	9 
l093fh:
	jr c,l0974h		;093f	38 33 	8 3 
	dec a			;0941	3d 	= 
	ld b,c			;0942	41 	A 
l0943h:
	ld c,l			;0943	4d 	M 
l0944h:
	ld d,b			;0944	50 	P 
	ld b,l			;0945	45 	E 
	ld e,b			;0946	58 	X 
	jr nz,l098ch		;0947	20 43 	  C 
	ld c,a			;0949	4f 	O 
	ld d,d			;094a	52 	R 
l094bh:
	ld d,b			;094b	50 	P 
	dec a			;094c	3d 	= 
sub_094dh:
	rst 10h			;094d	d7 	. 
	ld (06004h),hl		;094e	22 04 60 	" . ` 
	ex de,hl			;0951	eb 	. 
	ld d,c			;0952	51 	Q 
l0953h:
	ld e,(hl)			;0953	5e 	^ 
l0954h:
	ld a,03dh		;0954	3e 3d 	> = 
l0956h:
	cp e			;0956	bb 	. 
	ret z			;0957	c8 	. 
	call sub_177fh		;0958	cd 7f 17 	.  . 
	inc hl			;095b	23 	# 
	jr l0953h		;095c	18 f5 	. . 
	ld a,(ram_setup_flags_b9)		;095e	3a b9 aa 	: . . 
	and 003h		;0961	e6 03 	. . 
	rlca			;0963	07 	. 
	rlca			;0964	07 	. 
	ld hl,tbl_duplex		;0965	21 b7 08 	! . . 
	ld de,l0001h+1		;0968	11 02 00 	. . . 
	jr l099dh		;096b	18 30 	. 0 
	ld a,(ram_setup_flags_b9)		;096d	3a b9 aa 	: . . 
	and 004h		;0970	e6 04 	. . 
	ld b,a			;0972	47 	G 
	rrca			;0973	0f 	. 
l0974h:
	add a,b			;0974	80 	. 
	ld e,a			;0975	5f 	_ 
	ld d,000h		;0976	16 00 	. . 
	ld hl,l08c6h		;0978	21 c6 08 	! . . 
	add hl,de			;097b	19 	. 
	ld de,00009h		;097c	11 09 00 	. . . 
	ld b,006h		;097f	06 06 	. . 
	jr l09a3h		;0981	18 20 	.   
	ld a,(0aab8h)		;0983	3a b8 aa 	: . . 
	and 002h		;0986	e6 02 	. . 
	rlca			;0988	07 	. 
	ld hl,l08d2h		;0989	21 d2 08 	! . . 
l098ch:
	ld de,rst18_handler		;098c	11 18 00 	. . . 
	jr l099dh		;098f	18 0c 	. . 
	ld a,(0aab7h)		;0991	3a b7 aa 	: . . 
	and 008h		;0994	e6 08 	. . 
	rrca			;0996	0f 	. 
	ld hl,l08d9h		;0997	21 d9 08 	! . . 
	ld de,l001fh		;099a	11 1f 00 	. . . 
l099dh:
	ld c,a			;099d	4f 	O 
	ld b,000h		;099e	06 00 	. . 
	add hl,bc			;09a0	09 	. 
	ld b,003h		;09a1	06 03 	. . 
l09a3h:
	jp l0d61h		;09a3	c3 61 0d 	. a . 
l09a6h:
	ld a,(bc)			;09a6	0a 	. 
	and 00fh		;09a7	e6 0f 	. . 
	ld (de),a			;09a9	12 	. 
	inc de			;09aa	13 	. 
	push hl			;09ab	e5 	. 
	and a			;09ac	a7 	. 
	sbc hl,de		;09ad	ed 52 	. R 
	pop hl			;09af	e1 	. 
	ret c			;09b0	d8 	. 
	ld a,(bc)			;09b1	0a 	. 
	and 0f0h		;09b2	e6 f0 	. . 
	rrca			;09b4	0f 	. 
	rrca			;09b5	0f 	. 
	rrca			;09b6	0f 	. 
	rrca			;09b7	0f 	. 
	ld (de),a			;09b8	12 	. 
	inc de			;09b9	13 	. 
	push hl			;09ba	e5 	. 
	and a			;09bb	a7 	. 
	sbc hl,de		;09bc	ed 52 	. R 
	pop hl			;09be	e1 	. 
	ret c			;09bf	d8 	. 
	inc bc			;09c0	03 	. 
	jr l09a6h		;09c1	18 e3 	. . 
	ld a,0ffh		;09c3	3e ff 	> . 
	ld hl,ram_setup_flags_b9		;09c5	21 b9 aa 	! . . 
	set 6,(hl)		;09c8	cb f6 	. . 
	ld hl,05005h		;09ca	21 05 50 	! . P 
	set 2,(hl)		;09cd	cb d6 	. . 
	jr l09dch		;09cf	18 0b 	. . 
	ld hl,ram_setup_flags_b9		;09d1	21 b9 aa 	! . . 
	res 6,(hl)		;09d4	cb b6 	. . 
	ld hl,05005h		;09d6	21 05 50 	! . P 
	res 2,(hl)		;09d9	cb 96 	. . 
	xor a			;09db	af 	. 
l09dch:
	ld (0ab2ch),a		;09dc	32 2c ab 	2 , . 
	ret			;09df	c9 	. 
h_clear_mode7:
	xor a			;09e0	af 	. 
	ld (0ad79h),a		;09e1	32 79 ad 	2 y . 
	ld hl,ram_mode_flags		;09e4	21 29 aa 	! ) . 
	res 7,(hl)		;09e7	cb be 	. . 
	jp l0f87h		;09e9	c3 87 0f 	. . . 
	xor a			;09ec	af 	. 
	ld (0acc7h),a		;09ed	32 c7 ac 	2 . . 
	ret			;09f0	c9 	. 
h_cursor_report:
	ld a,(0abd8h)		;09f1	3a d8 ab 	: . . 
	add a,020h		;09f4	c6 20 	.   
	ld c,a			;09f6	4f 	O 
	rst 18h			;09f7	df 	. 
	ld a,(0abd7h)		;09f8	3a d7 ab 	: . . 
	add a,020h		;09fb	c6 20 	.   
	ld c,a			;09fd	4f 	O 
	rst 18h			;09fe	df 	. 
	ld a,(0aa2bh)		;09ff	3a 2b aa 	: + . 
	and 0c0h		;0a02	e6 c0 	. . 
	jp nz,l118eh		;0a04	c2 8e 11 	. . . 
	ret			;0a07	c9 	. 
h_cpp_extended:
	ld a,(0abd7h)		;0a08	3a d7 ab 	: . . 
	cp 020h		;0a0b	fe 20 	.   
	jr nc,l0a11h		;0a0d	30 02 	0 . 
	add a,060h		;0a0f	c6 60 	. ` 
l0a11h:
	ld c,a			;0a11	4f 	O 
	rst 18h			;0a12	df 	. 
	ld a,(0abd8h)		;0a13	3a d8 ab 	: . . 
	add a,060h		;0a16	c6 60 	. ` 
	ld c,a			;0a18	4f 	O 
	rst 18h			;0a19	df 	. 
	jp l118eh		;0a1a	c3 8e 11 	. . . 
h_cpp_multipage:
	ld a,(0abf8h)		;0a1d	3a f8 ab 	: . . 
	add a,02fh		;0a20	c6 2f 	. / 
	ld c,a			;0a22	4f 	O 
	rst 18h			;0a23	df 	. 
	jp h_cursor_report		;0a24	c3 f1 09 	. . . 
sub_0a27h:
	ld a,(0aa9dh)		;0a27	3a 9d aa 	: . . 
	and a			;0a2a	a7 	. 
	ret nz			;0a2b	c0 	. 
	ld a,029h		;0a2c	3e 29 	> ) 
	ld (06001h),a		;0a2e	32 01 60 	2 . ` 
	ret			;0a31	c9 	. 
	ld hl,00700h		;0a32	21 00 07 	! . . 
	rst 20h			;0a35	e7 	. 
	ld c,0ffh		;0a36	0e ff 	. . 
	jr z,l0a3ch		;0a38	28 02 	( . 
	ld c,0e0h		;0a3a	0e e0 	. . 
l0a3ch:
	ld a,(0ac28h)		;0a3c	3a 28 ac 	: ( . 
	and c			;0a3f	a1 	. 
	ld e,a			;0a40	5f 	_ 
	ld a,(0ab2fh)		;0a41	3a 2f ab 	: / . 
	ld d,a			;0a44	57 	W 
	ret			;0a45	c9 	. 
l0a46h:
	ld b,00ah		;0a46	06 0a 	. . 
	ld hl,0ab3bh		;0a48	21 3b ab 	! ; . 
l0a4bh:
	ld (hl),a			;0a4b	77 	w 
	inc hl			;0a4c	23 	# 
	djnz l0a4bh		;0a4d	10 fc 	. . 
	ld (0ab3ah),a		;0a4f	32 3a ab 	2 : . 
	jp l0a83h		;0a52	c3 83 0a 	. . . 
	xor a			;0a55	af 	. 
	jp l0a46h		;0a56	c3 46 0a 	. F . 
	ld a,001h		;0a59	3e 01 	> . 
	jp l0a46h		;0a5b	c3 46 0a 	. F . 
l0a5eh:
	ld d,000h		;0a5e	16 00 	. . 
	ld hl,0ab3bh		;0a60	21 3b ab 	! ; . 
	ld a,(0abd7h)		;0a63	3a d7 ab 	: . . 
	ld e,a			;0a66	5f 	_ 
	srl e		;0a67	cb 3b 	. ; 
	srl e		;0a69	cb 3b 	. ; 
	srl e		;0a6b	cb 3b 	. ; 
	add hl,de			;0a6d	19 	. 
	and 007h		;0a6e	e6 07 	. . 
	ld b,001h		;0a70	06 01 	. . 
l0a72h:
	jr z,l0a79h		;0a72	28 05 	( . 
	sla b		;0a74	cb 20 	.   
	dec a			;0a76	3d 	= 
	jr l0a72h		;0a77	18 f9 	. . 
l0a79h:
	ld a,c			;0a79	79 	y 
	and a			;0a7a	a7 	. 
	ld a,b			;0a7b	78 	x 
	jr z,l0a95h		;0a7c	28 17 	( . 
	or (hl)			;0a7e	b6 	. 
l0a7fh:
	ld (hl),a			;0a7f	77 	w 
	call sub_0a99h		;0a80	cd 99 0a 	. . . 
l0a83h:
	ld a,(ram_setup_flags_b9)		;0a83	3a b9 aa 	: . . 
	bit 3,a		;0a86	cb 5f 	. _ 
	ret nz			;0a88	c0 	. 
	ld hl,05023h		;0a89	21 23 50 	! # P 
	ld de,05010h		;0a8c	11 10 50 	. . P 
	ld bc,0ab3bh		;0a8f	01 3b ab 	. ; . 
	jp l09a6h		;0a92	c3 a6 09 	. . . 
l0a95h:
	cpl			;0a95	2f 	/ 
	and (hl)			;0a96	a6 	. 
	jr l0a7fh		;0a97	18 e6 	. . 
sub_0a99h:
	ld b,009h		;0a99	06 09 	. . 
	ld hl,0ab3bh		;0a9b	21 3b ab 	! ; . 
	ld a,(hl)			;0a9e	7e 	~ 
l0a9fh:
	inc hl			;0a9f	23 	# 
	or (hl)			;0aa0	b6 	. 
	djnz l0a9fh		;0aa1	10 fc 	. . 
	ld (0ab3ah),a		;0aa3	32 3a ab 	2 : . 
	ret			;0aa6	c9 	. 
h_mode_on_pair:
h_ampex_esc_1_sib:
	ld c,0ffh		;0aa7	0e ff 	. . 
	jr l0a5eh		;0aa9	18 b3 	. . 
h_mode_off_pair:
	ld c,000h		;0aab	0e 00 	. . 
	jr l0a5eh		;0aad	18 af 	. . 
master_dispatcher:
	ld a,c			;0aaf	79 	y 
	and 07fh		;0ab0	e6 7f 	.  
	ld c,a			;0ab2	4f 	O 
	ld hl,ram_xlate_table		;0ab3	21 83 a9 	! . . 
	ld b,000h		;0ab6	06 00 	. . 
	add hl,bc			;0ab8	09 	. 
	ld a,(hl)			;0ab9	7e 	~ 
	ld hl,020aah		;0aba	21 aa 20 	! .   
l0abdh:
	ld e,a			;0abd	5f 	_ 
l0abeh:
	ld d,000h		;0abe	16 00 	. . 
	add hl,de			;0ac0	19 	. 
	add hl,de			;0ac1	19 	. 
	ld e,(hl)			;0ac2	5e 	^ 
	inc hl			;0ac3	23 	# 
	ld d,(hl)			;0ac4	56 	V 
	ex de,hl			;0ac5	eb 	. 
	jp (hl)			;0ac6	e9 	. 
	and 01fh		;0ac7	e6 1f 	. . 
	ld e,a			;0ac9	5f 	_ 
	ld hl,0aa03h		;0aca	21 03 aa 	! . . 
	ld d,000h		;0acd	16 00 	. . 
	add hl,de			;0acf	19 	. 
	ld e,(hl)			;0ad0	5e 	^ 
	ld hl,02074h		;0ad1	21 74 20 	! t   
	jr l0abeh		;0ad4	18 e8 	. . 
	cp 0e8h		;0ad6	fe e8 	. . 
	jp z,00b72h		;0ad8	ca 72 0b 	. r . 
	cp 0eah		;0adb	fe ea 	. . 
	ret nc			;0add	d0 	. 
	sub 0e0h		;0ade	d6 e0 	. . 
	ld c,a			;0ae0	4f 	O 
	ld b,000h		;0ae1	06 00 	. . 
	ld a,(0aa2bh)		;0ae3	3a 2b aa 	: + . 
	and 020h		;0ae6	e6 20 	.   
	jr z,l0afeh		;0ae8	28 14 	( . 
	ld a,c			;0aea	79 	y 
	cp 004h		;0aeb	fe 04 	. . 
	jr nc,l0b29h		;0aed	30 3a 	0 : 
	ld hl,00b5ah		;0aef	21 5a 0b 	! Z . 
	add hl,bc			;0af2	09 	. 
	ld a,(hl)			;0af3	7e 	~ 
l0af4h:
	push af			;0af4	f5 	. 
l0af5h:
	ld a,(ram_leadin_byte)		;0af5	3a 99 aa 	: . . 
	call sub_0b45h		;0af8	cd 45 0b 	. E . 
	pop af			;0afb	f1 	. 
	jr sub_0b45h		;0afc	18 47 	. G 
l0afeh:
	ld hl,00700h		;0afe	21 00 07 	! . . 
	rst 20h			;0b01	e7 	. 
	jr z,l0b1fh		;0b02	28 1b 	( . 
	ld hl,l0b5eh		;0b04	21 5e 0b 	! ^ . 
	add hl,bc			;0b07	09 	. 
	ld a,(hl)			;0b08	7e 	~ 
	bit 7,a		;0b09	cb 7f 	.  
	jr z,sub_0b45h		;0b0b	28 38 	( 8 
	and 07fh		;0b0d	e6 7f 	.  
	cp 00bh		;0b0f	fe 0b 	. . 
	jr nz,l0af4h		;0b11	20 e1 	  . 
	ld hl,00200h		;0b13	21 00 02 	! . . 
	rst 20h			;0b16	e7 	. 
	ld a,00bh		;0b17	3e 0b 	> . 
	jr z,l0af4h		;0b19	28 d9 	( . 
	ld a,00ah		;0b1b	3e 0a 	> . 
	jr sub_0b45h		;0b1d	18 26 	. & 
l0b1fh:
	ld a,(0aa2bh)		;0b1f	3a 2b aa 	: + . 
	and 014h		;0b22	e6 14 	. . 
	ld hl,l0b68h		;0b24	21 68 0b 	! h . 
	jr nz,l0b49h		;0b27	20 20 	    
l0b29h:
	ld hl,l0b50h		;0b29	21 50 0b 	! P . 
	add hl,bc			;0b2c	09 	. 
	ld a,(0aa2bh)		;0b2d	3a 2b aa 	: + . 
	and 080h		;0b30	e6 80 	. . 
	ld a,(hl)			;0b32	7e 	~ 
	jr z,sub_0b45h		;0b33	28 10 	( . 
	ld c,a			;0b35	4f 	O 
	cp 00ah		;0b36	fe 0a 	. . 
	jr nz,l0b3ch		;0b38	20 02 	  . 
	ld c,016h		;0b3a	0e 16 	. . 
l0b3ch:
	ld a,(0aabdh)		;0b3c	3a bd aa 	: . . 
	and 001h		;0b3f	e6 01 	. . 
	jp z,ring_put_data		;0b41	ca b6 17 	. . . 
	ld a,c			;0b44	79 	y 
sub_0b45h:
	ld c,a			;0b45	4f 	O 
	jp l1873h		;0b46	c3 73 18 	. s . 
l0b49h:
	ld hl,l0b68h		;0b49	21 68 0b 	! h . 
	add hl,bc			;0b4c	09 	. 
	ld a,(hl)			;0b4d	7e 	~ 
	jr sub_0b45h		;0b4e	18 f5 	. . 
l0b50h:
	dec bc			;0b50	0b 	. 
	ld a,(bc)			;0b51	0a 	. 
	ex af,af'			;0b52	08 	. 
	inc c			;0b53	0c 	. 
	ld e,01fh		;0b54	1e 1f 	. . 
	add hl,bc			;0b56	09 	. 
	dec c			;0b57	0d 	. 
	nop			;0b58	00 	. 
	ld e,041h		;0b59	1e 41 	. A 
	ld b,d			;0b5b	42 	B 
	ld b,h			;0b5c	44 	D 
	ld b,e			;0b5d	43 	C 
l0b5eh:
	adc a,h			;0b5e	8c 	. 
	adc a,e			;0b5f	8b 	. 
	ex af,af'			;0b60	08 	. 
	djnz l0af5h		;0b61	10 92 	. . 
	rra			;0b63	1f 	. 
	add hl,bc			;0b64	09 	. 
	dec c			;0b65	0d 	. 
	nop			;0b66	00 	. 
	sub d			;0b67	92 	. 
l0b68h:
	ld a,(de)			;0b68	1a 	. 
	ld a,(bc)			;0b69	0a 	. 
	ex af,af'			;0b6a	08 	. 
	ld b,001h		;0b6b	06 01 	. . 
	rra			;0b6d	1f 	. 
	add hl,bc			;0b6e	09 	. 
	dec c			;0b6f	0d 	. 
	nop			;0b70	00 	. 
	ld bc,032afh		;0b71	01 af 32 	. . 2 
	ld h,c			;0b74	61 	a 
	xor l			;0b75	ad 	. 
	jp 022a8h		;0b76	c3 a8 22 	. . " 
sub_0b79h:
	call sub_179ch		;0b79	cd 9c 17 	. . . 
	ld a,(0c000h)		;0b7c	3a 00 c0 	: . . 
	cp 010h		;0b7f	fe 10 	. . 
	ret			;0b81	c9 	. 
	call sub_0b79h		;0b82	cd 79 0b 	. y . 
	push af			;0b85	f5 	. 
	ld e,010h		;0b86	1e 10 	. . 
	call sub_0b9eh		;0b88	cd 9e 0b 	. . . 
	call sub_179ch		;0b8b	cd 9c 17 	. . . 
	ld a,(ram_displaymode)		;0b8e	3a d0 ab 	: . . 
	and 0e0h		;0b91	e6 e0 	. . 
	ld b,a			;0b93	47 	G 
	ld a,(0d000h)		;0b94	3a 00 d0 	: . . 
	and 0efh		;0b97	e6 ef 	. . 
	or b			;0b99	b0 	. 
	ld b,a			;0b9a	47 	G 
	pop af			;0b9b	f1 	. 
	ld a,b			;0b9c	78 	x 
	ret			;0b9d	c9 	. 
sub_0b9eh:
	call sub_179ch		;0b9e	cd 9c 17 	. . . 
	ld a,(0d000h)		;0ba1	3a 00 d0 	: . . 
	or 001h		;0ba4	f6 01 	. . 
	ld d,a			;0ba6	57 	W 
	ld a,(ram_displaymode)		;0ba7	3a d0 ab 	: . . 
	ld b,001h		;0baa	06 01 	. . 
	and 040h		;0bac	e6 40 	. @ 
	jr z,l0bb2h		;0bae	28 02 	( . 
	ld b,002h		;0bb0	06 02 	. . 
l0bb2h:
	push bc			;0bb2	c5 	. 
	call sub_177fh		;0bb3	cd 7f 17 	.  . 
	call 03085h		;0bb6	cd 85 30 	. . 0 
l0bb9h:
	pop bc			;0bb9	c1 	. 
	djnz l0bb2h		;0bba	10 f6 	. . 
	ret			;0bbc	c9 	. 
	ld c,a			;0bbd	4f 	O 
	ld e,a			;0bbe	5f 	_ 
	ld hl,l1fc2h		;0bbf	21 c2 1f 	! . . 
	ld b,000h		;0bc2	06 00 	. . 
	add hl,bc			;0bc4	09 	. 
	add hl,bc			;0bc5	09 	. 
	ld c,(hl)			;0bc6	4e 	N 
	ld a,(0aa2bh)		;0bc7	3a 2b aa 	: + . 
	bit 0,a		;0bca	cb 47 	. G 
	jr z,l0bd6h		;0bcc	28 08 	( . 
	inc hl			;0bce	23 	# 
	ld a,(hl)			;0bcf	7e 	~ 
	ld hl,l0bffh		;0bd0	21 ff 0b 	! . . 
	jp l0abdh		;0bd3	c3 bd 0a 	. . . 
l0bd6h:
	and 080h		;0bd6	e6 80 	. . 
	jr nz,l0be7h		;0bd8	20 0d 	  . 
	ld a,e			;0bda	7b 	{ 
	cp 015h		;0bdb	fe 15 	. . 
	jr c,l0c3dh		;0bdd	38 5e 	8 ^ 
	ld a,(0aa2bh)		;0bdf	3a 2b aa 	: + . 
	and 042h		;0be2	e6 42 	. B 
	ret z			;0be4	c8 	. 
	jr l0c3dh		;0be5	18 56 	. V 
l0be7h:
	ld a,c			;0be7	79 	y 
	cp 0bbh		;0be8	fe bb 	. . 
	jr z,l0bfbh		;0bea	28 0f 	( . 
	cp 0bah		;0bec	fe ba 	. . 
	jr nz,l0bf2h		;0bee	20 02 	  . 
	ld c,0aah		;0bf0	0e aa 	. . 
l0bf2h:
	ld a,(0aabdh)		;0bf2	3a bd aa 	: . . 
	and 001h		;0bf5	e6 01 	. . 
	jr z,l0c3dh		;0bf7	28 44 	( D 
	jr l0c10h		;0bf9	18 15 	. . 
l0bfbh:
	ld c,09ah		;0bfb	0e 9a 	. . 
	jr l0bf2h		;0bfd	18 f3 	. . 
l0bffh:
	djnz 14		;0bff	10 0c 	. . 
	add hl,bc			;0c01	09 	. 
	inc c			;0c02	0c 	. 
	jr nc,14		;0c03	30 0c 	0 . 
	ld d,b			;0c05	50 	P 
	inc c			;0c06	0c 	. 
	scf			;0c07	37 	7 
	inc c			;0c08	0c 	. 
	ld a,(0aabah)		;0c09	3a ba aa 	: . . 
	bit 2,a		;0c0c	cb 57 	. W 
	jr nz,l0c3dh		;0c0e	20 2d 	  - 
l0c10h:
	ld a,(ram_mode_flags)		;0c10	3a 29 aa 	: ) . 
	and 002h		;0c13	e6 02 	. . 
	push bc			;0c15	c5 	. 
	call z,l0c3dh		;0c16	cc 3d 0c 	. = . 
	pop bc			;0c19	c1 	. 
	ld a,(ram_mode_flags)		;0c1a	3a 29 aa 	: ) . 
	and 003h		;0c1d	e6 03 	. . 
	ret z			;0c1f	c8 	. 
	ld a,c			;0c20	79 	y 
	and 07fh		;0c21	e6 7f 	.  
	cp 020h		;0c23	fe 20 	.   
	jr c,l0c2eh		;0c25	38 07 	8 . 
	push bc			;0c27	c5 	. 
	ld a,(ram_leadin_byte)		;0c28	3a 99 aa 	: . . 
	ld c,a			;0c2b	4f 	O 
	rst 18h			;0c2c	df 	. 
	pop bc			;0c2d	c1 	. 
l0c2eh:
	rst 18h			;0c2e	df 	. 
	ret			;0c2f	c9 	. 
	ld a,0ffh		;0c30	3e ff 	> . 
	ld (0aa2fh),a		;0c32	32 2f aa 	2 / . 
	jr l0c3dh		;0c35	18 06 	. . 
	ld a,(ram_mode_flags)		;0c37	3a 29 aa 	: ) . 
	and 008h		;0c3a	e6 08 	. . 
	ret z			;0c3c	c8 	. 
l0c3dh:
	bit 7,c		;0c3d	cb 79 	. y 
	ld a,0ffh		;0c3f	3e ff 	> . 
	jr nz,l0c44h		;0c41	20 01 	  . 
	xor a			;0c43	af 	. 
l0c44h:
	ld (0ac20h),a		;0c44	32 20 ac 	2   . 
	res 7,c		;0c47	cb b9 	. . 
	ld a,(0aa2bh)		;0c49	3a 2b aa 	: + . 
	and 080h		;0c4c	e6 80 	. . 
	jr nz,l0c5fh		;0c4e	20 0f 	  . 
	ld a,c			;0c50	79 	y 
	ld hl,02014h		;0c51	21 14 20 	! .   
	sub 020h		;0c54	d6 20 	.   
	ld c,a			;0c56	4f 	O 
	add hl,bc			;0c57	09 	. 
	ld a,(hl)			;0c58	7e 	~ 
	ld hl,020aah		;0c59	21 aa 20 	! .   
	jp l0abdh		;0c5c	c3 bd 0a 	. . . 
l0c5fh:
	ld a,c			;0c5f	79 	y 
	cp 020h		;0c60	fe 20 	.   
	jr c,l0c66h		;0c62	38 02 	8 . 
	set 7,c		;0c64	cb f9 	. . 
l0c66h:
	jp ring_put_data		;0c66	c3 b6 17 	. . . 
	ld hl,0afffh		;0c69	21 ff af 	! . . 
l0c6ch:
	ld c,(hl)			;0c6c	4e 	N 
	ld a,055h		;0c6d	3e 55 	> U 
l0c6fh:
	ld (hl),a			;0c6f	77 	w 
	cp (hl)			;0c70	be 	. 
	jr nz,l0c7dh		;0c71	20 0a 	  . 
	rrca			;0c73	0f 	. 
	jr c,l0c6fh		;0c74	38 f9 	8 . 
	ld (hl),c			;0c76	71 	q 
	dec hl			;0c77	2b 	+ 
	bit 3,h		;0c78	cb 5c 	. \ 
	jr nz,l0c6ch		;0c7a	20 f0 	  . 
	ret			;0c7c	c9 	. 
l0c7dh:
	ld a,00ah		;0c7d	3e 0a 	> . 
	jr l0c9bh		;0c7f	18 1a 	. . 
	ld hl,053ffh		;0c81	21 ff 53 	! . S 
l0c84h:
	ld c,(hl)			;0c84	4e 	N 
	ld b,00ah		;0c85	06 0a 	. . 
l0c87h:
	ld (hl),b			;0c87	70 	p 
	ld a,(hl)			;0c88	7e 	~ 
	and 00fh		;0c89	e6 0f 	. . 
	cp b			;0c8b	b8 	. 
	jr nz,l0c99h		;0c8c	20 0b 	  . 
	rrc b		;0c8e	cb 08 	. . 
	jr nc,l0c87h		;0c90	30 f5 	0 . 
	ld (hl),c			;0c92	71 	q 
	dec hl			;0c93	2b 	+ 
	bit 3,h		;0c94	cb 5c 	. \ 
	jr z,l0c84h		;0c96	28 ec 	( . 
	ret			;0c98	c9 	. 
l0c99h:
	ld a,00bh		;0c99	3e 0b 	> . 
l0c9bh:
	ld (hl),c			;0c9b	71 	q 
	ld (0abe2h),a		;0c9c	32 e2 ab 	2 . . 
	ret			;0c9f	c9 	. 
	ld a,(0abfah)		;0ca0	3a fa ab 	: . . 
	ld b,a			;0ca3	47 	G 
	ld hl,reset_vector		;0ca4	21 00 00 	! . . 
	ld de,00800h		;0ca7	11 00 08 	. . . 
l0caah:
	add hl,de			;0caa	19 	. 
	djnz l0caah		;0cab	10 fd 	. . 
	ld e,055h		;0cad	1e 55 	. U 
l0cafh:
	ld d,e			;0caf	53 	S 
	push hl			;0cb0	e5 	. 
l0cb1h:
	dec hl			;0cb1	2b 	+ 
	ld (06006h),hl		;0cb2	22 06 60 	" . ` 
	call sub_1777h		;0cb5	cd 77 17 	. w . 
	call sub_17a0h		;0cb8	cd a0 17 	. . . 
	ld a,(0c000h)		;0cbb	3a 00 c0 	: . . 
	cp e			;0cbe	bb 	. 
	jr nz,l0cd1h		;0cbf	20 10 	  . 
	ld a,(0d000h)		;0cc1	3a 00 d0 	: . . 
	cp e			;0cc4	bb 	. 
	jr nz,l0cd1h		;0cc5	20 0a 	  . 
	ld a,h			;0cc7	7c 	| 
	or l			;0cc8	b5 	. 
	jr nz,l0cb1h		;0cc9	20 e6 	  . 
	pop hl			;0ccb	e1 	. 
	rrc e		;0ccc	cb 0b 	. . 
	jr c,l0cafh		;0cce	38 df 	8 . 
	ret			;0cd0	c9 	. 
l0cd1h:
	pop hl			;0cd1	e1 	. 
	ld a,009h		;0cd2	3e 09 	> . 
	ld (0abe2h),a		;0cd4	32 e2 ab 	2 . . 
	ret			;0cd7	c9 	. 
sub_0cd8h:
	ld a,(0aa2bh)		;0cd8	3a 2b aa 	: + . 
	and 0c0h		;0cdb	e6 c0 	. . 
	ret			;0cdd	c9 	. 
sub_0cdeh:
	ld a,(0aab7h)		;0cde	3a b7 aa 	: . . 
	bit 4,a		;0ce1	cb 67 	. g 
	ld a,(0abc5h)		;0ce3	3a c5 ab 	: . . 
	jr nz,l0cefh		;0ce6	20 07 	  . 
	and 0fah		;0ce8	e6 fa 	. . 
	ld (0abc5h),a		;0cea	32 c5 ab 	2 . . 
	jr l0cf9h		;0ced	18 0a 	. . 
l0cefh:
	and 0e3h		;0cef	e6 e3 	. . 
	or 001h		;0cf1	f6 01 	. . 
	ld (0abc5h),a		;0cf3	32 c5 ab 	2 . . 
	call sub_0d4bh		;0cf6	cd 4b 0d 	. K . 
l0cf9h:
	xor a			;0cf9	af 	. 
	ld (0abe2h),a		;0cfa	32 e2 ab 	2 . . 
	jp l0e5ch		;0cfd	c3 5c 0e 	. \ . 
sub_0d00h:
	ld a,(0aab8h)		;0d00	3a b8 aa 	: . . 
	and 004h		;0d03	e6 04 	. . 
	ret nz			;0d05	c0 	. 
	ld hl,0abf6h		;0d06	21 f6 ab 	! . . 
	ld a,(0acc6h)		;0d09	3a c6 ac 	: . . 
	and a			;0d0c	a7 	. 
	jr nz,l0d22h		;0d0d	20 13 	  . 
	res 7,(hl)		;0d0f	cb be 	. . 
	ld a,(hl)			;0d11	7e 	~ 
	cp 00ah		;0d12	fe 0a 	. . 
	ret c			;0d14	d8 	. 
	ld a,0ffh		;0d15	3e ff 	> . 
	ld (0acc6h),a		;0d17	32 c6 ac 	2 . . 
	call 0297ah		;0d1a	cd 7a 29 	. z ) 
	ld c,050h		;0d1d	0e 50 	. P 
	jp aux_ring_enq		;0d1f	c3 75 14 	. u . 
l0d22h:
	bit 7,(hl)		;0d22	cb 7e 	. ~ 
	ld (hl),000h		;0d24	36 00 	6 . 
	ret z			;0d26	c8 	. 
	xor a			;0d27	af 	. 
	ld (0acc6h),a		;0d28	32 c6 ac 	2 . . 
	ld (0aa9dh),a		;0d2b	32 9d aa 	2 . . 
	ld a,029h		;0d2e	3e 29 	> ) 
	ld (06001h),a		;0d30	32 01 60 	2 . ` 
	ld c,051h		;0d33	0e 51 	. Q 
	jp aux_ring_enq		;0d35	c3 75 14 	. u . 
sub_0d38h:
	res 7,d		;0d38	cb ba 	. . 
	ld a,e			;0d3a	7b 	{ 
	and a			;0d3b	a7 	. 
	jr nz,l0d40h		;0d3c	20 02 	  . 
	set 7,d		;0d3e	cb fa 	. . 
l0d40h:
	jp sub_1777h		;0d40	c3 77 17 	. w . 
	ld a,(0abc5h)		;0d43	3a c5 ab 	: . . 
	ld d,a			;0d46	57 	W 
	ld e,020h		;0d47	1e 20 	.   
	jr l0d56h		;0d49	18 0b 	. . 
sub_0d4bh:
	ld a,(0abc5h)		;0d4b	3a c5 ab 	: . . 
	ld d,a			;0d4e	57 	W 
	ld e,020h		;0d4f	1e 20 	.   
	ld b,050h		;0d51	06 50 	. P 
	ld hl,reset_vector		;0d53	21 00 00 	! . . 
l0d56h:
	rst 10h			;0d56	d7 	. 
	ld (06006h),hl		;0d57	22 06 60 	" . ` 
	call sub_1777h		;0d5a	cd 77 17 	. w . 
	inc hl			;0d5d	23 	# 
	djnz l0d56h		;0d5e	10 f6 	. . 
	ret			;0d60	c9 	. 
l0d61h:
	ld a,008h		;0d61	3e 08 	> . 
	jr sub_0d68h		;0d63	18 03 	. . 
sub_0d65h:
	ld a,(0abc5h)		;0d65	3a c5 ab 	: . . 
sub_0d68h:
	rst 10h			;0d68	d7 	. 
	ld (06006h),de		;0d69	ed 53 06 60 	. S . ` 
	push de			;0d6d	d5 	. 
	push af			;0d6e	f5 	. 
	ld d,a			;0d6f	57 	W 
	ld e,(hl)			;0d70	5e 	^ 
	call sub_0d38h		;0d71	cd 38 0d 	. 8 . 
	pop af			;0d74	f1 	. 
	pop de			;0d75	d1 	. 
	inc hl			;0d76	23 	# 
	inc de			;0d77	13 	. 
	djnz sub_0d68h		;0d78	10 ee 	. . 
	ret			;0d7a	c9 	. 
sub_0d7bh:
	call sub_0d00h		;0d7b	cd 00 0d 	. . . 
	ld a,(0abc5h)		;0d7e	3a c5 ab 	: . . 
	bit 0,a		;0d81	cb 47 	. G 
	jr nz,l0d9dh		;0d83	20 18 	  . 
	bit 2,a		;0d85	cb 57 	. W 
	ld a,(0aa8ah)		;0d87	3a 8a aa 	: . . 
	jr nz,l0dbfh		;0d8a	20 33 	  3 
	bit 5,a		;0d8c	cb 6f 	. o 
	jr nz,l0dc4h		;0d8e	20 34 	  4 
	bit 4,a		;0d90	cb 67 	. g 
	jr z,l0dc9h		;0d92	28 35 	( 5 
	bit 7,a		;0d94	cb 7f 	.  
	jr z,l0dcfh		;0d96	28 37 	( 7 
	call 0256ah		;0d98	cd 6a 25 	. j % 
	jr l0dd4h		;0d9b	18 37 	. 7 
l0d9dh:
	ld a,(0aa8ah)		;0d9d	3a 8a aa 	: . . 
	bit 5,a		;0da0	cb 6f 	. o 
	ret z			;0da2	c8 	. 
	ld a,(0aab7h)		;0da3	3a b7 aa 	: . . 
	bit 5,a		;0da6	cb 6f 	. o 
	ret nz			;0da8	c0 	. 
	ld a,(0abc5h)		;0da9	3a c5 ab 	: . . 
	and 004h		;0dac	e6 04 	. . 
	call z,sub_0db3h		;0dae	cc b3 0d 	. . . 
	jr l0de1h		;0db1	18 2e 	. . 
sub_0db3h:
	ld a,(0abc5h)		;0db3	3a c5 ab 	: . . 
	or 01ch		;0db6	f6 1c 	. . 
	and 0feh		;0db8	e6 fe 	. . 
	ld (0abc5h),a		;0dba	32 c5 ab 	2 . . 
	jr sub_0d4bh		;0dbd	18 8c 	. . 
l0dbfh:
	bit 5,a		;0dbf	cb 6f 	. o 
	jr nz,l0de1h		;0dc1	20 1e 	  . 
	ret			;0dc3	c9 	. 
l0dc4h:
	call sub_0db3h		;0dc4	cd b3 0d 	. . . 
	jr l0de1h		;0dc7	18 18 	. . 
l0dc9h:
	bit 6,a		;0dc9	cb 77 	. w 
	jp nz,026e6h		;0dcb	c2 e6 26 	. . & 
	ret			;0dce	c9 	. 
l0dcfh:
	and 00fh		;0dcf	e6 0f 	. . 
	call nz,02598h		;0dd1	c4 98 25 	. . % 
l0dd4h:
	ld hl,0ac68h		;0dd4	21 68 ac 	! h . 
	dec (hl)			;0dd7	35 	5 
	ret nz			;0dd8	c0 	. 
	ld (hl),00fh		;0dd9	36 0f 	6 . 
	call sub_0f23h		;0ddb	cd 23 0f 	. # . 
	jp l0f6ah		;0dde	c3 6a 0f 	. j . 
l0de1h:
	ld a,(0abe2h)		;0de1	3a e2 ab 	: . . 
	bit 3,a		;0de4	cb 5f 	. _ 
	jr z,l0e0ah		;0de6	28 22 	( " 
	and 007h		;0de8	e6 07 	. . 
	rlca			;0dea	07 	. 
	ld b,a			;0deb	47 	G 
	rlca			;0dec	07 	. 
	add a,b			;0ded	80 	. 
	ld e,a			;0dee	5f 	_ 
	ld d,000h		;0def	16 00 	. . 
	ld hl,00ee7h		;0df1	21 e7 0e 	! . . 
	add hl,de			;0df4	19 	. 
	ld de,l000ah		;0df5	11 0a 00 	. . . 
	ld b,006h		;0df8	06 06 	. . 
	call sub_0d65h		;0dfa	cd 65 0d 	. e . 
	ld hl,l0ecch		;0dfd	21 cc 0e 	! . . 
	ld de,reset_vector		;0e00	11 00 00 	. . . 
	ld b,009h		;0e03	06 09 	. . 
	call sub_0d65h		;0e05	cd 65 0d 	. e . 
	jr l0e2dh		;0e08	18 23 	. # 
l0e0ah:
	ld a,(0abe2h)		;0e0a	3a e2 ab 	: . . 
	and 007h		;0e0d	e6 07 	. . 
l0e0fh:
	jr z,l0e2dh		;0e0f	28 1c 	( . 
	rlca			;0e11	07 	. 
	rlca			;0e12	07 	. 
	ld e,a			;0e13	5f 	_ 
	ld d,000h		;0e14	16 00 	. . 
	ld hl,00eb4h		;0e16	21 b4 0e 	! . . 
	add hl,de			;0e19	19 	. 
	ld de,00027h		;0e1a	11 27 00 	. ' . 
	ld b,004h		;0e1d	06 04 	. . 
	call sub_0d65h		;0e1f	cd 65 0d 	. e . 
	ld hl,00ed5h		;0e22	21 d5 0e 	! . . 
	ld de,l001dh+1		;0e25	11 1e 00 	. . . 
	ld b,009h		;0e28	06 09 	. . 
	call sub_0d65h		;0e2a	cd 65 0d 	. e . 
l0e2dh:
	ld a,(0abe2h)		;0e2d	3a e2 ab 	: . . 
	and 070h		;0e30	e6 70 	. p 
	jr z,l0e5ch		;0e32	28 28 	( ( 
	ld c,003h		;0e34	0e 03 	. . 
	ld hl,l0each		;0e36	21 ac 0e 	! . . 
	ld de,00043h		;0e39	11 43 00 	. C . 
l0e3ch:
	bit 4,a		;0e3c	cb 67 	. g 
	rrca			;0e3e	0f 	. 
	jr z,l0e4ah		;0e3f	28 09 	( . 
	push af			;0e41	f5 	. 
	ld b,004h		;0e42	06 04 	. . 
	call sub_0d65h		;0e44	cd 65 0d 	. e . 
	pop af			;0e47	f1 	. 
	jr l0e4eh		;0e48	18 04 	. . 
l0e4ah:
	inc hl			;0e4a	23 	# 
	inc hl			;0e4b	23 	# 
	inc hl			;0e4c	23 	# 
	inc hl			;0e4d	23 	# 
l0e4eh:
	dec c			;0e4e	0d 	. 
	jr nz,l0e3ch		;0e4f	20 eb 	  . 
	ld hl,str_err_rom+1		;0e51	21 de 0e 	! . . 
	ld de,l003ah		;0e54	11 3a 00 	. : . 
	ld b,009h		;0e57	06 09 	. . 
	call sub_0d65h		;0e59	cd 65 0d 	. e . 
l0e5ch:
	ld a,(0aa8ah)		;0e5c	3a 8a aa 	: . . 
	or 0c0h		;0e5f	f6 c0 	. . 
	and 0dfh		;0e61	e6 df 	. . 
	ld (0aa8ah),a		;0e63	32 8a aa 	2 . . 
	ret			;0e66	c9 	. 
tbl_status_vocab:
	ld e,b			;0e67	58 	X 
	ld c,l			;0e68	4d 	M 
	ld c,c			;0e69	49 	I 
	ld d,h			;0e6a	54 	T 
	jr nz,l0ec4h		;0e6b	20 57 	  W 
	ld d,b			;0e6d	50 	P 
	ld d,h			;0e6e	54 	T 
	ld b,c			;0e6f	41 	A 
	ld d,h			;0e70	54 	T 
	ld b,d			;0e71	42 	B 
	ld b,(hl)			;0e72	46 	F 
	ld c,h			;0e73	4c 	L 
	ld d,b			;0e74	50 	P 
	ld b,l			;0e75	45 	E 
	ld d,b			;0e76	50 	P 
	ld b,a			;0e77	47 	G 
	ld d,e			;0e78	53 	S 
	ld d,e			;0e79	53 	S 
	ld b,e			;0e7a	43 	C 
	ld d,b			;0e7b	50 	P 
	ld d,d			;0e7c	52 	R 
	ld d,h			;0e7d	54 	T 
	ld d,b			;0e7e	50 	P 
	ld b,a			;0e7f	47 	G 
	ld c,e			;0e80	4b 	K 
	ld c,l			;0e81	4d 	M 
	ld c,a			;0e82	4f 	O 
	ld c,(hl)			;0e83	4e 	N 
	ld b,d			;0e84	42 	B 
	ld d,l			;0e85	55 	U 
	ld b,(hl)			;0e86	46 	F 
	ld d,d			;0e87	52 	R 
	ld c,b			;0e88	48 	H 
	ld d,b			;0e89	50 	P 
	ld d,h			;0e8a	54 	T 
str_time_prefix:
	ld b,a			;0e8b	47 	G 
	ld d,h			;0e8c	54 	T 
	ld d,b			;0e8d	50 	P 
	ld d,d			;0e8e	52 	R 
	ld b,e			;0e8f	43 	C 
	ld d,b			;0e90	50 	P 
	ld d,b			;0e91	50 	P 
	ld d,l			;0e92	55 	U 
	ld b,(hl)			;0e93	46 	F 
	ld d,b			;0e94	50 	P 
	ld c,h			;0e95	4c 	L 
	ld c,e			;0e96	4b 	K 
str_par_ovr:
	ld d,h			;0e97	54 	T 
	ld c,c			;0e98	49 	I 
	ld c,l			;0e99	4d 	M 
	ld b,l			;0e9a	45 	E 
	ld a,(02020h)		;0e9b	3a 20 20 	:     
	dec l			;0e9e	2d 	- 
	ld b,c			;0e9f	41 	A 
	ld d,h			;0ea0	54 	T 
	ld b,d			;0ea1	42 	B 
	ld a,(04f4dh)		;0ea2	3a 4d 4f 	: M O 
	ld b,h			;0ea5	44 	D 
	ld b,l			;0ea6	45 	E 
	ld a,(0202dh)		;0ea7	3a 2d 20 	: -   
	jr nz,l0ed9h		;0eaa	20 2d 	  - 
l0each:
	ld d,b			;0eac	50 	P 
str_mode:
	ld b,c			;0ead	41 	A 
	ld d,d			;0eae	52 	R 
	jr nz,81		;0eaf	20 4f 	  O 
	ld d,(hl)			;0eb1	56 	V 
	ld d,d			;0eb2	52 	R 
	jr nz,l0efbh		;0eb3	20 46 	  F 
	ld d,d			;0eb5	52 	R 
	ld b,c			;0eb6	41 	A 
	jr nz,l0efdh		;0eb7	20 44 	  D 
	ld d,a			;0eb9	57 	W 
	ld c,h			;0eba	4c 	L 
	ld b,h			;0ebb	44 	D 
	ld c,l			;0ebc	4d 	M 
	ld c,a			;0ebd	4f 	O 
str_err_comp:
	ld b,h			;0ebe	44 	D 
	ld b,l			;0ebf	45 	E 
	ld d,b			;0ec0	50 	P 
	ld d,d			;0ec1	52 	R 
	ld c,a			;0ec2	4f 	O 
	ld b,a			;0ec3	47 	G 
l0ec4h:
	ld b,e			;0ec4	43 	C 
	ld d,l			;0ec5	55 	U 
	ld d,d			;0ec6	52 	R 
	ld d,e			;0ec7	53 	S 
	ld d,b			;0ec8	50 	P 
	ld d,d			;0ec9	52 	R 
	ld c,a			;0eca	4f 	O 
	ld d,h			;0ecb	54 	T 
l0ecch:
	ld b,d			;0ecc	42 	B 
	ld b,c			;0ecd	41 	A 
	ld b,h			;0ece	44 	D 
	jr nz,69		;0ecf	20 43 	  C 
	ld c,a			;0ed1	4f 	O 
	ld c,l			;0ed2	4d 	M 
	ld d,b			;0ed3	50 	P 
	ld a,(0504fh)		;0ed4	3a 4f 50 	: O P 
	ld b,l			;0ed7	45 	E 
	ld d,d			;0ed8	52 	R 
l0ed9h:
	jr nz,71		;0ed9	20 45 	  E 
	ld d,d			;0edb	52 	R 
	ld d,d			;0edc	52 	R 
str_err_rom:
	ld a,(04f43h)		;0edd	3a 43 4f 	: C O 
	ld c,l			;0ee0	4d 	M 
	ld c,l			;0ee1	4d 	M 
	jr nz,71		;0ee2	20 45 	  E 
	ld d,d			;0ee4	52 	R 
	ld d,d			;0ee5	52 	R 
	ld a,(04f52h)		;0ee6	3a 52 4f 	: R O 
	ld c,l			;0ee9	4d 	M 
	jr nz,l0f0ch		;0eea	20 20 	    
	jr nz,l0f32h		;0eec	20 44 	  D 
	ld c,c			;0eee	49 	I 
	ld d,e			;0eef	53 	S 
	ld d,d			;0ef0	52 	R 
	ld b,c			;0ef1	41 	A 
	ld c,l			;0ef2	4d 	M 
	ld b,h			;0ef3	44 	D 
	ld b,c			;0ef4	41 	A 
	ld d,h			;0ef5	54 	T 
	ld d,d			;0ef6	52 	R 
	ld b,c			;0ef7	41 	A 
	ld c,l			;0ef8	4d 	M 
	ld b,e			;0ef9	43 	C 
	ld c,l			;0efa	4d 	M 
l0efbh:
	ld c,a			;0efb	4f 	O 
	ld d,d			;0efc	52 	R 
l0efdh:
	ld b,c			;0efd	41 	A 
	ld c,l			;0efe	4d 	M 
	ld c,004h		;0eff	0e 04 	. . 
	jr l0f05h		;0f01	18 02 	. . 
l0f03h:
	ld c,002h		;0f03	0e 02 	. . 
l0f05h:
	ld hl,0abe2h		;0f05	21 e2 ab 	! . . 
	ld a,(hl)			;0f08	7e 	~ 
	and 0f0h		;0f09	e6 f0 	. . 
	or c			;0f0b	b1 	. 
l0f0ch:
	ld (hl),a			;0f0c	77 	w 
sub_0f0dh:
	ld hl,0aa8ah		;0f0d	21 8a aa 	! . . 
	set 5,(hl)		;0f10	cb ee 	. . 
	ret			;0f12	c9 	. 
sub_0f13h:
	ld l,030h		;0f13	2e 30 	. 0 
	inc a			;0f15	3c 	< 
l0f16h:
	cp 00ah		;0f16	fe 0a 	. . 
	jr c,l0f1fh		;0f18	38 05 	8 . 
	sub 00ah		;0f1a	d6 0a 	. . 
	inc l			;0f1c	2c 	, 
	jr l0f16h		;0f1d	18 f7 	. . 
l0f1fh:
	add a,030h		;0f1f	c6 30 	. 0 
	ld h,a			;0f21	67 	g 
	ret			;0f22	c9 	. 
sub_0f23h:
	ld a,(0ad68h)		;0f23	3a 68 ad 	: h . 
	and a			;0f26	a7 	. 
	ld a,(0abd8h)		;0f27	3a d8 ab 	: . . 
	jr z,l0f40h		;0f2a	28 14 	( . 
	ld hl,0ac09h		;0f2c	21 09 ac 	! . . 
	ld d,000h		;0f2f	16 00 	. . 
	ld e,(hl)			;0f31	5e 	^ 
l0f32h:
	ld hl,(0ac1eh)		;0f32	2a 1e ac 	* . . 
	add hl,de			;0f35	19 	. 
	ld b,a			;0f36	47 	G 
	inc b			;0f37	04 	. 
l0f38h:
	bit 7,(hl)		;0f38	cb 7e 	. ~ 
	jr z,l0f3dh		;0f3a	28 01 	( . 
	dec a			;0f3c	3d 	= 
l0f3dh:
	inc hl			;0f3d	23 	# 
	djnz l0f38h		;0f3e	10 f8 	. . 
l0f40h:
	ld hl,0ac09h		;0f40	21 09 ac 	! . . 
	add a,(hl)			;0f43	86 	. 
	call sub_0f13h		;0f44	cd 13 0f 	. . . 
	ld (0abf0h),hl		;0f47	22 f0 ab 	" . . 
	ld a,(0abd7h)		;0f4a	3a d7 ab 	: . . 
	call sub_0f13h		;0f4d	cd 13 0f 	. . . 
	ld (0abf2h),hl		;0f50	22 f2 ab 	" . . 
	ld a,(0abf8h)		;0f53	3a f8 ab 	: . . 
	dec a			;0f56	3d 	= 
	call sub_0f13h		;0f57	cd 13 0f 	. . . 
	ld a,h			;0f5a	7c 	| 
	ld hl,0abefh		;0f5b	21 ef ab 	! . . 
	ld (hl),a			;0f5e	77 	w 
	ld de,l0049h		;0f5f	11 49 00 	. I . 
	ld b,001h		;0f62	06 01 	. . 
	call sub_0d65h		;0f64	cd 65 0d 	. e . 
	inc de			;0f67	13 	. 
	jr l0f70h		;0f68	18 06 	. . 
l0f6ah:
	ld de,l000fh		;0f6a	11 0f 00 	. . . 
	ld hl,0aaa6h		;0f6d	21 a6 aa 	! . . 
l0f70h:
	ld b,002h		;0f70	06 02 	. . 
	call sub_0d65h		;0f72	cd 65 0d 	. e . 
	inc de			;0f75	13 	. 
	ld b,002h		;0f76	06 02 	. . 
	jp sub_0d65h		;0f78	c3 65 0d 	. e . 
l0f7bh:
	ld a,008h		;0f7b	3e 08 	> . 
	jr l0f89h		;0f7d	18 0a 	. . 
l0f7fh:
	ld a,004h		;0f7f	3e 04 	> . 
	jr l0f89h		;0f81	18 06 	. . 
l0f83h:
	ld a,002h		;0f83	3e 02 	> . 
	jr l0f89h		;0f85	18 02 	. . 
l0f87h:
	ld a,001h		;0f87	3e 01 	> . 
l0f89h:
	ld hl,0aa8ah		;0f89	21 8a aa 	! . . 
	or (hl)			;0f8c	b6 	. 
	ld (hl),a			;0f8d	77 	w 
	ret			;0f8e	c9 	. 
sub_0f8fh:
	ld hl,(0abe7h)		;0f8f	2a e7 ab 	* . . 
	ld (0abe3h),hl		;0f92	22 e3 ab 	" . . 
	ld bc,(0abdbh)		;0f95	ed 4b db ab 	. K . . 
	call sub_0fb3h		;0f99	cd b3 0f 	. . . 
	ld (0abdbh),bc		;0f9c	ed 43 db ab 	. C . . 
	ret			;0fa0	c9 	. 
sub_0fa1h:
	ld hl,(0abe5h)		;0fa1	2a e5 ab 	* . . 
	ld (0abe3h),hl		;0fa4	22 e3 ab 	" . . 
	ld bc,(0abd9h)		;0fa7	ed 4b d9 ab 	. K . . 
	call sub_0fb3h		;0fab	cd b3 0f 	. . . 
	ld (0abd9h),bc		;0fae	ed 43 d9 ab 	. C . . 
	ret			;0fb2	c9 	. 
sub_0fb3h:
	ld hl,(0ad69h)		;0fb3	2a 69 ad 	* i . 
	xor a			;0fb6	af 	. 
	ld e,b			;0fb7	58 	X 
	ld d,000h		;0fb8	16 00 	. . 
	add hl,de			;0fba	19 	. 
l0fbbh:
	bit 7,(hl)		;0fbb	cb 7e 	. ~ 
	jr z,l0fc4h		;0fbd	28 05 	( . 
	inc b			;0fbf	04 	. 
	ld c,a			;0fc0	4f 	O 
	inc hl			;0fc1	23 	# 
	jr l0fbbh		;0fc2	18 f7 	. . 
l0fc4h:
	ld a,(hl)			;0fc4	7e 	~ 
	call 03d35h		;0fc5	cd 35 3d 	. 5 = 
	ld l,c			;0fc8	69 	i 
	ld h,000h		;0fc9	26 00 	& . 
	add hl,de			;0fcb	19 	. 
	ld (06006h),hl		;0fcc	22 06 60 	" . ` 
	ret			;0fcf	c9 	. 
sub_0fd0h:
	inc c			;0fd0	0c 	. 
	ld a,c			;0fd1	79 	y 
	cp 050h		;0fd2	fe 50 	. P 
	jr nc,l0fddh		;0fd4	30 07 	0 . 
	call sub_0fb3h		;0fd6	cd b3 0f 	. . . 
	ld e,000h		;0fd9	1e 00 	. . 
	jr l0fe5h		;0fdb	18 08 	. . 
l0fddh:
	inc b			;0fdd	04 	. 
	ld c,000h		;0fde	0e 00 	. . 
	call sub_0fb3h		;0fe0	cd b3 0f 	. . . 
	ld e,001h		;0fe3	1e 01 	. . 
l0fe5h:
	ld a,(0abe4h)		;0fe5	3a e4 ab 	: . . 
	cp b			;0fe8	b8 	. 
	ld a,e			;0fe9	7b 	{ 
	jr c,l0ff3h		;0fea	38 07 	8 . 
	ret nz			;0fec	c0 	. 
	ld a,(0abe3h)		;0fed	3a e3 ab 	: . . 
	cp c			;0ff0	b9 	. 
	ld a,e			;0ff1	7b 	{ 
	ret nc			;0ff2	d0 	. 
l0ff3h:
	ld a,002h		;0ff3	3e 02 	> . 
	ret			;0ff5	c9 	. 
sub_0ff6h:
	ld bc,(0abd9h)		;0ff6	ed 4b d9 ab 	. K . . 
	call sub_0fd0h		;0ffa	cd d0 0f 	. . . 
	ld (0abd9h),bc		;0ffd	ed 43 d9 ab 	. C . . 
	dec a			;1001	3d 	= 
	jr nz,l100dh		;1002	20 09 	  . 
	push af			;1004	f5 	. 
l1005h:
	ld bc,(0ad6dh)		;1005	ed 4b 6d ad 	. K m . 
	call sub_11a1h		;1009	cd a1 11 	. . . 
	pop af			;100c	f1 	. 
l100dh:
	dec a			;100d	3d 	= 
	ret			;100e	c9 	. 
sub_100fh:
	bit 7,c		;100f	cb 79 	. y 
	ret z			;1011	c8 	. 
	ld a,c			;1012	79 	y 
	sub 0cfh		;1013	d6 cf 	. . 
	jr c,l1020h		;1015	38 09 	8 . 
	ld e,a			;1017	5f 	_ 
	ld d,000h		;1018	16 00 	. . 
	ld hl,tbl_gfx_chars_big		;101a	21 23 10 	! # . 
	add hl,de			;101d	19 	. 
	ld c,(hl)			;101e	4e 	N 
	ret			;101f	c9 	. 
l1020h:
	ld c,020h		;1020	0e 20 	.   
	ret			;1022	c9 	. 
tbl_gfx_chars_big:
	inc hl			;1023	23 	# 
	inc hl			;1024	23 	# 
	inc h			;1025	24 	$ 
	inc h			;1026	24 	$ 
	ld b,b			;1027	40 	@ 
	ld b,b			;1028	40 	@ 
	ld b,b			;1029	40 	@ 
	ld b,b			;102a	40 	@ 
	ld e,e			;102b	5b 	[ 
	ld e,e			;102c	5b 	[ 
	ld e,e			;102d	5b 	[ 
	ld e,e			;102e	5b 	[ 
	ld e,e			;102f	5b 	[ 
	ld e,h			;1030	5c 	\ 
	ld e,h			;1031	5c 	\ 
	ld e,h			;1032	5c 	\ 
	ld e,h			;1033	5c 	\ 
	ld e,h			;1034	5c 	\ 
	ld e,l			;1035	5d 	] 
	ld e,l			;1036	5d 	] 
	ld e,l			;1037	5d 	] 
	ld e,l			;1038	5d 	] 
	ld e,l			;1039	5d 	] 
	ld e,l			;103a	5d 	] 
	ld e,(hl)			;103b	5e 	^ 
	ld e,(hl)			;103c	5e 	^ 
	ld h,b			;103d	60 	` 
	ld h,b			;103e	60 	` 
	ld h,b			;103f	60 	` 
	ld a,e			;1040	7b 	{ 
	ld a,e			;1041	7b 	{ 
	ld a,e			;1042	7b 	{ 
	ld a,e			;1043	7b 	{ 
	ld a,e			;1044	7b 	{ 
	ld a,h			;1045	7c 	| 
	ld a,h			;1046	7c 	| 
	ld a,h			;1047	7c 	| 
	ld a,h			;1048	7c 	| 
	ld a,h			;1049	7c 	| 
	ld a,h			;104a	7c 	| 
	ld a,l			;104b	7d 	} 
	ld a,l			;104c	7d 	} 
	ld a,l			;104d	7d 	} 
	ld a,l			;104e	7d 	} 
	ld a,(hl)			;104f	7e 	~ 
	ld a,(hl)			;1050	7e 	~ 
	ld a,(hl)			;1051	7e 	~ 
	ld a,(hl)			;1052	7e 	~ 
	ld a,(hl)			;1053	7e 	~ 
sub_1054h:
	ld a,(0d000h)		;1054	3a 00 d0 	: . . 
	and 00fh		;1057	e6 0f 	. . 
	ld (0abe0h),a		;1059	32 e0 ab 	2 . . 
	ld hl,0abe1h		;105c	21 e1 ab 	! . . 
	ld b,(hl)			;105f	46 	F 
	xor b			;1060	a8 	. 
	ld de,reset_vector		;1061	11 00 00 	. . . 
l1064h:
	jr z,l108ah		;1064	28 24 	( $ 
	bit 0,a		;1066	cb 47 	. G 
	ld c,a			;1068	4f 	O 
	jr z,l107fh		;1069	28 14 	( . 
	push de			;106b	d5 	. 
	and b			;106c	a0 	. 
	bit 0,a		;106d	cb 47 	. G 
	jr z,l1072h		;106f	28 01 	( . 
	inc de			;1071	13 	. 
l1072h:
	ld hl,tbl_gfx_chars_small		;1072	21 91 10 	! . . 
	add hl,de			;1075	19 	. 
	push bc			;1076	c5 	. 
	ld c,01ch		;1077	0e 1c 	. . 
	ld b,(hl)			;1079	46 	F 
	call sub_11a1h		;107a	cd a1 11 	. . . 
	pop bc			;107d	c1 	. 
	pop de			;107e	d1 	. 
l107fh:
	inc de			;107f	13 	. 
	inc de			;1080	13 	. 
	res 0,e		;1081	cb 83 	. . 
	ld a,c			;1083	79 	y 
	srl b		;1084	cb 38 	. 8 
	srl a		;1086	cb 3f 	. ? 
	jr l1064h		;1088	18 da 	. . 
l108ah:
	ld a,(0abe0h)		;108a	3a e0 ab 	: . . 
	ld (0abe1h),a		;108d	32 e1 ab 	2 . . 
	ret			;1090	c9 	. 
tbl_gfx_chars_small:
	ld (hl),b			;1091	70 	p 
	ld (hl),c			;1092	71 	q 
	ld l,h			;1093	6c 	l 
	ld l,l			;1094	6d 	m 
	ld l,(hl)			;1095	6e 	n 
	ld l,a			;1096	6f 	o 
	ld l,d			;1097	6a 	j 
	ld l,e			;1098	6b 	k 
sub_1099h:
	ld a,(0d000h)		;1099	3a 00 d0 	: . . 
	and 010h		;109c	e6 10 	. . 
	ld (0abdfh),a		;109e	32 df ab 	2 . . 
	ld hl,0abdeh		;10a1	21 de ab 	! . . 
	cp (hl)			;10a4	be 	. 
	ret z			;10a5	c8 	. 
	ld a,(0abd3h)		;10a6	3a d3 ab 	: . . 
	and a			;10a9	a7 	. 
	ld a,(0aa2bh)		;10aa	3a 2b aa 	: + . 
	jr z,l10c8h		;10ad	28 19 	( . 
	and 0c1h		;10af	e6 c1 	. . 
	ret z			;10b1	c8 	. 
	ld a,(hl)			;10b2	7e 	~ 
	and a			;10b3	a7 	. 
	ld bc,(0ad71h)		;10b4	ed 4b 71 ad 	. K q . 
	jr nz,l10beh		;10b8	20 04 	  . 
	ld bc,(0ad6fh)		;10ba	ed 4b 6f ad 	. K o . 
l10beh:
	call sub_11a1h		;10be	cd a1 11 	. . . 
	ld a,(0abdfh)		;10c1	3a df ab 	: . . 
l10c4h:
	ld (0abdeh),a		;10c4	32 de ab 	2 . . 
	ret			;10c7	c9 	. 
l10c8h:
	and 002h		;10c8	e6 02 	. . 
	or (hl)			;10ca	b6 	. 
	jr nz,l10d4h		;10cb	20 07 	  . 
	ld bc,(0ad6bh)		;10cd	ed 4b 6b ad 	. K k . 
	call sub_11a1h		;10d1	cd a1 11 	. . . 
l10d4h:
	call sub_0ff6h		;10d4	cd f6 0f 	. . . 
	ret z			;10d7	c8 	. 
	call sub_17a0h		;10d8	cd a0 17 	. . . 
	ld a,(0d000h)		;10db	3a 00 d0 	: . . 
	and 010h		;10de	e6 10 	. . 
	jr z,l10c4h		;10e0	28 e2 	( . 
	jr l10d4h		;10e2	18 f0 	. . 
	ld a,(0abddh)		;10e4	3a dd ab 	: . . 
	and a			;10e7	a7 	. 
	ret z			;10e8	c8 	. 
	call sub_152fh		;10e9	cd 2f 15 	. / . 
	ret nc			;10ec	d0 	. 
	call sub_0fa1h		;10ed	cd a1 0f 	. . . 
	ld b,00fh		;10f0	06 0f 	. . 
l10f2h:
	ld a,(0aa8ch)		;10f2	3a 8c aa 	: . . 
	and 082h		;10f5	e6 82 	. . 
	cp 082h		;10f7	fe 82 	. . 
	ret z			;10f9	c8 	. 
	call sub_152fh		;10fa	cd 2f 15 	. / . 
	ret nc			;10fd	d0 	. 
	push bc			;10fe	c5 	. 
	call sub_17a0h		;10ff	cd a0 17 	. . . 
	ld a,(0ad7ch)		;1102	3a 7c ad 	: | . 
	and a			;1105	a7 	. 
	jr nz,l1168h		;1106	20 60 	  ` 
	call sub_1099h		;1108	cd 99 10 	. . . 
	ld a,(0aa2bh)		;110b	3a 2b aa 	: + . 
	and 001h		;110e	e6 01 	. . 
	call nz,sub_1054h		;1110	c4 54 10 	. T . 
l1113h:
	call sub_1359h		;1113	cd 59 13 	. Y . 
	ld a,c			;1116	79 	y 
	sub 0c0h		;1117	d6 c0 	. . 
	jr c,l1128h		;1119	38 0d 	8 . 
	cp 00bh		;111b	fe 0b 	. . 
	jr nc,l1128h		;111d	30 09 	0 . 
	ld hl,l11aah		;111f	21 aa 11 	! . . 
	add a,l			;1122	85 	. 
	ld l,a			;1123	6f 	o 
	jr nc,l1127h		;1124	30 01 	0 . 
	inc h			;1126	24 	$ 
l1127h:
	ld c,(hl)			;1127	4e 	N 
l1128h:
	call sub_100fh		;1128	cd 0f 10 	. . . 
	ld a,(0aa9ch)		;112b	3a 9c aa 	: . . 
	and a			;112e	a7 	. 
	jr nz,l1177h		;112f	20 46 	  F 
l1131h:
	ld a,c			;1131	79 	y 
	ld d,020h		;1132	16 20 	.   
	cp d			;1134	ba 	. 
	jr nc,l1141h		;1135	30 0a 	0 . 
	add a,d			;1137	82 	. 
	push af			;1138	f5 	. 
	ld c,01dh		;1139	0e 1d 	. . 
	cp d			;113b	ba 	. 
	call nz,l1552h		;113c	c4 52 15 	. R . 
	pop af			;113f	f1 	. 
	ld c,a			;1140	4f 	O 
l1141h:
	rst 18h			;1141	df 	. 
	call sub_0ff6h		;1142	cd f6 0f 	. . . 
	jr nz,l1164h		;1145	20 1d 	  . 
	ld a,(0aa9ch)		;1147	3a 9c aa 	: . . 
	and a			;114a	a7 	. 
	call nz,033afh		;114b	c4 af 33 	. . 3 
l114eh:
	ld a,(ram_mode_flags)		;114e	3a 29 aa 	: ) . 
	and 020h		;1151	e6 20 	.   
	call z,sub_1186h		;1153	cc 86 11 	. . . 
	xor a			;1156	af 	. 
	ld (0abddh),a		;1157	32 dd ab 	2 . . 
	ld (0aa9ch),a		;115a	32 9c aa 	2 . . 
	ld (0ad7ch),a		;115d	32 7c ad 	2 | . 
	pop bc			;1160	c1 	. 
	jp l0f7bh		;1161	c3 7b 0f 	. { . 
l1164h:
	pop bc			;1164	c1 	. 
	djnz l10f2h		;1165	10 8b 	. . 
	ret			;1167	c9 	. 
l1168h:
	ld a,(0d000h)		;1168	3a 00 d0 	: . . 
	or 008h		;116b	f6 08 	. . 
	ld d,a			;116d	57 	W 
	ld a,(0c000h)		;116e	3a 00 c0 	: . . 
	ld e,a			;1171	5f 	_ 
	call sub_1777h		;1172	cd 77 17 	. w . 
	jr l1113h		;1175	18 9c 	. . 
l1177h:
	ld a,c			;1177	79 	y 
	cp 003h		;1178	fe 03 	. . 
	jr nz,l1131h		;117a	20 b5 	  . 
	ld bc,(0abd9h)		;117c	ed 4b d9 ab 	. K . . 
	ld a,c			;1180	79 	y 
	call 0354dh		;1181	cd 4d 35 	. M 5 
	jr l114eh		;1184	18 c8 	. . 
sub_1186h:
	ld c,00dh		;1186	0e 0d 	. . 
	ld hl,007c0h		;1188	21 c0 07 	! . . 
	rst 20h			;118b	e7 	. 
	jr z,l119bh		;118c	28 0d 	( . 
l118eh:
	ld a,(0aa2bh)		;118e	3a 2b aa 	: + . 
	and 080h		;1191	e6 80 	. . 
	jr nz,l119dh		;1193	20 08 	  . 
	ld a,(0ad60h)		;1195	3a 60 ad 	: ` . 
	and a			;1198	a7 	. 
	ret z			;1199	c8 	. 
	ld c,a			;119a	4f 	O 
l119bh:
	rst 18h			;119b	df 	. 
	ret			;119c	c9 	. 
l119dh:
	ld bc,(0ad73h)		;119d	ed 4b 73 ad 	. K s . 
sub_11a1h:
	push bc			;11a1	c5 	. 
	rst 18h			;11a2	df 	. 
	pop bc			;11a3	c1 	. 
	bit 7,b		;11a4	cb 78 	. x 
	ret nz			;11a6	c0 	. 
	ld c,b			;11a7	48 	H 
	rst 18h			;11a8	df 	. 
	ret			;11a9	c9 	. 
l11aah:
	rrca			;11aa	0f 	. 
	djnz l11bbh		;11ab	10 0e 	. . 
	inc b			;11ad	04 	. 
	dec b			;11ae	05 	. 
	ld (de),a			;11af	12 	. 
	inc d			;11b0	14 	. 
	ld d,017h		;11b1	16 17 	. . 
	add hl,de			;11b3	19 	. 
	ld a,(de)			;11b4	1a 	. 
sub_11b5h:
	ld a,(0a947h)		;11b5	3a 47 a9 	: G . 
	ld hl,ram_tx_tail		;11b8	21 46 a9 	! F . 
l11bbh:
	sub (hl)			;11bb	96 	. 
	jr z,l11c5h		;11bc	28 07 	( . 
	and 01fh		;11be	e6 1f 	. . 
	cp 006h		;11c0	fe 06 	. . 
	ld a,000h		;11c2	3e 00 	> . 
	ret			;11c4	c9 	. 
l11c5h:
	ld a,0ffh		;11c5	3e ff 	> . 
	ret			;11c7	c9 	. 
	ld a,(0abd1h)		;11c8	3a d1 ab 	: . . 
	and a			;11cb	a7 	. 
	ret z			;11cc	c8 	. 
	call sub_0f8fh		;11cd	cd 8f 0f 	. . . 
l11d0h:
	call sub_11b5h		;11d0	cd b5 11 	. . . 
	ret c			;11d3	d8 	. 
	ld c,a			;11d4	4f 	O 
	ld a,(0abd2h)		;11d5	3a d2 ab 	: . . 
	and a			;11d8	a7 	. 
	jr z,l1204h		;11d9	28 29 	( ) 
	and c			;11db	a1 	. 
	ret z			;11dc	c8 	. 
	ld a,(0aa2bh)		;11dd	3a 2b aa 	: + . 
	and 080h		;11e0	e6 80 	. . 
	jr z,l11ebh		;11e2	28 07 	( . 
	ld a,(0abedh)		;11e4	3a ed ab 	: . . 
	ld c,a			;11e7	4f 	O 
	rst 18h			;11e8	df 	. 
	jr l11fah		;11e9	18 0f 	. . 
l11ebh:
	ld a,(0aa2fh)		;11eb	3a 2f aa 	: / . 
	and a			;11ee	a7 	. 
	jr nz,l11fah		;11ef	20 09 	  . 
	ld a,(0abd6h)		;11f1	3a d6 ab 	: . . 
	and a			;11f4	a7 	. 
	ld c,000h		;11f5	0e 00 	. . 
	call nz,l1552h		;11f7	c4 52 15 	. R . 
l11fah:
	xor a			;11fa	af 	. 
	ld (0abd1h),a		;11fb	32 d1 ab 	2 . . 
	ld (0aa2fh),a		;11fe	32 2f aa 	2 / . 
	jp l0f7fh		;1201	c3 7f 0f 	.  . 
l1204h:
	call sub_17a0h		;1204	cd a0 17 	. . . 
	call sub_1359h		;1207	cd 59 13 	. Y . 
	bit 0,a		;120a	cb 47 	. G 
	jr nz,l122dh		;120c	20 1f 	  . 
	bit 4,a		;120e	cb 67 	. g 
	jr z,l1218h		;1210	28 06 	( . 
	ld a,(0abeeh)		;1212	3a ee ab 	: . . 
	and a			;1215	a7 	. 
	jr nz,l122dh		;1216	20 15 	  . 
l1218h:
	ld a,(ram_mode_flags)		;1218	3a 29 aa 	: ) . 
	and 020h		;121b	e6 20 	.   
	jr nz,l1231h		;121d	20 12 	  . 
	ld a,c			;121f	79 	y 
	cp 000h		;1220	fe 00 	. . 
	jr nz,l1231h		;1222	20 0d 	  . 
	ld a,(0aa2bh)		;1224	3a 2b aa 	: + . 
	and 0c0h		;1227	e6 c0 	. . 
	jr z,l1237h		;1229	28 0c 	( . 
	jr l1234h		;122b	18 07 	. . 
l122dh:
	ld c,020h		;122d	0e 20 	.   
	jr l1234h		;122f	18 03 	. . 
l1231h:
	call sub_100fh		;1231	cd 0f 10 	. . . 
l1234h:
	call tx_enqueue		;1234	cd 40 15 	. @ . 
l1237h:
	ld bc,(0abdbh)		;1237	ed 4b db ab 	. K . . 
	call sub_0fd0h		;123b	cd d0 0f 	. . . 
	ld (0abdbh),bc		;123e	ed 43 db ab 	. C . . 
	and a			;1242	a7 	. 
	jr z,l11d0h		;1243	28 8b 	( . 
	push af			;1245	f5 	. 
	ld a,(0abd4h)		;1246	3a d4 ab 	: . . 
	ld hl,0aa8bh		;1249	21 8b aa 	! . . 
	or (hl)			;124c	b6 	. 
	jr nz,l1264h		;124d	20 15 	  . 
	ld c,00dh		;124f	0e 0d 	. . 
	call tx_enqueue		;1251	cd 40 15 	. @ . 
	ld c,00ah		;1254	0e 0a 	. . 
	call tx_enqueue		;1256	cd 40 15 	. @ . 
	ld hl,00700h		;1259	21 00 07 	! . . 
	rst 20h			;125c	e7 	. 
	jr nz,l1264h		;125d	20 05 	  . 
	ld c,000h		;125f	0e 00 	. . 
	call tx_enqueue		;1261	cd 40 15 	. @ . 
l1264h:
	pop af			;1264	f1 	. 
	dec a			;1265	3d 	= 
	dec a			;1266	3d 	= 
	jp nz,l11d0h		;1267	c2 d0 11 	. . . 
	ld a,0ffh		;126a	3e ff 	> . 
	ld (0abd2h),a		;126c	32 d2 ab 	2 . . 
	xor a			;126f	af 	. 
	ld (0aa8bh),a		;1270	32 8b aa 	2 . . 
	jp l11d0h		;1273	c3 d0 11 	. . . 
sub_1276h:
	ld a,(ram_mode_flags)		;1276	3a 29 aa 	: ) . 
	ld b,a			;1279	47 	G 
	and 080h		;127a	e6 80 	. . 
	ld (0abeeh),a		;127c	32 ee ab 	2 . . 
	ld a,b			;127f	78 	x 
	and 020h		;1280	e6 20 	.   
	ld (0abd4h),a		;1282	32 d4 ab 	2 . . 
	xor a			;1285	af 	. 
	ld (0abd2h),a		;1286	32 d2 ab 	2 . . 
	ld (0abdbh),a		;1289	32 db ab 	2 . . 
	ld a,(0aa2bh)		;128c	3a 2b aa 	: + . 
	and 080h		;128f	e6 80 	. . 
	ld a,(0ac09h)		;1291	3a 09 ac 	: . . 
	jr z,l1297h		;1294	28 01 	( . 
	xor a			;1296	af 	. 
l1297h:
	ld (0abdch),a		;1297	32 dc ab 	2 . . 
	ld a,(0abd7h)		;129a	3a d7 ab 	: . . 
	ld (0abe7h),a		;129d	32 e7 ab 	2 . . 
	ld a,(0abd8h)		;12a0	3a d8 ab 	: . . 
	ld b,a			;12a3	47 	G 
	ld a,(0ac09h)		;12a4	3a 09 ac 	: . . 
	add a,b			;12a7	80 	. 
	ld (0abe8h),a		;12a8	32 e8 ab 	2 . . 
	ld a,0ffh		;12ab	3e ff 	> . 
	ld (0abd6h),a		;12ad	32 d6 ab 	2 . . 
	ld (0abd1h),a		;12b0	32 d1 ab 	2 . . 
	ld hl,(0ac1eh)		;12b3	2a 1e ac 	* . . 
	ld (0ad69h),hl		;12b6	22 69 ad 	" i . 
	ld a,(0aa2bh)		;12b9	3a 2b aa 	: + . 
	and 080h		;12bc	e6 80 	. . 
	call nz,02924h		;12be	c4 24 29 	. $ ) 
	jp l0f7fh		;12c1	c3 7f 0f 	.  . 
l12c4h:
	ld a,(0aa2bh)		;12c4	3a 2b aa 	: + . 
	and 080h		;12c7	e6 80 	. . 
	ld a,(0ac09h)		;12c9	3a 09 ac 	: . . 
	jr z,l12d9h		;12cc	28 0b 	( . 
	xor a			;12ce	af 	. 
	jr l12d9h		;12cf	18 08 	. . 
l12d1h:
	ld a,(0abd8h)		;12d1	3a d8 ab 	: . . 
	ld b,a			;12d4	47 	G 
	ld a,(0ac09h)		;12d5	3a 09 ac 	: . . 
	add a,b			;12d8	80 	. 
l12d9h:
	ld (0abdah),a		;12d9	32 da ab 	2 . . 
	xor a			;12dc	af 	. 
	ld (0abd9h),a		;12dd	32 d9 ab 	2 . . 
	ld a,(0abd8h)		;12e0	3a d8 ab 	: . . 
	ld b,a			;12e3	47 	G 
	ld a,(0ac09h)		;12e4	3a 09 ac 	: . . 
	add a,b			;12e7	80 	. 
	ld (0abe6h),a		;12e8	32 e6 ab 	2 . . 
	ld a,(0abd7h)		;12eb	3a d7 ab 	: . . 
	ld (0abe5h),a		;12ee	32 e5 ab 	2 . . 
	xor a			;12f1	af 	. 
	ld (0abe1h),a		;12f2	32 e1 ab 	2 . . 
	ld (0abdeh),a		;12f5	32 de ab 	2 . . 
	cpl			;12f8	2f 	/ 
	ld (0abddh),a		;12f9	32 dd ab 	2 . . 
	ld hl,(0ac1eh)		;12fc	2a 1e ac 	* . . 
	ld (0ad69h),hl		;12ff	22 69 ad 	" i . 
	jp l0f7bh		;1302	c3 7b 0f 	. { . 
l1305h:
	call sub_11b5h		;1305	cd b5 11 	. . . 
	ret c			;1308	d8 	. 
	ld c,a			;1309	4f 	O 
	ld a,(0aab6h)		;130a	3a b6 aa 	: . . 
	and a			;130d	a7 	. 
	jr z,tx_drain_loop		;130e	28 09 	( . 
	and c			;1310	a1 	. 
	ret z			;1311	c8 	. 
	xor a			;1312	af 	. 
	ld (0abf7h),a		;1313	32 f7 ab 	2 . . 
	jp h_aux_enq_56		;1316	c3 48 1a 	. H . 
tx_drain_loop:
	ld a,(ram_local_head)		;1319	3a 45 a9 	: E . 
	ld hl,ram_local_tail		;131c	21 44 a9 	! D . 
	cp (hl)			;131f	be 	. 
	jp z,0497bh		;1320	ca 7b 49 	. { I 
	rst 28h			;1323	ef 	. 
	ld b,a			;1324	47 	G 
	ld a,(0aa2bh)		;1325	3a 2b aa 	: + . 
	and 080h		;1328	e6 80 	. . 
	ld a,b			;132a	78 	x 
	jr nz,l1339h		;132b	20 0c 	  . 
l132dh:
	ld hl,0abd5h		;132d	21 d5 ab 	! . . 
	cp (hl)			;1330	be 	. 
	jr nz,l133fh		;1331	20 0c 	  . 
l1333h:
	ld a,0ffh		;1333	3e ff 	> . 
	ld (0aab6h),a		;1335	32 b6 aa 	2 . . 
	ret			;1338	c9 	. 
l1339h:
	cp 014h		;1339	fe 14 	. . 
	jr nz,l132dh		;133b	20 f0 	  . 
	jr l1333h		;133d	18 f4 	. . 
l133fh:
	cp 080h		;133f	fe 80 	. . 
	ld a,(ram_leadin_byte)		;1341	3a 99 aa 	: . . 
	ld c,a			;1344	4f 	O 
	call nc,tx_enqueue		;1345	d4 40 15 	. @ . 
	ld c,b			;1348	48 	H 
	call tx_enqueue		;1349	cd 40 15 	. @ . 
	ld a,(0abf7h)		;134c	3a f7 ab 	: . . 
	bit 1,a		;134f	cb 4f 	. O 
	jr z,l1305h		;1351	28 b2 	( . 
	ld a,b			;1353	78 	x 
	call 04981h		;1354	cd 81 49 	. . I 
	jr l1305h		;1357	18 ac 	. . 
sub_1359h:
	ld a,(0c000h)		;1359	3a 00 c0 	: . . 
	ld c,a			;135c	4f 	O 
	ld a,(0aa2bh)		;135d	3a 2b aa 	: + . 
	and 0c0h		;1360	e6 c0 	. . 
	ld a,(0d000h)		;1362	3a 00 d0 	: . . 
	ret z			;1365	c8 	. 
	bit 5,a		;1366	cb 6f 	. o 
	ret z			;1368	c8 	. 
	ld e,a			;1369	5f 	_ 
	ld a,(0aa2bh)		;136a	3a 2b aa 	: + . 
	and 080h		;136d	e6 80 	. . 
	jr nz,l1375h		;136f	20 04 	  . 
	ld c,020h		;1371	0e 20 	.   
	ld a,e			;1373	7b 	{ 
	ret			;1374	c9 	. 
l1375h:
	ld b,010h		;1375	06 10 	. . 
	ld hl,02ee2h		;1377	21 e2 2e 	! . . 
	ld a,c			;137a	79 	y 
l137bh:
	cp (hl)			;137b	be 	. 
	jr z,l1382h		;137c	28 04 	( . 
	inc b			;137e	04 	. 
	inc hl			;137f	23 	# 
	jr l137bh		;1380	18 f9 	. . 
l1382h:
	ld c,b			;1382	48 	H 
	ld a,e			;1383	7b 	{ 
	and 0deh		;1384	e6 de 	. . 
	ret			;1386	c9 	. 
uart_rx_isr_body:
	ld a,(08000h)		;1387	3a 00 80 	: . . 
	bit 6,c		;138a	cb 71 	. q 
	ret nz			;138c	c0 	. 
	and 07fh		;138d	e6 7f 	.  
	ld (ram_esc_byte),a		;138f	32 23 aa 	2 # . 
	ld d,a			;1392	57 	W 
	ld a,c			;1393	79 	y 
	and 038h		;1394	e6 38 	. 8 
	jr z,l13a1h		;1396	28 09 	( . 
	rlca			;1398	07 	. 
	ld hl,0abe2h		;1399	21 e2 ab 	! . . 
	or (hl)			;139c	b6 	. 
	ld (hl),a			;139d	77 	w 
	call sub_0f0dh		;139e	cd 0d 0f 	. . . 
l13a1h:
	ld a,(ram_esc_state)		;13a1	3a 25 aa 	: % . 
	and a			;13a4	a7 	. 
	jp nz,esc_state_machine		;13a5	c2 10 4a 	. . J 
	ld a,(ram_leadin_byte)		;13a8	3a 99 aa 	: . . 
	cp d			;13ab	ba 	. 
	jp z,esc_state_machine		;13ac	ca 10 4a 	. . J 
ring_put_esc:
	ld a,(ram_local_head)		;13af	3a 45 a9 	: E . 
	ld hl,ram_local_tail		;13b2	21 44 a9 	! D . 
	inc (hl)			;13b5	34 	4 
	sub (hl)			;13b6	96 	. 
	ld d,a			;13b7	57 	W 
	jr nz,l13c5h		;13b8	20 0b 	  . 
	dec (hl)			;13ba	35 	5 
	ld hl,0abe2h		;13bb	21 e2 ab 	! . . 
	ld a,020h		;13be	3e 20 	>   
	or (hl)			;13c0	b6 	. 
	ld (hl),a			;13c1	77 	w 
	jp sub_0f0dh		;13c2	c3 0d 0f 	. . . 
l13c5h:
	ld a,(hl)			;13c5	7e 	~ 
	ld hl,ram_local_ring		;13c6	21 00 a8 	! . . 
	add a,l			;13c9	85 	. 
	ld l,a			;13ca	6f 	o 
	ld a,(ram_esc_byte)		;13cb	3a 23 aa 	: # . 
	ld (hl),a			;13ce	77 	w 
	bit 7,d		;13cf	cb 7a 	. z 
	ret nz			;13d1	c0 	. 
	call sub_13f9h		;13d2	cd f9 13 	. . . 
	ld hl,0aa8ch		;13d5	21 8c aa 	! . . 
	bit 7,(hl)		;13d8	cb 7e 	. ~ 
	ret z			;13da	c8 	. 
	bit 3,(hl)		;13db	cb 5e 	. ^ 
	ret nz			;13dd	c0 	. 
	set 3,(hl)		;13de	cb de 	. . 
	res 2,(hl)		;13e0	cb 96 	. . 
	ld a,013h		;13e2	3e 13 	> . 
l13e4h:
	push af			;13e4	f5 	. 
l13e5h:
	ld a,(io_uart_primary)		;13e5	3a 01 80 	: . . 
	and 001h		;13e8	e6 01 	. . 
	jr z,l13e5h		;13ea	28 f9 	( . 
	pop af			;13ec	f1 	. 
	ld (08000h),a		;13ed	32 00 80 	2 . . 
	ld hl,0ac3bh		;13f0	21 3b ac 	! ; . 
	set 0,(hl)		;13f3	cb c6 	. . 
	set 5,(hl)		;13f5	cb ee 	. . 
	jr l13feh		;13f7	18 05 	. . 
sub_13f9h:
	ld hl,0ac3bh		;13f9	21 3b ac 	! ; . 
	res 1,(hl)		;13fc	cb 8e 	. . 
l13feh:
	ld a,(hl)			;13fe	7e 	~ 
	ld (io_uart_primary),a		;13ff	32 01 80 	2 . . 
	ret			;1402	c9 	. 
	ld hl,0ac3bh		;1403	21 3b ac 	! ; . 
	set 1,(hl)		;1406	cb ce 	. . 
	jr l13feh		;1408	18 f4 	. . 
l140ah:
	ld a,(09000h)		;140a	3a 00 90 	: . . 
	bit 6,d		;140d	cb 72 	. r 
	jr nz,l142dh		;140f	20 1c 	  . 
	ld d,a			;1411	57 	W 
	ld a,(ram_kb_head)		;1412	3a 4a a9 	: J . 
	ld hl,ram_kb_tail		;1415	21 4b a9 	! K . 
	inc a			;1418	3c 	< 
	and 00fh		;1419	e6 0f 	. . 
	cp (hl)			;141b	be 	. 
	jp z,l0047h		;141c	ca 47 00 	. G . 
	ld (ram_kb_head),a		;141f	32 4a a9 	2 J . 
	ld hl,ram_rx_queue		;1422	21 30 a9 	! 0 . 
	ld b,000h		;1425	06 00 	. . 
	ld c,a			;1427	4f 	O 
	add hl,bc			;1428	09 	. 
	ld (hl),d			;1429	72 	r 
	jp l0047h		;142a	c3 47 00 	. G . 
l142dh:
	ld a,0ffh		;142d	3e ff 	> . 
	ld (0aab5h),a		;142f	32 b5 aa 	2 . . 
	jp l0047h		;1432	c3 47 00 	. G . 
sub_1435h:
	ld a,(0aaa3h)		;1435	3a a3 aa 	: . . 
	ld hl,0aaa4h		;1438	21 a4 aa 	! . . 
	cp (hl)			;143b	be 	. 
	ret z			;143c	c8 	. 
l143dh:
	ld a,(09001h)		;143d	3a 01 90 	: . . 
	and 004h		;1440	e6 04 	. . 
	jr z,l143dh		;1442	28 f9 	( . 
	di			;1444	f3 	. 
	ld a,05fh		;1445	3e 5f 	> _ 
	out (040h),a		;1447	d3 40 	. @ 
	ld a,09ah		;1449	3e 9a 	> . 
	out (040h),a		;144b	d3 40 	. @ 
	ld de,0ac3ch		;144d	11 3c ac 	. < . 
	ld a,(de)			;1450	1a 	. 
	and 0fch		;1451	e6 fc 	. . 
	ld (de),a			;1453	12 	. 
	ld (09001h),a		;1454	32 01 90 	2 . . 
	ld a,(hl)			;1457	7e 	~ 
	inc a			;1458	3c 	< 
	and 007h		;1459	e6 07 	. . 
	ld (hl),a			;145b	77 	w 
	ld c,a			;145c	4f 	O 
	ld b,000h		;145d	06 00 	. . 
	ld hl,0ac3dh		;145f	21 3d ac 	! = . 
	add hl,bc			;1462	09 	. 
	ld a,(hl)			;1463	7e 	~ 
	ld (09000h),a		;1464	32 00 90 	2 . . 
	ld a,(de)			;1467	1a 	. 
	set 0,a		;1468	cb c7 	. . 
	ld (de),a			;146a	12 	. 
	ld (09001h),a		;146b	32 01 90 	2 . . 
	ld a,0ffh		;146e	3e ff 	> . 
	ld (0ac47h),a		;1470	32 47 ac 	2 G . 
	ei			;1473	fb 	. 
	ret			;1474	c9 	. 
aux_ring_enq:
	ld a,(0aaa3h)		;1475	3a a3 aa 	: . . 
	inc a			;1478	3c 	< 
	and 007h		;1479	e6 07 	. . 
	push hl			;147b	e5 	. 
	ld hl,0aaa4h		;147c	21 a4 aa 	! . . 
	cp (hl)			;147f	be 	. 
	jr z,l148dh		;1480	28 0b 	( . 
	ld (0aaa3h),a		;1482	32 a3 aa 	2 . . 
	ld hl,0ac3dh		;1485	21 3d ac 	! = . 
	ld e,a			;1488	5f 	_ 
	ld d,000h		;1489	16 00 	. . 
	add hl,de			;148b	19 	. 
	ld (hl),c			;148c	71 	q 
l148dh:
	pop hl			;148d	e1 	. 
	ret			;148e	c9 	. 
sub_148fh:
	ld a,(ram_rx_head)		;148f	3a 48 a9 	: H . 
	ld hl,ram_rx_tail		;1492	21 49 a9 	! I . 
	cp (hl)			;1495	be 	. 
	jr z,l14cfh		;1496	28 37 	( 7 
	ld a,(0aa8ch)		;1498	3a 8c aa 	: . . 
	and 082h		;149b	e6 82 	. . 
	cp 082h		;149d	fe 82 	. . 
	jr z,l14dbh		;149f	28 3a 	( : 
	ld a,(io_uart_primary)		;14a1	3a 01 80 	: . . 
	and 080h		;14a4	e6 80 	. . 
	jr z,l14dbh		;14a6	28 33 	( 3 
	ld a,(hl)			;14a8	7e 	~ 
	inc a			;14a9	3c 	< 
	and 00fh		;14aa	e6 0f 	. . 
	ld (hl),a			;14ac	77 	w 
	ld hl,0a920h		;14ad	21 20 a9 	!   . 
	ld c,a			;14b0	4f 	O 
	ld b,000h		;14b1	06 00 	. . 
	add hl,bc			;14b3	09 	. 
	ld a,(hl)			;14b4	7e 	~ 
	and 07fh		;14b5	e6 7f 	.  
	ld hl,0aabch		;14b7	21 bc aa 	! . . 
	bit 4,(hl)		;14ba	cb 66 	. f 
	jr z,l14c0h		;14bc	28 02 	( . 
	set 7,a		;14be	cb ff 	. . 
l14c0h:
	ld (08000h),a		;14c0	32 00 80 	2 . . 
	ld hl,0ac3bh		;14c3	21 3b ac 	! ; . 
	set 0,(hl)		;14c6	cb c6 	. . 
	set 5,(hl)		;14c8	cb ee 	. . 
l14cah:
	ld a,(hl)			;14ca	7e 	~ 
	ld (io_uart_primary),a		;14cb	32 01 80 	2 . . 
	ret			;14ce	c9 	. 
l14cfh:
	ld a,(ram_mode_flags)		;14cf	3a 29 aa 	: ) . 
	and 002h		;14d2	e6 02 	. . 
	jr nz,l14dbh		;14d4	20 05 	  . 
	ld hl,0ac3bh		;14d6	21 3b ac 	! ; . 
	res 5,(hl)		;14d9	cb ae 	. . 
l14dbh:
	ld hl,0ac3bh		;14db	21 3b ac 	! ; . 
	res 0,(hl)		;14de	cb 86 	. . 
	jr l14cah		;14e0	18 e8 	. . 
sub_14e2h:
	xor a			;14e2	af 	. 
	ld (0ac47h),a		;14e3	32 47 ac 	2 G . 
	ld hl,0a947h		;14e6	21 47 a9 	! G . 
	ld a,(ram_tx_tail)		;14e9	3a 46 a9 	: F . 
	cp (hl)			;14ec	be 	. 
	jr z,sub_1524h		;14ed	28 35 	( 5 
	ld a,(09001h)		;14ef	3a 01 90 	: . . 
	and 080h		;14f2	e6 80 	. . 
	jr z,sub_1524h		;14f4	28 2e 	( . 
	ld a,(0ac3ch)		;14f6	3a 3c ac 	: < . 
	and 002h		;14f9	e6 02 	. . 
	call z,l05d7h		;14fb	cc d7 05 	. . . 
	ld hl,0a947h		;14fe	21 47 a9 	! G . 
	ld a,(hl)			;1501	7e 	~ 
	inc a			;1502	3c 	< 
	and 01fh		;1503	e6 1f 	. . 
	ld (hl),a			;1505	77 	w 
	ld hl,ram_tx_queue		;1506	21 00 a9 	! . . 
	ld c,a			;1509	4f 	O 
	ld b,000h		;150a	06 00 	. . 
	add hl,bc			;150c	09 	. 
	ld a,(hl)			;150d	7e 	~ 
	and 07fh		;150e	e6 7f 	.  
	ld hl,0aabch		;1510	21 bc aa 	! . . 
	bit 5,(hl)		;1513	cb 6e 	. n 
	jr z,l1519h		;1515	28 02 	( . 
	set 7,a		;1517	cb ff 	. . 
l1519h:
	ld (09000h),a		;1519	32 00 90 	2 . . 
	ld hl,0ac3ch		;151c	21 3c ac 	! < . 
	ld a,(hl)			;151f	7e 	~ 
	or 003h		;1520	f6 03 	. . 
	jr l152ah		;1522	18 06 	. . 
sub_1524h:
	ld hl,0ac3ch		;1524	21 3c ac 	! < . 
	ld a,(hl)			;1527	7e 	~ 
	res 0,a		;1528	cb 87 	. . 
l152ah:
	ld (hl),a			;152a	77 	w 
	ld (09001h),a		;152b	32 01 90 	2 . . 
	ret			;152e	c9 	. 
sub_152fh:
	ld hl,ram_rx_tail		;152f	21 49 a9 	! I . 
	ld a,(ram_rx_head)		;1532	3a 48 a9 	: H . 
	sub (hl)			;1535	96 	. 
	and 00fh		;1536	e6 0f 	. . 
	cp 00eh		;1538	fe 0e 	. . 
	ld a,000h		;153a	3e 00 	> . 
	ret c			;153c	d8 	. 
	ld a,0ffh		;153d	3e ff 	> . 
	ret			;153f	c9 	. 
tx_enqueue:
	ld a,(ram_tx_tail)		;1540	3a 46 a9 	: F . 
	inc a			;1543	3c 	< 
	and 01fh		;1544	e6 1f 	. . 
	ld hl,ram_tx_queue		;1546	21 00 a9 	! . . 
	ld e,a			;1549	5f 	_ 
	ld d,000h		;154a	16 00 	. . 
	add hl,de			;154c	19 	. 
	ld (hl),c			;154d	71 	q 
	ld (ram_tx_tail),a		;154e	32 46 a9 	2 F . 
	ret			;1551	c9 	. 
l1552h:
	ld a,(ram_mode_flags)		;1552	3a 29 aa 	: ) . 
	and 004h		;1555	e6 04 	. . 
	ret nz			;1557	c0 	. 
	ld a,0ffh		;1558	3e ff 	> . 
	ld (0aa27h),a		;155a	32 27 aa 	2 ' . 
l155dh:
	ld a,(0aa27h)		;155d	3a 27 aa 	: ' . 
	and a			;1560	a7 	. 
	ret z			;1561	c8 	. 
	call sub_1567h		;1562	cd 67 15 	. g . 
	jr l155dh		;1565	18 f6 	. . 
sub_1567h:
	ld hl,0aa27h		;1567	21 27 aa 	! ' . 
	ld (hl),000h		;156a	36 00 	6 . 
	ld a,(0aa8ch)		;156c	3a 8c aa 	: . . 
	and 082h		;156f	e6 82 	. . 
	cp 082h		;1571	fe 82 	. . 
	ret z			;1573	c8 	. 
	ld a,(ram_rx_tail)		;1574	3a 49 a9 	: I . 
	ld b,a			;1577	47 	G 
	ld a,(ram_rx_head)		;1578	3a 48 a9 	: H . 
	inc a			;157b	3c 	< 
	and 00fh		;157c	e6 0f 	. . 
	cp b			;157e	b8 	. 
	jr nz,l1586h		;157f	20 05 	  . 
	ld (hl),0ffh		;1581	36 ff 	6 . 
	jp l0059h		;1583	c3 59 00 	. Y . 
l1586h:
	ld hl,0a920h		;1586	21 20 a9 	!   . 
	ld e,a			;1589	5f 	_ 
	ld d,000h		;158a	16 00 	. . 
	add hl,de			;158c	19 	. 
	ld (hl),c			;158d	71 	q 
	ld (ram_rx_head),a		;158e	32 48 a9 	2 H . 
	ret			;1591	c9 	. 
sub_1592h:
	ld bc,(0aa2bh)		;1592	ed 4b 2b aa 	. K + . 
	ld a,b			;1596	78 	x 
	and h			;1597	a4 	. 
	ret nz			;1598	c0 	. 
	ld a,c			;1599	79 	y 
	and l			;159a	a5 	. 
	ret			;159b	c9 	. 
ring_get_next:
	ld a,(ram_local_tail)		;159c	3a 44 a9 	: D . 
	ld hl,ram_local_head		;159f	21 45 a9 	! E . 
	cp (hl)			;15a2	be 	. 
	di			;15a3	f3 	. 
	jr nz,l15b9h		;15a4	20 13 	  . 
	ei			;15a6	fb 	. 
	ld a,(ram_kb_head)		;15a7	3a 4a a9 	: J . 
	ld hl,ram_kb_tail		;15aa	21 4b a9 	! K . 
	cp (hl)			;15ad	be 	. 
	call nz,sub_17cfh		;15ae	c4 cf 17 	. . . 
	call 0497bh		;15b1	cd 7b 49 	. { I 
	call l0059h		;15b4	cd 59 00 	. Y . 
	jr ring_get_next		;15b7	18 e3 	. . 
l15b9h:
	inc (hl)			;15b9	34 	4 
	ld e,(hl)			;15ba	5e 	^ 
	ei			;15bb	fb 	. 
	ld a,080h		;15bc	3e 80 	> . 
	ld (0abf6h),a		;15be	32 f6 ab 	2 . . 
	ld d,000h		;15c1	16 00 	. . 
	ld hl,ram_local_ring		;15c3	21 00 a8 	! . . 
	add hl,de			;15c6	19 	. 
	ld a,(hl)			;15c7	7e 	~ 
	push af			;15c8	f5 	. 
	ld c,a			;15c9	4f 	O 
	ld a,(0aaa1h)		;15ca	3a a1 aa 	: . . 
	and a			;15cd	a7 	. 
	call nz,0374ch		;15ce	c4 4c 37 	. L 7 
	pop af			;15d1	f1 	. 
	ret			;15d2	c9 	. 
sub_15d3h:
	ld hl,0aa2eh		;15d3	21 2e aa 	! . . 
	cpl			;15d6	2f 	/ 
	and (hl)			;15d7	a6 	. 
l15d8h:
	ld (hl),a			;15d8	77 	w 
	ld (0f000h),a		;15d9	32 00 f0 	2 . . 
	ret			;15dc	c9 	. 
sub_15ddh:
	ld hl,0aa2eh		;15dd	21 2e aa 	! . . 
	or (hl)			;15e0	b6 	. 
	jr l15d8h		;15e1	18 f5 	. . 
sub_15e3h:
	ld hl,0ac3ch		;15e3	21 3c ac 	! < . 
	di			;15e6	f3 	. 
	res 5,(hl)		;15e7	cb ae 	. . 
l15e9h:
	ld a,(hl)			;15e9	7e 	~ 
	ld (09001h),a		;15ea	32 01 90 	2 . . 
	ei			;15ed	fb 	. 
	ret			;15ee	c9 	. 
l15efh:
	ld hl,0ac3ch		;15ef	21 3c ac 	! < . 
	di			;15f2	f3 	. 
	set 5,(hl)		;15f3	cb ee 	. . 
	jr l15e9h		;15f5	18 f2 	. . 
l15f7h:
	call sub_1757h		;15f7	cd 57 17 	. W . 
	ld e,a			;15fa	5f 	_ 
	ld a,(0ad79h)		;15fb	3a 79 ad 	: y . 
	and a			;15fe	a7 	. 
	jp z,l1613h		;15ff	ca 13 16 	. . . 
	call sub_179ch		;1602	cd 9c 17 	. . . 
	ld a,(0d000h)		;1605	3a 00 d0 	: . . 
	and 010h		;1608	e6 10 	. . 
	jp nz,031afh		;160a	c2 af 31 	. . 1 
	ld (0ad79h),a		;160d	32 79 ad 	2 y . 
	call sub_0cdeh		;1610	cd de 0c 	. . . 
l1613h:
	ld a,(0aa2bh)		;1613	3a 2b aa 	: + . 
	and 023h		;1616	e6 23 	. # 
	jr z,l1664h		;1618	28 4a 	( J 
	ld a,(ram_mode_flags)		;161a	3a 29 aa 	: ) . 
	and 010h		;161d	e6 10 	. . 
	ld a,(0ac28h)		;161f	3a 28 ac 	: ( . 
	jr nz,l1640h		;1622	20 1c 	  . 
	and 07fh		;1624	e6 7f 	.  
	ld b,a			;1626	47 	G 
	ld c,00fh		;1627	0e 0f 	. . 
l1629h:
	ld a,(0acfdh)		;1629	3a fd ac 	: . . 
	and a			;162c	a7 	. 
	jr nz,l1629h		;162d	20 fa 	  . 
	ld a,0ach		;162f	3e ac 	> . 
	ld (06001h),a		;1631	32 01 60 	2 . ` 
	ld hl,06001h		;1634	21 01 60 	! . ` 
l1637h:
	bit 5,(hl)		;1637	cb 6e 	. n 
	jr z,l1637h		;1639	28 fc 	( . 
	ld a,(0d000h)		;163b	3a 00 d0 	: . . 
l163eh:
	and c			;163e	a1 	. 
	or b			;163f	b0 	. 
l1640h:
	ld (0ad66h),a		;1640	32 66 ad 	2 f . 
	ld d,a			;1643	57 	W 
	and 040h		;1644	e6 40 	. @ 
	jp nz,l173dh		;1646	c2 3d 17 	. = . 
l1649h:
	ld a,e			;1649	7b 	{ 
	ld (0c000h),a		;164a	32 00 c0 	2 . . 
	and a			;164d	a7 	. 
	ld a,d			;164e	7a 	z 
	jr nz,l1653h		;164f	20 02 	  . 
	or 080h		;1651	f6 80 	. . 
l1653h:
	ld (0d000h),a		;1653	32 00 d0 	2 . . 
l1656h:
	ld a,(0acfdh)		;1656	3a fd ac 	: . . 
	and a			;1659	a7 	. 
	jr nz,l1656h		;165a	20 fa 	  . 
	ld a,0abh		;165c	3e ab 	> . 
	ld (06001h),a		;165e	32 01 60 	2 . ` 
	jp 03085h		;1661	c3 85 30 	. . 0 
l1664h:
	ld hl,00714h		;1664	21 14 07 	! . . 
	rst 20h			;1667	e7 	. 
	ld a,(0ac28h)		;1668	3a 28 ac 	: ( . 
	jr nz,l1640h		;166b	20 d3 	  . 
	and 07fh		;166d	e6 7f 	.  
	ld b,a			;166f	47 	G 
	ld c,00fh		;1670	0e 0f 	. . 
	call sub_0cd8h		;1672	cd d8 0c 	. . . 
	jr nz,l16b8h		;1675	20 41 	  A 
	ld c,01fh		;1677	0e 1f 	. . 
l1679h:
	ld a,(0acfdh)		;1679	3a fd ac 	: . . 
	and a			;167c	a7 	. 
	jr nz,l1679h		;167d	20 fa 	  . 
	ld a,0ach		;167f	3e ac 	> . 
	ld (06001h),a		;1681	32 01 60 	2 . ` 
l1684h:
	ld a,(06001h)		;1684	3a 01 60 	: . ` 
	and 020h		;1687	e6 20 	.   
	jr z,l1684h		;1689	28 f9 	( . 
	ld a,(0c000h)		;168b	3a 00 c0 	: . . 
	cp 010h		;168e	fe 10 	. . 
	ld hl,l1ad2h		;1690	21 d2 1a 	! . . 
	jr z,l16a6h		;1693	28 11 	( . 
	cp 012h		;1695	fe 12 	. . 
	ld a,(0d000h)		;1697	3a 00 d0 	: . . 
	jr nz,l163eh		;169a	20 a2 	  . 
	and 010h		;169c	e6 10 	. . 
	ld hl,l1abeh		;169e	21 be 1a 	! . . 
	jr nz,l16a6h		;16a1	20 03 	  . 
	ld hl,l1ac3h		;16a3	21 c3 1a 	! . . 
l16a6h:
	push hl			;16a6	e5 	. 
	ld a,(0d000h)		;16a7	3a 00 d0 	: . . 
	and 0feh		;16aa	e6 fe 	. . 
	and c			;16ac	a1 	. 
	or b			;16ad	b0 	. 
	call l1640h		;16ae	cd 40 16 	. @ . 
	call sub_1b62h		;16b1	cd 62 1b 	. b . 
	pop hl			;16b4	e1 	. 
	jp l1aaah		;16b5	c3 aa 1a 	. . . 
l16b8h:
	call sub_179ch		;16b8	cd 9c 17 	. . . 
	ld a,(0d000h)		;16bb	3a 00 d0 	: . . 
	bit 5,a		;16be	cb 6f 	. o 
	jp nz,041fah		;16c0	c2 fa 41 	. . A 
	and 02fh		;16c3	e6 2f 	. / 
	ld d,a			;16c5	57 	W 
	ld a,(0aa2ah)		;16c6	3a 2a aa 	: * . 
	bit 4,a		;16c9	cb 67 	. g 
	jr z,l16ech		;16cb	28 1f 	( . 
	push af			;16cd	f5 	. 
	res 2,a		;16ce	cb 97 	. . 
	ld (0aa2ah),a		;16d0	32 2a aa 	2 * . 
	ld hl,(0abd7h)		;16d3	2a d7 ab 	* . . 
	push hl			;16d6	e5 	. 
	ld hl,(06004h)		;16d7	2a 04 60 	* . ` 
	push hl			;16da	e5 	. 
	push de			;16db	d5 	. 
	call 039ebh		;16dc	cd eb 39 	. . 9 
	pop de			;16df	d1 	. 
	pop hl			;16e0	e1 	. 
	ld (06004h),hl		;16e1	22 04 60 	" . ` 
	pop hl			;16e4	e1 	. 
	ld (0abd7h),hl		;16e5	22 d7 ab 	" . . 
	pop af			;16e8	f1 	. 
	ld (0aa2ah),a		;16e9	32 2a aa 	2 * . 
l16ech:
	ld a,(0ac28h)		;16ec	3a 28 ac 	: ( . 
	and 03fh		;16ef	e6 3f 	. ? 
	or d			;16f1	b2 	. 
	ld d,a			;16f2	57 	W 
	rst 10h			;16f3	d7 	. 
	jp l1649h		;16f4	c3 49 16 	. I . 
	push af			;16f7	f5 	. 
	push bc			;16f8	c5 	. 
	push de			;16f9	d5 	. 
	push hl			;16fa	e5 	. 
	ld de,(0abd7h)		;16fb	ed 5b d7 ab 	. [ . . 
	ld a,e			;16ff	7b 	{ 
	and a			;1700	a7 	. 
	jr z,l172ch		;1701	28 29 	( ) 
	dec a			;1703	3d 	= 
l1704h:
	ld (0abd7h),a		;1704	32 d7 ab 	2 . . 
	push de			;1707	d5 	. 
	call 02f46h		;1708	cd 46 2f 	. F / 
	pop de			;170b	d1 	. 
	ld (06006h),hl		;170c	22 06 60 	" . ` 
	call sub_17a0h		;170f	cd a0 17 	. . . 
	ld a,(0d000h)		;1712	3a 00 d0 	: . . 
	bit 5,a		;1715	cb 6f 	. o 
	jr z,l171eh		;1717	28 05 	( . 
	ld a,(0c000h)		;1719	3a 00 c0 	: . . 
	jr l1720h		;171c	18 02 	. . 
l171eh:
	and 06fh		;171e	e6 6f 	. o 
l1720h:
	ld (0ac19h),a		;1720	32 19 ac 	2 . . 
	ld (0abd7h),de		;1723	ed 53 d7 ab 	. S . . 
l1727h:
	pop hl			;1727	e1 	. 
	pop de			;1728	d1 	. 
	pop bc			;1729	c1 	. 
	pop af			;172a	f1 	. 
	ret			;172b	c9 	. 
l172ch:
	ld a,d			;172c	7a 	z 
	and a			;172d	a7 	. 
	jr z,l1738h		;172e	28 08 	( . 
	dec a			;1730	3d 	= 
	ld (0abd8h),a		;1731	32 d8 ab 	2 . . 
	ld a,04fh		;1734	3e 4f 	> O 
	jr l1704h		;1736	18 cc 	. . 
l1738h:
	ld (0ac19h),a		;1738	32 19 ac 	2 . . 
	jr l1727h		;173b	18 ea 	. . 
l173dh:
	ld a,(0ad66h)		;173d	3a 66 ad 	: f . 
	and 0dfh		;1740	e6 df 	. . 
	push de			;1742	d5 	. 
	call sub_174ch		;1743	cd 4c 17 	. L . 
	pop de			;1746	d1 	. 
	ld a,(0ad66h)		;1747	3a 66 ad 	: f . 
	or 020h		;174a	f6 20 	.   
sub_174ch:
	ld d,a			;174c	57 	W 
l174dh:
	ld a,(06001h)		;174d	3a 01 60 	: . ` 
	and 020h		;1750	e6 20 	.   
	jr z,l174dh		;1752	28 f9 	( . 
	jp l1649h		;1754	c3 49 16 	. I . 
sub_1757h:
	cp 023h		;1757	fe 23 	. # 
	ret c			;1759	d8 	. 
	cp 07fh		;175a	fe 7f 	.  
	ret nc			;175c	d0 	. 
	sub 023h		;175d	d6 23 	. # 
	ld c,a			;175f	4f 	O 
	ld b,000h		;1760	06 00 	. . 
	ld hl,0ac6ah		;1762	21 6a ac 	! j . 
	add hl,bc			;1765	09 	. 
	ld a,(hl)			;1766	7e 	~ 
	ret			;1767	c9 	. 
crtc_write_cursor:
	ld hl,06001h		;1768	21 01 60 	! . ` 
l176bh:
	bit 5,(hl)		;176b	cb 6e 	. n 
	jr z,l176bh		;176d	28 fc 	( . 
	ret			;176f	c9 	. 
	ld a,0bbh		;1770	3e bb 	> . 
	call sub_1781h		;1772	cd 81 17 	. . . 
	jr crtc_write_cursor		;1775	18 f1 	. . 
sub_1777h:
	ld a,0a2h		;1777	3e a2 	> . 
	jr sub_1781h		;1779	18 06 	. . 
sub_177bh:
	ld a,0aah		;177b	3e aa 	> . 
	jr sub_1781h		;177d	18 02 	. . 
sub_177fh:
	ld a,0abh		;177f	3e ab 	> . 
sub_1781h:
	push af			;1781	f5 	. 
l1782h:
	ld a,(06001h)		;1782	3a 01 60 	: . ` 
	and 020h		;1785	e6 20 	.   
	jr z,l1782h		;1787	28 f9 	( . 
	ld a,e			;1789	7b 	{ 
	ld (0c000h),a		;178a	32 00 c0 	2 . . 
	ld a,d			;178d	7a 	z 
	ld (0d000h),a		;178e	32 00 d0 	2 . . 
l1791h:
	ld a,(0acfdh)		;1791	3a fd ac 	: . . 
	and a			;1794	a7 	. 
	jr nz,l1791h		;1795	20 fa 	  . 
	pop af			;1797	f1 	. 
	ld (06001h),a		;1798	32 01 60 	2 . ` 
	ret			;179b	c9 	. 
sub_179ch:
	ld a,0ach		;179c	3e ac 	> . 
	jr l17a2h		;179e	18 02 	. . 
sub_17a0h:
	ld a,0a4h		;17a0	3e a4 	> . 
l17a2h:
	push af			;17a2	f5 	. 
l17a3h:
	ld a,(06001h)		;17a3	3a 01 60 	: . ` 
	and 020h		;17a6	e6 20 	.   
	jr z,l17a3h		;17a8	28 f9 	( . 
l17aah:
	ld a,(0acfdh)		;17aa	3a fd ac 	: . . 
	and a			;17ad	a7 	. 
	jr nz,l17aah		;17ae	20 fa 	  . 
	pop af			;17b0	f1 	. 
	ld (06001h),a		;17b1	32 01 60 	2 . ` 
	rst 10h			;17b4	d7 	. 
	ret			;17b5	c9 	. 
ring_put_data:
	di			;17b6	f3 	. 
	ld hl,ram_local_head		;17b7	21 45 a9 	! E . 
	ld a,(ram_local_tail)		;17ba	3a 44 a9 	: D . 
	inc a			;17bd	3c 	< 
	cp (hl)			;17be	be 	. 
	jr nz,l17c2h		;17bf	20 01 	  . 
	dec a			;17c1	3d 	= 
l17c2h:
	ld (ram_local_tail),a		;17c2	32 44 a9 	2 D . 
	ld e,a			;17c5	5f 	_ 
	ld d,000h		;17c6	16 00 	. . 
	ld hl,ram_local_ring		;17c8	21 00 a8 	! . . 
	add hl,de			;17cb	19 	. 
	ld (hl),c			;17cc	71 	q 
	ei			;17cd	fb 	. 
	ret			;17ce	c9 	. 
sub_17cfh:
	ld a,(ram_mode_flags)		;17cf	3a 29 aa 	: ) . 
	and 00ch		;17d2	e6 0c 	. . 
	jr nz,l17e3h		;17d4	20 0d 	  . 
	ld a,(ram_rx_head)		;17d6	3a 48 a9 	: H . 
	inc a			;17d9	3c 	< 
	and 00fh		;17da	e6 0f 	. . 
	ld hl,ram_rx_tail		;17dc	21 49 a9 	! I . 
	cp (hl)			;17df	be 	. 
	jp z,l0059h		;17e0	ca 59 00 	. Y . 
l17e3h:
	call sub_17f7h		;17e3	cd f7 17 	. . . 
	ld a,c			;17e6	79 	y 
	jr nz,l17f1h		;17e7	20 08 	  . 
	cp 080h		;17e9	fe 80 	. . 
	jp nc,0b00fh		;17eb	d2 0f b0 	. . . 
	jp l1873h		;17ee	c3 73 18 	. s . 
l17f1h:
	cp 0b0h		;17f1	fe b0 	. . 
	jp z,02c89h		;17f3	ca 89 2c 	. . , 
	ret			;17f6	c9 	. 
sub_17f7h:
	xor a			;17f7	af 	. 
	ld (0abd6h),a		;17f8	32 d6 ab 	2 . . 
	ld a,(ram_kb_tail)		;17fb	3a 4b a9 	: K . 
	inc a			;17fe	3c 	< 
	and 00fh		;17ff	e6 0f 	. . 
	ld c,a			;1801	4f 	O 
	ld b,000h		;1802	06 00 	. . 
	ld hl,ram_rx_queue		;1804	21 30 a9 	! 0 . 
	add hl,bc			;1807	09 	. 
	ld c,(hl)			;1808	4e 	N 
	ld (ram_kb_tail),a		;1809	32 4b a9 	2 K . 
	ld a,c			;180c	79 	y 
	ld (0aa28h),a		;180d	32 28 aa 	2 ( . 
	ld a,080h		;1810	3e 80 	> . 
	ld (0abf6h),a		;1812	32 f6 ab 	2 . . 
	ld a,(0aab5h)		;1815	3a b5 aa 	: . . 
	and a			;1818	a7 	. 
	jr nz,l1820h		;1819	20 05 	  . 
	ld a,(0acc6h)		;181b	3a c6 ac 	: . . 
	and a			;181e	a7 	. 
	ret			;181f	c9 	. 
l1820h:
	call 0b015h		;1820	cd 15 b0 	. . . 
	ld a,(0aa89h)		;1823	3a 89 aa 	: . . 
	ld b,007h		;1826	06 07 	. . 
l1828h:
	bit 6,a		;1828	cb 77 	. w 
	jr nz,l1830h		;182a	20 04 	  . 
	sla a		;182c	cb 27 	. ' 
	djnz l1828h		;182e	10 f8 	. . 
l1830h:
	ld a,041h		;1830	3e 41 	> A 
	add a,b			;1832	80 	. 
	ld c,a			;1833	4f 	O 
	call aux_ring_enq		;1834	cd 75 14 	. u . 
	ld a,(0abc7h)		;1837	3a c7 ab 	: . . 
	and a			;183a	a7 	. 
	ld c,055h		;183b	0e 55 	. U 
	jr nz,l1840h		;183d	20 01 	  . 
	inc c			;183f	0c 	. 
l1840h:
	call aux_ring_enq		;1840	cd 75 14 	. u . 
	call sub_0516h		;1843	cd 16 05 	. . . 
	xor a			;1846	af 	. 
	ld (0aab5h),a		;1847	32 b5 aa 	2 . . 
	ld c,a			;184a	4f 	O 
	inc a			;184b	3c 	< 
	ret			;184c	c9 	. 
sub_184dh:
	call sub_0d00h		;184d	cd 00 0d 	. . . 
	call sub_1435h		;1850	cd 35 14 	. 5 . 
	ld a,(ram_kb_head)		;1853	3a 4a a9 	: J . 
	ld hl,ram_kb_tail		;1856	21 4b a9 	! K . 
	cp (hl)			;1859	be 	. 
	jr z,sub_184dh		;185a	28 f1 	( . 
	call sub_17f7h		;185c	cd f7 17 	. . . 
	jr nz,sub_184dh		;185f	20 ec 	  . 
	ret			;1861	c9 	. 
sub_1862h:
	ld hl,0aa8ch		;1862	21 8c aa 	! . . 
	bit 7,(hl)		;1865	cb 7e 	. ~ 
	ret z			;1867	c8 	. 
	bit 3,(hl)		;1868	cb 5e 	. ^ 
	ret nz			;186a	c0 	. 
	set 3,(hl)		;186b	cb de 	. . 
	res 2,(hl)		;186d	cb 96 	. . 
	ld c,013h		;186f	0e 13 	. . 
	rst 18h			;1871	df 	. 
	ret			;1872	c9 	. 
l1873h:
	ld a,(ram_mode_flags)		;1873	3a 29 aa 	: ) . 
	and 00dh		;1876	e6 0d 	. . 
	jr z,l1895h		;1878	28 1b 	( . 
esc_leadin_detector:
	ld a,c			;187a	79 	y 
	ld hl,ram_leadin_byte		;187b	21 99 aa 	! . . 
	cp (hl)			;187e	be 	. 
	jr z,l188ch		;187f	28 0b 	( . 
	ld a,(ram_esc_state)		;1881	3a 25 aa 	: % . 
	and a			;1884	a7 	. 
	jr nz,l188ch		;1885	20 05 	  . 
	call ring_put_data		;1887	cd b6 17 	. . . 
	jr l1895h		;188a	18 09 	. . 
l188ch:
	ld a,c			;188c	79 	y 
	ld (ram_esc_byte),a		;188d	32 23 aa 	2 # . 
	push bc			;1890	c5 	. 
	call esc_state_machine		;1891	cd 10 4a 	. . J 
	pop bc			;1894	c1 	. 
l1895h:
	ld a,(ram_mode_flags)		;1895	3a 29 aa 	: ) . 
	and 00ch		;1898	e6 0c 	. . 
	ld a,c			;189a	79 	y 
	ret nz			;189b	c0 	. 
	ld de,0ac3bh		;189c	11 3b ac 	. ; . 
	cp 011h		;189f	fe 11 	. . 
	jr nz,l18adh		;18a1	20 0a 	  . 
l18a3h:
	ld hl,0aa8ch		;18a3	21 8c aa 	! . . 
	set 2,(hl)		;18a6	cb d6 	. . 
	res 3,(hl)		;18a8	cb 9e 	. . 
	jp l13e4h		;18aa	c3 e4 13 	. . . 
l18adh:
	cp 013h		;18ad	fe 13 	. . 
	jr z,l18a3h		;18af	28 f2 	( . 
	jp sub_1567h		;18b1	c3 67 15 	. g . 
h_set_time:
	ld e,003h		;18b4	1e 03 	. . 
	call sub_18f4h		;18b6	cd f4 18 	. . . 
	jr c,l18ech		;18b9	38 31 	8 1 
	ld b,034h		;18bb	06 34 	. 4 
	cp 032h		;18bd	fe 32 	. 2 
	jr z,l18c5h		;18bf	28 04 	( . 
	jr nc,l18ech		;18c1	30 29 	0 ) 
	ld b,03ah		;18c3	06 3a 	. : 
l18c5h:
	dec e			;18c5	1d 	. 
	ld c,a			;18c6	4f 	O 
	call sub_18f4h		;18c7	cd f4 18 	. . . 
	jr c,l18ech		;18ca	38 20 	8   
	cp b			;18cc	b8 	. 
	jr nc,l18ech		;18cd	30 1d 	0 . 
	ld b,a			;18cf	47 	G 
	dec e			;18d0	1d 	. 
	call sub_18f4h		;18d1	cd f4 18 	. . . 
	jr c,l18ech		;18d4	38 16 	8 . 
	cp 036h		;18d6	fe 36 	. 6 
	jr nc,l18ech		;18d8	30 12 	0 . 
	ld e,a			;18da	5f 	_ 
	call sub_18f4h		;18db	cd f4 18 	. . . 
	ret c			;18de	d8 	. 
	cp 03ah		;18df	fe 3a 	. : 
	ret nc			;18e1	d0 	. 
	ld d,a			;18e2	57 	W 
	ld (0aaa6h),bc		;18e3	ed 43 a6 aa 	. C . . 
	ld (0aaa8h),de		;18e7	ed 53 a8 aa 	. S . . 
	ret			;18eb	c9 	. 
l18ech:
	ld a,(ram_local_head)		;18ec	3a 45 a9 	: E . 
	add a,e			;18ef	83 	. 
	ld (ram_local_head),a		;18f0	32 45 a9 	2 E . 
	ret			;18f3	c9 	. 
sub_18f4h:
	push de			;18f4	d5 	. 
	rst 28h			;18f5	ef 	. 
	pop de			;18f6	d1 	. 
	cp 030h		;18f7	fe 30 	. 0 
	ret			;18f9	c9 	. 
h_set_bcd_date:
	rst 28h			;18fa	ef 	. 
	ld e,002h		;18fb	1e 02 	. . 
	sub 030h		;18fd	d6 30 	. 0 
	cp 005h		;18ff	fe 05 	. . 
	jr nc,l18ech		;1901	30 e9 	0 . 
	ld e,a			;1903	5f 	_ 
	ld d,000h		;1904	16 00 	. . 
	ld hl,0ad6bh		;1906	21 6b ad 	! k . 
	add hl,de			;1909	19 	. 
	add hl,de			;190a	19 	. 
	call sub_190fh		;190b	cd 0f 19 	. . . 
	inc hl			;190e	23 	# 
sub_190fh:
	push hl			;190f	e5 	. 
	rst 28h			;1910	ef 	. 
	pop hl			;1911	e1 	. 
	ld (hl),a			;1912	77 	w 
	ret			;1913	c9 	. 
h_emit_graphic_letter:
	rst 28h			;1914	ef 	. 
	cp 041h		;1915	fe 41 	. A 
	ret c			;1917	d8 	. 
	cp 050h		;1918	fe 50 	. P 
	ret nc			;191a	d0 	. 
	add a,07fh		;191b	c6 7f 	.  
	jp l15f7h		;191d	c3 f7 15 	. . . 
h_esc_M_subdispatch:
	rst 28h			;1920	ef 	. 
	sub 02fh		;1921	d6 2f 	. / 
	cp 026h		;1923	fe 26 	. & 
	ret nc			;1925	d0 	. 
	ld hl,021dch		;1926	21 dc 21 	! . ! 
	jp l0abdh		;1929	c3 bd 0a 	. . . 
h_displaymode_read:
	rst 28h			;192c	ef 	. 
	ld c,a			;192d	4f 	O 
	ld a,(ram_displaymode)		;192e	3a d0 ab 	: . . 
	and 0e0h		;1931	e6 e0 	. . 
	ld b,a			;1933	47 	G 
	ld a,(0aa2eh)		;1934	3a 2e aa 	: . . 
	and 0d0h		;1937	e6 d0 	. . 
	bit 1,c		;1939	cb 49 	. I 
	jr z,l1943h		;193b	28 06 	( . 
	or 008h		;193d	f6 08 	. . 
	set 2,b		;193f	cb d0 	. . 
	jr l194dh		;1941	18 0a 	. . 
l1943h:
	bit 2,c		;1943	cb 51 	. Q 
	jr z,l194dh		;1945	28 06 	( . 
	or 002h		;1947	f6 02 	. . 
	set 0,b		;1949	cb c0 	. . 
	jr l1965h		;194b	18 18 	. . 
l194dh:
	bit 0,c		;194d	cb 41 	. A 
	jr z,l1955h		;194f	28 04 	( . 
	or 001h		;1951	f6 01 	. . 
	set 4,b		;1953	cb e0 	. . 
l1955h:
	bit 4,c		;1955	cb 61 	. a 
	jr z,l195dh		;1957	28 04 	( . 
	or 020h		;1959	f6 20 	.   
	set 3,b		;195b	cb d8 	. . 
l195dh:
	bit 5,c		;195d	cb 69 	. i 
	jr z,l1965h		;195f	28 04 	( . 
	or 004h		;1961	f6 04 	. . 
	set 1,b		;1963	cb c8 	. . 
l1965h:
	ld (0aa2eh),a		;1965	32 2e aa 	2 . . 
	ld (0f000h),a		;1968	32 00 f0 	2 . . 
	ld hl,ram_displaymode		;196b	21 d0 ab 	! . . 
	ld (hl),b			;196e	70 	p 
	jp l0f83h		;196f	c3 83 0f 	. . . 
emul_switcher_entry:
	rst 28h			;1972	ef 	. 
	sub 020h		;1973	d6 20 	.   
	cp 00bh		;1975	fe 0b 	. . 
	ret nc			;1977	d0 	. 
	ld c,a			;1978	4f 	O 
	ld b,000h		;1979	06 00 	. . 
	ld hl,l199bh		;197b	21 9b 19 	! . . 
	add hl,bc			;197e	09 	. 
	ld b,(hl)			;197f	46 	F 
emul_switcher:
	ld a,(ram_setup_emul_bb)		;1980	3a bb aa 	: . . 
	and 0f0h		;1983	e6 f0 	. . 
	or b			;1985	b0 	. 
	ld (ram_setup_emul_bb),a		;1986	32 bb aa 	2 . . 
	call sub_04e4h		;1989	cd e4 04 	. . . 
	call sub_0353h		;198c	cd 53 03 	. S . 
	call l0552h		;198f	cd 52 05 	. R . 
	call sub_023dh		;1992	cd 3d 02 	. = . 
	call sub_0588h		;1995	cd 88 05 	. . . 
	jp l05ech		;1998	c3 ec 05 	. . . 
l199bh:
	nop			;199b	00 	. 
	ld bc,00302h		;199c	01 02 03 	. . . 
	inc b			;199f	04 	. 
	ld b,005h		;19a0	06 05 	. . 
	ex af,af'			;19a2	08 	. 
	add hl,bc			;19a3	09 	. 
	ld a,(bc)			;19a4	0a 	. 
	rlca			;19a5	07 	. 
noop_handler_u4:
	ret			;19a6	c9 	. 
h_write_with_attr:
	rst 28h			;19a7	ef 	. 
	ld e,a			;19a8	5f 	_ 
	ld a,(0ac28h)		;19a9	3a 28 ac 	: ( . 
	ld d,a			;19ac	57 	W 
	jp sub_177fh		;19ad	c3 7f 17 	.  . 
h_set_flag_abd2:
	ld a,0ffh		;19b0	3e ff 	> . 
	ld (0abd2h),a		;19b2	32 d2 ab 	2 . . 
	ret			;19b5	c9 	. 
h_read_char_at_cursor:
	call sub_179ch		;19b6	cd 9c 17 	. . . 
	ld a,(0c000h)		;19b9	3a 00 c0 	: . . 
	ld c,a			;19bc	4f 	O 
	rst 18h			;19bd	df 	. 
	ld c,00dh		;19be	0e 0d 	. . 
	rst 18h			;19c0	df 	. 
	ret			;19c1	c9 	. 
h_tx_letter_N:
	ld c,04eh		;19c2	0e 4e 	. N 
l19c4h:
	jp aux_ring_enq		;19c4	c3 75 14 	. u . 
h_tx_letter_O:
	ld c,04fh		;19c7	0e 4f 	. O 
	jr l19c4h		;19c9	18 f9 	. . 
h_toggle_ab2c:
	ld a,(0ab2ch)		;19cb	3a 2c ab 	: , . 
	xor 0ffh		;19ce	ee ff 	. . 
	ld (0ab2ch),a		;19d0	32 2c ab 	2 , . 
	ret			;19d3	c9 	. 
h_conditional_1276:
	ld a,(0abd1h)		;19d4	3a d1 ab 	: . . 
	and a			;19d7	a7 	. 
	call z,sub_1276h		;19d8	cc 76 12 	. v . 
	ret			;19db	c9 	. 
h_line_insert:
	ld hl,0aa2ah		;19dc	21 2a aa 	! * . 
	set 2,(hl)		;19df	cb d6 	. . 
	jp 038deh		;19e1	c3 de 38 	. . 8 
h_prev_page:
	ld c,001h		;19e4	0e 01 	. . 
	ld a,(0abf5h)		;19e6	3a f5 ab 	: . . 
l19e9h:
	ld e,a			;19e9	5f 	_ 
	ld a,c			;19ea	79 	y 
	ld (0abf7h),a		;19eb	32 f7 ab 	2 . . 
	xor a			;19ee	af 	. 
	ld (0aab6h),a		;19ef	32 b6 aa 	2 . . 
	ld a,e			;19f2	7b 	{ 
	ld (0abd5h),a		;19f3	32 d5 ab 	2 . . 
	ld a,(0aabah)		;19f6	3a ba aa 	: . . 
	bit 1,a		;19f9	cb 4f 	. O 
	jp nz,l0f7fh		;19fb	c2 7f 0f 	.  . 
	ld c,052h		;19fe	0e 52 	. R 
	call sub_1a3dh		;1a00	cd 3d 1a 	. = . 
	ld a,(0abd5h)		;1a03	3a d5 ab 	: . . 
	ld c,a			;1a06	4f 	O 
	jp aux_ring_enq		;1a07	c3 75 14 	. u . 
h_tx_literal:
	ld a,(ram_mode_flags)		;1a0a	3a 29 aa 	: ) . 
	ld b,a			;1a0d	47 	G 
	and 090h		;1a0e	e6 90 	. . 
	jp nz,l0f03h		;1a10	c2 03 0f 	. . . 
	ld a,040h		;1a13	3e 40 	> @ 
	call sub_15d3h		;1a15	cd d3 15 	. . . 
	ld a,b			;1a18	78 	x 
	or 020h		;1a19	f6 20 	.   
l1a1bh:
	ld (ram_mode_flags),a		;1a1b	32 29 aa 	2 ) . 
	jp l0f87h		;1a1e	c3 87 0f 	. . . 
h_set_aa2e_bit6:
	ld a,040h		;1a21	3e 40 	> @ 
	call sub_15ddh		;1a23	cd dd 15 	. . . 
	ld a,(ram_mode_flags)		;1a26	3a 29 aa 	: ) . 
	and 0dfh		;1a29	e6 df 	. . 
	jr l1a1bh		;1a2b	18 ee 	. . 
h_mode_off_abdd:
	ld c,0ffh		;1a2d	0e ff 	. . 
l1a2fh:
	ld a,(0abddh)		;1a2f	3a dd ab 	: . . 
	and a			;1a32	a7 	. 
	ret nz			;1a33	c0 	. 
	ld a,c			;1a34	79 	y 
	ld (0abd3h),a		;1a35	32 d3 ab 	2 . . 
	jp l12d1h		;1a38	c3 d1 12 	. . . 
h_aux_enq_55:
	ld c,055h		;1a3b	0e 55 	. U 
sub_1a3dh:
	ld a,0ffh		;1a3d	3e ff 	> . 
l1a3fh:
	ld (0abc7h),a		;1a3f	32 c7 ab 	2 . . 
	call aux_ring_enq		;1a42	cd 75 14 	. u . 
	jp l0f7fh		;1a45	c3 7f 0f 	.  . 
h_aux_enq_56:
	ld c,056h		;1a48	0e 56 	. V 
	xor a			;1a4a	af 	. 
	jr l1a3fh		;1a4b	18 f2 	. . 
h_aa2e_or_abd0:
	ld e,010h		;1a4d	1e 10 	. . 
	ld a,(ram_displaymode)		;1a4f	3a d0 ab 	: . . 
	or 010h		;1a52	f6 10 	. . 
	ld c,a			;1a54	4f 	O 
	ld a,(0aa2eh)		;1a55	3a 2e aa 	: . . 
	or 001h		;1a58	f6 01 	. . 
	jr l1a62h		;1a5a	18 06 	. . 
l1a5ch:
	ld a,(0aa2eh)		;1a5c	3a 2e aa 	: . . 
	and 0d1h		;1a5f	e6 d1 	. . 
	or d			;1a61	b2 	. 
l1a62h:
	ld (0aa2eh),a		;1a62	32 2e aa 	2 . . 
	ld (0f000h),a		;1a65	32 00 f0 	2 . . 
	ld a,(ram_displaymode)		;1a68	3a d0 ab 	: . . 
	and 0e0h		;1a6b	e6 e0 	. . 
	or c			;1a6d	b1 	. 
	ld (ram_displaymode),a		;1a6e	32 d0 ab 	2 . . 
	ld a,e			;1a71	7b 	{ 
	jp l1bc7h		;1a72	c3 c7 1b 	. . . 
h_screen_mode_0:
	ld d,000h		;1a75	16 00 	. . 
	ld c,000h		;1a77	0e 00 	. . 
l1a79h:
	ld e,00fh		;1a79	1e 0f 	. . 
	jr l1a5ch		;1a7b	18 df 	. . 
h_screen_mode_1:
	ld d,008h		;1a7d	16 08 	. . 
	ld c,004h		;1a7f	0e 04 	. . 
	jr l1a79h		;1a81	18 f6 	. . 
h_screen_mode_2:
	ld d,002h		;1a83	16 02 	. . 
	ld c,001h		;1a85	0e 01 	. . 
	jr l1a79h		;1a87	18 f0 	. . 
h_cursor_right_or_ins:
	call sub_0b79h		;1a89	cd 79 0b 	. y . 
	jp z,02f54h		;1a8c	ca 54 2f 	. T / 
sub_1a8fh:
	ld hl,(0abd7h)		;1a8f	2a d7 ab 	* . . 
	push hl			;1a92	e5 	. 
	cp 012h		;1a93	fe 12 	. . 
	call z,h_dual_action_clr		;1a95	cc 97 1b 	. . . 
	pop iy		;1a98	fd e1 	. . 
	call sub_1b58h		;1a9a	cd 58 1b 	. X . 
	ld hl,l1ad2h		;1a9d	21 d2 1a 	! . . 
	ld e,010h		;1aa0	1e 10 	. . 
l1aa2h:
	push hl			;1aa2	e5 	. 
	call sub_0b9eh		;1aa3	cd 9e 0b 	. . . 
	call sub_1b62h		;1aa6	cd 62 1b 	. b . 
	pop hl			;1aa9	e1 	. 
l1aaah:
	cp 050h		;1aaa	fe 50 	. P 
	jr z,l1aceh		;1aac	28 20 	(   
l1aaeh:
	rst 10h			;1aae	d7 	. 
	ld a,0ach		;1aaf	3e ac 	> . 
	ld (06001h),a		;1ab1	32 01 60 	2 . ` 
	rst 10h			;1ab4	d7 	. 
	ld a,(0c000h)		;1ab5	3a 00 c0 	: . . 
	cp 012h		;1ab8	fe 12 	. . 
	ld a,(0d000h)		;1aba	3a 00 d0 	: . . 
	jp (hl)			;1abd	e9 	. 
l1abeh:
	push af			;1abe	f5 	. 
	or 010h		;1abf	f6 10 	. . 
	jr l1ac6h		;1ac1	18 03 	. . 
l1ac3h:
	push af			;1ac3	f5 	. 
	and 0efh		;1ac4	e6 ef 	. . 
l1ac6h:
	call sub_1ad9h		;1ac6	cd d9 1a 	. . . 
	pop af			;1ac9	f1 	. 
	jr z,l1aceh		;1aca	28 02 	( . 
l1acch:
	djnz l1aaeh		;1acc	10 e0 	. . 
l1aceh:
	rst 10h			;1ace	d7 	. 
	jp sub_1b58h		;1acf	c3 58 1b 	. X . 
l1ad2h:
	xor 008h		;1ad2	ee 08 	. . 
	call sub_1ad9h		;1ad4	cd d9 1a 	. . . 
	jr l1acch		;1ad7	18 f3 	. . 
sub_1ad9h:
	ld (0d000h),a		;1ad9	32 00 d0 	2 . . 
	rst 10h			;1adc	d7 	. 
	ld a,0abh		;1add	3e ab 	> . 
	ld (06001h),a		;1adf	32 01 60 	2 . ` 
	ret			;1ae2	c9 	. 
	ld ix,(0aaa6h)		;1ae3	dd 2a a6 aa 	. * . . 
	ld de,(0aaa8h)		;1ae7	ed 5b a8 aa 	. [ . . 
	call 0297ah		;1aeb	cd 7a 29 	. z ) 
	ld a,09fh		;1aee	3e 9f 	> . 
	ld (06001h),a		;1af0	32 01 60 	2 . ` 
	jp main_entry_in_u5		;1af3	c3 3d 24 	. = $ 
h_scroll_mode_c2:
	ld c,002h		;1af6	0e 02 	. . 
	ld a,(0abf4h)		;1af8	3a f4 ab 	: . . 
	jp l19e9h		;1afb	c3 e9 19 	. . . 
h_clr_aa2a_bit2:
	ld hl,0aa2ah		;1afe	21 2a aa 	! * . 
	res 2,(hl)		;1b01	cb 96 	. . 
	jr l1b0ah		;1b03	18 05 	. . 
h_set_aa2a_bit2:
	ld hl,0aa2ah		;1b05	21 2a aa 	! * . 
	set 2,(hl)		;1b08	cb d6 	. . 
l1b0ah:
	jp 039ebh		;1b0a	c3 eb 39 	. . 9 
	ld c,000h		;1b0d	0e 00 	. . 
l1b0fh:
	ld a,(0abddh)		;1b0f	3a dd ab 	: . . 
	and a			;1b12	a7 	. 
	ret nz			;1b13	c0 	. 
	ld a,c			;1b14	79 	y 
	ld (0abd3h),a		;1b15	32 d3 ab 	2 . . 
	jp l12c4h		;1b18	c3 c4 12 	. . . 
h_mode_on_abdd:
	ld c,000h		;1b1b	0e 00 	. . 
	jp l1a2fh		;1b1d	c3 2f 1a 	. / . 
	ld c,0ffh		;1b20	0e ff 	. . 
	jr l1b0fh		;1b22	18 eb 	. . 
h_call_1d4e_c3:
	ld c,003h		;1b24	0e 03 	. . 
	jp l1d4eh		;1b26	c3 4e 1d 	. N . 
	ret			;1b29	c9 	. 
h_tx_aa8b_mode:
	ld a,(0abd1h)		;1b2a	3a d1 ab 	: . . 
	and a			;1b2d	a7 	. 
	ret nz			;1b2e	c0 	. 
	ld a,003h		;1b2f	3e 03 	> . 
	ld (0aa8bh),a		;1b31	32 8b aa 	2 . . 
	jp sub_1276h		;1b34	c3 76 12 	. v . 
h_set_aa2a_bit3:
	ld a,(0aa2ah)		;1b37	3a 2a aa 	: * . 
	or 008h		;1b3a	f6 08 	. . 
l1b3ch:
	ld (0aa2ah),a		;1b3c	32 2a aa 	2 * . 
	jp l0f87h		;1b3f	c3 87 0f 	. . . 
h_clr_aa2a_bit3:
	ld a,(0aa2ah)		;1b42	3a 2a aa 	: * . 
	and 0f7h		;1b45	e6 f7 	. . 
	jr l1b3ch		;1b47	18 f3 	. . 
sub_1b49h:
	call sub_0b79h		;1b49	cd 79 0b 	. y . 
	ret nz			;1b4c	c0 	. 
	ld ix,(0abd7h)		;1b4d	dd 2a d7 ab 	. * . . 
	push ix		;1b51	dd e5 	. . 
	call sub_1a8fh		;1b53	cd 8f 1a 	. . . 
	pop iy		;1b56	fd e1 	. . 
sub_1b58h:
	ld (0abd7h),iy		;1b58	fd 22 d7 ab 	. " . . 
	call 0450ah		;1b5c	cd 0a 45 	. . E 
	jp l15efh		;1b5f	c3 ef 15 	. . . 
sub_1b62h:
	call sub_15e3h		;1b62	cd e3 15 	. . . 
	ld iy,(0abd7h)		;1b65	fd 2a d7 ab 	. * . . 
	ld a,(0abd7h)		;1b69	3a d7 ab 	: . . 
	ld b,a			;1b6c	47 	G 
	ld a,050h		;1b6d	3e 50 	> P 
	sub b			;1b6f	90 	. 
	ld b,a			;1b70	47 	G 
	ret			;1b71	c9 	. 
h_dual_action_set:
	ld hl,rst08_handler		;1b72	21 08 00 	! . . 
	rst 20h			;1b75	e7 	. 
	jr z,l1b83h		;1b76	28 0b 	( . 
	call sub_1b49h		;1b78	cd 49 1b 	. I . 
	ld hl,l1abeh		;1b7b	21 be 1a 	! . . 
	ld e,012h		;1b7e	1e 12 	. . 
	jp l1aa2h		;1b80	c3 a2 1a 	. . . 
l1b83h:
	ld a,(0aa2ah)		;1b83	3a 2a aa 	: * . 
	or 040h		;1b86	f6 40 	. @ 
	ld (0aa2ah),a		;1b88	32 2a aa 	2 * . 
	ld c,010h		;1b8b	0e 10 	. . 
	call set_displaymode_bit		;1b8d	cd 83 1c 	. . . 
	ld a,(0ac28h)		;1b90	3a 28 ac 	: ( . 
	or 010h		;1b93	f6 10 	. . 
	jr l1bc7h		;1b95	18 30 	. 0 
h_dual_action_clr:
	ld hl,rst08_handler		;1b97	21 08 00 	! . . 
	rst 20h			;1b9a	e7 	. 
	jr z,l1ba8h		;1b9b	28 0b 	( . 
	call sub_1b49h		;1b9d	cd 49 1b 	. I . 
	ld hl,l1ac3h		;1ba0	21 c3 1a 	! . . 
	ld e,012h		;1ba3	1e 12 	. . 
	jp l1aa2h		;1ba5	c3 a2 1a 	. . . 
l1ba8h:
	ld a,(0aa2ah)		;1ba8	3a 2a aa 	: * . 
	and 0bfh		;1bab	e6 bf 	. . 
	ld (0aa2ah),a		;1bad	32 2a aa 	2 * . 
	ld c,010h		;1bb0	0e 10 	. . 
	call clr_displaymode_bit		;1bb2	cd 91 1c 	. . . 
	ld a,(0ac28h)		;1bb5	3a 28 ac 	: ( . 
	and 0efh		;1bb8	e6 ef 	. . 
	jr l1bc7h		;1bba	18 0b 	. . 
h_mode_a_check:
	ld a,(ram_mode_flags)		;1bbc	3a 29 aa 	: ) . 
	or 010h		;1bbf	f6 10 	. . 
	ld (ram_mode_flags),a		;1bc1	32 29 aa 	2 ) . 
l1bc4h:
	ld a,(ram_displaymode)		;1bc4	3a d0 ab 	: . . 
l1bc7h:
	ld (0ac28h),a		;1bc7	32 28 ac 	2 ( . 
	call l0f83h		;1bca	cd 83 0f 	. . . 
	jp l0f87h		;1bcd	c3 87 0f 	. . . 
h_mode_conditional:
h_clr_mode_nibble:
	ld a,(ram_mode_flags)		;1bd0	3a 29 aa 	: ) . 
	and 0efh		;1bd3	e6 ef 	. . 
	ld (ram_mode_flags),a		;1bd5	32 29 aa 	2 ) . 
	ld a,(ram_displaymode)		;1bd8	3a d0 ab 	: . . 
	and 0f0h		;1bdb	e6 f0 	. . 
	jr l1bc7h		;1bdd	18 e8 	. . 
h_abdd_pair_off:
	ld c,000h		;1bdf	0e 00 	. . 
	jr l1be5h		;1be1	18 02 	. . 
h_abdd_pair_on:
	ld c,0ffh		;1be3	0e ff 	. . 
l1be5h:
	ld a,(0abddh)		;1be5	3a dd ab 	: . . 
	and a			;1be8	a7 	. 
	ret nz			;1be9	c0 	. 
	ld a,c			;1bea	79 	y 
	ld (0abd3h),a		;1beb	32 d3 ab 	2 . . 
	ld a,0ffh		;1bee	3e ff 	> . 
	ld (0abddh),a		;1bf0	32 dd ab 	2 . . 
	ld (0aa9ch),a		;1bf3	32 9c aa 	2 . . 
	ld a,(0abd8h)		;1bf6	3a d8 ab 	: . . 
	ld hl,0ac09h		;1bf9	21 09 ac 	! . . 
	add a,(hl)			;1bfc	86 	. 
	ld b,a			;1bfd	47 	G 
	ld e,a			;1bfe	5f 	_ 
	ld d,000h		;1bff	16 00 	. . 
	ld hl,(0ac1eh)		;1c01	2a 1e ac 	* . . 
	ld (0ad69h),hl		;1c04	22 69 ad 	" i . 
	add hl,de			;1c07	19 	. 
	ld a,(0abd7h)		;1c08	3a d7 ab 	: . . 
	ld c,a			;1c0b	4f 	O 
	inc b			;1c0c	04 	. 
	call 0297ah		;1c0d	cd 7a 29 	. z ) 
l1c10h:
	push hl			;1c10	e5 	. 
	ld a,(hl)			;1c11	7e 	~ 
	call 03d35h		;1c12	cd 35 3d 	. 5 = 
	ld l,c			;1c15	69 	i 
	ld h,000h		;1c16	26 00 	& . 
	add hl,de			;1c18	19 	. 
l1c19h:
	ld (06006h),hl		;1c19	22 06 60 	" . ` 
	ld a,0a4h		;1c1c	3e a4 	> . 
	ld (06001h),a		;1c1e	32 01 60 	2 . ` 
	ld a,(0d000h)		;1c21	3a 00 d0 	: . . 
	and 010h		;1c24	e6 10 	. . 
	jr nz,l1c2fh		;1c26	20 07 	  . 
	ld a,(0c000h)		;1c28	3a 00 c0 	: . . 
	cp 002h		;1c2b	fe 02 	. . 
	jr z,l1c58h		;1c2d	28 29 	( ) 
l1c2fh:
	dec hl			;1c2f	2b 	+ 
	dec c			;1c30	0d 	. 
	jp p,l1c19h		;1c31	f2 19 1c 	. . . 
	pop hl			;1c34	e1 	. 
l1c35h:
	dec hl			;1c35	2b 	+ 
	djnz l1c50h		;1c36	10 18 	. . 
l1c38h:
	ld c,000h		;1c38	0e 00 	. . 
l1c3ah:
	ld (0abd9h),bc		;1c3a	ed 43 d9 ab 	. C . . 
	ld a,04fh		;1c3e	3e 4f 	> O 
	ld (0abe5h),a		;1c40	32 e5 ab 	2 . . 
	ld a,(0ac1dh)		;1c43	3a 1d ac 	: . . 
	dec a			;1c46	3d 	= 
	ld (0abe6h),a		;1c47	32 e6 ab 	2 . . 
	call sub_0a27h		;1c4a	cd 27 0a 	. ' . 
	jp l0f7bh		;1c4d	c3 7b 0f 	. { . 
l1c50h:
	bit 7,(hl)		;1c50	cb 7e 	. ~ 
	jr nz,l1c35h		;1c52	20 e1 	  . 
	ld c,04fh		;1c54	0e 4f 	. O 
	jr l1c10h		;1c56	18 b8 	. . 
l1c58h:
	pop hl			;1c58	e1 	. 
	dec b			;1c59	05 	. 
	inc c			;1c5a	0c 	. 
	ld a,c			;1c5b	79 	y 
	cp 050h		;1c5c	fe 50 	. P 
	jr c,l1c3ah		;1c5e	38 da 	8 . 
	inc b			;1c60	04 	. 
	ld a,(0ac1dh)		;1c61	3a 1d ac 	: . . 
	cp b			;1c64	b8 	. 
	jr nz,l1c38h		;1c65	20 d1 	  . 
	ld b,000h		;1c67	06 00 	. . 
	jr l1c38h		;1c69	18 cd 	. . 
h_clr_aa2a_bit2_E:
	ld hl,0aa2ah		;1c6b	21 2a aa 	! * . 
	res 2,(hl)		;1c6e	cb 96 	. . 
	jp 038deh		;1c70	c3 de 38 	. . 8 
h_esc_j_set_bit3:
	ld c,008h		;1c73	0e 08 	. . 
l1c75h:
	call set_displaymode_bit		;1c75	cd 83 1c 	. . . 
l1c78h:
	ld a,(ram_mode_flags)		;1c78	3a 29 aa 	: ) . 
	and 010h		;1c7b	e6 10 	. . 
	jp z,l0f83h		;1c7d	ca 83 0f 	. . . 
	jp l1bc4h		;1c80	c3 c4 1b 	. . . 
set_displaymode_bit:
	ld hl,ram_displaymode		;1c83	21 d0 ab 	! . . 
	ld a,(hl)			;1c86	7e 	~ 
	or c			;1c87	b1 	. 
	ld (hl),a			;1c88	77 	w 
	ret			;1c89	c9 	. 
h_esc_k_clr_bit3:
	ld c,008h		;1c8a	0e 08 	. . 
l1c8ch:
	call clr_displaymode_bit		;1c8c	cd 91 1c 	. . . 
	jr l1c78h		;1c8f	18 e7 	. . 
clr_displaymode_bit:
	ld a,c			;1c91	79 	y 
	cpl			;1c92	2f 	/ 
	ld hl,ram_displaymode		;1c93	21 d0 ab 	! . . 
	and (hl)			;1c96	a6 	. 
	ld (hl),a			;1c97	77 	w 
	ret			;1c98	c9 	. 
h_esc_l_set_bit1:
	ld c,002h		;1c99	0e 02 	. . 
	jr l1c75h		;1c9b	18 d8 	. . 
h_esc_m_clr_bit1:
	ld c,002h		;1c9d	0e 02 	. . 
	jr l1c8ch		;1c9f	18 eb 	. . 
h_esc_n_set_bit2:
	ld c,004h		;1ca1	0e 04 	. . 
	jr l1c75h		;1ca3	18 d0 	. . 
h_esc_o_clr_bit2:
	ld c,004h		;1ca5	0e 04 	. . 
	jr l1c8ch		;1ca7	18 e3 	. . 
h_esc_p_set_bit0:
	ld c,001h		;1ca9	0e 01 	. . 
	jr l1c75h		;1cab	18 c8 	. . 
h_esc_q_clr_bit0:
	ld c,001h		;1cad	0e 01 	. . 
	jr l1c8ch		;1caf	18 db 	. . 
	ld a,(0aabdh)		;1cb1	3a bd aa 	: . . 
	and 0feh		;1cb4	e6 fe 	. . 
	jr l1cbdh		;1cb6	18 05 	. . 
	ld a,(0aabdh)		;1cb8	3a bd aa 	: . . 
	or 001h		;1cbb	f6 01 	. . 
l1cbdh:
	ld (0aabdh),a		;1cbd	32 bd aa 	2 . . 
	ret			;1cc0	c9 	. 
	ret			;1cc1	c9 	. 
	ret			;1cc2	c9 	. 
sub_1cc3h:
	ld hl,0500dh		;1cc3	21 0d 50 	! . P 
	ld bc,0aab7h		;1cc6	01 b7 aa 	. . . 
	ld de,05000h		;1cc9	11 00 50 	. . P 
	jp l09a6h		;1ccc	c3 a6 09 	. . . 
	ld hl,ram_setup_flags_b9		;1ccf	21 b9 aa 	! . . 
	set 2,(hl)		;1cd2	cb d6 	. . 
	ld c,059h		;1cd4	0e 59 	. Y 
l1cd6h:
	jp aux_ring_enq		;1cd6	c3 75 14 	. u . 
	ld hl,ram_setup_flags_b9		;1cd9	21 b9 aa 	! . . 
	res 2,(hl)		;1cdc	cb 96 	. . 
	ld c,058h		;1cde	0e 58 	. X 
	jr l1cd6h		;1ce0	18 f4 	. . 
	ld a,(ram_displaymode)		;1ce2	3a d0 ab 	: . . 
	or 01fh		;1ce5	f6 1f 	. . 
	jr l1ceeh		;1ce7	18 05 	. . 
	ld a,(ram_displaymode)		;1ce9	3a d0 ab 	: . . 
	and 0e0h		;1cec	e6 e0 	. . 
l1ceeh:
	jp l1bc7h		;1cee	c3 c7 1b 	. . . 
	ld hl,0aa8ch		;1cf1	21 8c aa 	! . . 
	bit 7,(hl)		;1cf4	cb 7e 	. ~ 
	ret z			;1cf6	c8 	. 
	res 1,(hl)		;1cf7	cb 8e 	. . 
	ret			;1cf9	c9 	. 
	ld hl,0aa8ch		;1cfa	21 8c aa 	! . . 
	bit 7,(hl)		;1cfd	cb 7e 	. ~ 
	ret z			;1cff	c8 	. 
	set 1,(hl)		;1d00	cb ce 	. . 
	ret			;1d02	c9 	. 
	ld hl,0aa8ch		;1d03	21 8c aa 	! . . 
	res 7,(hl)		;1d06	cb be 	. . 
	ld hl,0aab8h		;1d08	21 b8 aa 	! . . 
	set 3,(hl)		;1d0b	cb de 	. . 
	ret			;1d0d	c9 	. 
	ld hl,0aa8ch		;1d0e	21 8c aa 	! . . 
	set 7,(hl)		;1d11	cb fe 	. . 
	ld hl,0aab8h		;1d13	21 b8 aa 	! . . 
	res 3,(hl)		;1d16	cb 9e 	. . 
	ret			;1d18	c9 	. 
	call sub_0cdeh		;1d19	cd de 0c 	. . . 
	jp h_aux_enq_56		;1d1c	c3 48 1a 	. H . 
	ld hl,0ac3bh		;1d1f	21 3b ac 	! ; . 
	set 3,(hl)		;1d22	cb de 	. . 
	ld a,(hl)			;1d24	7e 	~ 
	ld (io_uart_primary),a		;1d25	32 01 80 	2 . . 
	ld a,010h		;1d28	3e 10 	> . 
	ld (0ac10h),a		;1d2a	32 10 ac 	2 . . 
	ret			;1d2d	c9 	. 
	call sub_1862h		;1d2e	cd 62 18 	. b . 
	ld c,002h		;1d31	0e 02 	. . 
l1d33h:
	call sub_1d55h		;1d33	cd 55 1d 	. U . 
	ld de,ram_setup_flags_b9		;1d36	11 b9 aa 	. . . 
	ld a,(de)			;1d39	1a 	. 
	and 0fch		;1d3a	e6 fc 	. . 
	or c			;1d3c	b1 	. 
	ld (de),a			;1d3d	12 	. 
	call sub_0524h		;1d3e	cd 24 05 	. $ . 
	jp l0f87h		;1d41	c3 87 0f 	. . . 
h_setup_flag_tx:
	ld a,(ram_setup_flags_b9)		;1d44	3a b9 aa 	: . . 
	bit 1,a		;1d47	cb 4f 	. O 
	ret z			;1d49	c8 	. 
	ld a,(0ad5fh)		;1d4a	3a 5f ad 	: _ . 
	ld c,a			;1d4d	4f 	O 
l1d4eh:
	push bc			;1d4e	c5 	. 
	call sub_0084h		;1d4f	cd 84 00 	. . . 
	pop bc			;1d52	c1 	. 
	jr l1d33h		;1d53	18 de 	. . 
sub_1d55h:
	ld a,(ram_setup_flags_b9)		;1d55	3a b9 aa 	: . . 
	bit 1,a		;1d58	cb 4f 	. O 
	ret nz			;1d5a	c0 	. 
	and 001h		;1d5b	e6 01 	. . 
	ld (0ad5fh),a		;1d5d	32 5f ad 	2 _ . 
	ret			;1d60	c9 	. 
xlate_aux_emul_0_7:
	nop			;1d61	00 	. 
	nop			;1d62	00 	. 
	nop			;1d63	00 	. 
	nop			;1d64	00 	. 
	nop			;1d65	00 	. 
	nop			;1d66	00 	. 
	nop			;1d67	00 	. 
	ld bc,00302h		;1d68	01 02 03 	. . . 
	inc b			;1d6b	04 	. 
	dec b			;1d6c	05 	. 
	ld b,007h		;1d6d	06 07 	. . 
	dec bc			;1d6f	0b 	. 
	inc c			;1d70	0c 	. 
	nop			;1d71	00 	. 
	ld d,000h		;1d72	16 00 	. . 
	rla			;1d74	17 	. 
	nop			;1d75	00 	. 
	nop			;1d76	00 	. 
	nop			;1d77	00 	. 
	nop			;1d78	00 	. 
	nop			;1d79	00 	. 
	nop			;1d7a	00 	. 
	ex af,af'			;1d7b	08 	. 
	nop			;1d7c	00 	. 
	nop			;1d7d	00 	. 
	nop			;1d7e	00 	. 
	add hl,bc			;1d7f	09 	. 
	ld a,(bc)			;1d80	0a 	. 
	inc bc			;1d81	03 	. 
	ld c,000h		;1d82	0e 00 	. . 
	rrca			;1d84	0f 	. 
	nop			;1d85	00 	. 
	ld a,(de)			;1d86	1a 	. 
	nop			;1d87	00 	. 
	dec c			;1d88	0d 	. 
	ld bc,l0209h		;1d89	01 09 02 	. . . 
	dec bc			;1d8c	0b 	. 
	inc b			;1d8d	04 	. 
	inc c			;1d8e	0c 	. 
	ld b,006h		;1d8f	06 06 	. . 
	dec bc			;1d91	0b 	. 
	dec c			;1d92	0d 	. 
	inc c			;1d93	0c 	. 
	dec d			;1d94	15 	. 
	ld c,011h		;1d95	0e 11 	. . 
	rrca			;1d97	0f 	. 
	ld (de),a			;1d98	12 	. 
	djnz l1daah		;1d99	10 0f 	. . 
	ld (de),a			;1d9b	12 	. 
	inc de			;1d9c	13 	. 
	inc d			;1d9d	14 	. 
	inc d			;1d9e	14 	. 
	dec d			;1d9f	15 	. 
	ld (bc),a			;1da0	02 	. 
	ld a,(de)			;1da1	1a 	. 
	dec b			;1da2	05 	. 
	ld bc,l1005h		;1da3	01 05 10 	. . . 
	ex af,af'			;1da6	08 	. 
	ld bc,00609h		;1da7	01 09 06 	. . . 
l1daah:
	ld b,00bh		;1daa	06 0b 	. . 
	nop			;1dac	00 	. 
	inc c			;1dad	0c 	. 
	dec d			;1dae	15 	. 
	ld c,011h		;1daf	0e 11 	. . 
	rrca			;1db1	0f 	. 
	ld (de),a			;1db2	12 	. 
	dec d			;1db3	15 	. 
	ld (bc),a			;1db4	02 	. 
	ld a,(de)			;1db5	1a 	. 
	dec b			;1db6	05 	. 
	inc bc			;1db7	03 	. 
	ld c,000h		;1db8	0e 00 	. . 
	rrca			;1dba	0f 	. 
	nop			;1dbb	00 	. 
	ld a,(de)			;1dbc	1a 	. 
	dec d			;1dbd	15 	. 
	ld b,00eh		;1dbe	06 0e 	. . 
	jr l1dd1h		;1dc0	18 0f 	. . 
	add hl,de			;1dc2	19 	. 
	ld (de),a			;1dc3	12 	. 
	ld a,(de)			;1dc4	1a 	. 
	inc d			;1dc5	14 	. 
	inc d			;1dc6	14 	. 
	ld d,004h		;1dc7	16 04 	. . 
	ld a,(de)			;1dc9	1a 	. 
	dec d			;1dca	15 	. 
xlate_aux_emul_8_10:
	nop			;1dcb	00 	. 
	nop			;1dcc	00 	. 
	nop			;1dcd	00 	. 
	nop			;1dce	00 	. 
	nop			;1dcf	00 	. 
	nop			;1dd0	00 	. 
l1dd1h:
	nop			;1dd1	00 	. 
	ld bc,00302h		;1dd2	01 02 03 	. . . 
	inc b			;1dd5	04 	. 
	nop			;1dd6	00 	. 
	nop			;1dd7	00 	. 
	rlca			;1dd8	07 	. 
	nop			;1dd9	00 	. 
	nop			;1dda	00 	. 
	ld b,016h		;1ddb	06 16 	. . 
	nop			;1ddd	00 	. 
	rla			;1dde	17 	. 
	nop			;1ddf	00 	. 
	nop			;1de0	00 	. 
	nop			;1de1	00 	. 
	nop			;1de2	00 	. 
	nop			;1de3	00 	. 
	nop			;1de4	00 	. 
	nop			;1de5	00 	. 
	nop			;1de6	00 	. 
	nop			;1de7	00 	. 
	nop			;1de8	00 	. 
	nop			;1de9	00 	. 
	ld a,(bc)			;1dea	0a 	. 
	ld bc,00e0eh		;1deb	01 0e 0e 	. . . 
xlate_base_emul_0_6:
	nop			;1dee	00 	. 
	nop			;1def	00 	. 
	ld b,c			;1df0	41 	A 
	ld b,b			;1df1	40 	@ 
	nop			;1df2	00 	. 
	nop			;1df3	00 	. 
	ld e,c			;1df4	59 	Y 
	ld a,b			;1df5	78 	x 
	ld l,a			;1df6	6f 	o 
	ld h,e			;1df7	63 	c 
	ld l,l			;1df8	6d 	m 
	dec hl			;1df9	2b 	+ 
	nop			;1dfa	00 	. 
	nop			;1dfb	00 	. 
	nop			;1dfc	00 	. 
	nop			;1dfd	00 	. 
	nop			;1dfe	00 	. 
	ld c,d			;1dff	4a 	J 
	ld (hl),d			;1e00	72 	r 
	ld l,h			;1e01	6c 	l 
	ld d,h			;1e02	54 	T 
	ld d,e			;1e03	53 	S 
	ccf			;1e04	3f 	? 
	ld d,l			;1e05	55 	U 
	dec de			;1e06	1b 	. 
	inc e			;1e07	1c 	. 
	dec hl			;1e08	2b 	+ 
	add a,e			;1e09	83 	. 
	nop			;1e0a	00 	. 
	inc c			;1e0b	0c 	. 
	nop			;1e0c	00 	. 
	halt			;1e0d	76 	v 
	ld c,(hl)			;1e0e	4e 	N 
	ld (hl),b			;1e0f	70 	p 
	ld d,(hl)			;1e10	56 	V 
	ld d,a			;1e11	57 	W 
	ld e,b			;1e12	58 	X 
	ld (hl),a			;1e13	77 	w 
	ld h,a			;1e14	67 	g 
	dec d			;1e15	15 	. 
	nop			;1e16	00 	. 
	ld b,d			;1e17	42 	B 
	dec (hl)			;1e18	35 	5 
	ld e,b			;1e19	58 	X 
	nop			;1e1a	00 	. 
	jr l1e66h		;1e1b	18 49 	. I 
	inc l			;1e1d	2c 	, 
	inc sp			;1e1e	33 	3 
	ld d,b			;1e1f	50 	P 
	inc (hl)			;1e20	34 	4 
	ld l,c			;1e21	69 	i 
	ld (hl),05ah		;1e22	36 5a 	6 Z 
	ld l,d			;1e24	6a 	j 
	ld d,c			;1e25	51 	Q 
	ld h,l			;1e26	65 	e 
	scf			;1e27	37 	7 
	nop			;1e28	00 	. 
	nop			;1e29	00 	. 
	nop			;1e2a	00 	. 
	nop			;1e2b	00 	. 
	nop			;1e2c	00 	. 
	nop			;1e2d	00 	. 
	nop			;1e2e	00 	. 
	nop			;1e2f	00 	. 
	nop			;1e30	00 	. 
	nop			;1e31	00 	. 
	nop			;1e32	00 	. 
	dec bc			;1e33	0b 	. 
	nop			;1e34	00 	. 
	nop			;1e35	00 	. 
	nop			;1e36	00 	. 
	ld c,a			;1e37	4f 	O 
	nop			;1e38	00 	. 
	nop			;1e39	00 	. 
	nop			;1e3a	00 	. 
	nop			;1e3b	00 	. 
	nop			;1e3c	00 	. 
	nop			;1e3d	00 	. 
	nop			;1e3e	00 	. 
	nop			;1e3f	00 	. 
	nop			;1e40	00 	. 
	nop			;1e41	00 	. 
	add a,c			;1e42	81 	. 
	nop			;1e43	00 	. 
	ld h,c			;1e44	61 	a 
	ld h,d			;1e45	62 	b 
	ld (hl),c			;1e46	71 	q 
	add a,d			;1e47	82 	. 
	ld c,h			;1e48	4c 	L 
	jr nz,l1e4bh		;1e49	20 00 	  . 
l1e4bh:
	inc b			;1e4b	04 	. 
	nop			;1e4c	00 	. 
	nop			;1e4d	00 	. 
	inc c			;1e4e	0c 	. 
	ld h,c			;1e4f	61 	a 
	ld (hl),e			;1e50	73 	s 
	ld h,(hl)			;1e51	66 	f 
	inc bc			;1e52	03 	. 
	ld h,a			;1e53	67 	g 
	ld c,068h		;1e54	0e 68 	. h 
	rrca			;1e56	0f 	. 
	ld l,d			;1e57	6a 	j 
	ld a,c			;1e58	79 	y 
	ld l,e			;1e59	6b 	k 
	ld a,d			;1e5a	7a 	z 
	ld l,h			;1e5b	6c 	l 
	ld a,e			;1e5c	7b 	{ 
	ld l,l			;1e5d	6d 	m 
	ld a,h			;1e5e	7c 	| 
	ld l,(hl)			;1e5f	6e 	n 
	ld a,l			;1e60	7d 	} 
	ld l,a			;1e61	6f 	o 
	ld a,(hl)			;1e62	7e 	~ 
	ld (hl),b			;1e63	70 	p 
	ld a,a			;1e64	7f 	 
	ld (hl),c			;1e65	71 	q 
l1e66h:
	add a,b			;1e66	80 	. 
	ld c,02bh		;1e67	0e 2b 	. + 
	dec hl			;1e69	2b 	+ 
	inc l			;1e6a	2c 	, 
	ccf			;1e6b	3f 	? 
	dec l			;1e6c	2d 	- 
	ld d,l			;1e6d	55 	U 
	ld l,036h		;1e6e	2e 36 	. 6 
	cpl			;1e70	2f 	/ 
	scf			;1e71	37 	7 
	ld (hl),000h		;1e72	36 00 	6 . 
	scf			;1e74	37 	7 
	nop			;1e75	00 	. 
	ld a,(04100h)		;1e76	3a 00 41 	: . A 
	ld e,b			;1e79	58 	X 
	ld b,h			;1e7a	44 	D 
	nop			;1e7b	00 	. 
	ld d,h			;1e7c	54 	T 
	add a,c			;1e7d	81 	. 
	ld e,c			;1e7e	59 	Y 
	add a,d			;1e7f	82 	. 
	ld (hl),h			;1e80	74 	t 
	nop			;1e81	00 	. 
	ld a,c			;1e82	79 	y 
	nop			;1e83	00 	. 
	ld b,026h		;1e84	06 26 	. & 
	nop			;1e86	00 	. 
	daa			;1e87	27 	' 
	nop			;1e88	00 	. 
	inc l			;1e89	2c 	, 
	dec d			;1e8a	15 	. 
	ld b,c			;1e8b	41 	A 
	nop			;1e8c	00 	. 
	ld b,a			;1e8d	47 	G 
	ld c,b			;1e8e	48 	H 
	ld e,c			;1e8f	59 	Y 
	scf			;1e90	37 	7 
	ld d,021h		;1e91	16 21 	. ! 
	ld l,h			;1e93	6c 	l 
	ld (02300h),hl		;1e94	22 00 23 	" . # 
	nop			;1e97	00 	. 
	ld h,000h		;1e98	26 00 	& . 
	daa			;1e9a	27 	' 
	nop			;1e9b	00 	. 
	jr z,l1e9eh		;1e9c	28 00 	( . 
l1e9eh:
	add hl,hl			;1e9e	29 	) 
	nop			;1e9f	00 	. 
	inc l			;1ea0	2c 	, 
	ld d,h			;1ea1	54 	T 
	dec l			;1ea2	2d 	- 
	ld d,e			;1ea3	53 	S 
	ld l,03fh		;1ea4	2e 3f 	. ? 
	jr nc,l1ec1h		;1ea6	30 19 	0 . 
	inc sp			;1ea8	33 	3 
	dec (hl)			;1ea9	35 	5 
	inc (hl)			;1eaa	34 	4 
	ld e,b			;1eab	58 	X 
	dec (hl)			;1eac	35 	5 
	ld b,b			;1ead	40 	@ 
	ld (hl),041h		;1eae	36 41 	6 A 
	dec a			;1eb0	3d 	= 
	nop			;1eb1	00 	. 
	ld b,c			;1eb2	41 	A 
	nop			;1eb3	00 	. 
	ld c,d			;1eb4	4a 	J 
	nop			;1eb5	00 	. 
	ld c,e			;1eb6	4b 	K 
	ld (hl),054h		;1eb7	36 54 	6 T 
	nop			;1eb9	00 	. 
	ld e,c			;1eba	59 	Y 
	inc c			;1ebb	0c 	. 
	ld l,e			;1ebc	6b 	k 
	scf			;1ebd	37 	7 
	inc e			;1ebe	1c 	. 
	inc h			;1ebf	24 	$ 
	nop			;1ec0	00 	. 
l1ec1h:
	dec h			;1ec1	25 	% 
	ld d,(hl)			;1ec2	56 	V 
	ld h,000h		;1ec3	26 00 	& . 
	daa			;1ec5	27 	' 
	nop			;1ec6	00 	. 
	jr z,l1ec9h		;1ec7	28 00 	( . 
l1ec9h:
	add hl,hl			;1ec9	29 	) 
	nop			;1eca	00 	. 
	inc l			;1ecb	2c 	, 
	ld d,a			;1ecc	57 	W 
	dec l			;1ecd	2d 	- 
	ld e,b			;1ece	58 	X 
	ld l,067h		;1ecf	2e 67 	. g 
	cpl			;1ed1	2f 	/ 
	ld b,d			;1ed2	42 	B 
	jr nc,l1f0ah		;1ed3	30 35 	0 5 
	inc a			;1ed5	3c 	< 
	ld e,b			;1ed6	58 	X 
	dec a			;1ed7	3d 	= 
	ld l,03eh		;1ed8	2e 3e 	. > 
	cpl			;1eda	2f 	/ 
	ld b,c			;1edb	41 	A 
	inc a			;1edc	3c 	< 
	ld b,d			;1edd	42 	B 
	dec a			;1ede	3d 	= 
	ld b,e			;1edf	43 	C 
	ld c,l			;1ee0	4d 	M 
	ld b,h			;1ee1	44 	D 
	ld d,d			;1ee2	52 	R 
	ld b,l			;1ee3	45 	E 
	ld (hl),a			;1ee4	77 	w 
	ld b,(hl)			;1ee5	46 	F 
	ld a,(03b47h)		;1ee6	3a 47 3b 	: G ; 
	ld c,b			;1ee9	48 	H 
	ld a,049h		;1eea	3e 49 	> I 
	ld l,(hl)			;1eec	6e 	n 
	ld c,d			;1eed	4a 	J 
	scf			;1eee	37 	7 
	ld c,e			;1eef	4b 	K 
	ld (hl),054h		;1ef0	36 54 	6 T 
	nop			;1ef2	00 	. 
	ld e,c			;1ef3	59 	Y 
	inc c			;1ef4	0c 	. 
	ld e,d			;1ef5	5a 	Z 
	ld l,e			;1ef6	6b 	k 
	inc de			;1ef7	13 	. 
	ld hl,02558h		;1ef8	21 58 25 	! X % 
	ld l,c			;1efb	69 	i 
	dec l			;1efc	2d 	- 
	ld b,02fh		;1efd	06 2f 	. / 
	ld h,h			;1eff	64 	d 
	ld b,c			;1f00	41 	A 
	ld e,b			;1f01	58 	X 
	ld b,h			;1f02	44 	D 
	nop			;1f03	00 	. 
	ld c,e			;1f04	4b 	K 
	ld c,c			;1f05	49 	I 
	ld c,(hl)			;1f06	4e 	N 
	nop			;1f07	00 	. 
	ld d,e			;1f08	53 	S 
	ld (hl),h			;1f09	74 	t 
l1f0ah:
	ld d,h			;1f0a	54 	T 
	ld (hl),059h		;1f0b	36 59 	6 Y 
	scf			;1f0d	37 	7 
	ld e,(hl)			;1f0e	5e 	^ 
	ld e,e			;1f0f	5b 	[ 
	ld e,a			;1f10	5f 	_ 
	ld e,h			;1f11	5c 	\ 
	ld l,d			;1f12	6a 	j 
	ld e,l			;1f13	5d 	] 
	ld l,e			;1f14	6b 	k 
	ld h,(hl)			;1f15	66 	f 
	ld l,h			;1f16	6c 	l 
	ld e,a			;1f17	5f 	_ 
	ld l,l			;1f18	6d 	m 
	ld h,b			;1f19	60 	` 
	ld (hl),c			;1f1a	71 	q 
	ld e,(hl)			;1f1b	5e 	^ 
	ld (hl),e			;1f1c	73 	s 
	ld (hl),l			;1f1d	75 	u 
xlate_base_emul_8_10:
	nop			;1f1e	00 	. 
	nop			;1f1f	00 	. 
	nop			;1f20	00 	. 
	nop			;1f21	00 	. 
	nop			;1f22	00 	. 
	ld c,e			;1f23	4b 	K 
	ld b,c			;1f24	41 	A 
	nop			;1f25	00 	. 
	nop			;1f26	00 	. 
	nop			;1f27	00 	. 
	nop			;1f28	00 	. 
	dec a			;1f29	3d 	= 
	inc a			;1f2a	3c 	< 
	nop			;1f2b	00 	. 
	nop			;1f2c	00 	. 
	ld (hl),000h		;1f2d	36 00 	6 . 
	dec c			;1f2f	0d 	. 
	ld a,034h		;1f30	3e 34 	> 4 
	nop			;1f32	00 	. 
	ld b,b			;1f33	40 	@ 
	nop			;1f34	00 	. 
	ld sp,04437h		;1f35	31 37 44 	1 7 D 
	ld (hl),a			;1f38	77 	w 
	nop			;1f39	00 	. 
	add hl,hl			;1f3a	29 	) 
	ld b,e			;1f3b	43 	C 
	nop			;1f3c	00 	. 
	ld b,l			;1f3d	45 	E 
	nop			;1f3e	00 	. 
	nop			;1f3f	00 	. 
	nop			;1f40	00 	. 
	ld d,(hl)			;1f41	56 	V 
	nop			;1f42	00 	. 
	nop			;1f43	00 	. 
	nop			;1f44	00 	. 
	nop			;1f45	00 	. 
	nop			;1f46	00 	. 
	nop			;1f47	00 	. 
	dec (hl)			;1f48	35 	5 
	nop			;1f49	00 	. 
	nop			;1f4a	00 	. 
	nop			;1f4b	00 	. 
	nop			;1f4c	00 	. 
	ld c,(hl)			;1f4d	4e 	N 
	nop			;1f4e	00 	. 
	ld c,d			;1f4f	4a 	J 
	ld (hl),d			;1f50	72 	r 
	ld l,h			;1f51	6c 	l 
	nop			;1f52	00 	. 
	nop			;1f53	00 	. 
	ccf			;1f54	3f 	? 
	ld d,l			;1f55	55 	U 
	dec de			;1f56	1b 	. 
	inc e			;1f57	1c 	. 
	nop			;1f58	00 	. 
	nop			;1f59	00 	. 
	nop			;1f5a	00 	. 
	nop			;1f5b	00 	. 
	nop			;1f5c	00 	. 
	ld e,b			;1f5d	58 	X 
	nop			;1f5e	00 	. 
	nop			;1f5f	00 	. 
	nop			;1f60	00 	. 
	ld d,a			;1f61	57 	W 
	nop			;1f62	00 	. 
	nop			;1f63	00 	. 
	nop			;1f64	00 	. 
	dec d			;1f65	15 	. 
	nop			;1f66	00 	. 
	nop			;1f67	00 	. 
	nop			;1f68	00 	. 
	nop			;1f69	00 	. 
	nop			;1f6a	00 	. 
	jr l1fb6h		;1f6b	18 49 	. I 
	inc l			;1f6d	2c 	, 
	inc sp			;1f6e	33 	3 
	ld d,b			;1f6f	50 	P 
	nop			;1f70	00 	. 
	ld l,c			;1f71	69 	i 
	nop			;1f72	00 	. 
	nop			;1f73	00 	. 
	ld l,d			;1f74	6a 	j 
	ld d,c			;1f75	51 	Q 
	ld h,l			;1f76	65 	e 
	nop			;1f77	00 	. 
	nop			;1f78	00 	. 
	nop			;1f79	00 	. 
	nop			;1f7a	00 	. 
	nop			;1f7b	00 	. 
	nop			;1f7c	00 	. 
	nop			;1f7d	00 	. 
	nop			;1f7e	00 	. 
	nop			;1f7f	00 	. 
	nop			;1f80	00 	. 
	nop			;1f81	00 	. 
	nop			;1f82	00 	. 
	dec bc			;1f83	0b 	. 
	nop			;1f84	00 	. 
	nop			;1f85	00 	. 
	rrca			;1f86	0f 	. 
	nop			;1f87	00 	. 
	nop			;1f88	00 	. 
	nop			;1f89	00 	. 
	nop			;1f8a	00 	. 
	nop			;1f8b	00 	. 
	nop			;1f8c	00 	. 
	nop			;1f8d	00 	. 
	nop			;1f8e	00 	. 
	nop			;1f8f	00 	. 
	nop			;1f90	00 	. 
	nop			;1f91	00 	. 
	add a,c			;1f92	81 	. 
	nop			;1f93	00 	. 
	nop			;1f94	00 	. 
	nop			;1f95	00 	. 
	ld (hl),c			;1f96	71 	q 
	add a,d			;1f97	82 	. 
	ld c,h			;1f98	4c 	L 
	jr nz,l1f9bh		;1f99	20 00 	  . 
l1f9bh:
	inc b			;1f9b	04 	. 
	nop			;1f9c	00 	. 
	nop			;1f9d	00 	. 
	add hl,bc			;1f9e	09 	. 
	inc b			;1f9f	04 	. 
	inc (hl)			;1fa0	34 	4 
	dec bc			;1fa1	0b 	. 
	nop			;1fa2	00 	. 
	inc c			;1fa3	0c 	. 
	nop			;1fa4	00 	. 
	inc de			;1fa5	13 	. 
	ld (02d14h),a		;1fa6	32 14 2d 	2 . - 
	rla			;1fa9	17 	. 
	nop			;1faa	00 	. 
	add hl,de			;1fab	19 	. 
	nop			;1fac	00 	. 
	dec e			;1fad	1d 	. 
	nop			;1fae	00 	. 
	rra			;1faf	1f 	. 
	nop			;1fb0	00 	. 
	ex af,af'			;1fb1	08 	. 
	ld bc,l0246h		;1fb2	01 46 02 	. F . 
	ld b,a			;1fb5	47 	G 
l1fb6h:
	rla			;1fb6	17 	. 
	nop			;1fb7	00 	. 
	ld hl,0222dh		;1fb8	21 2d 22 	! - " 
	ld (0352ah),a		;1fbb	32 2a 35 	2 * 5 
	inc a			;1fbe	3c 	< 
	cpl			;1fbf	2f 	/ 
	ld a,02eh		;1fc0	3e 2e 	> . 
l1fc2h:
	cp e			;1fc2	bb 	. 
	ld bc,001bah		;1fc3	01 ba 01 	. . . 
	ld d,b			;1fc6	50 	P 
	ld (bc),a			;1fc7	02 	. 
	ld c,h			;1fc8	4c 	L 
	ld (bc),a			;1fc9	02 	. 
	ld c,e			;1fca	4b 	K 
	inc bc			;1fcb	03 	. 
	inc (hl)			;1fcc	34 	4 
	inc b			;1fcd	04 	. 
	ld (hl),004h		;1fce	36 04 	6 . 
	dec (hl)			;1fd0	35 	5 
	inc b			;1fd1	04 	. 
	scf			;1fd2	37 	7 
	inc b			;1fd3	04 	. 
	ld d,h			;1fd4	54 	T 
	nop			;1fd5	00 	. 
	ld (hl),h			;1fd6	74 	t 
	nop			;1fd7	00 	. 
	exx			;1fd8	d9 	. 
	nop			;1fd9	00 	. 
	ld sp,hl			;1fda	f9 	. 
	nop			;1fdb	00 	. 
	ld c,c			;1fdc	49 	I 
	inc bc			;1fdd	03 	. 
	ld (03303h),a		;1fde	32 03 33 	2 . 3 
	inc bc			;1fe1	03 	. 
	ld sp,04503h		;1fe2	31 03 45 	1 . E 
	nop			;1fe5	00 	. 
	ld d,d			;1fe6	52 	R 
	nop			;1fe7	00 	. 
	ld d,c			;1fe8	51 	Q 
	nop			;1fe9	00 	. 
	ld d,a			;1fea	57 	W 
	nop			;1feb	00 	. 
	daa			;1fec	27 	' 
	inc bc			;1fed	03 	. 
	ld h,003h		;1fee	26 03 	& . 
	ld b,e			;1ff0	43 	C 
	inc bc			;1ff1	03 	. 
	ld b,d			;1ff2	42 	B 
	inc bc			;1ff3	03 	. 
	jr z,l1ff9h		;1ff4	28 03 	( . 
	add hl,hl			;1ff6	29 	) 
	inc bc			;1ff7	03 	. 
l1ff8h:
	inc b			;1ff8	04 	. 
l1ff9h:
	ld b,e			;1ff9	43 	C 
	ld (hl),c			;1ffa	71 	q 
	nop			;1ffb	00 	. 
	ld bc,03121h		;1ffc	01 21 31 	. ! 1 
	ld b,e			;1fff	43 	C 

	end
