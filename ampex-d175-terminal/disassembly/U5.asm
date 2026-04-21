; z80dasm 1.1.6
; command line: z80dasm -a -l -t -z -g 0x2000 -S U5.sym -o U5.asm ../EPROM_dumps/U5-TMS2764JL.bin

	org	02000h
ram_esc_byte:	equ 0xaa23
ram_esc_state:	equ 0xaa25
ram_mode_flags:	equ 0xaa29
ram_leadin_byte:	equ 0xaa99
ram_setup_flags_b9:	equ 0xaab9
ram_setup_emul_bb:	equ 0xaabb
ram_tab_flags:	equ 0xac18
ram_attr_subsel:	equ 0xac19

	ld h,c			;2000	61 	a 
	ld (hl),c			;2001	71 	q 
	nop			;2002	00 	. 
	ld sp,04371h		;2003	31 71 43 	1 q C 
	nop			;2006	00 	. 
	ld hl,01101h		;2007	21 01 11 	! . . 
	ld sp,00048h		;200a	31 48 00 	1 H . 
	ld a,(bc)			;200d	0a 	. 
	nop			;200e	00 	. 
	ld b,c			;200f	41 	A 
	ld d,c			;2010	51 	Q 
	ld h,e			;2011	63 	c 
	rrca			;2012	0f 	. 
	nop			;2013	00 	. 
tv950_xlate_base:
	inc b			;2014	04 	. 
	dec e			;2015	1d 	. 
	ld b,c			;2016	41 	A 
	ld b,b			;2017	40 	@ 
	ld a,(0593bh)		;2018	3a 3b 59 	: ; Y 
	ld a,b			;201b	78 	x 
	ld l,a			;201c	6f 	o 
	ld h,e			;201d	63 	c 
	ld l,l			;201e	6d 	m 
	add a,e			;201f	83 	. 
	adc a,b			;2020	88 	. 
	ld b,000h		;2021	06 00 	. . 
	ld h,h			;2023	64 	d 
	djnz 76		;2024	10 4a 	. J 
	ld (hl),d			;2026	72 	r 
	ld l,h			;2027	6c 	l 
	ld d,h			;2028	54 	T 
	ld d,e			;2029	53 	S 
	ccf			;202a	3f 	? 
	ld d,l			;202b	55 	U 
	adc a,c			;202c	89 	. 
	adc a,d			;202d	8a 	. 
	dec hl			;202e	2b 	+ 
	add a,e			;202f	83 	. 
	add a,a			;2030	87 	. 
	inc c			;2031	0c 	. 
	add a,(hl)			;2032	86 	. 
	halt			;2033	76 	v 
	ld c,(hl)			;2034	4e 	N 
	ld e,b			;2035	58 	X 
	ld d,(hl)			;2036	56 	V 
	ld d,a			;2037	57 	W 
	rra			;2038	1f 	. 
	ld (hl),a			;2039	77 	w 
	daa			;203a	27 	' 
	ld a,(de)			;203b	1a 	. 
	jr nc,l2080h		;203c	30 42 	0 B 
	adc a,e			;203e	8b 	. 
	ld c,c			;203f	49 	I 
	ld e,d			;2040	5a 	Z 
	jr -114		;2041	18 8c 	. . 
	adc a,l			;2043	8d 	. 
	inc sp			;2044	33 	3 
	ld d,b			;2045	50 	P 
	inc (hl)			;2046	34 	4 
	ld (hl),h			;2047	74 	t 
	ld (hl),038h		;2048	36 38 	6 8 
	nop			;204a	00 	. 
	ld d,c			;204b	51 	Q 
	add hl,sp			;204c	39 	9 
	scf			;204d	37 	7 
	ld hl,l2225h		;204e	21 25 22 	! % " 
	ld h,01bh		;2051	26 1b 	& . 
	inc e			;2053	1c 	. 
	dec (hl)			;2054	35 	5 
	ld e,b			;2055	58 	X 
	adc a,(hl)			;2056	8e 	. 
	nop			;2057	00 	. 
	adc a,a			;2058	8f 	. 
	inc hl			;2059	23 	# 
	sub c			;205a	91 	. 
	sub d			;205b	92 	. 
	sub e			;205c	93 	. 
	ld c,a			;205d	4f 	O 
	ld l,(hl)			;205e	6e 	n 
	sub h			;205f	94 	. 
	sub l			;2060	95 	. 
	nop			;2061	00 	. 
	add a,h			;2062	84 	. 
	add a,l			;2063	85 	. 
	inc h			;2064	24 	$ 
	sub (hl)			;2065	96 	. 
	sub a			;2066	97 	. 
	ld (hl),l			;2067	75 	u 
	add a,c			;2068	81 	. 
	add hl,sp			;2069	39 	9 
	ld h,c			;206a	61 	a 
	ld h,d			;206b	62 	b 
	rlca			;206c	07 	. 
	add a,d			;206d	82 	. 
	sbc a,b			;206e	98 	. 
	ld bc,00211h		;206f	01 11 02 	. . . 
	nop			;2072	00 	. 
	nop			;2073	00 	. 
	ld a,b			;2074	78 	x 
	inc l			;2075	2c 	, 
	ld a,c			;2076	79 	y 
	inc l			;2077	2c 	, 
	ld e,c			;2078	59 	Y 
	cpl			;2079	2f 	/ 
	ld hl,(06146h)		;207a	2a 46 61 	* F a 
	cpl			;207d	2f 	/ 
	ld h,l			;207e	65 	e 
	cpl			;207f	2f 	/ 
l2080h:
	ld d,h			;2080	54 	T 
	cpl			;2081	2f 	/ 
	ld a,(hl)			;2082	7e 	~ 
	inc l			;2083	2c 	, 
	ld l,a			;2084	6f 	o 
	ld b,h			;2085	44 	D 
	xor a			;2086	af 	. 
	inc sp			;2087	33 	3 
	cp 026h		;2088	fe 26 	. & 
	ld c,b			;208a	48 	H 
	ld a,(de)			;208b	1a 	. 
	dec sp			;208c	3b 	; 
l208dh:
	ld a,(de)			;208d	1a 	. 
	defb 0cbh,034h	;sli h		;208e	cb 34 	. 4 
	adc a,b			;2090	88 	. 
	ld b,l			;2091	45 	E 
	or e			;2092	b3 	. 
	inc (hl)			;2093	34 	4 
	rrca			;2094	0f 	. 
	ld hl,(01ce2h)		;2095	2a e2 1c 	* . . 
	jp (hl)			;2098	e9 	. 
	inc e			;2099	1c 	. 
	or 01ah		;209a	f6 1a 	. . 
	ld a,b			;209c	78 	x 
	inc l			;209d	2c 	, 
	or b			;209e	b0 	. 
	ld b,h			;209f	44 	D 
	pop af			;20a0	f1 	. 
	inc e			;20a1	1c 	. 
	jp m,0031ch		;20a2	fa 1c 03 	. . . 
	dec e			;20a5	1d 	. 
	ld c,01dh		;20a6	0e 1d 	. . 
	call po,09819h		;20a8	e4 19 98 	. . . 
	daa			;20ab	27 	' 
	sbc a,b			;20ac	98 	. 
	daa			;20ad	27 	' 
	sbc a,b			;20ae	98 	. 
	daa			;20af	27 	' 
	ld d,b			;20b0	50 	P 
	ld (018b4h),hl		;20b1	22 b4 18 	" . . 
	sbc a,b			;20b4	98 	. 
	daa			;20b5	27 	' 
	ret pe			;20b6	e8 	. 
	inc (hl)			;20b7	34 	4 
	jp m,09818h		;20b8	fa 18 98 	. . . 
l20bbh:
	daa			;20bb	27 	' 
	sbc a,b			;20bc	98 	. 
	daa			;20bd	27 	' 
	sbc a,b			;20be	98 	. 
	daa			;20bf	27 	' 
l20c0h:
	rst 18h			;20c0	df 	. 
	ld (hl),023h		;20c1	36 23 	6 # 
	dec (hl)			;20c3	35 	5 
	sub d			;20c4	92 	. 
	inc (hl)			;20c5	34 	4 
l20c6h:
	sbc a,c			;20c6	99 	. 
	daa			;20c7	27 	' 
	add hl,de			;20c8	19 	. 
	dec (hl)			;20c9	35 	5 
	call c,0eb27h		;20ca	dc 27 eb 	. ' . 
	daa			;20cd	27 	' 
	sbc a,b			;20ce	98 	. 
	daa			;20cf	27 	' 
	sbc a,b			;20d0	98 	. 
	daa			;20d1	27 	' 
	sbc a,b			;20d2	98 	. 
	daa			;20d3	27 	' 
l20d4h:
	inc d			;20d4	14 	. 
	add hl,de			;20d5	19 	. 
	defb 0cbh,034h	;sli h		;20d6	cb 34 	. 4 
	or e			;20d8	b3 	. 
	inc (hl)			;20d9	34 	4 
	jr nz,l20f5h		;20da	20 19 	  . 
	inc l			;20dc	2c 	, 
	add hl,de			;20dd	19 	. 
	inc c			;20de	0c 	. 
	jr z,l2153h		;20df	28 72 	( r 
	add hl,de			;20e1	19 	. 
	ld b,b			;20e2	40 	@ 
	jr z,l2143h		;20e3	28 5e 	( ^ 
	jr z,l208dh		;20e5	28 a6 	( . 
	add hl,de			;20e7	19 	. 
	cp e			;20e8	bb 	. 
	jr z,-55		;20e9	28 c7 	( . 
	jr z,l20bbh		;20eb	28 ce 	( . 
	jr z,l20c6h		;20ed	28 d7 	( . 
	jr z,l20d4h		;20ef	28 e3 	( . 
	jr z,-22		;20f1	28 e8 	( . 
	jr z,l20c0h		;20f3	28 cb 	( . 
l20f5h:
	inc (hl)			;20f5	34 	4 
	or e			;20f6	b3 	. 
	inc (hl)			;20f7	34 	4 
	and a			;20f8	a7 	. 
	add hl,de			;20f9	19 	. 
	sbc a,b			;20fa	98 	. 
	daa			;20fb	27 	' 
	ld l,a			;20fc	6f 	o 
	ld b,h			;20fd	44 	D 
	adc a,b			;20fe	88 	. 
	ld b,l			;20ff	45 	E 
	ret pe			;2100	e8 	. 
	ld b,h			;2101	44 	D 
	or b			;2102	b0 	. 
	add hl,de			;2103	19 	. 
	or (hl)			;2104	b6 	. 
	add hl,de			;2105	19 	. 
	jp nz,0c719h		;2106	c2 19 c7 	. . . 
	add hl,de			;2109	19 	. 
	rr c		;210a	cb 19 	. . 
	adc a,046h		;210c	ce 46 	. F 
	add hl,sp			;210e	39 	9 
	ld hl,(019d4h)		;210f	2a d4 19 	* . . 
	call c,0e419h		;2112	dc 19 e4 	. . . 
	add hl,de			;2115	19 	. 
	push de			;2116	d5 	. 
	ld b,e			;2117	43 	C 
	ld b,l			;2118	45 	E 
	ld b,h			;2119	44 	D 
	ld a,(bc)			;211a	0a 	. 
	ld a,(de)			;211b	1a 	. 
	ld hl,0ed1ah		;211c	21 1a ed 	! . . 
	jr z,l2124h		;211f	28 03 	( . 
	add hl,hl			;2121	29 	) 
	ld h,l			;2122	65 	e 
	cpl			;2123	2f 	/ 
l2124h:
	ld h,c			;2124	61 	a 
	cpl			;2125	2f 	/ 
	xor a			;2126	af 	. 
	inc sp			;2127	33 	3 
	dec l			;2128	2d 	- 
	ld a,(de)			;2129	1a 	. 
	dec sp			;212a	3b 	; 
	ld a,(de)			;212b	1a 	. 
	ld c,b			;212c	48 	H 
	ld a,(de)			;212d	1a 	. 
	inc c			;212e	0c 	. 
	inc (hl)			;212f	34 	4 
	ld l,045h		;2130	2e 45 	. E 
	ld c,l			;2132	4d 	M 
	ld a,(de)			;2133	1a 	. 
	ld (hl),l			;2134	75 	u 
	ld a,(de)			;2135	1a 	. 
	ld a,l			;2136	7d 	} 
	ld a,(de)			;2137	1a 	. 
	add a,e			;2138	83 	. 
	ld a,(de)			;2139	1a 	. 
	adc a,c			;213a	89 	. 
	ld a,(de)			;213b	1a 	. 
	inc h			;213c	24 	$ 
	add hl,hl			;213d	29 	) 
	ld b,l			;213e	45 	E 
	ld b,(hl)			;213f	46 	F 
	ex af,af'			;2140	08 	. 
	ld a,(bc)			;2141	0a 	. 
	scf			;2142	37 	7 
l2143h:
	daa			;2143	27 	' 
	ld d,h			;2144	54 	T 
	cpl			;2145	2f 	/ 
	or 01ah		;2146	f6 1a 	. . 
	ld hl,(0fe46h)		;2148	2a 46 fe 	* F . 
	ld a,(de)			;214b	1a 	. 
	dec b			;214c	05 	. 
	dec de			;214d	1b 	. 
	ld e,c			;214e	59 	Y 
	cpl			;214f	2f 	/ 
	dec c			;2150	0d 	. 
	dec de			;2151	1b 	. 
	dec de			;2152	1b 	. 
l2153h:
	dec de			;2153	1b 	. 
	jr nz,l2171h		;2154	20 1b 	  . 
	inc h			;2156	24 	$ 
	dec de			;2157	1b 	. 
	ld b,h			;2158	44 	D 
	dec e			;2159	1d 	. 
	sbc a,b			;215a	98 	. 
	daa			;215b	27 	' 
	call po,02a33h		;215c	e4 33 2a 	. 3 * 
	dec de			;215f	1b 	. 
	inc (hl)			;2160	34 	4 
	add hl,hl			;2161	29 	) 
	dec a			;2162	3d 	= 
	add hl,hl			;2163	29 	) 
	ld b,c			;2164	41 	A 
	add hl,hl			;2165	29 	) 
	ld b,l			;2166	45 	E 
	add hl,hl			;2167	29 	) 
	ld c,c			;2168	49 	I 
	add hl,hl			;2169	29 	) 
	ld c,l			;216a	4d 	M 
	add hl,hl			;216b	29 	) 
	scf			;216c	37 	7 
	dec de			;216d	1b 	. 
	ld b,d			;216e	42 	B 
	dec de			;216f	1b 	. 
	ld (hl),d			;2170	72 	r 
l2171h:
	dec de			;2171	1b 	. 
	dec e			;2172	1d 	. 
	ld a,(bc)			;2173	0a 	. 
	push de			;2174	d5 	. 
	ld b,(hl)			;2175	46 	F 
	ld d,c			;2176	51 	Q 
	add hl,hl			;2177	29 	) 
	inc d			;2178	14 	. 
	ld b,a			;2179	47 	G 
	sbc a,b			;217a	98 	. 
	daa			;217b	27 	' 
	sbc a,b			;217c	98 	. 
	daa			;217d	27 	' 
	sbc a,b			;217e	98 	. 
	daa			;217f	27 	' 
	rrca			;2180	0f 	. 
	ld hl,(00a55h)		;2181	2a 55 0a 	* U . 
	adc a,(hl)			;2184	8e 	. 
	ld b,h			;2185	44 	D 
	ld d,a			;2186	57 	W 
	add hl,hl			;2187	29 	) 
	sub a			;2188	97 	. 
	dec de			;2189	1b 	. 
	cp h			;218a	bc 	. 
	dec de			;218b	1b 	. 
	sbc a,b			;218c	98 	. 
	daa			;218d	27 	' 
	xor e			;218e	ab 	. 
	ld a,(bc)			;218f	0a 	. 
	ret nc			;2190	d0 	. 
	dec de			;2191	1b 	. 
	rst 18h			;2192	df 	. 
	dec de			;2193	1b 	. 
	ex (sp),hl			;2194	e3 	. 
	dec de			;2195	1b 	. 
	pop af			;2196	f1 	. 
	add hl,bc			;2197	09 	. 
	ld l,e			;2198	6b 	k 
	inc e			;2199	1c 	. 
	ret po			;219a	e0 	. 
	add hl,bc			;219b	09 	. 
	ld (hl),e			;219c	73 	s 
	inc e			;219d	1c 	. 
	adc a,d			;219e	8a 	. 
	inc e			;219f	1c 	. 
	sbc a,c			;21a0	99 	. 
	inc e			;21a1	1c 	. 
	sbc a,l			;21a2	9d 	. 
	inc e			;21a3	1c 	. 
	and c			;21a4	a1 	. 
	inc e			;21a5	1c 	. 
	and l			;21a6	a5 	. 
	inc e			;21a7	1c 	. 
	xor c			;21a8	a9 	. 
	inc e			;21a9	1c 	. 
	xor l			;21aa	ad 	. 
	inc e			;21ab	1c 	. 
	bit 0,e		;21ac	cb 43 	. C 
	ld h,l			;21ae	65 	e 
	ld b,h			;21af	44 	D 
	or b			;21b0	b0 	. 
	ld b,h			;21b1	44 	D 
	ld l,e			;21b2	6b 	k 
	add hl,hl			;21b3	29 	) 
	ld (hl),l			;21b4	75 	u 
	add hl,hl			;21b5	29 	) 
	exx			;21b6	d9 	. 
	inc e			;21b7	1c 	. 
	rst 8			;21b8	cf 	. 
	inc e			;21b9	1c 	. 
	add a,b			;21ba	80 	. 
	add hl,hl			;21bb	29 	) 
	or h			;21bc	b4 	. 
	ld hl,(l2abah)		;21bd	2a ba 2a 	* . * 
	cp c			;21c0	b9 	. 
	add hl,hl			;21c1	29 	) 
	cp a			;21c2	bf 	. 
	add hl,hl			;21c3	29 	) 
	push bc			;21c4	c5 	. 
	add hl,hl			;21c5	29 	) 
	sra c		;21c6	cb 29 	. ) 
	sra c		;21c8	cb 29 	. ) 
	sbc a,b			;21ca	98 	. 
	daa			;21cb	27 	' 
	ret c			;21cc	d8 	. 
	add hl,hl			;21cd	29 	) 
	ld c,027h		;21ce	0e 27 	. ' 
	dec b			;21d0	05 	. 
	daa			;21d1	27 	' 
	or c			;21d2	b1 	. 
	inc e			;21d3	1c 	. 
	cp b			;21d4	b8 	. 
	inc e			;21d5	1c 	. 
	call z,0d229h		;21d6	cc 29 d2 	. ) . 
	add hl,hl			;21d9	29 	) 
	nop			;21da	00 	. 
	or b			;21db	b0 	. 
esc_M_subdispatch_tbl:
	jp nz,0d81ch		;21dc	c2 1c d8 	. . . 
	add hl,hl			;21df	29 	) 
	jp nz,0c21ch		;21e0	c2 1c c2 	. . . 
	inc e			;21e3	1c 	. 
	ld c,027h		;21e4	0e 27 	. ' 
	dec b			;21e6	05 	. 
	daa			;21e7	27 	' 
	jp nz,0c719h		;21e8	c2 19 c7 	. . . 
	add hl,de			;21eb	19 	. 
	jp 0ed1ch		;21ec	c3 1c ed 	. . . 
	jr z,5		;21ef	28 03 	( . 
	add hl,hl			;21f1	29 	) 
	rrca			;21f2	0f 	. 
	ld hl,(h_page_counter_op)		;21f3	2a 39 2a 	* 9 * 
	rst 8			;21f6	cf 	. 
	inc e			;21f7	1c 	. 
	ld hl,(0d929h)		;21f8	2a 29 d9 	* ) . 
	inc e			;21fb	1c 	. 
	nop			;21fc	00 	. 
	or b			;21fd	b0 	. 
	ld d,e			;21fe	53 	S 
	ld hl,(l2a9eh)		;21ff	2a 9e 2a 	* . * 
	defb 0edh;next byte illegal after ed		;2202	ed 	. 
	dec sp			;2203	3b 	; 
	ld hl,0b43ch		;2204	21 3c b4 	! < . 
	ld hl,(l2abah)		;2207	2a ba 2a 	* . * 
	ld h,a			;220a	67 	g 
	inc a			;220b	3c 	< 
	ld l,h			;220c	6c 	l 
	inc a			;220d	3c 	< 
	ret nz			;220e	c0 	. 
	ld hl,(l2ac9h)		;220f	2a c9 2a 	* . * 
	jp nc,0de2ah		;2212	d2 2a de 	. * . 
	ld hl,(l2c2eh)		;2215	2a 2e 2c 	* . , 
	ld a,02ch		;2218	3e 2c 	> , 
	ld c,(hl)			;221a	4e 	N 
	inc l			;221b	2c 	, 
	ld h,b			;221c	60 	` 
	inc l			;221d	2c 	, 
	jp 0d109h		;221e	c3 09 d1 	. . . 
	add hl,bc			;2221	09 	. 
	ld l,a			;2222	6f 	o 
	inc l			;2223	2c 	, 
	ld (hl),e			;2224	73 	s 
l2225h:
	inc l			;2225	2c 	, 
	ld l,01dh		;2226	2e 1d 	. . 
l2228h:
	jr l2247h		;2228	18 1d 	. . 
	jr 31		;222a	18 1d 	. . 
	jr l224bh		;222c	18 1d 	. . 
	jr 31		;222e	18 1d 	. . 
	add hl,de			;2230	19 	. 
	dec e			;2231	1d 	. 
	rra			;2232	1f 	. 
	dec e			;2233	1d 	. 
	dec c			;2234	0d 	. 
	dec l			;2235	2d 	- 
	add hl,sp			;2236	39 	9 
	dec l			;2237	2d 	- 
	scf			;2238	37 	7 
	daa			;2239	27 	' 
	ld b,h			;223a	44 	D 
	dec e			;223b	1d 	. 
	ld l,01dh		;223c	2e 1d 	. . 
	ld e,h			;223e	5c 	\ 
	dec l			;223f	2d 	- 
	ld h,c			;2240	61 	a 
	dec l			;2241	2d 	- 
	ld l,b			;2242	68 	h 
	dec l			;2243	2d 	- 
	ld l,l			;2244	6d 	m 
	dec l			;2245	2d 	- 
	ld a,(bc)			;2246	0a 	. 
l2247h:
	ld a,(de)			;2247	1a 	. 
	ld hl,0181ah		;2248	21 1a 18 	! . . 
l224bh:
	dec e			;224b	1d 	. 
	jr l226bh		;224c	18 1d 	. . 
	jr l226dh		;224e	18 1d 	. . 
h_cursor_addr_4coord:
	ld e,004h		;2250	1e 04 	. . 
	ld a,(ram_mode_flags)		;2252	3a 29 aa 	: ) . 
	and 010h		;2255	e6 10 	. . 
	ld b,a			;2257	47 	G 
	ld a,(0aa2ah)		;2258	3a 2a aa 	: * . 
	and 040h		;225b	e6 40 	. @ 
	or b			;225d	b0 	. 
	jr z,l22a5h		;225e	28 45 	( E 
	dec e			;2260	1d 	. 
	call sub_3507h		;2261	cd 07 35 	. . 5 
	jr nc,l22a5h		;2264	30 3f 	0 ? 
	dec e			;2266	1d 	. 
	ld h,a			;2267	67 	g 
	call sub_350eh		;2268	cd 0e 35 	. . 5 
l226bh:
	jr nc,l22a5h		;226b	30 38 	0 8 
l226dh:
	dec e			;226d	1d 	. 
	ld l,a			;226e	6f 	o 
	call sub_3507h		;226f	cd 07 35 	. . 5 
	jr nc,l22a5h		;2272	30 31 	0 1 
	ld c,a			;2274	4f 	O 
	cp h			;2275	bc 	. 
	jr c,l22a5h		;2276	38 2d 	8 - 
	call sub_350eh		;2278	cd 0e 35 	. . 5 
	ret nc			;227b	d0 	. 
	ld e,a			;227c	5f 	_ 
	ld a,c			;227d	79 	y 
	cp h			;227e	bc 	. 
	jr nz,l2284h		;227f	20 03 	  . 
	ld a,e			;2281	7b 	{ 
	cp l			;2282	bd 	. 
	ret c			;2283	d8 	. 
l2284h:
	ld b,e			;2284	43 	C 
	ld iy,(0abd7h)		;2285	fd 2a d7 ab 	. * . . 
	ld de,0abd7h		;2289	11 d7 ab 	. . . 
	ex de,hl			;228c	eb 	. 
	ld (hl),e			;228d	73 	s 
	inc hl			;228e	23 	# 
	ld (hl),d			;228f	72 	r 
	call 0450ah		;2290	cd 0a 45 	. . E 
	call 015e3h		;2293	cd e3 15 	. . . 
	ld hl,00000h		;2296	21 00 00 	! . . 
	ld a,(0ac28h)		;2299	3a 28 ac 	: ( . 
	ld e,a			;229c	5f 	_ 
	ld a,b			;229d	78 	x 
	inc a			;229e	3c 	< 
	call 0455ah		;229f	cd 5a 45 	. Z E 
	jp 015efh		;22a2	c3 ef 15 	. . . 
l22a5h:
	jp 018ech		;22a5	c3 ec 18 	. . . 
	call sub_3f78h		;22a8	cd 78 3f 	. x ? 
	ld a,(ram_mode_flags)		;22ab	3a 29 aa 	: ) . 
	and 004h		;22ae	e6 04 	. . 
	jr nz,l22bah		;22b0	20 08 	  . 
	ld hl,0aa8ch		;22b2	21 8c aa 	! . . 
	bit 7,(hl)		;22b5	cb 7e 	. ~ 
	call nz,013e2h		;22b7	c4 e2 13 	. . . 
l22bah:
	call 013f9h		;22ba	cd f9 13 	. . . 
	ld a,030h		;22bd	3e 30 	> 0 
	ld (06001h),a		;22bf	32 01 60 	2 . ` 
	ld c,056h		;22c2	0e 56 	. V 
	call 01475h		;22c4	cd 75 14 	. u . 
	xor a			;22c7	af 	. 
	ld (0abc7h),a		;22c8	32 c7 ab 	2 . . 
	ld de,00000h		;22cb	11 00 00 	. . . 
	ld hl,l23e1h		;22ce	21 e1 23 	! . # 
	ld b,050h		;22d1	06 50 	. P 
	call 00d61h		;22d3	cd 61 0d 	. a . 
	call 0095eh		;22d6	cd 5e 09 	. ^ . 
	call 0096dh		;22d9	cd 6d 09 	. m . 
	call 00983h		;22dc	cd 83 09 	. . . 
	call 00991h		;22df	cd 91 09 	. . . 
	call sub_23b5h		;22e2	cd b5 23 	. . # 
	call sub_2387h		;22e5	cd 87 23 	. . # 
	call sub_239fh		;22e8	cd 9f 23 	. . # 
l22ebh:
	call 0184dh		;22eb	cd 4d 18 	. M . 
	ld a,c			;22ee	79 	y 
	cp 0e8h		;22ef	fe e8 	. . 
	jr z,l22fah		;22f1	28 07 	( . 
	cp 013h		;22f3	fe 13 	. . 
	jr nz,l2303h		;22f5	20 0c 	  . 
	call 01cc3h		;22f7	cd c3 1c 	. . . 
l22fah:
	call 002dbh		;22fa	cd db 02 	. . . 
	call 01403h		;22fd	cd 03 14 	. . . 
	jp 001b5h		;2300	c3 b5 01 	. . . 
l2303h:
	sub 031h		;2303	d6 31 	. 1 
	cp 009h		;2305	fe 09 	. . 
	jr nc,l22ebh		;2307	30 e2 	0 . 
	ld hl,l2311h		;2309	21 11 23 	! . # 
	call 00abdh		;230c	cd bd 0a 	. . . 
	jr l22ebh		;230f	18 da 	. . 
l2311h:
	inc hl			;2311	23 	# 
	inc hl			;2312	23 	# 
	ld (hl),023h		;2313	36 23 	6 # 
	ld b,b			;2315	40 	@ 
	inc hl			;2316	23 	# 
	ld c,d			;2317	4a 	J 
	inc hl			;2318	23 	# 
	ld d,h			;2319	54 	T 
	inc hl			;231a	23 	# 
	ld e,(hl)			;231b	5e 	^ 
	inc hl			;231c	23 	# 
	ld hl,(07329h)		;231d	2a 29 73 	* ) s 
	inc hl			;2320	23 	# 
	ld a,l			;2321	7d 	} 
	inc hl			;2322	23 	# 
	call 01d55h		;2323	cd 55 1d 	. U . 
	ld hl,ram_setup_flags_b9		;2326	21 b9 aa 	! . . 
	ld a,(hl)			;2329	7e 	~ 
	inc a			;232a	3c 	< 
	and 003h		;232b	e6 03 	. . 
	ld b,a			;232d	47 	G 
	ld a,(hl)			;232e	7e 	~ 
	and 0fch		;232f	e6 fc 	. . 
	or b			;2331	b0 	. 
	ld (hl),a			;2332	77 	w 
	jp 0095eh		;2333	c3 5e 09 	. ^ . 
	ld hl,ram_setup_flags_b9		;2336	21 b9 aa 	! . . 
	ld a,(hl)			;2339	7e 	~ 
	xor 004h		;233a	ee 04 	. . 
	ld (hl),a			;233c	77 	w 
	jp 0096dh		;233d	c3 6d 09 	. m . 
	ld hl,0aab8h		;2340	21 b8 aa 	! . . 
	ld a,(hl)			;2343	7e 	~ 
	xor 002h		;2344	ee 02 	. . 
	ld (hl),a			;2346	77 	w 
	jp 00983h		;2347	c3 83 09 	. . . 
	ld hl,0aab7h		;234a	21 b7 aa 	! . . 
	ld a,(hl)			;234d	7e 	~ 
	xor 008h		;234e	ee 08 	. . 
	ld (hl),a			;2350	77 	w 
	jp 00991h		;2351	c3 91 09 	. . . 
	ld hl,0aab7h		;2354	21 b7 aa 	! . . 
	ld a,(hl)			;2357	7e 	~ 
	xor 040h		;2358	ee 40 	. @ 
	ld (hl),a			;235a	77 	w 
	jp sub_2387h		;235b	c3 87 23 	. . # 
	ld hl,ram_setup_emul_bb		;235e	21 bb aa 	! . . 
	ld a,(hl)			;2361	7e 	~ 
	and 0f0h		;2362	e6 f0 	. . 
	add a,010h		;2364	c6 10 	. . 
	jr nz,l236ah		;2366	20 02 	  . 
	ld a,010h		;2368	3e 10 	> . 
l236ah:
	ld b,a			;236a	47 	G 
	ld a,(hl)			;236b	7e 	~ 
	and 00fh		;236c	e6 0f 	. . 
	or b			;236e	b0 	. 
	ld (hl),a			;236f	77 	w 
	jp sub_239fh		;2370	c3 9f 23 	. . # 
	pop hl			;2373	e1 	. 
	call sub_23cah		;2374	cd ca 23 	. . # 
	call sub_2866h		;2377	cd 66 28 	. f ( 
	jp 005f2h		;237a	c3 f2 05 	. . . 
	ld hl,0aabdh		;237d	21 bd aa 	! . . 
	ld a,(hl)			;2380	7e 	~ 
	xor 001h		;2381	ee 01 	. . 
	ld (hl),a			;2383	77 	w 
	jp sub_23b5h		;2384	c3 b5 23 	. . # 
sub_2387h:
	ld a,(0aab7h)		;2387	3a b7 aa 	: . . 
	bit 6,a		;238a	cb 77 	. w 
	ld e,006h		;238c	1e 06 	. . 
	jr nz,l2392h		;238e	20 02 	  . 
	ld e,000h		;2390	1e 00 	. . 
l2392h:
	ld d,000h		;2392	16 00 	. . 
	ld hl,02431h		;2394	21 31 24 	! 1 $ 
	add hl,de			;2397	19 	. 
	ld de,00026h		;2398	11 26 00 	. & . 
	ld b,006h		;239b	06 06 	. . 
	jr l23b2h		;239d	18 13 	. . 
sub_239fh:
	ld a,(ram_setup_emul_bb)		;239f	3a bb aa 	: . . 
	and 0f0h		;23a2	e6 f0 	. . 
	rrca			;23a4	0f 	. 
	rrca			;23a5	0f 	. 
	ld e,a			;23a6	5f 	_ 
	ld d,000h		;23a7	16 00 	. . 
	ld hl,008e8h		;23a9	21 e8 08 	! . . 
	add hl,de			;23ac	19 	. 
	ld de,00030h		;23ad	11 30 00 	. 0 . 
	ld b,004h		;23b0	06 04 	. . 
l23b2h:
	jp 00d61h		;23b2	c3 61 0d 	. a . 
sub_23b5h:
	ld a,(0aabdh)		;23b5	3a bd aa 	: . . 
	and 001h		;23b8	e6 01 	. . 
	rlca			;23ba	07 	. 
	rlca			;23bb	07 	. 
	ld e,a			;23bc	5f 	_ 
	ld d,000h		;23bd	16 00 	. . 
	ld hl,008e0h		;23bf	21 e0 08 	! . . 
	add hl,de			;23c2	19 	. 
	ld b,004h		;23c3	06 04 	. . 
	ld de,00049h		;23c5	11 49 00 	. I . 
	jr l23b2h		;23c8	18 e8 	. . 
sub_23cah:
	ld a,(0ac36h)		;23ca	3a 36 ac 	: 6 . 
	and a			;23cd	a7 	. 
	jr z,l23d9h		;23ce	28 09 	( . 
	xor a			;23d0	af 	. 
	ld hl,0ad5ch		;23d1	21 5c ad 	! \ . 
	ld (hl),a			;23d4	77 	w 
l23d5h:
	ld a,(hl)			;23d5	7e 	~ 
	and a			;23d6	a7 	. 
	jr z,l23d5h		;23d7	28 fc 	( . 
l23d9h:
	ld a,017h		;23d9	3e 17 	> . 
	ld (0ab27h),a		;23db	32 27 ab 	2 ' . 
	jp l3d43h		;23de	c3 43 3d 	. C = 
l23e1h:
	ld sp,0483dh		;23e1	31 3d 48 	1 = H 
	ld b,h			;23e4	44 	D 
	ld e,b			;23e5	58 	X 
	jr nz,l2408h		;23e6	20 20 	    
	ld (0533dh),a		;23e8	32 3d 53 	2 = S 
	ld c,c			;23eb	49 	I 
	ld c,h			;23ec	4c 	L 
	ld b,l			;23ed	45 	E 
	ld c,(hl)			;23ee	4e 	N 
	ld d,h			;23ef	54 	T 
	jr nz,l2412h		;23f0	20 20 	    
	inc sp			;23f2	33 	3 
	dec a			;23f3	3d 	= 
	ld b,d			;23f4	42 	B 
	ld b,l			;23f5	45 	E 
	ld c,h			;23f6	4c 	L 
	ld c,h			;23f7	4c 	L 
	dec l			;23f8	2d 	- 
	ld c,a			;23f9	4f 	O 
	ld b,(hl)			;23fa	46 	F 
	ld b,(hl)			;23fb	46 	F 
	jr nz,l241eh		;23fc	20 20 	    
	inc (hl)			;23fe	34 	4 
	dec a			;23ff	3d 	= 
	ld c,(hl)			;2400	4e 	N 
	ld c,a			;2401	4f 	O 
	ld d,d			;2402	52 	R 
	jr nz,l2425h		;2403	20 20 	    
	dec (hl)			;2405	35 	5 
	dec a			;2406	3d 	= 
	ld d,e			;2407	53 	S 
l2408h:
	ld c,l			;2408	4d 	M 
	ld c,a			;2409	4f 	O 
	ld c,a			;240a	4f 	O 
	ld d,h			;240b	54 	T 
	ld c,b			;240c	48 	H 
	jr nz,34		;240d	20 20 	    
	ld (hl),03dh		;240f	36 3d 	6 = 
	add hl,sp			;2411	39 	9 
l2412h:
	ld (hl),030h		;2412	36 30 	6 0 
	jr nc,34		;2414	30 20 	0   
	jr nz,57		;2416	20 37 	  7 
	dec a			;2418	3d 	= 
	ld d,d			;2419	52 	R 
	ld b,l			;241a	45 	E 
	ld d,e			;241b	53 	S 
	ld b,l			;241c	45 	E 
	ld d,h			;241d	54 	T 
l241eh:
	jr nz,34		;241e	20 20 	    
	jr c,l245fh		;2420	38 3d 	8 = 
	ld c,l			;2422	4d 	M 
	ld b,l			;2423	45 	E 
	ld c,(hl)			;2424	4e 	N 
l2425h:
	ld d,l			;2425	55 	U 
	jr nz,34		;2426	20 20 	    
	add hl,sp			;2428	39 	9 
	dec a			;2429	3d 	= 
	ld c,h			;242a	4c 	L 
	ld c,a			;242b	4f 	O 
	ld b,e			;242c	43 	C 
	ld b,l			;242d	45 	E 
	jr nz,l2450h		;242e	20 20 	    
	jr nz,76		;2430	20 4a 	  J 
	ld d,l			;2432	55 	U 
	ld c,l			;2433	4d 	M 
	ld d,b			;2434	50 	P 
	jr nz,34		;2435	20 20 	    
	ld d,e			;2437	53 	S 
	ld c,l			;2438	4d 	M 
	ld c,a			;2439	4f 	O 
	ld c,a			;243a	4f 	O 
	ld d,h			;243b	54 	T 
	ld c,b			;243c	48 	H 
main_entry:
	di			;243d	f3 	. 
	ld sp,0ae1eh		;243e	31 1e ae 	1 . . 
	call 04dcfh		;2441	cd cf 4d 	. . M 
	call sub_3c71h		;2444	cd 71 3c 	. q < 
	ld de,00020h		;2447	11 20 00 	.   . 
	ld hl,01fffh		;244a	21 ff 1f 	! . . 
	call 046f4h		;244d	cd f4 46 	. . F 
l2450h:
	call 001f4h		;2450	cd f4 01 	. . . 
	call 00552h		;2453	cd 52 05 	. R . 
	call 0b01eh		;2456	cd 1e b0 	. . . 
l2459h:
	ld a,(0a94ah)		;2459	3a 4a a9 	: J . 
	ld hl,0a94bh		;245c	21 4b a9 	! K . 
l245fh:
	cp (hl)			;245f	be 	. 
	call nz,017cfh		;2460	c4 cf 17 	. . . 
	ld a,(0abf7h)		;2463	3a f7 ab 	: . . 
	and a			;2466	a7 	. 
	jr z,l246eh		;2467	28 05 	( . 
	call 01305h		;2469	cd 05 13 	. . . 
	jr l2471h		;246c	18 03 	. . 
l246eh:
	call 04960h		;246e	cd 60 49 	. ` I 
l2471h:
	call 00d7bh		;2471	cd 7b 0d 	. { . 
	call 010e4h		;2474	cd e4 10 	. . . 
	call 011c8h		;2477	cd c8 11 	. . . 
	call sub_37e8h		;247a	cd e8 37 	. . 7 
	di			;247d	f3 	. 
	ld hl,0ac3bh		;247e	21 3b ac 	! ; . 
	bit 3,(hl)		;2481	cb 5e 	. ^ 
	jr nz,l248dh		;2483	20 08 	  . 
	ld a,(08001h)		;2485	3a 01 80 	: . . 
	and 001h		;2488	e6 01 	. . 
	call nz,0148fh		;248a	c4 8f 14 	. . . 
l248dh:
	ei			;248d	fb 	. 
	ld a,(0ac47h)		;248e	3a 47 ac 	: G . 
	and a			;2491	a7 	. 
	call z,01435h		;2492	cc 35 14 	. 5 . 
	di			;2495	f3 	. 
	ld a,(09001h)		;2496	3a 01 90 	: . . 
	bit 2,a		;2499	cb 57 	. W 
	call nz,014e2h		;249b	c4 e2 14 	. . . 
	ei			;249e	fb 	. 
	call 0b01bh		;249f	cd 1b b0 	. . . 
	jr l2459h		;24a2	18 b5 	. . 
l24a4h:
	ld hl,0ab45h		;24a4	21 45 ab 	! E . 
l24a7h:
	ld b,050h		;24a7	06 50 	. P 
l24a9h:
	ld c,(hl)			;24a9	4e 	N 
	call sub_24beh		;24aa	cd be 24 	. . $ 
	jr z,l24b5h		;24ad	28 06 	( . 
l24afh:
	djnz l24a9h		;24af	10 f8 	. . 
l24b1h:
	ld c,00dh		;24b1	0e 0d 	. . 
	rst 18h			;24b3	df 	. 
	ret			;24b4	c9 	. 
l24b5h:
	ld a,(0aa2bh)		;24b5	3a 2b aa 	: + . 
	and 080h		;24b8	e6 80 	. . 
	jr nz,l24afh		;24ba	20 f3 	  . 
	jr l24b1h		;24bc	18 f3 	. . 
sub_24beh:
	push hl			;24be	e5 	. 
	push bc			;24bf	c5 	. 
	call 0100fh		;24c0	cd 0f 10 	. . . 
	rst 18h			;24c3	df 	. 
	pop bc			;24c4	c1 	. 
	pop hl			;24c5	e1 	. 
	inc hl			;24c6	23 	# 
	ld a,c			;24c7	79 	y 
	and a			;24c8	a7 	. 
	ret			;24c9	c9 	. 
l24cah:
	push bc			;24ca	c5 	. 
	ld hl,00000h		;24cb	21 00 00 	! . . 
	ld ix,0ab45h		;24ce	dd 21 45 ab 	. ! E . 
	ld b,04fh		;24d2	06 4f 	. O 
	ld a,(0abc5h)		;24d4	3a c5 ab 	: . . 
	ld d,a			;24d7	57 	W 
l24d8h:
	ld a,(ix+001h)		;24d8	dd 7e 01 	. ~ . 
	ld (ix+000h),a		;24db	dd 77 00 	. w . 
	ld (06006h),hl		;24de	22 06 60 	" . ` 
	ld e,a			;24e1	5f 	_ 
	call 00d38h		;24e2	cd 38 0d 	. 8 . 
	rst 10h			;24e5	d7 	. 
	inc hl			;24e6	23 	# 
	inc ix		;24e7	dd 23 	. # 
	djnz l24d8h		;24e9	10 ed 	. . 
	pop bc			;24eb	c1 	. 
	ld a,c			;24ec	79 	y 
	ld (ix+000h),a		;24ed	dd 77 00 	. w . 
	ld e,a			;24f0	5f 	_ 
	ld (06006h),hl		;24f1	22 06 60 	" . ` 
	jp 00d38h		;24f4	c3 38 0d 	. 8 . 
	ld a,c			;24f7	79 	y 
	cp 080h		;24f8	fe 80 	. . 
	jr c,l2507h		;24fa	38 0b 	8 . 
	and 07fh		;24fc	e6 7f 	.  
	push af			;24fe	f5 	. 
	ld a,(ram_leadin_byte)		;24ff	3a 99 aa 	: . . 
	ld c,a			;2502	4f 	O 
	call sub_250fh		;2503	cd 0f 25 	. . % 
	pop af			;2506	f1 	. 
l2507h:
	call 01757h		;2507	cd 57 17 	. W . 
	ld c,a			;250a	4f 	O 
	cp 00dh		;250b	fe 0d 	. . 
	jr z,l2540h		;250d	28 31 	( 1 
sub_250fh:
	ld hl,(0ad62h)		;250f	2a 62 ad 	* b . 
	ld de,(0ad64h)		;2512	ed 5b 64 ad 	. [ d . 
	ld a,l			;2516	7d 	} 
	cp 050h		;2517	fe 50 	. P 
	jr nc,l24cah		;2519	30 af 	0 . 
	ld (06006h),hl		;251b	22 06 60 	" . ` 
	ld a,c			;251e	79 	y 
	ld (de),a			;251f	12 	. 
	push de			;2520	d5 	. 
	ld e,a			;2521	5f 	_ 
	ld a,(0abc5h)		;2522	3a c5 ab 	: . . 
	ld d,a			;2525	57 	W 
	call 00d38h		;2526	cd 38 0d 	. 8 . 
	pop de			;2529	d1 	. 
	ld a,(0aa2bh)		;252a	3a 2b aa 	: + . 
	and 080h		;252d	e6 80 	. . 
	jr z,l2536h		;252f	28 05 	( . 
	ld a,l			;2531	7d 	} 
	cp 04fh		;2532	fe 4f 	. O 
	jr nc,l2540h		;2534	30 0a 	0 . 
l2536h:
	inc hl			;2536	23 	# 
	inc de			;2537	13 	. 
	ld (0ad62h),hl		;2538	22 62 ad 	" b . 
	ld (0ad64h),de		;253b	ed 53 64 ad 	. S d . 
	ret			;253f	c9 	. 
l2540h:
	xor a			;2540	af 	. 
	ld (0ad61h),a		;2541	32 61 ad 	2 a . 
	ret			;2544	c9 	. 
l2545h:
	ld a,(0aa8ah)		;2545	3a 8a aa 	: . . 
	and 010h		;2548	e6 10 	. . 
	jr z,l2564h		;254a	28 18 	( . 
	ld b,050h		;254c	06 50 	. P 
	ld hl,00000h		;254e	21 00 00 	! . . 
l2551h:
	ld (06006h),hl		;2551	22 06 60 	" . ` 
	call 017a0h		;2554	cd a0 17 	. . . 
	ld a,(0c000h)		;2557	3a 00 c0 	: . . 
	ld c,a			;255a	4f 	O 
	call sub_24beh		;255b	cd be 24 	. . $ 
	djnz l2551h		;255e	10 f1 	. . 
	ld c,00dh		;2560	0e 0d 	. . 
	rst 18h			;2562	df 	. 
	ret			;2563	c9 	. 
l2564h:
	ld hl,0ad0ch		;2564	21 0c ad 	! . . 
	jp l24a7h		;2567	c3 a7 24 	. . $ 
	call 00d4bh		;256a	cd 4b 0d 	. K . 
	ld a,(0aa8ah)		;256d	3a 8a aa 	: . . 
	or 00fh		;2570	f6 0f 	. . 
	ld (0aa8ah),a		;2572	32 8a aa 	2 . . 
	ld de,0000ah		;2575	11 0a 00 	. . . 
	ld hl,00e97h		;2578	21 97 0e 	! . . 
	ld b,008h		;257b	06 08 	. . 
	call 00d65h		;257d	cd 65 0d 	. e . 
	ld de,0001ch		;2580	11 1c 00 	. . . 
	ld b,004h		;2583	06 04 	. . 
	call 00d65h		;2585	cd 65 0d 	. e . 
	ld de,00026h		;2588	11 26 00 	. & . 
	ld b,005h		;258b	06 05 	. . 
	call 00d65h		;258d	cd 65 0d 	. e . 
	ld de,0004ah		;2590	11 4a 00 	. J . 
	ld b,006h		;2593	06 06 	. . 
	call 00d65h		;2595	cd 65 0d 	. e . 
	ld a,(0aa8ah)		;2598	3a 8a aa 	: . . 
	bit 3,a		;259b	cb 5f 	. _ 
	jr z,l25deh		;259d	28 3f 	( ? 
	ld a,(0abddh)		;259f	3a dd ab 	: . . 
	and a			;25a2	a7 	. 
	jr z,l25aah		;25a3	28 05 	( . 
	ld hl,00e67h		;25a5	21 67 0e 	! g . 
	jr l25c1h		;25a8	18 17 	. . 
l25aah:
	ld a,(ram_setup_emul_bb)		;25aa	3a bb aa 	: . . 
	and 00fh		;25ad	e6 0f 	. . 
	rlca			;25af	07 	. 
	ld e,a			;25b0	5f 	_ 
	sla a		;25b1	cb 27 	. ' 
	add a,e			;25b3	83 	. 
	ld e,a			;25b4	5f 	_ 
	ld hl,04c86h		;25b5	21 86 4c 	! . L 
	and a			;25b8	a7 	. 
	jr nz,l25beh		;25b9	20 03 	  . 
	ld hl,04f06h		;25bb	21 06 4f 	! . O 
l25beh:
	ld d,000h		;25be	16 00 	. . 
	add hl,de			;25c0	19 	. 
l25c1h:
	ld de,00000h		;25c1	11 00 00 	. . . 
	ld b,005h		;25c4	06 05 	. . 
	call 00d65h		;25c6	cd 65 0d 	. e . 
	ld a,(0aabah)		;25c9	3a ba aa 	: . . 
	rra			;25cc	1f 	. 
	rra			;25cd	1f 	. 
	rra			;25ce	1f 	. 
	rra			;25cf	1f 	. 
	and 00fh		;25d0	e6 0f 	. . 
	ld hl,04c54h		;25d2	21 54 4c 	! T L 
	ld de,00006h		;25d5	11 06 00 	. . . 
	call sub_26deh		;25d8	cd de 26 	. . & 
	ld a,(0aa8ah)		;25db	3a 8a aa 	: . . 
l25deh:
	bit 2,a		;25de	cb 57 	. W 
	jr z,l2613h		;25e0	28 31 	( 1 
	ld hl,00015h		;25e2	21 15 00 	! . . 
	ld b,006h		;25e5	06 06 	. . 
	call 00d43h		;25e7	cd 43 0d 	. C . 
	ld a,(0abc7h)		;25ea	3a c7 ab 	: . . 
	and a			;25ed	a7 	. 
	jr z,l25fbh		;25ee	28 0b 	( . 
	ld hl,00e95h		;25f0	21 95 0e 	! . . 
	ld de,00015h		;25f3	11 15 00 	. . . 
	ld b,002h		;25f6	06 02 	. . 
	call 00d65h		;25f8	cd 65 0d 	. e . 
l25fbh:
	ld a,(0abd1h)		;25fb	3a d1 ab 	: . . 
	and a			;25fe	a7 	. 
	jr z,l2609h		;25ff	28 08 	( . 
	ld a,(0aa8bh)		;2601	3a 8b aa 	: . . 
	call sub_26cah		;2604	cd ca 26 	. . & 
	jr l2610h		;2607	18 07 	. . 
l2609h:
	ld a,(0abf7h)		;2609	3a f7 ab 	: . . 
	and a			;260c	a7 	. 
	call nz,sub_26cah		;260d	c4 ca 26 	. . & 
l2610h:
	ld a,(0aa8ah)		;2610	3a 8a aa 	: . . 
l2613h:
	bit 1,a		;2613	cb 4f 	. O 
	jr z,l263dh		;2615	28 26 	( & 
	ld hl,00020h		;2617	21 20 00 	!   . 
	ld b,005h		;261a	06 05 	. . 
	call 00d43h		;261c	cd 43 0d 	. C . 
	ld hl,00e84h		;261f	21 84 0e 	! . . 
	ld de,00020h		;2622	11 20 00 	.   . 
	ld a,(0abd0h)		;2625	3a d0 ab 	: . . 
	ld c,a			;2628	4f 	O 
	ld b,005h		;2629	06 05 	. . 
l262bh:
	rr c		;262b	cb 19 	. . 
	jr nc,l2637h		;262d	30 08 	0 . 
	push bc			;262f	c5 	. 
	ld b,001h		;2630	06 01 	. . 
	call 00d65h		;2632	cd 65 0d 	. e . 
	dec hl			;2635	2b 	+ 
	pop bc			;2636	c1 	. 
l2637h:
	inc hl			;2637	23 	# 
	djnz l262bh		;2638	10 f1 	. . 
	ld a,(0aa8ah)		;263a	3a 8a aa 	: . . 
l263dh:
	bit 0,a		;263d	cb 47 	. G 
	jp z,l26c2h		;263f	ca c2 26 	. . & 
	ld hl,0002fh		;2642	21 2f 00 	! / . 
	ld b,01ah		;2645	06 1a 	. . 
	call 00d43h		;2647	cd 43 0d 	. C . 
	ld a,(ram_setup_flags_b9)		;264a	3a b9 aa 	: . . 
	and 003h		;264d	e6 03 	. . 
	ld hl,008b7h		;264f	21 b7 08 	! . . 
	ld de,0002bh		;2652	11 2b 00 	. + . 
	call sub_26deh		;2655	cd de 26 	. . & 
	xor a			;2658	af 	. 
	ld c,a			;2659	4f 	O 
l265ah:
	ld (0acc8h),a		;265a	32 c8 ac 	2 . . 
	ld h,a			;265d	67 	g 
	rlca			;265e	07 	. 
	rlca			;265f	07 	. 
	rlca			;2660	07 	. 
	sub h			;2661	94 	. 
	ld hl,l266ah		;2662	21 6a 26 	! j & 
	ld e,a			;2665	5f 	_ 
	ld d,000h		;2666	16 00 	. . 
	add hl,de			;2668	19 	. 
	jp (hl)			;2669	e9 	. 
l266ah:
	ld a,(0aa2ah)		;266a	3a 2a aa 	: * . 
	bit 6,a		;266d	cb 77 	. w 
	jr l26a0h		;266f	18 2f 	. / 
	ld a,(ram_mode_flags)		;2671	3a 29 aa 	: ) . 
	bit 4,a		;2674	cb 67 	. g 
	jr l26a0h		;2676	18 28 	. ( 
	ld a,(0aa2ah)		;2678	3a 2a aa 	: * . 
	bit 3,a		;267b	cb 5f 	. _ 
	jr l26a0h		;267d	18 21 	. ! 
	ld a,(0aa2ah)		;267f	3a 2a aa 	: * . 
	bit 0,a		;2682	cb 47 	. G 
	jr l26a0h		;2684	18 1a 	. . 
	ld a,(0aa2ah)		;2686	3a 2a aa 	: * . 
	bit 1,a		;2689	cb 4f 	. O 
	jr l26a0h		;268b	18 13 	. . 
	ld a,(ram_mode_flags)		;268d	3a 29 aa 	: ) . 
	bit 7,a		;2690	cb 7f 	.  
	jr l26a0h		;2692	18 0c 	. . 
	ld a,(ram_mode_flags)		;2694	3a 29 aa 	: ) . 
	bit 6,a		;2697	cb 77 	. w 
	jr l26a0h		;2699	18 05 	. . 
	ld a,(ram_mode_flags)		;269b	3a 29 aa 	: ) . 
	bit 5,a		;269e	cb 6f 	. o 
l26a0h:
	jr z,l26b7h		;26a0	28 15 	( . 
	ld de,0002fh		;26a2	11 2f 00 	. / . 
	ld a,c			;26a5	79 	y 
	rlca			;26a6	07 	. 
	rlca			;26a7	07 	. 
	ld l,a			;26a8	6f 	o 
	ld h,000h		;26a9	26 00 	& . 
	add hl,de			;26ab	19 	. 
	ex de,hl			;26ac	eb 	. 
	ld hl,00e6ch		;26ad	21 6c 0e 	! l . 
	ld a,(0acc8h)		;26b0	3a c8 ac 	: . . 
	call sub_26d0h		;26b3	cd d0 26 	. . & 
	inc c			;26b6	0c 	. 
l26b7h:
	ld a,(0acc8h)		;26b7	3a c8 ac 	: . . 
	inc a			;26ba	3c 	< 
	cp 008h		;26bb	fe 08 	. . 
	jr nz,l265ah		;26bd	20 9b 	  . 
	ld a,(0aa8ah)		;26bf	3a 8a aa 	: . . 
l26c2h:
	and 070h		;26c2	e6 70 	. p 
	or 040h		;26c4	f6 40 	. @ 
	ld (0aa8ah),a		;26c6	32 8a aa 	2 . . 
	ret			;26c9	c9 	. 
sub_26cah:
	ld hl,00e89h		;26ca	21 89 0e 	! . . 
	ld de,00018h		;26cd	11 18 00 	. . . 
sub_26d0h:
	push de			;26d0	d5 	. 
	ld e,a			;26d1	5f 	_ 
	rlca			;26d2	07 	. 
	add a,e			;26d3	83 	. 
	ld e,a			;26d4	5f 	_ 
	ld d,000h		;26d5	16 00 	. . 
	add hl,de			;26d7	19 	. 
	pop de			;26d8	d1 	. 
l26d9h:
	ld b,003h		;26d9	06 03 	. . 
	jp 00d65h		;26db	c3 65 0d 	. e . 
sub_26deh:
	rlca			;26de	07 	. 
	rlca			;26df	07 	. 
	ld c,a			;26e0	4f 	O 
	ld b,000h		;26e1	06 00 	. . 
	add hl,bc			;26e3	09 	. 
	jr l26d9h		;26e4	18 f3 	. . 
	ld hl,0ab45h		;26e6	21 45 ab 	! E . 
	ld de,00000h		;26e9	11 00 00 	. . . 
	ld b,050h		;26ec	06 50 	. P 
	call 00d65h		;26ee	cd 65 0d 	. e . 
	ld hl,0aa8ah		;26f1	21 8a aa 	! . . 
	res 6,(hl)		;26f4	cb b6 	. . 
	ret			;26f6	c9 	. 
l26f7h:
	xor a			;26f7	af 	. 
	ld (0abd7h),a		;26f8	32 d7 ab 	2 . . 
	jp l3538h		;26fb	c3 38 35 	. 8 5 
l26feh:
	xor a			;26fe	af 	. 
	ld (0abd7h),a		;26ff	32 d7 ab 	2 . . 
	jp h_vt52_esc_B_down		;2702	c3 61 2f 	. a / 
	ld a,(0aa8ah)		;2705	3a 8a aa 	: . . 
	or 090h		;2708	f6 90 	. . 
	ld (0aa8ah),a		;270a	32 8a aa 	2 . . 
	ret			;270d	c9 	. 
	ld a,(0aa8ah)		;270e	3a 8a aa 	: . . 
	bit 4,a		;2711	cb 67 	. g 
	ret z			;2713	c8 	. 
	or 040h		;2714	f6 40 	. @ 
	and 0efh		;2716	e6 ef 	. . 
	ld (0aa8ah),a		;2718	32 8a aa 	2 . . 
sub_271bh:
	ld de,0ad0ch		;271b	11 0c ad 	. . . 
	ld b,050h		;271e	06 50 	. P 
	ld hl,00000h		;2720	21 00 00 	! . . 
l2723h:
	ld (06006h),hl		;2723	22 06 60 	" . ` 
	call 017a0h		;2726	cd a0 17 	. . . 
	ld a,(0c000h)		;2729	3a 00 c0 	: . . 
	and a			;272c	a7 	. 
	jr nz,l2731h		;272d	20 02 	  . 
	ld a,020h		;272f	3e 20 	>   
l2731h:
	ld (de),a			;2731	12 	. 
	inc hl			;2732	23 	# 
	inc de			;2733	13 	. 
	djnz l2723h		;2734	10 ed 	. . 
	ret			;2736	c9 	. 
h_attr_reset:
	call sub_3f78h		;2737	cd 78 3f 	. x ? 
	xor a			;273a	af 	. 
	ld (ram_attr_subsel),a		;273b	32 19 ac 	2 . . 
	ld a,(0ac1dh)		;273e	3a 1d ac 	: . . 
	ld b,a			;2741	47 	G 
	call sub_2ef2h		;2742	cd f2 2e 	. . . 
	ld a,001h		;2745	3e 01 	> . 
	ld (0abf8h),a		;2747	32 f8 ab 	2 . . 
	call l3d43h		;274a	cd 43 3d 	. C = 
	call sub_3ceeh		;274d	cd ee 3c 	. . < 
	ld hl,00080h		;2750	21 80 00 	! . . 
	ld de,04f00h		;2753	11 00 4f 	. . O 
	ld c,008h		;2756	0e 08 	. . 
	call 0094dh		;2758	cd 4d 09 	. M . 
	ld hl,000d0h		;275b	21 d0 00 	! . . 
	rst 10h			;275e	d7 	. 
	ld (06004h),hl		;275f	22 04 60 	" . ` 
	ld d,000h		;2762	16 00 	. . 
	call sub_278eh		;2764	cd 8e 27 	. . ' 
	ld d,008h		;2767	16 08 	. . 
	call sub_278eh		;2769	cd 8e 27 	. . ' 
	ld d,010h		;276c	16 10 	. . 
	call sub_278eh		;276e	cd 8e 27 	. . ' 
	ld d,006h		;2771	16 06 	. . 
	call sub_278eh		;2773	cd 8e 27 	. . ' 
	ld d,01eh		;2776	16 1e 	. . 
	call sub_278eh		;2778	cd 8e 27 	. . ' 
	ld b,000h		;277b	06 00 	. . 
	ld e,b			;277d	58 	X 
l277eh:
	ld d,040h		;277e	16 40 	. @ 
	call 0177fh		;2780	cd 7f 17 	.  . 
	ld d,060h		;2783	16 60 	. ` 
	call 0177fh		;2785	cd 7f 17 	.  . 
	inc e			;2788	1c 	. 
	djnz l277eh		;2789	10 f3 	. . 
	jp h_vt52_esc_H_home		;278b	c3 af 33 	. . 3 
sub_278eh:
	ld b,000h		;278e	06 00 	. . 
	ld e,b			;2790	58 	X 
l2791h:
	call 0177fh		;2791	cd 7f 17 	.  . 
	inc e			;2794	1c 	. 
	djnz l2791h		;2795	10 fa 	. . 
	ret			;2797	c9 	. 
noop_handler:
	ret			;2798	c9 	. 
h_region_2coords:
	call sub_3f78h		;2799	cd 78 3f 	. x ? 
	rst 28h			;279c	ef 	. 
	sub 020h		;279d	d6 20 	.   
	ld (0ac16h),a		;279f	32 16 ac 	2 . . 
	rst 28h			;27a2	ef 	. 
	sub 020h		;27a3	d6 20 	.   
	ld (0ac17h),a		;27a5	32 17 ac 	2 . . 
	call sub_27d5h		;27a8	cd d5 27 	. . ' 
	ret nc			;27ab	d0 	. 
	ld a,(0ac16h)		;27ac	3a 16 ac 	: . . 
	call sub_27d5h		;27af	cd d5 27 	. . ' 
	ret nc			;27b2	d0 	. 
	ld a,(0ac17h)		;27b3	3a 17 ac 	: . . 
	ld hl,0ac16h		;27b6	21 16 ac 	! . . 
	cp (hl)			;27b9	be 	. 
	ret c			;27ba	d8 	. 
	ld hl,0aa2ah		;27bb	21 2a aa 	! * . 
	set 1,(hl)		;27be	cb ce 	. . 
	ld a,(0ac16h)		;27c0	3a 16 ac 	: . . 
	ld (0ab2eh),a		;27c3	32 2e ab 	2 . . 
	ld a,(0ac17h)		;27c6	3a 17 ac 	: . . 
	ld (0ab2dh),a		;27c9	32 2d ab 	2 - . 
	ld (0abd8h),a		;27cc	32 d8 ab 	2 . . 
	call 00f87h		;27cf	cd 87 0f 	. . . 
	jp h_vt52_esc_H_home		;27d2	c3 af 33 	. . 3 
sub_27d5h:
	ld hl,0ab27h		;27d5	21 27 ab 	! ' . 
	ld b,(hl)			;27d8	46 	F 
	inc b			;27d9	04 	. 
	cp b			;27da	b8 	. 
	ret			;27db	c9 	. 
h_3byte_cmd_bit0:
	rst 28h			;27dc	ef 	. 
	bit 0,a		;27dd	cb 47 	. G 
	jr z,l27e6h		;27df	28 05 	( . 
	rst 28h			;27e1	ef 	. 
	ld (0abe9h),a		;27e2	32 e9 ab 	2 . . 
	ret			;27e5	c9 	. 
l27e6h:
	rst 28h			;27e6	ef 	. 
	ld (0abeah),a		;27e7	32 ea ab 	2 . . 
	ret			;27ea	c9 	. 
h_cursor_addr_ampex:
	rst 28h			;27eb	ef 	. 
	ld c,a			;27ec	4f 	O 
	rst 28h			;27ed	ef 	. 
	ld b,a			;27ee	47 	G 
	ld a,(ram_mode_flags)		;27ef	3a 29 aa 	: ) . 
	and 040h		;27f2	e6 40 	. @ 
	ret nz			;27f4	c0 	. 
	ld a,c			;27f5	79 	y 
	sub 031h		;27f6	d6 31 	. 1 
	cp 014h		;27f8	fe 14 	. . 
	jp nc,l3718h		;27fa	d2 18 37 	. . 7 
	push bc			;27fd	c5 	. 
	call sub_3700h		;27fe	cd 00 37 	. . 7 
	pop bc			;2801	c1 	. 
	ld a,b			;2802	78 	x 
	and 003h		;2803	e6 03 	. . 
	jp z,l3718h		;2805	ca 18 37 	. . 7 
	ld c,a			;2808	4f 	O 
	jp l374ch		;2809	c3 4c 37 	. L 7 
h_digit_sel_attr:
	rst 28h			;280c	ef 	. 
	sub 030h		;280d	d6 30 	. 0 
	cp 010h		;280f	fe 10 	. . 
	ret nc			;2811	d0 	. 
	ld d,000h		;2812	16 00 	. . 
	ld e,a			;2814	5f 	_ 
	ld hl,attr_table		;2815	21 e2 2e 	! . . 
	add hl,de			;2818	19 	. 
	ld a,(hl)			;2819	7e 	~ 
	ld (ram_attr_subsel),a		;281a	32 19 ac 	2 . . 
	call sub_2eb8h		;281d	cd b8 2e 	. . . 
	ld (06006h),hl		;2820	22 06 60 	" . ` 
	ld d,031h		;2823	16 31 	. 1 
	ld a,(ram_attr_subsel)		;2825	3a 19 ac 	: . . 
	ld e,a			;2828	5f 	_ 
	call 01777h		;2829	cd 77 17 	. w . 
	ld a,(0abd7h)		;282c	3a d7 ab 	: . . 
	and a			;282f	a7 	. 
	jr nz,l283ah		;2830	20 08 	  . 
	ld a,(0aabdh)		;2832	3a bd aa 	: . . 
	bit 1,a		;2835	cb 4f 	. O 
	jp nz,l2df4h		;2837	c2 f4 2d 	. . - 
l283ah:
	call sub_2e17h		;283a	cd 17 2e 	. . . 
	jp l2df4h		;283d	c3 f4 2d 	. . - 
	rst 28h			;2840	ef 	. 
	sub 020h		;2841	d6 20 	.   
	cp 009h		;2843	fe 09 	. . 
	ret nc			;2845	d0 	. 
	inc a			;2846	3c 	< 
	ld b,a			;2847	47 	G 
	ld c,a			;2848	4f 	O 
	ld a,(0aabah)		;2849	3a ba aa 	: . . 
	and 00fh		;284c	e6 0f 	. . 
	jr l2852h		;284e	18 02 	. . 
l2850h:
	add a,010h		;2850	c6 10 	. . 
l2852h:
	djnz l2850h		;2852	10 fc 	. . 
	ld (0aabah),a		;2854	32 ba aa 	2 . . 
	ld b,c			;2857	41 	A 
	call 04f3bh		;2858	cd 3b 4f 	. ; O 
	jp 00f7bh		;285b	c3 7b 0f 	. { . 
h_param_cp_31:
	rst 28h			;285e	ef 	. 
	cp 031h		;285f	fe 31 	. 1 
	jr z,l2877h		;2861	28 14 	( . 
	cp 032h		;2863	fe 32 	. 2 
	ret nz			;2865	c0 	. 
sub_2866h:
	xor a			;2866	af 	. 
	ld (0ad68h),a		;2867	32 68 ad 	2 h . 
	ld b,018h		;286a	06 18 	. . 
	call 041dfh		;286c	cd df 41 	. . A 
l286fh:
	res 7,(hl)		;286f	cb be 	. . 
	inc hl			;2871	23 	# 
	djnz l286fh		;2872	10 fb 	. . 
	jp l2f22h		;2874	c3 22 2f 	. " / 
l2877h:
	ld a,017h		;2877	3e 17 	> . 
	ld hl,0ad68h		;2879	21 68 ad 	! h . 
	cp (hl)			;287c	be 	. 
	ret z			;287d	c8 	. 
	inc (hl)			;287e	34 	4 
	ld a,(0abd8h)		;287f	3a d8 ab 	: . . 
	call 041dfh		;2882	cd df 41 	. . A 
	set 7,(hl)		;2885	cb fe 	. . 
	cp 017h		;2887	fe 17 	. . 
	jr z,l28adh		;2889	28 22 	( " 
	inc a			;288b	3c 	< 
	inc hl			;288c	23 	# 
	ld c,001h		;288d	0e 01 	. . 
l288fh:
	bit 7,(hl)		;288f	cb 7e 	. ~ 
	jr nz,l28a7h		;2891	20 14 	  . 
l2893h:
	ld (0abd8h),a		;2893	32 d8 ab 	2 . . 
	call l2f22h		;2896	cd 22 2f 	. " / 
	ld a,(ram_mode_flags)		;2899	3a 29 aa 	: ) . 
	and 080h		;289c	e6 80 	. . 
	jp z,0450ah		;289e	ca 0a 45 	. . E 
	ld a,c			;28a1	79 	y 
	ld c,000h		;28a2	0e 00 	. . 
	jp l310dh		;28a4	c3 0d 31 	. . 1 
l28a7h:
	inc a			;28a7	3c 	< 
	inc hl			;28a8	23 	# 
	cp 018h		;28a9	fe 18 	. . 
	jr c,l288fh		;28ab	38 e2 	8 . 
l28adh:
	ld c,0ffh		;28ad	0e ff 	. . 
	ld b,018h		;28af	06 18 	. . 
	dec a			;28b1	3d 	= 
	dec hl			;28b2	2b 	+ 
l28b3h:
	bit 7,(hl)		;28b3	cb 7e 	. ~ 
	jr z,l2893h		;28b5	28 dc 	( . 
	dec a			;28b7	3d 	= 
	dec hl			;28b8	2b 	+ 
	djnz l28b3h		;28b9	10 f8 	. . 
h_subdispatch_HF:
	rst 28h			;28bb	ef 	. 
	cp 048h		;28bc	fe 48 	. H 
	jp z,l2c6fh		;28be	ca 6f 2c 	. o , 
	cp 046h		;28c1	fe 46 	. F 
	jp z,l2c73h		;28c3	ca 73 2c 	. s , 
	ret			;28c6	c9 	. 
h_param_minus_20:
	rst 28h			;28c7	ef 	. 
	sub 020h		;28c8	d6 20 	.   
	ld c,a			;28ca	4f 	O 
	jp l3720h		;28cb	c3 20 37 	.   7 
h_bit0_dispatch:
	rst 28h			;28ce	ef 	. 
	bit 0,a		;28cf	cb 47 	. G 
	jp z,l24a4h		;28d1	ca a4 24 	. . $ 
	jp l2545h		;28d4	c3 45 25 	. E % 
h_subdispatch_12:
	rst 28h			;28d7	ef 	. 
	cp 031h		;28d8	fe 31 	. 1 
	jp z,l2a9eh		;28da	ca 9e 2a 	. . * 
	cp 032h		;28dd	fe 32 	. 2 
	jp z,l2a56h		;28df	ca 56 2a 	. V * 
	ret			;28e2	c9 	. 
h_set_ab2f:
	rst 28h			;28e3	ef 	. 
	ld (0ab2fh),a		;28e4	32 2f ab 	2 / . 
	ret			;28e7	c9 	. 
h_set_abed:
	rst 28h			;28e8	ef 	. 
	ld (0abedh),a		;28e9	32 ed ab 	2 . . 
	ret			;28ec	c9 	. 
h_vt52_esc_F_gfx_on:
	ld c,080h		;28ed	0e 80 	. . 
	ld a,(0aa89h)		;28ef	3a 89 aa 	: . . 
	or 080h		;28f2	f6 80 	. . 
l28f4h:
	ld (0aa89h),a		;28f4	32 89 aa 	2 . . 
	ld a,(0aabah)		;28f7	3a ba aa 	: . . 
	and 00fh		;28fa	e6 0f 	. . 
	or c			;28fc	b1 	. 
	ld (0aabah),a		;28fd	32 ba aa 	2 . . 
	jp 00f7bh		;2900	c3 7b 0f 	. { . 
h_vt52_esc_G_gfx_off:
	ld c,000h		;2903	0e 00 	. . 
	ld a,(0aa89h)		;2905	3a 89 aa 	: . . 
	and 07fh		;2908	e6 7f 	.  
	jr z,l28f4h		;290a	28 e8 	( . 
l290ch:
	inc c			;290c	0c 	. 
	bit 0,a		;290d	cb 47 	. G 
	jr nz,l2915h		;290f	20 04 	  . 
	srl a		;2911	cb 3f 	. ? 
	jr l290ch		;2913	18 f7 	. . 
l2915h:
	sla c		;2915	cb 21 	. ! 
	sla c		;2917	cb 21 	. ! 
	sla c		;2919	cb 21 	. ! 
	sla c		;291b	cb 21 	. ! 
	ld a,(0aa89h)		;291d	3a 89 aa 	: . . 
	and 07fh		;2920	e6 7f 	.  
	jr l28f4h		;2922	18 d0 	. . 
h_invoke_cursor_apply:
	call sub_388dh		;2924	cd 8d 38 	. . 8 
	jp l3538h		;2927	c3 38 35 	. 8 5 
	ld a,(0aaa1h)		;292a	3a a1 aa 	: . . 
	and a			;292d	a7 	. 
	call nz,sub_3780h		;292e	c4 80 37 	. . 7 
	jp 01ae3h		;2931	c3 e3 1a 	. . . 
h_tab_set_bit2:
	ld c,004h		;2934	0e 04 	. . 
l2936h:
	xor a			;2936	af 	. 
l2937h:
	ld (ram_tab_flags),a		;2937	32 18 ac 	2 . . 
	jp l2d76h		;293a	c3 76 2d 	. v - 
h_tab_set_bit0:
	ld c,001h		;293d	0e 01 	. . 
	jr l2936h		;293f	18 f5 	. . 
h_tab_set_bit3:
	ld c,008h		;2941	0e 08 	. . 
	jr l2936h		;2943	18 f1 	. . 
h_tab_clr_bits:
	ld a,005h		;2945	3e 05 	> . 
	jr l2953h		;2947	18 0a 	. . 
h_tab_set_bit1:
	ld c,002h		;2949	0e 02 	. . 
	jr l2936h		;294b	18 e9 	. . 
h_tab_clr_bit1:
	ld a,002h		;294d	3e 02 	> . 
	jr l2953h		;294f	18 02 	. . 
h_tab_clr_bit3:
	ld a,008h		;2951	3e 08 	> . 
l2953h:
	cpl			;2953	2f 	/ 
	ld c,a			;2954	4f 	O 
	jr l2937h		;2955	18 e0 	. . 
h_reverse_lf:
	ld a,(0ac09h)		;2957	3a 09 ac 	: . . 
	ld b,a			;295a	47 	G 
	ld a,(0abd8h)		;295b	3a d8 ab 	: . . 
	or b			;295e	b0 	. 
	jp nz,h_vt52_esc_A_up		;295f	c2 65 2f 	. e / 
	ld a,(ram_mode_flags)		;2962	3a 29 aa 	: ) . 
	and 088h		;2965	e6 88 	. . 
	ret nz			;2967	c0 	. 
	jp 01c6bh		;2968	c3 6b 1c 	. k . 
	xor a			;296b	af 	. 
	ld (0aa9dh),a		;296c	32 9d aa 	2 . . 
	ld a,029h		;296f	3e 29 	> ) 
	ld (06001h),a		;2971	32 01 60 	2 . ` 
	ret			;2974	c9 	. 
	ld a,0ffh		;2975	3e ff 	> . 
	ld (0aa9dh),a		;2977	32 9d aa 	2 . . 
sub_297ah:
	ld a,028h		;297a	3e 28 	> ( 
	ld (06001h),a		;297c	32 01 60 	2 . ` 
	ret			;297f	c9 	. 
	call sub_3f78h		;2980	cd 78 3f 	. x ? 
	rst 30h			;2983	f7 	. 
	ld a,020h		;2984	3e 20 	>   
	ld (0c000h),a		;2986	32 00 c0 	2 . . 
	ld a,010h		;2989	3e 10 	> . 
	ld (0d000h),a		;298b	32 00 d0 	2 . . 
	ld hl,(0ac1eh)		;298e	2a 1e ac 	* . . 
	call sub_297ah		;2991	cd 7a 29 	. z ) 
	ld a,(0ac1dh)		;2994	3a 1d ac 	: . . 
	ld c,a			;2997	4f 	O 
l2998h:
	ld a,(hl)			;2998	7e 	~ 
	bit 7,a		;2999	cb 7f 	.  
	jr nz,l29afh		;299b	20 12 	  . 
	push hl			;299d	e5 	. 
	call sub_3d35h		;299e	cd 35 3d 	. 5 = 
	pop hl			;29a1	e1 	. 
	ld b,050h		;29a2	06 50 	. P 
	ld (06004h),de		;29a4	ed 53 04 60 	. S . ` 
	ld a,0abh		;29a8	3e ab 	> . 
l29aah:
	ld (06001h),a		;29aa	32 01 60 	2 . ` 
	djnz l29aah		;29ad	10 fb 	. . 
l29afh:
	inc hl			;29af	23 	# 
	dec c			;29b0	0d 	. 
	jr nz,l2998h		;29b1	20 e5 	  . 
	call 00a27h		;29b3	cd 27 0a 	. ' . 
	jp h_vt52_esc_H_home		;29b6	c3 af 33 	. . 3 
	call sub_385bh		;29b9	cd 5b 38 	. [ 8 
	jp l3538h		;29bc	c3 38 35 	. 8 5 
	ld hl,0aa2ah		;29bf	21 2a aa 	! * . 
	set 5,(hl)		;29c2	cb ee 	. . 
	ret			;29c4	c9 	. 
	ld hl,0aa2ah		;29c5	21 2a aa 	! * . 
	res 5,(hl)		;29c8	cb ae 	. . 
	ret			;29ca	c9 	. 
	ret			;29cb	c9 	. 
	ld hl,0aa2ah		;29cc	21 2a aa 	! * . 
	set 4,(hl)		;29cf	cb e6 	. . 
	ret			;29d1	c9 	. 
	ld hl,0aa2ah		;29d2	21 2a aa 	! * . 
	res 4,(hl)		;29d5	cb a6 	. . 
	ret			;29d7	c9 	. 
	ld a,(0aa8ah)		;29d8	3a 8a aa 	: . . 
	and 010h		;29db	e6 10 	. . 
	call nz,sub_271bh		;29dd	c4 1b 27 	. . ' 
	ld a,(0abc5h)		;29e0	3a c5 ab 	: . . 
	and 004h		;29e3	e6 04 	. . 
	ret nz			;29e5	c0 	. 
	ld b,050h		;29e6	06 50 	. P 
	ld hl,0ab45h		;29e8	21 45 ab 	! E . 
	xor a			;29eb	af 	. 
l29ech:
	ld (hl),a			;29ec	77 	w 
	inc hl			;29ed	23 	# 
	djnz l29ech		;29ee	10 fc 	. . 
	ld hl,00000h		;29f0	21 00 00 	! . . 
	ld (0ad62h),hl		;29f3	22 62 ad 	" b . 
	ld hl,0ab45h		;29f6	21 45 ab 	! E . 
	ld (0ad64h),hl		;29f9	22 64 ad 	" d . 
	call 00d4bh		;29fc	cd 4b 0d 	. K . 
	ld a,(0aa8ah)		;29ff	3a 8a aa 	: . . 
	set 7,a		;2a02	cb ff 	. . 
	and 0a0h		;2a04	e6 a0 	. . 
	ld (0aa8ah),a		;2a06	32 8a aa 	2 . . 
	ld a,0ffh		;2a09	3e ff 	> . 
	ld (0ad61h),a		;2a0b	32 61 ad 	2 a . 
	ret			;2a0e	c9 	. 
h_vt52_esc_Z_identify:
	ld a,(0aa2bh)		;2a0f	3a 2b aa 	: + . 
	and 080h		;2a12	e6 80 	. . 
	ld hl,04f17h		;2a14	21 17 4f 	! . O 
	jr nz,l2a1ch		;2a17	20 03 	  . 
	ld hl,04f00h		;2a19	21 00 4f 	! . O 
l2a1ch:
	ld a,(hl)			;2a1c	7e 	~ 
	cp 03dh		;2a1d	fe 3d 	. = 
	jr z,l2a28h		;2a1f	28 07 	( . 
	ld c,a			;2a21	4f 	O 
	push hl			;2a22	e5 	. 
	rst 18h			;2a23	df 	. 
	pop hl			;2a24	e1 	. 
	inc hl			;2a25	23 	# 
	jr l2a1ch		;2a26	18 f4 	. . 
l2a28h:
	ld a,(0aa2bh)		;2a28	3a 2b aa 	: + . 
	and 080h		;2a2b	e6 80 	. . 
	ret z			;2a2d	c8 	. 
	ld c,02ch		;2a2e	0e 2c 	. , 
	rst 18h			;2a30	df 	. 
	ld a,(0abfah)		;2a31	3a fa ab 	: . . 
	add a,02fh		;2a34	c6 2f 	. / 
	ld c,a			;2a36	4f 	O 
	rst 18h			;2a37	df 	. 
	ret			;2a38	c9 	. 
h_page_counter_op:
	ld a,(0ad77h)		;2a39	3a 77 ad 	: w . 
	inc a			;2a3c	3c 	< 
	ld h,a			;2a3d	67 	g 
	ld l,000h		;2a3e	2e 00 	. . 
	ld (0abd7h),hl		;2a40	22 d7 ab 	" . . 
	call 0450ah		;2a43	cd 0a 45 	. . E 
	ld hl,00000h		;2a46	21 00 00 	! . . 
	ld d,045h		;2a49	16 45 	. E 
	ld e,l			;2a4b	5d 	] 
	ld a,(0ab27h)		;2a4c	3a 27 ab 	: ' . 
	ld c,a			;2a4f	4f 	O 
	jp 0454ah		;2a50	c3 4a 45 	. J E 
	call sub_2eb0h		;2a53	cd b0 2e 	. . . 
l2a56h:
	ld a,(0ac36h)		;2a56	3a 36 ac 	: 6 . 
	and a			;2a59	a7 	. 
	jp nz,00f03h		;2a5a	c2 03 0f 	. . . 
	ld a,(0abfah)		;2a5d	3a fa ab 	: . . 
	cp 001h		;2a60	fe 01 	. . 
	ret z			;2a62	c8 	. 
	cp 003h		;2a63	fe 03 	. . 
	ret z			;2a65	c8 	. 
	rrca			;2a66	0f 	. 
	ld (0abf9h),a		;2a67	32 f9 ab 	2 . . 
	ld a,018h		;2a6a	3e 18 	> . 
	ld (0ac0ah),a		;2a6c	32 0a ac 	2 . . 
	rlca			;2a6f	07 	. 
	ld (0ac1dh),a		;2a70	32 1d ac 	2 . . 
	ld hl,0aa2ah		;2a73	21 2a aa 	! * . 
	set 0,(hl)		;2a76	cb c6 	. . 
	xor a			;2a78	af 	. 
l2a79h:
	ld (0ad68h),a		;2a79	32 68 ad 	2 h . 
	ld (0ac09h),a		;2a7c	32 09 ac 	2 . . 
	ld a,001h		;2a7f	3e 01 	> . 
	ld (0abf8h),a		;2a81	32 f8 ab 	2 . . 
	ld b,060h		;2a84	06 60 	. ` 
	call sub_2ef2h		;2a86	cd f2 2e 	. . . 
	call sub_394eh		;2a89	cd 4e 39 	. N 9 
	call sub_3ceeh		;2a8c	cd ee 3c 	. . < 
	call 00f87h		;2a8f	cd 87 0f 	. . . 
	call l2f22h		;2a92	cd 22 2f 	. " / 
	call sub_31b8h		;2a95	cd b8 31 	. . 1 
	call l3d43h		;2a98	cd 43 3d 	. C = 
	jp l2ffah		;2a9b	c3 fa 2f 	. . / 
l2a9eh:
	ld hl,0aa2ah		;2a9e	21 2a aa 	! * . 
	res 0,(hl)		;2aa1	cb 86 	. . 
	ld a,(0abfah)		;2aa3	3a fa ab 	: . . 
	ld (0abf9h),a		;2aa6	32 f9 ab 	2 . . 
	ld a,018h		;2aa9	3e 18 	> . 
	ld (0ac1dh),a		;2aab	32 1d ac 	2 . . 
	xor a			;2aae	af 	. 
	ld (0ac0ah),a		;2aaf	32 0a ac 	2 . . 
	jr l2a79h		;2ab2	18 c5 	. . 
	ld hl,0aab7h		;2ab4	21 b7 aa 	! . . 
	set 6,(hl)		;2ab7	cb f6 	. . 
	ret			;2ab9	c9 	. 
l2abah:
	ld hl,0aab7h		;2aba	21 b7 aa 	! . . 
	res 6,(hl)		;2abd	cb b6 	. . 
	ret			;2abf	c9 	. 
	call sub_2eb0h		;2ac0	cd b0 2e 	. . . 
	call sub_2aeah		;2ac3	cd ea 2a 	. . * 
	jp l2b0fh		;2ac6	c3 0f 2b 	. . + 
l2ac9h:
	call sub_2eb0h		;2ac9	cd b0 2e 	. . . 
	call sub_2af9h		;2acc	cd f9 2a 	. . * 
	jp l2b0fh		;2acf	c3 0f 2b 	. . + 
	call sub_2eb0h		;2ad2	cd b0 2e 	. . . 
	call sub_2b05h		;2ad5	cd 05 2b 	. . + 
	call sub_2aeah		;2ad8	cd ea 2a 	. . * 
	jp l2b6ah		;2adb	c3 6a 2b 	. j + 
	call sub_2eb0h		;2ade	cd b0 2e 	. . . 
	call sub_2b05h		;2ae1	cd 05 2b 	. . + 
	call sub_2af9h		;2ae4	cd f9 2a 	. . * 
	jp l2b6ah		;2ae7	c3 6a 2b 	. j + 
sub_2aeah:
	ld hl,0abd0h		;2aea	21 d0 ab 	! . . 
	res 6,(hl)		;2aed	cb b6 	. . 
	ld hl,0ac28h		;2aef	21 28 ac 	! ( . 
	res 6,(hl)		;2af2	cb b6 	. . 
l2af4h:
	ld a,(hl)			;2af4	7e 	~ 
	ld (0d000h),a		;2af5	32 00 d0 	2 . . 
	ret			;2af8	c9 	. 
sub_2af9h:
	ld hl,0abd0h		;2af9	21 d0 ab 	! . . 
	set 6,(hl)		;2afc	cb f6 	. . 
	ld hl,0ac28h		;2afe	21 28 ac 	! ( . 
	set 6,(hl)		;2b01	cb f6 	. . 
	jr l2af4h		;2b03	18 ef 	. . 
sub_2b05h:
	ld a,(0aa2ah)		;2b05	3a 2a aa 	: * . 
	bit 0,a		;2b08	cb 47 	. G 
	ret z			;2b0a	c8 	. 
	pop hl			;2b0b	e1 	. 
	jp 00f03h		;2b0c	c3 03 0f 	. . . 
l2b0fh:
	call sub_3f78h		;2b0f	cd 78 3f 	. x ? 
	ld hl,0ac36h		;2b12	21 36 ac 	! 6 . 
	ld b,(hl)			;2b15	46 	F 
	xor a			;2b16	af 	. 
	cp b			;2b17	b8 	. 
	ret z			;2b18	c8 	. 
	ld hl,0acfeh		;2b19	21 fe ac 	! . . 
	ld c,a			;2b1c	4f 	O 
	ld a,(0abd8h)		;2b1d	3a d8 ab 	: . . 
	and a			;2b20	a7 	. 
	jr nz,l2b2eh		;2b21	20 0b 	  . 
	ld a,(0ac35h)		;2b23	3a 35 ac 	: 5 . 
	and a			;2b26	a7 	. 
	ret z			;2b27	c8 	. 
	xor a			;2b28	af 	. 
	ld (0aab0h),a		;2b29	32 b0 aa 	2 . . 
	jr l2b49h		;2b2c	18 1b 	. . 
l2b2eh:
	dec a			;2b2e	3d 	= 
l2b2fh:
	cp (hl)			;2b2f	be 	. 
	jr z,l2b37h		;2b30	28 05 	( . 
	inc hl			;2b32	23 	# 
	inc c			;2b33	0c 	. 
	djnz l2b2fh		;2b34	10 f9 	. . 
	ret			;2b36	c9 	. 
l2b37h:
	dec b			;2b37	05 	. 
	jr nz,l2b3eh		;2b38	20 04 	  . 
	ld (hl),0ffh		;2b3a	36 ff 	6 . 
	jr l2b49h		;2b3c	18 0b 	. . 
l2b3eh:
	ld c,b			;2b3e	48 	H 
	ld b,000h		;2b3f	06 00 	. . 
	ld d,h			;2b41	54 	T 
	ld e,l			;2b42	5d 	] 
	inc hl			;2b43	23 	# 
	ldir		;2b44	ed b0 	. . 
	ld a,0ffh		;2b46	3e ff 	> . 
	ld (de),a			;2b48	12 	. 
l2b49h:
	ld hl,0ab27h		;2b49	21 27 ab 	! ' . 
	inc (hl)			;2b4c	34 	4 
	ld d,000h		;2b4d	16 00 	. . 
	ld e,(hl)			;2b4f	5e 	^ 
	ld hl,(0ac1eh)		;2b50	2a 1e ac 	* . . 
	add hl,de			;2b53	19 	. 
	ld a,(hl)			;2b54	7e 	~ 
	call sub_3d84h		;2b55	cd 84 3d 	. . = 
	ld a,(0aab0h)		;2b58	3a b0 aa 	: . . 
	ld (0ac35h),a		;2b5b	32 35 ac 	2 5 . 
	ld hl,0ac39h		;2b5e	21 39 ac 	! 9 . 
	ld (hl),002h		;2b61	36 02 	6 . 
l2b63h:
	ld a,(hl)			;2b63	7e 	~ 
	and a			;2b64	a7 	. 
	jr nz,l2b63h		;2b65	20 fc 	  . 
	jp l3d43h		;2b67	c3 43 3d 	. C = 
l2b6ah:
	call sub_3f78h		;2b6a	cd 78 3f 	. x ? 
	ld b,000h		;2b6d	06 00 	. . 
	ld a,(0ac36h)		;2b6f	3a 36 ac 	: 6 . 
	ld c,a			;2b72	4f 	O 
	and a			;2b73	a7 	. 
	jr z,l2b77h		;2b74	28 01 	( . 
	dec c			;2b76	0d 	. 
l2b77h:
	ld a,(0ac35h)		;2b77	3a 35 ac 	: 5 . 
	and a			;2b7a	a7 	. 
	jr z,l2b7eh		;2b7b	28 01 	( . 
	dec c			;2b7d	0d 	. 
l2b7eh:
	ld hl,0acfeh		;2b7e	21 fe ac 	! . . 
	add hl,bc			;2b81	09 	. 
	ld a,(hl)			;2b82	7e 	~ 
	inc a			;2b83	3c 	< 
	ld hl,0ab27h		;2b84	21 27 ab 	! ' . 
	cp (hl)			;2b87	be 	. 
	ret z			;2b88	c8 	. 
	jp nc,00f03h		;2b89	d2 03 0f 	. . . 
	ld a,(0abd8h)		;2b8c	3a d8 ab 	: . . 
	ld hl,0acfeh		;2b8f	21 fe ac 	! . . 
	and a			;2b92	a7 	. 
	jr nz,l2ba3h		;2b93	20 0e 	  . 
	ld a,(0ac35h)		;2b95	3a 35 ac 	: 5 . 
	and a			;2b98	a7 	. 
	ret nz			;2b99	c0 	. 
	cpl			;2b9a	2f 	/ 
	ld (0aab0h),a		;2b9b	32 b0 aa 	2 . . 
	ld hl,0ab27h		;2b9e	21 27 ab 	! ' . 
	jr l2bf5h		;2ba1	18 52 	. R 
l2ba3h:
	dec a			;2ba3	3d 	= 
l2ba4h:
	cp (hl)			;2ba4	be 	. 
	jr c,l2babh		;2ba5	38 04 	8 . 
	ret z			;2ba7	c8 	. 
	inc hl			;2ba8	23 	# 
	jr l2ba4h		;2ba9	18 f9 	. . 
l2babh:
	ex de,hl			;2bab	eb 	. 
	ld hl,0acfeh		;2bac	21 fe ac 	! . . 
	ld bc,0000ch		;2baf	01 0c 00 	. . . 
	add hl,bc			;2bb2	09 	. 
	push hl			;2bb3	e5 	. 
	and a			;2bb4	a7 	. 
	sbc hl,de		;2bb5	ed 52 	. R 
	ld b,h			;2bb7	44 	D 
	ld c,l			;2bb8	4d 	M 
	pop hl			;2bb9	e1 	. 
	ld d,h			;2bba	54 	T 
	ld e,l			;2bbb	5d 	] 
	dec hl			;2bbc	2b 	+ 
	lddr		;2bbd	ed b8 	. . 
	push af			;2bbf	f5 	. 
	ld hl,0ab27h		;2bc0	21 27 ab 	! ' . 
	ld a,(0abd8h)		;2bc3	3a d8 ab 	: . . 
	cp (hl)			;2bc6	be 	. 
	jr nz,l2bf3h		;2bc7	20 2a 	  * 
	pop af			;2bc9	f1 	. 
	ld hl,0abd8h		;2bca	21 d8 ab 	! . . 
	dec (hl)			;2bcd	35 	5 
	ld hl,0aa2ah		;2bce	21 2a aa 	! * . 
	set 2,(hl)		;2bd1	cb d6 	. . 
	bit 1,(hl)		;2bd3	cb 4e 	. N 
	jr z,l2beeh		;2bd5	28 17 	( . 
	ld a,(0ab2dh)		;2bd7	3a 2d ab 	: - . 
	ld hl,0ab27h		;2bda	21 27 ab 	! ' . 
	cp (hl)			;2bdd	be 	. 
	jr nz,l2beeh		;2bde	20 0e 	  . 
	ld a,(0ac07h)		;2be0	3a 07 ac 	: . . 
	cp 001h		;2be3	fe 01 	. . 
	jp z,00f03h		;2be5	ca 03 0f 	. . . 
	call sub_3f56h		;2be8	cd 56 3f 	. V ? 
l2bebh:
	jp l2b6ah		;2beb	c3 6a 2b 	. j + 
l2beeh:
	call sub_3e9eh		;2bee	cd 9e 3e 	. . > 
	jr l2bebh		;2bf1	18 f8 	. . 
l2bf3h:
	pop af			;2bf3	f1 	. 
	ld (de),a			;2bf4	12 	. 
l2bf5h:
	ld d,000h		;2bf5	16 00 	. . 
	ld e,(hl)			;2bf7	5e 	^ 
	dec (hl)			;2bf8	35 	5 
	ld hl,(0ac1eh)		;2bf9	2a 1e ac 	* . . 
	add hl,de			;2bfc	19 	. 
	ld a,(hl)			;2bfd	7e 	~ 
	ld a,(0aab0h)		;2bfe	3a b0 aa 	: . . 
	ld (0ac35h),a		;2c01	32 35 ac 	2 5 . 
	ld hl,0ac39h		;2c04	21 39 ac 	! 9 . 
	ld (hl),001h		;2c07	36 01 	6 . 
l2c09h:
	ld a,(hl)			;2c09	7e 	~ 
	and a			;2c0a	a7 	. 
	jr nz,l2c09h		;2c0b	20 fc 	  . 
	call l3d43h		;2c0d	cd 43 3d 	. C = 
	ld a,(0aa2ah)		;2c10	3a 2a aa 	: * . 
	bit 1,a		;2c13	cb 4f 	. O 
	ret z			;2c15	c8 	. 
	ld a,(0ab27h)		;2c16	3a 27 ab 	: ' . 
	ld hl,0ab2dh		;2c19	21 2d ab 	! - . 
	cp (hl)			;2c1c	be 	. 
	ret nc			;2c1d	d0 	. 
	ld (hl),a			;2c1e	77 	w 
	ld hl,0ab2eh		;2c1f	21 2e ab 	! . . 
	cp (hl)			;2c22	be 	. 
	ret nc			;2c23	d0 	. 
	ld (hl),000h		;2c24	36 00 	6 . 
	ld hl,0aa2ah		;2c26	21 2a aa 	! * . 
	res 1,(hl)		;2c29	cb 8e 	. . 
	jp 00f87h		;2c2b	c3 87 0f 	. . . 
l2c2eh:
	call sub_2f1ah		;2c2e	cd 1a 2f 	. . / 
	ld hl,0aabdh		;2c31	21 bd aa 	! . . 
	set 1,(hl)		;2c34	cb ce 	. . 
	ld hl,0500ch		;2c36	21 0c 50 	! . P 
	set 1,(hl)		;2c39	cb ce 	. . 
	jp sub_394eh		;2c3b	c3 4e 39 	. N 9 
	call sub_2f1ah		;2c3e	cd 1a 2f 	. . / 
	ld hl,0aabdh		;2c41	21 bd aa 	! . . 
	res 1,(hl)		;2c44	cb 8e 	. . 
	ld hl,0500ch		;2c46	21 0c 50 	! . P 
	res 1,(hl)		;2c49	cb 8e 	. . 
	jp sub_394eh		;2c4b	c3 4e 39 	. N 9 
	ld hl,0aa2ah		;2c4e	21 2a aa 	! * . 
	res 1,(hl)		;2c51	cb 8e 	. . 
	ld a,(0ab27h)		;2c53	3a 27 ab 	: ' . 
	ld (0ab2dh),a		;2c56	32 2d ab 	2 - . 
	xor a			;2c59	af 	. 
	ld (0ab2eh),a		;2c5a	32 2e ab 	2 . . 
	jp 00f87h		;2c5d	c3 87 0f 	. . . 
	ld a,(ram_mode_flags)		;2c60	3a 29 aa 	: ) . 
	and 040h		;2c63	e6 40 	. @ 
	ret nz			;2c65	c0 	. 
	call sub_3648h		;2c66	cd 48 36 	. H 6 
	call 04edch		;2c69	cd dc 4e 	. . N 
	jp 04e85h		;2c6c	c3 85 4e 	. . N 
l2c6fh:
	ld c,000h		;2c6f	0e 00 	. . 
	jr l2c75h		;2c71	18 02 	. . 
l2c73h:
	ld c,001h		;2c73	0e 01 	. . 
l2c75h:
	jp 01d4eh		;2c75	c3 4e 1d 	. N . 
	ret			;2c78	c9 	. 
	ld c,057h		;2c79	0e 57 	. W 
	jp 01475h		;2c7b	c3 75 14 	. u . 
l2c7eh:
	ld a,(0aabah)		;2c7e	3a ba aa 	: . . 
	bit 3,a		;2c81	cb 5f 	. _ 
	jp z,l26f7h		;2c83	ca f7 26 	. . & 
	jp l26feh		;2c86	c3 fe 26 	. . & 
	cp 094h		;2c89	fe 94 	. . 
	jr nc,l2c93h		;2c8b	30 06 	0 . 
	sub 080h		;2c8d	d6 80 	. . 
	ld c,a			;2c8f	4f 	O 
	jp l3720h		;2c90	c3 20 37 	.   7 
l2c93h:
	cp 0a0h		;2c93	fe a0 	. . 
	ret c			;2c95	d8 	. 
	cp 0ach		;2c96	fe ac 	. . 
	jp c,04d7fh		;2c98	da 7f 4d 	.  M 
	cp 0c0h		;2c9b	fe c0 	. . 
	jr c,l2ce8h		;2c9d	38 49 	8 I 
	cp 0f0h		;2c9f	fe f0 	. . 
	jr nc,l2cbdh		;2ca1	30 1a 	0 . 
	cp 0dfh		;2ca3	fe df 	. . 
	ret z			;2ca5	c8 	. 
	jp nc,00ad6h		;2ca6	d2 d6 0a 	. . . 
	cp 0dbh		;2ca9	fe db 	. . 
	ld c,a			;2cab	4f 	O 
	ld b,000h		;2cac	06 00 	. . 
	jr nc,l2cc5h		;2cae	30 15 	0 . 
	ld a,(0aa2bh)		;2cb0	3a 2b aa 	: + . 
	and 020h		;2cb3	e6 20 	.   
	ld a,c			;2cb5	79 	y 
	jr nz,l2cd7h		;2cb6	20 1f 	  . 
l2cb8h:
	sub 0c0h		;2cb8	d6 c0 	. . 
	jp 00bbdh		;2cba	c3 bd 0b 	. . . 
l2cbdh:
	cp 0fch		;2cbd	fe fc 	. . 
	ret nc			;2cbf	d0 	. 
	sub 050h		;2cc0	d6 50 	. P 
	jp 04d7fh		;2cc2	c3 7f 4d 	.  M 
l2cc5h:
	ld a,(0aa2bh)		;2cc5	3a 2b aa 	: + . 
	and 080h		;2cc8	e6 80 	. . 
	ret z			;2cca	c8 	. 
	ld a,c			;2ccb	79 	y 
	sub 0dbh		;2ccc	d6 db 	. . 
	ld hl,l2d06h		;2cce	21 06 2d 	! . - 
	ld c,a			;2cd1	4f 	O 
	add hl,bc			;2cd2	09 	. 
	ld c,(hl)			;2cd3	4e 	N 
	jp 00bf2h		;2cd4	c3 f2 0b 	. . . 
l2cd7h:
	ld a,c			;2cd7	79 	y 
	cp 0d5h		;2cd8	fe d5 	. . 
	jr c,l2cb8h		;2cda	38 dc 	8 . 
	sub 0d5h		;2cdc	d6 d5 	. . 
	rrca			;2cde	0f 	. 
	ld c,a			;2cdf	4f 	O 
	ld hl,l2d0ah		;2ce0	21 0a 2d 	! . - 
	add hl,bc			;2ce3	09 	. 
	ld c,(hl)			;2ce4	4e 	N 
	jp 00c27h		;2ce5	c3 27 0c 	. ' . 
l2ce8h:
	cp 0adh		;2ce8	fe ad 	. . 
	jr z,l2cf4h		;2cea	28 08 	( . 
	sub 0ach		;2cec	d6 ac 	. . 
	ld hl,l2228h		;2cee	21 28 22 	! ( " 
	jp 00abdh		;2cf1	c3 bd 0a 	. . . 
l2cf4h:
	ld c,a			;2cf4	4f 	O 
	ld hl,00400h		;2cf5	21 00 04 	! . . 
	rst 20h			;2cf8	e7 	. 
	jr nz,l2d01h		;2cf9	20 06 	  . 
	ld a,c			;2cfb	79 	y 
	sub 0a0h		;2cfc	d6 a0 	. . 
	jp 00bbdh		;2cfe	c3 bd 0b 	. . . 
l2d01h:
	ld c,00eh		;2d01	0e 0e 	. . 
	jp 01873h		;2d03	c3 73 18 	. s . 
l2d06h:
	ld c,(hl)			;2d06	4e 	N 
	ld c,a			;2d07	4f 	O 
	ld (hl),c			;2d08	71 	q 
	ld (hl),d			;2d09	72 	r 
l2d0ah:
	ld d,b			;2d0a	50 	P 
	ld d,c			;2d0b	51 	Q 
	ld d,d			;2d0c	52 	R 
	ld a,(0aa2bh)		;2d0d	3a 2b aa 	: + . 
	and 080h		;2d10	e6 80 	. . 
	jr z,l2d1bh		;2d12	28 07 	( . 
	ld a,(0abe9h)		;2d14	3a e9 ab 	: . . 
l2d17h:
	ld c,a			;2d17	4f 	O 
	jp 00bf2h		;2d18	c3 f2 0b 	. . . 
l2d1bh:
	ld hl,0aab7h		;2d1b	21 b7 aa 	! . . 
	res 4,(hl)		;2d1e	cb a6 	. . 
	res 5,(hl)		;2d20	cb ae 	. . 
	ld a,(0abc5h)		;2d22	3a c5 ab 	: . . 
	bit 0,a		;2d25	cb 47 	. G 
	ret z			;2d27	c8 	. 
	and 0feh		;2d28	e6 fe 	. . 
	or 018h		;2d2a	f6 18 	. . 
	ld (0abc5h),a		;2d2c	32 c5 ab 	2 . . 
	bit 2,a		;2d2f	cb 57 	. W 
	jp z,00e5ch		;2d31	ca 5c 0e 	. \ . 
	call 00f0dh		;2d34	cd 0d 0f 	. . . 
	jr l2d59h		;2d37	18 20 	.   
	ld a,(0aa2bh)		;2d39	3a 2b aa 	: + . 
	and 080h		;2d3c	e6 80 	. . 
	jr z,l2d45h		;2d3e	28 05 	( . 
	ld a,(0abeah)		;2d40	3a ea ab 	: . . 
	jr l2d17h		;2d43	18 d2 	. . 
l2d45h:
	ld hl,0aab7h		;2d45	21 b7 aa 	! . . 
	set 4,(hl)		;2d48	cb e6 	. . 
	set 5,(hl)		;2d4a	cb ee 	. . 
	ld a,(0abc5h)		;2d4c	3a c5 ab 	: . . 
	bit 0,a		;2d4f	cb 47 	. G 
	ret nz			;2d51	c0 	. 
	and 0e7h		;2d52	e6 e7 	. . 
	or 001h		;2d54	f6 01 	. . 
	ld (0abc5h),a		;2d56	32 c5 ab 	2 . . 
l2d59h:
	jp 00d4bh		;2d59	c3 4b 0d 	. K . 
	call sub_3bedh		;2d5c	cd ed 3b 	. . ; 
	jr l2d70h		;2d5f	18 0f 	. . 
	call sub_3c21h		;2d61	cd 21 3c 	. ! < 
	ld a,001h		;2d64	3e 01 	> . 
	jr l2d72h		;2d66	18 0a 	. . 
	call sub_3c67h		;2d68	cd 67 3c 	. g < 
	jr l2d70h		;2d6b	18 03 	. . 
	call sub_3c6ch		;2d6d	cd 6c 3c 	. l < 
l2d70h:
	ld a,0ffh		;2d70	3e ff 	> . 
l2d72h:
	push af			;2d72	f5 	. 
	jp l2ff9h		;2d73	c3 f9 2f 	. . / 
l2d76h:
	call sub_2eb8h		;2d76	cd b8 2e 	. . . 
	rst 10h			;2d79	d7 	. 
	ld (06004h),hl		;2d7a	22 04 60 	" . ` 
	call 0179ch		;2d7d	cd 9c 17 	. . . 
	ld a,(0d000h)		;2d80	3a 00 d0 	: . . 
	bit 5,a		;2d83	cb 6f 	. o 
	ld a,(ram_tab_flags)		;2d85	3a 18 ac 	: . . 
	jr z,l2dc0h		;2d88	28 36 	( 6 
	and a			;2d8a	a7 	. 
	ld a,(0c000h)		;2d8b	3a 00 c0 	: . . 
	ld d,a			;2d8e	57 	W 
	jr nz,l2db3h		;2d8f	20 22 	  " 
	ld a,005h		;2d91	3e 05 	> . 
	and c			;2d93	a1 	. 
	jr z,l2d9ah		;2d94	28 04 	( . 
	ld a,d			;2d96	7a 	z 
	or c			;2d97	b1 	. 
	jr l2db4h		;2d98	18 1a 	. . 
l2d9ah:
	ld a,d			;2d9a	7a 	z 
	and 005h		;2d9b	e6 05 	. . 
	jr z,l2da5h		;2d9d	28 06 	( . 
	ld a,d			;2d9f	7a 	z 
	and 0fah		;2da0	e6 fa 	. . 
	or c			;2da2	b1 	. 
	jr l2db4h		;2da3	18 0f 	. . 
l2da5h:
	ld a,d			;2da5	7a 	z 
	or c			;2da6	b1 	. 
	ld e,a			;2da7	5f 	_ 
	ld a,(ram_attr_subsel)		;2da8	3a 19 ac 	: . . 
	and 005h		;2dab	e6 05 	. . 
	or e			;2dad	b3 	. 
	ld (ram_attr_subsel),a		;2dae	32 19 ac 	2 . . 
	jr l2db8h		;2db1	18 05 	. . 
l2db3h:
	and c			;2db3	a1 	. 
l2db4h:
	ld (ram_attr_subsel),a		;2db4	32 19 ac 	2 . . 
	ld e,a			;2db7	5f 	_ 
l2db8h:
	call sub_2e01h		;2db8	cd 01 2e 	. . . 
	call sub_2e17h		;2dbb	cd 17 2e 	. . . 
	jr l2df4h		;2dbe	18 34 	. 4 
l2dc0h:
	and a			;2dc0	a7 	. 
	jr nz,l2dd9h		;2dc1	20 16 	  . 
	ld a,005h		;2dc3	3e 05 	> . 
	and c			;2dc5	a1 	. 
	jr z,l2dcbh		;2dc6	28 03 	( . 
	ld a,c			;2dc8	79 	y 
	jr l2ddah		;2dc9	18 0f 	. . 
l2dcbh:
	ld e,c			;2dcb	59 	Y 
	ld a,(0d000h)		;2dcc	3a 00 d0 	: . . 
	and 005h		;2dcf	e6 05 	. . 
	and 0f5h		;2dd1	e6 f5 	. . 
	or c			;2dd3	b1 	. 
	ld (ram_attr_subsel),a		;2dd4	32 19 ac 	2 . . 
	jr l2ddeh		;2dd7	18 05 	. . 
l2dd9h:
	xor a			;2dd9	af 	. 
l2ddah:
	ld e,a			;2dda	5f 	_ 
	ld (ram_attr_subsel),a		;2ddb	32 19 ac 	2 . . 
l2ddeh:
	call sub_2e01h		;2dde	cd 01 2e 	. . . 
	ld hl,(0ac14h)		;2de1	2a 14 ac 	* . . 
	ld (06004h),hl		;2de4	22 04 60 	" . ` 
	call 0179ch		;2de7	cd 9c 17 	. . . 
	ld a,(0d000h)		;2dea	3a 00 d0 	: . . 
	cp c			;2ded	b9 	. 
	call nz,sub_2e17h		;2dee	c4 17 2e 	. . . 
	call sub_2ea8h		;2df1	cd a8 2e 	. . . 
l2df4h:
	ld hl,(0ac14h)		;2df4	2a 14 ac 	* . . 
	ld (06004h),hl		;2df7	22 04 60 	" . ` 
	ld a,(0ac16h)		;2dfa	3a 16 ac 	: . . 
	ld (0aab7h),a		;2dfd	32 b7 aa 	2 . . 
	ret			;2e00	c9 	. 
sub_2e01h:
	ld d,021h		;2e01	16 21 	. ! 
	ld a,(0ac28h)		;2e03	3a 28 ac 	: ( . 
	and 010h		;2e06	e6 10 	. . 
	jr z,l2e0ch		;2e08	28 02 	( . 
	set 4,d		;2e0a	cb e2 	. . 
l2e0ch:
	rst 10h			;2e0c	d7 	. 
	ld hl,(0ac12h)		;2e0d	2a 12 ac 	* . . 
	ld (06006h),hl		;2e10	22 06 60 	" . ` 
	call 01777h		;2e13	cd 77 17 	. w . 
	rst 10h			;2e16	d7 	. 
sub_2e17h:
	push af			;2e17	f5 	. 
	push bc			;2e18	c5 	. 
	push hl			;2e19	e5 	. 
	rst 10h			;2e1a	d7 	. 
	call sub_3e96h		;2e1b	cd 96 3e 	. . > 
	ld hl,(0abd7h)		;2e1e	2a d7 ab 	* . . 
	push hl			;2e21	e5 	. 
	call 0450ah		;2e22	cd 0a 45 	. . E 
	ld hl,0abd8h		;2e25	21 d8 ab 	! . . 
	ld a,(0ab27h)		;2e28	3a 27 ab 	: ' . 
	inc a			;2e2b	3c 	< 
	sub (hl)			;2e2c	96 	. 
	ld (0ac1ah),a		;2e2d	32 1a ac 	2 . . 
	ld a,(hl)			;2e30	7e 	~ 
	rlca			;2e31	07 	. 
	ld d,000h		;2e32	16 00 	. . 
	ld e,a			;2e34	5f 	_ 
	ld hl,0a951h		;2e35	21 51 a9 	! Q . 
	add hl,de			;2e38	19 	. 
	inc hl			;2e39	23 	# 
	inc hl			;2e3a	23 	# 
	ld (0ac1bh),hl		;2e3b	22 1b ac 	" . . 
	ld hl,0abd7h		;2e3e	21 d7 ab 	! . . 
	ld a,050h		;2e41	3e 50 	> P 
	sub (hl)			;2e43	96 	. 
	ld b,a			;2e44	47 	G 
	ld a,(0aabdh)		;2e45	3a bd aa 	: . . 
	bit 1,a		;2e48	cb 4f 	. O 
	jr z,l2e51h		;2e4a	28 05 	( . 
	ld a,001h		;2e4c	3e 01 	> . 
	ld (0ac1ah),a		;2e4e	32 1a ac 	2 . . 
l2e51h:
	call 0179ch		;2e51	cd 9c 17 	. . . 
	ld a,(0d000h)		;2e54	3a 00 d0 	: . . 
	ld e,a			;2e57	5f 	_ 
	bit 5,a		;2e58	cb 6f 	. o 
	jr nz,l2e94h		;2e5a	20 38 	  8 
	and 06fh		;2e5c	e6 6f 	. o 
	ld d,a			;2e5e	57 	W 
	ld a,(ram_attr_subsel)		;2e5f	3a 19 ac 	: . . 
	cp d			;2e62	ba 	. 
	jr z,l2e94h		;2e63	28 2f 	( / 
	ld d,a			;2e65	57 	W 
	ld a,e			;2e66	7b 	{ 
	and 090h		;2e67	e6 90 	. . 
	or d			;2e69	b2 	. 
	ld (0d000h),a		;2e6a	32 00 d0 	2 . . 
	ld a,(0c000h)		;2e6d	3a 00 c0 	: . . 
	ld (0c000h),a		;2e70	32 00 c0 	2 . . 
	ld a,0abh		;2e73	3e ab 	> . 
	ld (06001h),a		;2e75	32 01 60 	2 . ` 
	djnz l2e51h		;2e78	10 d7 	. . 
	rst 10h			;2e7a	d7 	. 
	ld hl,0ac1ah		;2e7b	21 1a ac 	! . . 
	dec (hl)			;2e7e	35 	5 
	jp z,l2e94h		;2e7f	ca 94 2e 	. . . 
	ld b,050h		;2e82	06 50 	. P 
	ld hl,(0ac1bh)		;2e84	2a 1b ac 	* . . 
	ld e,(hl)			;2e87	5e 	^ 
	inc hl			;2e88	23 	# 
	ld d,(hl)			;2e89	56 	V 
	ld (06004h),de		;2e8a	ed 53 04 60 	. S . ` 
	inc hl			;2e8e	23 	# 
	ld (0ac1bh),hl		;2e8f	22 1b ac 	" . . 
	jr l2e51h		;2e92	18 bd 	. . 
l2e94h:
	ld a,(0ad78h)		;2e94	3a 78 ad 	: x . 
	and a			;2e97	a7 	. 
	call nz,sub_2ea8h		;2e98	c4 a8 2e 	. . . 
	ld a,0ffh		;2e9b	3e ff 	> . 
	ld (0ad78h),a		;2e9d	32 78 ad 	2 x . 
	pop hl			;2ea0	e1 	. 
	ld (0abd7h),hl		;2ea1	22 d7 ab 	" . . 
	pop hl			;2ea4	e1 	. 
	pop bc			;2ea5	c1 	. 
	pop af			;2ea6	f1 	. 
	ret			;2ea7	c9 	. 
sub_2ea8h:
	push af			;2ea8	f5 	. 
	ld a,031h		;2ea9	3e 31 	> 1 
	ld (06001h),a		;2eab	32 01 60 	2 . ` 
	pop af			;2eae	f1 	. 
	ret			;2eaf	c9 	. 
sub_2eb0h:
	ld a,(0aa2bh)		;2eb0	3a 2b aa 	: + . 
	and 001h		;2eb3	e6 01 	. . 
	ret nz			;2eb5	c0 	. 
	pop hl			;2eb6	e1 	. 
	ret			;2eb7	c9 	. 
sub_2eb8h:
	ld a,(0aab7h)		;2eb8	3a b7 aa 	: . . 
	ld (0ac16h),a		;2ebb	32 16 ac 	2 . . 
	and 07fh		;2ebe	e6 7f 	.  
	ld (0aab7h),a		;2ec0	32 b7 aa 	2 . . 
	rst 10h			;2ec3	d7 	. 
	ld hl,(06004h)		;2ec4	2a 04 60 	* . ` 
	ld a,(0aa2bh)		;2ec7	3a 2b aa 	: + . 
	and 080h		;2eca	e6 80 	. . 
	call z,016f7h		;2ecc	cc f7 16 	. . . 
	push hl			;2ecf	e5 	. 
	push bc			;2ed0	c5 	. 
	push de			;2ed1	d5 	. 
	call sub_3085h		;2ed2	cd 85 30 	. . 0 
	call sub_2f46h		;2ed5	cd 46 2f 	. F / 
	pop de			;2ed8	d1 	. 
	pop bc			;2ed9	c1 	. 
	ld (0ac14h),hl		;2eda	22 14 ac 	" . . 
	pop hl			;2edd	e1 	. 
	ld (0ac12h),hl		;2ede	22 12 ac 	" . . 
	ret			;2ee1	c9 	. 
attr_table:
	nop			;2ee2	00 	. 
	ld bc,00504h		;2ee3	01 04 05 	. . . 
	ex af,af'			;2ee6	08 	. 
	add hl,bc			;2ee7	09 	. 
	inc c			;2ee8	0c 	. 
	dec c			;2ee9	0d 	. 
	ld (bc),a			;2eea	02 	. 
	inc bc			;2eeb	03 	. 
	ld b,007h		;2eec	06 07 	. . 
	ld a,(bc)			;2eee	0a 	. 
	dec bc			;2eef	0b 	. 
	ld c,00fh		;2ef0	0e 0f 	. . 
sub_2ef2h:
	push bc			;2ef2	c5 	. 
	call sub_2866h		;2ef3	cd 66 28 	. f ( 
	pop bc			;2ef6	c1 	. 
	ld hl,0aac7h		;2ef7	21 c7 aa 	! . . 
	ld (0ac1eh),hl		;2efa	22 1e ac 	" . . 
	ld a,(0ab2fh)		;2efd	3a 2f ab 	: / . 
	push af			;2f00	f5 	. 
	ld a,020h		;2f01	3e 20 	>   
	ld (0ab2fh),a		;2f03	32 2f ab 	2 / . 
	xor a			;2f06	af 	. 
	ld (0ad79h),a		;2f07	32 79 ad 	2 y . 
	ld (0ac09h),a		;2f0a	32 09 ac 	2 . . 
l2f0dh:
	ld (hl),a			;2f0d	77 	w 
	call sub_3d84h		;2f0e	cd 84 3d 	. . = 
	inc a			;2f11	3c 	< 
	inc hl			;2f12	23 	# 
	djnz l2f0dh		;2f13	10 f8 	. . 
	pop af			;2f15	f1 	. 
	ld (0ab2fh),a		;2f16	32 2f ab 	2 / . 
	ret			;2f19	c9 	. 
sub_2f1ah:
	ld a,(0aa2bh)		;2f1a	3a 2b aa 	: + . 
	and 080h		;2f1d	e6 80 	. . 
	ret nz			;2f1f	c0 	. 
	pop hl			;2f20	e1 	. 
	ret			;2f21	c9 	. 
l2f22h:
	xor a			;2f22	af 	. 
	call 041dfh		;2f23	cd df 41 	. . A 
	ex de,hl			;2f26	eb 	. 
	ld a,(0ab27h)		;2f27	3a 27 ab 	: ' . 
	call 041dfh		;2f2a	cd df 41 	. . A 
	call 041f4h		;2f2d	cd f4 41 	. . A 
	and a			;2f30	a7 	. 
	sbc hl,de		;2f31	ed 52 	. R 
	ld a,l			;2f33	7d 	} 
	inc a			;2f34	3c 	< 
	ld (0ad76h),a		;2f35	32 76 ad 	2 v . 
	ld h,d			;2f38	62 	b 
	ld l,e			;2f39	6b 	k 
	call 041eeh		;2f3a	cd ee 41 	. . A 
	and a			;2f3d	a7 	. 
	sbc hl,de		;2f3e	ed 52 	. R 
	ld a,l			;2f40	7d 	} 
	dec a			;2f41	3d 	= 
	ld (0ad77h),a		;2f42	32 77 ad 	2 w . 
	ret			;2f45	c9 	. 
sub_2f46h:
	ld a,(0abd8h)		;2f46	3a d8 ab 	: . . 
	call sub_3d20h		;2f49	cd 20 3d 	.   = 
	ld a,(0abd7h)		;2f4c	3a d7 ab 	: . . 
	ld l,a			;2f4f	6f 	o 
	ld h,000h		;2f50	26 00 	& . 
	add hl,de			;2f52	19 	. 
	ret			;2f53	c9 	. 
h_vt52_esc_C_right:
	ld b,001h		;2f54	06 01 	. . 
	jp l2f75h		;2f56	c3 75 2f 	. u / 
h_vt52_esc_D_left:
	ld b,0ffh		;2f59	06 ff 	. . 
	xor a			;2f5b	af 	. 
	ld (0ac22h),a		;2f5c	32 22 ac 	2 " . 
	jr l2f75h		;2f5f	18 14 	. . 
h_vt52_esc_B_down:
	ld b,001h		;2f61	06 01 	. . 
	jr l2f67h		;2f63	18 02 	. . 
h_vt52_esc_A_up:
	ld b,0ffh		;2f65	06 ff 	. . 
l2f67h:
	ld hl,0abd8h		;2f67	21 d8 ab 	! . . 
	ld a,(hl)			;2f6a	7e 	~ 
	add a,b			;2f6b	80 	. 
	ld (hl),a			;2f6c	77 	w 
	push bc			;2f6d	c5 	. 
	ld a,001h		;2f6e	3e 01 	> . 
	cp b			;2f70	b8 	. 
	jr z,l2faeh		;2f71	28 3b 	( ; 
	jr l2fdbh		;2f73	18 66 	. f 
l2f75h:
	ld a,(0abd7h)		;2f75	3a d7 ab 	: . . 
	add a,b			;2f78	80 	. 
	ld (0abd7h),a		;2f79	32 d7 ab 	2 . . 
	cp 0ffh		;2f7c	fe ff 	. . 
	jr z,l2fa0h		;2f7e	28 20 	(   
	cp 050h		;2f80	fe 50 	. P 
	jr nz,l2ffah		;2f82	20 76 	  v 
	ld a,(0ad68h)		;2f84	3a 68 ad 	: h . 
	and a			;2f87	a7 	. 
	jr z,l2f91h		;2f88	28 07 	( . 
	xor a			;2f8a	af 	. 
	ld (0abd7h),a		;2f8b	32 d7 ab 	2 . . 
	jp h_vt52_esc_B_down		;2f8e	c3 61 2f 	. a / 
l2f91h:
	ld a,(0aab7h)		;2f91	3a b7 aa 	: . . 
	bit 7,a		;2f94	cb 7f 	.  
	jr z,l2fa0h		;2f96	28 08 	( . 
	ld a,(0abd7h)		;2f98	3a d7 ab 	: . . 
	sub b			;2f9b	90 	. 
	ld (0abd7h),a		;2f9c	32 d7 ab 	2 . . 
	ret			;2f9f	c9 	. 
l2fa0h:
	push bc			;2fa0	c5 	. 
	ld a,0ffh		;2fa1	3e ff 	> . 
	cp b			;2fa3	b8 	. 
	ld hl,0abd8h		;2fa4	21 d8 ab 	! . . 
	jr z,l2fd5h		;2fa7	28 2c 	( , 
	xor a			;2fa9	af 	. 
	ld (0abd7h),a		;2faa	32 d7 ab 	2 . . 
	inc (hl)			;2fad	34 	4 
l2faeh:
	ld a,(0aa2ah)		;2fae	3a 2a aa 	: * . 
	bit 1,a		;2fb1	cb 4f 	. O 
	jr z,l2fc1h		;2fb3	28 0c 	( . 
	ld a,(0ab2dh)		;2fb5	3a 2d ab 	: - . 
	inc a			;2fb8	3c 	< 
	cp (hl)			;2fb9	be 	. 
	jr nz,l2fc1h		;2fba	20 05 	  . 
	call sub_30f6h		;2fbc	cd f6 30 	. . 0 
	jr l2ff9h		;2fbf	18 38 	. 8 
l2fc1h:
	ld a,(0aa2bh)		;2fc1	3a 2b aa 	: + . 
	and 080h		;2fc4	e6 80 	. . 
	ld a,(0ad76h)		;2fc6	3a 76 ad 	: v . 
	jr nz,l2fcfh		;2fc9	20 04 	  . 
	ld a,(0ab27h)		;2fcb	3a 27 ab 	: ' . 
	inc a			;2fce	3c 	< 
l2fcfh:
	cp (hl)			;2fcf	be 	. 
	call z,sub_3039h		;2fd0	cc 39 30 	. 9 0 
	jr l2ff9h		;2fd3	18 24 	. $ 
l2fd5h:
	ld a,04fh		;2fd5	3e 4f 	> O 
	ld (0abd7h),a		;2fd7	32 d7 ab 	2 . . 
	dec (hl)			;2fda	35 	5 
l2fdbh:
	ld a,(0aa2ah)		;2fdb	3a 2a aa 	: * . 
	bit 1,a		;2fde	cb 4f 	. O 
	jr z,l2ff1h		;2fe0	28 0f 	( . 
	ld a,(0ab2eh)		;2fe2	3a 2e ab 	: . . 
	dec a			;2fe5	3d 	= 
	cp (hl)			;2fe6	be 	. 
	jr nz,l2ff1h		;2fe7	20 08 	  . 
	ld a,(0ab2dh)		;2fe9	3a 2d ab 	: - . 
	ld (0abd8h),a		;2fec	32 d8 ab 	2 . . 
	jr l2ff9h		;2fef	18 08 	. . 
l2ff1h:
	ld a,(hl)			;2ff1	7e 	~ 
	ld hl,0ad77h		;2ff2	21 77 ad 	! w . 
	cp (hl)			;2ff5	be 	. 
	call z,sub_305ah		;2ff6	cc 5a 30 	. Z 0 
l2ff9h:
	pop bc			;2ff9	c1 	. 
l2ffah:
	call 0450ah		;2ffa	cd 0a 45 	. . E 
l2ffdh:
	ld a,(ram_mode_flags)		;2ffd	3a 29 aa 	: ) . 
	and 080h		;3000	e6 80 	. . 
	jr z,l3018h		;3002	28 14 	( . 
	ld a,(0ac22h)		;3004	3a 22 ac 	: " . 
	push af			;3007	f5 	. 
	push bc			;3008	c5 	. 
	ld a,b			;3009	78 	x 
	ld c,000h		;300a	0e 00 	. . 
	call l310dh		;300c	cd 0d 31 	. . 1 
	pop bc			;300f	c1 	. 
	pop af			;3010	f1 	. 
	ld hl,0ac22h		;3011	21 22 ac 	! " . 
	or (hl)			;3014	b6 	. 
	ld (0ac22h),a		;3015	32 22 ac 	2 " . 
l3018h:
	ld a,(0ad68h)		;3018	3a 68 ad 	: h . 
	and a			;301b	a7 	. 
	call nz,sub_35d3h		;301c	c4 d3 35 	. . 5 
	ld a,(0abd7h)		;301f	3a d7 ab 	: . . 
	cp 047h		;3022	fe 47 	. G 
	ret nz			;3024	c0 	. 
	ld a,(0aab8h)		;3025	3a b8 aa 	: . . 
	bit 1,a		;3028	cb 4f 	. O 
	ret nz			;302a	c0 	. 
	ld a,b			;302b	78 	x 
	cp 001h		;302c	fe 01 	. . 
	ret nz			;302e	c0 	. 
	ld a,(0abf7h)		;302f	3a f7 ab 	: . . 
	and a			;3032	a7 	. 
	ret nz			;3033	c0 	. 
	ld c,057h		;3034	0e 57 	. W 
	jp 01475h		;3036	c3 75 14 	. u . 
sub_3039h:
	ld a,(0aa2ah)		;3039	3a 2a aa 	: * . 
	bit 0,a		;303c	cb 47 	. G 
	jr nz,l30a4h		;303e	20 64 	  d 
	bit 3,a		;3040	cb 5f 	. _ 
	jp nz,l30c1h		;3042	c2 c1 30 	. . 0 
	ld a,(ram_mode_flags)		;3045	3a 29 aa 	: ) . 
	and 088h		;3048	e6 88 	. . 
	jp nz,l3074h		;304a	c2 74 30 	. t 0 
	ld a,(0ab2ch)		;304d	3a 2c ab 	: , . 
	and a			;3050	a7 	. 
	jp z,l3074h		;3051	ca 74 30 	. t 0 
	call sub_3481h		;3054	cd 81 34 	. . 4 
l3057h:
	jp sub_3e9eh		;3057	c3 9e 3e 	. . > 
sub_305ah:
	ld a,0ffh		;305a	3e ff 	> . 
	ld (0ac22h),a		;305c	32 22 ac 	2 " . 
	ld a,(0aa2ah)		;305f	3a 2a aa 	: * . 
	bit 0,a		;3062	cb 47 	. G 
	jp nz,l30cah		;3064	c2 ca 30 	. . 0 
	bit 3,a		;3067	cb 5f 	. _ 
	jp nz,l30e0h		;3069	c2 e0 30 	. . 0 
	ld a,(0aa2bh)		;306c	3a 2b aa 	: + . 
	and 0d7h		;306f	e6 d7 	. . 
	jp nz,sub_3481h		;3071	c2 81 34 	. . 4 
l3074h:
	ld a,(0aa2bh)		;3074	3a 2b aa 	: + . 
	and 080h		;3077	e6 80 	. . 
	ld a,000h		;3079	3e 00 	> . 
	jr z,l3081h		;307b	28 04 	( . 
	ld a,(0ad77h)		;307d	3a 77 ad 	: w . 
	inc a			;3080	3c 	< 
l3081h:
	ld (0abd8h),a		;3081	32 d8 ab 	2 . . 
	ret			;3084	c9 	. 
sub_3085h:
	ld hl,0abd7h		;3085	21 d7 ab 	! . . 
	inc (hl)			;3088	34 	4 
	ld a,(hl)			;3089	7e 	~ 
	cp 050h		;308a	fe 50 	. P 
	ld b,001h		;308c	06 01 	. . 
	jp c,l2ffdh		;308e	da fd 2f 	. . / 
	ld a,(0ad68h)		;3091	3a 68 ad 	: h . 
	and a			;3094	a7 	. 
	jr z,l309eh		;3095	28 07 	( . 
	xor a			;3097	af 	. 
	ld (0abd7h),a		;3098	32 d7 ab 	2 . . 
	jp h_vt52_esc_B_down		;309b	c3 61 2f 	. a / 
l309eh:
	call l2f91h		;309e	cd 91 2f 	. . / 
	jp 0450ah		;30a1	c3 0a 45 	. . E 
l30a4h:
	call sub_3481h		;30a4	cd 81 34 	. . 4 
	ld a,(0ac09h)		;30a7	3a 09 ac 	: . . 
	cp 018h		;30aa	fe 18 	. . 
	jp nz,sub_3c21h		;30ac	c2 21 3c 	. ! < 
	ld a,(0aa2ah)		;30af	3a 2a aa 	: * . 
	bit 3,a		;30b2	cb 5f 	. _ 
	jr nz,l30c1h		;30b4	20 0b 	  . 
	ld a,(ram_mode_flags)		;30b6	3a 29 aa 	: ) . 
	and 088h		;30b9	e6 88 	. . 
	jr z,l3057h		;30bb	28 9a 	( . 
	call l3074h		;30bd	cd 74 30 	. t 0 
	ret			;30c0	c9 	. 
l30c1h:
	call l3074h		;30c1	cd 74 30 	. t 0 
	call sub_388dh		;30c4	cd 8d 38 	. . 8 
	jp sub_3c67h		;30c7	c3 67 3c 	. g < 
l30cah:
	ld a,(0ac09h)		;30ca	3a 09 ac 	: . . 
	and a			;30cd	a7 	. 
	jr z,l30d6h		;30ce	28 06 	( . 
	call l3074h		;30d0	cd 74 30 	. t 0 
	jp sub_3bedh		;30d3	c3 ed 3b 	. . ; 
l30d6h:
	ld a,(0aa2ah)		;30d6	3a 2a aa 	: * . 
	bit 3,a		;30d9	cb 5f 	. _ 
	jr nz,l30e0h		;30db	20 03 	  . 
	push bc			;30dd	c5 	. 
	jr l30e4h		;30de	18 04 	. . 
l30e0h:
	push bc			;30e0	c5 	. 
	call sub_385bh		;30e1	cd 5b 38 	. [ 8 
l30e4h:
	ld b,018h		;30e4	06 18 	. . 
l30e6h:
	push bc			;30e6	c5 	. 
	call sub_3c21h		;30e7	cd 21 3c 	. ! < 
	pop bc			;30ea	c1 	. 
	djnz l30e6h		;30eb	10 f9 	. . 
	ld a,(0ab27h)		;30ed	3a 27 ab 	: ' . 
	ld (0abd8h),a		;30f0	32 d8 ab 	2 . . 
	jp l2ff9h		;30f3	c3 f9 2f 	. . / 
sub_30f6h:
	ld a,(ram_mode_flags)		;30f6	3a 29 aa 	: ) . 
	and 088h		;30f9	e6 88 	. . 
	jr z,l3104h		;30fb	28 07 	( . 
	ld a,(0ab2eh)		;30fd	3a 2e ab 	: . . 
	ld (0abd8h),a		;3100	32 d8 ab 	2 . . 
	ret			;3103	c9 	. 
l3104h:
	ld a,(0ab2dh)		;3104	3a 2d ab 	: - . 
	ld (0abd8h),a		;3107	32 d8 ab 	2 . . 
	jp sub_3f56h		;310a	c3 56 3f 	. V ? 
l310dh:
	ld (0ac24h),a		;310d	32 24 ac 	2 $ . 
	ld a,c			;3110	79 	y 
	ld (0ac23h),a		;3111	32 23 ac 	2 # . 
	xor a			;3114	af 	. 
	ld (0ac25h),a		;3115	32 25 ac 	2 % . 
	ld (0ac22h),a		;3118	32 22 ac 	2 " . 
	ld (0ac21h),a		;311b	32 21 ac 	2 ! . 
l311eh:
	call sub_3335h		;311e	cd 35 33 	. 5 3 
	ld hl,(0abd7h)		;3121	2a d7 ab 	* . . 
	ld b,l			;3124	45 	E 
	ld c,h			;3125	4c 	L 
l3126h:
	call 046c2h		;3126	cd c2 46 	. . F 
	call 017a0h		;3129	cd a0 17 	. . . 
	ld a,(0d000h)		;312c	3a 00 d0 	: . . 
	ex de,hl			;312f	eb 	. 
	and 010h		;3130	e6 10 	. . 
	ld hl,0ac23h		;3132	21 23 ac 	! # . 
	xor (hl)			;3135	ae 	. 
	jr nz,l3140h		;3136	20 08 	  . 
	ld l,b			;3138	68 	h 
	ld h,c			;3139	61 	a 
	ld (0abd7h),hl		;313a	22 d7 ab 	" . . 
	jp 0450ah		;313d	c3 0a 45 	. . E 
l3140h:
	ld hl,(0ac26h)		;3140	2a 26 ac 	* & . 
	and a			;3143	a7 	. 
	sbc hl,de		;3144	ed 52 	. R 
	jp nz,l32d1h		;3146	c2 d1 32 	. . 2 
l3149h:
	ld a,(0ac25h)		;3149	3a 25 ac 	: % . 
	and a			;314c	a7 	. 
	jr z,l316bh		;314d	28 1c 	( . 
	ld a,(0ac22h)		;314f	3a 22 ac 	: " . 
	and a			;3152	a7 	. 
	jp nz,l31afh		;3153	c2 af 31 	. . 1 
	cpl			;3156	2f 	/ 
	ld (0ac22h),a		;3157	32 22 ac 	2 " . 
	ld a,001h		;315a	3e 01 	> . 
	ld (0ac24h),a		;315c	32 24 ac 	2 $ . 
	ld a,(0ab2eh)		;315f	3a 2e ab 	: . . 
	ld (0abd8h),a		;3162	32 d8 ab 	2 . . 
	xor a			;3165	af 	. 
	ld (0abd7h),a		;3166	32 d7 ab 	2 . . 
	jr l311eh		;3169	18 b3 	. . 
l316bh:
	ld a,(0aa2ah)		;316b	3a 2a aa 	: * . 
	bit 3,a		;316e	cb 5f 	. _ 
	jp nz,l3277h		;3170	c2 77 32 	. w 2 
l3173h:
	ld a,(0aa2ah)		;3173	3a 2a aa 	: * . 
	bit 0,a		;3176	cb 47 	. G 
	jr z,l31abh		;3178	28 31 	( 1 
	ld a,(0ac24h)		;317a	3a 24 ac 	: $ . 
	cp 001h		;317d	fe 01 	. . 
	jr z,l3193h		;317f	28 12 	( . 
	call sub_326dh		;3181	cd 6d 32 	. m 2 
l3184h:
	call sub_3227h		;3184	cd 27 32 	. ' 2 
	ret nz			;3187	c0 	. 
	ld a,(0ac09h)		;3188	3a 09 ac 	: . . 
	and a			;318b	a7 	. 
	jr z,l31afh		;318c	28 21 	( ! 
	call sub_3bedh		;318e	cd ed 3b 	. . ; 
	jr l3184h		;3191	18 f1 	. . 
l3193h:
	call sub_325fh		;3193	cd 5f 32 	. _ 2 
l3196h:
	call sub_3227h		;3196	cd 27 32 	. ' 2 
	ret nz			;3199	c0 	. 
	ld a,(0ac09h)		;319a	3a 09 ac 	: . . 
	cp 018h		;319d	fe 18 	. . 
	jr nz,l31a6h		;319f	20 05 	  . 
	call sub_325fh		;31a1	cd 5f 32 	. _ 2 
	jr l31afh		;31a4	18 09 	. . 
l31a6h:
	call sub_3c21h		;31a6	cd 21 3c 	. ! < 
	jr l3196h		;31a9	18 eb 	. . 
l31abh:
	call sub_3227h		;31ab	cd 27 32 	. ' 2 
	ret nz			;31ae	c0 	. 
l31afh:
	ld a,005h		;31af	3e 05 	> . 
	ld (0ad79h),a		;31b1	32 79 ad 	2 y . 
	ld c,a			;31b4	4f 	O 
	call 00f05h		;31b5	cd 05 0f 	. . . 
sub_31b8h:
	xor a			;31b8	af 	. 
	call 041dfh		;31b9	cd df 41 	. . A 
	ld d,h			;31bc	54 	T 
	ld e,l			;31bd	5d 	] 
	call 0451bh		;31be	cd 1b 45 	. . E 
	ld a,000h		;31c1	3e 00 	> . 
	jr c,l31cbh		;31c3	38 06 	8 . 
	ld a,(0ab2eh)		;31c5	3a 2e ab 	: . . 
	call 041dfh		;31c8	cd df 41 	. . A 
l31cbh:
	call 041eeh		;31cb	cd ee 41 	. . A 
	and a			;31ce	a7 	. 
	sbc hl,de		;31cf	ed 52 	. R 
	ld h,l			;31d1	65 	e 
	ld l,000h		;31d2	2e 00 	. . 
	ld (0abd7h),hl		;31d4	22 d7 ab 	" . . 
	jp 0450ah		;31d7	c3 0a 45 	. . E 
sub_31dah:
	push bc			;31da	c5 	. 
	push de			;31db	d5 	. 
	push hl			;31dc	e5 	. 
	bit 7,(hl)		;31dd	cb 7e 	. ~ 
	jr nz,l320eh		;31df	20 2d 	  - 
	ld a,(hl)			;31e1	7e 	~ 
	call sub_3d35h		;31e2	cd 35 3d 	. 5 = 
	ld a,(0ac24h)		;31e5	3a 24 ac 	: $ . 
	cp 001h		;31e8	fe 01 	. . 
	jr z,l31f1h		;31ea	28 05 	( . 
	ld hl,0004fh		;31ec	21 4f 00 	! O . 
	add hl,de			;31ef	19 	. 
	ex de,hl			;31f0	eb 	. 
l31f1h:
	ex de,hl			;31f1	eb 	. 
	ld b,050h		;31f2	06 50 	. P 
l31f4h:
	rst 30h			;31f4	f7 	. 
	ld (06006h),hl		;31f5	22 06 60 	" . ` 
	call 017a0h		;31f8	cd a0 17 	. . . 
	ld a,(0d000h)		;31fb	3a 00 d0 	: . . 
	and 010h		;31fe	e6 10 	. . 
	jr z,l3213h		;3200	28 11 	( . 
	ld a,(0ac24h)		;3202	3a 24 ac 	: $ . 
	cp 001h		;3205	fe 01 	. . 
	jr z,l320bh		;3207	28 02 	( . 
	dec hl			;3209	2b 	+ 
	dec hl			;320a	2b 	+ 
l320bh:
	inc hl			;320b	23 	# 
	djnz l31f4h		;320c	10 e6 	. . 
l320eh:
	xor a			;320e	af 	. 
l320fh:
	pop hl			;320f	e1 	. 
	pop de			;3210	d1 	. 
	pop bc			;3211	c1 	. 
	ret			;3212	c9 	. 
l3213h:
	ld a,(0ac24h)		;3213	3a 24 ac 	: $ . 
	cp 001h		;3216	fe 01 	. . 
	jr nz,l3223h		;3218	20 09 	  . 
	ld a,050h		;321a	3e 50 	> P 
	sub b			;321c	90 	. 
l321dh:
	ld (0abd7h),a		;321d	32 d7 ab 	2 . . 
	inc a			;3220	3c 	< 
	jr l320fh		;3221	18 ec 	. . 
l3223h:
	dec b			;3223	05 	. 
	ld a,b			;3224	78 	x 
	jr l321dh		;3225	18 f6 	. . 
sub_3227h:
	ld a,(0ab27h)		;3227	3a 27 ab 	: ' . 
	inc a			;322a	3c 	< 
	ld b,a			;322b	47 	G 
	ld a,(0ac24h)		;322c	3a 24 ac 	: $ . 
	cp 001h		;322f	fe 01 	. . 
	ld a,(0ab27h)		;3231	3a 27 ab 	: ' . 
	jr nz,l3237h		;3234	20 01 	  . 
	xor a			;3236	af 	. 
l3237h:
	call 041dfh		;3237	cd df 41 	. . A 
l323ah:
	call sub_31dah		;323a	cd da 31 	. . 1 
	jr nz,l324dh		;323d	20 0e 	  . 
	ld a,(0ac24h)		;323f	3a 24 ac 	: $ . 
	cp 001h		;3242	fe 01 	. . 
	jr z,l3248h		;3244	28 02 	( . 
	dec hl			;3246	2b 	+ 
	dec hl			;3247	2b 	+ 
l3248h:
	inc hl			;3248	23 	# 
	djnz l323ah		;3249	10 ef 	. . 
	xor a			;324b	af 	. 
	ret			;324c	c9 	. 
l324dh:
	ex de,hl			;324d	eb 	. 
	xor a			;324e	af 	. 
	call 041dfh		;324f	cd df 41 	. . A 
	ex de,hl			;3252	eb 	. 
	and a			;3253	a7 	. 
	sbc hl,de		;3254	ed 52 	. R 
	ld a,l			;3256	7d 	} 
	ld (0abd8h),a		;3257	32 d8 ab 	2 . . 
	call 0450ah		;325a	cd 0a 45 	. . E 
	inc a			;325d	3c 	< 
	ret			;325e	c9 	. 
sub_325fh:
	ld a,(0ac09h)		;325f	3a 09 ac 	: . . 
	and a			;3262	a7 	. 
	ret z			;3263	c8 	. 
	ld b,a			;3264	47 	G 
l3265h:
	push bc			;3265	c5 	. 
	call sub_3bedh		;3266	cd ed 3b 	. . ; 
	pop bc			;3269	c1 	. 
	djnz l3265h		;326a	10 f9 	. . 
	ret			;326c	c9 	. 
sub_326dh:
	ld b,018h		;326d	06 18 	. . 
l326fh:
	push bc			;326f	c5 	. 
	call sub_3c21h		;3270	cd 21 3c 	. ! < 
	pop bc			;3273	c1 	. 
	djnz l326fh		;3274	10 f9 	. . 
	ret			;3276	c9 	. 
l3277h:
	ld a,(0ac22h)		;3277	3a 22 ac 	: " . 
	and a			;327a	a7 	. 
	jr nz,l32a7h		;327b	20 2a 	  * 
	cpl			;327d	2f 	/ 
	ld (0ac22h),a		;327e	32 22 ac 	2 " . 
	ld a,(0abf8h)		;3281	3a f8 ab 	: . . 
	ld (0ac21h),a		;3284	32 21 ac 	2 ! . 
l3287h:
	ld a,(0ac24h)		;3287	3a 24 ac 	: $ . 
	cp 001h		;328a	fe 01 	. . 
	jr nz,l3296h		;328c	20 08 	  . 
	call sub_388dh		;328e	cd 8d 38 	. . 8 
	call sub_325fh		;3291	cd 5f 32 	. _ 2 
	jr l329ch		;3294	18 06 	. . 
l3296h:
	call sub_385bh		;3296	cd 5b 38 	. [ 8 
	call sub_326dh		;3299	cd 6d 32 	. m 2 
l329ch:
	call sub_3227h		;329c	cd 27 32 	. ' 2 
	ret nz			;329f	c0 	. 
	ld a,(0aa2ah)		;32a0	3a 2a aa 	: * . 
	bit 0,a		;32a3	cb 47 	. G 
	jr nz,l32b3h		;32a5	20 0c 	  . 
l32a7h:
	ld a,(0ac21h)		;32a7	3a 21 ac 	: ! . 
	ld hl,0abf8h		;32aa	21 f8 ab 	! . . 
	cp (hl)			;32ad	be 	. 
	jp z,l31afh		;32ae	ca af 31 	. . 1 
	jr l3287h		;32b1	18 d4 	. . 
l32b3h:
	ld a,(0ac24h)		;32b3	3a 24 ac 	: $ . 
	cp 001h		;32b6	fe 01 	. . 
	jr nz,l32c6h		;32b8	20 0c 	  . 
	ld a,(0ac09h)		;32ba	3a 09 ac 	: . . 
	cp 018h		;32bd	fe 18 	. . 
	jr z,l32a7h		;32bf	28 e6 	( . 
	call sub_3c21h		;32c1	cd 21 3c 	. ! < 
	jr l329ch		;32c4	18 d6 	. . 
l32c6h:
	ld a,(0ac09h)		;32c6	3a 09 ac 	: . . 
	and a			;32c9	a7 	. 
	jr z,l32a7h		;32ca	28 db 	( . 
	call sub_3bedh		;32cc	cd ed 3b 	. . ; 
	jr l329ch		;32cf	18 cb 	. . 
l32d1h:
	ld a,(0ac24h)		;32d1	3a 24 ac 	: $ . 
	cp 001h		;32d4	fe 01 	. . 
	jr nz,l3300h		;32d6	20 28 	  ( 
	ld a,b			;32d8	78 	x 
	cp 04fh		;32d9	fe 4f 	. O 
	jr z,l32e0h		;32db	28 03 	( . 
	inc b			;32dd	04 	. 
	jr l3318h		;32de	18 38 	. 8 
l32e0h:
	inc c			;32e0	0c 	. 
	ld a,c			;32e1	79 	y 
	ld hl,0ad76h		;32e2	21 76 ad 	! v . 
	cp (hl)			;32e5	be 	. 
	jr z,l32f3h		;32e6	28 0b 	( . 
	call 041dfh		;32e8	cd df 41 	. . A 
	bit 7,(hl)		;32eb	cb 7e 	. ~ 
	jr nz,l32e0h		;32ed	20 f1 	  . 
	ld b,000h		;32ef	06 00 	. . 
	jr l3318h		;32f1	18 25 	. % 
l32f3h:
	dec c			;32f3	0d 	. 
	call sub_3326h		;32f4	cd 26 33 	. & 3 
	push bc			;32f7	c5 	. 
	call sub_3c21h		;32f8	cd 21 3c 	. ! < 
	pop bc			;32fb	c1 	. 
	ld b,000h		;32fc	06 00 	. . 
	jr l3318h		;32fe	18 18 	. . 
l3300h:
	xor a			;3300	af 	. 
	cp b			;3301	b8 	. 
	jr z,l3307h		;3302	28 03 	( . 
	dec b			;3304	05 	. 
	jr l3318h		;3305	18 11 	. . 
l3307h:
	dec c			;3307	0d 	. 
	ld a,c			;3308	79 	y 
	ld hl,0ad77h		;3309	21 77 ad 	! w . 
	cp (hl)			;330c	be 	. 
	jr z,l331bh		;330d	28 0c 	( . 
	call 041dfh		;330f	cd df 41 	. . A 
	bit 7,(hl)		;3312	cb 7e 	. ~ 
	jr nz,l3307h		;3314	20 f1 	  . 
l3316h:
	ld b,04fh		;3316	06 4f 	. O 
l3318h:
	jp l3126h		;3318	c3 26 31 	. & 1 
l331bh:
	inc c			;331b	0c 	. 
	call sub_3326h		;331c	cd 26 33 	. & 3 
	push bc			;331f	c5 	. 
	call sub_3bedh		;3320	cd ed 3b 	. . ; 
	pop bc			;3323	c1 	. 
	jr l3316h		;3324	18 f0 	. . 
sub_3326h:
	call 046c2h		;3326	cd c2 46 	. . F 
	ex de,hl			;3329	eb 	. 
	ld hl,(0ac26h)		;332a	2a 26 ac 	* & . 
	and a			;332d	a7 	. 
	sbc hl,de		;332e	ed 52 	. R 
	ret nz			;3330	c0 	. 
	pop af			;3331	f1 	. 
	jp l3149h		;3332	c3 49 31 	. I 1 
sub_3335h:
	ld a,(0aa2ah)		;3335	3a 2a aa 	: * . 
	bit 1,a		;3338	cb 4f 	. O 
	jr nz,l336dh		;333a	20 31 	  1 
l333ch:
	ld a,(0ac24h)		;333c	3a 24 ac 	: $ . 
	cp 001h		;333f	fe 01 	. . 
	jr z,l335ch		;3341	28 19 	( . 
	ld a,(0ac09h)		;3343	3a 09 ac 	: . . 
	and a			;3346	a7 	. 
	jr nz,l3356h		;3347	20 0d 	  . 
	call 041dfh		;3349	cd df 41 	. . A 
	call 041eeh		;334c	cd ee 41 	. . A 
	call sub_33a9h		;334f	cd a9 33 	. . 3 
l3352h:
	ld (0ac26h),hl		;3352	22 26 ac 	" & . 
	ret			;3355	c9 	. 
l3356h:
	xor a			;3356	af 	. 
sub_3357h:
	call sub_339fh		;3357	cd 9f 33 	. . 3 
	jr l3352h		;335a	18 f6 	. . 
l335ch:
	ld a,(0ac1dh)		;335c	3a 1d ac 	: . . 
	ld hl,0ac36h		;335f	21 36 ac 	! 6 . 
	sub (hl)			;3362	96 	. 
	dec a			;3363	3d 	= 
	call sub_3357h		;3364	cd 57 33 	. W 3 
	ld de,0004fh		;3367	11 4f 00 	. O . 
	add hl,de			;336a	19 	. 
	jr l3352h		;336b	18 e5 	. . 
l336dh:
	ld a,(0ac24h)		;336d	3a 24 ac 	: $ . 
	cp 0ffh		;3370	fe ff 	. . 
	jr z,l338eh		;3372	28 1a 	( . 
	ld a,(0abd8h)		;3374	3a d8 ab 	: . . 
	ld d,a			;3377	57 	W 
	ld a,(0ab2dh)		;3378	3a 2d ab 	: - . 
	sub d			;337b	92 	. 
	jr c,l333ch		;337c	38 be 	8 . 
	ld b,04fh		;337e	06 4f 	. O 
	ld a,(0ab2dh)		;3380	3a 2d ab 	: - . 
l3383h:
	ld c,a			;3383	4f 	O 
	ld a,0ffh		;3384	3e ff 	> . 
	ld (0ac25h),a		;3386	32 25 ac 	2 % . 
	call 046c2h		;3389	cd c2 46 	. . F 
	jr l3352h		;338c	18 c4 	. . 
l338eh:
	ld a,(0ab2eh)		;338e	3a 2e ab 	: . . 
	ld e,a			;3391	5f 	_ 
	ld b,000h		;3392	06 00 	. . 
	ld a,(0abd8h)		;3394	3a d8 ab 	: . . 
	sub e			;3397	93 	. 
	jr c,l333ch		;3398	38 a2 	8 . 
	ld a,(0ab2eh)		;339a	3a 2e ab 	: . . 
	jr l3383h		;339d	18 e4 	. . 
sub_339fh:
	ld d,000h		;339f	16 00 	. . 
	ld e,a			;33a1	5f 	_ 
	ld hl,(0ac1eh)		;33a2	2a 1e ac 	* . . 
	add hl,de			;33a5	19 	. 
	call 041f4h		;33a6	cd f4 41 	. . A 
sub_33a9h:
	ld a,(hl)			;33a9	7e 	~ 
	call sub_3d35h		;33aa	cd 35 3d 	. 5 = 
	ex de,hl			;33ad	eb 	. 
	ret			;33ae	c9 	. 
h_vt52_esc_H_home:
	call 04511h		;33af	cd 11 45 	. . E 
	jr z,l33b9h		;33b2	28 05 	( . 
	call 0451bh		;33b4	cd 1b 45 	. . E 
	jr nc,l33d3h		;33b7	30 1a 	0 . 
l33b9h:
	ld hl,00014h		;33b9	21 14 00 	! . . 
	rst 20h			;33bc	e7 	. 
	jr nz,l33d9h		;33bd	20 1a 	  . 
l33bfh:
	call sub_325fh		;33bf	cd 5f 32 	. _ 2 
	call sub_31b8h		;33c2	cd b8 31 	. . 1 
	ld a,(ram_mode_flags)		;33c5	3a 29 aa 	: ) . 
	and 080h		;33c8	e6 80 	. . 
	ret z			;33ca	c8 	. 
	ld a,001h		;33cb	3e 01 	> . 
	ld (0ac24h),a		;33cd	32 24 ac 	2 $ . 
	jp l3173h		;33d0	c3 73 31 	. s 1 
l33d3h:
	ld (0abd8h),a		;33d3	32 d8 ab 	2 . . 
	jp l3538h		;33d6	c3 38 35 	. 8 5 
l33d9h:
	ld a,(0ab2ch)		;33d9	3a 2c ab 	: , . 
	and a			;33dc	a7 	. 
	jr z,l33bfh		;33dd	28 e0 	( . 
	ld a,(0ab27h)		;33df	3a 27 ab 	: ' . 
	jr l33d3h		;33e2	18 ef 	. . 
h_prot_on:
	ld hl,0aa2ah		;33e4	21 2a aa 	! * . 
	res 5,(hl)		;33e7	cb ae 	. . 
	ld hl,ram_mode_flags		;33e9	21 29 aa 	! ) . 
	set 7,(hl)		;33ec	cb fe 	. . 
	call 00f87h		;33ee	cd 87 0f 	. . . 
sub_33f1h:
	ld c,000h		;33f1	0e 00 	. . 
	ld a,001h		;33f3	3e 01 	> . 
	jp l310dh		;33f5	c3 0d 31 	. . 1 
	ld c,010h		;33f8	0e 10 	. . 
	ld a,001h		;33fa	3e 01 	> . 
	call l310dh		;33fc	cd 0d 31 	. . 1 
	ld a,(0ac22h)		;33ff	3a 22 ac 	: " . 
	and a			;3402	a7 	. 
	jp nz,009ech		;3403	c2 ec 09 	. . . 
	call sub_33f1h		;3406	cd f1 33 	. . 3 
	jp 009ech		;3409	c3 ec 09 	. . . 
h_mode_bit7_test:
	ld a,(ram_mode_flags)		;340c	3a 29 aa 	: ) . 
	bit 7,a		;340f	cb 7f 	.  
	jr nz,l3429h		;3411	20 16 	  . 
	call 00cd8h		;3413	cd d8 0c 	. . . 
	jr nz,l3450h		;3416	20 38 	  8 
	ld hl,00700h		;3418	21 00 07 	! . . 
	rst 20h			;341b	e7 	. 
	jp z,l2c7eh		;341c	ca 7e 2c 	. ~ , 
	ld hl,ram_mode_flags		;341f	21 29 aa 	! ) . 
	set 7,(hl)		;3422	cb fe 	. . 
	ld a,0ffh		;3424	3e ff 	> . 
	ld (0acc7h),a		;3426	32 c7 ac 	2 . . 
l3429h:
	call h_vt52_esc_D_left		;3429	cd 59 2f 	. Y / 
	ld a,(0ac22h)		;342c	3a 22 ac 	: " . 
	and a			;342f	a7 	. 
	jr nz,l3441h		;3430	20 0f 	  . 
	ld c,010h		;3432	0e 10 	. . 
	ld a,0ffh		;3434	3e ff 	> . 
	call l310dh		;3436	cd 0d 31 	. . 1 
	ld a,(0ac22h)		;3439	3a 22 ac 	: " . 
	and a			;343c	a7 	. 
	ret nz			;343d	c0 	. 
	call sub_33f1h		;343e	cd f1 33 	. . 3 
l3441h:
	ld a,(0acc7h)		;3441	3a c7 ac 	: . . 
	and a			;3444	a7 	. 
	ret z			;3445	c8 	. 
	xor a			;3446	af 	. 
	ld (0acc7h),a		;3447	32 c7 ac 	2 . . 
	ld hl,ram_mode_flags		;344a	21 29 aa 	! ) . 
	res 7,(hl)		;344d	cb be 	. . 
	ret			;344f	c9 	. 
l3450h:
	ld a,(0abd7h)		;3450	3a d7 ab 	: . . 
	and a			;3453	a7 	. 
	ret z			;3454	c8 	. 
	dec a			;3455	3d 	= 
	call 04618h		;3456	cd 18 46 	. . F 
	cpl			;3459	2f 	/ 
	and 007h		;345a	e6 07 	. . 
l345ch:
	jr z,l3463h		;345c	28 05 	( . 
	sla b		;345e	cb 20 	.   
	dec a			;3460	3d 	= 
	jr l345ch		;3461	18 f9 	. . 
l3463h:
	ld a,b			;3463	78 	x 
	and a			;3464	a7 	. 
	jr z,l3471h		;3465	28 0a 	( . 
l3467h:
	bit 7,a		;3467	cb 7f 	.  
	jp nz,l347eh		;3469	c2 7e 34 	. ~ 4 
	sla a		;346c	cb 27 	. ' 
	dec d			;346e	15 	. 
	jr l3467h		;346f	18 f6 	. . 
l3471h:
	dec e			;3471	1d 	. 
	jp m,l347bh		;3472	fa 7b 34 	. { 4 
	ld d,007h		;3475	16 07 	. . 
	dec hl			;3477	2b 	+ 
	ld b,(hl)			;3478	46 	F 
	jr l3463h		;3479	18 e8 	. . 
l347bh:
	ld de,00000h		;347b	11 00 00 	. . . 
l347eh:
	jp 045ach		;347e	c3 ac 45 	. . E 
sub_3481h:
	ld a,(0ad68h)		;3481	3a 68 ad 	: h . 
	and a			;3484	a7 	. 
	ld a,(0ab27h)		;3485	3a 27 ab 	: ' . 
	jr z,l348eh		;3488	28 04 	( . 
	ld a,(0ad76h)		;348a	3a 76 ad 	: v . 
	dec a			;348d	3d 	= 
l348eh:
	ld (0abd8h),a		;348e	32 d8 ab 	2 . . 
	ret			;3491	c9 	. 
	rst 28h			;3492	ef 	. 
	cp 060h		;3493	fe 60 	. ` 
	jr c,l3499h		;3495	38 02 	8 . 
	sub 060h		;3497	d6 60 	. ` 
l3499h:
	cp 04fh		;3499	fe 4f 	. O 
	jr c,l349fh		;349b	38 02 	8 . 
	ld a,04fh		;349d	3e 4f 	> O 
l349fh:
	push af			;349f	f5 	. 
	rst 28h			;34a0	ef 	. 
	pop de			;34a1	d1 	. 
	and 01fh		;34a2	e6 1f 	. . 
	ld hl,0ab27h		;34a4	21 27 ab 	! ' . 
	cp (hl)			;34a7	be 	. 
	jr c,l34abh		;34a8	38 01 	8 . 
	ld a,(hl)			;34aa	7e 	~ 
l34abh:
	ld h,a			;34ab	67 	g 
	ld l,d			;34ac	6a 	j 
	ld (0abd7h),hl		;34ad	22 d7 ab 	" . . 
	jp l3538h		;34b0	c3 38 35 	. 8 5 
h_set_cursor_col_bcd:
	rst 28h			;34b3	ef 	. 
	ld b,a			;34b4	47 	G 
	and 070h		;34b5	e6 70 	. p 
	rrca			;34b7	0f 	. 
	ld c,a			;34b8	4f 	O 
	rrca			;34b9	0f 	. 
	rrca			;34ba	0f 	. 
	add a,c			;34bb	81 	. 
	ld c,a			;34bc	4f 	O 
	ld a,b			;34bd	78 	x 
	and 00fh		;34be	e6 0f 	. . 
	add a,c			;34c0	81 	. 
	cp 050h		;34c1	fe 50 	. P 
	jr nc,l3504h		;34c3	30 3f 	0 ? 
	ld (0abd7h),a		;34c5	32 d7 ab 	2 . . 
	jp l3538h		;34c8	c3 38 35 	. 8 5 
h_set_cursor_row_5bit:
	rst 28h			;34cb	ef 	. 
	and 01fh		;34cc	e6 1f 	. . 
	ld b,a			;34ce	47 	G 
	ld a,(0aa2bh)		;34cf	3a 2b aa 	: + . 
	and 080h		;34d2	e6 80 	. . 
	jr nz,l34e3h		;34d4	20 0d 	  . 
	ld a,(0ab27h)		;34d6	3a 27 ab 	: ' . 
	cp b			;34d9	b8 	. 
	jr c,l3504h		;34da	38 28 	8 ( 
	ld a,b			;34dc	78 	x 
	ld (0abd8h),a		;34dd	32 d8 ab 	2 . . 
	jp l3538h		;34e0	c3 38 35 	. 8 5 
l34e3h:
	call sub_3598h		;34e3	cd 98 35 	. . 5 
	jr l3551h		;34e6	18 69 	. i 
	rst 28h			;34e8	ef 	. 
	sub 030h		;34e9	d6 30 	. 0 
	ld hl,0abf9h		;34eb	21 f9 ab 	! . . 
	cp (hl)			;34ee	be 	. 
	jr nc,l34ffh		;34ef	30 0e 	0 . 
	inc a			;34f1	3c 	< 
l34f2h:
	ld hl,0abf8h		;34f2	21 f8 ab 	! . . 
	cp (hl)			;34f5	be 	. 
	jr z,h_vt52_esc_Y_cursor		;34f6	28 2b 	( + 
	push af			;34f8	f5 	. 
	call sub_388dh		;34f9	cd 8d 38 	. . 8 
	pop af			;34fc	f1 	. 
	jr l34f2h		;34fd	18 f3 	. . 
l34ffh:
	ld e,002h		;34ff	1e 02 	. . 
	call 018ech		;3501	cd ec 18 	. . . 
l3504h:
	jp 00effh		;3504	c3 ff 0e 	. . . 
sub_3507h:
	ld a,(0ab27h)		;3507	3a 27 ab 	: ' . 
	inc a			;350a	3c 	< 
	ld d,a			;350b	57 	W 
	jr l3510h		;350c	18 02 	. . 
sub_350eh:
	ld d,050h		;350e	16 50 	. P 
l3510h:
	push hl			;3510	e5 	. 
	push de			;3511	d5 	. 
	rst 28h			;3512	ef 	. 
	pop de			;3513	d1 	. 
	pop hl			;3514	e1 	. 
	sub 020h		;3515	d6 20 	.   
	cp d			;3517	ba 	. 
	ret			;3518	c9 	. 
h_cursor_addr_alt:
	call sub_3507h		;3519	cd 07 35 	. . 5 
	ld hl,0ab2eh		;351c	21 2e ab 	! . . 
	add a,(hl)			;351f	86 	. 
	cp d			;3520	ba 	. 
	jr l352bh		;3521	18 08 	. . 
h_vt52_esc_Y_cursor:
	call 00cd8h		;3523	cd d8 0c 	. . . 
	jr nz,l3543h		;3526	20 1b 	  . 
	call sub_3507h		;3528	cd 07 35 	. . 5 
l352bh:
	jr nc,l353dh		;352b	30 10 	0 . 
	ld b,a			;352d	47 	G 
	call sub_350eh		;352e	cd 0e 35 	. . 5 
	jr nc,l3504h		;3531	30 d1 	0 . 
	ld c,a			;3533	4f 	O 
	ld (0abd7h),bc		;3534	ed 43 d7 ab 	. C . . 
l3538h:
	ld b,001h		;3538	06 01 	. . 
	jp l2ffah		;353a	c3 fa 2f 	. . / 
l353dh:
	ld hl,0a945h		;353d	21 45 a9 	! E . 
	inc (hl)			;3540	34 	4 
	jr l3504h		;3541	18 c1 	. . 
l3543h:
	call sub_3592h		;3543	cd 92 35 	. . 5 
	call sub_350eh		;3546	cd 0e 35 	. . 5 
	jr c,l354dh		;3549	38 02 	8 . 
	ld a,04fh		;354b	3e 4f 	> O 
l354dh:
	ld (0abd7h),a		;354d	32 d7 ab 	2 . . 
	ld a,b			;3550	78 	x 
l3551h:
	ld hl,0ac09h		;3551	21 09 ac 	! . . 
	cp (hl)			;3554	be 	. 
	ld a,(hl)			;3555	7e 	~ 
	jr nc,l356bh		;3556	30 13 	0 . 
	sub b			;3558	90 	. 
	ld b,a			;3559	47 	G 
l355ah:
	push bc			;355a	c5 	. 
	call sub_3bedh		;355b	cd ed 3b 	. . ; 
	pop bc			;355e	c1 	. 
	djnz l355ah		;355f	10 f9 	. . 
	xor a			;3561	af 	. 
	call 041dfh		;3562	cd df 41 	. . A 
	push hl			;3565	e5 	. 
	call 041eeh		;3566	cd ee 41 	. . A 
	jr l3584h		;3569	18 19 	. . 
l356bh:
	add a,017h		;356b	c6 17 	. . 
	cp b			;356d	b8 	. 
	jr nc,l358bh		;356e	30 1b 	0 . 
	ld c,a			;3570	4f 	O 
	ld a,b			;3571	78 	x 
	sub c			;3572	91 	. 
	ld b,a			;3573	47 	G 
l3574h:
	push bc			;3574	c5 	. 
	call sub_3c21h		;3575	cd 21 3c 	. ! < 
	pop bc			;3578	c1 	. 
	djnz l3574h		;3579	10 f9 	. . 
	ld a,017h		;357b	3e 17 	> . 
	call 041dfh		;357d	cd df 41 	. . A 
	push hl			;3580	e5 	. 
	call 041f4h		;3581	cd f4 41 	. . A 
l3584h:
	pop de			;3584	d1 	. 
	and a			;3585	a7 	. 
	sbc hl,de		;3586	ed 52 	. R 
	add a,l			;3588	85 	. 
	jr l358dh		;3589	18 02 	. . 
l358bh:
	ld a,b			;358b	78 	x 
	sub (hl)			;358c	96 	. 
l358dh:
	ld (0abd8h),a		;358d	32 d8 ab 	2 . . 
	jr l3538h		;3590	18 a6 	. . 
sub_3592h:
	rst 28h			;3592	ef 	. 
	sub 020h		;3593	d6 20 	.   
	jr c,l35cfh		;3595	38 38 	8 8 
	ld b,a			;3597	47 	G 
sub_3598h:
	ld a,(0ac1dh)		;3598	3a 1d ac 	: . . 
	ld hl,0ad68h		;359b	21 68 ad 	! h . 
	sub (hl)			;359e	96 	. 
	dec a			;359f	3d 	= 
	cp b			;35a0	b8 	. 
	jr nc,l35a4h		;35a1	30 01 	0 . 
	ld b,a			;35a3	47 	G 
l35a4h:
	ld a,b			;35a4	78 	x 
	ld c,(hl)			;35a5	4e 	N 
	ld hl,0ac09h		;35a6	21 09 ac 	! . . 
	cp (hl)			;35a9	be 	. 
	ret c			;35aa	d8 	. 
	ld a,(hl)			;35ab	7e 	~ 
	add a,017h		;35ac	c6 17 	. . 
	cp b			;35ae	b8 	. 
	ld a,b			;35af	78 	x 
	jr c,l35cch		;35b0	38 1a 	8 . 
	sub (hl)			;35b2	96 	. 
	ld b,a			;35b3	47 	G 
	xor a			;35b4	af 	. 
	call 041dfh		;35b5	cd df 41 	. . A 
	inc b			;35b8	04 	. 
l35b9h:
	bit 7,(hl)		;35b9	cb 7e 	. ~ 
	jr nz,l35c8h		;35bb	20 0b 	  . 
	inc hl			;35bd	23 	# 
	inc a			;35be	3c 	< 
	djnz l35b9h		;35bf	10 f8 	. . 
	dec a			;35c1	3d 	= 
	ld hl,0ac09h		;35c2	21 09 ac 	! . . 
	add a,(hl)			;35c5	86 	. 
	ld b,a			;35c6	47 	G 
	ret			;35c7	c9 	. 
l35c8h:
	inc hl			;35c8	23 	# 
	inc a			;35c9	3c 	< 
	jr l35b9h		;35ca	18 ed 	. . 
l35cch:
	add a,c			;35cc	81 	. 
	ld b,a			;35cd	47 	G 
	ret			;35ce	c9 	. 
l35cfh:
	ld b,000h		;35cf	06 00 	. . 
	jr l35a4h		;35d1	18 d1 	. . 
sub_35d3h:
	ld a,(0abd8h)		;35d3	3a d8 ab 	: . . 
	call 041dfh		;35d6	cd df 41 	. . A 
	bit 7,(hl)		;35d9	cb 7e 	. ~ 
	ret z			;35db	c8 	. 
l35dch:
	and a			;35dc	a7 	. 
	jr z,l360bh		;35dd	28 2c 	( , 
	cp 017h		;35df	fe 17 	. . 
	jr z,l3629h		;35e1	28 46 	( F 
	ld a,b			;35e3	78 	x 
	ld hl,0abd8h		;35e4	21 d8 ab 	! . . 
	add a,(hl)			;35e7	86 	. 
	ld (hl),a			;35e8	77 	w 
	call 041dfh		;35e9	cd df 41 	. . A 
	bit 7,(hl)		;35ec	cb 7e 	. ~ 
	jr nz,l35dch		;35ee	20 ec 	  . 
	ld a,(ram_mode_flags)		;35f0	3a 29 aa 	: ) . 
	and 080h		;35f3	e6 80 	. . 
	jp z,0450ah		;35f5	ca 0a 45 	. . E 
	ld a,b			;35f8	78 	x 
	push bc			;35f9	c5 	. 
	ld c,000h		;35fa	0e 00 	. . 
	call l310dh		;35fc	cd 0d 31 	. . 1 
	pop bc			;35ff	c1 	. 
	ld a,(0abd8h)		;3600	3a d8 ab 	: . . 
	call 041dfh		;3603	cd df 41 	. . A 
	bit 7,(hl)		;3606	cb 7e 	. ~ 
	ret z			;3608	c8 	. 
	jr l35dch		;3609	18 d1 	. . 
l360bh:
	ld a,001h		;360b	3e 01 	> . 
	cp b			;360d	b8 	. 
	jr z,l3622h		;360e	28 12 	( . 
l3610h:
	push bc			;3610	c5 	. 
	call sub_3bedh		;3611	cd ed 3b 	. . ; 
	pop bc			;3614	c1 	. 
	call sub_3227h		;3615	cd 27 32 	. ' 2 
	ret nz			;3618	c0 	. 
	ld a,(0ac09h)		;3619	3a 09 ac 	: . . 
	and a			;361c	a7 	. 
	jp z,l3173h		;361d	ca 73 31 	. s 1 
	jr l3610h		;3620	18 ee 	. . 
l3622h:
	ld hl,0abd8h		;3622	21 d8 ab 	! . . 
	inc (hl)			;3625	34 	4 
	ld a,(hl)			;3626	7e 	~ 
	jr sub_35d3h		;3627	18 aa 	. . 
l3629h:
	ld a,001h		;3629	3e 01 	> . 
	cp b			;362b	b8 	. 
	jr z,l3635h		;362c	28 07 	( . 
	ld hl,0abd8h		;362e	21 d8 ab 	! . . 
	dec (hl)			;3631	35 	5 
	ld a,(hl)			;3632	7e 	~ 
	jr sub_35d3h		;3633	18 9e 	. . 
l3635h:
	push bc			;3635	c5 	. 
	call sub_3bedh		;3636	cd ed 3b 	. . ; 
	pop bc			;3639	c1 	. 
	call sub_3227h		;363a	cd 27 32 	. ' 2 
	ret nz			;363d	c0 	. 
	ld a,(0ac09h)		;363e	3a 09 ac 	: . . 
	cp 018h		;3641	fe 18 	. . 
	jp z,l3193h		;3643	ca 93 31 	. . 1 
	jr l3635h		;3646	18 ed 	. . 
sub_3648h:
	ld de,0afffh		;3648	11 ff af 	. . . 
	ld hl,0b3ffh		;364b	21 ff b3 	! . . 
	ld a,055h		;364e	3e 55 	> U 
	ld c,(hl)			;3650	4e 	N 
l3651h:
	ld (hl),a			;3651	77 	w 
	cp (hl)			;3652	be 	. 
	jr nz,l365bh		;3653	20 06 	  . 
	rrca			;3655	0f 	. 
	jr c,l3651h		;3656	38 f9 	8 . 
	ld de,0b7ffh		;3658	11 ff b7 	. . . 
l365bh:
	ld (0aa9eh),de		;365b	ed 53 9e aa 	. S . . 
	ld (hl),c			;365f	71 	q 
	ret			;3660	c9 	. 
sub_3661h:
	call sub_36ceh		;3661	cd ce 36 	. . 6 
	ex de,hl			;3664	eb 	. 
	ld de,0ae70h		;3665	11 70 ae 	. p . 
	and a			;3668	a7 	. 
	sbc hl,de		;3669	ed 52 	. R 
	ret c			;366b	d8 	. 
	add hl,de			;366c	19 	. 
	ex de,hl			;366d	eb 	. 
	ld hl,(0ae1eh)		;366e	2a 1e ae 	* . . 
	and a			;3671	a7 	. 
	sbc hl,bc		;3672	ed 42 	. B 
	push bc			;3674	c5 	. 
	jr z,l3681h		;3675	28 0a 	( . 
	jr c,l3681h		;3677	38 08 	8 . 
	push de			;3679	d5 	. 
	push hl			;367a	e5 	. 
	push bc			;367b	c5 	. 
	pop hl			;367c	e1 	. 
	pop bc			;367d	c1 	. 
	ldir		;367e	ed b0 	. . 
	pop de			;3680	d1 	. 
l3681h:
	pop hl			;3681	e1 	. 
	and a			;3682	a7 	. 
	sbc hl,de		;3683	ed 52 	. R 
	ld c,l			;3685	4d 	M 
	ld b,h			;3686	44 	D 
	ld hl,(0aa9eh)		;3687	2a 9e aa 	* . . 
	and a			;368a	a7 	. 
	sbc hl,de		;368b	ed 52 	. R 
	ret c			;368d	d8 	. 
	ld hl,(0ae1eh)		;368e	2a 1e ae 	* . . 
	sbc hl,bc		;3691	ed 42 	. B 
	ld (0ae1eh),hl		;3693	22 1e ae 	" . . 
	xor a			;3696	af 	. 
	ld hl,0ae20h		;3697	21 20 ae 	!   . 
l369ah:
	inc a			;369a	3c 	< 
	cp 029h		;369b	fe 29 	. ) 
	ret nc			;369d	d0 	. 
	push de			;369e	d5 	. 
	push hl			;369f	e5 	. 
	push de			;36a0	d5 	. 
	ld e,(hl)			;36a1	5e 	^ 
	inc hl			;36a2	23 	# 
	ld d,(hl)			;36a3	56 	V 
	pop hl			;36a4	e1 	. 
	push hl			;36a5	e5 	. 
	and a			;36a6	a7 	. 
	sbc hl,de		;36a7	ed 52 	. R 
	ex de,hl			;36a9	eb 	. 
	pop de			;36aa	d1 	. 
	jr nc,l36c8h		;36ab	30 1b 	0 . 
	ccf			;36ad	3f 	? 
	push de			;36ae	d5 	. 
	ld de,(0aa9eh)		;36af	ed 5b 9e aa 	. [ . . 
	push hl			;36b3	e5 	. 
	sbc hl,de		;36b4	ed 52 	. R 
	dec hl			;36b6	2b 	+ 
	dec hl			;36b7	2b 	+ 
	bit 7,h		;36b8	cb 7c 	. | 
	pop hl			;36ba	e1 	. 
	pop de			;36bb	d1 	. 
	jr z,l36c8h		;36bc	28 0a 	( . 
	and a			;36be	a7 	. 
	sbc hl,bc		;36bf	ed 42 	. B 
	ex de,hl			;36c1	eb 	. 
	ex (sp),hl			;36c2	e3 	. 
	ld (hl),e			;36c3	73 	s 
	inc hl			;36c4	23 	# 
	ld (hl),d			;36c5	72 	r 
	dec hl			;36c6	2b 	+ 
	ex (sp),hl			;36c7	e3 	. 
l36c8h:
	pop hl			;36c8	e1 	. 
	pop de			;36c9	d1 	. 
	inc hl			;36ca	23 	# 
	inc hl			;36cb	23 	# 
	jr l369ah		;36cc	18 cc 	. . 
sub_36ceh:
	add a,a			;36ce	87 	. 
	add a,a			;36cf	87 	. 
	ld c,a			;36d0	4f 	O 
	ld b,000h		;36d1	06 00 	. . 
	ld hl,0ae20h		;36d3	21 20 ae 	!   . 
	add hl,bc			;36d6	09 	. 
	ld e,(hl)			;36d7	5e 	^ 
	inc hl			;36d8	23 	# 
	ld d,(hl)			;36d9	56 	V 
	inc hl			;36da	23 	# 
	ld c,(hl)			;36db	4e 	N 
	inc hl			;36dc	23 	# 
	ld b,(hl)			;36dd	46 	F 
	ret			;36de	c9 	. 
	ld a,(ram_mode_flags)		;36df	3a 29 aa 	: ) . 
	and 040h		;36e2	e6 40 	. @ 
	ret nz			;36e4	c0 	. 
	rst 28h			;36e5	ef 	. 
	sub 041h		;36e6	d6 41 	. A 
	add a,a			;36e8	87 	. 
	ld b,a			;36e9	47 	G 
	add a,a			;36ea	87 	. 
	add a,a			;36eb	87 	. 
	add a,b			;36ec	80 	. 
	cp 00bh		;36ed	fe 0b 	. . 
	jr c,l36f3h		;36ef	38 02 	8 . 
	ld a,046h		;36f1	3e 46 	> F 
l36f3h:
	ld b,a			;36f3	47 	G 
	rst 28h			;36f4	ef 	. 
	sub 030h		;36f5	d6 30 	. 0 
	cp 00ah		;36f7	fe 0a 	. . 
	jr nc,l3718h		;36f9	30 1d 	0 . 
	add a,b			;36fb	80 	. 
	cp 014h		;36fc	fe 14 	. . 
	jr nc,l3718h		;36fe	30 18 	0 . 
sub_3700h:
	ld (0aaa0h),a		;3700	32 a0 aa 	2 . . 
	call sub_3661h		;3703	cd 61 36 	. a 6 
	ld b,000h		;3706	06 00 	. . 
	call sub_3798h		;3708	cd 98 37 	. . 7 
	ld a,0ffh		;370b	3e ff 	> . 
	ld (0aaa1h),a		;370d	32 a1 aa 	2 . . 
l3710h:
	ld hl,ram_mode_flags		;3710	21 29 aa 	! ) . 
	set 6,(hl)		;3713	cb f6 	. . 
	jp 00f87h		;3715	c3 87 0f 	. . . 
l3718h:
	ld hl,0abe2h		;3718	21 e2 ab 	! . . 
	ld (hl),003h		;371b	36 03 	6 . 
	jp 00f0dh		;371d	c3 0d 0f 	. . . 
l3720h:
	ld a,(ram_mode_flags)		;3720	3a 29 aa 	: ) . 
	and 040h		;3723	e6 40 	. @ 
	ret nz			;3725	c0 	. 
	ld a,c			;3726	79 	y 
	cp 014h		;3727	fe 14 	. . 
	ret nc			;3729	d0 	. 
	ld (0aaa0h),a		;372a	32 a0 aa 	2 . . 
	call sub_36ceh		;372d	cd ce 36 	. . 6 
	ld l,e			;3730	6b 	k 
	ld h,d			;3731	62 	b 
	and a			;3732	a7 	. 
	sbc hl,bc		;3733	ed 42 	. B 
	ret nc			;3735	d0 	. 
	ld a,(0aa2bh)		;3736	3a 2b aa 	: + . 
	and 080h		;3739	e6 80 	. . 
	ld a,002h		;373b	3e 02 	> . 
	jr z,l3743h		;373d	28 04 	( . 
	ld a,(de)			;373f	1a 	. 
	inc de			;3740	13 	. 
	and 003h		;3741	e6 03 	. . 
l3743h:
	ld (0aaa2h),a		;3743	32 a2 aa 	2 . . 
	ld (0aa9ah),de		;3746	ed 53 9a aa 	. S . . 
	jr l3710h		;374a	18 c4 	. . 
l374ch:
	ld hl,0aac3h		;374c	21 c3 aa 	! . . 
	ld a,(hl)			;374f	7e 	~ 
	and a			;3750	a7 	. 
	ld a,c			;3751	79 	y 
	jr nz,l377ch		;3752	20 28 	  ( 
	cp 010h		;3754	fe 10 	. . 
	jr nz,l3760h		;3756	20 08 	  . 
	ld a,(0aa2bh)		;3758	3a 2b aa 	: + . 
	and 080h		;375b	e6 80 	. . 
	jr nz,l3779h		;375d	20 1a 	  . 
	ld a,c			;375f	79 	y 
l3760h:
	ld hl,0aac4h		;3760	21 c4 aa 	! . . 
	cp (hl)			;3763	be 	. 
	jr z,sub_3780h		;3764	28 1a 	( . 
l3766h:
	ld bc,(0ae1eh)		;3766	ed 4b 1e ae 	. K . . 
	ld hl,(0aa9eh)		;376a	2a 9e aa 	* . . 
	and a			;376d	a7 	. 
	sbc hl,bc		;376e	ed 42 	. B 
	jr c,l3718h		;3770	38 a6 	8 . 
	ld (bc),a			;3772	02 	. 
	inc bc			;3773	03 	. 
	ld (0ae1eh),bc		;3774	ed 43 1e ae 	. C . . 
	ret			;3778	c9 	. 
l3779h:
	ld (hl),0ffh		;3779	36 ff 	6 . 
	ret			;377b	c9 	. 
l377ch:
	ld (hl),000h		;377c	36 00 	6 . 
	jr l3766h		;377e	18 e6 	. . 
sub_3780h:
	xor a			;3780	af 	. 
	ld (0aaa1h),a		;3781	32 a1 aa 	2 . . 
	ld b,002h		;3784	06 02 	. . 
	call sub_3798h		;3786	cd 98 37 	. . 7 
	call sub_3834h		;3789	cd 34 38 	. 4 8 
	ld hl,053ffh		;378c	21 ff 53 	! . S 
	ld de,0503ch		;378f	11 3c 50 	. < P 
	ld bc,0ae1eh		;3792	01 1e ae 	. . . 
	jp 009a6h		;3795	c3 a6 09 	. . . 
sub_3798h:
	ld a,(0aaa0h)		;3798	3a a0 aa 	: . . 
	add a,a			;379b	87 	. 
	add a,a			;379c	87 	. 
	add a,b			;379d	80 	. 
	ld c,a			;379e	4f 	O 
	ld b,000h		;379f	06 00 	. . 
	ld hl,0ae20h		;37a1	21 20 ae 	!   . 
	add hl,bc			;37a4	09 	. 
	ld bc,(0ae1eh)		;37a5	ed 4b 1e ae 	. K . . 
	ld (hl),c			;37a9	71 	q 
	inc hl			;37aa	23 	# 
	ld (hl),b			;37ab	70 	p 
	ret			;37ac	c9 	. 
sub_37adh:
	di			;37ad	f3 	. 
	ld hl,(0aa9ah)		;37ae	2a 9a aa 	* . . 
	ld a,(hl)			;37b1	7e 	~ 
	ld de,ram_esc_byte		;37b2	11 23 aa 	. # . 
	ld hl,ram_leadin_byte		;37b5	21 99 aa 	! . . 
	cp 080h		;37b8	fe 80 	. . 
	jr nc,l37cbh		;37ba	30 0f 	0 . 
	ld (de),a			;37bc	12 	. 
	cp (hl)			;37bd	be 	. 
	jr z,l37d7h		;37be	28 17 	( . 
	ld a,(ram_esc_state)		;37c0	3a 25 aa 	: % . 
	and a			;37c3	a7 	. 
	jr nz,l37d7h		;37c4	20 11 	  . 
	call 013afh		;37c6	cd af 13 	. . . 
	ei			;37c9	fb 	. 
	ret			;37ca	c9 	. 
l37cbh:
	and 07fh		;37cb	e6 7f 	.  
	push af			;37cd	f5 	. 
	ld a,(hl)			;37ce	7e 	~ 
	ld (de),a			;37cf	12 	. 
	call 04a10h		;37d0	cd 10 4a 	. . J 
	pop af			;37d3	f1 	. 
	ld (ram_esc_byte),a		;37d4	32 23 aa 	2 # . 
l37d7h:
	call 04a10h		;37d7	cd 10 4a 	. . J 
	ei			;37da	fb 	. 
	ret			;37db	c9 	. 
sub_37dch:
	ld hl,(0aa9ah)		;37dc	2a 9a aa 	* . . 
	ld a,(hl)			;37df	7e 	~ 
	cp 080h		;37e0	fe 80 	. . 
	ld c,a			;37e2	4f 	O 
	jp nc,00c27h		;37e3	d2 27 0c 	. ' . 
	rst 18h			;37e6	df 	. 
	ret			;37e7	c9 	. 
sub_37e8h:
	ld a,(ram_mode_flags)		;37e8	3a 29 aa 	: ) . 
	and 040h		;37eb	e6 40 	. @ 
	ret z			;37ed	c8 	. 
	ld a,(0aaa1h)		;37ee	3a a1 aa 	: . . 
	and a			;37f1	a7 	. 
	ret nz			;37f2	c0 	. 
	ld a,(0aaa0h)		;37f3	3a a0 aa 	: . . 
	call sub_36ceh		;37f6	cd ce 36 	. . 6 
	ld d,b			;37f9	50 	P 
	ld e,c			;37fa	59 	Y 
l37fbh:
	ld b,009h		;37fb	06 09 	. . 
l37fdh:
	push bc			;37fd	c5 	. 
	push de			;37fe	d5 	. 
	ld a,(ram_mode_flags)		;37ff	3a 29 aa 	: ) . 
	and 020h		;3802	e6 20 	.   
	jr nz,l381ah		;3804	20 14 	  . 
	ld a,(0aa2bh)		;3806	3a 2b aa 	: + . 
	and 080h		;3809	e6 80 	. . 
	call z,sub_383ch		;380b	cc 3c 38 	. < 8 
	ld a,(0aaa2h)		;380e	3a a2 aa 	: . . 
	push af			;3811	f5 	. 
	bit 0,a		;3812	cb 47 	. G 
	call nz,sub_37dch		;3814	c4 dc 37 	. . 7 
	pop af			;3817	f1 	. 
	bit 1,a		;3818	cb 4f 	. O 
l381ah:
	call nz,sub_37adh		;381a	c4 ad 37 	. . 7 
	ld hl,(0aa9ah)		;381d	2a 9a aa 	* . . 
	inc hl			;3820	23 	# 
	ld (0aa9ah),hl		;3821	22 9a aa 	" . . 
	pop de			;3824	d1 	. 
	pop bc			;3825	c1 	. 
	and a			;3826	a7 	. 
	sbc hl,de		;3827	ed 52 	. R 
	jr nc,sub_3834h		;3829	30 09 	0 . 
	djnz l37fdh		;382b	10 d0 	. . 
	ld a,(ram_esc_state)		;382d	3a 25 aa 	: % . 
	and a			;3830	a7 	. 
	jr nz,l37fbh		;3831	20 c8 	  . 
	ret			;3833	c9 	. 
sub_3834h:
	ld hl,ram_mode_flags		;3834	21 29 aa 	! ) . 
	res 6,(hl)		;3837	cb b6 	. . 
	jp 00f87h		;3839	c3 87 0f 	. . . 
sub_383ch:
	ld bc,(0aa9ah)		;383c	ed 4b 9a aa 	. K . . 
	ld hl,0aaa2h		;3840	21 a2 aa 	! . . 
	ld a,(bc)			;3843	0a 	. 
	bit 0,(hl)		;3844	cb 46 	. F 
	jr nz,l384fh		;3846	20 07 	  . 
	cp 0d3h		;3848	fe d3 	. . 
	ret nz			;384a	c0 	. 
	ld (hl),001h		;384b	36 01 	6 . 
	jr l3854h		;384d	18 05 	. . 
l384fh:
	cp 0d6h		;384f	fe d6 	. . 
	ret nz			;3851	c0 	. 
	ld (hl),002h		;3852	36 02 	6 . 
l3854h:
	inc bc			;3854	03 	. 
	ld (0aa9ah),bc		;3855	ed 43 9a aa 	. C . . 
	jr sub_383ch		;3859	18 e1 	. . 
sub_385bh:
	call sub_38b1h		;385b	cd b1 38 	. . 8 
	ld hl,0abf8h		;385e	21 f8 ab 	! . . 
	ld a,(hl)			;3861	7e 	~ 
	cp 001h		;3862	fe 01 	. . 
	jr z,l3887h		;3864	28 21 	( ! 
	dec (hl)			;3866	35 	5 
l3867h:
	call sub_38a9h		;3867	cd a9 38 	. . 8 
	call sub_38c5h		;386a	cd c5 38 	. . 8 
l386dh:
	call l3d43h		;386d	cd 43 3d 	. C = 
	xor a			;3870	af 	. 
	call 041dfh		;3871	cd df 41 	. . A 
	ld b,018h		;3874	06 18 	. . 
l3876h:
	bit 7,(hl)		;3876	cb 7e 	. ~ 
	jr z,l387bh		;3878	28 01 	( . 
	inc a			;387a	3c 	< 
l387bh:
	inc hl			;387b	23 	# 
	djnz l3876h		;387c	10 f8 	. . 
	ld (0ad68h),a		;387e	32 68 ad 	2 h . 
	call l2f22h		;3881	cd 22 2f 	. " / 
	jp 0450ah		;3884	c3 0a 45 	. . E 
l3887h:
	ld a,(0abf9h)		;3887	3a f9 ab 	: . . 
	ld (hl),a			;388a	77 	w 
	jr l3867h		;388b	18 da 	. . 
sub_388dh:
	call sub_38b1h		;388d	cd b1 38 	. . 8 
	ld a,(0abf8h)		;3890	3a f8 ab 	: . . 
	ld hl,0abf9h		;3893	21 f9 ab 	! . . 
	cp (hl)			;3896	be 	. 
	ld hl,0abf8h		;3897	21 f8 ab 	! . . 
	jr c,l38a6h		;389a	38 0a 	8 . 
	ld (hl),001h		;389c	36 01 	6 . 
l389eh:
	call sub_38a9h		;389e	cd a9 38 	. . 8 
	call sub_38c5h		;38a1	cd c5 38 	. . 8 
	jr l386dh		;38a4	18 c7 	. . 
l38a6h:
	inc (hl)			;38a6	34 	4 
	jr l389eh		;38a7	18 f5 	. . 
sub_38a9h:
	call sub_38b9h		;38a9	cd b9 38 	. . 8 
	ld a,(hl)			;38ac	7e 	~ 
	ld (0ac09h),a		;38ad	32 09 ac 	2 . . 
	ret			;38b0	c9 	. 
sub_38b1h:
	call sub_38b9h		;38b1	cd b9 38 	. . 8 
	ld a,(0ac09h)		;38b4	3a 09 ac 	: . . 
	ld (hl),a			;38b7	77 	w 
	ret			;38b8	c9 	. 
sub_38b9h:
	ld a,(0abf8h)		;38b9	3a f8 ab 	: . . 
	dec a			;38bc	3d 	= 
	ld d,000h		;38bd	16 00 	. . 
	ld e,a			;38bf	5f 	_ 
	ld hl,0abfbh		;38c0	21 fb ab 	! . . 
	add hl,de			;38c3	19 	. 
	ret			;38c4	c9 	. 
sub_38c5h:
	ld a,(0abf8h)		;38c5	3a f8 ab 	: . . 
	dec a			;38c8	3d 	= 
	jr z,l38d3h		;38c9	28 08 	( . 
	ld b,a			;38cb	47 	G 
	xor a			;38cc	af 	. 
	ld hl,0ac1dh		;38cd	21 1d ac 	! . . 
l38d0h:
	add a,(hl)			;38d0	86 	. 
	djnz l38d0h		;38d1	10 fd 	. . 
l38d3h:
	ld d,000h		;38d3	16 00 	. . 
	ld e,a			;38d5	5f 	_ 
	ld hl,0aac7h		;38d6	21 c7 aa 	! . . 
	add hl,de			;38d9	19 	. 
	ld (0ac1eh),hl		;38da	22 1e ac 	" . . 
	ret			;38dd	c9 	. 
	ld a,(ram_mode_flags)		;38de	3a 29 aa 	: ) . 
	bit 7,a		;38e1	cb 7f 	.  
	ret nz			;38e3	c0 	. 
	ld a,(0aa2ah)		;38e4	3a 2a aa 	: * . 
	bit 1,a		;38e7	cb 4f 	. O 
	jp nz,l39a5h		;38e9	c2 a5 39 	. . 9 
	ld a,(0ac1dh)		;38ec	3a 1d ac 	: . . 
	ld hl,0ac09h		;38ef	21 09 ac 	! . . 
	sub (hl)			;38f2	96 	. 
	ld hl,0abd8h		;38f3	21 d8 ab 	! . . 
	sub (hl)			;38f6	96 	. 
	dec a			;38f7	3d 	= 
	jr nz,l3911h		;38f8	20 17 	  . 
l38fah:
	ld hl,007c0h		;38fa	21 c0 07 	! . . 
	rst 20h			;38fd	e7 	. 
	jr z,l3907h		;38fe	28 07 	( . 
	xor a			;3900	af 	. 
	ld (0abd7h),a		;3901	32 d7 ab 	2 . . 
	call 0450ah		;3904	cd 0a 45 	. . E 
l3907h:
	ld a,(0abd8h)		;3907	3a d8 ab 	: . . 
	call 041dfh		;390a	cd df 41 	. . A 
	ld a,(hl)			;390d	7e 	~ 
	jp l3d9bh		;390e	c3 9b 3d 	. . = 
l3911h:
	ld c,a			;3911	4f 	O 
	call sub_39d5h		;3912	cd d5 39 	. . 9 
	ld a,c			;3915	79 	y 
	sub b			;3916	90 	. 
	ld b,a			;3917	47 	G 
	jr z,l38fah		;3918	28 e0 	( . 
	ld a,(0aa2ah)		;391a	3a 2a aa 	: * . 
	bit 2,a		;391d	cb 57 	. W 
	jr z,l3984h		;391f	28 63 	( c 
l3921h:
	ld a,(0abd8h)		;3921	3a d8 ab 	: . . 
	call 041dfh		;3924	cd df 41 	. . A 
	ld c,(hl)			;3927	4e 	N 
l3928h:
	ld d,h			;3928	54 	T 
	ld e,l			;3929	5d 	] 
	inc hl			;392a	23 	# 
	call 041eeh		;392b	cd ee 41 	. . A 
	ld a,(hl)			;392e	7e 	~ 
	ld (de),a			;392f	12 	. 
	djnz l3928h		;3930	10 f6 	. . 
	ld (hl),c			;3932	71 	q 
	ld a,c			;3933	79 	y 
l3934h:
	call l3d9bh		;3934	cd 9b 3d 	. . = 
l3937h:
	ld hl,007c0h		;3937	21 c0 07 	! . . 
	rst 20h			;393a	e7 	. 
	ld a,(0abd7h)		;393b	3a d7 ab 	: . . 
	jr z,l3944h		;393e	28 04 	( . 
	xor a			;3940	af 	. 
	ld (0abd7h),a		;3941	32 d7 ab 	2 . . 
l3944h:
	call l3d43h		;3944	cd 43 3d 	. C = 
	call 0450ah		;3947	cd 0a 45 	. . E 
	call 00cd8h		;394a	cd d8 0c 	. . . 
	ret z			;394d	c8 	. 
sub_394eh:
	ld b,017h		;394e	06 17 	. . 
	ld hl,(0abd7h)		;3950	2a d7 ab 	* . . 
	push hl			;3953	e5 	. 
	xor a			;3954	af 	. 
	ld h,a			;3955	67 	g 
	ld l,a			;3956	6f 	o 
	ld (0abd7h),hl		;3957	22 d7 ab 	" . . 
	ld (ram_attr_subsel),a		;395a	32 19 ac 	2 . . 
	call sub_2e17h		;395d	cd 17 2e 	. . . 
	inc a			;3960	3c 	< 
	ld hl,0aabdh		;3961	21 bd aa 	! . . 
l3964h:
	ld (0abd8h),a		;3964	32 d8 ab 	2 . . 
	bit 1,(hl)		;3967	cb 4e 	. N 
	jr nz,l396eh		;3969	20 03 	  . 
	call 016f7h		;396b	cd f7 16 	. . . 
l396eh:
	push af			;396e	f5 	. 
	xor a			;396f	af 	. 
	ld (0ad78h),a		;3970	32 78 ad 	2 x . 
	pop af			;3973	f1 	. 
	call sub_2e17h		;3974	cd 17 2e 	. . . 
	inc a			;3977	3c 	< 
	djnz l3964h		;3978	10 ea 	. . 
	pop hl			;397a	e1 	. 
	ld (0abd7h),hl		;397b	22 d7 ab 	" . . 
	call sub_2ea8h		;397e	cd a8 2e 	. . . 
	jp 0450ah		;3981	c3 0a 45 	. . E 
l3984h:
	ld a,(0ac1dh)		;3984	3a 1d ac 	: . . 
	dec a			;3987	3d 	= 
	ld d,000h		;3988	16 00 	. . 
	ld e,a			;398a	5f 	_ 
	ld hl,(0ac1eh)		;398b	2a 1e ac 	* . . 
	add hl,de			;398e	19 	. 
l398fh:
	call 041f4h		;398f	cd f4 41 	. . A 
	ld c,(hl)			;3992	4e 	N 
l3993h:
	ld d,h			;3993	54 	T 
	ld e,l			;3994	5d 	] 
	dec hl			;3995	2b 	+ 
	call 041f4h		;3996	cd f4 41 	. . A 
	ld a,(hl)			;3999	7e 	~ 
	ld (de),a			;399a	12 	. 
	djnz l3993h		;399b	10 f6 	. . 
	ld (hl),c			;399d	71 	q 
	ld a,c			;399e	79 	y 
	call l3d9bh		;399f	cd 9b 3d 	. . = 
	jp l3937h		;39a2	c3 37 39 	. 7 9 
l39a5h:
	call sub_3ab6h		;39a5	cd b6 3a 	. . : 
	ret c			;39a8	d8 	. 
	ld a,(0ac07h)		;39a9	3a 07 ac 	: . . 
	cp 001h		;39ac	fe 01 	. . 
	jr nz,l39b7h		;39ae	20 07 	  . 
l39b0h:
	ld hl,(0ac05h)		;39b0	2a 05 ac 	* . . 
	ld a,(hl)			;39b3	7e 	~ 
	jp l3934h		;39b4	c3 34 39 	. 4 9 
l39b7h:
	ld a,(0abd8h)		;39b7	3a d8 ab 	: . . 
	ld hl,0ab2dh		;39ba	21 2d ab 	! - . 
	cp (hl)			;39bd	be 	. 
	jr z,l39b0h		;39be	28 f0 	( . 
	ld a,(0ab2dh)		;39c0	3a 2d ab 	: - . 
	ld hl,0abd8h		;39c3	21 d8 ab 	! . . 
	sub (hl)			;39c6	96 	. 
	ld b,a			;39c7	47 	G 
	ld a,(0aa2ah)		;39c8	3a 2a aa 	: * . 
	bit 2,a		;39cb	cb 57 	. W 
	jp nz,l3921h		;39cd	c2 21 39 	. ! 9 
	ld hl,(0ac05h)		;39d0	2a 05 ac 	* . . 
	jr l398fh		;39d3	18 ba 	. . 
sub_39d5h:
	ld a,018h		;39d5	3e 18 	> . 
	ld hl,0abd8h		;39d7	21 d8 ab 	! . . 
	sub (hl)			;39da	96 	. 
	ld b,a			;39db	47 	G 
	ld a,(hl)			;39dc	7e 	~ 
	call 041dfh		;39dd	cd df 41 	. . A 
	xor a			;39e0	af 	. 
l39e1h:
	bit 7,(hl)		;39e1	cb 7e 	. ~ 
	jr z,l39e6h		;39e3	28 01 	( . 
	inc a			;39e5	3c 	< 
l39e6h:
	inc hl			;39e6	23 	# 
	djnz l39e1h		;39e7	10 f8 	. . 
	ld b,a			;39e9	47 	G 
	ret			;39ea	c9 	. 
	xor a			;39eb	af 	. 
	ld (0ac08h),a		;39ec	32 08 ac 	2 . . 
	call 00cd8h		;39ef	cd d8 0c 	. . . 
	jr z,l3a06h		;39f2	28 12 	( . 
	call 0179ch		;39f4	cd 9c 17 	. . . 
	ld a,(0d000h)		;39f7	3a 00 d0 	: . . 
	bit 5,a		;39fa	cb 6f 	. o 
	jr z,l3a06h		;39fc	28 08 	( . 
	ld a,0ffh		;39fe	3e ff 	> . 
	ld (0ac08h),a		;3a00	32 08 ac 	2 . . 
	call 016f7h		;3a03	cd f7 16 	. . . 
l3a06h:
	ld a,(0aa2bh)		;3a06	3a 2b aa 	: + . 
	and 008h		;3a09	e6 08 	. . 
	ret nz			;3a0b	c0 	. 
	ld a,(0aa2ah)		;3a0c	3a 2a aa 	: * . 
	bit 1,a		;3a0f	cb 4f 	. O 
	jr z,l3a17h		;3a11	28 04 	( . 
	call sub_3ab6h		;3a13	cd b6 3a 	. . : 
	ret c			;3a16	d8 	. 
l3a17h:
	ld a,(0aa2ah)		;3a17	3a 2a aa 	: * . 
	bit 2,a		;3a1a	cb 57 	. W 
	jp nz,l3b16h		;3a1c	c2 16 3b 	. . ; 
	bit 5,a		;3a1f	cb 6f 	. o 
	jr z,l3a41h		;3a21	28 1e 	( . 
	bit 1,a		;3a23	cb 4f 	. O 
	ld a,(0abd8h)		;3a25	3a d8 ab 	: . . 
	ld (0ac1ah),a		;3a28	32 1a ac 	2 . . 
	ld b,a			;3a2b	47 	G 
	jr z,l3a36h		;3a2c	28 08 	( . 
	ld a,(0ab2dh)		;3a2e	3a 2d ab 	: - . 
	sub b			;3a31	90 	. 
	inc a			;3a32	3c 	< 
	ld c,a			;3a33	4f 	O 
	jr l3a43h		;3a34	18 0d 	. . 
l3a36h:
	ld a,(0ac1dh)		;3a36	3a 1d ac 	: . . 
	sub b			;3a39	90 	. 
	ld hl,0ac09h		;3a3a	21 09 ac 	! . . 
	sub (hl)			;3a3d	96 	. 
	ld c,a			;3a3e	4f 	O 
	jr l3a43h		;3a3f	18 02 	. . 
l3a41h:
	ld c,001h		;3a41	0e 01 	. . 
l3a43h:
	ld a,(0ab2fh)		;3a43	3a 2f ab 	: / . 
	ld (0ac16h),a		;3a46	32 16 ac 	2 . . 
	ld a,(ram_mode_flags)		;3a49	3a 29 aa 	: ) . 
	and 010h		;3a4c	e6 10 	. . 
	ld a,(0ac28h)		;3a4e	3a 28 ac 	: ( . 
	jr nz,l3a64h		;3a51	20 11 	  . 
	call 0179ch		;3a53	cd 9c 17 	. . . 
	ld a,(0d000h)		;3a56	3a 00 d0 	: . . 
	bit 5,a		;3a59	cb 6f 	. o 
	jr z,l3a62h		;3a5b	28 05 	( . 
	call 016f7h		;3a5d	cd f7 16 	. . . 
	jr l3a64h		;3a60	18 02 	. . 
l3a62h:
	and 00fh		;3a62	e6 0f 	. . 
l3a64h:
	ld (ram_tab_flags),a		;3a64	32 18 ac 	2 . . 
	ld a,04fh		;3a67	3e 4f 	> O 
	ld hl,0abd7h		;3a69	21 d7 ab 	! . . 
	sub (hl)			;3a6c	96 	. 
	inc a			;3a6d	3c 	< 
	ld b,a			;3a6e	47 	G 
	ld hl,(06004h)		;3a6f	2a 04 60 	* . ` 
l3a72h:
	call sub_3ae3h		;3a72	cd e3 3a 	. . : 
	dec c			;3a75	0d 	. 
	jr z,l3a7fh		;3a76	28 07 	( . 
	ld b,050h		;3a78	06 50 	. P 
	call sub_3ac4h		;3a7a	cd c4 3a 	. . : 
	jr l3a72h		;3a7d	18 f3 	. . 
l3a7fh:
	call 00cd8h		;3a7f	cd d8 0c 	. . . 
	ret z			;3a82	c8 	. 
	ld a,(ram_tab_flags)		;3a83	3a 18 ac 	: . . 
	bit 5,a		;3a86	cb 6f 	. o 
	jr z,l3aadh		;3a88	28 23 	( # 
	call 017a0h		;3a8a	cd a0 17 	. . . 
	ld a,(0d000h)		;3a8d	3a 00 d0 	: . . 
	ld (ram_attr_subsel),a		;3a90	32 19 ac 	2 . . 
	ld hl,(0abd7h)		;3a93	2a d7 ab 	* . . 
	ld a,(0ab27h)		;3a96	3a 27 ab 	: ' . 
	cp h			;3a99	bc 	. 
	jr z,l3aadh		;3a9a	28 11 	( . 
	push hl			;3a9c	e5 	. 
	inc h			;3a9d	24 	$ 
	ld l,000h		;3a9e	2e 00 	. . 
	ld (0abd7h),hl		;3aa0	22 d7 ab 	" . . 
	call sub_2e17h		;3aa3	cd 17 2e 	. . . 
	pop hl			;3aa6	e1 	. 
	ld (0abd7h),hl		;3aa7	22 d7 ab 	" . . 
	call 0450ah		;3aaa	cd 0a 45 	. . E 
l3aadh:
	call 00cd8h		;3aad	cd d8 0c 	. . . 
	jp nz,sub_394eh		;3ab0	c2 4e 39 	. N 9 
	jp 0450ah		;3ab3	c3 0a 45 	. . E 
sub_3ab6h:
	ld a,(0abd8h)		;3ab6	3a d8 ab 	: . . 
	ld hl,0ab2eh		;3ab9	21 2e ab 	! . . 
	cp (hl)			;3abc	be 	. 
	ret c			;3abd	d8 	. 
	ld b,a			;3abe	47 	G 
	ld a,(0ab2dh)		;3abf	3a 2d ab 	: - . 
	cp b			;3ac2	b8 	. 
	ret			;3ac3	c9 	. 
sub_3ac4h:
	ld hl,0ac1ah		;3ac4	21 1a ac 	! . . 
	inc (hl)			;3ac7	34 	4 
	ld a,(hl)			;3ac8	7e 	~ 
	call 041dfh		;3ac9	cd df 41 	. . A 
	bit 7,(hl)		;3acc	cb 7e 	. ~ 
	jp z,sub_33a9h		;3ace	ca a9 33 	. . 3 
	dec c			;3ad1	0d 	. 
	jr nz,sub_3ac4h		;3ad2	20 f0 	  . 
	pop af			;3ad4	f1 	. 
	pop af			;3ad5	f1 	. 
	dec hl			;3ad6	2b 	+ 
	ld a,(hl)			;3ad7	7e 	~ 
	push de			;3ad8	d5 	. 
	call sub_3d35h		;3ad9	cd 35 3d 	. 5 = 
	ld hl,0004fh		;3adc	21 4f 00 	! O . 
	add hl,de			;3adf	19 	. 
	pop de			;3ae0	d1 	. 
	jr l3b56h		;3ae1	18 73 	. s 
sub_3ae3h:
	rst 10h			;3ae3	d7 	. 
	ld (06006h),hl		;3ae4	22 06 60 	" . ` 
	call 017a0h		;3ae7	cd a0 17 	. . . 
	ld a,(ram_mode_flags)		;3aea	3a 29 aa 	: ) . 
	bit 7,a		;3aed	cb 7f 	.  
	jr z,l3afbh		;3aef	28 0a 	( . 
	ld a,(0d000h)		;3af1	3a 00 d0 	: . . 
	bit 4,a		;3af4	cb 67 	. g 
	jr z,l3afbh		;3af6	28 03 	( . 
	ld c,001h		;3af8	0e 01 	. . 
	ret			;3afa	c9 	. 
l3afbh:
	ld a,(0ac16h)		;3afb	3a 16 ac 	: . . 
	ld e,a			;3afe	5f 	_ 
	ld a,(ram_tab_flags)		;3aff	3a 18 ac 	: . . 
	ld d,a			;3b02	57 	W 
	ld a,(0c000h)		;3b03	3a 00 c0 	: . . 
	ld (0ac16h),a		;3b06	32 16 ac 	2 . . 
	ld a,(0d000h)		;3b09	3a 00 d0 	: . . 
	ld (ram_tab_flags),a		;3b0c	32 18 ac 	2 . . 
	call 01777h		;3b0f	cd 77 17 	. w . 
	inc hl			;3b12	23 	# 
	djnz sub_3ae3h		;3b13	10 ce 	. . 
	ret			;3b15	c9 	. 
l3b16h:
	bit 5,a		;3b16	cb 6f 	. o 
	jr z,l3b38h		;3b18	28 1e 	( . 
	bit 1,a		;3b1a	cb 4f 	. O 
	ld a,(0abd8h)		;3b1c	3a d8 ab 	: . . 
	ld b,a			;3b1f	47 	G 
	ld (0ac1ah),a		;3b20	32 1a ac 	2 . . 
	jr z,l3b2dh		;3b23	28 08 	( . 
	ld a,(0ab2dh)		;3b25	3a 2d ab 	: - . 
	sub b			;3b28	90 	. 
	inc a			;3b29	3c 	< 
	ld c,a			;3b2a	4f 	O 
	jr l3b3ah		;3b2b	18 0d 	. . 
l3b2dh:
	ld a,(0ac1dh)		;3b2d	3a 1d ac 	: . . 
	sub b			;3b30	90 	. 
	ld hl,0ac09h		;3b31	21 09 ac 	! . . 
	sub (hl)			;3b34	96 	. 
	ld c,a			;3b35	4f 	O 
	jr l3b3ah		;3b36	18 02 	. . 
l3b38h:
	ld c,001h		;3b38	0e 01 	. . 
l3b3ah:
	ld hl,0abd7h		;3b3a	21 d7 ab 	! . . 
	ld a,04fh		;3b3d	3e 4f 	> O 
	sub (hl)			;3b3f	96 	. 
	ld hl,(06004h)		;3b40	2a 04 60 	* . ` 
	jr z,l3b49h		;3b43	28 04 	( . 
	ld b,a			;3b45	47 	G 
l3b46h:
	call sub_3ba9h		;3b46	cd a9 3b 	. . ; 
l3b49h:
	dec c			;3b49	0d 	. 
	jr z,l3b56h		;3b4a	28 0a 	( . 
	ld (0ac1bh),hl		;3b4c	22 1b ac 	" . . 
	call sub_3b8bh		;3b4f	cd 8b 3b 	. . ; 
	ld b,04fh		;3b52	06 4f 	. O 
	jr l3b46h		;3b54	18 f0 	. . 
l3b56h:
	rst 10h			;3b56	d7 	. 
	ld (06006h),hl		;3b57	22 06 60 	" . ` 
	ld a,(0ab2fh)		;3b5a	3a 2f ab 	: / . 
	ld e,a			;3b5d	5f 	_ 
	ld a,(ram_mode_flags)		;3b5e	3a 29 aa 	: ) . 
	and 010h		;3b61	e6 10 	. . 
	ld a,(0ac28h)		;3b63	3a 28 ac 	: ( . 
	jr nz,l3b6bh		;3b66	20 03 	  . 
	ld a,d			;3b68	7a 	z 
	and 00fh		;3b69	e6 0f 	. . 
l3b6bh:
	ld d,a			;3b6b	57 	W 
	call 01777h		;3b6c	cd 77 17 	. w . 
	ld a,(0ac08h)		;3b6f	3a 08 ac 	: . . 
	and a			;3b72	a7 	. 
	jr z,l3b88h		;3b73	28 13 	( . 
	ld hl,(0abd7h)		;3b75	2a d7 ab 	* . . 
	push hl			;3b78	e5 	. 
	ld hl,(06004h)		;3b79	2a 04 60 	* . ` 
	push hl			;3b7c	e5 	. 
	call sub_2e17h		;3b7d	cd 17 2e 	. . . 
	pop hl			;3b80	e1 	. 
	ld (06004h),hl		;3b81	22 04 60 	" . ` 
	pop hl			;3b84	e1 	. 
	ld (0abd7h),hl		;3b85	22 d7 ab 	" . . 
l3b88h:
	jp l3aadh		;3b88	c3 ad 3a 	. . : 
sub_3b8bh:
	call sub_3ac4h		;3b8b	cd c4 3a 	. . : 
	rst 10h			;3b8e	d7 	. 
	ld (06006h),hl		;3b8f	22 06 60 	" . ` 
	call 017a0h		;3b92	cd a0 17 	. . . 
	ld de,(0ac1bh)		;3b95	ed 5b 1b ac 	. [ . . 
	ld (06006h),de		;3b99	ed 53 06 60 	. S . ` 
	ld a,(0c000h)		;3b9d	3a 00 c0 	: . . 
	ld e,a			;3ba0	5f 	_ 
	ld a,(0d000h)		;3ba1	3a 00 d0 	: . . 
	ld d,a			;3ba4	57 	W 
	call 01777h		;3ba5	cd 77 17 	. w . 
	ret			;3ba8	c9 	. 
sub_3ba9h:
	inc hl			;3ba9	23 	# 
	rst 10h			;3baa	d7 	. 
	ld (06006h),hl		;3bab	22 06 60 	" . ` 
	call 017a0h		;3bae	cd a0 17 	. . . 
	ld a,(0d000h)		;3bb1	3a 00 d0 	: . . 
	ld d,a			;3bb4	57 	W 
	ld a,(ram_mode_flags)		;3bb5	3a 29 aa 	: ) . 
	and 080h		;3bb8	e6 80 	. . 
	jr z,l3bc7h		;3bba	28 0b 	( . 
	bit 4,d		;3bbc	cb 62 	. b 
	jr z,l3bc7h		;3bbe	28 07 	( . 
	call sub_3bd7h		;3bc0	cd d7 3b 	. . ; 
	dec hl			;3bc3	2b 	+ 
	ld c,001h		;3bc4	0e 01 	. . 
	ret			;3bc6	c9 	. 
l3bc7h:
	ld a,(0c000h)		;3bc7	3a 00 c0 	: . . 
	ld e,a			;3bca	5f 	_ 
	dec hl			;3bcb	2b 	+ 
	ld (06006h),hl		;3bcc	22 06 60 	" . ` 
	call 01777h		;3bcf	cd 77 17 	. w . 
	inc hl			;3bd2	23 	# 
	djnz sub_3ba9h		;3bd3	10 d4 	. . 
	rst 10h			;3bd5	d7 	. 
	ret			;3bd6	c9 	. 
sub_3bd7h:
	call 00cd8h		;3bd7	cd d8 0c 	. . . 
	ret z			;3bda	c8 	. 
	bit 5,d		;3bdb	cb 6a 	. j 
	ret z			;3bdd	c8 	. 
	dec hl			;3bde	2b 	+ 
	ld (06006h),hl		;3bdf	22 06 60 	" . ` 
	call 017a0h		;3be2	cd a0 17 	. . . 
	ld a,(0d000h)		;3be5	3a 00 d0 	: . . 
	and 06fh		;3be8	e6 6f 	. o 
	ld d,a			;3bea	57 	W 
	inc hl			;3beb	23 	# 
	ret			;3bec	c9 	. 
sub_3bedh:
	ld a,(0ac09h)		;3bed	3a 09 ac 	: . . 
	and a			;3bf0	a7 	. 
	ret z			;3bf1	c8 	. 
	ld a,(0ad68h)		;3bf2	3a 68 ad 	: h . 
	and a			;3bf5	a7 	. 
	jp nz,041afh		;3bf6	c2 af 41 	. . A 
	ld a,(0ac36h)		;3bf9	3a 36 ac 	: 6 . 
	and a			;3bfc	a7 	. 
	ret nz			;3bfd	c0 	. 
	ld a,(0aa2ah)		;3bfe	3a 2a aa 	: * . 
	bit 1,a		;3c01	cb 4f 	. O 
	jr z,l3c19h		;3c03	28 14 	( . 
	call sub_3ceeh		;3c05	cd ee 3c 	. . < 
	ld b,000h		;3c08	06 00 	. . 
	ld a,(0ac07h)		;3c0a	3a 07 ac 	: . . 
	ld c,a			;3c0d	4f 	O 
	ld hl,(0ac03h)		;3c0e	2a 03 ac 	* . . 
	dec hl			;3c11	2b 	+ 
	ld a,(hl)			;3c12	7e 	~ 
	ld d,h			;3c13	54 	T 
	ld e,l			;3c14	5d 	] 
	inc hl			;3c15	23 	# 
	ldir		;3c16	ed b0 	. . 
	ld (de),a			;3c18	12 	. 
l3c19h:
	ld hl,0ac09h		;3c19	21 09 ac 	! . . 
	dec (hl)			;3c1c	35 	5 
l3c1dh:
	ld b,0ffh		;3c1d	06 ff 	. . 
	jr l3c58h		;3c1f	18 37 	. 7 
sub_3c21h:
	ld a,(0ac09h)		;3c21	3a 09 ac 	: . . 
	add a,018h		;3c24	c6 18 	. . 
	ld hl,0ac1dh		;3c26	21 1d ac 	! . . 
	cp (hl)			;3c29	be 	. 
	ret z			;3c2a	c8 	. 
	ld a,(0ac36h)		;3c2b	3a 36 ac 	: 6 . 
	and a			;3c2e	a7 	. 
	ret nz			;3c2f	c0 	. 
	ld a,(0ad68h)		;3c30	3a 68 ad 	: h . 
	and a			;3c33	a7 	. 
	jp nz,0417eh		;3c34	c2 7e 41 	. ~ A 
	ld a,(0aa2ah)		;3c37	3a 2a aa 	: * . 
	bit 1,a		;3c3a	cb 4f 	. O 
	jr z,l3c52h		;3c3c	28 14 	( . 
	call sub_3ceeh		;3c3e	cd ee 3c 	. . < 
	ld b,000h		;3c41	06 00 	. . 
	ld hl,0ac07h		;3c43	21 07 ac 	! . . 
	ld c,(hl)			;3c46	4e 	N 
	ld hl,(0ac05h)		;3c47	2a 05 ac 	* . . 
	inc hl			;3c4a	23 	# 
	ld a,(hl)			;3c4b	7e 	~ 
	ld d,h			;3c4c	54 	T 
	ld e,l			;3c4d	5d 	] 
	dec hl			;3c4e	2b 	+ 
	lddr		;3c4f	ed b8 	. . 
	ld (de),a			;3c51	12 	. 
l3c52h:
	ld hl,0ac09h		;3c52	21 09 ac 	! . . 
	inc (hl)			;3c55	34 	4 
l3c56h:
	ld b,001h		;3c56	06 01 	. . 
l3c58h:
	push bc			;3c58	c5 	. 
	call l3d43h		;3c59	cd 43 3d 	. C = 
	call 00cd8h		;3c5c	cd d8 0c 	. . . 
	call nz,sub_394eh		;3c5f	c4 4e 39 	. N 9 
	call sub_3ceeh		;3c62	cd ee 3c 	. . < 
	pop bc			;3c65	c1 	. 
	ret			;3c66	c9 	. 
sub_3c67h:
	call sub_325fh		;3c67	cd 5f 32 	. _ 2 
	jr l3c1dh		;3c6a	18 b1 	. . 
sub_3c6ch:
	call sub_326dh		;3c6c	cd 6d 32 	. m 2 
	jr l3c56h		;3c6f	18 e5 	. . 
sub_3c71h:
	call 00c69h		;3c71	cd 69 0c 	. i . 
	call 00c81h		;3c74	cd 81 0c 	. . . 
	ld a,001h		;3c77	3e 01 	> . 
	ld (0abfah),a		;3c79	32 fa ab 	2 . . 
	call sub_3caah		;3c7c	cd aa 3c 	. . < 
	ld a,(0abfah)		;3c7f	3a fa ab 	: . . 
	ld (0abf9h),a		;3c82	32 f9 ab 	2 . . 
	cp 001h		;3c85	fe 01 	. . 
	jr nz,l3c8eh		;3c87	20 05 	  . 
	ld hl,00800h		;3c89	21 00 08 	! . . 
	jr l3c99h		;3c8c	18 0b 	. . 
l3c8eh:
	ld hl,00780h		;3c8e	21 80 07 	! . . 
	ld b,a			;3c91	47 	G 
	dec b			;3c92	05 	. 
	ld de,00800h		;3c93	11 00 08 	. . . 
l3c96h:
	add hl,de			;3c96	19 	. 
	djnz l3c96h		;3c97	10 fd 	. . 
l3c99h:
	ld (0ac4dh),hl		;3c99	22 4d ac 	" M . 
	call 00ca0h		;3c9c	cd a0 0c 	. . . 
	call sub_3cd7h		;3c9f	cd d7 3c 	. . < 
	ld a,(0abe2h)		;3ca2	3a e2 ab 	: . . 
	and a			;3ca5	a7 	. 
	jp nz,00f0dh		;3ca6	c2 0d 0f 	. . . 
	ret			;3ca9	c9 	. 
sub_3caah:
	ld b,003h		;3caa	06 03 	. . 
	ld de,00c00h		;3cac	11 00 0c 	. . . 
l3cafh:
	ld (06006h),de		;3caf	ed 53 06 60 	. S . ` 
	push de			;3cb3	d5 	. 
	ld de,05555h		;3cb4	11 55 55 	. U U 
	call 01777h		;3cb7	cd 77 17 	. w . 
	call 017a0h		;3cba	cd a0 17 	. . . 
	pop de			;3cbd	d1 	. 
	ld a,(0c000h)		;3cbe	3a 00 c0 	: . . 
	cp 055h		;3cc1	fe 55 	. U 
	ret nz			;3cc3	c0 	. 
	ld a,(0d000h)		;3cc4	3a 00 d0 	: . . 
	cp 055h		;3cc7	fe 55 	. U 
	ret nz			;3cc9	c0 	. 
	ld hl,0abfah		;3cca	21 fa ab 	! . . 
	inc (hl)			;3ccd	34 	4 
	ld hl,00800h		;3cce	21 00 08 	! . . 
	add hl,de			;3cd1	19 	. 
	ld d,h			;3cd2	54 	T 
	ld e,l			;3cd3	5d 	] 
	djnz l3cafh		;3cd4	10 d9 	. . 
	ret			;3cd6	c9 	. 
sub_3cd7h:
	ld de,04fffh		;3cd7	11 ff 4f 	. . O 
	xor a			;3cda	af 	. 
	ld h,a			;3cdb	67 	g 
	ld l,a			;3cdc	6f 	o 
l3cddh:
	add a,(hl)			;3cdd	86 	. 
	inc hl			;3cde	23 	# 
	and a			;3cdf	a7 	. 
	push hl			;3ce0	e5 	. 
	sbc hl,de		;3ce1	ed 52 	. R 
	pop hl			;3ce3	e1 	. 
	jr c,l3cddh		;3ce4	38 f7 	8 . 
	cp (hl)			;3ce6	be 	. 
	ret z			;3ce7	c8 	. 
	ld a,008h		;3ce8	3e 08 	> . 
	ld (0abe2h),a		;3cea	32 e2 ab 	2 . . 
	ret			;3ced	c9 	. 
sub_3ceeh:
	xor a			;3cee	af 	. 
	ld d,a			;3cef	57 	W 
	call 041dfh		;3cf0	cd df 41 	. . A 
	ld (0ac49h),hl		;3cf3	22 49 ac 	" I . 
	ld b,h			;3cf6	44 	D 
	ld c,l			;3cf7	4d 	M 
	ld a,(0ab2eh)		;3cf8	3a 2e ab 	: . . 
	ld e,a			;3cfb	5f 	_ 
	add hl,de			;3cfc	19 	. 
	ld (0ac03h),hl		;3cfd	22 03 ac 	" . . 
	ld h,b			;3d00	60 	` 
	ld l,c			;3d01	69 	i 
	ld a,(0ab2dh)		;3d02	3a 2d ab 	: - . 
	ld e,a			;3d05	5f 	_ 
	add hl,de			;3d06	19 	. 
	ld (0ac05h),hl		;3d07	22 05 ac 	" . . 
	ld a,(0ab27h)		;3d0a	3a 27 ab 	: ' . 
	ld e,a			;3d0d	5f 	_ 
	ld h,b			;3d0e	60 	` 
	ld l,c			;3d0f	69 	i 
	add hl,de			;3d10	19 	. 
	ld (0ac4bh),hl		;3d11	22 4b ac 	" K . 
	ld hl,0ab2eh		;3d14	21 2e ab 	! . . 
	ld a,(0ab2dh)		;3d17	3a 2d ab 	: - . 
	sub (hl)			;3d1a	96 	. 
	inc a			;3d1b	3c 	< 
	ld (0ac07h),a		;3d1c	32 07 ac 	2 . . 
	ret			;3d1f	c9 	. 
sub_3d20h:
	ld d,000h		;3d20	16 00 	. . 
	rlca			;3d22	07 	. 
	ld e,a			;3d23	5f 	_ 
	ld a,(0aa88h)		;3d24	3a 88 aa 	: . . 
	cp 001h		;3d27	fe 01 	. . 
	jr nz,l3d30h		;3d29	20 05 	  . 
	ld hl,0accbh		;3d2b	21 cb ac 	! . . 
	jr l3d3eh		;3d2e	18 0e 	. . 
l3d30h:
	ld hl,0a951h		;3d30	21 51 a9 	! Q . 
	jr l3d3eh		;3d33	18 09 	. . 
sub_3d35h:
	and 07fh		;3d35	e6 7f 	.  
	rlca			;3d37	07 	. 
	ld d,000h		;3d38	16 00 	. . 
	ld e,a			;3d3a	5f 	_ 
	ld hl,l3dd6h		;3d3b	21 d6 3d 	! . = 
l3d3eh:
	add hl,de			;3d3e	19 	. 
	ld e,(hl)			;3d3f	5e 	^ 
	inc hl			;3d40	23 	# 
	ld d,(hl)			;3d41	56 	V 
	ret			;3d42	c9 	. 
l3d43h:
	ld a,(0accah)		;3d43	3a ca ac 	: . . 
	and a			;3d46	a7 	. 
	jr z,l3d4eh		;3d47	28 05 	( . 
	ld bc,0accbh		;3d49	01 cb ac 	. . . 
	jr l3d51h		;3d4c	18 03 	. . 
l3d4eh:
	ld bc,0a951h		;3d4e	01 51 a9 	. Q . 
l3d51h:
	ld a,(0ab27h)		;3d51	3a 27 ab 	: ' . 
	inc a			;3d54	3c 	< 
	ld (0accah),a		;3d55	32 ca ac 	2 . . 
	ld hl,0ac09h		;3d58	21 09 ac 	! . . 
	ld e,(hl)			;3d5b	5e 	^ 
	ld d,000h		;3d5c	16 00 	. . 
	ld hl,(0ac1eh)		;3d5e	2a 1e ac 	* . . 
	add hl,de			;3d61	19 	. 
	jr l3d65h		;3d62	18 01 	. . 
l3d64h:
	inc hl			;3d64	23 	# 
l3d65h:
	ld a,(hl)			;3d65	7e 	~ 
	push hl			;3d66	e5 	. 
	and 07fh		;3d67	e6 7f 	.  
	rlca			;3d69	07 	. 
	ld e,a			;3d6a	5f 	_ 
	ld d,000h		;3d6b	16 00 	. . 
	ld hl,l3dd6h		;3d6d	21 d6 3d 	! . = 
	add hl,de			;3d70	19 	. 
	ld a,(hl)			;3d71	7e 	~ 
	ld (bc),a			;3d72	02 	. 
	inc hl			;3d73	23 	# 
	inc bc			;3d74	03 	. 
	ld a,(hl)			;3d75	7e 	~ 
	ld (bc),a			;3d76	02 	. 
	inc bc			;3d77	03 	. 
	ld hl,0accah		;3d78	21 ca ac 	! . . 
	dec (hl)			;3d7b	35 	5 
	pop hl			;3d7c	e1 	. 
	jr nz,l3d64h		;3d7d	20 e5 	  . 
	xor a			;3d7f	af 	. 
	ld (bc),a			;3d80	02 	. 
	inc bc			;3d81	03 	. 
	ld (bc),a			;3d82	02 	. 
	ret			;3d83	c9 	. 
sub_3d84h:
	push af			;3d84	f5 	. 
	push bc			;3d85	c5 	. 
	push hl			;3d86	e5 	. 
	call sub_3dcah		;3d87	cd ca 3d 	. . = 
	call 00cd8h		;3d8a	cd d8 0c 	. . . 
	jr z,l3d94h		;3d8d	28 05 	( . 
	ld a,(ram_attr_subsel)		;3d8f	3a 19 ac 	: . . 
	jr l3da6h		;3d92	18 12 	. . 
l3d94h:
	ld a,(0ac28h)		;3d94	3a 28 ac 	: ( . 
	and 06fh		;3d97	e6 6f 	. o 
	jr l3da6h		;3d99	18 0b 	. . 
l3d9bh:
	push af			;3d9b	f5 	. 
	push bc			;3d9c	c5 	. 
	push hl			;3d9d	e5 	. 
	call sub_3dcah		;3d9e	cd ca 3d 	. . = 
	ld a,(0ac28h)		;3da1	3a 28 ac 	: ( . 
	and 06fh		;3da4	e6 6f 	. o 
l3da6h:
	ld (0d000h),a		;3da6	32 00 d0 	2 . . 
	ld c,0a2h		;3da9	0e a2 	. . 
	ld de,06001h		;3dab	11 01 60 	. . ` 
	ld b,050h		;3dae	06 50 	. P 
l3db0h:
	ld a,(06001h)		;3db0	3a 01 60 	: . ` 
	and 020h		;3db3	e6 20 	.   
	jr z,l3db0h		;3db5	28 f9 	( . 
	ld (06006h),hl		;3db7	22 06 60 	" . ` 
l3dbah:
	ld a,(0acfdh)		;3dba	3a fd ac 	: . . 
	and a			;3dbd	a7 	. 
	jr nz,l3dbah		;3dbe	20 fa 	  . 
	ld a,c			;3dc0	79 	y 
	ld (de),a			;3dc1	12 	. 
	inc hl			;3dc2	23 	# 
	djnz l3db0h		;3dc3	10 eb 	. . 
	rst 10h			;3dc5	d7 	. 
	pop hl			;3dc6	e1 	. 
	pop bc			;3dc7	c1 	. 
	pop af			;3dc8	f1 	. 
	ret			;3dc9	c9 	. 
sub_3dcah:
	call sub_3d35h		;3dca	cd 35 3d 	. 5 = 
	ex de,hl			;3dcd	eb 	. 
	rst 10h			;3dce	d7 	. 
	ld a,(0ab2fh)		;3dcf	3a 2f ab 	: / . 
	ld (0c000h),a		;3dd2	32 00 c0 	2 . . 
	ret			;3dd5	c9 	. 
l3dd6h:
	add a,b			;3dd6	80 	. 
	nop			;3dd7	00 	. 
	ret nc			;3dd8	d0 	. 
	nop			;3dd9	00 	. 
	jr nz,l3dddh		;3dda	20 01 	  . 
	ld (hl),b			;3ddc	70 	p 
l3dddh:
	ld bc,001c0h		;3ddd	01 c0 01 	. . . 
	djnz l3de4h		;3de0	10 02 	. . 
	ld h,b			;3de2	60 	` 
	ld (bc),a			;3de3	02 	. 
l3de4h:
	or b			;3de4	b0 	. 
	ld (bc),a			;3de5	02 	. 
	nop			;3de6	00 	. 
	inc bc			;3de7	03 	. 
	ld d,b			;3de8	50 	P 
	inc bc			;3de9	03 	. 
	and b			;3dea	a0 	. 
	inc bc			;3deb	03 	. 
	ret p			;3dec	f0 	. 
	inc bc			;3ded	03 	. 
	ld b,b			;3dee	40 	@ 
	inc b			;3def	04 	. 
	sub b			;3df0	90 	. 
	inc b			;3df1	04 	. 
	ret po			;3df2	e0 	. 
	inc b			;3df3	04 	. 
	jr nc,7		;3df4	30 05 	0 . 
	add a,b			;3df6	80 	. 
	dec b			;3df7	05 	. 
	ret nc			;3df8	d0 	. 
	dec b			;3df9	05 	. 
	jr nz,l3e02h		;3dfa	20 06 	  . 
	ld (hl),b			;3dfc	70 	p 
	ld b,0c0h		;3dfd	06 c0 	. . 
l3dffh:
	ld b,010h		;3dff	06 10 	. . 
l3e01h:
	rlca			;3e01	07 	. 
l3e02h:
	ld h,b			;3e02	60 	` 
	rlca			;3e03	07 	. 
	or b			;3e04	b0 	. 
	rlca			;3e05	07 	. 
	nop			;3e06	00 	. 
	ex af,af'			;3e07	08 	. 
	ld d,b			;3e08	50 	P 
	ex af,af'			;3e09	08 	. 
	and b			;3e0a	a0 	. 
	ex af,af'			;3e0b	08 	. 
	ret p			;3e0c	f0 	. 
	ex af,af'			;3e0d	08 	. 
	ld b,b			;3e0e	40 	@ 
	add hl,bc			;3e0f	09 	. 
	sub b			;3e10	90 	. 
	add hl,bc			;3e11	09 	. 
	ret po			;3e12	e0 	. 
	add hl,bc			;3e13	09 	. 
	jr nc,l3e20h		;3e14	30 0a 	0 . 
	add a,b			;3e16	80 	. 
	ld a,(bc)			;3e17	0a 	. 
	ret nc			;3e18	d0 	. 
	ld a,(bc)			;3e19	0a 	. 
	jr nz,l3e27h		;3e1a	20 0b 	  . 
	ld (hl),b			;3e1c	70 	p 
	dec bc			;3e1d	0b 	. 
	ret nz			;3e1e	c0 	. 
	dec bc			;3e1f	0b 	. 
l3e20h:
	djnz l3e2eh		;3e20	10 0c 	. . 
	ld h,b			;3e22	60 	` 
	inc c			;3e23	0c 	. 
	or b			;3e24	b0 	. 
	inc c			;3e25	0c 	. 
	nop			;3e26	00 	. 
l3e27h:
	dec c			;3e27	0d 	. 
	ld d,b			;3e28	50 	P 
	dec c			;3e29	0d 	. 
	and b			;3e2a	a0 	. 
	dec c			;3e2b	0d 	. 
	ret p			;3e2c	f0 	. 
	dec c			;3e2d	0d 	. 
l3e2eh:
	ld b,b			;3e2e	40 	@ 
	ld c,090h		;3e2f	0e 90 	. . 
	ld c,0e0h		;3e31	0e e0 	. . 
	ld c,030h		;3e33	0e 30 	. 0 
	rrca			;3e35	0f 	. 
	add a,b			;3e36	80 	. 
	rrca			;3e37	0f 	. 
	ret nc			;3e38	d0 	. 
	rrca			;3e39	0f 	. 
	jr nz,l3e4ch		;3e3a	20 10 	  . 
	ld (hl),b			;3e3c	70 	p 
	djnz l3dffh		;3e3d	10 c0 	. . 
	djnz l3e51h		;3e3f	10 10 	. . 
	ld de,01160h		;3e41	11 60 11 	. ` . 
	or b			;3e44	b0 	. 
	ld de,01200h		;3e45	11 00 12 	. . . 
	ld d,b			;3e48	50 	P 
	ld (de),a			;3e49	12 	. 
	and b			;3e4a	a0 	. 
	ld (de),a			;3e4b	12 	. 
l3e4ch:
	ret p			;3e4c	f0 	. 
	ld (de),a			;3e4d	12 	. 
	ld b,b			;3e4e	40 	@ 
	inc de			;3e4f	13 	. 
	sub b			;3e50	90 	. 
l3e51h:
	inc de			;3e51	13 	. 
	ret po			;3e52	e0 	. 
l3e53h:
	inc de			;3e53	13 	. 
	jr nc,l3e6ah		;3e54	30 14 	0 . 
	add a,b			;3e56	80 	. 
	inc d			;3e57	14 	. 
	ret nc			;3e58	d0 	. 
	inc d			;3e59	14 	. 
	jr nz,l3e71h		;3e5a	20 15 	  . 
	ld (hl),b			;3e5c	70 	p 
	dec d			;3e5d	15 	. 
	ret nz			;3e5e	c0 	. 
	dec d			;3e5f	15 	. 
	djnz l3e78h		;3e60	10 16 	. . 
	ld h,b			;3e62	60 	` 
	ld d,0b0h		;3e63	16 b0 	. . 
	ld d,000h		;3e65	16 00 	. . 
	rla			;3e67	17 	. 
	ld d,b			;3e68	50 	P 
	rla			;3e69	17 	. 
l3e6ah:
	and b			;3e6a	a0 	. 
	rla			;3e6b	17 	. 
	ret p			;3e6c	f0 	. 
	rla			;3e6d	17 	. 
	ld b,b			;3e6e	40 	@ 
	jr l3e01h		;3e6f	18 90 	. . 
l3e71h:
	jr l3e53h		;3e71	18 e0 	. . 
	jr l3ea5h		;3e73	18 30 	. 0 
	add hl,de			;3e75	19 	. 
	add a,b			;3e76	80 	. 
	add hl,de			;3e77	19 	. 
l3e78h:
	ret nc			;3e78	d0 	. 
	add hl,de			;3e79	19 	. 
	jr nz,sub_3e96h		;3e7a	20 1a 	  . 
	ld (hl),b			;3e7c	70 	p 
	ld a,(de)			;3e7d	1a 	. 
	ret nz			;3e7e	c0 	. 
	ld a,(de)			;3e7f	1a 	. 
	djnz l3e9dh		;3e80	10 1b 	. . 
	ld h,b			;3e82	60 	` 
	dec de			;3e83	1b 	. 
	or b			;3e84	b0 	. 
	dec de			;3e85	1b 	. 
	nop			;3e86	00 	. 
	inc e			;3e87	1c 	. 
	ld d,b			;3e88	50 	P 
	inc e			;3e89	1c 	. 
	and b			;3e8a	a0 	. 
	inc e			;3e8b	1c 	. 
	ret p			;3e8c	f0 	. 
	inc e			;3e8d	1c 	. 
	ld b,b			;3e8e	40 	@ 
	dec e			;3e8f	1d 	. 
	sub b			;3e90	90 	. 
	dec e			;3e91	1d 	. 
	ret po			;3e92	e0 	. 
	dec e			;3e93	1d 	. 
	jr nc,32		;3e94	30 1e 	0 . 
sub_3e96h:
	push af			;3e96	f5 	. 
	ld a,030h		;3e97	3e 30 	> 0 
	ld (06001h),a		;3e99	32 01 60 	2 . ` 
	pop af			;3e9c	f1 	. 
l3e9dh:
	ret			;3e9d	c9 	. 
sub_3e9eh:
	ld a,(0ad68h)		;3e9e	3a 68 ad 	: h . 
	and a			;3ea1	a7 	. 
	jp nz,04120h		;3ea2	c2 20 41 	.   A 
l3ea5h:
	call sub_3ceeh		;3ea5	cd ee 3c 	. . < 
	call sub_3f78h		;3ea8	cd 78 3f 	. x ? 
	ld a,(0ac09h)		;3eab	3a 09 ac 	: . . 
	ld hl,0ac0ah		;3eae	21 0a ac 	! . . 
	cp (hl)			;3eb1	be 	. 
	jp c,l3ec2h		;3eb2	da c2 3e 	. . > 
	call sub_3f86h		;3eb5	cd 86 3f 	. . ? 
l3eb8h:
	ld hl,0aa2ah		;3eb8	21 2a aa 	! * . 
	bit 1,(hl)		;3ebb	cb 4e 	. N 
	jp nz,l3d43h		;3ebd	c2 43 3d 	. C = 
	jr l3ee8h		;3ec0	18 26 	. & 
l3ec2h:
	ld a,(0aa2ah)		;3ec2	3a 2a aa 	: * . 
	bit 1,a		;3ec5	cb 4f 	. O 
	jr z,l3ed9h		;3ec7	28 10 	( . 
	ld a,(0ac07h)		;3ec9	3a 07 ac 	: . . 
	ld b,000h		;3ecc	06 00 	. . 
	ld c,a			;3ece	4f 	O 
	ld hl,(0ac05h)		;3ecf	2a 05 ac 	* . . 
	ld d,h			;3ed2	54 	T 
	ld e,l			;3ed3	5d 	] 
	inc de			;3ed4	13 	. 
	ld a,(de)			;3ed5	1a 	. 
	lddr		;3ed6	ed b8 	. . 
	ld (de),a			;3ed8	12 	. 
l3ed9h:
	ld a,018h		;3ed9	3e 18 	> . 
	call 041dfh		;3edb	cd df 41 	. . A 
	ld a,(hl)			;3ede	7e 	~ 
	call sub_3d84h		;3edf	cd 84 3d 	. . = 
	ld hl,0ac09h		;3ee2	21 09 ac 	! . . 
	inc (hl)			;3ee5	34 	4 
	jr l3eb8h		;3ee6	18 d0 	. . 
l3ee8h:
	ld a,(0ac36h)		;3ee8	3a 36 ac 	: 6 . 
	and a			;3eeb	a7 	. 
	jp nz,0404fh		;3eec	c2 4f 40 	. O @ 
	ld a,(0aa2bh)		;3eef	3a 2b aa 	: + . 
	and 0c0h		;3ef2	e6 c0 	. . 
	jr z,l3f03h		;3ef4	28 0d 	( . 
	ld a,(0aab7h)		;3ef6	3a b7 aa 	: . . 
	bit 6,a		;3ef9	cb 77 	. w 
	jr nz,l3f14h		;3efb	20 17 	  . 
	call l3d43h		;3efd	cd 43 3d 	. C = 
	jp sub_394eh		;3f00	c3 4e 39 	. N 9 
l3f03h:
	bit 2,(hl)		;3f03	cb 56 	. V 
	jr z,l3f0ch		;3f05	28 05 	( . 
	res 2,(hl)		;3f07	cb 96 	. . 
	jp l3d43h		;3f09	c3 43 3d 	. C = 
l3f0ch:
	ld a,(0aab7h)		;3f0c	3a b7 aa 	: . . 
	bit 6,a		;3f0f	cb 77 	. w 
	jp z,l3d43h		;3f11	ca 43 3d 	. C = 
l3f14h:
	ld a,(0ab2eh)		;3f14	3a 2e ab 	: . . 
	dec a			;3f17	3d 	= 
	ld (0ac0ch),a		;3f18	32 0c ac 	2 . . 
	ld a,(0aa2ah)		;3f1b	3a 2a aa 	: * . 
	bit 1,a		;3f1e	cb 4f 	. O 
	jr nz,l3f28h		;3f20	20 06 	  . 
	ld a,(0ab27h)		;3f22	3a 27 ab 	: ' . 
	ld (0ab2dh),a		;3f25	32 2d ab 	2 - . 
l3f28h:
	ld a,(0ab2dh)		;3f28	3a 2d ab 	: - . 
	dec a			;3f2b	3d 	= 
	ld (0ac0dh),a		;3f2c	32 0d ac 	2 . . 
	ld a,001h		;3f2f	3e 01 	> . 
	ld (0accah),a		;3f31	32 ca ac 	2 . . 
	call l3d43h		;3f34	cd 43 3d 	. C = 
	call sub_3e96h		;3f37	cd 96 3e 	. . > 
	ld hl,0aa88h		;3f3a	21 88 aa 	! . . 
	ld (hl),001h		;3f3d	36 01 	6 . 
l3f3fh:
	ld a,(hl)			;3f3f	7e 	~ 
	cp 002h		;3f40	fe 02 	. . 
	jr nz,l3f3fh		;3f42	20 fb 	  . 
	ld bc,00030h		;3f44	01 30 00 	. 0 . 
	ld hl,0accbh		;3f47	21 cb ac 	! . . 
	ld de,0a951h		;3f4a	11 51 a9 	. Q . 
	ldir		;3f4d	ed b0 	. . 
	call 00cd8h		;3f4f	cd d8 0c 	. . . 
	ret z			;3f52	c8 	. 
	jp sub_394eh		;3f53	c3 4e 39 	. N 9 
sub_3f56h:
	call sub_3f78h		;3f56	cd 78 3f 	. x ? 
	call sub_3ceeh		;3f59	cd ee 3c 	. . < 
	ld a,(0ac07h)		;3f5c	3a 07 ac 	: . . 
	dec a			;3f5f	3d 	= 
	jr z,l3f7fh		;3f60	28 1d 	( . 
	ld b,000h		;3f62	06 00 	. . 
	ld c,a			;3f64	4f 	O 
	ld hl,(0ac03h)		;3f65	2a 03 ac 	* . . 
	ld a,(hl)			;3f68	7e 	~ 
	ld d,h			;3f69	54 	T 
	ld e,l			;3f6a	5d 	] 
	inc hl			;3f6b	23 	# 
	ldir		;3f6c	ed b0 	. . 
	ld (de),a			;3f6e	12 	. 
	call sub_3d84h		;3f6f	cd 84 3d 	. . = 
	ld hl,0aa2ah		;3f72	21 2a aa 	! * . 
	jp l3ee8h		;3f75	c3 e8 3e 	. . > 
sub_3f78h:
	ld a,(0aa88h)		;3f78	3a 88 aa 	: . . 
	and a			;3f7b	a7 	. 
	jr nz,sub_3f78h		;3f7c	20 fa 	  . 
	ret			;3f7e	c9 	. 
l3f7fh:
	ld hl,(0ac03h)		;3f7f	2a 03 ac 	* . . 
	ld a,(hl)			;3f82	7e 	~ 
	jp sub_3d84h		;3f83	c3 84 3d 	. . = 
sub_3f86h:
	ld a,(0aa2ah)		;3f86	3a 2a aa 	: * . 
	bit 0,a		;3f89	cb 47 	. G 
	jp nz,0401ah		;3f8b	c2 1a 40 	. . @ 
	bit 1,a		;3f8e	cb 4f 	. O 
	jp nz,l3fc3h		;3f90	c2 c3 3f 	. . ? 
l3f93h:
	ld hl,(0ac49h)		;3f93	2a 49 ac 	* I . 
	ld b,(hl)			;3f96	46 	F 
	push bc			;3f97	c5 	. 
	ld hl,(0ac49h)		;3f98	2a 49 ac 	* I . 
	ld d,h			;3f9b	54 	T 
	ld e,l			;3f9c	5d 	] 
	inc hl			;3f9d	23 	# 
	ld a,(0ab27h)		;3f9e	3a 27 ab 	: ' . 
	ld c,a			;3fa1	4f 	O 
	ld b,000h		;3fa2	06 00 	. . 
	ldir		;3fa4	ed b0 	. . 
	ld a,(0aa2ah)		;3fa6	3a 2a aa 	: * . 
	bit 1,a		;3fa9	cb 4f 	. O 
	jp nz,l3fb7h		;3fab	c2 b7 3f 	. . ? 
	pop bc			;3fae	c1 	. 
l3fafh:
	ld hl,(0ac4bh)		;3faf	2a 4b ac 	* K . 
	ld (hl),b			;3fb2	70 	p 
	ld a,b			;3fb3	78 	x 
l3fb4h:
	jp sub_3d84h		;3fb4	c3 84 3d 	. . = 
l3fb7h:
	call 0400ah		;3fb7	cd 0a 40 	. . @ 
	pop bc			;3fba	c1 	. 
	ld hl,(0ac03h)		;3fbb	2a 03 ac 	* . . 
	dec hl			;3fbe	2b 	+ 
	ld (hl),c			;3fbf	71 	q 
	jp l3fafh		;3fc0	c3 af 3f 	. . ? 
l3fc3h:
	ld a,(0ab2eh)		;3fc3	3a 2e ab 	: . . 
	and a			;3fc6	a7 	. 
	jr z,l3fcfh		;3fc7	28 06 	( . 
	call sub_3ff6h		;3fc9	cd f6 3f 	. . ? 
	jp l3f93h		;3fcc	c3 93 3f 	. . ? 
l3fcfh:
	ld a,(0ab27h)		;3fcf	3a 27 ab 	: ' . 
	ld hl,0ac07h		;3fd2	21 07 ac 	! . . 
	sub (hl)			;3fd5	96 	. 
	jr z,l3fe8h		;3fd6	28 10 	( . 
	ld c,a			;3fd8	4f 	O 
	ld b,000h		;3fd9	06 00 	. . 
	ld hl,(0ac05h)		;3fdb	2a 05 ac 	* . . 
	inc hl			;3fde	23 	# 
	ld d,h			;3fdf	54 	T 
	ld e,l			;3fe0	5d 	] 
	ld a,(hl)			;3fe1	7e 	~ 
	inc hl			;3fe2	23 	# 
	ldir		;3fe3	ed b0 	. . 
	ld (de),a			;3fe5	12 	. 
	jr l3fb4h		;3fe6	18 cc 	. . 
l3fe8h:
	ld hl,(0ac05h)		;3fe8	2a 05 ac 	* . . 
	inc hl			;3feb	23 	# 
	ld a,(hl)			;3fec	7e 	~ 
	jr l3fb4h		;3fed	18 c5 	. . 
	ld hl,(0ac03h)		;3fef	2a 03 ac 	* . . 
	dec hl			;3ff2	2b 	+ 
	ld a,(hl)			;3ff3	7e 	~ 
	jr l3fb4h		;3ff4	18 be 	. . 
sub_3ff6h:
	push hl			;3ff6	e5 	. 
	push bc			;3ff7	c5 	. 
	ld hl,(0ac03h)		;3ff8	2a 03 ac 	* . . 
	ld de,0ac4fh		;3ffb	11 4f ac 	. O . 
	defb 03ah,007h		;3ffe	3a 07 	: . 

	end
