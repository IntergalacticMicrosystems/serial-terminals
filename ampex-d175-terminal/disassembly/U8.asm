; z80dasm 1.1.6
; command line: z80dasm -a -l -t -z -g 0xB000 -S U8.sym -o U8.asm ../EPROM_dumps/U8-AM2732-1DC.bin

	org	0b000h

overlay_entry:
	jr overlay_init		;b000	18 2e 	. . 
lb002h:
	ld a,002h		;b002	3e 02 	> . 
lb004h:
	ld c,e			;b004	4b 	K 
lb005h:
	call pe,0f3c3h		;b005	ec c3 f3 	. . . 
	or b			;b008	b0 	. 
jumptable_start:
	jp lb34eh		;b009	c3 4e b3 	. N . 
	jp lb092h		;b00c	c3 92 b0 	. . . 
	jp lb521h		;b00f	c3 21 b5 	. ! . 
	jp lb690h		;b012	c3 90 b6 	. . . 
	jp lb0b5h		;b015	c3 b5 b0 	. . . 
	jp lb420h		;b018	c3 20 b4 	.   . 
	jp lb3f7h		;b01b	c3 f7 b3 	. . . 
	jp lb0bch		;b01e	c3 bc b0 	. . . 
	nop			;b021	00 	. 
	nop			;b022	00 	. 
	nop			;b023	00 	. 
	nop			;b024	00 	. 
	nop			;b025	00 	. 
	nop			;b026	00 	. 
	nop			;b027	00 	. 
	nop			;b028	00 	. 
	nop			;b029	00 	. 
	nop			;b02a	00 	. 
	nop			;b02b	00 	. 
	nop			;b02c	00 	. 
	nop			;b02d	00 	. 
	nop			;b02e	00 	. 
	nop			;b02f	00 	. 
overlay_init:
	ld hl,lb054h		;b030	21 54 b0 	! T . 
	ld a,c			;b033	79 	y 
sub_b034h:
	push bc			;b034	c5 	. 
	ld b,000h		;b035	06 00 	. . 
	ld c,(hl)			;b037	4e 	N 
	push bc			;b038	c5 	. 
	inc hl			;b039	23 	# 
	cpir		;b03a	ed b1 	. . 
	jr nz,lb04fh		;b03c	20 11 	  . 
	and a			;b03e	a7 	. 
	sbc hl,bc		;b03f	ed 42 	. B 
	pop bc			;b041	c1 	. 
	dec bc			;b042	0b 	. 
	add hl,bc			;b043	09 	. 
	add hl,bc			;b044	09 	. 
	pop bc			;b045	c1 	. 
	ld a,(hl)			;b046	7e 	~ 
	inc hl			;b047	23 	# 
	ld h,(hl)			;b048	66 	f 
	ld l,a			;b049	6f 	o 
	call sub_b053h		;b04a	cd 53 b0 	. S . 
	and a			;b04d	a7 	. 
	ret			;b04e	c9 	. 
lb04fh:
	pop bc			;b04f	c1 	. 
	pop bc			;b050	c1 	. 
	scf			;b051	37 	7 
	ret			;b052	c9 	. 
sub_b053h:
	jp (hl)			;b053	e9 	. 
lb054h:
	djnz lb057h		;b054	10 01 	. . 
	inc l			;b056	2c 	, 
lb057h:
	cpl			;b057	2f 	/ 
	ld a,e			;b058	7b 	{ 
	jr nz,59		;b059	20 39 	  9 
	jr c,lb0ach		;b05b	38 4f 	8 O 
	dec h			;b05d	25 	% 
	ld a,h			;b05e	7c 	| 
	ld a,l			;b05f	7d 	} 
	ld a,(hl)			;b060	7e 	~ 
	ld hl,05056h		;b061	21 56 50 	! V P 
	ld c,e			;b064	4b 	K 
	add a,l			;b065	85 	. 
	or b			;b066	b0 	. 
	add hl,de			;b067	19 	. 
	or c			;b068	b1 	. 
	ld h,0b1h		;b069	26 b1 	& . 
	ld a,(de)			;b06b	1a 	. 
	or d			;b06c	b2 	. 
	ld d,b			;b06d	50 	P 
	or c			;b06e	b1 	. 
	ld e,c			;b06f	59 	Y 
	or c			;b070	b1 	. 
	ld e,l			;b071	5d 	] 
	or c			;b072	b1 	. 
	ex (sp),hl			;b073	e3 	. 
	or d			;b074	b2 	. 
	ld d,0b3h		;b075	16 b3 	. . 
	scf			;b077	37 	7 
	or c			;b078	b1 	. 
	dec sp			;b079	3b 	; 
	or c			;b07a	b1 	. 
	ccf			;b07b	3f 	? 
	or c			;b07c	b1 	. 
	adc a,a			;b07d	8f 	. 
	or c			;b07e	b1 	. 
	ld d,c			;b07f	51 	Q 
	or h			;b080	b4 	. 
	sbc a,d			;b081	9a 	. 
	or c			;b082	b1 	. 
	ld b,c			;b083	41 	A 
	or h			;b084	b4 	. 
	call 02f59h		;b085	cd 59 2f 	. Y / 
	ld bc,(0abd7h)		;b088	ed 4b d7 ab 	. K . . 
	ld a,(0ab2fh)		;b08c	3a 2f ab 	: / . 
	jp lb26fh		;b08f	c3 6f b2 	. o . 
lb092h:
	ld a,(0abd8h)		;b092	3a d8 ab 	: . . 
	ld c,a			;b095	4f 	O 
	ld b,04fh		;b096	06 4f 	. O 
	call 046c2h		;b098	cd c2 46 	. . F 
lb09bh:
	call 017a0h		;b09b	cd a0 17 	. . . 
	ld a,(0c000h)		;b09e	3a 00 c0 	: . . 
	and a			;b0a1	a7 	. 
	jr z,lb0a8h		;b0a2	28 04 	( . 
	cp 020h		;b0a4	fe 20 	.   
	jr nz,lb0aeh		;b0a6	20 06 	  . 
lb0a8h:
	dec hl			;b0a8	2b 	+ 
	ld (06006h),hl		;b0a9	22 06 60 	" . ` 
lb0ach:
	djnz lb09bh		;b0ac	10 ed 	. . 
lb0aeh:
	ld a,b			;b0ae	78 	x 
	ld (0abd7h),a		;b0af	32 d7 ab 	2 . . 
	jp 03538h		;b0b2	c3 38 35 	. 8 5 
lb0b5h:
	ld a,(lb004h)		;b0b5	3a 04 b0 	: . . 
	ld c,a			;b0b8	4f 	O 
	jp 01475h		;b0b9	c3 75 14 	. u . 
lb0bch:
	ld hl,lb6d6h		;b0bc	21 d6 b6 	! . . 
	ld b,007h		;b0bf	06 07 	. . 
lb0c1h:
	ld c,018h		;b0c1	0e 18 	. . 
lb0c3h:
	ld d,(hl)			;b0c3	56 	V 
	inc hl			;b0c4	23 	# 
	ld e,008h		;b0c5	1e 08 	. . 
lb0c7h:
	sla d		;b0c7	cb 22 	. " 
	ld a,02ah		;b0c9	3e 2a 	> * 
	call c,lb26fh		;b0cb	dc 6f b2 	. o . 
	inc bc			;b0ce	03 	. 
	dec e			;b0cf	1d 	. 
	jr nz,lb0c7h		;b0d0	20 f5 	  . 
	ld a,c			;b0d2	79 	y 
	cp 038h		;b0d3	fe 38 	. 8 
	jr c,lb0c3h		;b0d5	38 ec 	8 . 
	inc b			;b0d7	04 	. 
	ld a,b			;b0d8	78 	x 
	cp 00ch		;b0d9	fe 0c 	. . 
	jr c,lb0c1h		;b0db	38 e4 	8 . 
	ld b,00eh		;b0dd	06 0e 	. . 
	ld e,003h		;b0df	1e 03 	. . 
lb0e1h:
	ld c,01ch		;b0e1	0e 1c 	. . 
	ld d,018h		;b0e3	16 18 	. . 
lb0e5h:
	ld a,(hl)			;b0e5	7e 	~ 
	inc hl			;b0e6	23 	# 
	call lb26fh		;b0e7	cd 6f b2 	. o . 
	inc bc			;b0ea	03 	. 
	dec d			;b0eb	15 	. 
	jr nz,lb0e5h		;b0ec	20 f7 	  . 
	inc b			;b0ee	04 	. 
	dec e			;b0ef	1d 	. 
	jr nz,lb0e1h		;b0f0	20 ef 	  . 
	ret			;b0f2	c9 	. 
	ld hl,lbfffh		;b0f3	21 ff bf 	! . . 
	ld de,lb005h		;b0f6	11 05 b0 	. . . 
	xor a			;b0f9	af 	. 
	ld (0ad82h),a		;b0fa	32 82 ad 	2 . . 
	ld (0ad7bh),a		;b0fd	32 7b ad 	2 { . 
lb100h:
	add a,(hl)			;b100	86 	. 
	dec hl			;b101	2b 	+ 
	and a			;b102	a7 	. 
	push hl			;b103	e5 	. 
	sbc hl,de		;b104	ed 52 	. R 
	pop hl			;b106	e1 	. 
	jr nz,lb100h		;b107	20 f7 	  . 
	cp (hl)			;b109	be 	. 
	jr z,lb126h		;b10a	28 1a 	( . 
	ld (0ad80h),a		;b10c	32 80 ad 	2 . . 
	ld a,008h		;b10f	3e 08 	> . 
	ld (0abe2h),a		;b111	32 e2 ab 	2 . . 
	call 00f0dh		;b114	cd 0d 0f 	. . . 
	jr lb126h		;b117	18 0d 	. . 
	call 009e0h		;b119	cd e0 09 	. . . 
	call sub_b132h		;b11c	cd 32 b1 	. 2 . 
	call 046d5h		;b11f	cd d5 46 	. . F 
	xor a			;b122	af 	. 
	ld (0ad61h),a		;b123	32 61 ad 	2 a . 
lb126h:
	ld a,080h		;b126	3e 80 	> . 
	push af			;b128	f5 	. 
	ld a,0f0h		;b129	3e f0 	> . 
	call sub_b2d8h		;b12b	cd d8 b2 	. . . 
	pop af			;b12e	f1 	. 
	jp lb2d0h		;b12f	c3 d0 b2 	. . . 
sub_b132h:
	ld a,(0abf9h)		;b132	3a f9 ab 	: . . 
	jr lb141h		;b135	18 0a 	. . 
	ld a,001h		;b137	3e 01 	> . 
	jr lb141h		;b139	18 06 	. . 
	ld a,002h		;b13b	3e 02 	> . 
	jr lb141h		;b13d	18 02 	. . 
	ld a,003h		;b13f	3e 03 	> . 
lb141h:
	ld c,a			;b141	4f 	O 
	ld a,(0abf9h)		;b142	3a f9 ab 	: . . 
	cp c			;b145	b9 	. 
	jr nc,lb149h		;b146	30 01 	0 . 
	ld c,a			;b148	4f 	O 
lb149h:
	ld a,c			;b149	79 	y 
	ld (0abf8h),a		;b14a	32 f8 ab 	2 . . 
	jp 02924h		;b14d	c3 24 29 	. $ ) 
	call 02d0dh		;b150	cd 0d 2d 	. . - 
	call 0270eh		;b153	cd 0e 27 	. . ' 
	jp 026e6h		;b156	c3 e6 26 	. . & 
	ld a,0ffh		;b159	3e ff 	> . 
	jr lb15eh		;b15b	18 01 	. . 
	xor a			;b15d	af 	. 
lb15eh:
	ld (0ad7bh),a		;b15e	32 7b ad 	2 { . 
	ret			;b161	c9 	. 
sub_b162h:
	push bc			;b162	c5 	. 
	push de			;b163	d5 	. 
	push hl			;b164	e5 	. 
	ld c,a			;b165	4f 	O 
	call 01552h		;b166	cd 52 15 	. R . 
	pop hl			;b169	e1 	. 
	pop de			;b16a	d1 	. 
	pop bc			;b16b	c1 	. 
	ret			;b16c	c9 	. 
sub_b16dh:
	ld a,l			;b16d	7d 	} 
	call sub_b178h		;b16e	cd 78 b1 	. x . 
	ld a,h			;b171	7c 	| 
	push de			;b172	d5 	. 
	ld de,00230h		;b173	11 30 02 	. 0 . 
	jr lb17ch		;b176	18 04 	. . 
sub_b178h:
	push de			;b178	d5 	. 
	ld de,00330h		;b179	11 30 03 	. 0 . 
lb17ch:
	push hl			;b17c	e5 	. 
	call sub_b4d0h		;b17d	cd d0 b4 	. . . 
	call sub_b4d7h		;b180	cd d7 b4 	. . . 
	pop hl			;b183	e1 	. 
	pop de			;b184	d1 	. 
	ret			;b185	c9 	. 
sub_b186h:
	push af			;b186	f5 	. 
	ld a,01ch		;b187	3e 1c 	> . 
	call sub_b162h		;b189	cd 62 b1 	. b . 
	pop af			;b18c	f1 	. 
	jr sub_b162h		;b18d	18 d3 	. . 
	ld hl,0aab9h		;b18f	21 b9 aa 	! . . 
	bit 2,(hl)		;b192	cb 56 	. V 
	jp z,01ccfh		;b194	ca cf 1c 	. . . 
	jp 01cd9h		;b197	c3 d9 1c 	. . . 
	ld a,06dh		;b19a	3e 6d 	> m 
	call sub_b186h		;b19c	cd 86 b1 	. . . 
	ld a,(0ad7ah)		;b19f	3a 7a ad 	: z . 
	srl a		;b1a2	cb 3f 	. ? 
	srl a		;b1a4	cb 3f 	. ? 
	srl a		;b1a6	cb 3f 	. ? 
	srl a		;b1a8	cb 3f 	. ? 
	ld b,a			;b1aa	47 	G 
	ld a,(0ad7bh)		;b1ab	3a 7b ad 	: { . 
	and 010h		;b1ae	e6 10 	. . 
	add a,b			;b1b0	80 	. 
	call sub_b214h		;b1b1	cd 14 b2 	. . . 
	ld a,(0aa29h)		;b1b4	3a 29 aa 	: ) . 
	ld b,a			;b1b7	47 	G 
	and 080h		;b1b8	e6 80 	. . 
	rrca			;b1ba	0f 	. 
	ld c,a			;b1bb	4f 	O 
	ld a,b			;b1bc	78 	x 
	and 008h		;b1bd	e6 08 	. . 
	or c			;b1bf	b1 	. 
	call sub_b214h		;b1c0	cd 14 b2 	. . . 
	ld a,(0aa9dh)		;b1c3	3a 9d aa 	: . . 
	cpl			;b1c6	2f 	/ 
	and 004h		;b1c7	e6 04 	. . 
	call sub_b214h		;b1c9	cd 14 b2 	. . . 
	ld a,(0ac28h)		;b1cc	3a 28 ac 	: ( . 
	ld b,a			;b1cf	47 	G 
	and 014h		;b1d0	e6 14 	. . 
	bit 0,b		;b1d2	cb 40 	. @ 
	jr z,lb1d8h		;b1d4	28 02 	( . 
	set 1,a		;b1d6	cb cf 	. . 
lb1d8h:
	bit 1,b		;b1d8	cb 48 	. H 
	jr z,lb1deh		;b1da	28 02 	( . 
	set 3,a		;b1dc	cb df 	. . 
lb1deh:
	bit 3,b		;b1de	cb 58 	. X 
	jr z,lb1e4h		;b1e0	28 02 	( . 
	set 0,a		;b1e2	cb c7 	. . 
lb1e4h:
	call sub_b214h		;b1e4	cd 14 b2 	. . . 
	ld a,(0abf8h)		;b1e7	3a f8 ab 	: . . 
	add a,010h		;b1ea	c6 10 	. . 
	call sub_b214h		;b1ec	cd 14 b2 	. . . 
	ld a,090h		;b1ef	3e 90 	> . 
	call sub_b2c9h		;b1f1	cd c9 b2 	. . . 
	jr nz,lb209h		;b1f4	20 13 	  . 
lb1f6h:
	ld c,031h		;b1f6	0e 31 	. 1 
lb1f8h:
	call 01552h		;b1f8	cd 52 15 	. R . 
	call 009f1h		;b1fb	cd f1 09 	. . . 
	ld a,(0aa2bh)		;b1fe	3a 2b aa 	: + . 
	and 0c0h		;b201	e6 c0 	. . 
	ret nz			;b203	c0 	. 
	ld c,00dh		;b204	0e 0d 	. . 
	jp 01552h		;b206	c3 52 15 	. R . 
lb209h:
	ld a,(0aab7h)		;b209	3a b7 aa 	: . . 
	and 030h		;b20c	e6 30 	. 0 
	ld c,030h		;b20e	0e 30 	. 0 
	jr nz,lb1f8h		;b210	20 e6 	  . 
	jr lb1f6h		;b212	18 e2 	. . 
sub_b214h:
	add a,020h		;b214	c6 20 	.   
	ld c,a			;b216	4f 	O 
	jp 01552h		;b217	c3 52 15 	. R . 
	call sub_b2a3h		;b21a	cd a3 b2 	. . . 
	ld a,(0abd8h)		;b21d	3a d8 ab 	: . . 
	ld d,a			;b220	57 	W 
	add a,h			;b221	84 	. 
	ld h,a			;b222	67 	g 
	ld a,(0ab27h)		;b223	3a 27 ab 	: ' . 
	cp h			;b226	bc 	. 
	ret c			;b227	d8 	. 
	ld a,(0abd7h)		;b228	3a d7 ab 	: . . 
	ld e,a			;b22b	5f 	_ 
	add a,l			;b22c	85 	. 
	cp 050h		;b22d	fe 50 	. P 
	ret nc			;b22f	d0 	. 
	ld l,a			;b230	6f 	o 
	ld b,h			;b231	44 	D 
	ld c,e			;b232	4b 	K 
	ld a,0c2h		;b233	3e c2 	> . 
	call lb26fh		;b235	cd 6f b2 	. o . 
	ld c,l			;b238	4d 	M 
	ld a,0c3h		;b239	3e c3 	> . 
	call lb26fh		;b23b	cd 6f b2 	. o . 
	ld b,d			;b23e	42 	B 
	ld a,0c1h		;b23f	3e c1 	> . 
	call lb26fh		;b241	cd 6f b2 	. o . 
	ld c,e			;b244	4b 	K 
	ld a,0c0h		;b245	3e c0 	> . 
	call lb26fh		;b247	cd 6f b2 	. o . 
lb24ah:
	inc c			;b24a	0c 	. 
	ld a,c			;b24b	79 	y 
	cp l			;b24c	bd 	. 
	jr nc,lb25dh		;b24d	30 0e 	0 . 
	ld a,0c8h		;b24f	3e c8 	> . 
	call lb26fh		;b251	cd 6f b2 	. o . 
	ld b,h			;b254	44 	D 
	ld a,0c8h		;b255	3e c8 	> . 
	call lb26fh		;b257	cd 6f b2 	. o . 
	ld b,d			;b25a	42 	B 
	jr lb24ah		;b25b	18 ed 	. . 
lb25dh:
	inc b			;b25d	04 	. 
	ld a,b			;b25e	78 	x 
	cp h			;b25f	bc 	. 
	ret nc			;b260	d0 	. 
	ld c,e			;b261	4b 	K 
	ld a,0c9h		;b262	3e c9 	> . 
	call lb26fh		;b264	cd 6f b2 	. o . 
	ld c,l			;b267	4d 	M 
	ld a,0c9h		;b268	3e c9 	> . 
	call lb26fh		;b26a	cd 6f b2 	. o . 
	jr lb25dh		;b26d	18 ee 	. . 
lb26fh:
	push de			;b26f	d5 	. 
	push hl			;b270	e5 	. 
	push af			;b271	f5 	. 
	call sub_b297h		;b272	cd 97 b2 	. . . 
	ld a,(0aa29h)		;b275	3a 29 aa 	: ) . 
	and 010h		;b278	e6 10 	. . 
	ld a,(0ac28h)		;b27a	3a 28 ac 	: ( . 
	jr nz,lb28eh		;b27d	20 0f 	  . 
	call 017a0h		;b27f	cd a0 17 	. . . 
	ld a,(0d000h)		;b282	3a 00 d0 	: . . 
	and 00fh		;b285	e6 0f 	. . 
	ld d,a			;b287	57 	W 
	ld a,(0abd0h)		;b288	3a d0 ab 	: . . 
	and 010h		;b28b	e6 10 	. . 
	or d			;b28d	b2 	. 
lb28eh:
	ld d,a			;b28e	57 	W 
	pop af			;b28f	f1 	. 
	ld e,a			;b290	5f 	_ 
	call 00d38h		;b291	cd 38 0d 	. 8 . 
	pop hl			;b294	e1 	. 
	pop de			;b295	d1 	. 
	ret			;b296	c9 	. 
sub_b297h:
	ld a,b			;b297	78 	x 
	call 03d20h		;b298	cd 20 3d 	.   = 
	ld l,c			;b29b	69 	i 
	ld h,000h		;b29c	26 00 	& . 
	add hl,de			;b29e	19 	. 
	ld (06006h),hl		;b29f	22 06 60 	" . ` 
	ret			;b2a2	c9 	. 
sub_b2a3h:
	push de			;b2a3	d5 	. 
	ld c,003h		;b2a4	0e 03 	. . 
	call sub_b4c2h		;b2a6	cd c2 b4 	. . . 
	jr c,lb2b7h		;b2a9	38 0c 	8 . 
	dec hl			;b2ab	2b 	+ 
	ld e,l			;b2ac	5d 	] 
	ld c,002h		;b2ad	0e 02 	. . 
	call sub_b4c2h		;b2af	cd c2 b4 	. . . 
	jr c,lb2b7h		;b2b2	38 03 	8 . 
	dec hl			;b2b4	2b 	+ 
	ld d,l			;b2b5	55 	U 
	ex de,hl			;b2b6	eb 	. 
lb2b7h:
	pop de			;b2b7	d1 	. 
	ret			;b2b8	c9 	. 
	ld c,003h		;b2b9	0e 03 	. . 
	call sub_b4c2h		;b2bb	cd c2 b4 	. . . 
	ret c			;b2be	d8 	. 
	dec hl			;b2bf	2b 	+ 
	ret			;b2c0	c9 	. 
sub_b2c1h:
	ld c,002h		;b2c1	0e 02 	. . 
	call sub_b4c2h		;b2c3	cd c2 b4 	. . . 
	ret c			;b2c6	d8 	. 
	dec hl			;b2c7	2b 	+ 
	ret			;b2c8	c9 	. 
sub_b2c9h:
	push hl			;b2c9	e5 	. 
	ld hl,0ad7ah		;b2ca	21 7a ad 	! z . 
	and (hl)			;b2cd	a6 	. 
	pop hl			;b2ce	e1 	. 
	ret			;b2cf	c9 	. 
lb2d0h:
	push hl			;b2d0	e5 	. 
	ld hl,0ad7ah		;b2d1	21 7a ad 	! z . 
	or (hl)			;b2d4	b6 	. 
	ld (hl),a			;b2d5	77 	w 
	pop hl			;b2d6	e1 	. 
	ret			;b2d7	c9 	. 
sub_b2d8h:
	push af			;b2d8	f5 	. 
	push hl			;b2d9	e5 	. 
	ld hl,0ad7ah		;b2da	21 7a ad 	! z . 
	cpl			;b2dd	2f 	/ 
	and (hl)			;b2de	a6 	. 
	ld (hl),a			;b2df	77 	w 
	pop hl			;b2e0	e1 	. 
	pop af			;b2e1	f1 	. 
	ret			;b2e2	c9 	. 
	ld a,0feh		;b2e3	3e fe 	> . 
	ld (0ad61h),a		;b2e5	32 61 ad 	2 a . 
	xor a			;b2e8	af 	. 
	ld b,007h		;b2e9	06 07 	. . 
	ld hl,0ad82h		;b2eb	21 82 ad 	! . . 
lb2eeh:
	ld (hl),a			;b2ee	77 	w 
	inc hl			;b2ef	23 	# 
	djnz lb2eeh		;b2f0	10 fc 	. . 
	ret			;b2f2	c9 	. 
lb2f3h:
	jr z,lb311h		;b2f3	28 1c 	( . 
	inc a			;b2f5	3c 	< 
	cpl			;b2f6	2f 	/ 
	ld hl,0ad82h		;b2f7	21 82 ad 	! . . 
	add a,l			;b2fa	85 	. 
	ld l,a			;b2fb	6f 	o 
	jr nc,lb2ffh		;b2fc	30 01 	0 . 
	inc h			;b2fe	24 	$ 
lb2ffh:
	ld a,c			;b2ff	79 	y 
	sub 080h		;b300	d6 80 	. . 
	jr c,lb30bh		;b302	38 07 	8 . 
	ld c,a			;b304	4f 	O 
	ld a,(0aa99h)		;b305	3a 99 aa 	: . . 
	cp c			;b308	b9 	. 
	jr nz,lb311h		;b309	20 06 	  . 
lb30bh:
	ld (hl),c			;b30b	71 	q 
	ld hl,0ad61h		;b30c	21 61 ad 	! a . 
	dec (hl)			;b30f	35 	5 
	ret			;b310	c9 	. 
lb311h:
	xor a			;b311	af 	. 
	ld (0ad61h),a		;b312	32 61 ad 	2 a . 
	ret			;b315	c9 	. 
	ld a,(0aa8ah)		;b316	3a 8a aa 	: . . 
	and 010h		;b319	e6 10 	. . 
	call nz,0271bh		;b31b	c4 1b 27 	. . ' 
	call sub_b2c1h		;b31e	cd c1 b2 	. . . 
	ex de,hl			;b321	eb 	. 
	ld hl,0ab45h		;b322	21 45 ab 	! E . 
	add hl,de			;b325	19 	. 
	ld (0ad64h),hl		;b326	22 64 ad 	" d . 
	ld hl,00000h		;b329	21 00 00 	! . . 
	add hl,de			;b32c	19 	. 
	ld (0ad62h),hl		;b32d	22 62 ad 	" b . 
	ld a,(0aa8ah)		;b330	3a 8a aa 	: . . 
	set 7,a		;b333	cb ff 	. . 
	and 0a0h		;b335	e6 a0 	. . 
	ld (0aa8ah),a		;b337	32 8a aa 	2 . . 
	ld a,00fh		;b33a	3e 0f 	> . 
	ld (0ad61h),a		;b33c	32 61 ad 	2 a . 
	xor a			;b33f	af 	. 
	ld (0ad7dh),a		;b340	32 7d ad 	2 } . 
	ld a,(0abc5h)		;b343	3a c5 ab 	: . . 
	and 0fah		;b346	e6 fa 	. . 
	or 018h		;b348	f6 18 	. . 
	ld (0abc5h),a		;b34a	32 c5 ab 	2 . . 
	ret			;b34d	c9 	. 
lb34eh:
	cp 0ffh		;b34e	fe ff 	. . 
	jp z,024f7h		;b350	ca f7 24 	. . $ 
	cp 0f8h		;b353	fe f8 	. . 
	jr nc,lb2f3h		;b355	30 9c 	0 . 
	ld a,c			;b357	79 	y 
	cp 080h		;b358	fe 80 	. . 
	jr nc,lb3adh		;b35a	30 51 	0 Q 
	cp 020h		;b35c	fe 20 	.   
	jr nc,lb375h		;b35e	30 15 	0 . 
	cp 001h		;b360	fe 01 	. . 
	jr z,lb3b4h		;b362	28 50 	( P 
	cp 008h		;b364	fe 08 	. . 
	jr z,lb3b4h		;b366	28 4c 	( L 
	cp 009h		;b368	fe 09 	. . 
	jr z,lb39ah		;b36a	28 2e 	( . 
	cp 00ch		;b36c	fe 0c 	. . 
	jp z,02c79h		;b36e	ca 79 2c 	. y , 
	cp 00dh		;b371	fe 0d 	. . 
	jr z,lb3dah		;b373	28 65 	( e 
lb375h:
	ld a,(0ad64h)		;b375	3a 64 ad 	: d . 
	ld hl,0ab45h		;b378	21 45 ab 	! E . 
	sub l			;b37b	95 	. 
	cp 050h		;b37c	fe 50 	. P 
	jp c,024f7h		;b37e	da f7 24 	. . $ 
	ld a,c			;b381	79 	y 
	call 01757h		;b382	cd 57 17 	. W . 
	ld c,a			;b385	4f 	O 
	call sub_b3eeh		;b386	cd ee b3 	. . . 
	ld hl,(0ad64h)		;b389	2a 64 ad 	* d . 
	ld (hl),b			;b38c	70 	p 
	inc hl			;b38d	23 	# 
	ld de,0ab45h		;b38e	11 45 ab 	. E . 
	ld a,e			;b391	7b 	{ 
	sub l			;b392	95 	. 
	jp p,lb406h		;b393	f2 06 b4 	. . . 
	ld (0ad64h),hl		;b396	22 64 ad 	" d . 
	ret			;b399	c9 	. 
lb39ah:
	xor a			;b39a	af 	. 
	ld (0ad62h),a		;b39b	32 62 ad 	2 b . 
	ld (0ad7dh),a		;b39e	32 7d ad 	2 } . 
	ld b,050h		;b3a1	06 50 	. P 
	ld hl,0ab45h		;b3a3	21 45 ab 	! E . 
lb3a6h:
	ld (hl),a			;b3a6	77 	w 
	inc hl			;b3a7	23 	# 
	djnz lb3a6h		;b3a8	10 fc 	. . 
	jp 00d4bh		;b3aa	c3 4b 0d 	. K . 
lb3adh:
	call lb3dah		;b3ad	cd da b3 	. . . 
	ld a,c			;b3b0	79 	y 
	jp 04981h		;b3b1	c3 81 49 	. . I 
lb3b4h:
	ld hl,(0ad62h)		;b3b4	2a 62 ad 	* b . 
	ld a,h			;b3b7	7c 	| 
	or l			;b3b8	b5 	. 
	ret z			;b3b9	c8 	. 
	dec hl			;b3ba	2b 	+ 
	ld (0ad62h),hl		;b3bb	22 62 ad 	" b . 
	ld de,(0ad64h)		;b3be	ed 5b 64 ad 	. [ d . 
	dec de			;b3c2	1b 	. 
	ld (0ad64h),de		;b3c3	ed 53 64 ad 	. S d . 
	ld a,c			;b3c7	79 	y 
	cp 001h		;b3c8	fe 01 	. . 
	ret nz			;b3ca	c0 	. 
	ld a,(0ab2fh)		;b3cb	3a 2f ab 	: / . 
	ld (de),a			;b3ce	12 	. 
	ld (06006h),hl		;b3cf	22 06 60 	" . ` 
	ld e,a			;b3d2	5f 	_ 
	ld a,(0abc5h)		;b3d3	3a c5 ab 	: . . 
	ld d,a			;b3d6	57 	W 
	jp 00d38h		;b3d7	c3 38 0d 	. 8 . 
lb3dah:
	xor a			;b3da	af 	. 
	ld (0ad61h),a		;b3db	32 61 ad 	2 a . 
	ld a,(0ad64h)		;b3de	3a 64 ad 	: d . 
	ld hl,0ab45h		;b3e1	21 45 ab 	! E . 
	sub l			;b3e4	95 	. 
	cp 051h		;b3e5	fe 51 	. Q 
	ret c			;b3e7	d8 	. 
	ld a,001h		;b3e8	3e 01 	> . 
	ld (0ad7dh),a		;b3ea	32 7d ad 	2 } . 
	ret			;b3ed	c9 	. 
sub_b3eeh:
	ld a,(0ab45h)		;b3ee	3a 45 ab 	: E . 
	push af			;b3f1	f5 	. 
	call 024cah		;b3f2	cd ca 24 	. . $ 
	pop bc			;b3f5	c1 	. 
	ret			;b3f6	c9 	. 
lb3f7h:
	ld hl,0ad7dh		;b3f7	21 7d ad 	! } . 
	bit 7,(hl)		;b3fa	cb 7e 	. ~ 
	ret z			;b3fc	c8 	. 
	res 7,(hl)		;b3fd	cb be 	. . 
	ld a,(0ab95h)		;b3ff	3a 95 ab 	: . . 
	ld c,a			;b402	4f 	O 
	call sub_b3eeh		;b403	cd ee b3 	. . . 
lb406h:
	ld hl,0ab96h		;b406	21 96 ab 	! . . 
	ld a,(0ad64h)		;b409	3a 64 ad 	: d . 
	sub l			;b40c	95 	. 
	ld c,a			;b40d	4f 	O 
	ld a,b			;b40e	78 	x 
	jr z,lb41ah		;b40f	28 09 	( . 
	jr c,lb41ah		;b411	38 07 	8 . 
	ld b,000h		;b413	06 00 	. . 
	ld de,0ab95h		;b415	11 95 ab 	. . . 
	ldir		;b418	ed b0 	. . 
lb41ah:
	ld hl,(0ad64h)		;b41a	2a 64 ad 	* d . 
	dec hl			;b41d	2b 	+ 
	ld (hl),a			;b41e	77 	w 
	ret			;b41f	c9 	. 
lb420h:
	ld a,(0ad7dh)		;b420	3a 7d ad 	: } . 
	ld b,a			;b423	47 	G 
	and 07fh		;b424	e6 7f 	.  
	ret z			;b426	c8 	. 
	dec a			;b427	3d 	= 
	jr nz,lb439h		;b428	20 0f 	  . 
	ld a,(0aab8h)		;b42a	3a b8 aa 	: . . 
	and 001h		;b42d	e6 01 	. . 
	ld a,087h		;b42f	3e 87 	> . 
	jr nz,lb435h		;b431	20 02 	  . 
	ld a,088h		;b433	3e 88 	> . 
lb435h:
	ld (0ad7dh),a		;b435	32 7d ad 	2 } . 
	ret			;b438	c9 	. 
lb439h:
	bit 7,b		;b439	cb 78 	. x 
	jr z,lb435h		;b43b	28 f8 	( . 
	add a,080h		;b43d	c6 80 	. . 
	jr lb435h		;b43f	18 f4 	. . 
	ld a,020h		;b441	3e 20 	>   
	call sub_b186h		;b443	cd 86 b1 	. . . 
	ld hl,0ffffh		;b446	21 ff ff 	! . . 
lb449h:
	call sub_b16dh		;b449	cd 6d b1 	. m . 
	ld a,00dh		;b44c	3e 0d 	> . 
	jp sub_b162h		;b44e	c3 62 b1 	. b . 
	ld a,022h		;b451	3e 22 	> " 
	call sub_b186h		;b453	cd 86 b1 	. . . 
	ld hl,(lb002h)		;b456	2a 02 b0 	* . . 
	call sub_b16dh		;b459	cd 6d b1 	. m . 
	ld hl,00000h		;b45c	21 00 00 	! . . 
	jr lb449h		;b45f	18 e8 	. . 
	push hl			;b461	e5 	. 
	ld l,a			;b462	6f 	o 
	ld h,000h		;b463	26 00 	& . 
	call sub_b46ah		;b465	cd 6a b4 	. j . 
	pop hl			;b468	e1 	. 
	ret			;b469	c9 	. 
sub_b46ah:
	push bc			;b46a	c5 	. 
	ld bc,02a00h		;b46b	01 00 2a 	. . * 
lb46eh:
	ld a,00ah		;b46e	3e 0a 	> . 
	call sub_b4deh		;b470	cd de b4 	. . . 
	push af			;b473	f5 	. 
	inc c			;b474	0c 	. 
	ld a,h			;b475	7c 	| 
	or l			;b476	b5 	. 
	jr nz,lb46eh		;b477	20 f5 	  . 
	ld a,d			;b479	7a 	z 
	sub c			;b47a	91 	. 
	jr z,lb486h		;b47b	28 09 	( . 
	jr c,lb488h		;b47d	38 09 	8 . 
	ld b,a			;b47f	47 	G 
lb480h:
	ld a,e			;b480	7b 	{ 
	call sub_b492h		;b481	cd 92 b4 	. . . 
	djnz lb480h		;b484	10 fa 	. . 
lb486h:
	ld b,030h		;b486	06 30 	. 0 
lb488h:
	pop af			;b488	f1 	. 
	add a,b			;b489	80 	. 
	call sub_b492h		;b48a	cd 92 b4 	. . . 
	dec c			;b48d	0d 	. 
	jr nz,lb488h		;b48e	20 f8 	  . 
	pop bc			;b490	c1 	. 
	ret			;b491	c9 	. 
sub_b492h:
	push hl			;b492	e5 	. 
	ld hl,(0ad80h)		;b493	2a 80 ad 	* . . 
	ex (sp),hl			;b496	e3 	. 
	ret			;b497	c9 	. 
lb498h:
	push de			;b498	d5 	. 
	ld hl,00000h		;b499	21 00 00 	! . . 
	ld b,000h		;b49c	06 00 	. . 
lb49eh:
	call sub_b518h		;b49e	cd 18 b5 	. . . 
	cp 030h		;b4a1	fe 30 	. 0 
	jr c,lb4bfh		;b4a3	38 1a 	8 . 
	cp 03ah		;b4a5	fe 3a 	. : 
	jr nc,lb4bfh		;b4a7	30 16 	0 . 
	call sub_b4cah		;b4a9	cd ca b4 	. . . 
	inc b			;b4ac	04 	. 
	and 00fh		;b4ad	e6 0f 	. . 
	ld d,h			;b4af	54 	T 
	ld e,l			;b4b0	5d 	] 
	add hl,hl			;b4b1	29 	) 
	add hl,hl			;b4b2	29 	) 
	add hl,de			;b4b3	19 	. 
	add hl,hl			;b4b4	29 	) 
	ld d,000h		;b4b5	16 00 	. . 
	ld e,a			;b4b7	5f 	_ 
	add hl,de			;b4b8	19 	. 
	dec c			;b4b9	0d 	. 
	jr nz,lb49eh		;b4ba	20 e2 	  . 
	pop de			;b4bc	d1 	. 
	and a			;b4bd	a7 	. 
	ret			;b4be	c9 	. 
lb4bfh:
	pop de			;b4bf	d1 	. 
	scf			;b4c0	37 	7 
lb4c1h:
	ret			;b4c1	c9 	. 
sub_b4c2h:
	ld hl,lb4c1h		;b4c2	21 c1 b4 	! . . 
	ld (0ad7eh),hl		;b4c5	22 7e ad 	" ~ . 
	jr lb498h		;b4c8	18 ce 	. . 
sub_b4cah:
	push hl			;b4ca	e5 	. 
	ld hl,(0ad7eh)		;b4cb	2a 7e ad 	* ~ . 
	ex (sp),hl			;b4ce	e3 	. 
	ret			;b4cf	c9 	. 
sub_b4d0h:
	ld hl,sub_b162h		;b4d0	21 62 b1 	! b . 
	ld (0ad80h),hl		;b4d3	22 80 ad 	" . . 
	ret			;b4d6	c9 	. 
sub_b4d7h:
	ld l,a			;b4d7	6f 	o 
	ld h,000h		;b4d8	26 00 	& . 
	inc l			;b4da	2c 	, 
	jp sub_b46ah		;b4db	c3 6a b4 	. j . 
sub_b4deh:
	or a			;b4de	b7 	. 
	ret z			;b4df	c8 	. 
	push bc			;b4e0	c5 	. 
	push de			;b4e1	d5 	. 
	ld d,000h		;b4e2	16 00 	. . 
	ld e,a			;b4e4	5f 	_ 
	ex de,hl			;b4e5	eb 	. 
	ld b,001h		;b4e6	06 01 	. . 
lb4e8h:
	ld a,h			;b4e8	7c 	| 
	cp d			;b4e9	ba 	. 
	jr c,lb4f4h		;b4ea	38 08 	8 . 
	jr nz,lb4f8h		;b4ec	20 0a 	  . 
	ld a,l			;b4ee	7d 	} 
	cp e			;b4ef	bb 	. 
	jr c,lb4f4h		;b4f0	38 02 	8 . 
	jr nz,lb4f8h		;b4f2	20 04 	  . 
lb4f4h:
	inc b			;b4f4	04 	. 
	add hl,hl			;b4f5	29 	) 
	jr nc,lb4e8h		;b4f6	30 f0 	0 . 
lb4f8h:
	ld a,b			;b4f8	78 	x 
	ex de,hl			;b4f9	eb 	. 
	ld bc,00000h		;b4fa	01 00 00 	. . . 
lb4fdh:
	dec a			;b4fd	3d 	= 
	jr z,lb512h		;b4fe	28 12 	( . 
	rr d		;b500	cb 1a 	. . 
	rr e		;b502	cb 1b 	. . 
	sla c		;b504	cb 21 	. ! 
	rl b		;b506	cb 10 	. . 
	inc bc			;b508	03 	. 
	sbc hl,de		;b509	ed 52 	. R 
	jr nc,lb4fdh		;b50b	30 f0 	0 . 
	add hl,de			;b50d	19 	. 
	dec bc			;b50e	0b 	. 
	or a			;b50f	b7 	. 
	jr lb4fdh		;b510	18 eb 	. . 
lb512h:
	ld a,l			;b512	7d 	} 
	ld h,b			;b513	60 	` 
	ld l,c			;b514	69 	i 
	pop de			;b515	d1 	. 
	pop bc			;b516	c1 	. 
	ret			;b517	c9 	. 
sub_b518h:
	push de			;b518	d5 	. 
	push hl			;b519	e5 	. 
	rst 28h			;b51a	ef 	. 
	pop hl			;b51b	e1 	. 
	pop de			;b51c	d1 	. 
	ret			;b51d	c9 	. 
lb51eh:
	jp 02c89h		;b51e	c3 89 2c 	. . , 
lb521h:
	ld c,a			;b521	4f 	O 
	cp 0f0h		;b522	fe f0 	. . 
	jr nc,lb51eh		;b524	30 f8 	0 . 
	cp 0b1h		;b526	fe b1 	. . 
	jr c,lb51eh		;b528	38 f4 	8 . 
	cp 0b5h		;b52a	fe b5 	. . 
	jr c,lb542h		;b52c	38 14 	8 . 
	cp 0c0h		;b52e	fe c0 	. . 
	jr c,lb51eh		;b530	38 ec 	8 . 
	cp 0e0h		;b532	fe e0 	. . 
	jr c,lb542h		;b534	38 0c 	8 . 
	cp 0e5h		;b536	fe e5 	. . 
	jr c,lb51eh		;b538	38 e4 	8 . 
	cp 0e8h		;b53a	fe e8 	. . 
	jr z,lb51eh		;b53c	28 e0 	( . 
	cp 0e9h		;b53e	fe e9 	. . 
	jr z,lb51eh		;b540	28 dc 	( . 
lb542h:
	ld hl,lb604h		;b542	21 04 b6 	! . . 
	call sub_b683h		;b545	cd 83 b6 	. . . 
	jr z,lb57ah		;b548	28 30 	( 0 
	ld hl,lb60dh		;b54a	21 0d b6 	! . . 
	call sub_b683h		;b54d	cd 83 b6 	. . . 
	jr z,lb57fh		;b550	28 2d 	( - 
	ld hl,lb673h		;b552	21 73 b6 	! s . 
	call sub_b034h		;b555	cd 34 b0 	. 4 . 
	ret nc			;b558	d0 	. 
	ld a,c			;b559	79 	y 
	ld hl,lb65eh		;b55a	21 5e b6 	! ^ . 
	call sub_b683h		;b55d	cd 83 b6 	. . . 
	ret nz			;b560	c0 	. 
	ld c,(hl)			;b561	4e 	N 
	jp 01873h		;b562	c3 73 18 	. s . 
	ld a,(0aa29h)		;b565	3a 29 aa 	: ) . 
	and 008h		;b568	e6 08 	. . 
	call nz,01d44h		;b56a	c4 44 1d 	. D . 
	ld hl,lb628h		;b56d	21 28 b6 	! ( . 
	jr lb57ah		;b570	18 08 	. . 
	call lb39ah		;b572	cd 9a b3 	. . . 
	ld c,07fh		;b575	0e 7f 	.  
	jp 01873h		;b577	c3 73 18 	. s . 
lb57ah:
	ld de,0001fh		;b57a	11 1f 00 	. . . 
	jr lb5edh		;b57d	18 6e 	. n 
lb57fh:
	ld a,(0ad7bh)		;b57f	3a 7b ad 	: { . 
	and a			;b582	a7 	. 
	jr nz,lb5eah		;b583	20 65 	  e 
	ld a,c			;b585	79 	y 
	ld de,00019h		;b586	11 19 00 	. . . 
	add hl,de			;b589	19 	. 
	ex de,hl			;b58a	eb 	. 
	ld hl,lb64dh		;b58b	21 4d b6 	! M . 
	sbc hl,de		;b58e	ed 52 	. R 
	ex de,hl			;b590	eb 	. 
	ld de,0001fh		;b591	11 1f 00 	. . . 
	jr c,lb5a4h		;b594	38 0e 	8 . 
	cp 0cbh		;b596	fe cb 	. . 
	jr z,lb5cch		;b598	28 32 	( 2 
	cp 0cch		;b59a	fe cc 	. . 
	jr z,lb5d3h		;b59c	28 35 	( 5 
	cp 0ceh		;b59e	fe ce 	. . 
	jr z,lb5deh		;b5a0	28 3c 	( < 
lb5a2h:
	ld e,000h		;b5a2	1e 00 	. . 
lb5a4h:
	ld a,(0aa29h)		;b5a4	3a 29 aa 	: ) . 
	and 00ch		;b5a7	e6 0c 	. . 
	call z,lb5edh		;b5a9	cc ed b5 	. . . 
	ld a,(0aa29h)		;b5ac	3a 29 aa 	: ) . 
	and 002h		;b5af	e6 02 	. . 
	ret nz			;b5b1	c0 	. 
	ld a,(hl)			;b5b2	7e 	~ 
	cp 080h		;b5b3	fe 80 	. . 
	jr nc,lb5bbh		;b5b5	30 04 	0 . 
	ld c,a			;b5b7	4f 	O 
	jp 017b6h		;b5b8	c3 b6 17 	. . . 
lb5bbh:
	ld de,0000bh		;b5bb	11 0b 00 	. . . 
	add hl,de			;b5be	19 	. 
	ld a,(hl)			;b5bf	7e 	~ 
	ld c,a			;b5c0	4f 	O 
	cp 0c5h		;b5c1	fe c5 	. . 
	jp nz,02c89h		;b5c3	c2 89 2c 	. . , 
	ld (0ad7ch),a		;b5c6	32 7c ad 	2 | . 
	jp 02c89h		;b5c9	c3 89 2c 	. . , 
lb5cch:
	push hl			;b5cc	e5 	. 
	call 01d44h		;b5cd	cd 44 1d 	. D . 
	pop hl			;b5d0	e1 	. 
	ld d,000h		;b5d1	16 00 	. . 
lb5d3h:
	ld e,(hl)			;b5d3	5e 	^ 
	add hl,de			;b5d4	19 	. 
lb5d5h:
	ld a,(hl)			;b5d5	7e 	~ 
	and a			;b5d6	a7 	. 
	ret z			;b5d7	c8 	. 
	call sub_b162h		;b5d8	cd 62 b1 	. b . 
	inc hl			;b5db	23 	# 
	jr lb5d5h		;b5dc	18 f7 	. . 
lb5deh:
	ld hl,0ad82h		;b5de	21 82 ad 	! . . 
	ld a,(hl)			;b5e1	7e 	~ 
	and a			;b5e2	a7 	. 
	jr nz,lb5d5h		;b5e3	20 f0 	  . 
	ld hl,0b642h		;b5e5	21 42 b6 	! B . 
	jr lb5a2h		;b5e8	18 b8 	. . 
lb5eah:
	ld de,00d1ch		;b5ea	11 1c 0d 	. . . 
lb5edh:
	ld a,e			;b5ed	7b 	{ 
	and a			;b5ee	a7 	. 
	call nz,sub_b162h		;b5ef	c4 62 b1 	. b . 
	ld a,(hl)			;b5f2	7e 	~ 
	cp 01fh		;b5f3	fe 1f 	. . 
	jr z,lb600h		;b5f5	28 09 	( . 
lb5f7h:
	call sub_b162h		;b5f7	cd 62 b1 	. b . 
	ld a,d			;b5fa	7a 	z 
	and a			;b5fb	a7 	. 
	call nz,sub_b162h		;b5fc	c4 62 b1 	. b . 
	ret			;b5ff	c9 	. 
lb600h:
	ld a,00dh		;b600	3e 0d 	> . 
	jr lb5f7h		;b602	18 f3 	. . 
lb604h:
	inc b			;b604	04 	. 
	ret nz			;b605	c0 	. 
	jp nz,0d8cdh		;b606	c2 cd d8 	. . . 
	ld c,b			;b609	48 	H 
	ld d,b			;b60a	50 	P 
	ld c,l			;b60b	4d 	M 
	ld l,l			;b60c	6d 	m 
lb60dh:
	add hl,de			;b60d	19 	. 
	set 1,h		;b60e	cb cc 	. . 
	adc a,0c6h		;b610	ce c6 	. . 
	rst 0			;b612	c7 	. 
	ret z			;b613	c8 	. 
	ret			;b614	c9 	. 
	or d			;b615	b2 	. 
	or e			;b616	b3 	. 
	or h			;b617	b4 	. 
	jp c,0dfdeh		;b618	da de df 	. . . 
	push hl			;b61b	e5 	. 
	call nc,0d1d3h		;b61c	d4 d3 d1 	. . . 
	jp nc,0c1c5h		;b61f	d2 c5 c1 	. . . 
	jp 0dcc4h		;b622	c3 c4 dc 	. . . 
	defb 0ddh,0b1h,034h	;illegal sequence		;b625	dd b1 34 	. . 4 
lb628h:
	ld b,e			;b628	43 	C 
	ld b,l			;b629	45 	E 
	ld h,05ch		;b62a	26 5c 	& \ 
	jr z,sub_b683h		;b62c	28 55 	( U 
	scf			;b62e	37 	7 
	ld c,l			;b62f	4d 	M 
	ld c,h			;b630	4c 	L 
	ld a,l			;b631	7d 	} 
	ld e,a			;b632	5f 	_ 
	ld e,(hl)			;b633	5e 	^ 
	ld l,b			;b634	68 	h 
	ld c,c			;b635	49 	I 
	ld sp,03669h		;b636	31 69 36 	1 i 6 
	ld d,c			;b639	51 	Q 
	ld (05259h),a		;b63a	32 59 52 	2 Y R 
	halt			;b63d	76 	v 
	ld (hl),a			;b63e	77 	w 
	ld (hl),l			;b63f	75 	u 
	add hl,hl			;b640	29 	) 
	ld l,01bh		;b641	2e 1b 	. . 
	dec h			;b643	25 	% 
	ld hl,(02d2fh)		;b644	2a 2f 2d 	* / - 
	dec a			;b647	3d 	= 
	dec a			;b648	3d 	= 
	dec a			;b649	3d 	= 
	dec c			;b64a	0d 	. 
	nop			;b64b	00 	. 
	nop			;b64c	00 	. 
lb64dh:
	rra			;b64d	1f 	. 
	ret			;b64e	c9 	. 
lb64fh:
	call nz,0c2d4h		;b64f	c4 d4 c2 	. . . 
	out (046h),a		;b652	d3 46 	. F 
	ld d,d			;b654	52 	R 
lb655h:
	ld c,a			;b655	4f 	O 
	ld (hl),h			;b656	74 	t 
	ld h,d			;b657	62 	b 
	ld b,h			;b658	44 	D 
	out (0d4h),a		;b659	d3 d4 	. . 
	and 0cdh		;b65b	e6 cd 	. . 
	push bc			;b65d	c5 	. 
lb65eh:
	dec b			;b65e	05 	. 
	jp pe,0caefh		;b65f	ea ef ca 	. . . 
	rst 8			;b662	cf 	. 
	rst 20h			;b663	e7 	. 
	ld bc,01b00h		;b664	01 00 1b 	. . . 
	dec c			;b667	0d 	. 
	dec c			;b668	0d 	. 
	ld c,l			;b669	4d 	M 
	ld b,l			;b66a	45 	E 
	ld c,(hl)			;b66b	4e 	N 
	ld d,l			;b66c	55 	U 
	dec c			;b66d	0d 	. 
	nop			;b66e	00 	. 
	ld d,e			;b66f	53 	S 
	ld d,a			;b670	57 	W 
	dec c			;b671	0d 	. 
	nop			;b672	00 	. 
lb673h:
	dec b			;b673	05 	. 
	ret nc			;b674	d0 	. 
	push de			;b675	d5 	. 
	sub 0d9h		;b676	d6 d9 	. . 
	in a,(072h)		;b678	db 72 	. r 
	or l			;b67a	b5 	. 
	ld hl,(01929h)		;b67b	2a 29 19 	* ) . 
	or c			;b67e	b1 	. 
lb67fh:
	ld h,l			;b67f	65 	e 
	or l			;b680	b5 	. 
	ld l,a			;b681	6f 	o 
	ld b,h			;b682	44 	D 
sub_b683h:
	push bc			;b683	c5 	. 
	ld b,000h		;b684	06 00 	. . 
	ld c,(hl)			;b686	4e 	N 
	push bc			;b687	c5 	. 
	inc hl			;b688	23 	# 
	cpir		;b689	ed b1 	. . 
	pop bc			;b68b	c1 	. 
	add hl,bc			;b68c	09 	. 
	dec hl			;b68d	2b 	+ 
	pop bc			;b68e	c1 	. 
	ret			;b68f	c9 	. 
lb690h:
	ld de,lb6a2h		;b690	11 a2 b6 	. . . 
	ld hl,0a983h		;b693	21 83 a9 	! . . 
	call 0040dh		;b696	cd 0d 04 	. . . 
	ld de,lb6d3h		;b699	11 d3 b6 	. . . 
	ld hl,0aa03h		;b69c	21 03 aa 	! . . 
	jp 0040dh		;b69f	c3 0d 04 	. . . 
lb6a2h:
	jr lb6f0h		;b6a2	18 4c 	. L 
	inc sp			;b6a4	33 	3 
	ld h,d			;b6a5	62 	b 
	inc l			;b6a6	2c 	, 
	ld c,b			;b6a7	48 	H 
	inc b			;b6a8	04 	. 
	ld (hl),l			;b6a9	75 	u 
	jr nz,lb71eh		;b6aa	20 72 	  r 
	dec de			;b6ac	1b 	. 
	ld (hl),e			;b6ad	73 	s 
	dec e			;b6ae	1d 	. 
	inc l			;b6af	2c 	, 
	sbc a,b			;b6b0	98 	. 
	cpl			;b6b1	2f 	/ 
	sbc a,b			;b6b2	98 	. 
	ld a,e			;b6b3	7b 	{ 
	sbc a,b			;b6b4	98 	. 
	jr nz,lb64fh		;b6b5	20 98 	  . 
	jr nc,lb67fh		;b6b7	30 c6 	0 . 
	add hl,sp			;b6b9	39 	9 
	sbc a,b			;b6ba	98 	. 
	jr c,lb655h		;b6bb	38 98 	8 . 
	ld c,a			;b6bd	4f 	O 
	sbc a,b			;b6be	98 	. 
	dec h			;b6bf	25 	% 
	sbc a,b			;b6c0	98 	. 
	ld a,h			;b6c1	7c 	| 
	sbc a,b			;b6c2	98 	. 
	ld a,l			;b6c3	7d 	} 
	sbc a,b			;b6c4	98 	. 
	ld a,(hl)			;b6c5	7e 	~ 
	sbc a,b			;b6c6	98 	. 
	ld hl,05b98h		;b6c7	21 98 5b 	! . [ 
	add a,h			;b6ca	84 	. 
	ld e,l			;b6cb	5d 	] 
	add a,l			;b6cc	85 	. 
	ld d,(hl)			;b6cd	56 	V 
	sbc a,b			;b6ce	98 	. 
	ld d,b			;b6cf	50 	P 
	sbc a,b			;b6d0	98 	. 
	ld c,e			;b6d1	4b 	K 
	sbc a,b			;b6d2	98 	. 
lb6d3h:
	ld bc,0b301h		;b6d3	01 01 b3 	. . . 
lb6d6h:
	rlca			;b6d6	07 	. 
	sbc a,a			;b6d7	9f 	. 
	jr lb756h		;b6d8	18 7c 	. | 
	ex af,af'			;b6da	08 	. 
	ex af,af'			;b6db	08 	. 
	ld b,h			;b6dc	44 	D 
	adc a,b			;b6dd	88 	. 
	ld c,010h		;b6de	0e 10 	. . 
	ld sp,hl			;b6e0	f9 	. 
	ret p			;b6e1	f0 	. 
	ld (bc),a			;b6e2	02 	. 
	ld hl,02012h		;b6e3	21 12 20 	! .   
	inc a			;b6e6	3c 	< 
	ld b,d			;b6e7	42 	B 
	inc h			;b6e8	24 	$ 
	jr nz,lb70bh		;b6e9	20 20 	    
	jr nz,lb70dh		;b6eb	20 20 	    
	jr nz,lb745h		;b6ed	20 56 	  V 
	ld h,l			;b6ef	65 	e 
lb6f0h:
	ld (hl),d			;b6f0	72 	r 
	ld (hl),e			;b6f1	73 	s 
	ld l,c			;b6f2	69 	i 
	ld l,a			;b6f3	6f 	o 
	ld l,(hl)			;b6f4	6e 	n 
	jr nz,lb745h		;b6f5	20 4e 	  N 
	ld l,a			;b6f7	6f 	o 
	ld l,020h		;b6f8	2e 20 	.   
	ld (hl),033h		;b6fa	36 33 	6 3 
	ld l,033h		;b6fc	2e 33 	. 3 
	jr nz,34		;b6fe	20 20 	    
	jr nz,lb722h		;b700	20 20 	    
	jr nz,lb724h		;b702	20 20 	    
	jr nz,lb749h		;b704	20 43 	  C 
	ld l,a			;b706	6f 	o 
	ld (hl),b			;b707	70 	p 
	ld a,c			;b708	79 	y 
	ld (hl),d			;b709	72 	r 
	ld l,c			;b70a	69 	i 
lb70bh:
	ld h,a			;b70b	67 	g 
	ld l,b			;b70c	68 	h 
lb70dh:
	ld (hl),h			;b70d	74 	t 
	jr nz,lb738h		;b70e	20 28 	  ( 
	ld b,e			;b710	43 	C 
	add hl,hl			;b711	29 	) 
	jr nz,lb745h		;b712	20 31 	  1 
	add hl,sp			;b714	39 	9 
	jr c,lb74ah		;b715	38 33 	8 3 
	jr nz,lb739h		;b717	20 20 	    
	jr nz,lb73bh		;b719	20 20 	    
	ld d,e			;b71b	53 	S 
	ld (hl),h			;b71c	74 	t 
	ld h,c			;b71d	61 	a 
lb71eh:
	ld (hl),d			;b71e	72 	r 
	jr nz,lb775h		;b71f	20 54 	  T 
	ld h,l			;b721	65 	e 
lb722h:
	ld h,e			;b722	63 	c 
	ld l,b			;b723	68 	h 
lb724h:
	ld l,(hl)			;b724	6e 	n 
	ld l,a			;b725	6f 	o 
	ld l,h			;b726	6c 	l 
	ld l,a			;b727	6f 	o 
	ld h,a			;b728	67 	g 
	ld l,c			;b729	69 	i 
	ld h,l			;b72a	65 	e 
	ld (hl),e			;b72b	73 	s 
	inc l			;b72c	2c 	, 
	jr nz,lb778h		;b72d	20 49 	  I 
	ld l,(hl)			;b72f	6e 	n 
	ld h,e			;b730	63 	c 
	ld l,0ffh		;b731	2e ff 	. . 
	rst 38h			;b733	ff 	. 
	rst 38h			;b734	ff 	. 
	rst 38h			;b735	ff 	. 
	rst 38h			;b736	ff 	. 
	rst 38h			;b737	ff 	. 
lb738h:
	rst 38h			;b738	ff 	. 
lb739h:
	rst 38h			;b739	ff 	. 
	rst 38h			;b73a	ff 	. 
lb73bh:
	rst 38h			;b73b	ff 	. 
	rst 38h			;b73c	ff 	. 
	rst 38h			;b73d	ff 	. 
	rst 38h			;b73e	ff 	. 
	rst 38h			;b73f	ff 	. 
	rst 38h			;b740	ff 	. 
	rst 38h			;b741	ff 	. 
	rst 38h			;b742	ff 	. 
	rst 38h			;b743	ff 	. 
	rst 38h			;b744	ff 	. 
lb745h:
	rst 38h			;b745	ff 	. 
	rst 38h			;b746	ff 	. 
	rst 38h			;b747	ff 	. 
	rst 38h			;b748	ff 	. 
lb749h:
	rst 38h			;b749	ff 	. 
lb74ah:
	rst 38h			;b74a	ff 	. 
	rst 38h			;b74b	ff 	. 
	rst 38h			;b74c	ff 	. 
	rst 38h			;b74d	ff 	. 
	rst 38h			;b74e	ff 	. 
	rst 38h			;b74f	ff 	. 
	rst 38h			;b750	ff 	. 
	rst 38h			;b751	ff 	. 
	rst 38h			;b752	ff 	. 
	rst 38h			;b753	ff 	. 
	rst 38h			;b754	ff 	. 
	rst 38h			;b755	ff 	. 
lb756h:
	rst 38h			;b756	ff 	. 
	rst 38h			;b757	ff 	. 
	rst 38h			;b758	ff 	. 
	rst 38h			;b759	ff 	. 
	rst 38h			;b75a	ff 	. 
	rst 38h			;b75b	ff 	. 
	rst 38h			;b75c	ff 	. 
	rst 38h			;b75d	ff 	. 
	rst 38h			;b75e	ff 	. 
	rst 38h			;b75f	ff 	. 
	rst 38h			;b760	ff 	. 
	rst 38h			;b761	ff 	. 
	rst 38h			;b762	ff 	. 
	rst 38h			;b763	ff 	. 
	rst 38h			;b764	ff 	. 
	rst 38h			;b765	ff 	. 
	rst 38h			;b766	ff 	. 
	rst 38h			;b767	ff 	. 
	rst 38h			;b768	ff 	. 
	rst 38h			;b769	ff 	. 
	rst 38h			;b76a	ff 	. 
	rst 38h			;b76b	ff 	. 
	rst 38h			;b76c	ff 	. 
	rst 38h			;b76d	ff 	. 
	rst 38h			;b76e	ff 	. 
	rst 38h			;b76f	ff 	. 
	rst 38h			;b770	ff 	. 
	rst 38h			;b771	ff 	. 
	rst 38h			;b772	ff 	. 
	rst 38h			;b773	ff 	. 
	rst 38h			;b774	ff 	. 
lb775h:
	rst 38h			;b775	ff 	. 
	rst 38h			;b776	ff 	. 
	rst 38h			;b777	ff 	. 
lb778h:
	rst 38h			;b778	ff 	. 
	rst 38h			;b779	ff 	. 
	rst 38h			;b77a	ff 	. 
	rst 38h			;b77b	ff 	. 
	rst 38h			;b77c	ff 	. 
	rst 38h			;b77d	ff 	. 
	rst 38h			;b77e	ff 	. 
	rst 38h			;b77f	ff 	. 
	rst 38h			;b780	ff 	. 
	rst 38h			;b781	ff 	. 
	rst 38h			;b782	ff 	. 
	rst 38h			;b783	ff 	. 
	rst 38h			;b784	ff 	. 
	rst 38h			;b785	ff 	. 
	rst 38h			;b786	ff 	. 
	rst 38h			;b787	ff 	. 
	rst 38h			;b788	ff 	. 
	rst 38h			;b789	ff 	. 
	rst 38h			;b78a	ff 	. 
	rst 38h			;b78b	ff 	. 
	rst 38h			;b78c	ff 	. 
	rst 38h			;b78d	ff 	. 
	rst 38h			;b78e	ff 	. 
	rst 38h			;b78f	ff 	. 
	rst 38h			;b790	ff 	. 
	rst 38h			;b791	ff 	. 
	rst 38h			;b792	ff 	. 
	rst 38h			;b793	ff 	. 
	rst 38h			;b794	ff 	. 
	rst 38h			;b795	ff 	. 
	rst 38h			;b796	ff 	. 
	rst 38h			;b797	ff 	. 
	rst 38h			;b798	ff 	. 
	rst 38h			;b799	ff 	. 
	rst 38h			;b79a	ff 	. 
	rst 38h			;b79b	ff 	. 
	rst 38h			;b79c	ff 	. 
	rst 38h			;b79d	ff 	. 
	rst 38h			;b79e	ff 	. 
	rst 38h			;b79f	ff 	. 
	rst 38h			;b7a0	ff 	. 
	rst 38h			;b7a1	ff 	. 
	rst 38h			;b7a2	ff 	. 
	rst 38h			;b7a3	ff 	. 
	rst 38h			;b7a4	ff 	. 
	rst 38h			;b7a5	ff 	. 
	rst 38h			;b7a6	ff 	. 
	rst 38h			;b7a7	ff 	. 
	rst 38h			;b7a8	ff 	. 
	rst 38h			;b7a9	ff 	. 
	rst 38h			;b7aa	ff 	. 
	rst 38h			;b7ab	ff 	. 
	rst 38h			;b7ac	ff 	. 
	rst 38h			;b7ad	ff 	. 
	rst 38h			;b7ae	ff 	. 
	rst 38h			;b7af	ff 	. 
	rst 38h			;b7b0	ff 	. 
	rst 38h			;b7b1	ff 	. 
	rst 38h			;b7b2	ff 	. 
	rst 38h			;b7b3	ff 	. 
	rst 38h			;b7b4	ff 	. 
	rst 38h			;b7b5	ff 	. 
	rst 38h			;b7b6	ff 	. 
	rst 38h			;b7b7	ff 	. 
	rst 38h			;b7b8	ff 	. 
	rst 38h			;b7b9	ff 	. 
	rst 38h			;b7ba	ff 	. 
	rst 38h			;b7bb	ff 	. 
	rst 38h			;b7bc	ff 	. 
	rst 38h			;b7bd	ff 	. 
	rst 38h			;b7be	ff 	. 
	rst 38h			;b7bf	ff 	. 
	rst 38h			;b7c0	ff 	. 
	rst 38h			;b7c1	ff 	. 
	rst 38h			;b7c2	ff 	. 
	rst 38h			;b7c3	ff 	. 
	rst 38h			;b7c4	ff 	. 
	rst 38h			;b7c5	ff 	. 
	rst 38h			;b7c6	ff 	. 
	rst 38h			;b7c7	ff 	. 
	rst 38h			;b7c8	ff 	. 
	rst 38h			;b7c9	ff 	. 
	rst 38h			;b7ca	ff 	. 
	rst 38h			;b7cb	ff 	. 
	rst 38h			;b7cc	ff 	. 
	rst 38h			;b7cd	ff 	. 
	rst 38h			;b7ce	ff 	. 
	rst 38h			;b7cf	ff 	. 
	rst 38h			;b7d0	ff 	. 
	rst 38h			;b7d1	ff 	. 
	rst 38h			;b7d2	ff 	. 
	rst 38h			;b7d3	ff 	. 
	rst 38h			;b7d4	ff 	. 
	rst 38h			;b7d5	ff 	. 
	rst 38h			;b7d6	ff 	. 
	rst 38h			;b7d7	ff 	. 
	rst 38h			;b7d8	ff 	. 
	rst 38h			;b7d9	ff 	. 
	rst 38h			;b7da	ff 	. 
	rst 38h			;b7db	ff 	. 
	rst 38h			;b7dc	ff 	. 
	rst 38h			;b7dd	ff 	. 
	rst 38h			;b7de	ff 	. 
	rst 38h			;b7df	ff 	. 
	rst 38h			;b7e0	ff 	. 
	rst 38h			;b7e1	ff 	. 
	rst 38h			;b7e2	ff 	. 
	rst 38h			;b7e3	ff 	. 
	rst 38h			;b7e4	ff 	. 
	rst 38h			;b7e5	ff 	. 
	rst 38h			;b7e6	ff 	. 
	rst 38h			;b7e7	ff 	. 
	rst 38h			;b7e8	ff 	. 
	rst 38h			;b7e9	ff 	. 
	rst 38h			;b7ea	ff 	. 
	rst 38h			;b7eb	ff 	. 
	rst 38h			;b7ec	ff 	. 
	rst 38h			;b7ed	ff 	. 
	rst 38h			;b7ee	ff 	. 
	rst 38h			;b7ef	ff 	. 
	rst 38h			;b7f0	ff 	. 
	rst 38h			;b7f1	ff 	. 
	rst 38h			;b7f2	ff 	. 
	rst 38h			;b7f3	ff 	. 
	rst 38h			;b7f4	ff 	. 
	rst 38h			;b7f5	ff 	. 
	rst 38h			;b7f6	ff 	. 
	rst 38h			;b7f7	ff 	. 
	rst 38h			;b7f8	ff 	. 
	rst 38h			;b7f9	ff 	. 
	rst 38h			;b7fa	ff 	. 
	rst 38h			;b7fb	ff 	. 
	rst 38h			;b7fc	ff 	. 
	rst 38h			;b7fd	ff 	. 
	rst 38h			;b7fe	ff 	. 
	rst 38h			;b7ff	ff 	. 
	rst 38h			;b800	ff 	. 
	rst 38h			;b801	ff 	. 
	rst 38h			;b802	ff 	. 
	rst 38h			;b803	ff 	. 
	rst 38h			;b804	ff 	. 
	rst 38h			;b805	ff 	. 
	rst 38h			;b806	ff 	. 
	rst 38h			;b807	ff 	. 
	rst 38h			;b808	ff 	. 
	rst 38h			;b809	ff 	. 
	rst 38h			;b80a	ff 	. 
	rst 38h			;b80b	ff 	. 
	rst 38h			;b80c	ff 	. 
	rst 38h			;b80d	ff 	. 
	rst 38h			;b80e	ff 	. 
	rst 38h			;b80f	ff 	. 
	rst 38h			;b810	ff 	. 
	rst 38h			;b811	ff 	. 
	rst 38h			;b812	ff 	. 
	rst 38h			;b813	ff 	. 
	rst 38h			;b814	ff 	. 
	rst 38h			;b815	ff 	. 
	rst 38h			;b816	ff 	. 
	rst 38h			;b817	ff 	. 
	rst 38h			;b818	ff 	. 
	rst 38h			;b819	ff 	. 
	rst 38h			;b81a	ff 	. 
	rst 38h			;b81b	ff 	. 
	rst 38h			;b81c	ff 	. 
	rst 38h			;b81d	ff 	. 
	rst 38h			;b81e	ff 	. 
	rst 38h			;b81f	ff 	. 
	rst 38h			;b820	ff 	. 
	rst 38h			;b821	ff 	. 
	rst 38h			;b822	ff 	. 
	rst 38h			;b823	ff 	. 
	rst 38h			;b824	ff 	. 
	rst 38h			;b825	ff 	. 
	rst 38h			;b826	ff 	. 
	rst 38h			;b827	ff 	. 
	rst 38h			;b828	ff 	. 
	rst 38h			;b829	ff 	. 
	rst 38h			;b82a	ff 	. 
	rst 38h			;b82b	ff 	. 
	rst 38h			;b82c	ff 	. 
	rst 38h			;b82d	ff 	. 
	rst 38h			;b82e	ff 	. 
	rst 38h			;b82f	ff 	. 
	rst 38h			;b830	ff 	. 
	rst 38h			;b831	ff 	. 
	rst 38h			;b832	ff 	. 
	rst 38h			;b833	ff 	. 
	rst 38h			;b834	ff 	. 
	rst 38h			;b835	ff 	. 
	rst 38h			;b836	ff 	. 
	rst 38h			;b837	ff 	. 
	rst 38h			;b838	ff 	. 
	rst 38h			;b839	ff 	. 
	rst 38h			;b83a	ff 	. 
	rst 38h			;b83b	ff 	. 
	rst 38h			;b83c	ff 	. 
	rst 38h			;b83d	ff 	. 
	rst 38h			;b83e	ff 	. 
	rst 38h			;b83f	ff 	. 
	rst 38h			;b840	ff 	. 
	rst 38h			;b841	ff 	. 
	rst 38h			;b842	ff 	. 
	rst 38h			;b843	ff 	. 
	rst 38h			;b844	ff 	. 
	rst 38h			;b845	ff 	. 
	rst 38h			;b846	ff 	. 
	rst 38h			;b847	ff 	. 
	rst 38h			;b848	ff 	. 
	rst 38h			;b849	ff 	. 
	rst 38h			;b84a	ff 	. 
	rst 38h			;b84b	ff 	. 
	rst 38h			;b84c	ff 	. 
	rst 38h			;b84d	ff 	. 
	rst 38h			;b84e	ff 	. 
	rst 38h			;b84f	ff 	. 
	rst 38h			;b850	ff 	. 
	rst 38h			;b851	ff 	. 
	rst 38h			;b852	ff 	. 
	rst 38h			;b853	ff 	. 
	rst 38h			;b854	ff 	. 
	rst 38h			;b855	ff 	. 
	rst 38h			;b856	ff 	. 
	rst 38h			;b857	ff 	. 
	rst 38h			;b858	ff 	. 
	rst 38h			;b859	ff 	. 
	rst 38h			;b85a	ff 	. 
	rst 38h			;b85b	ff 	. 
	rst 38h			;b85c	ff 	. 
	rst 38h			;b85d	ff 	. 
	rst 38h			;b85e	ff 	. 
	rst 38h			;b85f	ff 	. 
	rst 38h			;b860	ff 	. 
	rst 38h			;b861	ff 	. 
	rst 38h			;b862	ff 	. 
	rst 38h			;b863	ff 	. 
	rst 38h			;b864	ff 	. 
	rst 38h			;b865	ff 	. 
	rst 38h			;b866	ff 	. 
	rst 38h			;b867	ff 	. 
	rst 38h			;b868	ff 	. 
	rst 38h			;b869	ff 	. 
	rst 38h			;b86a	ff 	. 
	rst 38h			;b86b	ff 	. 
	rst 38h			;b86c	ff 	. 
	rst 38h			;b86d	ff 	. 
	rst 38h			;b86e	ff 	. 
	rst 38h			;b86f	ff 	. 
	rst 38h			;b870	ff 	. 
	rst 38h			;b871	ff 	. 
	rst 38h			;b872	ff 	. 
	rst 38h			;b873	ff 	. 
	rst 38h			;b874	ff 	. 
	rst 38h			;b875	ff 	. 
	rst 38h			;b876	ff 	. 
	rst 38h			;b877	ff 	. 
	rst 38h			;b878	ff 	. 
	rst 38h			;b879	ff 	. 
	rst 38h			;b87a	ff 	. 
	rst 38h			;b87b	ff 	. 
	rst 38h			;b87c	ff 	. 
	rst 38h			;b87d	ff 	. 
	rst 38h			;b87e	ff 	. 
	rst 38h			;b87f	ff 	. 
	rst 38h			;b880	ff 	. 
	rst 38h			;b881	ff 	. 
	rst 38h			;b882	ff 	. 
	rst 38h			;b883	ff 	. 
	rst 38h			;b884	ff 	. 
	rst 38h			;b885	ff 	. 
	rst 38h			;b886	ff 	. 
	rst 38h			;b887	ff 	. 
	rst 38h			;b888	ff 	. 
	rst 38h			;b889	ff 	. 
	rst 38h			;b88a	ff 	. 
	rst 38h			;b88b	ff 	. 
	rst 38h			;b88c	ff 	. 
	rst 38h			;b88d	ff 	. 
	rst 38h			;b88e	ff 	. 
	rst 38h			;b88f	ff 	. 
	rst 38h			;b890	ff 	. 
	rst 38h			;b891	ff 	. 
	rst 38h			;b892	ff 	. 
	rst 38h			;b893	ff 	. 
	rst 38h			;b894	ff 	. 
	rst 38h			;b895	ff 	. 
	rst 38h			;b896	ff 	. 
	rst 38h			;b897	ff 	. 
	rst 38h			;b898	ff 	. 
	rst 38h			;b899	ff 	. 
	rst 38h			;b89a	ff 	. 
	rst 38h			;b89b	ff 	. 
	rst 38h			;b89c	ff 	. 
	rst 38h			;b89d	ff 	. 
	rst 38h			;b89e	ff 	. 
	rst 38h			;b89f	ff 	. 
	rst 38h			;b8a0	ff 	. 
	rst 38h			;b8a1	ff 	. 
	rst 38h			;b8a2	ff 	. 
	rst 38h			;b8a3	ff 	. 
	rst 38h			;b8a4	ff 	. 
	rst 38h			;b8a5	ff 	. 
	rst 38h			;b8a6	ff 	. 
	rst 38h			;b8a7	ff 	. 
	rst 38h			;b8a8	ff 	. 
	rst 38h			;b8a9	ff 	. 
	rst 38h			;b8aa	ff 	. 
	rst 38h			;b8ab	ff 	. 
	rst 38h			;b8ac	ff 	. 
	rst 38h			;b8ad	ff 	. 
	rst 38h			;b8ae	ff 	. 
	rst 38h			;b8af	ff 	. 
	rst 38h			;b8b0	ff 	. 
	rst 38h			;b8b1	ff 	. 
	rst 38h			;b8b2	ff 	. 
	rst 38h			;b8b3	ff 	. 
	rst 38h			;b8b4	ff 	. 
	rst 38h			;b8b5	ff 	. 
	rst 38h			;b8b6	ff 	. 
	rst 38h			;b8b7	ff 	. 
	rst 38h			;b8b8	ff 	. 
	rst 38h			;b8b9	ff 	. 
	rst 38h			;b8ba	ff 	. 
	rst 38h			;b8bb	ff 	. 
	rst 38h			;b8bc	ff 	. 
	rst 38h			;b8bd	ff 	. 
	rst 38h			;b8be	ff 	. 
	rst 38h			;b8bf	ff 	. 
	rst 38h			;b8c0	ff 	. 
	rst 38h			;b8c1	ff 	. 
	rst 38h			;b8c2	ff 	. 
	rst 38h			;b8c3	ff 	. 
	rst 38h			;b8c4	ff 	. 
	rst 38h			;b8c5	ff 	. 
	rst 38h			;b8c6	ff 	. 
	rst 38h			;b8c7	ff 	. 
	rst 38h			;b8c8	ff 	. 
	rst 38h			;b8c9	ff 	. 
	rst 38h			;b8ca	ff 	. 
	rst 38h			;b8cb	ff 	. 
	rst 38h			;b8cc	ff 	. 
	rst 38h			;b8cd	ff 	. 
	rst 38h			;b8ce	ff 	. 
	rst 38h			;b8cf	ff 	. 
	rst 38h			;b8d0	ff 	. 
	rst 38h			;b8d1	ff 	. 
	rst 38h			;b8d2	ff 	. 
	rst 38h			;b8d3	ff 	. 
	rst 38h			;b8d4	ff 	. 
	rst 38h			;b8d5	ff 	. 
	rst 38h			;b8d6	ff 	. 
	rst 38h			;b8d7	ff 	. 
	rst 38h			;b8d8	ff 	. 
	rst 38h			;b8d9	ff 	. 
	rst 38h			;b8da	ff 	. 
	rst 38h			;b8db	ff 	. 
	rst 38h			;b8dc	ff 	. 
	rst 38h			;b8dd	ff 	. 
	rst 38h			;b8de	ff 	. 
	rst 38h			;b8df	ff 	. 
	rst 38h			;b8e0	ff 	. 
	rst 38h			;b8e1	ff 	. 
	rst 38h			;b8e2	ff 	. 
	rst 38h			;b8e3	ff 	. 
	rst 38h			;b8e4	ff 	. 
	rst 38h			;b8e5	ff 	. 
	rst 38h			;b8e6	ff 	. 
	rst 38h			;b8e7	ff 	. 
	rst 38h			;b8e8	ff 	. 
	rst 38h			;b8e9	ff 	. 
	rst 38h			;b8ea	ff 	. 
	rst 38h			;b8eb	ff 	. 
	rst 38h			;b8ec	ff 	. 
	rst 38h			;b8ed	ff 	. 
	rst 38h			;b8ee	ff 	. 
	rst 38h			;b8ef	ff 	. 
	rst 38h			;b8f0	ff 	. 
	rst 38h			;b8f1	ff 	. 
	rst 38h			;b8f2	ff 	. 
	rst 38h			;b8f3	ff 	. 
	rst 38h			;b8f4	ff 	. 
	rst 38h			;b8f5	ff 	. 
	rst 38h			;b8f6	ff 	. 
	rst 38h			;b8f7	ff 	. 
	rst 38h			;b8f8	ff 	. 
	rst 38h			;b8f9	ff 	. 
	rst 38h			;b8fa	ff 	. 
	rst 38h			;b8fb	ff 	. 
	rst 38h			;b8fc	ff 	. 
	rst 38h			;b8fd	ff 	. 
	rst 38h			;b8fe	ff 	. 
	rst 38h			;b8ff	ff 	. 
	rst 38h			;b900	ff 	. 
	rst 38h			;b901	ff 	. 
	rst 38h			;b902	ff 	. 
	rst 38h			;b903	ff 	. 
	rst 38h			;b904	ff 	. 
	rst 38h			;b905	ff 	. 
	rst 38h			;b906	ff 	. 
	rst 38h			;b907	ff 	. 
	rst 38h			;b908	ff 	. 
	rst 38h			;b909	ff 	. 
	rst 38h			;b90a	ff 	. 
	rst 38h			;b90b	ff 	. 
	rst 38h			;b90c	ff 	. 
	rst 38h			;b90d	ff 	. 
	rst 38h			;b90e	ff 	. 
	rst 38h			;b90f	ff 	. 
	rst 38h			;b910	ff 	. 
	rst 38h			;b911	ff 	. 
	rst 38h			;b912	ff 	. 
	rst 38h			;b913	ff 	. 
	rst 38h			;b914	ff 	. 
	rst 38h			;b915	ff 	. 
	rst 38h			;b916	ff 	. 
	rst 38h			;b917	ff 	. 
	rst 38h			;b918	ff 	. 
	rst 38h			;b919	ff 	. 
	rst 38h			;b91a	ff 	. 
	rst 38h			;b91b	ff 	. 
	rst 38h			;b91c	ff 	. 
	rst 38h			;b91d	ff 	. 
	rst 38h			;b91e	ff 	. 
	rst 38h			;b91f	ff 	. 
	rst 38h			;b920	ff 	. 
	rst 38h			;b921	ff 	. 
	rst 38h			;b922	ff 	. 
	rst 38h			;b923	ff 	. 
	rst 38h			;b924	ff 	. 
	rst 38h			;b925	ff 	. 
	rst 38h			;b926	ff 	. 
	rst 38h			;b927	ff 	. 
	rst 38h			;b928	ff 	. 
	rst 38h			;b929	ff 	. 
	rst 38h			;b92a	ff 	. 
	rst 38h			;b92b	ff 	. 
	rst 38h			;b92c	ff 	. 
	rst 38h			;b92d	ff 	. 
	rst 38h			;b92e	ff 	. 
	rst 38h			;b92f	ff 	. 
	rst 38h			;b930	ff 	. 
	rst 38h			;b931	ff 	. 
	rst 38h			;b932	ff 	. 
	rst 38h			;b933	ff 	. 
	rst 38h			;b934	ff 	. 
	rst 38h			;b935	ff 	. 
	rst 38h			;b936	ff 	. 
	rst 38h			;b937	ff 	. 
	rst 38h			;b938	ff 	. 
	rst 38h			;b939	ff 	. 
	rst 38h			;b93a	ff 	. 
	rst 38h			;b93b	ff 	. 
	rst 38h			;b93c	ff 	. 
	rst 38h			;b93d	ff 	. 
	rst 38h			;b93e	ff 	. 
	rst 38h			;b93f	ff 	. 
	rst 38h			;b940	ff 	. 
	rst 38h			;b941	ff 	. 
	rst 38h			;b942	ff 	. 
	rst 38h			;b943	ff 	. 
	rst 38h			;b944	ff 	. 
	rst 38h			;b945	ff 	. 
	rst 38h			;b946	ff 	. 
	rst 38h			;b947	ff 	. 
	rst 38h			;b948	ff 	. 
	rst 38h			;b949	ff 	. 
	rst 38h			;b94a	ff 	. 
	rst 38h			;b94b	ff 	. 
	rst 38h			;b94c	ff 	. 
	rst 38h			;b94d	ff 	. 
	rst 38h			;b94e	ff 	. 
	rst 38h			;b94f	ff 	. 
	rst 38h			;b950	ff 	. 
	rst 38h			;b951	ff 	. 
	rst 38h			;b952	ff 	. 
	rst 38h			;b953	ff 	. 
	rst 38h			;b954	ff 	. 
	rst 38h			;b955	ff 	. 
	rst 38h			;b956	ff 	. 
	rst 38h			;b957	ff 	. 
	rst 38h			;b958	ff 	. 
	rst 38h			;b959	ff 	. 
	rst 38h			;b95a	ff 	. 
	rst 38h			;b95b	ff 	. 
	rst 38h			;b95c	ff 	. 
	rst 38h			;b95d	ff 	. 
	rst 38h			;b95e	ff 	. 
	rst 38h			;b95f	ff 	. 
	rst 38h			;b960	ff 	. 
	rst 38h			;b961	ff 	. 
	rst 38h			;b962	ff 	. 
	rst 38h			;b963	ff 	. 
	rst 38h			;b964	ff 	. 
	rst 38h			;b965	ff 	. 
	rst 38h			;b966	ff 	. 
	rst 38h			;b967	ff 	. 
	rst 38h			;b968	ff 	. 
	rst 38h			;b969	ff 	. 
	rst 38h			;b96a	ff 	. 
	rst 38h			;b96b	ff 	. 
	rst 38h			;b96c	ff 	. 
	rst 38h			;b96d	ff 	. 
	rst 38h			;b96e	ff 	. 
	rst 38h			;b96f	ff 	. 
	rst 38h			;b970	ff 	. 
	rst 38h			;b971	ff 	. 
	rst 38h			;b972	ff 	. 
	rst 38h			;b973	ff 	. 
	rst 38h			;b974	ff 	. 
	rst 38h			;b975	ff 	. 
	rst 38h			;b976	ff 	. 
	rst 38h			;b977	ff 	. 
	rst 38h			;b978	ff 	. 
	rst 38h			;b979	ff 	. 
	rst 38h			;b97a	ff 	. 
	rst 38h			;b97b	ff 	. 
	rst 38h			;b97c	ff 	. 
	rst 38h			;b97d	ff 	. 
	rst 38h			;b97e	ff 	. 
	rst 38h			;b97f	ff 	. 
	rst 38h			;b980	ff 	. 
	rst 38h			;b981	ff 	. 
	rst 38h			;b982	ff 	. 
	rst 38h			;b983	ff 	. 
	rst 38h			;b984	ff 	. 
	rst 38h			;b985	ff 	. 
	rst 38h			;b986	ff 	. 
	rst 38h			;b987	ff 	. 
	rst 38h			;b988	ff 	. 
	rst 38h			;b989	ff 	. 
	rst 38h			;b98a	ff 	. 
	rst 38h			;b98b	ff 	. 
	rst 38h			;b98c	ff 	. 
	rst 38h			;b98d	ff 	. 
	rst 38h			;b98e	ff 	. 
	rst 38h			;b98f	ff 	. 
	rst 38h			;b990	ff 	. 
	rst 38h			;b991	ff 	. 
	rst 38h			;b992	ff 	. 
	rst 38h			;b993	ff 	. 
	rst 38h			;b994	ff 	. 
	rst 38h			;b995	ff 	. 
	rst 38h			;b996	ff 	. 
	rst 38h			;b997	ff 	. 
	rst 38h			;b998	ff 	. 
	rst 38h			;b999	ff 	. 
	rst 38h			;b99a	ff 	. 
	rst 38h			;b99b	ff 	. 
	rst 38h			;b99c	ff 	. 
	rst 38h			;b99d	ff 	. 
	rst 38h			;b99e	ff 	. 
	rst 38h			;b99f	ff 	. 
	rst 38h			;b9a0	ff 	. 
	rst 38h			;b9a1	ff 	. 
	rst 38h			;b9a2	ff 	. 
	rst 38h			;b9a3	ff 	. 
	rst 38h			;b9a4	ff 	. 
	rst 38h			;b9a5	ff 	. 
	rst 38h			;b9a6	ff 	. 
	rst 38h			;b9a7	ff 	. 
	rst 38h			;b9a8	ff 	. 
	rst 38h			;b9a9	ff 	. 
	rst 38h			;b9aa	ff 	. 
	rst 38h			;b9ab	ff 	. 
	rst 38h			;b9ac	ff 	. 
	rst 38h			;b9ad	ff 	. 
	rst 38h			;b9ae	ff 	. 
	rst 38h			;b9af	ff 	. 
	rst 38h			;b9b0	ff 	. 
	rst 38h			;b9b1	ff 	. 
	rst 38h			;b9b2	ff 	. 
	rst 38h			;b9b3	ff 	. 
	rst 38h			;b9b4	ff 	. 
	rst 38h			;b9b5	ff 	. 
	rst 38h			;b9b6	ff 	. 
	rst 38h			;b9b7	ff 	. 
	rst 38h			;b9b8	ff 	. 
	rst 38h			;b9b9	ff 	. 
	rst 38h			;b9ba	ff 	. 
	rst 38h			;b9bb	ff 	. 
	rst 38h			;b9bc	ff 	. 
	rst 38h			;b9bd	ff 	. 
	rst 38h			;b9be	ff 	. 
	rst 38h			;b9bf	ff 	. 
	rst 38h			;b9c0	ff 	. 
	rst 38h			;b9c1	ff 	. 
	rst 38h			;b9c2	ff 	. 
	rst 38h			;b9c3	ff 	. 
	rst 38h			;b9c4	ff 	. 
	rst 38h			;b9c5	ff 	. 
	rst 38h			;b9c6	ff 	. 
	rst 38h			;b9c7	ff 	. 
	rst 38h			;b9c8	ff 	. 
	rst 38h			;b9c9	ff 	. 
	rst 38h			;b9ca	ff 	. 
	rst 38h			;b9cb	ff 	. 
	rst 38h			;b9cc	ff 	. 
	rst 38h			;b9cd	ff 	. 
	rst 38h			;b9ce	ff 	. 
	rst 38h			;b9cf	ff 	. 
	rst 38h			;b9d0	ff 	. 
	rst 38h			;b9d1	ff 	. 
	rst 38h			;b9d2	ff 	. 
	rst 38h			;b9d3	ff 	. 
	rst 38h			;b9d4	ff 	. 
	rst 38h			;b9d5	ff 	. 
	rst 38h			;b9d6	ff 	. 
	rst 38h			;b9d7	ff 	. 
	rst 38h			;b9d8	ff 	. 
	rst 38h			;b9d9	ff 	. 
	rst 38h			;b9da	ff 	. 
	rst 38h			;b9db	ff 	. 
	rst 38h			;b9dc	ff 	. 
	rst 38h			;b9dd	ff 	. 
	rst 38h			;b9de	ff 	. 
	rst 38h			;b9df	ff 	. 
	rst 38h			;b9e0	ff 	. 
	rst 38h			;b9e1	ff 	. 
	rst 38h			;b9e2	ff 	. 
	rst 38h			;b9e3	ff 	. 
	rst 38h			;b9e4	ff 	. 
	rst 38h			;b9e5	ff 	. 
	rst 38h			;b9e6	ff 	. 
	rst 38h			;b9e7	ff 	. 
	rst 38h			;b9e8	ff 	. 
	rst 38h			;b9e9	ff 	. 
	rst 38h			;b9ea	ff 	. 
	rst 38h			;b9eb	ff 	. 
	rst 38h			;b9ec	ff 	. 
	rst 38h			;b9ed	ff 	. 
	rst 38h			;b9ee	ff 	. 
	rst 38h			;b9ef	ff 	. 
	rst 38h			;b9f0	ff 	. 
	rst 38h			;b9f1	ff 	. 
	rst 38h			;b9f2	ff 	. 
	rst 38h			;b9f3	ff 	. 
	rst 38h			;b9f4	ff 	. 
	rst 38h			;b9f5	ff 	. 
	rst 38h			;b9f6	ff 	. 
	rst 38h			;b9f7	ff 	. 
	rst 38h			;b9f8	ff 	. 
	rst 38h			;b9f9	ff 	. 
	rst 38h			;b9fa	ff 	. 
	rst 38h			;b9fb	ff 	. 
	rst 38h			;b9fc	ff 	. 
	rst 38h			;b9fd	ff 	. 
	rst 38h			;b9fe	ff 	. 
	rst 38h			;b9ff	ff 	. 
	rst 38h			;ba00	ff 	. 
	rst 38h			;ba01	ff 	. 
	rst 38h			;ba02	ff 	. 
	rst 38h			;ba03	ff 	. 
	rst 38h			;ba04	ff 	. 
	rst 38h			;ba05	ff 	. 
	rst 38h			;ba06	ff 	. 
	rst 38h			;ba07	ff 	. 
	rst 38h			;ba08	ff 	. 
	rst 38h			;ba09	ff 	. 
	rst 38h			;ba0a	ff 	. 
	rst 38h			;ba0b	ff 	. 
	rst 38h			;ba0c	ff 	. 
	rst 38h			;ba0d	ff 	. 
	rst 38h			;ba0e	ff 	. 
	rst 38h			;ba0f	ff 	. 
	rst 38h			;ba10	ff 	. 
	rst 38h			;ba11	ff 	. 
	rst 38h			;ba12	ff 	. 
	rst 38h			;ba13	ff 	. 
	rst 38h			;ba14	ff 	. 
	rst 38h			;ba15	ff 	. 
	rst 38h			;ba16	ff 	. 
	rst 38h			;ba17	ff 	. 
	rst 38h			;ba18	ff 	. 
	rst 38h			;ba19	ff 	. 
	rst 38h			;ba1a	ff 	. 
	rst 38h			;ba1b	ff 	. 
	rst 38h			;ba1c	ff 	. 
	rst 38h			;ba1d	ff 	. 
	rst 38h			;ba1e	ff 	. 
	rst 38h			;ba1f	ff 	. 
	rst 38h			;ba20	ff 	. 
	rst 38h			;ba21	ff 	. 
	rst 38h			;ba22	ff 	. 
	rst 38h			;ba23	ff 	. 
	rst 38h			;ba24	ff 	. 
	rst 38h			;ba25	ff 	. 
	rst 38h			;ba26	ff 	. 
	rst 38h			;ba27	ff 	. 
	rst 38h			;ba28	ff 	. 
	rst 38h			;ba29	ff 	. 
	rst 38h			;ba2a	ff 	. 
	rst 38h			;ba2b	ff 	. 
	rst 38h			;ba2c	ff 	. 
	rst 38h			;ba2d	ff 	. 
	rst 38h			;ba2e	ff 	. 
	rst 38h			;ba2f	ff 	. 
	rst 38h			;ba30	ff 	. 
	rst 38h			;ba31	ff 	. 
	rst 38h			;ba32	ff 	. 
	rst 38h			;ba33	ff 	. 
	rst 38h			;ba34	ff 	. 
	rst 38h			;ba35	ff 	. 
	rst 38h			;ba36	ff 	. 
	rst 38h			;ba37	ff 	. 
	rst 38h			;ba38	ff 	. 
	rst 38h			;ba39	ff 	. 
	rst 38h			;ba3a	ff 	. 
	rst 38h			;ba3b	ff 	. 
	rst 38h			;ba3c	ff 	. 
	rst 38h			;ba3d	ff 	. 
	rst 38h			;ba3e	ff 	. 
	rst 38h			;ba3f	ff 	. 
	rst 38h			;ba40	ff 	. 
	rst 38h			;ba41	ff 	. 
	rst 38h			;ba42	ff 	. 
	rst 38h			;ba43	ff 	. 
	rst 38h			;ba44	ff 	. 
	rst 38h			;ba45	ff 	. 
	rst 38h			;ba46	ff 	. 
	rst 38h			;ba47	ff 	. 
	rst 38h			;ba48	ff 	. 
	rst 38h			;ba49	ff 	. 
	rst 38h			;ba4a	ff 	. 
	rst 38h			;ba4b	ff 	. 
	rst 38h			;ba4c	ff 	. 
	rst 38h			;ba4d	ff 	. 
	rst 38h			;ba4e	ff 	. 
	rst 38h			;ba4f	ff 	. 
	rst 38h			;ba50	ff 	. 
	rst 38h			;ba51	ff 	. 
	rst 38h			;ba52	ff 	. 
	rst 38h			;ba53	ff 	. 
	rst 38h			;ba54	ff 	. 
	rst 38h			;ba55	ff 	. 
	rst 38h			;ba56	ff 	. 
	rst 38h			;ba57	ff 	. 
	rst 38h			;ba58	ff 	. 
	rst 38h			;ba59	ff 	. 
	rst 38h			;ba5a	ff 	. 
	rst 38h			;ba5b	ff 	. 
	rst 38h			;ba5c	ff 	. 
	rst 38h			;ba5d	ff 	. 
	rst 38h			;ba5e	ff 	. 
	rst 38h			;ba5f	ff 	. 
	rst 38h			;ba60	ff 	. 
	rst 38h			;ba61	ff 	. 
	rst 38h			;ba62	ff 	. 
	rst 38h			;ba63	ff 	. 
	rst 38h			;ba64	ff 	. 
	rst 38h			;ba65	ff 	. 
	rst 38h			;ba66	ff 	. 
	rst 38h			;ba67	ff 	. 
	rst 38h			;ba68	ff 	. 
	rst 38h			;ba69	ff 	. 
	rst 38h			;ba6a	ff 	. 
	rst 38h			;ba6b	ff 	. 
	rst 38h			;ba6c	ff 	. 
	rst 38h			;ba6d	ff 	. 
	rst 38h			;ba6e	ff 	. 
	rst 38h			;ba6f	ff 	. 
	rst 38h			;ba70	ff 	. 
	rst 38h			;ba71	ff 	. 
	rst 38h			;ba72	ff 	. 
	rst 38h			;ba73	ff 	. 
	rst 38h			;ba74	ff 	. 
	rst 38h			;ba75	ff 	. 
	rst 38h			;ba76	ff 	. 
	rst 38h			;ba77	ff 	. 
	rst 38h			;ba78	ff 	. 
	rst 38h			;ba79	ff 	. 
	rst 38h			;ba7a	ff 	. 
	rst 38h			;ba7b	ff 	. 
	rst 38h			;ba7c	ff 	. 
	rst 38h			;ba7d	ff 	. 
	rst 38h			;ba7e	ff 	. 
	rst 38h			;ba7f	ff 	. 
	rst 38h			;ba80	ff 	. 
	rst 38h			;ba81	ff 	. 
	rst 38h			;ba82	ff 	. 
	rst 38h			;ba83	ff 	. 
	rst 38h			;ba84	ff 	. 
	rst 38h			;ba85	ff 	. 
	rst 38h			;ba86	ff 	. 
	rst 38h			;ba87	ff 	. 
	rst 38h			;ba88	ff 	. 
	rst 38h			;ba89	ff 	. 
	rst 38h			;ba8a	ff 	. 
	rst 38h			;ba8b	ff 	. 
	rst 38h			;ba8c	ff 	. 
	rst 38h			;ba8d	ff 	. 
	rst 38h			;ba8e	ff 	. 
	rst 38h			;ba8f	ff 	. 
	rst 38h			;ba90	ff 	. 
	rst 38h			;ba91	ff 	. 
	rst 38h			;ba92	ff 	. 
	rst 38h			;ba93	ff 	. 
	rst 38h			;ba94	ff 	. 
	rst 38h			;ba95	ff 	. 
	rst 38h			;ba96	ff 	. 
	rst 38h			;ba97	ff 	. 
	rst 38h			;ba98	ff 	. 
	rst 38h			;ba99	ff 	. 
	rst 38h			;ba9a	ff 	. 
	rst 38h			;ba9b	ff 	. 
	rst 38h			;ba9c	ff 	. 
	rst 38h			;ba9d	ff 	. 
	rst 38h			;ba9e	ff 	. 
	rst 38h			;ba9f	ff 	. 
	rst 38h			;baa0	ff 	. 
	rst 38h			;baa1	ff 	. 
	rst 38h			;baa2	ff 	. 
	rst 38h			;baa3	ff 	. 
	rst 38h			;baa4	ff 	. 
	rst 38h			;baa5	ff 	. 
	rst 38h			;baa6	ff 	. 
	rst 38h			;baa7	ff 	. 
	rst 38h			;baa8	ff 	. 
	rst 38h			;baa9	ff 	. 
	rst 38h			;baaa	ff 	. 
	rst 38h			;baab	ff 	. 
	rst 38h			;baac	ff 	. 
	rst 38h			;baad	ff 	. 
	rst 38h			;baae	ff 	. 
	rst 38h			;baaf	ff 	. 
	rst 38h			;bab0	ff 	. 
	rst 38h			;bab1	ff 	. 
	rst 38h			;bab2	ff 	. 
	rst 38h			;bab3	ff 	. 
	rst 38h			;bab4	ff 	. 
	rst 38h			;bab5	ff 	. 
	rst 38h			;bab6	ff 	. 
	rst 38h			;bab7	ff 	. 
	rst 38h			;bab8	ff 	. 
	rst 38h			;bab9	ff 	. 
	rst 38h			;baba	ff 	. 
	rst 38h			;babb	ff 	. 
	rst 38h			;babc	ff 	. 
	rst 38h			;babd	ff 	. 
	rst 38h			;babe	ff 	. 
	rst 38h			;babf	ff 	. 
	rst 38h			;bac0	ff 	. 
	rst 38h			;bac1	ff 	. 
	rst 38h			;bac2	ff 	. 
	rst 38h			;bac3	ff 	. 
	rst 38h			;bac4	ff 	. 
	rst 38h			;bac5	ff 	. 
	rst 38h			;bac6	ff 	. 
	rst 38h			;bac7	ff 	. 
	rst 38h			;bac8	ff 	. 
	rst 38h			;bac9	ff 	. 
	rst 38h			;baca	ff 	. 
	rst 38h			;bacb	ff 	. 
	rst 38h			;bacc	ff 	. 
	rst 38h			;bacd	ff 	. 
	rst 38h			;bace	ff 	. 
	rst 38h			;bacf	ff 	. 
	rst 38h			;bad0	ff 	. 
	rst 38h			;bad1	ff 	. 
	rst 38h			;bad2	ff 	. 
	rst 38h			;bad3	ff 	. 
	rst 38h			;bad4	ff 	. 
	rst 38h			;bad5	ff 	. 
	rst 38h			;bad6	ff 	. 
	rst 38h			;bad7	ff 	. 
	rst 38h			;bad8	ff 	. 
	rst 38h			;bad9	ff 	. 
	rst 38h			;bada	ff 	. 
	rst 38h			;badb	ff 	. 
	rst 38h			;badc	ff 	. 
	rst 38h			;badd	ff 	. 
	rst 38h			;bade	ff 	. 
	rst 38h			;badf	ff 	. 
	rst 38h			;bae0	ff 	. 
	rst 38h			;bae1	ff 	. 
	rst 38h			;bae2	ff 	. 
	rst 38h			;bae3	ff 	. 
	rst 38h			;bae4	ff 	. 
	rst 38h			;bae5	ff 	. 
	rst 38h			;bae6	ff 	. 
	rst 38h			;bae7	ff 	. 
	rst 38h			;bae8	ff 	. 
	rst 38h			;bae9	ff 	. 
	rst 38h			;baea	ff 	. 
	rst 38h			;baeb	ff 	. 
	rst 38h			;baec	ff 	. 
	rst 38h			;baed	ff 	. 
	rst 38h			;baee	ff 	. 
	rst 38h			;baef	ff 	. 
	rst 38h			;baf0	ff 	. 
	rst 38h			;baf1	ff 	. 
	rst 38h			;baf2	ff 	. 
	rst 38h			;baf3	ff 	. 
	rst 38h			;baf4	ff 	. 
	rst 38h			;baf5	ff 	. 
	rst 38h			;baf6	ff 	. 
	rst 38h			;baf7	ff 	. 
	rst 38h			;baf8	ff 	. 
	rst 38h			;baf9	ff 	. 
	rst 38h			;bafa	ff 	. 
	rst 38h			;bafb	ff 	. 
	rst 38h			;bafc	ff 	. 
	rst 38h			;bafd	ff 	. 
	rst 38h			;bafe	ff 	. 
	rst 38h			;baff	ff 	. 
	rst 38h			;bb00	ff 	. 
	rst 38h			;bb01	ff 	. 
	rst 38h			;bb02	ff 	. 
	rst 38h			;bb03	ff 	. 
	rst 38h			;bb04	ff 	. 
	rst 38h			;bb05	ff 	. 
	rst 38h			;bb06	ff 	. 
	rst 38h			;bb07	ff 	. 
	rst 38h			;bb08	ff 	. 
	rst 38h			;bb09	ff 	. 
	rst 38h			;bb0a	ff 	. 
	rst 38h			;bb0b	ff 	. 
	rst 38h			;bb0c	ff 	. 
	rst 38h			;bb0d	ff 	. 
	rst 38h			;bb0e	ff 	. 
	rst 38h			;bb0f	ff 	. 
	rst 38h			;bb10	ff 	. 
	rst 38h			;bb11	ff 	. 
	rst 38h			;bb12	ff 	. 
	rst 38h			;bb13	ff 	. 
	rst 38h			;bb14	ff 	. 
	rst 38h			;bb15	ff 	. 
	rst 38h			;bb16	ff 	. 
	rst 38h			;bb17	ff 	. 
	rst 38h			;bb18	ff 	. 
	rst 38h			;bb19	ff 	. 
	rst 38h			;bb1a	ff 	. 
	rst 38h			;bb1b	ff 	. 
	rst 38h			;bb1c	ff 	. 
	rst 38h			;bb1d	ff 	. 
	rst 38h			;bb1e	ff 	. 
	rst 38h			;bb1f	ff 	. 
	rst 38h			;bb20	ff 	. 
	rst 38h			;bb21	ff 	. 
	rst 38h			;bb22	ff 	. 
	rst 38h			;bb23	ff 	. 
	rst 38h			;bb24	ff 	. 
	rst 38h			;bb25	ff 	. 
	rst 38h			;bb26	ff 	. 
	rst 38h			;bb27	ff 	. 
	rst 38h			;bb28	ff 	. 
	rst 38h			;bb29	ff 	. 
	rst 38h			;bb2a	ff 	. 
	rst 38h			;bb2b	ff 	. 
	rst 38h			;bb2c	ff 	. 
	rst 38h			;bb2d	ff 	. 
	rst 38h			;bb2e	ff 	. 
	rst 38h			;bb2f	ff 	. 
	rst 38h			;bb30	ff 	. 
	rst 38h			;bb31	ff 	. 
	rst 38h			;bb32	ff 	. 
	rst 38h			;bb33	ff 	. 
	rst 38h			;bb34	ff 	. 
	rst 38h			;bb35	ff 	. 
	rst 38h			;bb36	ff 	. 
	rst 38h			;bb37	ff 	. 
	rst 38h			;bb38	ff 	. 
	rst 38h			;bb39	ff 	. 
	rst 38h			;bb3a	ff 	. 
	rst 38h			;bb3b	ff 	. 
	rst 38h			;bb3c	ff 	. 
	rst 38h			;bb3d	ff 	. 
	rst 38h			;bb3e	ff 	. 
	rst 38h			;bb3f	ff 	. 
	rst 38h			;bb40	ff 	. 
	rst 38h			;bb41	ff 	. 
	rst 38h			;bb42	ff 	. 
	rst 38h			;bb43	ff 	. 
	rst 38h			;bb44	ff 	. 
	rst 38h			;bb45	ff 	. 
	rst 38h			;bb46	ff 	. 
	rst 38h			;bb47	ff 	. 
	rst 38h			;bb48	ff 	. 
	rst 38h			;bb49	ff 	. 
	rst 38h			;bb4a	ff 	. 
	rst 38h			;bb4b	ff 	. 
	rst 38h			;bb4c	ff 	. 
	rst 38h			;bb4d	ff 	. 
	rst 38h			;bb4e	ff 	. 
	rst 38h			;bb4f	ff 	. 
	rst 38h			;bb50	ff 	. 
	rst 38h			;bb51	ff 	. 
	rst 38h			;bb52	ff 	. 
	rst 38h			;bb53	ff 	. 
	rst 38h			;bb54	ff 	. 
	rst 38h			;bb55	ff 	. 
	rst 38h			;bb56	ff 	. 
	rst 38h			;bb57	ff 	. 
	rst 38h			;bb58	ff 	. 
	rst 38h			;bb59	ff 	. 
	rst 38h			;bb5a	ff 	. 
	rst 38h			;bb5b	ff 	. 
	rst 38h			;bb5c	ff 	. 
	rst 38h			;bb5d	ff 	. 
	rst 38h			;bb5e	ff 	. 
	rst 38h			;bb5f	ff 	. 
	rst 38h			;bb60	ff 	. 
	rst 38h			;bb61	ff 	. 
	rst 38h			;bb62	ff 	. 
	rst 38h			;bb63	ff 	. 
	rst 38h			;bb64	ff 	. 
	rst 38h			;bb65	ff 	. 
	rst 38h			;bb66	ff 	. 
	rst 38h			;bb67	ff 	. 
	rst 38h			;bb68	ff 	. 
	rst 38h			;bb69	ff 	. 
	rst 38h			;bb6a	ff 	. 
	rst 38h			;bb6b	ff 	. 
	rst 38h			;bb6c	ff 	. 
	rst 38h			;bb6d	ff 	. 
	rst 38h			;bb6e	ff 	. 
	rst 38h			;bb6f	ff 	. 
	rst 38h			;bb70	ff 	. 
	rst 38h			;bb71	ff 	. 
	rst 38h			;bb72	ff 	. 
	rst 38h			;bb73	ff 	. 
	rst 38h			;bb74	ff 	. 
	rst 38h			;bb75	ff 	. 
	rst 38h			;bb76	ff 	. 
	rst 38h			;bb77	ff 	. 
	rst 38h			;bb78	ff 	. 
	rst 38h			;bb79	ff 	. 
	rst 38h			;bb7a	ff 	. 
	rst 38h			;bb7b	ff 	. 
	rst 38h			;bb7c	ff 	. 
	rst 38h			;bb7d	ff 	. 
	rst 38h			;bb7e	ff 	. 
	rst 38h			;bb7f	ff 	. 
	rst 38h			;bb80	ff 	. 
	rst 38h			;bb81	ff 	. 
	rst 38h			;bb82	ff 	. 
	rst 38h			;bb83	ff 	. 
	rst 38h			;bb84	ff 	. 
	rst 38h			;bb85	ff 	. 
	rst 38h			;bb86	ff 	. 
	rst 38h			;bb87	ff 	. 
	rst 38h			;bb88	ff 	. 
	rst 38h			;bb89	ff 	. 
	rst 38h			;bb8a	ff 	. 
	rst 38h			;bb8b	ff 	. 
	rst 38h			;bb8c	ff 	. 
	rst 38h			;bb8d	ff 	. 
	rst 38h			;bb8e	ff 	. 
	rst 38h			;bb8f	ff 	. 
	rst 38h			;bb90	ff 	. 
	rst 38h			;bb91	ff 	. 
	rst 38h			;bb92	ff 	. 
	rst 38h			;bb93	ff 	. 
	rst 38h			;bb94	ff 	. 
	rst 38h			;bb95	ff 	. 
	rst 38h			;bb96	ff 	. 
	rst 38h			;bb97	ff 	. 
	rst 38h			;bb98	ff 	. 
	rst 38h			;bb99	ff 	. 
	rst 38h			;bb9a	ff 	. 
	rst 38h			;bb9b	ff 	. 
	rst 38h			;bb9c	ff 	. 
	rst 38h			;bb9d	ff 	. 
	rst 38h			;bb9e	ff 	. 
	rst 38h			;bb9f	ff 	. 
	rst 38h			;bba0	ff 	. 
	rst 38h			;bba1	ff 	. 
	rst 38h			;bba2	ff 	. 
	rst 38h			;bba3	ff 	. 
	rst 38h			;bba4	ff 	. 
	rst 38h			;bba5	ff 	. 
	rst 38h			;bba6	ff 	. 
	rst 38h			;bba7	ff 	. 
	rst 38h			;bba8	ff 	. 
	rst 38h			;bba9	ff 	. 
	rst 38h			;bbaa	ff 	. 
	rst 38h			;bbab	ff 	. 
	rst 38h			;bbac	ff 	. 
	rst 38h			;bbad	ff 	. 
	rst 38h			;bbae	ff 	. 
	rst 38h			;bbaf	ff 	. 
	rst 38h			;bbb0	ff 	. 
	rst 38h			;bbb1	ff 	. 
	rst 38h			;bbb2	ff 	. 
	rst 38h			;bbb3	ff 	. 
	rst 38h			;bbb4	ff 	. 
	rst 38h			;bbb5	ff 	. 
	rst 38h			;bbb6	ff 	. 
	rst 38h			;bbb7	ff 	. 
	rst 38h			;bbb8	ff 	. 
	rst 38h			;bbb9	ff 	. 
	rst 38h			;bbba	ff 	. 
	rst 38h			;bbbb	ff 	. 
	rst 38h			;bbbc	ff 	. 
	rst 38h			;bbbd	ff 	. 
	rst 38h			;bbbe	ff 	. 
	rst 38h			;bbbf	ff 	. 
	rst 38h			;bbc0	ff 	. 
	rst 38h			;bbc1	ff 	. 
	rst 38h			;bbc2	ff 	. 
	rst 38h			;bbc3	ff 	. 
	rst 38h			;bbc4	ff 	. 
	rst 38h			;bbc5	ff 	. 
	rst 38h			;bbc6	ff 	. 
	rst 38h			;bbc7	ff 	. 
	rst 38h			;bbc8	ff 	. 
	rst 38h			;bbc9	ff 	. 
	rst 38h			;bbca	ff 	. 
	rst 38h			;bbcb	ff 	. 
	rst 38h			;bbcc	ff 	. 
	rst 38h			;bbcd	ff 	. 
	rst 38h			;bbce	ff 	. 
	rst 38h			;bbcf	ff 	. 
	rst 38h			;bbd0	ff 	. 
	rst 38h			;bbd1	ff 	. 
	rst 38h			;bbd2	ff 	. 
	rst 38h			;bbd3	ff 	. 
	rst 38h			;bbd4	ff 	. 
	rst 38h			;bbd5	ff 	. 
	rst 38h			;bbd6	ff 	. 
	rst 38h			;bbd7	ff 	. 
	rst 38h			;bbd8	ff 	. 
	rst 38h			;bbd9	ff 	. 
	rst 38h			;bbda	ff 	. 
	rst 38h			;bbdb	ff 	. 
	rst 38h			;bbdc	ff 	. 
	rst 38h			;bbdd	ff 	. 
	rst 38h			;bbde	ff 	. 
	rst 38h			;bbdf	ff 	. 
	rst 38h			;bbe0	ff 	. 
	rst 38h			;bbe1	ff 	. 
	rst 38h			;bbe2	ff 	. 
	rst 38h			;bbe3	ff 	. 
	rst 38h			;bbe4	ff 	. 
	rst 38h			;bbe5	ff 	. 
	rst 38h			;bbe6	ff 	. 
	rst 38h			;bbe7	ff 	. 
	rst 38h			;bbe8	ff 	. 
	rst 38h			;bbe9	ff 	. 
	rst 38h			;bbea	ff 	. 
	rst 38h			;bbeb	ff 	. 
	rst 38h			;bbec	ff 	. 
	rst 38h			;bbed	ff 	. 
	rst 38h			;bbee	ff 	. 
	rst 38h			;bbef	ff 	. 
	rst 38h			;bbf0	ff 	. 
	rst 38h			;bbf1	ff 	. 
	rst 38h			;bbf2	ff 	. 
	rst 38h			;bbf3	ff 	. 
	rst 38h			;bbf4	ff 	. 
	rst 38h			;bbf5	ff 	. 
	rst 38h			;bbf6	ff 	. 
	rst 38h			;bbf7	ff 	. 
	rst 38h			;bbf8	ff 	. 
	rst 38h			;bbf9	ff 	. 
	rst 38h			;bbfa	ff 	. 
	rst 38h			;bbfb	ff 	. 
	rst 38h			;bbfc	ff 	. 
	rst 38h			;bbfd	ff 	. 
	rst 38h			;bbfe	ff 	. 
	rst 38h			;bbff	ff 	. 
	rst 38h			;bc00	ff 	. 
	rst 38h			;bc01	ff 	. 
	rst 38h			;bc02	ff 	. 
	rst 38h			;bc03	ff 	. 
	rst 38h			;bc04	ff 	. 
	rst 38h			;bc05	ff 	. 
	rst 38h			;bc06	ff 	. 
	rst 38h			;bc07	ff 	. 
	rst 38h			;bc08	ff 	. 
	rst 38h			;bc09	ff 	. 
	rst 38h			;bc0a	ff 	. 
	rst 38h			;bc0b	ff 	. 
	rst 38h			;bc0c	ff 	. 
	rst 38h			;bc0d	ff 	. 
	rst 38h			;bc0e	ff 	. 
	rst 38h			;bc0f	ff 	. 
	rst 38h			;bc10	ff 	. 
	rst 38h			;bc11	ff 	. 
	rst 38h			;bc12	ff 	. 
	rst 38h			;bc13	ff 	. 
	rst 38h			;bc14	ff 	. 
	rst 38h			;bc15	ff 	. 
	rst 38h			;bc16	ff 	. 
	rst 38h			;bc17	ff 	. 
	rst 38h			;bc18	ff 	. 
	rst 38h			;bc19	ff 	. 
	rst 38h			;bc1a	ff 	. 
	rst 38h			;bc1b	ff 	. 
	rst 38h			;bc1c	ff 	. 
	rst 38h			;bc1d	ff 	. 
	rst 38h			;bc1e	ff 	. 
	rst 38h			;bc1f	ff 	. 
	rst 38h			;bc20	ff 	. 
	rst 38h			;bc21	ff 	. 
	rst 38h			;bc22	ff 	. 
	rst 38h			;bc23	ff 	. 
	rst 38h			;bc24	ff 	. 
	rst 38h			;bc25	ff 	. 
	rst 38h			;bc26	ff 	. 
	rst 38h			;bc27	ff 	. 
	rst 38h			;bc28	ff 	. 
	rst 38h			;bc29	ff 	. 
	rst 38h			;bc2a	ff 	. 
	rst 38h			;bc2b	ff 	. 
	rst 38h			;bc2c	ff 	. 
	rst 38h			;bc2d	ff 	. 
	rst 38h			;bc2e	ff 	. 
	rst 38h			;bc2f	ff 	. 
	rst 38h			;bc30	ff 	. 
	rst 38h			;bc31	ff 	. 
	rst 38h			;bc32	ff 	. 
	rst 38h			;bc33	ff 	. 
	rst 38h			;bc34	ff 	. 
	rst 38h			;bc35	ff 	. 
	rst 38h			;bc36	ff 	. 
	rst 38h			;bc37	ff 	. 
	rst 38h			;bc38	ff 	. 
	rst 38h			;bc39	ff 	. 
	rst 38h			;bc3a	ff 	. 
	rst 38h			;bc3b	ff 	. 
	rst 38h			;bc3c	ff 	. 
	rst 38h			;bc3d	ff 	. 
	rst 38h			;bc3e	ff 	. 
	rst 38h			;bc3f	ff 	. 
	rst 38h			;bc40	ff 	. 
	rst 38h			;bc41	ff 	. 
	rst 38h			;bc42	ff 	. 
	rst 38h			;bc43	ff 	. 
	rst 38h			;bc44	ff 	. 
	rst 38h			;bc45	ff 	. 
	rst 38h			;bc46	ff 	. 
	rst 38h			;bc47	ff 	. 
	rst 38h			;bc48	ff 	. 
	rst 38h			;bc49	ff 	. 
	rst 38h			;bc4a	ff 	. 
	rst 38h			;bc4b	ff 	. 
	rst 38h			;bc4c	ff 	. 
	rst 38h			;bc4d	ff 	. 
	rst 38h			;bc4e	ff 	. 
	rst 38h			;bc4f	ff 	. 
	rst 38h			;bc50	ff 	. 
	rst 38h			;bc51	ff 	. 
	rst 38h			;bc52	ff 	. 
	rst 38h			;bc53	ff 	. 
	rst 38h			;bc54	ff 	. 
	rst 38h			;bc55	ff 	. 
	rst 38h			;bc56	ff 	. 
	rst 38h			;bc57	ff 	. 
	rst 38h			;bc58	ff 	. 
	rst 38h			;bc59	ff 	. 
	rst 38h			;bc5a	ff 	. 
	rst 38h			;bc5b	ff 	. 
	rst 38h			;bc5c	ff 	. 
	rst 38h			;bc5d	ff 	. 
	rst 38h			;bc5e	ff 	. 
	rst 38h			;bc5f	ff 	. 
	rst 38h			;bc60	ff 	. 
	rst 38h			;bc61	ff 	. 
	rst 38h			;bc62	ff 	. 
	rst 38h			;bc63	ff 	. 
	rst 38h			;bc64	ff 	. 
	rst 38h			;bc65	ff 	. 
	rst 38h			;bc66	ff 	. 
	rst 38h			;bc67	ff 	. 
	rst 38h			;bc68	ff 	. 
	rst 38h			;bc69	ff 	. 
	rst 38h			;bc6a	ff 	. 
	rst 38h			;bc6b	ff 	. 
	rst 38h			;bc6c	ff 	. 
	rst 38h			;bc6d	ff 	. 
	rst 38h			;bc6e	ff 	. 
	rst 38h			;bc6f	ff 	. 
	rst 38h			;bc70	ff 	. 
	rst 38h			;bc71	ff 	. 
	rst 38h			;bc72	ff 	. 
	rst 38h			;bc73	ff 	. 
	rst 38h			;bc74	ff 	. 
	rst 38h			;bc75	ff 	. 
	rst 38h			;bc76	ff 	. 
	rst 38h			;bc77	ff 	. 
	rst 38h			;bc78	ff 	. 
	rst 38h			;bc79	ff 	. 
	rst 38h			;bc7a	ff 	. 
	rst 38h			;bc7b	ff 	. 
	rst 38h			;bc7c	ff 	. 
	rst 38h			;bc7d	ff 	. 
	rst 38h			;bc7e	ff 	. 
	rst 38h			;bc7f	ff 	. 
	rst 38h			;bc80	ff 	. 
	rst 38h			;bc81	ff 	. 
	rst 38h			;bc82	ff 	. 
	rst 38h			;bc83	ff 	. 
	rst 38h			;bc84	ff 	. 
	rst 38h			;bc85	ff 	. 
	rst 38h			;bc86	ff 	. 
	rst 38h			;bc87	ff 	. 
	rst 38h			;bc88	ff 	. 
	rst 38h			;bc89	ff 	. 
	rst 38h			;bc8a	ff 	. 
	rst 38h			;bc8b	ff 	. 
	rst 38h			;bc8c	ff 	. 
	rst 38h			;bc8d	ff 	. 
	rst 38h			;bc8e	ff 	. 
	rst 38h			;bc8f	ff 	. 
	rst 38h			;bc90	ff 	. 
	rst 38h			;bc91	ff 	. 
	rst 38h			;bc92	ff 	. 
	rst 38h			;bc93	ff 	. 
	rst 38h			;bc94	ff 	. 
	rst 38h			;bc95	ff 	. 
	rst 38h			;bc96	ff 	. 
	rst 38h			;bc97	ff 	. 
	rst 38h			;bc98	ff 	. 
	rst 38h			;bc99	ff 	. 
	rst 38h			;bc9a	ff 	. 
	rst 38h			;bc9b	ff 	. 
	rst 38h			;bc9c	ff 	. 
	rst 38h			;bc9d	ff 	. 
	rst 38h			;bc9e	ff 	. 
	rst 38h			;bc9f	ff 	. 
	rst 38h			;bca0	ff 	. 
	rst 38h			;bca1	ff 	. 
	rst 38h			;bca2	ff 	. 
	rst 38h			;bca3	ff 	. 
	rst 38h			;bca4	ff 	. 
	rst 38h			;bca5	ff 	. 
	rst 38h			;bca6	ff 	. 
	rst 38h			;bca7	ff 	. 
	rst 38h			;bca8	ff 	. 
	rst 38h			;bca9	ff 	. 
	rst 38h			;bcaa	ff 	. 
	rst 38h			;bcab	ff 	. 
	rst 38h			;bcac	ff 	. 
	rst 38h			;bcad	ff 	. 
	rst 38h			;bcae	ff 	. 
	rst 38h			;bcaf	ff 	. 
	rst 38h			;bcb0	ff 	. 
	rst 38h			;bcb1	ff 	. 
	rst 38h			;bcb2	ff 	. 
	rst 38h			;bcb3	ff 	. 
	rst 38h			;bcb4	ff 	. 
	rst 38h			;bcb5	ff 	. 
	rst 38h			;bcb6	ff 	. 
	rst 38h			;bcb7	ff 	. 
	rst 38h			;bcb8	ff 	. 
	rst 38h			;bcb9	ff 	. 
	rst 38h			;bcba	ff 	. 
	rst 38h			;bcbb	ff 	. 
	rst 38h			;bcbc	ff 	. 
	rst 38h			;bcbd	ff 	. 
	rst 38h			;bcbe	ff 	. 
	rst 38h			;bcbf	ff 	. 
	rst 38h			;bcc0	ff 	. 
	rst 38h			;bcc1	ff 	. 
	rst 38h			;bcc2	ff 	. 
	rst 38h			;bcc3	ff 	. 
	rst 38h			;bcc4	ff 	. 
	rst 38h			;bcc5	ff 	. 
	rst 38h			;bcc6	ff 	. 
	rst 38h			;bcc7	ff 	. 
	rst 38h			;bcc8	ff 	. 
	rst 38h			;bcc9	ff 	. 
	rst 38h			;bcca	ff 	. 
	rst 38h			;bccb	ff 	. 
	rst 38h			;bccc	ff 	. 
	rst 38h			;bccd	ff 	. 
	rst 38h			;bcce	ff 	. 
	rst 38h			;bccf	ff 	. 
	rst 38h			;bcd0	ff 	. 
	rst 38h			;bcd1	ff 	. 
	rst 38h			;bcd2	ff 	. 
	rst 38h			;bcd3	ff 	. 
	rst 38h			;bcd4	ff 	. 
	rst 38h			;bcd5	ff 	. 
	rst 38h			;bcd6	ff 	. 
	rst 38h			;bcd7	ff 	. 
	rst 38h			;bcd8	ff 	. 
	rst 38h			;bcd9	ff 	. 
	rst 38h			;bcda	ff 	. 
	rst 38h			;bcdb	ff 	. 
	rst 38h			;bcdc	ff 	. 
	rst 38h			;bcdd	ff 	. 
	rst 38h			;bcde	ff 	. 
	rst 38h			;bcdf	ff 	. 
	rst 38h			;bce0	ff 	. 
	rst 38h			;bce1	ff 	. 
	rst 38h			;bce2	ff 	. 
	rst 38h			;bce3	ff 	. 
	rst 38h			;bce4	ff 	. 
	rst 38h			;bce5	ff 	. 
	rst 38h			;bce6	ff 	. 
	rst 38h			;bce7	ff 	. 
	rst 38h			;bce8	ff 	. 
	rst 38h			;bce9	ff 	. 
	rst 38h			;bcea	ff 	. 
	rst 38h			;bceb	ff 	. 
	rst 38h			;bcec	ff 	. 
	rst 38h			;bced	ff 	. 
	rst 38h			;bcee	ff 	. 
	rst 38h			;bcef	ff 	. 
	rst 38h			;bcf0	ff 	. 
	rst 38h			;bcf1	ff 	. 
	rst 38h			;bcf2	ff 	. 
	rst 38h			;bcf3	ff 	. 
	rst 38h			;bcf4	ff 	. 
	rst 38h			;bcf5	ff 	. 
	rst 38h			;bcf6	ff 	. 
	rst 38h			;bcf7	ff 	. 
	rst 38h			;bcf8	ff 	. 
	rst 38h			;bcf9	ff 	. 
	rst 38h			;bcfa	ff 	. 
	rst 38h			;bcfb	ff 	. 
	rst 38h			;bcfc	ff 	. 
	rst 38h			;bcfd	ff 	. 
	rst 38h			;bcfe	ff 	. 
	rst 38h			;bcff	ff 	. 
	rst 38h			;bd00	ff 	. 
	rst 38h			;bd01	ff 	. 
	rst 38h			;bd02	ff 	. 
	rst 38h			;bd03	ff 	. 
	rst 38h			;bd04	ff 	. 
	rst 38h			;bd05	ff 	. 
	rst 38h			;bd06	ff 	. 
	rst 38h			;bd07	ff 	. 
	rst 38h			;bd08	ff 	. 
	rst 38h			;bd09	ff 	. 
	rst 38h			;bd0a	ff 	. 
	rst 38h			;bd0b	ff 	. 
	rst 38h			;bd0c	ff 	. 
	rst 38h			;bd0d	ff 	. 
	rst 38h			;bd0e	ff 	. 
	rst 38h			;bd0f	ff 	. 
	rst 38h			;bd10	ff 	. 
	rst 38h			;bd11	ff 	. 
	rst 38h			;bd12	ff 	. 
	rst 38h			;bd13	ff 	. 
	rst 38h			;bd14	ff 	. 
	rst 38h			;bd15	ff 	. 
	rst 38h			;bd16	ff 	. 
	rst 38h			;bd17	ff 	. 
	rst 38h			;bd18	ff 	. 
	rst 38h			;bd19	ff 	. 
	rst 38h			;bd1a	ff 	. 
	rst 38h			;bd1b	ff 	. 
	rst 38h			;bd1c	ff 	. 
	rst 38h			;bd1d	ff 	. 
	rst 38h			;bd1e	ff 	. 
	rst 38h			;bd1f	ff 	. 
	rst 38h			;bd20	ff 	. 
	rst 38h			;bd21	ff 	. 
	rst 38h			;bd22	ff 	. 
	rst 38h			;bd23	ff 	. 
	rst 38h			;bd24	ff 	. 
	rst 38h			;bd25	ff 	. 
	rst 38h			;bd26	ff 	. 
	rst 38h			;bd27	ff 	. 
	rst 38h			;bd28	ff 	. 
	rst 38h			;bd29	ff 	. 
	rst 38h			;bd2a	ff 	. 
	rst 38h			;bd2b	ff 	. 
	rst 38h			;bd2c	ff 	. 
	rst 38h			;bd2d	ff 	. 
	rst 38h			;bd2e	ff 	. 
	rst 38h			;bd2f	ff 	. 
	rst 38h			;bd30	ff 	. 
	rst 38h			;bd31	ff 	. 
	rst 38h			;bd32	ff 	. 
	rst 38h			;bd33	ff 	. 
	rst 38h			;bd34	ff 	. 
	rst 38h			;bd35	ff 	. 
	rst 38h			;bd36	ff 	. 
	rst 38h			;bd37	ff 	. 
	rst 38h			;bd38	ff 	. 
	rst 38h			;bd39	ff 	. 
	rst 38h			;bd3a	ff 	. 
	rst 38h			;bd3b	ff 	. 
	rst 38h			;bd3c	ff 	. 
	rst 38h			;bd3d	ff 	. 
	rst 38h			;bd3e	ff 	. 
	rst 38h			;bd3f	ff 	. 
	rst 38h			;bd40	ff 	. 
	rst 38h			;bd41	ff 	. 
	rst 38h			;bd42	ff 	. 
	rst 38h			;bd43	ff 	. 
	rst 38h			;bd44	ff 	. 
	rst 38h			;bd45	ff 	. 
	rst 38h			;bd46	ff 	. 
	rst 38h			;bd47	ff 	. 
	rst 38h			;bd48	ff 	. 
	rst 38h			;bd49	ff 	. 
	rst 38h			;bd4a	ff 	. 
	rst 38h			;bd4b	ff 	. 
	rst 38h			;bd4c	ff 	. 
	rst 38h			;bd4d	ff 	. 
	rst 38h			;bd4e	ff 	. 
	rst 38h			;bd4f	ff 	. 
	rst 38h			;bd50	ff 	. 
	rst 38h			;bd51	ff 	. 
	rst 38h			;bd52	ff 	. 
	rst 38h			;bd53	ff 	. 
	rst 38h			;bd54	ff 	. 
	rst 38h			;bd55	ff 	. 
	rst 38h			;bd56	ff 	. 
	rst 38h			;bd57	ff 	. 
	rst 38h			;bd58	ff 	. 
	rst 38h			;bd59	ff 	. 
	rst 38h			;bd5a	ff 	. 
	rst 38h			;bd5b	ff 	. 
	rst 38h			;bd5c	ff 	. 
	rst 38h			;bd5d	ff 	. 
	rst 38h			;bd5e	ff 	. 
	rst 38h			;bd5f	ff 	. 
	rst 38h			;bd60	ff 	. 
	rst 38h			;bd61	ff 	. 
	rst 38h			;bd62	ff 	. 
	rst 38h			;bd63	ff 	. 
	rst 38h			;bd64	ff 	. 
	rst 38h			;bd65	ff 	. 
	rst 38h			;bd66	ff 	. 
	rst 38h			;bd67	ff 	. 
	rst 38h			;bd68	ff 	. 
	rst 38h			;bd69	ff 	. 
	rst 38h			;bd6a	ff 	. 
	rst 38h			;bd6b	ff 	. 
	rst 38h			;bd6c	ff 	. 
	rst 38h			;bd6d	ff 	. 
	rst 38h			;bd6e	ff 	. 
	rst 38h			;bd6f	ff 	. 
	rst 38h			;bd70	ff 	. 
	rst 38h			;bd71	ff 	. 
	rst 38h			;bd72	ff 	. 
	rst 38h			;bd73	ff 	. 
	rst 38h			;bd74	ff 	. 
	rst 38h			;bd75	ff 	. 
	rst 38h			;bd76	ff 	. 
	rst 38h			;bd77	ff 	. 
	rst 38h			;bd78	ff 	. 
	rst 38h			;bd79	ff 	. 
	rst 38h			;bd7a	ff 	. 
	rst 38h			;bd7b	ff 	. 
	rst 38h			;bd7c	ff 	. 
	rst 38h			;bd7d	ff 	. 
	rst 38h			;bd7e	ff 	. 
	rst 38h			;bd7f	ff 	. 
	rst 38h			;bd80	ff 	. 
	rst 38h			;bd81	ff 	. 
	rst 38h			;bd82	ff 	. 
	rst 38h			;bd83	ff 	. 
	rst 38h			;bd84	ff 	. 
	rst 38h			;bd85	ff 	. 
	rst 38h			;bd86	ff 	. 
	rst 38h			;bd87	ff 	. 
	rst 38h			;bd88	ff 	. 
	rst 38h			;bd89	ff 	. 
	rst 38h			;bd8a	ff 	. 
	rst 38h			;bd8b	ff 	. 
	rst 38h			;bd8c	ff 	. 
	rst 38h			;bd8d	ff 	. 
	rst 38h			;bd8e	ff 	. 
	rst 38h			;bd8f	ff 	. 
	rst 38h			;bd90	ff 	. 
	rst 38h			;bd91	ff 	. 
	rst 38h			;bd92	ff 	. 
	rst 38h			;bd93	ff 	. 
	rst 38h			;bd94	ff 	. 
	rst 38h			;bd95	ff 	. 
	rst 38h			;bd96	ff 	. 
	rst 38h			;bd97	ff 	. 
	rst 38h			;bd98	ff 	. 
	rst 38h			;bd99	ff 	. 
	rst 38h			;bd9a	ff 	. 
	rst 38h			;bd9b	ff 	. 
	rst 38h			;bd9c	ff 	. 
	rst 38h			;bd9d	ff 	. 
	rst 38h			;bd9e	ff 	. 
	rst 38h			;bd9f	ff 	. 
	rst 38h			;bda0	ff 	. 
	rst 38h			;bda1	ff 	. 
	rst 38h			;bda2	ff 	. 
	rst 38h			;bda3	ff 	. 
	rst 38h			;bda4	ff 	. 
	rst 38h			;bda5	ff 	. 
	rst 38h			;bda6	ff 	. 
	rst 38h			;bda7	ff 	. 
	rst 38h			;bda8	ff 	. 
	rst 38h			;bda9	ff 	. 
	rst 38h			;bdaa	ff 	. 
	rst 38h			;bdab	ff 	. 
	rst 38h			;bdac	ff 	. 
	rst 38h			;bdad	ff 	. 
	rst 38h			;bdae	ff 	. 
	rst 38h			;bdaf	ff 	. 
	rst 38h			;bdb0	ff 	. 
	rst 38h			;bdb1	ff 	. 
	rst 38h			;bdb2	ff 	. 
	rst 38h			;bdb3	ff 	. 
	rst 38h			;bdb4	ff 	. 
	rst 38h			;bdb5	ff 	. 
	rst 38h			;bdb6	ff 	. 
	rst 38h			;bdb7	ff 	. 
	rst 38h			;bdb8	ff 	. 
	rst 38h			;bdb9	ff 	. 
	rst 38h			;bdba	ff 	. 
	rst 38h			;bdbb	ff 	. 
	rst 38h			;bdbc	ff 	. 
	rst 38h			;bdbd	ff 	. 
	rst 38h			;bdbe	ff 	. 
	rst 38h			;bdbf	ff 	. 
	rst 38h			;bdc0	ff 	. 
	rst 38h			;bdc1	ff 	. 
	rst 38h			;bdc2	ff 	. 
	rst 38h			;bdc3	ff 	. 
	rst 38h			;bdc4	ff 	. 
	rst 38h			;bdc5	ff 	. 
	rst 38h			;bdc6	ff 	. 
	rst 38h			;bdc7	ff 	. 
	rst 38h			;bdc8	ff 	. 
	rst 38h			;bdc9	ff 	. 
	rst 38h			;bdca	ff 	. 
	rst 38h			;bdcb	ff 	. 
	rst 38h			;bdcc	ff 	. 
	rst 38h			;bdcd	ff 	. 
	rst 38h			;bdce	ff 	. 
	rst 38h			;bdcf	ff 	. 
	rst 38h			;bdd0	ff 	. 
	rst 38h			;bdd1	ff 	. 
	rst 38h			;bdd2	ff 	. 
	rst 38h			;bdd3	ff 	. 
	rst 38h			;bdd4	ff 	. 
	rst 38h			;bdd5	ff 	. 
	rst 38h			;bdd6	ff 	. 
	rst 38h			;bdd7	ff 	. 
	rst 38h			;bdd8	ff 	. 
	rst 38h			;bdd9	ff 	. 
	rst 38h			;bdda	ff 	. 
	rst 38h			;bddb	ff 	. 
	rst 38h			;bddc	ff 	. 
	rst 38h			;bddd	ff 	. 
	rst 38h			;bdde	ff 	. 
	rst 38h			;bddf	ff 	. 
	rst 38h			;bde0	ff 	. 
	rst 38h			;bde1	ff 	. 
	rst 38h			;bde2	ff 	. 
	rst 38h			;bde3	ff 	. 
	rst 38h			;bde4	ff 	. 
	rst 38h			;bde5	ff 	. 
	rst 38h			;bde6	ff 	. 
	rst 38h			;bde7	ff 	. 
	rst 38h			;bde8	ff 	. 
	rst 38h			;bde9	ff 	. 
	rst 38h			;bdea	ff 	. 
	rst 38h			;bdeb	ff 	. 
	rst 38h			;bdec	ff 	. 
	rst 38h			;bded	ff 	. 
	rst 38h			;bdee	ff 	. 
	rst 38h			;bdef	ff 	. 
	rst 38h			;bdf0	ff 	. 
	rst 38h			;bdf1	ff 	. 
	rst 38h			;bdf2	ff 	. 
	rst 38h			;bdf3	ff 	. 
	rst 38h			;bdf4	ff 	. 
	rst 38h			;bdf5	ff 	. 
	rst 38h			;bdf6	ff 	. 
	rst 38h			;bdf7	ff 	. 
	rst 38h			;bdf8	ff 	. 
	rst 38h			;bdf9	ff 	. 
	rst 38h			;bdfa	ff 	. 
	rst 38h			;bdfb	ff 	. 
	rst 38h			;bdfc	ff 	. 
	rst 38h			;bdfd	ff 	. 
	rst 38h			;bdfe	ff 	. 
	rst 38h			;bdff	ff 	. 
	rst 38h			;be00	ff 	. 
	rst 38h			;be01	ff 	. 
	rst 38h			;be02	ff 	. 
	rst 38h			;be03	ff 	. 
	rst 38h			;be04	ff 	. 
	rst 38h			;be05	ff 	. 
	rst 38h			;be06	ff 	. 
	rst 38h			;be07	ff 	. 
	rst 38h			;be08	ff 	. 
	rst 38h			;be09	ff 	. 
	rst 38h			;be0a	ff 	. 
	rst 38h			;be0b	ff 	. 
	rst 38h			;be0c	ff 	. 
	rst 38h			;be0d	ff 	. 
	rst 38h			;be0e	ff 	. 
	rst 38h			;be0f	ff 	. 
	rst 38h			;be10	ff 	. 
	rst 38h			;be11	ff 	. 
	rst 38h			;be12	ff 	. 
	rst 38h			;be13	ff 	. 
	rst 38h			;be14	ff 	. 
	rst 38h			;be15	ff 	. 
	rst 38h			;be16	ff 	. 
	rst 38h			;be17	ff 	. 
	rst 38h			;be18	ff 	. 
	rst 38h			;be19	ff 	. 
	rst 38h			;be1a	ff 	. 
	rst 38h			;be1b	ff 	. 
	rst 38h			;be1c	ff 	. 
	rst 38h			;be1d	ff 	. 
	rst 38h			;be1e	ff 	. 
	rst 38h			;be1f	ff 	. 
	rst 38h			;be20	ff 	. 
	rst 38h			;be21	ff 	. 
	rst 38h			;be22	ff 	. 
	rst 38h			;be23	ff 	. 
	rst 38h			;be24	ff 	. 
	rst 38h			;be25	ff 	. 
	rst 38h			;be26	ff 	. 
	rst 38h			;be27	ff 	. 
	rst 38h			;be28	ff 	. 
	rst 38h			;be29	ff 	. 
	rst 38h			;be2a	ff 	. 
	rst 38h			;be2b	ff 	. 
	rst 38h			;be2c	ff 	. 
	rst 38h			;be2d	ff 	. 
	rst 38h			;be2e	ff 	. 
	rst 38h			;be2f	ff 	. 
	rst 38h			;be30	ff 	. 
	rst 38h			;be31	ff 	. 
	rst 38h			;be32	ff 	. 
	rst 38h			;be33	ff 	. 
	rst 38h			;be34	ff 	. 
	rst 38h			;be35	ff 	. 
	rst 38h			;be36	ff 	. 
	rst 38h			;be37	ff 	. 
	rst 38h			;be38	ff 	. 
	rst 38h			;be39	ff 	. 
	rst 38h			;be3a	ff 	. 
	rst 38h			;be3b	ff 	. 
	rst 38h			;be3c	ff 	. 
	rst 38h			;be3d	ff 	. 
	rst 38h			;be3e	ff 	. 
	rst 38h			;be3f	ff 	. 
	rst 38h			;be40	ff 	. 
	rst 38h			;be41	ff 	. 
	rst 38h			;be42	ff 	. 
	rst 38h			;be43	ff 	. 
	rst 38h			;be44	ff 	. 
	rst 38h			;be45	ff 	. 
	rst 38h			;be46	ff 	. 
	rst 38h			;be47	ff 	. 
	rst 38h			;be48	ff 	. 
	rst 38h			;be49	ff 	. 
	rst 38h			;be4a	ff 	. 
	rst 38h			;be4b	ff 	. 
	rst 38h			;be4c	ff 	. 
	rst 38h			;be4d	ff 	. 
	rst 38h			;be4e	ff 	. 
	rst 38h			;be4f	ff 	. 
	rst 38h			;be50	ff 	. 
	rst 38h			;be51	ff 	. 
	rst 38h			;be52	ff 	. 
	rst 38h			;be53	ff 	. 
	rst 38h			;be54	ff 	. 
	rst 38h			;be55	ff 	. 
	rst 38h			;be56	ff 	. 
	rst 38h			;be57	ff 	. 
	rst 38h			;be58	ff 	. 
	rst 38h			;be59	ff 	. 
	rst 38h			;be5a	ff 	. 
	rst 38h			;be5b	ff 	. 
	rst 38h			;be5c	ff 	. 
	rst 38h			;be5d	ff 	. 
	rst 38h			;be5e	ff 	. 
	rst 38h			;be5f	ff 	. 
	rst 38h			;be60	ff 	. 
	rst 38h			;be61	ff 	. 
	rst 38h			;be62	ff 	. 
	rst 38h			;be63	ff 	. 
	rst 38h			;be64	ff 	. 
	rst 38h			;be65	ff 	. 
	rst 38h			;be66	ff 	. 
	rst 38h			;be67	ff 	. 
	rst 38h			;be68	ff 	. 
	rst 38h			;be69	ff 	. 
	rst 38h			;be6a	ff 	. 
	rst 38h			;be6b	ff 	. 
	rst 38h			;be6c	ff 	. 
	rst 38h			;be6d	ff 	. 
	rst 38h			;be6e	ff 	. 
	rst 38h			;be6f	ff 	. 
	rst 38h			;be70	ff 	. 
	rst 38h			;be71	ff 	. 
	rst 38h			;be72	ff 	. 
	rst 38h			;be73	ff 	. 
	rst 38h			;be74	ff 	. 
	rst 38h			;be75	ff 	. 
	rst 38h			;be76	ff 	. 
	rst 38h			;be77	ff 	. 
	rst 38h			;be78	ff 	. 
	rst 38h			;be79	ff 	. 
	rst 38h			;be7a	ff 	. 
	rst 38h			;be7b	ff 	. 
	rst 38h			;be7c	ff 	. 
	rst 38h			;be7d	ff 	. 
	rst 38h			;be7e	ff 	. 
	rst 38h			;be7f	ff 	. 
	rst 38h			;be80	ff 	. 
	rst 38h			;be81	ff 	. 
	rst 38h			;be82	ff 	. 
	rst 38h			;be83	ff 	. 
	rst 38h			;be84	ff 	. 
	rst 38h			;be85	ff 	. 
	rst 38h			;be86	ff 	. 
	rst 38h			;be87	ff 	. 
	rst 38h			;be88	ff 	. 
	rst 38h			;be89	ff 	. 
	rst 38h			;be8a	ff 	. 
	rst 38h			;be8b	ff 	. 
	rst 38h			;be8c	ff 	. 
	rst 38h			;be8d	ff 	. 
	rst 38h			;be8e	ff 	. 
	rst 38h			;be8f	ff 	. 
	rst 38h			;be90	ff 	. 
	rst 38h			;be91	ff 	. 
	rst 38h			;be92	ff 	. 
	rst 38h			;be93	ff 	. 
	rst 38h			;be94	ff 	. 
	rst 38h			;be95	ff 	. 
	rst 38h			;be96	ff 	. 
	rst 38h			;be97	ff 	. 
	rst 38h			;be98	ff 	. 
	rst 38h			;be99	ff 	. 
	rst 38h			;be9a	ff 	. 
	rst 38h			;be9b	ff 	. 
	rst 38h			;be9c	ff 	. 
	rst 38h			;be9d	ff 	. 
	rst 38h			;be9e	ff 	. 
	rst 38h			;be9f	ff 	. 
	rst 38h			;bea0	ff 	. 
	rst 38h			;bea1	ff 	. 
	rst 38h			;bea2	ff 	. 
	rst 38h			;bea3	ff 	. 
	rst 38h			;bea4	ff 	. 
	rst 38h			;bea5	ff 	. 
	rst 38h			;bea6	ff 	. 
	rst 38h			;bea7	ff 	. 
	rst 38h			;bea8	ff 	. 
	rst 38h			;bea9	ff 	. 
	rst 38h			;beaa	ff 	. 
	rst 38h			;beab	ff 	. 
	rst 38h			;beac	ff 	. 
	rst 38h			;bead	ff 	. 
	rst 38h			;beae	ff 	. 
	rst 38h			;beaf	ff 	. 
	rst 38h			;beb0	ff 	. 
	rst 38h			;beb1	ff 	. 
	rst 38h			;beb2	ff 	. 
	rst 38h			;beb3	ff 	. 
	rst 38h			;beb4	ff 	. 
	rst 38h			;beb5	ff 	. 
	rst 38h			;beb6	ff 	. 
	rst 38h			;beb7	ff 	. 
	rst 38h			;beb8	ff 	. 
	rst 38h			;beb9	ff 	. 
	rst 38h			;beba	ff 	. 
	rst 38h			;bebb	ff 	. 
	rst 38h			;bebc	ff 	. 
	rst 38h			;bebd	ff 	. 
	rst 38h			;bebe	ff 	. 
	rst 38h			;bebf	ff 	. 
	rst 38h			;bec0	ff 	. 
	rst 38h			;bec1	ff 	. 
	rst 38h			;bec2	ff 	. 
	rst 38h			;bec3	ff 	. 
	rst 38h			;bec4	ff 	. 
	rst 38h			;bec5	ff 	. 
	rst 38h			;bec6	ff 	. 
	rst 38h			;bec7	ff 	. 
	rst 38h			;bec8	ff 	. 
	rst 38h			;bec9	ff 	. 
	rst 38h			;beca	ff 	. 
	rst 38h			;becb	ff 	. 
	rst 38h			;becc	ff 	. 
	rst 38h			;becd	ff 	. 
	rst 38h			;bece	ff 	. 
	rst 38h			;becf	ff 	. 
	rst 38h			;bed0	ff 	. 
	rst 38h			;bed1	ff 	. 
	rst 38h			;bed2	ff 	. 
	rst 38h			;bed3	ff 	. 
	rst 38h			;bed4	ff 	. 
	rst 38h			;bed5	ff 	. 
	rst 38h			;bed6	ff 	. 
	rst 38h			;bed7	ff 	. 
	rst 38h			;bed8	ff 	. 
	rst 38h			;bed9	ff 	. 
	rst 38h			;beda	ff 	. 
	rst 38h			;bedb	ff 	. 
	rst 38h			;bedc	ff 	. 
	rst 38h			;bedd	ff 	. 
	rst 38h			;bede	ff 	. 
	rst 38h			;bedf	ff 	. 
	rst 38h			;bee0	ff 	. 
	rst 38h			;bee1	ff 	. 
	rst 38h			;bee2	ff 	. 
	rst 38h			;bee3	ff 	. 
	rst 38h			;bee4	ff 	. 
	rst 38h			;bee5	ff 	. 
	rst 38h			;bee6	ff 	. 
	rst 38h			;bee7	ff 	. 
	rst 38h			;bee8	ff 	. 
	rst 38h			;bee9	ff 	. 
	rst 38h			;beea	ff 	. 
	rst 38h			;beeb	ff 	. 
	rst 38h			;beec	ff 	. 
	rst 38h			;beed	ff 	. 
	rst 38h			;beee	ff 	. 
	rst 38h			;beef	ff 	. 
	rst 38h			;bef0	ff 	. 
	rst 38h			;bef1	ff 	. 
	rst 38h			;bef2	ff 	. 
	rst 38h			;bef3	ff 	. 
	rst 38h			;bef4	ff 	. 
	rst 38h			;bef5	ff 	. 
	rst 38h			;bef6	ff 	. 
	rst 38h			;bef7	ff 	. 
	rst 38h			;bef8	ff 	. 
	rst 38h			;bef9	ff 	. 
	rst 38h			;befa	ff 	. 
	rst 38h			;befb	ff 	. 
	rst 38h			;befc	ff 	. 
	rst 38h			;befd	ff 	. 
	rst 38h			;befe	ff 	. 
	rst 38h			;beff	ff 	. 
	rst 38h			;bf00	ff 	. 
	rst 38h			;bf01	ff 	. 
	rst 38h			;bf02	ff 	. 
	rst 38h			;bf03	ff 	. 
	rst 38h			;bf04	ff 	. 
	rst 38h			;bf05	ff 	. 
	rst 38h			;bf06	ff 	. 
	rst 38h			;bf07	ff 	. 
	rst 38h			;bf08	ff 	. 
	rst 38h			;bf09	ff 	. 
	rst 38h			;bf0a	ff 	. 
	rst 38h			;bf0b	ff 	. 
	rst 38h			;bf0c	ff 	. 
	rst 38h			;bf0d	ff 	. 
	rst 38h			;bf0e	ff 	. 
	rst 38h			;bf0f	ff 	. 
	rst 38h			;bf10	ff 	. 
	rst 38h			;bf11	ff 	. 
	rst 38h			;bf12	ff 	. 
	rst 38h			;bf13	ff 	. 
	rst 38h			;bf14	ff 	. 
	rst 38h			;bf15	ff 	. 
	rst 38h			;bf16	ff 	. 
	rst 38h			;bf17	ff 	. 
	rst 38h			;bf18	ff 	. 
	rst 38h			;bf19	ff 	. 
	rst 38h			;bf1a	ff 	. 
	rst 38h			;bf1b	ff 	. 
	rst 38h			;bf1c	ff 	. 
	rst 38h			;bf1d	ff 	. 
	rst 38h			;bf1e	ff 	. 
	rst 38h			;bf1f	ff 	. 
	rst 38h			;bf20	ff 	. 
	rst 38h			;bf21	ff 	. 
	rst 38h			;bf22	ff 	. 
	rst 38h			;bf23	ff 	. 
	rst 38h			;bf24	ff 	. 
	rst 38h			;bf25	ff 	. 
	rst 38h			;bf26	ff 	. 
	rst 38h			;bf27	ff 	. 
	rst 38h			;bf28	ff 	. 
	rst 38h			;bf29	ff 	. 
	rst 38h			;bf2a	ff 	. 
	rst 38h			;bf2b	ff 	. 
	rst 38h			;bf2c	ff 	. 
	rst 38h			;bf2d	ff 	. 
	rst 38h			;bf2e	ff 	. 
	rst 38h			;bf2f	ff 	. 
	rst 38h			;bf30	ff 	. 
	rst 38h			;bf31	ff 	. 
	rst 38h			;bf32	ff 	. 
	rst 38h			;bf33	ff 	. 
	rst 38h			;bf34	ff 	. 
	rst 38h			;bf35	ff 	. 
	rst 38h			;bf36	ff 	. 
	rst 38h			;bf37	ff 	. 
	rst 38h			;bf38	ff 	. 
	rst 38h			;bf39	ff 	. 
	rst 38h			;bf3a	ff 	. 
	rst 38h			;bf3b	ff 	. 
	rst 38h			;bf3c	ff 	. 
	rst 38h			;bf3d	ff 	. 
	rst 38h			;bf3e	ff 	. 
	rst 38h			;bf3f	ff 	. 
	rst 38h			;bf40	ff 	. 
	rst 38h			;bf41	ff 	. 
	rst 38h			;bf42	ff 	. 
	rst 38h			;bf43	ff 	. 
	rst 38h			;bf44	ff 	. 
	rst 38h			;bf45	ff 	. 
	rst 38h			;bf46	ff 	. 
	rst 38h			;bf47	ff 	. 
	rst 38h			;bf48	ff 	. 
	rst 38h			;bf49	ff 	. 
	rst 38h			;bf4a	ff 	. 
	rst 38h			;bf4b	ff 	. 
	rst 38h			;bf4c	ff 	. 
	rst 38h			;bf4d	ff 	. 
	rst 38h			;bf4e	ff 	. 
	rst 38h			;bf4f	ff 	. 
	rst 38h			;bf50	ff 	. 
	rst 38h			;bf51	ff 	. 
	rst 38h			;bf52	ff 	. 
	rst 38h			;bf53	ff 	. 
	rst 38h			;bf54	ff 	. 
	rst 38h			;bf55	ff 	. 
	rst 38h			;bf56	ff 	. 
	rst 38h			;bf57	ff 	. 
	rst 38h			;bf58	ff 	. 
	rst 38h			;bf59	ff 	. 
	rst 38h			;bf5a	ff 	. 
	rst 38h			;bf5b	ff 	. 
	rst 38h			;bf5c	ff 	. 
	rst 38h			;bf5d	ff 	. 
	rst 38h			;bf5e	ff 	. 
	rst 38h			;bf5f	ff 	. 
	rst 38h			;bf60	ff 	. 
	rst 38h			;bf61	ff 	. 
	rst 38h			;bf62	ff 	. 
	rst 38h			;bf63	ff 	. 
	rst 38h			;bf64	ff 	. 
	rst 38h			;bf65	ff 	. 
	rst 38h			;bf66	ff 	. 
	rst 38h			;bf67	ff 	. 
	rst 38h			;bf68	ff 	. 
	rst 38h			;bf69	ff 	. 
	rst 38h			;bf6a	ff 	. 
	rst 38h			;bf6b	ff 	. 
	rst 38h			;bf6c	ff 	. 
	rst 38h			;bf6d	ff 	. 
	rst 38h			;bf6e	ff 	. 
	rst 38h			;bf6f	ff 	. 
	rst 38h			;bf70	ff 	. 
	rst 38h			;bf71	ff 	. 
	rst 38h			;bf72	ff 	. 
	rst 38h			;bf73	ff 	. 
	rst 38h			;bf74	ff 	. 
	rst 38h			;bf75	ff 	. 
	rst 38h			;bf76	ff 	. 
	rst 38h			;bf77	ff 	. 
	rst 38h			;bf78	ff 	. 
	rst 38h			;bf79	ff 	. 
	rst 38h			;bf7a	ff 	. 
	rst 38h			;bf7b	ff 	. 
	rst 38h			;bf7c	ff 	. 
	rst 38h			;bf7d	ff 	. 
	rst 38h			;bf7e	ff 	. 
	rst 38h			;bf7f	ff 	. 
	rst 38h			;bf80	ff 	. 
	rst 38h			;bf81	ff 	. 
	rst 38h			;bf82	ff 	. 
	rst 38h			;bf83	ff 	. 
	rst 38h			;bf84	ff 	. 
	rst 38h			;bf85	ff 	. 
	rst 38h			;bf86	ff 	. 
	rst 38h			;bf87	ff 	. 
	rst 38h			;bf88	ff 	. 
	rst 38h			;bf89	ff 	. 
	rst 38h			;bf8a	ff 	. 
	rst 38h			;bf8b	ff 	. 
	rst 38h			;bf8c	ff 	. 
	rst 38h			;bf8d	ff 	. 
	rst 38h			;bf8e	ff 	. 
	rst 38h			;bf8f	ff 	. 
	rst 38h			;bf90	ff 	. 
	rst 38h			;bf91	ff 	. 
	rst 38h			;bf92	ff 	. 
	rst 38h			;bf93	ff 	. 
	rst 38h			;bf94	ff 	. 
	rst 38h			;bf95	ff 	. 
	rst 38h			;bf96	ff 	. 
	rst 38h			;bf97	ff 	. 
	rst 38h			;bf98	ff 	. 
	rst 38h			;bf99	ff 	. 
	rst 38h			;bf9a	ff 	. 
	rst 38h			;bf9b	ff 	. 
	rst 38h			;bf9c	ff 	. 
	rst 38h			;bf9d	ff 	. 
	rst 38h			;bf9e	ff 	. 
	rst 38h			;bf9f	ff 	. 
	rst 38h			;bfa0	ff 	. 
	rst 38h			;bfa1	ff 	. 
	rst 38h			;bfa2	ff 	. 
	rst 38h			;bfa3	ff 	. 
	rst 38h			;bfa4	ff 	. 
	rst 38h			;bfa5	ff 	. 
	rst 38h			;bfa6	ff 	. 
	rst 38h			;bfa7	ff 	. 
	rst 38h			;bfa8	ff 	. 
	rst 38h			;bfa9	ff 	. 
	rst 38h			;bfaa	ff 	. 
	rst 38h			;bfab	ff 	. 
	rst 38h			;bfac	ff 	. 
	rst 38h			;bfad	ff 	. 
	rst 38h			;bfae	ff 	. 
	rst 38h			;bfaf	ff 	. 
	rst 38h			;bfb0	ff 	. 
	rst 38h			;bfb1	ff 	. 
	rst 38h			;bfb2	ff 	. 
	rst 38h			;bfb3	ff 	. 
	rst 38h			;bfb4	ff 	. 
	rst 38h			;bfb5	ff 	. 
	rst 38h			;bfb6	ff 	. 
	rst 38h			;bfb7	ff 	. 
	rst 38h			;bfb8	ff 	. 
	rst 38h			;bfb9	ff 	. 
	rst 38h			;bfba	ff 	. 
	rst 38h			;bfbb	ff 	. 
	rst 38h			;bfbc	ff 	. 
	rst 38h			;bfbd	ff 	. 
	rst 38h			;bfbe	ff 	. 
	rst 38h			;bfbf	ff 	. 
	rst 38h			;bfc0	ff 	. 
	rst 38h			;bfc1	ff 	. 
	rst 38h			;bfc2	ff 	. 
	rst 38h			;bfc3	ff 	. 
	rst 38h			;bfc4	ff 	. 
	rst 38h			;bfc5	ff 	. 
	rst 38h			;bfc6	ff 	. 
	rst 38h			;bfc7	ff 	. 
	rst 38h			;bfc8	ff 	. 
	rst 38h			;bfc9	ff 	. 
	rst 38h			;bfca	ff 	. 
	rst 38h			;bfcb	ff 	. 
	rst 38h			;bfcc	ff 	. 
	rst 38h			;bfcd	ff 	. 
	rst 38h			;bfce	ff 	. 
	rst 38h			;bfcf	ff 	. 
	rst 38h			;bfd0	ff 	. 
	rst 38h			;bfd1	ff 	. 
	rst 38h			;bfd2	ff 	. 
	rst 38h			;bfd3	ff 	. 
	rst 38h			;bfd4	ff 	. 
	rst 38h			;bfd5	ff 	. 
	rst 38h			;bfd6	ff 	. 
	rst 38h			;bfd7	ff 	. 
	rst 38h			;bfd8	ff 	. 
	rst 38h			;bfd9	ff 	. 
	rst 38h			;bfda	ff 	. 
	rst 38h			;bfdb	ff 	. 
	rst 38h			;bfdc	ff 	. 
	rst 38h			;bfdd	ff 	. 
	rst 38h			;bfde	ff 	. 
	rst 38h			;bfdf	ff 	. 
	rst 38h			;bfe0	ff 	. 
	rst 38h			;bfe1	ff 	. 
	rst 38h			;bfe2	ff 	. 
	rst 38h			;bfe3	ff 	. 
	rst 38h			;bfe4	ff 	. 
	rst 38h			;bfe5	ff 	. 
	rst 38h			;bfe6	ff 	. 
	rst 38h			;bfe7	ff 	. 
	rst 38h			;bfe8	ff 	. 
	rst 38h			;bfe9	ff 	. 
	rst 38h			;bfea	ff 	. 
	rst 38h			;bfeb	ff 	. 
	rst 38h			;bfec	ff 	. 
	rst 38h			;bfed	ff 	. 
	rst 38h			;bfee	ff 	. 
	rst 38h			;bfef	ff 	. 
	rst 38h			;bff0	ff 	. 
	rst 38h			;bff1	ff 	. 
	rst 38h			;bff2	ff 	. 
	rst 38h			;bff3	ff 	. 
	rst 38h			;bff4	ff 	. 
	rst 38h			;bff5	ff 	. 
	rst 38h			;bff6	ff 	. 
	rst 38h			;bff7	ff 	. 
	rst 38h			;bff8	ff 	. 
	rst 38h			;bff9	ff 	. 
	rst 38h			;bffa	ff 	. 
	rst 38h			;bffb	ff 	. 
	rst 38h			;bffc	ff 	. 
	rst 38h			;bffd	ff 	. 
	rst 38h			;bffe	ff 	. 
lbfffh:
	rst 38h			;bfff	ff 	. 

	end
