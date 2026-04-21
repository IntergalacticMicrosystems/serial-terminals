; z80dasm 1.1.6
; command line: z80dasm -a -l -t -z -g 0x4000 -S U6.sym -o U6.asm ../EPROM_dumps/U6-AM2732-1DC.bin

	org	04000h
video_ram_write:	equ 0x15f7
ram_param_stash:	equ 0xa94c
ram_xlate_table:	equ 0xa983
ram_esc_byte:	equ 0xaa23
ram_esc_state:	equ 0xaa25
ram_esc_arity:	equ 0xaa26
ram_mode_flags:	equ 0xaa29
ram_leadin_byte:	equ 0xaa99
ram_setup_flags_b9:	equ 0xaab9
ram_copy_dst:	equ 0xac03
ram_copy_len:	equ 0xac07

	xor h			;4000	ac 	. 
	ld c,a			;4001	4f 	O 
	ld b,000h		;4002	06 00 	. . 
	ldir		;4004	ed b0 	. . 
	pop bc			;4006	c1 	. 
	ld c,(hl)			;4007	4e 	N 
	pop hl			;4008	e1 	. 
	ret			;4009	c9 	. 
copy_menu_block:
	ld hl,0ac4fh		;400a	21 4f ac 	! O . 
	ld de,(ram_copy_dst)		;400d	ed 5b 03 ac 	. [ . . 
	ld a,(ram_copy_len)		;4011	3a 07 ac 	: . . 
	ld c,a			;4014	4f 	O 
	ld b,000h		;4015	06 00 	. . 
	ldir		;4017	ed b0 	. . 
	ret			;4019	c9 	. 
	ld hl,(0ac1eh)		;401a	2a 1e ac 	* . . 
	ld b,(hl)			;401d	46 	F 
	ld a,(0aa2ah)		;401e	3a 2a aa 	: * . 
	bit 1,a		;4021	cb 4f 	. O 
	call nz,03ff6h		;4023	c4 f6 3f 	. . ? 
	push bc			;4026	c5 	. 
	ld b,000h		;4027	06 00 	. . 
	ld c,02fh		;4029	0e 2f 	. / 
	ld d,h			;402b	54 	T 
	ld e,l			;402c	5d 	] 
	inc hl			;402d	23 	# 
	ldir		;402e	ed b0 	. . 
	push de			;4030	d5 	. 
	ld a,(0aa2ah)		;4031	3a 2a aa 	: * . 
	bit 1,a		;4034	cb 4f 	. O 
	jr nz,l403fh		;4036	20 07 	  . 
	pop hl			;4038	e1 	. 
	pop bc			;4039	c1 	. 
	ld (hl),b			;403a	70 	p 
	ld a,b			;403b	78 	x 
	jp 03d84h		;403c	c3 84 3d 	. . = 
l403fh:
	call copy_menu_block		;403f	cd 0a 40 	. . @ 
	pop hl			;4042	e1 	. 
	pop bc			;4043	c1 	. 
	ld (hl),b			;4044	70 	p 
	ld a,b			;4045	78 	x 
	call 03d84h		;4046	cd 84 3d 	. . = 
	ld hl,(ram_copy_dst)		;4049	2a 03 ac 	* . . 
	dec hl			;404c	2b 	+ 
	ld (hl),c			;404d	71 	q 
	ret			;404e	c9 	. 
	ld a,(0aa2ah)		;404f	3a 2a aa 	: * . 
	bit 1,a		;4052	cb 4f 	. O 
	jp nz,l408bh		;4054	c2 8b 40 	. . @ 
	ld a,(0ac35h)		;4057	3a 35 ac 	: 5 . 
	ld (0ac08h),a		;405a	32 08 ac 	2 . . 
	ld a,(0acfeh)		;405d	3a fe ac 	: . . 
	and a			;4060	a7 	. 
	jr nz,l407bh		;4061	20 18 	  . 
	cpl			;4063	2f 	/ 
	ld (0aab0h),a		;4064	32 b0 aa 	2 . . 
	ld hl,0acfeh		;4067	21 fe ac 	! . . 
l406ah:
	inc hl			;406a	23 	# 
	ld a,0ffh		;406b	3e ff 	> . 
	cp (hl)			;406d	be 	. 
	jr nz,l4074h		;406e	20 04 	  . 
	dec hl			;4070	2b 	+ 
	ld (hl),a			;4071	77 	w 
	jr l40deh		;4072	18 6a 	. j 
l4074h:
	ld a,(hl)			;4074	7e 	~ 
	dec a			;4075	3d 	= 
	dec hl			;4076	2b 	+ 
	ld (hl),a			;4077	77 	w 
	inc hl			;4078	23 	# 
	jr l406ah		;4079	18 ef 	. . 
l407bh:
	xor a			;407b	af 	. 
	ld (0aab0h),a		;407c	32 b0 aa 	2 . . 
	ld hl,0acfeh		;407f	21 fe ac 	! . . 
l4082h:
	ld a,0ffh		;4082	3e ff 	> . 
	cp (hl)			;4084	be 	. 
	jr z,l40deh		;4085	28 57 	( W 
	dec (hl)			;4087	35 	5 
	inc hl			;4088	23 	# 
	jr l4082h		;4089	18 f7 	. . 
l408bh:
	xor a			;408b	af 	. 
	ld (0ac08h),a		;408c	32 08 ac 	2 . . 
	ld a,(0ab2eh)		;408f	3a 2e ab 	: . . 
	and a			;4092	a7 	. 
	jr nz,l40adh		;4093	20 18 	  . 
	ld hl,0ac35h		;4095	21 35 ac 	! 5 . 
	or (hl)			;4098	b6 	. 
	jr z,l409eh		;4099	28 03 	( . 
	ld (0ac08h),a		;409b	32 08 ac 	2 . . 
l409eh:
	xor a			;409e	af 	. 
	ld (0aab0h),a		;409f	32 b0 aa 	2 . . 
	ld a,(0acfeh)		;40a2	3a fe ac 	: . . 
	and a			;40a5	a7 	. 
	jr nz,l40adh		;40a6	20 05 	  . 
	ld a,0ffh		;40a8	3e ff 	> . 
	ld (0aab0h),a		;40aa	32 b0 aa 	2 . . 
l40adh:
	ld b,00ch		;40ad	06 0c 	. . 
	ld hl,0acfeh		;40af	21 fe ac 	! . . 
	ld a,(0ab2eh)		;40b2	3a 2e ab 	: . . 
	dec a			;40b5	3d 	= 
	ld d,a			;40b6	57 	W 
	ld a,(0ab2dh)		;40b7	3a 2d ab 	: - . 
	ld e,a			;40ba	5f 	_ 
l40bbh:
	ld a,(hl)			;40bb	7e 	~ 
	cp 0ffh		;40bc	fe ff 	. . 
	jr z,l40c3h		;40be	28 03 	( . 
	call sub_4110h		;40c0	cd 10 41 	. . A 
l40c3h:
	inc hl			;40c3	23 	# 
	djnz l40bbh		;40c4	10 f5 	. . 
	ld hl,0acfeh		;40c6	21 fe ac 	! . . 
l40c9h:
	ld a,(hl)			;40c9	7e 	~ 
	cp 0ffh		;40ca	fe ff 	. . 
	jr z,l40d1h		;40cc	28 03 	( . 
	inc hl			;40ce	23 	# 
	jr l40c9h		;40cf	18 f8 	. . 
l40d1h:
	inc hl			;40d1	23 	# 
	ld a,(hl)			;40d2	7e 	~ 
	cp 0ffh		;40d3	fe ff 	. . 
	jr z,l40deh		;40d5	28 07 	( . 
	dec hl			;40d7	2b 	+ 
	ld (hl),a			;40d8	77 	w 
	inc hl			;40d9	23 	# 
	ld (hl),0ffh		;40da	36 ff 	6 . 
	jr l40d1h		;40dc	18 f3 	. . 
l40deh:
	ld a,(0ac08h)		;40de	3a 08 ac 	: . . 
	and a			;40e1	a7 	. 
	jr nz,l40eeh		;40e2	20 0a 	  . 
	ld a,(0aab0h)		;40e4	3a b0 aa 	: . . 
	ld (0ac35h),a		;40e7	32 35 ac 	2 5 . 
	ld a,003h		;40ea	3e 03 	> . 
	jr l4105h		;40ec	18 17 	. . 
l40eeh:
	ld hl,0ab27h		;40ee	21 27 ab 	! ' . 
	inc (hl)			;40f1	34 	4 
	ld d,000h		;40f2	16 00 	. . 
	ld e,(hl)			;40f4	5e 	^ 
	ld hl,(0ac1eh)		;40f5	2a 1e ac 	* . . 
	add hl,de			;40f8	19 	. 
	ld a,(hl)			;40f9	7e 	~ 
	call 03d84h		;40fa	cd 84 3d 	. . = 
	ld a,(0aab0h)		;40fd	3a b0 aa 	: . . 
	ld (0ac35h),a		;4100	32 35 ac 	2 5 . 
	ld a,002h		;4103	3e 02 	> . 
l4105h:
	ld hl,0ac39h		;4105	21 39 ac 	! 9 . 
	ld (hl),a			;4108	77 	w 
l4109h:
	ld a,(hl)			;4109	7e 	~ 
	and a			;410a	a7 	. 
	jr nz,l4109h		;410b	20 fc 	  . 
	jp 03d43h		;410d	c3 43 3d 	. C = 
sub_4110h:
	cp d			;4110	ba 	. 
	ret m			;4111	f8 	. 
	jr z,l4119h		;4112	28 05 	( . 
	cp e			;4114	bb 	. 
	ret p			;4115	f0 	. 
	dec a			;4116	3d 	= 
	ld (hl),a			;4117	77 	w 
	ret			;4118	c9 	. 
l4119h:
	ld a,0ffh		;4119	3e ff 	> . 
	ld (hl),a			;411b	77 	w 
	ld (0ac08h),a		;411c	32 08 ac 	2 . . 
	ret			;411f	c9 	. 
	ld a,(0aa2ah)		;4120	3a 2a aa 	: * . 
	bit 0,a		;4123	cb 47 	. G 
	jr nz,l414ch		;4125	20 25 	  % 
	xor a			;4127	af 	. 
	call sub_41dfh		;4128	cd df 41 	. . A 
	call sub_41eeh		;412b	cd ee 41 	. . A 
	ld c,(hl)			;412e	4e 	N 
	call sub_41d6h		;412f	cd d6 41 	. . A 
	dec b			;4132	05 	. 
	jr nz,l413fh		;4133	20 0a 	  . 
l4135h:
	ld a,c			;4135	79 	y 
l4136h:
	call 03d84h		;4136	cd 84 3d 	. . = 
l4139h:
	call 03d43h		;4139	cd 43 3d 	. C = 
	jp l4156h		;413c	c3 56 41 	. V A 
l413fh:
	ld d,h			;413f	54 	T 
	ld e,l			;4140	5d 	] 
	inc hl			;4141	23 	# 
	call sub_41eeh		;4142	cd ee 41 	. . A 
	ld a,(hl)			;4145	7e 	~ 
	ld (de),a			;4146	12 	. 
	djnz l413fh		;4147	10 f6 	. . 
	ld (hl),c			;4149	71 	q 
	jr l4135h		;414a	18 e9 	. . 
l414ch:
	ld a,(0ac09h)		;414c	3a 09 ac 	: . . 
	cp 018h		;414f	fe 18 	. . 
	jr z,l415eh		;4151	28 0b 	( . 
	call sub_417eh		;4153	cd 7e 41 	. ~ A 
l4156h:
	ld a,(0ad68h)		;4156	3a 68 ad 	: h . 
	and a			;4159	a7 	. 
	ret z			;415a	c8 	. 
	jp 0394eh		;415b	c3 4e 39 	. N 9 
l415eh:
	ld hl,(0ac1eh)		;415e	2a 1e ac 	* . . 
	ld a,(hl)			;4161	7e 	~ 
	ld b,000h		;4162	06 00 	. . 
	ld c,017h		;4164	0e 17 	. . 
	ld d,h			;4166	54 	T 
	ld e,l			;4167	5d 	] 
	inc hl			;4168	23 	# 
	ldir		;4169	ed b0 	. . 
	ld c,a			;416b	4f 	O 
	call sub_41d6h		;416c	cd d6 41 	. . A 
l416fh:
	call sub_41eeh		;416f	cd ee 41 	. . A 
	ld a,(hl)			;4172	7e 	~ 
	ld (de),a			;4173	12 	. 
	ld d,h			;4174	54 	T 
	ld e,l			;4175	5d 	] 
	inc hl			;4176	23 	# 
	djnz l416fh		;4177	10 f6 	. . 
	ld a,c			;4179	79 	y 
	ld (de),a			;417a	12 	. 
	jp l4136h		;417b	c3 36 41 	. 6 A 
sub_417eh:
	ld a,018h		;417e	3e 18 	> . 
	call sub_41dfh		;4180	cd df 41 	. . A 
	ld a,(hl)			;4183	7e 	~ 
	ld b,000h		;4184	06 00 	. . 
	ld c,018h		;4186	0e 18 	. . 
	ld d,h			;4188	54 	T 
	ld e,l			;4189	5d 	] 
	dec hl			;418a	2b 	+ 
	lddr		;418b	ed b8 	. . 
	ld c,a			;418d	4f 	O 
	call sub_41d6h		;418e	cd d6 41 	. . A 
	dec b			;4191	05 	. 
	inc hl			;4192	23 	# 
	res 7,(hl)		;4193	cb be 	. . 
l4195h:
	inc hl			;4195	23 	# 
	call sub_41eeh		;4196	cd ee 41 	. . A 
	ld a,(hl)			;4199	7e 	~ 
	ld (de),a			;419a	12 	. 
	ld d,h			;419b	54 	T 
	ld e,l			;419c	5d 	] 
	xor a			;419d	af 	. 
	or b			;419e	b0 	. 
	jr z,l41a4h		;419f	28 03 	( . 
	dec b			;41a1	05 	. 
	jr l4195h		;41a2	18 f1 	. . 
l41a4h:
	ld (hl),c			;41a4	71 	q 
	ld hl,0ac09h		;41a5	21 09 ac 	! . . 
	inc (hl)			;41a8	34 	4 
	call 03d43h		;41a9	cd 43 3d 	. C = 
	jp 0394eh		;41ac	c3 4e 39 	. N 9 
	xor a			;41af	af 	. 
	ld b,a			;41b0	47 	G 
	ld c,018h		;41b1	0e 18 	. . 
	call sub_41dfh		;41b3	cd df 41 	. . A 
	dec hl			;41b6	2b 	+ 
	ld d,h			;41b7	54 	T 
	ld e,l			;41b8	5d 	] 
	ld a,(hl)			;41b9	7e 	~ 
	inc hl			;41ba	23 	# 
	ldir		;41bb	ed b0 	. . 
	ld c,a			;41bd	4f 	O 
	dec hl			;41be	2b 	+ 
	res 7,(hl)		;41bf	cb be 	. . 
	call sub_41d6h		;41c1	cd d6 41 	. . A 
l41c4h:
	dec hl			;41c4	2b 	+ 
	call sub_41f4h		;41c5	cd f4 41 	. . A 
	ld a,(hl)			;41c8	7e 	~ 
	ld (de),a			;41c9	12 	. 
	ld d,h			;41ca	54 	T 
	ld e,l			;41cb	5d 	] 
	djnz l41c4h		;41cc	10 f6 	. . 
	ld (hl),c			;41ce	71 	q 
	ld hl,0ac09h		;41cf	21 09 ac 	! . . 
	dec (hl)			;41d2	35 	5 
	jp l4139h		;41d3	c3 39 41 	. 9 A 
sub_41d6h:
	ld a,(0ad68h)		;41d6	3a 68 ad 	: h . 
	ld b,a			;41d9	47 	G 
	ld a,018h		;41da	3e 18 	> . 
	sub b			;41dc	90 	. 
	ld b,a			;41dd	47 	G 
	ret			;41de	c9 	. 
sub_41dfh:
	push de			;41df	d5 	. 
	ld hl,0ac09h		;41e0	21 09 ac 	! . . 
	ld d,000h		;41e3	16 00 	. . 
	ld e,(hl)			;41e5	5e 	^ 
	ld hl,(0ac1eh)		;41e6	2a 1e ac 	* . . 
	add hl,de			;41e9	19 	. 
	ld e,a			;41ea	5f 	_ 
	add hl,de			;41eb	19 	. 
	pop de			;41ec	d1 	. 
	ret			;41ed	c9 	. 
sub_41eeh:
	bit 7,(hl)		;41ee	cb 7e 	. ~ 
	ret z			;41f0	c8 	. 
	inc hl			;41f1	23 	# 
	jr sub_41eeh		;41f2	18 fa 	. . 
sub_41f4h:
	bit 7,(hl)		;41f4	cb 7e 	. ~ 
	ret z			;41f6	c8 	. 
	dec hl			;41f7	2b 	+ 
	jr sub_41f4h		;41f8	18 fa 	. . 
	ld a,(0ac28h)		;41fa	3a 28 ac 	: ( . 
	and 010h		;41fd	e6 10 	. . 
	or 040h		;41ff	f6 40 	. @ 
	ld d,a			;4201	57 	W 
	call 0177bh		;4202	cd 7b 17 	. { . 
	call 016f7h		;4205	cd f7 16 	. . . 
	call 02e17h		;4208	cd 17 2e 	. . . 
	call 03085h		;420b	cd 85 30 	. . 0 
	jp 0394eh		;420e	c3 4e 39 	. N 9 
sub_4211h:
	ld a,(0abd7h)		;4211	3a d7 ab 	: . . 
	ld b,a			;4214	47 	G 
	ld a,(0ab35h)		;4215	3a 35 ab 	: 5 . 
	ld hl,0abd8h		;4218	21 d8 ab 	! . . 
	cp (hl)			;421b	be 	. 
	ld a,(0ab36h)		;421c	3a 36 ab 	: 6 . 
	jr z,l4223h		;421f	28 02 	( . 
	ld a,050h		;4221	3e 50 	> P 
l4223h:
	sub b			;4223	90 	. 
	ld b,a			;4224	47 	G 
	call 00cd8h		;4225	cd d8 0c 	. . . 
	call nz,sub_479ch		;4228	c4 9c 47 	. . G 
	rst 30h			;422b	f7 	. 
	call 03e96h		;422c	cd 96 3e 	. . > 
	ld a,(0aa2bh)		;422f	3a 2b aa 	: + . 
	and 008h		;4232	e6 08 	. . 
	jr nz,l426fh		;4234	20 39 	  9 
	ld a,(0ab34h)		;4236	3a 34 ab 	: 4 . 
	and a			;4239	a7 	. 
	jr z,l425fh		;423a	28 23 	( # 
	ld a,(ram_mode_flags)		;423c	3a 29 aa 	: ) . 
	and 010h		;423f	e6 10 	. . 
	jr nz,l425fh		;4241	20 1c 	  . 
	ld a,e			;4243	7b 	{ 
	and 090h		;4244	e6 90 	. . 
	ld e,a			;4246	5f 	_ 
l4247h:
	ld hl,06001h		;4247	21 01 60 	! . ` 
	ld c,0abh		;424a	0e ab 	. . 
	ld d,0ach		;424c	16 ac 	. . 
l424eh:
	rst 30h			;424e	f7 	. 
	ld (hl),d			;424f	72 	r 
	rst 10h			;4250	d7 	. 
	call sub_42f5h		;4251	cd f5 42 	. . B 
	rst 30h			;4254	f7 	. 
	ld (hl),c			;4255	71 	q 
	djnz l424eh		;4256	10 f6 	. . 
	rst 10h			;4258	d7 	. 
	call sub_42c9h		;4259	cd c9 42 	. . B 
	ret z			;425c	c8 	. 
	jr l4247h		;425d	18 e8 	. . 
l425fh:
	ld hl,06001h		;425f	21 01 60 	! . ` 
	ld c,0abh		;4262	0e ab 	. . 
l4264h:
	rst 30h			;4264	f7 	. 
	ld (hl),c			;4265	71 	q 
	djnz l4264h		;4266	10 fc 	. . 
	rst 10h			;4268	d7 	. 
	call sub_42c9h		;4269	cd c9 42 	. . B 
	ret z			;426c	c8 	. 
	jr l425fh		;426d	18 f0 	. . 
l426fh:
	call sub_428ah		;426f	cd 8a 42 	. . B 
l4272h:
	ld a,e			;4272	7b 	{ 
	ld (0d000h),a		;4273	32 00 d0 	2 . . 
	ld hl,06001h		;4276	21 01 60 	! . ` 
	ld c,0abh		;4279	0e ab 	. . 
l427bh:
	rst 30h			;427b	f7 	. 
	ld (hl),c			;427c	71 	q 
	djnz l427bh		;427d	10 fc 	. . 
	rst 10h			;427f	d7 	. 
	ld a,e			;4280	7b 	{ 
	and 080h		;4281	e6 80 	. . 
	ld e,a			;4283	5f 	_ 
	call sub_42c9h		;4284	cd c9 42 	. . B 
	ret z			;4287	c8 	. 
	jr l4272h		;4288	18 e8 	. . 
sub_428ah:
	ld a,e			;428a	7b 	{ 
	and 080h		;428b	e6 80 	. . 
	ld e,a			;428d	5f 	_ 
	ld a,(0abd7h)		;428e	3a d7 ab 	: . . 
	and a			;4291	a7 	. 
	ret z			;4292	c8 	. 
	call 0179ch		;4293	cd 9c 17 	. . . 
	ld a,(0d000h)		;4296	3a 00 d0 	: . . 
	and 01fh		;4299	e6 1f 	. . 
	or e			;429b	b3 	. 
	ld d,e			;429c	53 	S 
	ld e,a			;429d	5f 	_ 
	and 001h		;429e	e6 01 	. . 
	ret z			;42a0	c8 	. 
	rst 30h			;42a1	f7 	. 
	ld hl,(06004h)		;42a2	2a 04 60 	* . ` 
	dec hl			;42a5	2b 	+ 
	ld (06004h),hl		;42a6	22 04 60 	" . ` 
	ld a,0adh		;42a9	3e ad 	> . 
	ld (06001h),a		;42ab	32 01 60 	2 . ` 
	rst 10h			;42ae	d7 	. 
	ld a,(0d000h)		;42af	3a 00 d0 	: . . 
	and 01fh		;42b2	e6 1f 	. . 
	or d			;42b4	b2 	. 
	ld e,a			;42b5	5f 	_ 
	and 001h		;42b6	e6 01 	. . 
	ret z			;42b8	c8 	. 
	ld a,(0c000h)		;42b9	3a 00 c0 	: . . 
	cp 010h		;42bc	fe 10 	. . 
	ld a,010h		;42be	3e 10 	> . 
	jr nz,l42c5h		;42c0	20 03 	  . 
	ld a,008h		;42c2	3e 08 	> . 
	xor e			;42c4	ab 	. 
l42c5h:
	or d			;42c5	b2 	. 
	ld e,a			;42c6	5f 	_ 
	ret			;42c7	c9 	. 
l42c8h:
	pop af			;42c8	f1 	. 
sub_42c9h:
	ld a,(0ab35h)		;42c9	3a 35 ab 	: 5 . 
	ld hl,0abd8h		;42cc	21 d8 ab 	! . . 
	sub (hl)			;42cf	96 	. 
	ret z			;42d0	c8 	. 
	push af			;42d1	f5 	. 
	push bc			;42d2	c5 	. 
	inc (hl)			;42d3	34 	4 
	ld c,(hl)			;42d4	4e 	N 
	call sub_47aeh		;42d5	cd ae 47 	. . G 
	pop bc			;42d8	c1 	. 
	jr nz,l42c8h		;42d9	20 ed 	  . 
	pop af			;42db	f1 	. 
	cp 001h		;42dc	fe 01 	. . 
	ld b,050h		;42de	06 50 	. P 
	jr nz,l42e6h		;42e0	20 04 	  . 
	ld a,(0ab36h)		;42e2	3a 36 ab 	: 6 . 
	ld b,a			;42e5	47 	G 
l42e6h:
	ld a,(hl)			;42e6	7e 	~ 
	push de			;42e7	d5 	. 
	call 03d20h		;42e8	cd 20 3d 	.   = 
	rst 30h			;42eb	f7 	. 
	ld (06004h),de		;42ec	ed 53 04 60 	. S . ` 
	pop de			;42f0	d1 	. 
	ld a,0ffh		;42f1	3e ff 	> . 
	and a			;42f3	a7 	. 
	ret			;42f4	c9 	. 
sub_42f5h:
	ld a,(0aa2bh)		;42f5	3a 2b aa 	: + . 
	and 0c0h		;42f8	e6 c0 	. . 
	jr nz,l4306h		;42fa	20 0a 	  . 
l42fch:
	ld a,(0d000h)		;42fc	3a 00 d0 	: . . 
	and 00fh		;42ff	e6 0f 	. . 
l4301h:
	or e			;4301	b3 	. 
l4302h:
	ld (0d000h),a		;4302	32 00 d0 	2 . . 
	ret			;4305	c9 	. 
l4306h:
	ld a,(ram_mode_flags)		;4306	3a 29 aa 	: ) . 
	and 080h		;4309	e6 80 	. . 
	ret z			;430b	c8 	. 
	ld a,(0aa2bh)		;430c	3a 2b aa 	: + . 
	and 040h		;430f	e6 40 	. @ 
	jr z,l42fch		;4311	28 e9 	( . 
	ld a,(0d000h)		;4313	3a 00 d0 	: . . 
	and 030h		;4316	e6 30 	. 0 
	cp 030h		;4318	fe 30 	. 0 
	jr nz,l432ah		;431a	20 0e 	  . 
	ld a,(0c000h)		;431c	3a 00 c0 	: . . 
	ld (0ac19h),a		;431f	32 19 ac 	2 . . 
	ld (0c000h),a		;4322	32 00 c0 	2 . . 
	ld a,(0d000h)		;4325	3a 00 d0 	: . . 
	jr l4302h		;4328	18 d8 	. . 
l432ah:
	and 010h		;432a	e6 10 	. . 
	ld e,a			;432c	5f 	_ 
	ld a,(0ac17h)		;432d	3a 17 ac 	: . . 
	jr z,l4335h		;4330	28 03 	( . 
	ld a,(0c000h)		;4332	3a 00 c0 	: . . 
l4335h:
	ld (0c000h),a		;4335	32 00 c0 	2 . . 
	and a			;4338	a7 	. 
	ld a,(0ac19h)		;4339	3a 19 ac 	: . . 
	jr nz,l4301h		;433c	20 c3 	  . 
	or 080h		;433e	f6 80 	. . 
	jr l4301h		;4340	18 bf 	. . 
sub_4342h:
	ld a,(0ab34h)		;4342	3a 34 ab 	: 4 . 
	and a			;4345	a7 	. 
	call nz,sub_43b5h		;4346	c4 b5 43 	. . C 
	ld a,(0ab38h)		;4349	3a 38 ab 	: 8 . 
	and a			;434c	a7 	. 
	jr z,l4397h		;434d	28 48 	( H 
	ld a,(0abd8h)		;434f	3a d8 ab 	: . . 
	ld d,a			;4352	57 	W 
	ld a,(0ab39h)		;4353	3a 39 ab 	: 9 . 
	cp d			;4356	ba 	. 
	jr z,l4397h		;4357	28 3e 	( > 
	ld a,(0aa2ah)		;4359	3a 2a aa 	: * . 
	bit 1,a		;435c	cb 4f 	. O 
	jr z,l4397h		;435e	28 37 	( 7 
	ld a,(0ab2eh)		;4360	3a 2e ab 	: . . 
	cp d			;4363	ba 	. 
	jr z,l4368h		;4364	28 02 	( . 
	jr nc,l4370h		;4366	30 08 	0 . 
l4368h:
	ld a,(0ab2dh)		;4368	3a 2d ab 	: - . 
	cp d			;436b	ba 	. 
	jr c,l4397h		;436c	38 29 	8 ) 
	jr l4378h		;436e	18 08 	. . 
l4370h:
	xor a			;4370	af 	. 
	ld (0ab37h),a		;4371	32 37 ab 	2 7 . 
	ld a,(0ab2eh)		;4374	3a 2e ab 	: . . 
	dec a			;4377	3d 	= 
l4378h:
	ld (0ab35h),a		;4378	32 35 ab 	2 5 . 
	call sub_4211h		;437b	cd 11 42 	. . B 
	ld a,(0ab37h)		;437e	3a 37 ab 	: 7 . 
	and a			;4381	a7 	. 
	jr nz,l43a1h		;4382	20 1d 	  . 
	ld (0abd7h),a		;4384	32 d7 ab 	2 . . 
	ld a,(0ab27h)		;4387	3a 27 ab 	: ' . 
	ld b,a			;438a	47 	G 
	ld a,(0ab2dh)		;438b	3a 2d ab 	: - . 
	cp b			;438e	b8 	. 
	jr nc,l43a1h		;438f	30 10 	0 . 
	inc a			;4391	3c 	< 
	push de			;4392	d5 	. 
	call sub_4507h		;4393	cd 07 45 	. . E 
	pop de			;4396	d1 	. 
l4397h:
	ld a,0ffh		;4397	3e ff 	> . 
	ld (0ab37h),a		;4399	32 37 ab 	2 7 . 
	ld a,(0ab39h)		;439c	3a 39 ab 	: 9 . 
	jr l4378h		;439f	18 d7 	. . 
l43a1h:
	xor a			;43a1	af 	. 
	ld (0ac20h),a		;43a2	32 20 ac 	2   . 
	call 02ea8h		;43a5	cd a8 2e 	. . . 
	call 00a27h		;43a8	cd 27 0a 	. ' . 
sub_43abh:
	ld a,080h		;43ab	3e 80 	> . 
	jp 015d3h		;43ad	c3 d3 15 	. . . 
l43b0h:
	ld a,080h		;43b0	3e 80 	> . 
	jp 015ddh		;43b2	c3 dd 15 	. . . 
sub_43b5h:
	ld a,(0aa2bh)		;43b5	3a 2b aa 	: + . 
	and 040h		;43b8	e6 40 	. @ 
	ret nz			;43ba	c0 	. 
	ld a,(ram_mode_flags)		;43bb	3a 29 aa 	: ) . 
	and 080h		;43be	e6 80 	. . 
	jp nz,l43b0h		;43c0	c2 b0 43 	. . C 
	ret			;43c3	c9 	. 
sub_43c4h:
	xor a			;43c4	af 	. 
	ld (0abd7h),a		;43c5	32 d7 ab 	2 . . 
	jp sub_4507h		;43c8	c3 07 45 	. . E 
h_erase_to_eol:
	ld d,000h		;43cb	16 00 	. . 
	ld a,(0ac28h)		;43cd	3a 28 ac 	: ( . 
	or 080h		;43d0	f6 80 	. . 
	ld e,a			;43d2	5f 	_ 
	jr erase_body_common		;43d3	18 03 	. . 
h_erase_eol_unprot:
	call 00a32h		;43d5	cd 32 0a 	. 2 . 
erase_body_common:
	ld a,e			;43d8	7b 	{ 
	and 0efh		;43d9	e6 ef 	. . 
	ld e,a			;43db	5f 	_ 
	call sub_43b5h		;43dc	cd b5 43 	. . C 
	ld a,(0abd7h)		;43df	3a d7 ab 	: . . 
	ld b,a			;43e2	47 	G 
	ld a,050h		;43e3	3e 50 	> P 
	sub b			;43e5	90 	. 
	ld b,a			;43e6	47 	G 
	ld hl,06001h		;43e7	21 01 60 	! . ` 
	rst 30h			;43ea	f7 	. 
	ld (hl),030h		;43eb	36 30 	6 0 
	ld a,d			;43ed	7a 	z 
	ld (0c000h),a		;43ee	32 00 c0 	2 . . 
	ld (0ac17h),a		;43f1	32 17 ac 	2 . . 
	ld c,0abh		;43f4	0e ab 	. . 
	ld a,(0aa2bh)		;43f6	3a 2b aa 	: + . 
	bit 3,a		;43f9	cb 5f 	. _ 
	jr nz,l442fh		;43fb	20 32 	  2 
	and 014h		;43fd	e6 14 	. . 
	jr nz,l4442h		;43ff	20 41 	  A 
	ld a,(0aa2bh)		;4401	3a 2b aa 	: + . 
	and 0c3h		;4404	e6 c3 	. . 
	jp nz,l4729h		;4406	c2 29 47 	. ) G 
	ld a,(ram_mode_flags)		;4409	3a 29 aa 	: ) . 
	and 010h		;440c	e6 10 	. . 
	jr nz,l4432h		;440e	20 22 	  " 
	ld d,0ach		;4410	16 ac 	. . 
	ld a,e			;4412	7b 	{ 
	and 090h		;4413	e6 90 	. . 
	ld e,a			;4415	5f 	_ 
l4416h:
	rst 30h			;4416	f7 	. 
	ld (hl),d			;4417	72 	r 
	rst 10h			;4418	d7 	. 
	ld a,(0d000h)		;4419	3a 00 d0 	: . . 
	and 00fh		;441c	e6 0f 	. . 
	or e			;441e	b3 	. 
	ld (0d000h),a		;441f	32 00 d0 	2 . . 
	ld (hl),c			;4422	71 	q 
	djnz l4416h		;4423	10 f1 	. . 
l4425h:
	rst 30h			;4425	f7 	. 
	call 02ea8h		;4426	cd a8 2e 	. . . 
	call sub_43abh		;4429	cd ab 43 	. . C 
	jp 03538h		;442c	c3 38 35 	. 8 5 
l442fh:
	call sub_428ah		;442f	cd 8a 42 	. . B 
l4432h:
	ld a,e			;4432	7b 	{ 
	and 09fh		;4433	e6 9f 	. . 
l4435h:
	ld (0d000h),a		;4435	32 00 d0 	2 . . 
	ld hl,06001h		;4438	21 01 60 	! . ` 
l443bh:
	rst 30h			;443b	f7 	. 
	ld (hl),c			;443c	71 	q 
	djnz l443bh		;443d	10 fc 	. . 
	rst 10h			;443f	d7 	. 
	jr l4425h		;4440	18 e3 	. . 
l4442h:
	xor a			;4442	af 	. 
	jr l4435h		;4443	18 f0 	. . 
h_erase_to_end_screen:
	call 00a32h		;4445	cd 32 0a 	. 2 . 
l4448h:
	ld a,(0aa2bh)		;4448	3a 2b aa 	: + . 
	and 014h		;444b	e6 14 	. . 
	ld a,e			;444d	7b 	{ 
	jr nz,l445dh		;444e	20 0d 	  . 
	and 0efh		;4450	e6 ef 	. . 
	ld e,a			;4452	5f 	_ 
l4453h:
	ld hl,0ffffh		;4453	21 ff ff 	! . . 
l4456h:
	ld a,(0ab27h)		;4456	3a 27 ab 	: ' . 
	ld c,a			;4459	4f 	O 
	jp l454ah		;445a	c3 4a 45 	. J E 
l445dh:
	and 080h		;445d	e6 80 	. . 
	ld e,a			;445f	5f 	_ 
	ld hl,0ff00h		;4460	21 00 ff 	! . . 
	jr l4456h		;4463	18 f1 	. . 
h_erase_82:
h_erase_full_page:
	ld d,000h		;4465	16 00 	. . 
	ld a,(0ac28h)		;4467	3a 28 ac 	: ( . 
	or 080h		;446a	f6 80 	. . 
	ld e,a			;446c	5f 	_ 
	jr l4448h		;446d	18 d9 	. . 
h_erase_var_1:
	call 023cah		;446f	cd ca 23 	. . # 
	call sub_43c4h		;4472	cd c4 43 	. . C 
	ld e,000h		;4475	1e 00 	. . 
	ld a,(0ab2fh)		;4477	3a 2f ab 	: / . 
	ld d,a			;447a	57 	W 
l447bh:
	push de			;447b	d5 	. 
	call sub_471dh		;447c	cd 1d 47 	. . G 
	pop de			;447f	d1 	. 
	ld hl,00000h		;4480	21 00 00 	! . . 
	ld c,017h		;4483	0e 17 	. . 
	call l454ah		;4485	cd 4a 45 	. J E 
	call sub_44a4h		;4488	cd a4 44 	. . D 
	jp 00f83h		;448b	c3 83 0f 	. . . 
h_mode_48e_star:
	call 023cah		;448e	cd ca 23 	. . # 
	call 00cd8h		;4491	cd d8 0c 	. . . 
	jr z,l449bh		;4494	28 05 	( . 
	call sub_44f2h		;4496	cd f2 44 	. . D 
	jr l449eh		;4499	18 03 	. . 
l449bh:
	call sub_43c4h		;449b	cd c4 43 	. . C 
l449eh:
	ld d,000h		;449e	16 00 	. . 
	ld e,080h		;44a0	1e 80 	. . 
	jr l447bh		;44a2	18 d7 	. . 
sub_44a4h:
	call 00562h		;44a4	cd 62 05 	. b . 
	ld a,(0aa2ah)		;44a7	3a 2a aa 	: * . 
	and 040h		;44aa	e6 40 	. @ 
	call nz,01b72h		;44ac	c4 72 1b 	. r . 
	ret			;44af	c9 	. 
h_erase_83:
	ld a,(0ac28h)		;44b0	3a 28 ac 	: ( . 
	ld e,a			;44b3	5f 	_ 
	ld a,(0ab2fh)		;44b4	3a 2f ab 	: / . 
	ld d,a			;44b7	57 	W 
l44b8h:
	push de			;44b8	d5 	. 
	ld a,(0ab2eh)		;44b9	3a 2e ab 	: . . 
	and a			;44bc	a7 	. 
	jr nz,l44dbh		;44bd	20 1c 	  . 
	ld a,(0ab2dh)		;44bf	3a 2d ab 	: - . 
	cp 017h		;44c2	fe 17 	. . 
	jr nc,l44dbh		;44c4	30 15 	0 . 
	inc a			;44c6	3c 	< 
	ld c,a			;44c7	4f 	O 
	ld a,(0abd8h)		;44c8	3a d8 ab 	: . . 
	cp c			;44cb	b9 	. 
	jr c,l44dbh		;44cc	38 0d 	8 . 
	ld a,c			;44ce	79 	y 
	ld (0abd8h),a		;44cf	32 d8 ab 	2 . . 
	xor a			;44d2	af 	. 
	ld (0abd7h),a		;44d3	32 d7 ab 	2 . . 
	call sub_450ah		;44d6	cd 0a 45 	. . E 
	jr l44deh		;44d9	18 03 	. . 
l44dbh:
	call sub_44f2h		;44db	cd f2 44 	. . D 
l44deh:
	pop de			;44de	d1 	. 
	call l4448h		;44df	cd 48 44 	. H D 
	call sub_44f2h		;44e2	cd f2 44 	. . D 
	jp 03538h		;44e5	c3 38 35 	. 8 5 
h_attr_bit7_set:
	ld d,000h		;44e8	16 00 	. . 
	ld a,(0ac28h)		;44ea	3a 28 ac 	: ( . 
	or 080h		;44ed	f6 80 	. . 
	ld e,a			;44ef	5f 	_ 
	jr l44b8h		;44f0	18 c6 	. . 
sub_44f2h:
	call sub_4511h		;44f2	cd 11 45 	. . E 
	jr z,l44fch		;44f5	28 05 	( . 
	call sub_451bh		;44f7	cd 1b 45 	. . E 
	jr nc,sub_4507h		;44fa	30 0b 	0 . 
l44fch:
	ld a,(0ad68h)		;44fc	3a 68 ad 	: h . 
	and a			;44ff	a7 	. 
	ld a,000h		;4500	3e 00 	> . 
	jr z,sub_4507h		;4502	28 03 	( . 
	jp 031b8h		;4504	c3 b8 31 	. . 1 
sub_4507h:
	ld (0abd8h),a		;4507	32 d8 ab 	2 . . 
sub_450ah:
	call 02f46h		;450a	cd 46 2f 	. F / 
	ld (06004h),hl		;450d	22 04 60 	" . ` 
	ret			;4510	c9 	. 
sub_4511h:
	xor a			;4511	af 	. 
	ld (0abd7h),a		;4512	32 d7 ab 	2 . . 
	ld a,(0aa2ah)		;4515	3a 2a aa 	: * . 
	and 002h		;4518	e6 02 	. . 
	ret			;451a	c9 	. 
sub_451bh:
	ld a,(0ab2eh)		;451b	3a 2e ab 	: . . 
	ld c,a			;451e	4f 	O 
	ld a,(0abd8h)		;451f	3a d8 ab 	: . . 
	cp c			;4522	b9 	. 
	ret c			;4523	d8 	. 
	ld c,a			;4524	4f 	O 
	ld a,(0ab2dh)		;4525	3a 2d ab 	: - . 
	cp c			;4528	b9 	. 
	ret c			;4529	d8 	. 
	ld a,(0ab2eh)		;452a	3a 2e ab 	: . . 
	ret			;452d	c9 	. 
h_ampex_esc_C:
	call l43b0h		;452e	cd b0 43 	. . C 
	ld a,(ram_mode_flags)		;4531	3a 29 aa 	: ) . 
	push af			;4534	f5 	. 
	or 080h		;4535	f6 80 	. . 
	ld (ram_mode_flags),a		;4537	32 29 aa 	2 ) . 
	call sub_44f2h		;453a	cd f2 44 	. . D 
	ld de,02000h		;453d	11 00 20 	. .   
	call l44b8h		;4540	cd b8 44 	. . D 
	pop af			;4543	f1 	. 
	ld (ram_mode_flags),a		;4544	32 29 aa 	2 ) . 
	jp sub_43abh		;4547	c3 ab 43 	. . C 
l454ah:
	call 03f78h		;454a	cd 78 3f 	. x ? 
	ld iy,(0abd7h)		;454d	fd 2a d7 ab 	. * . . 
	ld a,d			;4551	7a 	z 
	ld (0c000h),a		;4552	32 00 c0 	2 . . 
	ld (0ac17h),a		;4555	32 17 ac 	2 . . 
	ld a,050h		;4558	3e 50 	> P 
	ld (0ab36h),a		;455a	32 36 ab 	2 6 . 
	ld a,c			;455d	79 	y 
	ld (0ab39h),a		;455e	32 39 ab 	2 9 . 
	ld a,e			;4561	7b 	{ 
	ld (0d000h),a		;4562	32 00 d0 	2 . . 
	ld a,h			;4565	7c 	| 
	ld (0ab38h),a		;4566	32 38 ab 	2 8 . 
	ld a,l			;4569	7d 	} 
	ld (0ab34h),a		;456a	32 34 ab 	2 4 . 
	call sub_4342h		;456d	cd 42 43 	. B C 
	ld (0abd7h),iy		;4570	fd 22 d7 ab 	. " . . 
	ld a,(0aa2bh)		;4574	3a 2b aa 	: + . 
	and 080h		;4577	e6 80 	. . 
	call nz,0394eh		;4579	c4 4e 39 	. N 9 
	jp 03538h		;457c	c3 38 35 	. 8 5 
	ld de,00020h		;457f	11 20 00 	.   . 
	call 00d51h		;4582	cd 51 0d 	. Q . 
	jp h_erase_var_1		;4585	c3 6f 44 	. o D 
h_erase_fill_var:
h_setup_erase_cond:
	call 00a59h		;4588	cd 59 0a 	. Y . 
l458bh:
	ld a,(0ab3ah)		;458b	3a 3a ab 	: : . 
	and a			;458e	a7 	. 
	jp z,0b00ch		;458f	ca 0c b0 	. . . 
	ld a,(0abd7h)		;4592	3a d7 ab 	: . . 
	inc a			;4595	3c 	< 
	cp 050h		;4596	fe 50 	. P 
	jr z,l45c8h		;4598	28 2e 	( . 
l459ah:
	call sub_4618h		;459a	cd 18 46 	. . F 
l459dh:
	jr z,l45a4h		;459d	28 05 	( . 
	srl b		;459f	cb 38 	. 8 
	dec a			;45a1	3d 	= 
	jr l459dh		;45a2	18 f9 	. . 
l45a4h:
	ld a,b			;45a4	78 	x 
	and a			;45a5	a7 	. 
	jr z,l45bch		;45a6	28 14 	( . 
l45a8h:
	bit 0,b		;45a8	cb 40 	. @ 
	jr z,l45b7h		;45aa	28 0b 	( . 
	ld a,e			;45ac	7b 	{ 
	rlca			;45ad	07 	. 
	rlca			;45ae	07 	. 
	rlca			;45af	07 	. 
	add a,d			;45b0	82 	. 
	ld (0abd7h),a		;45b1	32 d7 ab 	2 . . 
	jp sub_450ah		;45b4	c3 0a 45 	. . E 
l45b7h:
	srl b		;45b7	cb 38 	. 8 
	inc d			;45b9	14 	. 
	jr l45a8h		;45ba	18 ec 	. . 
l45bch:
	inc e			;45bc	1c 	. 
	ld a,009h		;45bd	3e 09 	> . 
	cp e			;45bf	bb 	. 
	jr c,l45c8h		;45c0	38 06 	8 . 
	ld d,000h		;45c2	16 00 	. . 
	inc hl			;45c4	23 	# 
	ld b,(hl)			;45c5	46 	F 
	jr l45a4h		;45c6	18 dc 	. . 
l45c8h:
	ld hl,0abd8h		;45c8	21 d8 ab 	! . . 
	ld a,(0aa2ah)		;45cb	3a 2a aa 	: * . 
	and 002h		;45ce	e6 02 	. . 
	jr z,l45dbh		;45d0	28 09 	( . 
	ld a,(0ab2dh)		;45d2	3a 2d ab 	: - . 
	cp (hl)			;45d5	be 	. 
	ld a,(0ab2eh)		;45d6	3a 2e ab 	: . . 
	jr z,l4611h		;45d9	28 36 	( 6 
l45dbh:
	ld a,(0ab27h)		;45db	3a 27 ab 	: ' . 
	inc (hl)			;45de	34 	4 
	cp (hl)			;45df	be 	. 
	jr nc,l4614h		;45e0	30 32 	0 2 
	ld a,(0aa2ah)		;45e2	3a 2a aa 	: * . 
	bit 0,a		;45e5	cb 47 	. G 
	jr z,l45fah		;45e7	28 11 	( . 
	ld a,(0ac09h)		;45e9	3a 09 ac 	: . . 
	cp 018h		;45ec	fe 18 	. . 
	jr nz,l45f5h		;45ee	20 05 	  . 
	call 02f61h		;45f0	cd 61 2f 	. a / 
	jr l4604h		;45f3	18 0f 	. . 
l45f5h:
	call 03c21h		;45f5	cd 21 3c 	. ! < 
	jr l460eh		;45f8	18 14 	. . 
l45fah:
	bit 3,a		;45fa	cb 5f 	. _ 
	jr z,l4604h		;45fc	28 06 	( . 
	call 0388dh		;45fe	cd 8d 38 	. . 8 
l4601h:
	xor a			;4601	af 	. 
	jr l4611h		;4602	18 0d 	. . 
l4604h:
	ld a,(ram_mode_flags)		;4604	3a 29 aa 	: ) . 
	and 088h		;4607	e6 88 	. . 
	jr nz,l4601h		;4609	20 f6 	  . 
	call 03e9eh		;460b	cd 9e 3e 	. . > 
l460eh:
	ld a,(0ab27h)		;460e	3a 27 ab 	: ' . 
l4611h:
	ld (0abd8h),a		;4611	32 d8 ab 	2 . . 
l4614h:
	xor a			;4614	af 	. 
	jp l459ah		;4615	c3 9a 45 	. . E 
sub_4618h:
	ld e,a			;4618	5f 	_ 
	ld d,000h		;4619	16 00 	. . 
	ld hl,0ab3bh		;461b	21 3b ab 	! ; . 
	srl e		;461e	cb 3b 	. ; 
	srl e		;4620	cb 3b 	. ; 
	srl e		;4622	cb 3b 	. ; 
	add hl,de			;4624	19 	. 
	ld b,(hl)			;4625	46 	F 
	and 007h		;4626	e6 07 	. . 
	ld d,a			;4628	57 	W 
	ret			;4629	c9 	. 
h_ampex_esc_i:
	ld hl,00018h		;462a	21 18 00 	! . . 
	rst 20h			;462d	e7 	. 
	ret nz			;462e	c0 	. 
	ld a,(ram_mode_flags)		;462f	3a 29 aa 	: ) . 
	and 080h		;4632	e6 80 	. . 
	jr nz,l4642h		;4634	20 0c 	  . 
	ld hl,00700h		;4636	21 00 07 	! . . 
	rst 20h			;4639	e7 	. 
	jp z,l458bh		;463a	ca 8b 45 	. . E 
	ld a,0ffh		;463d	3e ff 	> . 
	ld (0acc7h),a		;463f	32 c7 ac 	2 . . 
l4642h:
	jp 033f8h		;4642	c3 f8 33 	. . 3 
h_save_cursor:
	ld a,(ram_mode_flags)		;4645	3a 29 aa 	: ) . 
	and 080h		;4648	e6 80 	. . 
	jr z,l4657h		;464a	28 0b 	( . 
	ld hl,0abd7h		;464c	21 d7 ab 	! . . 
	ld b,(hl)			;464f	46 	F 
	inc hl			;4650	23 	# 
	ld c,(hl)			;4651	4e 	N 
	ld a,(0aa2bh)		;4652	3a 2b aa 	: + . 
	and 0c1h		;4655	e6 c1 	. . 
l4657h:
	jp z,00aa7h		;4657	ca a7 0a 	. . . 
	and 001h		;465a	e6 01 	. . 
	jr nz,l4693h		;465c	20 35 	  5 
	ld a,c			;465e	79 	y 
	ld c,b			;465f	48 	H 
	ld hl,0ac09h		;4660	21 09 ac 	! . . 
	add a,(hl)			;4663	86 	. 
	ld b,a			;4664	47 	G 
l4665h:
	ld hl,(0ac1eh)		;4665	2a 1e ac 	* . . 
	ld a,c			;4668	79 	y 
	call 00fb7h		;4669	cd b7 0f 	. . . 
	call 017a0h		;466c	cd a0 17 	. . . 
	ld a,(0d000h)		;466f	3a 00 d0 	: . . 
	bit 4,a		;4672	cb 67 	. g 
	jr nz,l468ah		;4674	20 14 	  . 
	ld e,020h		;4676	1e 20 	.   
	or 010h		;4678	f6 10 	. . 
	and 07fh		;467a	e6 7f 	.  
	ld d,a			;467c	57 	W 
	call 01777h		;467d	cd 77 17 	. w . 
l4680h:
	inc b			;4680	04 	. 
	ld a,(0ac1dh)		;4681	3a 1d ac 	: . . 
	cp b			;4684	b8 	. 
	jr nc,l4665h		;4685	30 de 	0 . 
l4687h:
	jp 033f1h		;4687	c3 f1 33 	. . 3 
l468ah:
	ld a,(0aa2bh)		;468a	3a 2b aa 	: + . 
	and 040h		;468d	e6 40 	. @ 
	jr nz,l4680h		;468f	20 ef 	  . 
	jr l4687h		;4691	18 f4 	. . 
l4693h:
	ld a,c			;4693	79 	y 
	or b			;4694	b0 	. 
	jr z,l46bah		;4695	28 23 	( # 
	ld a,b			;4697	78 	x 
	and a			;4698	a7 	. 
	jr nz,l469eh		;4699	20 03 	  . 
	dec c			;469b	0d 	. 
	ld b,050h		;469c	06 50 	. P 
l469eh:
	dec b			;469e	05 	. 
l469fh:
	call sub_46c2h		;469f	cd c2 46 	. . F 
	call 017a0h		;46a2	cd a0 17 	. . . 
	ld a,(0d000h)		;46a5	3a 00 d0 	: . . 
	or 010h		;46a8	f6 10 	. . 
	ld d,a			;46aa	57 	W 
	ld a,(0c000h)		;46ab	3a 00 c0 	: . . 
	ld e,a			;46ae	5f 	_ 
	call 01777h		;46af	cd 77 17 	. w . 
	inc c			;46b2	0c 	. 
	ld a,(0ab27h)		;46b3	3a 27 ab 	: ' . 
	cp c			;46b6	b9 	. 
	jr nc,l469fh		;46b7	30 e6 	0 . 
	ret			;46b9	c9 	. 
l46bah:
	ld a,(0ab27h)		;46ba	3a 27 ab 	: ' . 
	ld c,a			;46bd	4f 	O 
	ld b,04fh		;46be	06 4f 	. O 
	jr l469fh		;46c0	18 dd 	. . 
sub_46c2h:
	ld a,c			;46c2	79 	y 
	call 03d20h		;46c3	cd 20 3d 	.   = 
	ld l,b			;46c6	68 	h 
	ld h,000h		;46c7	26 00 	& . 
	add hl,de			;46c9	19 	. 
	ld (06006h),hl		;46ca	22 06 60 	" . ` 
	ret			;46cd	c9 	. 
h_ampex_esc_0:
	ld e,010h		;46ce	1e 10 	. . 
	ld d,020h		;46d0	16 20 	.   
	jp l4453h		;46d2	c3 53 44 	. S D 
h_ampex_esc_X:
	call 03f78h		;46d5	cd 78 3f 	. x ? 
	ld a,(0abd0h)		;46d8	3a d0 ab 	: . . 
	and 010h		;46db	e6 10 	. . 
	ld (0abd0h),a		;46dd	32 d0 ab 	2 . . 
	ld (0ac28h),a		;46e0	32 28 ac 	2 ( . 
	call 00f83h		;46e3	cd 83 0f 	. . . 
	call 023cah		;46e6	cd ca 23 	. . # 
	call sub_471dh		;46e9	cd 1d 47 	. . G 
	xor a			;46ec	af 	. 
	ld e,a			;46ed	5f 	_ 
	ld d,080h		;46ee	16 80 	. . 
	ld hl,(0ac4dh)		;46f0	2a 4d ac 	* M . 
	dec hl			;46f3	2b 	+ 
	ld (06006h),hl		;46f4	22 06 60 	" . ` 
	ld hl,00080h		;46f7	21 80 00 	! . . 
	ld (06004h),hl		;46fa	22 04 60 	" . ` 
	call 01770h		;46fd	cd 70 17 	. p . 
	xor a			;4700	af 	. 
	ld (0ac09h),a		;4701	32 09 ac 	2 . . 
	jr l4711h		;4704	18 0b 	. . 
	ld a,(0aa2ah)		;4706	3a 2a aa 	: * . 
	and 001h		;4709	e6 01 	. . 
	call nz,03c67h		;470b	c4 67 3c 	. g < 
	call h_ampex_esc_F		;470e	cd 14 47 	. . G 
l4711h:
	jp 033afh		;4711	c3 af 33 	. . 3 
h_ampex_esc_F:
h_swap_f8_f9:
	ld a,(0abf9h)		;4714	3a f9 ab 	: . . 
	ld (0abf8h),a		;4717	32 f8 ab 	2 . . 
	jp 02924h		;471a	c3 24 29 	. $ ) 
sub_471dh:
	ld a,(0aa2bh)		;471d	3a 2b aa 	: + . 
	and 0c3h		;4720	e6 c3 	. . 
	ret z			;4722	c8 	. 
	call 01b97h		;4723	cd 97 1b 	. . . 
	jp 009e0h		;4726	c3 e0 09 	. . . 
l4729h:
	call sub_479ch		;4729	cd 9c 47 	. . G 
	ld a,(ram_mode_flags)		;472c	3a 29 aa 	: ) . 
	and 080h		;472f	e6 80 	. . 
	jr nz,l4753h		;4731	20 20 	    
l4733h:
	rst 30h			;4733	f7 	. 
	ld (hl),c			;4734	71 	q 
	djnz l4733h		;4735	10 fc 	. . 
	ld hl,(0abd7h)		;4737	2a d7 ab 	* . . 
	ld a,(0ab27h)		;473a	3a 27 ab 	: ' . 
	cp h			;473d	bc 	. 
	jr z,l4762h		;473e	28 22 	( " 
	push hl			;4740	e5 	. 
	inc h			;4741	24 	$ 
	ld l,000h		;4742	2e 00 	. . 
	ld (0abd7h),hl		;4744	22 d7 ab 	" . . 
	call 016f7h		;4747	cd f7 16 	. . . 
	call 02e17h		;474a	cd 17 2e 	. . . 
	pop hl			;474d	e1 	. 
	ld (0abd7h),hl		;474e	22 d7 ab 	" . . 
	jr l4762h		;4751	18 0f 	. . 
l4753h:
	ld d,0ach		;4753	16 ac 	. . 
l4755h:
	rst 30h			;4755	f7 	. 
	ld (hl),d			;4756	72 	r 
	rst 10h			;4757	d7 	. 
	ld a,(0d000h)		;4758	3a 00 d0 	: . . 
	and 010h		;475b	e6 10 	. . 
	jr nz,l4768h		;475d	20 09 	  . 
	ld (hl),c			;475f	71 	q 
	djnz l4755h		;4760	10 f3 	. . 
l4762h:
	call 0394eh		;4762	cd 4e 39 	. N 9 
	jp l4425h		;4765	c3 25 44 	. % D 
l4768h:
	ld a,(0aa2bh)		;4768	3a 2b aa 	: + . 
	and 040h		;476b	e6 40 	. @ 
	jr z,l4762h		;476d	28 f3 	( . 
l476fh:
	ld a,(0d000h)		;476f	3a 00 d0 	: . . 
	bit 5,a		;4772	cb 6f 	. o 
	jr nz,l4791h		;4774	20 1b 	  . 
	and 090h		;4776	e6 90 	. . 
	ld d,a			;4778	57 	W 
	ld a,(0ac19h)		;4779	3a 19 ac 	: . . 
	or d			;477c	b2 	. 
	ld (0d000h),a		;477d	32 00 d0 	2 . . 
	ld a,(0c000h)		;4780	3a 00 c0 	: . . 
	ld (0c000h),a		;4783	32 00 c0 	2 . . 
	rst 10h			;4786	d7 	. 
	ld (hl),c			;4787	71 	q 
l4788h:
	djnz l478ch		;4788	10 02 	. . 
	jr l4762h		;478a	18 d6 	. . 
l478ch:
	call 0179ch		;478c	cd 9c 17 	. . . 
	jr l476fh		;478f	18 de 	. . 
l4791h:
	ld a,(0c000h)		;4791	3a 00 c0 	: . . 
	ld (0ac19h),a		;4794	32 19 ac 	2 . . 
	ld a,0a9h		;4797	3e a9 	> . 
	ld (hl),a			;4799	77 	w 
	jr l4788h		;479a	18 ec 	. . 
sub_479ch:
	call 016f7h		;479c	cd f7 16 	. . . 
	ld a,(0ac17h)		;479f	3a 17 ac 	: . . 
	and a			;47a2	a7 	. 
	ld a,(0ac19h)		;47a3	3a 19 ac 	: . . 
	jr nz,l47aah		;47a6	20 02 	  . 
	or 080h		;47a8	f6 80 	. . 
l47aah:
	ld (0d000h),a		;47aa	32 00 d0 	2 . . 
	ret			;47ad	c9 	. 
sub_47aeh:
	push hl			;47ae	e5 	. 
	ld a,c			;47af	79 	y 
	call sub_41dfh		;47b0	cd df 41 	. . A 
	bit 7,(hl)		;47b3	cb 7e 	. ~ 
	pop hl			;47b5	e1 	. 
	ret			;47b6	c9 	. 
	exx			;47b7	d9 	. 
	ex af,af'			;47b8	08 	. 
	ld hl,06001h		;47b9	21 01 60 	! . ` 
	ld a,(hl)			;47bc	7e 	~ 
	jp m,l47d0h		;47bd	fa d0 47 	. . G 
	jr nz,l47d6h		;47c0	20 14 	  . 
	ld (hl),010h		;47c2	36 10 	6 . 
	dec l			;47c4	2d 	- 
	ld (hl),e			;47c5	73 	s 
	dec l			;47c6	2d 	- 
	ld hl,(0ac01h)		;47c7	2a 01 ac 	* . . 
	ld (06002h),hl		;47ca	22 02 60 	" . ` 
	scf			;47cd	37 	7 
	jr l47f1h		;47ce	18 21 	. ! 
l47d0h:
	ld (hl),010h		;47d0	36 10 	6 . 
	dec l			;47d2	2d 	- 
	ld (hl),058h		;47d3	36 58 	6 X 
	scf			;47d5	37 	7 
l47d6h:
	bit 3,a		;47d6	cb 5f 	. _ 
	jr z,l4826h		;47d8	28 4c 	( L 
	jp c,l48fbh		;47da	da fb 48 	. . H 
	ld a,(0ac36h)		;47dd	3a 36 ac 	: 6 . 
	and a			;47e0	a7 	. 
	call nz,sub_47fah		;47e1	c4 fa 47 	. . G 
	ld a,(bc)			;47e4	0a 	. 
	ld l,a			;47e5	6f 	o 
	inc c			;47e6	0c 	. 
	ld a,(bc)			;47e7	0a 	. 
	ld h,a			;47e8	67 	g 
	inc c			;47e9	0c 	. 
	ld (06002h),hl		;47ea	22 02 60 	" . ` 
	inc d			;47ed	14 	. 
	ld a,001h		;47ee	3e 01 	> . 
	and a			;47f0	a7 	. 
l47f1h:
	ld a,05fh		;47f1	3e 5f 	> _ 
	ld (06001h),a		;47f3	32 01 60 	2 . ` 
	exx			;47f6	d9 	. 
	ex af,af'			;47f7	08 	. 
	retn		;47f8	ed 45 	. E 
sub_47fah:
	ld a,(0ac38h)		;47fa	3a 38 ac 	: 8 . 
	cp d			;47fd	ba 	. 
	ld hl,06001h		;47fe	21 01 60 	! . ` 
	ld (hl),017h		;4801	36 17 	6 . 
	jr nz,l481eh		;4803	20 19 	  . 
	ld a,(0aa95h)		;4805	3a 95 aa 	: . . 
	or 010h		;4808	f6 10 	. . 
	dec l			;480a	2d 	- 
	ld (hl),a			;480b	77 	w 
	ld hl,0ac37h		;480c	21 37 ac 	! 7 . 
	push bc			;480f	c5 	. 
	ld b,000h		;4810	06 00 	. . 
	ld c,(hl)			;4812	4e 	N 
	inc (hl)			;4813	34 	4 
	ld hl,0ac29h		;4814	21 29 ac 	! ) . 
	add hl,bc			;4817	09 	. 
	ld a,(hl)			;4818	7e 	~ 
	ld (0ac38h),a		;4819	32 38 ac 	2 8 . 
	pop bc			;481c	c1 	. 
	ret			;481d	c9 	. 
l481eh:
	ld a,(0aa95h)		;481e	3a 95 aa 	: . . 
	and 0efh		;4821	e6 ef 	. . 
	dec l			;4823	2d 	- 
	ld (hl),a			;4824	77 	w 
	ret			;4825	c9 	. 
l4826h:
	call 00098h		;4826	cd 98 00 	. . . 
	call 000ebh		;4829	cd eb 00 	. . . 
	xor a			;482c	af 	. 
	ld (0acfdh),a		;482d	32 fd ac 	2 . . 
	call 0b018h		;4830	cd 18 b0 	. . . 
	ld hl,0ac10h		;4833	21 10 ac 	! . . 
	xor a			;4836	af 	. 
	or (hl)			;4837	b6 	. 
	jr z,l4846h		;4838	28 0c 	( . 
	dec (hl)			;483a	35 	5 
	jr nz,l4846h		;483b	20 09 	  . 
	ld hl,0ac3bh		;483d	21 3b ac 	! ; . 
	res 3,(hl)		;4840	cb 9e 	. . 
	ld a,(hl)			;4842	7e 	~ 
	ld (08001h),a		;4843	32 01 80 	2 . . 
l4846h:
	ld a,(0ad5ch)		;4846	3a 5c ad 	: \ . 
	and a			;4849	a7 	. 
	call z,sub_4947h		;484a	cc 47 49 	. G I 
	ld a,(0ac39h)		;484d	3a 39 ac 	: 9 . 
	ld hl,0ac36h		;4850	21 36 ac 	! 6 . 
	or (hl)			;4853	b6 	. 
	jr z,l489ch		;4854	28 46 	( F 
	ld a,(0ac39h)		;4856	3a 39 ac 	: 9 . 
	cp 001h		;4859	fe 01 	. . 
	jr c,l4880h		;485b	38 23 	8 # 
	jr z,l4895h		;485d	28 36 	( 6 
	cp 003h		;485f	fe 03 	. . 
	jr z,l4871h		;4861	28 0e 	( . 
	dec (hl)			;4863	35 	5 
	ld hl,0aa92h		;4864	21 92 aa 	! . . 
	inc (hl)			;4867	34 	4 
l4868h:
	ld a,014h		;4868	3e 14 	> . 
	ld (06001h),a		;486a	32 01 60 	2 . ` 
	ld a,(hl)			;486d	7e 	~ 
	ld (06000h),a		;486e	32 00 60 	2 . ` 
l4871h:
	xor a			;4871	af 	. 
	ld (0ac39h),a		;4872	32 39 ac 	2 9 . 
	ld hl,0acfeh		;4875	21 fe ac 	! . . 
	ld de,0ac29h		;4878	11 29 ac 	. ) . 
	ld bc,0000ch		;487b	01 0c 00 	. . . 
	ldir		;487e	ed b0 	. . 
l4880h:
	ld a,(0ac35h)		;4880	3a 35 ac 	: 5 . 
	ld d,000h		;4883	16 00 	. . 
	and a			;4885	a7 	. 
	jr nz,l488ch		;4886	20 04 	  . 
	ld a,(0ac29h)		;4888	3a 29 ac 	: ) . 
	inc d			;488b	14 	. 
l488ch:
	ld (0ac38h),a		;488c	32 38 ac 	2 8 . 
	ld a,d			;488f	7a 	z 
	ld (0ac37h),a		;4890	32 37 ac 	2 7 . 
	jr l48a2h		;4893	18 0d 	. . 
l4895h:
	inc (hl)			;4895	34 	4 
	ld hl,0aa92h		;4896	21 92 aa 	! . . 
	dec (hl)			;4899	35 	5 
	jr l4868h		;489a	18 cc 	. . 
l489ch:
	ld a,(0aa88h)		;489c	3a 88 aa 	: . . 
	and a			;489f	a7 	. 
	jr nz,l48b2h		;48a0	20 10 	  . 
l48a2h:
	ld hl,00000h		;48a2	21 00 00 	! . . 
	ld (06002h),hl		;48a5	22 02 60 	" . ` 
	ld bc,0a951h		;48a8	01 51 a9 	. Q . 
	ld d,0ffh		;48ab	16 ff 	. . 
	inc a			;48ad	3c 	< 
	and a			;48ae	a7 	. 
	jp l47f1h		;48af	c3 f1 47 	. . G 
l48b2h:
	cp 001h		;48b2	fe 01 	. . 
	jr nz,l48dah		;48b4	20 24 	  $ 
	inc a			;48b6	3c 	< 
	ld (0aa88h),a		;48b7	32 88 aa 	2 . . 
	ld hl,06001h		;48ba	21 01 60 	! . ` 
	ld (hl),014h		;48bd	36 14 	6 . 
	dec l			;48bf	2d 	- 
	ld (hl),099h		;48c0	36 99 	6 . 
	ld hl,0abffh		;48c2	21 ff ab 	! . . 
	ld (hl),048h		;48c5	36 48 	6 H 
	inc hl			;48c7	23 	# 
	ld (hl),008h		;48c8	36 08 	6 . 
l48cah:
	ld bc,0a951h		;48ca	01 51 a9 	. Q . 
	ld d,0ffh		;48cd	16 ff 	. . 
	ld hl,00000h		;48cf	21 00 00 	! . . 
	ld (06002h),hl		;48d2	22 02 60 	" . ` 
	and a			;48d5	a7 	. 
	scf			;48d6	37 	7 
	jp l47f1h		;48d7	c3 f1 47 	. . G 
l48dah:
	ld hl,0abffh		;48da	21 ff ab 	! . . 
	xor a			;48dd	af 	. 
	cp (hl)			;48de	be 	. 
	jr z,l48ech		;48df	28 0b 	( . 
	ld a,(hl)			;48e1	7e 	~ 
	sub 008h		;48e2	d6 08 	. . 
	ld (hl),a			;48e4	77 	w 
	inc l			;48e5	2c 	, 
	ld a,(hl)			;48e6	7e 	~ 
	add a,008h		;48e7	c6 08 	. . 
	ld (hl),a			;48e9	77 	w 
	jr l48cah		;48ea	18 de 	. . 
l48ech:
	ld (0aa88h),a		;48ec	32 88 aa 	2 . . 
	ld hl,06001h		;48ef	21 01 60 	! . ` 
	ld (hl),031h		;48f2	36 31 	6 1 
	ld (hl),014h		;48f4	36 14 	6 . 
	dec l			;48f6	2d 	- 
	ld (hl),098h		;48f7	36 98 	6 . 
	jr l48a2h		;48f9	18 a7 	. . 
l48fbh:
	rst 10h			;48fb	d7 	. 
	ld a,(bc)			;48fc	0a 	. 
	ld l,a			;48fd	6f 	o 
	inc c			;48fe	0c 	. 
	ld a,(bc)			;48ff	0a 	. 
	ld h,a			;4900	67 	g 
	inc c			;4901	0c 	. 
	ld a,001h		;4902	3e 01 	> . 
	ld (0acfdh),a		;4904	32 fd ac 	2 . . 
	ld a,(0ac0ch)		;4907	3a 0c ac 	: . . 
	cp d			;490a	ba 	. 
	jr nz,l491fh		;490b	20 12 	  . 
	inc d			;490d	14 	. 
	ld (0ac01h),hl		;490e	22 01 ac 	" . . 
	ld hl,(0ac4dh)		;4911	2a 4d ac 	* M . 
	ld (06002h),hl		;4914	22 02 60 	" . ` 
	ld a,(0abffh)		;4917	3a ff ab 	: . . 
	ld e,a			;491a	5f 	_ 
	xor a			;491b	af 	. 
	jp l47f1h		;491c	c3 f1 47 	. . G 
l491fh:
	ld a,(0ac0dh)		;491f	3a 0d ac 	: . . 
	cp d			;4922	ba 	. 
	jr nz,l493ah		;4923	20 15 	  . 
	inc d			;4925	14 	. 
	ld (06002h),hl		;4926	22 02 60 	" . ` 
	ld a,(bc)			;4929	0a 	. 
	inc c			;492a	0c 	. 
	ld l,a			;492b	6f 	o 
	ld a,(bc)			;492c	0a 	. 
	ld h,a			;492d	67 	g 
	inc c			;492e	0c 	. 
	ld (0ac01h),hl		;492f	22 01 ac 	" . . 
	ld a,(0ac00h)		;4932	3a 00 ac 	: . . 
	ld e,a			;4935	5f 	_ 
	xor a			;4936	af 	. 
	jp l47f1h		;4937	c3 f1 47 	. . G 
l493ah:
	ld (06002h),hl		;493a	22 02 60 	" . ` 
	xor a			;493d	af 	. 
	ld (0acfdh),a		;493e	32 fd ac 	2 . . 
	inc d			;4941	14 	. 
	inc a			;4942	3c 	< 
	scf			;4943	37 	7 
	jp l47f1h		;4944	c3 f1 47 	. . G 
sub_4947h:
	ld a,(0aa88h)		;4947	3a 88 aa 	: . . 
	and a			;494a	a7 	. 
	ret nz			;494b	c0 	. 
	ld hl,(0a951h)		;494c	2a 51 a9 	* Q . 
	ld (06002h),hl		;494f	22 02 60 	" . ` 
	call sub_4ec1h		;4952	cd c1 4e 	. . N 
	ld a,098h		;4955	3e 98 	> . 
	ld (0aa92h),a		;4957	32 92 aa 	2 . . 
	ld (0ad5ch),a		;495a	32 5c ad 	2 \ . 
	jp 0022bh		;495d	c3 2b 02 	. + . 
display_main_loop:
	ld hl,0ad5dh		;4960	21 5d ad 	! ] . 
	dec (hl)			;4963	35 	5 
	ret z			;4964	c8 	. 
	ld a,(0a944h)		;4965	3a 44 a9 	: D . 
	ld hl,0a945h		;4968	21 45 a9 	! E . 
	cp (hl)			;496b	be 	. 
	jr z,l497bh		;496c	28 0d 	( . 
	call 015b9h		;496e	cd b9 15 	. . . 
	call display_dispatcher		;4971	cd 81 49 	. . I 
	ld a,(0abf7h)		;4974	3a f7 ab 	: . . 
	and a			;4977	a7 	. 
	jr z,display_main_loop		;4978	28 e6 	( . 
	ret			;497a	c9 	. 
l497bh:
	call 01403h		;497b	cd 03 14 	. . . 
	jp 00084h		;497e	c3 84 00 	. . . 
display_dispatcher:
	ld c,a			;4981	4f 	O 
	ld a,(0ad61h)		;4982	3a 61 ad 	: a . 
	and a			;4985	a7 	. 
	jp nz,0b009h		;4986	c2 09 b0 	. . . 
	ld a,(0aa89h)		;4989	3a 89 aa 	: . . 
	and 080h		;498c	e6 80 	. . 
	jr z,l49b5h		;498e	28 25 	( % 
	ld a,c			;4990	79 	y 
	cp 020h		;4991	fe 20 	.   
	jr c,l49b5h		;4993	38 20 	8   
	cp 080h		;4995	fe 80 	. . 
	jr nc,l49b5h		;4997	30 1c 	0 . 
	ld a,(0aa2bh)		;4999	3a 2b aa 	: + . 
	and 080h		;499c	e6 80 	. . 
	ld a,c			;499e	79 	y 
	jr nz,l49a9h		;499f	20 08 	  . 
	cp 06fh		;49a1	fe 6f 	. o 
	ret nc			;49a3	d0 	. 
	add a,060h		;49a4	c6 60 	. ` 
l49a6h:
	jp video_ram_write		;49a6	c3 f7 15 	. . . 
l49a9h:
	and 00fh		;49a9	e6 0f 	. . 
	ld c,a			;49ab	4f 	O 
	ld b,000h		;49ac	06 00 	. . 
	ld hl,l4a00h		;49ae	21 00 4a 	! . J 
	add hl,bc			;49b1	09 	. 
	ld a,(hl)			;49b2	7e 	~ 
	jr l49a6h		;49b3	18 f1 	. . 
l49b5h:
	ld a,(ram_mode_flags)		;49b5	3a 29 aa 	: ) . 
	and 020h		;49b8	e6 20 	.   
	jr nz,l49e0h		;49ba	20 24 	  $ 
	ld a,(0aaa1h)		;49bc	3a a1 aa 	: . . 
	and a			;49bf	a7 	. 
	jr nz,l49e0h		;49c0	20 1e 	  . 
	ld a,c			;49c2	79 	y 
	cp 020h		;49c3	fe 20 	.   
	jp c,00ac7h		;49c5	da c7 0a 	. . . 
	cp 07fh		;49c8	fe 7f 	.  
	ret z			;49ca	c8 	. 
	jp c,video_ram_write		;49cb	da f7 15 	. . . 
	cp 0a0h		;49ce	fe a0 	. . 
	jr nc,l49ddh		;49d0	30 0b 	0 . 
	ld hl,00700h		;49d2	21 00 07 	! . . 
	rst 20h			;49d5	e7 	. 
	jr nz,l49ddh		;49d6	20 05 	  . 
	ld a,c			;49d8	79 	y 
	and 07fh		;49d9	e6 7f 	.  
	jr l49fdh		;49db	18 20 	.   
l49ddh:
	jp 00aafh		;49dd	c3 af 0a 	. . . 
l49e0h:
	ld a,c			;49e0	79 	y 
	cp 080h		;49e1	fe 80 	. . 
	jp c,video_ram_write		;49e3	da f7 15 	. . . 
	and 07fh		;49e6	e6 7f 	.  
	ld e,a			;49e8	5f 	_ 
	ld d,000h		;49e9	16 00 	. . 
	ld hl,ram_xlate_table		;49eb	21 83 a9 	! . . 
	add hl,de			;49ee	19 	. 
	ld a,(hl)			;49ef	7e 	~ 
	cp 039h		;49f0	fe 39 	. 9 
	jr z,l49ddh		;49f2	28 e9 	( . 
	ld a,e			;49f4	7b 	{ 
	push af			;49f5	f5 	. 
	ld a,(ram_leadin_byte)		;49f6	3a 99 aa 	: . . 
	call video_ram_write		;49f9	cd f7 15 	. . . 
	pop af			;49fc	f1 	. 
l49fdh:
	jp video_ram_write		;49fd	c3 f7 15 	. . . 
l4a00h:
	jr nz,-51		;4a00	20 cb 	  . 
	call z,0cecdh		;4a02	cc cd ce 	. . . 
	jp nz,0c1c0h		;4a05	c2 c0 c1 	. . . 
	jp 0c9cah		;4a08	c3 ca c9 	. . . 
	ret z			;4a0b	c8 	. 
	push bc			;4a0c	c5 	. 
	add a,0c4h		;4a0d	c6 c4 	. . 
	rst 0			;4a0f	c7 	. 
esc_state_machine:
	ld a,(ram_esc_state)		;4a10	3a 25 aa 	: % . 
	and a			;4a13	a7 	. 
	jp z,l4a8ah		;4a14	ca 8a 4a 	. . J 
	cp 0ffh		;4a17	fe ff 	. . 
	jr nz,l4a62h		;4a19	20 47 	  G 
	ld a,(ram_esc_byte)		;4a1b	3a 23 aa 	: # . 
	ld c,a			;4a1e	4f 	O 
	ld hl,ram_esc_state		;4a1f	21 25 aa 	! % . 
	ld a,(0ad61h)		;4a22	3a 61 ad 	: a . 
	and a			;4a25	a7 	. 
	jr nz,l4a57h		;4a26	20 2f 	  / 
	ld a,(0aaa1h)		;4a28	3a a1 aa 	: . . 
	and a			;4a2b	a7 	. 
	jr nz,l4a57h		;4a2c	20 29 	  ) 
	ld a,(ram_mode_flags)		;4a2e	3a 29 aa 	: ) . 
	and 020h		;4a31	e6 20 	.   
	jr nz,l4a57h		;4a33	20 22 	  " 
	ld b,000h		;4a35	06 00 	. . 
xlate_table_lookup:
	ld hl,ram_xlate_table		;4a37	21 83 a9 	! . . 
	add hl,bc			;4a3a	09 	. 
	ld a,(hl)			;4a3b	7e 	~ 
	ld hl,ram_esc_state		;4a3c	21 25 aa 	! % . 
	and a			;4a3f	a7 	. 
	jr z,l4a57h		;4a40	28 15 	( . 
arity_classifier:
	ld (hl),005h		;4a42	36 05 	6 . 
	cp 006h		;4a44	fe 06 	. . 
	jr c,l4a59h		;4a46	38 11 	8 . 
	dec (hl)			;4a48	35 	5 
	cp 00bh		;4a49	fe 0b 	. . 
	jr c,l4a59h		;4a4b	38 0c 	8 . 
	dec (hl)			;4a4d	35 	5 
	cp 015h		;4a4e	fe 15 	. . 
	jr c,l4a59h		;4a50	38 07 	8 . 
	dec (hl)			;4a52	35 	5 
	cp 029h		;4a53	fe 29 	. ) 
	jr c,l4a59h		;4a55	38 02 	8 . 
l4a57h:
	ld (hl),001h		;4a57	36 01 	6 . 
l4a59h:
	ld a,(hl)			;4a59	7e 	~ 
	ld (ram_esc_arity),a		;4a5a	32 26 aa 	2 & . 
	ld hl,ram_esc_byte		;4a5d	21 23 aa 	! # . 
	set 7,(hl)		;4a60	cb fe 	. . 
l4a62h:
	ld hl,ram_esc_state		;4a62	21 25 aa 	! % . 
	dec (hl)			;4a65	35 	5 
	push af			;4a66	f5 	. 
	ld a,(hl)			;4a67	7e 	~ 
	ld hl,ram_param_stash		;4a68	21 4c a9 	! L . 
	add a,l			;4a6b	85 	. 
	ld l,a			;4a6c	6f 	o 
	ld a,(ram_esc_byte)		;4a6d	3a 23 aa 	: # . 
	ld (hl),a			;4a70	77 	w 
	pop af			;4a71	f1 	. 
	ret nz			;4a72	c0 	. 
	ld a,(ram_esc_arity)		;4a73	3a 26 aa 	: & . 
	ld b,a			;4a76	47 	G 
l4a77h:
	ld a,b			;4a77	78 	x 
	ld hl,ram_param_stash		;4a78	21 4c a9 	! L . 
	dec a			;4a7b	3d 	= 
	add a,l			;4a7c	85 	. 
	ld l,a			;4a7d	6f 	o 
	ld a,(hl)			;4a7e	7e 	~ 
	ld (ram_esc_byte),a		;4a7f	32 23 aa 	2 # . 
	push bc			;4a82	c5 	. 
	call 013afh		;4a83	cd af 13 	. . . 
	pop bc			;4a86	c1 	. 
	djnz l4a77h		;4a87	10 ee 	. . 
	ret			;4a89	c9 	. 
l4a8ah:
	ld a,(0aa2bh)		;4a8a	3a 2b aa 	: + . 
	and 080h		;4a8d	e6 80 	. . 
	jr nz,l4a99h		;4a8f	20 08 	  . 
	ld a,(ram_mode_flags)		;4a91	3a 29 aa 	: ) . 
	and 020h		;4a94	e6 20 	.   
	jp nz,013afh		;4a96	c2 af 13 	. . . 
l4a99h:
	ld a,0ffh		;4a99	3e ff 	> . 
	ld (ram_esc_state),a		;4a9b	32 25 aa 	2 % . 
	ret			;4a9e	c9 	. 
setup_menu_text:
	ld b,c			;4a9f	41 	A 
	jr nz,l4ae5h		;4aa0	20 43 	  C 
	ld d,l			;4aa2	55 	U 
	ld d,d			;4aa3	52 	R 
	ld d,e			;4aa4	53 	S 
	ld c,a			;4aa5	4f 	O 
	ld d,d			;4aa6	52 	R 
	jr nz,l4ae3h		;4aa7	20 3a 	  : 
	ld l,046h		;4aa9	2e 46 	. F 
	ld c,h			;4aab	4c 	L 
	ld b,c			;4aac	41 	A 
	ld d,e			;4aad	53 	S 
	ld c,b			;4aae	48 	H 
	dec l			;4aaf	2d 	- 
	ld b,d			;4ab0	42 	B 
	ld c,h			;4ab1	4c 	L 
	ld c,e			;4ab2	4b 	K 
	ld l,042h		;4ab3	2e 42 	. B 
	ld c,h			;4ab5	4c 	L 
	ld c,e			;4ab6	4b 	K 
	ld l,046h		;4ab7	2e 46 	. F 
	ld c,h			;4ab9	4c 	L 
	ld b,c			;4aba	41 	A 
	ld d,e			;4abb	53 	S 
	ld c,b			;4abc	48 	H 
	dec l			;4abd	2d 	- 
	ld d,l			;4abe	55 	U 
	ld c,h			;4abf	4c 	L 
	ld l,055h		;4ac0	2e 55 	. U 
	ld c,h			;4ac2	4c 	L 
	ld l,04fh		;4ac3	2e 4f 	. O 
	ld b,(hl)			;4ac5	46 	F 
	ld b,(hl)			;4ac6	46 	F 
	ld hl,(02042h)		;4ac7	2a 42 20 	* B   
	ld d,e			;4aca	53 	S 
	ld d,h			;4acb	54 	T 
	ld b,c			;4acc	41 	A 
	ld d,h			;4acd	54 	T 
	ld d,l			;4ace	55 	U 
	ld d,e			;4acf	53 	S 
	jr nz,60		;4ad0	20 3a 	  : 
	ld l,04fh		;4ad2	2e 4f 	. O 
	ld c,(hl)			;4ad4	4e 	N 
	ld l,044h		;4ad5	2e 44 	. D 
	ld c,c			;4ad7	49 	I 
	ld d,e			;4ad8	53 	S 
	ld d,b			;4ad9	50 	P 
	dec l			;4ada	2d 	- 
	ld c,a			;4adb	4f 	O 
	ld c,(hl)			;4adc	4e 	N 
	dec l			;4add	2d 	- 
	ld b,l			;4ade	45 	E 
	ld d,d			;4adf	52 	R 
	ld d,d			;4ae0	52 	R 
	ld l,04fh		;4ae1	2e 4f 	. O 
l4ae3h:
	ld b,(hl)			;4ae3	46 	F 
	ld b,(hl)			;4ae4	46 	F 
l4ae5h:
	ld hl,(02043h)		;4ae5	2a 43 20 	* C   
	ld b,c			;4ae8	41 	A 
	ld d,l			;4ae9	55 	U 
	ld d,h			;4aea	54 	T 
	ld c,a			;4aeb	4f 	O 
	jr nz,l4b3ch		;4aec	20 4e 	  N 
	ld b,l			;4aee	45 	E 
	ld d,a			;4aef	57 	W 
	jr nz,l4b3eh		;4af0	20 4c 	  L 
	ld c,c			;4af2	49 	I 
	ld c,(hl)			;4af3	4e 	N 
	ld b,l			;4af4	45 	E 
	jr nz,l4b31h		;4af5	20 3a 	  : 
	ld l,059h		;4af7	2e 59 	. Y 
	ld l,04eh		;4af9	2e 4e 	. N 
	ld hl,(02044h)		;4afb	2a 44 20 	* D   
	ld c,h			;4afe	4c 	L 
	ld c,c			;4aff	49 	I 
	ld c,(hl)			;4b00	4e 	N 
	ld b,l			;4b01	45 	E 
	jr nz,l4b4ah		;4b02	20 46 	  F 
	ld d,d			;4b04	52 	R 
	ld b,l			;4b05	45 	E 
	ld d,c			;4b06	51 	Q 
	jr nz,60		;4b07	20 3a 	  : 
	ld l,036h		;4b09	2e 36 	. 6 
	jr nc,l4b3bh		;4b0b	30 2e 	0 . 
	dec (hl)			;4b0d	35 	5 
	jr nc,l4b3ah		;4b0e	30 2a 	0 * 
	ld b,l			;4b10	45 	E 
	jr nz,l4b56h		;4b11	20 43 	  C 
	ld d,d			;4b13	52 	R 
	ld d,h			;4b14	54 	T 
	jr nz,l4b6ah		;4b15	20 53 	  S 
	ld b,c			;4b17	41 	A 
	ld d,(hl)			;4b18	56 	V 
	ld b,l			;4b19	45 	E 
	ld d,d			;4b1a	52 	R 
	jr nz,60		;4b1b	20 3a 	  : 
	ld l,059h		;4b1d	2e 59 	. Y 
	ld l,04eh		;4b1f	2e 4e 	. N 
	ld hl,(02046h)		;4b21	2a 46 20 	* F   
	ld e,b			;4b24	58 	X 
	ld c,a			;4b25	4f 	O 
	ld c,(hl)			;4b26	4e 	N 
	cpl			;4b27	2f 	/ 
	ld e,b			;4b28	58 	X 
	ld c,a			;4b29	4f 	O 
	ld b,(hl)			;4b2a	46 	F 
	ld b,(hl)			;4b2b	46 	F 
	jr nz,l4b68h		;4b2c	20 3a 	  : 
	ld l,04fh		;4b2e	2e 4f 	. O 
	ld c,(hl)			;4b30	4e 	N 
l4b31h:
	ld l,04fh		;4b31	2e 4f 	. O 
	ld b,(hl)			;4b33	46 	F 
	ld b,(hl)			;4b34	46 	F 
	ld hl,(02047h)		;4b35	2a 47 20 	* G   
	ld d,b			;4b38	50 	P 
	ld b,c			;4b39	41 	A 
l4b3ah:
	ld d,d			;4b3a	52 	R 
l4b3bh:
	ld c,c			;4b3b	49 	I 
l4b3ch:
	ld d,h			;4b3c	54 	T 
	ld e,c			;4b3d	59 	Y 
l4b3eh:
	jr nz,l4b60h		;4b3e	20 20 	    
	jr nz,l4b7ch		;4b40	20 3a 	  : 
	ld l,04fh		;4b42	2e 4f 	. O 
	ld b,(hl)			;4b44	46 	F 
	ld b,(hl)			;4b45	46 	F 
	ld l,04fh		;4b46	2e 4f 	. O 
	ld b,h			;4b48	44 	D 
	ld b,h			;4b49	44 	D 
l4b4ah:
	ld l,045h		;4b4a	2e 45 	. E 
	ld d,(hl)			;4b4c	56 	V 
	ld b,l			;4b4d	45 	E 
	ld c,(hl)			;4b4e	4e 	N 
	ld hl,(02048h)		;4b4f	2a 48 20 	* H   
	ld d,e			;4b52	53 	S 
	ld d,h			;4b53	54 	T 
	ld c,a			;4b54	4f 	O 
	ld d,b			;4b55	50 	P 
l4b56h:
	jr nz,l4b9ah		;4b56	20 42 	  B 
	ld c,c			;4b58	49 	I 
	ld d,h			;4b59	54 	T 
	jr nz,l4b96h		;4b5a	20 3a 	  : 
	ld l,031h		;4b5c	2e 31 	. 1 
	ld l,032h		;4b5e	2e 32 	. 2 
l4b60h:
	ld hl,(02049h)		;4b60	2a 49 20 	* I   
	ld b,d			;4b63	42 	B 
	ld c,c			;4b64	49 	I 
	ld d,h			;4b65	54 	T 
	cpl			;4b66	2f 	/ 
	ld b,e			;4b67	43 	C 
l4b68h:
	ld c,b			;4b68	48 	H 
	ld b,c			;4b69	41 	A 
l4b6ah:
	ld d,d			;4b6a	52 	R 
	jr nz,l4ba7h		;4b6b	20 3a 	  : 
	ld l,038h		;4b6d	2e 38 	. 8 
	ld l,037h		;4b6f	2e 37 	. 7 
	ld hl,(0204ah)		;4b71	2a 4a 20 	* J   
	ld d,h			;4b74	54 	T 
	ld b,c			;4b75	41 	A 
	ld b,d			;4b76	42 	B 
	jr nz,l4bcch		;4b77	20 53 	  S 
	ld b,c			;4b79	41 	A 
	ld d,(hl)			;4b7a	56 	V 
	ld b,l			;4b7b	45 	E 
l4b7ch:
	jr nz,l4bb8h		;4b7c	20 3a 	  : 
	ld l,059h		;4b7e	2e 59 	. Y 
	ld l,04eh		;4b80	2e 4e 	. N 
	ld hl,(0204bh)		;4b82	2a 4b 20 	* K   
	ld c,h			;4b85	4c 	L 
	ld b,l			;4b86	45 	E 
	ld b,c			;4b87	41 	A 
	ld b,h			;4b88	44 	D 
	dec l			;4b89	2d 	- 
	ld c,c			;4b8a	49 	I 
	ld c,(hl)			;4b8b	4e 	N 
	jr nz,l4bd1h		;4b8c	20 43 	  C 
	ld c,a			;4b8e	4f 	O 
	ld b,h			;4b8f	44 	D 
	ld b,l			;4b90	45 	E 
	jr nz,l4bcdh		;4b91	20 3a 	  : 
	ld l,045h		;4b93	2e 45 	. E 
	ld d,e			;4b95	53 	S 
l4b96h:
	ld b,e			;4b96	43 	C 
	ld l,054h		;4b97	2e 54 	. T 
	ld c,c			;4b99	49 	I 
l4b9ah:
	ld c,h			;4b9a	4c 	L 
	ld b,h			;4b9b	44 	D 
	ld b,l			;4b9c	45 	E 
	ld hl,(0204ch)		;4b9d	2a 4c 20 	* L   
	ld b,(hl)			;4ba0	46 	F 
	ld d,l			;4ba1	55 	U 
	ld c,(hl)			;4ba2	4e 	N 
	ld b,e			;4ba3	43 	C 
	jr nz,l4bf1h		;4ba4	20 4b 	  K 
	ld b,l			;4ba6	45 	E 
l4ba7h:
	ld e,c			;4ba7	59 	Y 
	jr nz,60		;4ba8	20 3a 	  : 
	ld l,045h		;4baa	2e 45 	. E 
	ld d,e			;4bac	53 	S 
	ld b,e			;4bad	43 	C 
	dec l			;4bae	2d 	- 
	ld b,e			;4baf	43 	C 
	ld c,a			;4bb0	4f 	O 
	ld b,h			;4bb1	44 	D 
	ld b,l			;4bb2	45 	E 
	ld l,045h		;4bb3	2e 45 	. E 
	ld d,e			;4bb5	53 	S 
	ld b,e			;4bb6	43 	C 
	dec l			;4bb7	2d 	- 
l4bb8h:
	ld b,e			;4bb8	43 	C 
	ld c,a			;4bb9	4f 	O 
	ld b,h			;4bba	44 	D 
	ld b,l			;4bbb	45 	E 
	dec l			;4bbc	2d 	- 
	ld b,e			;4bbd	43 	C 
	ld d,d			;4bbe	52 	R 
	ld l,053h		;4bbf	2e 53 	. S 
	ld d,h			;4bc1	54 	T 
	ld e,b			;4bc2	58 	X 
	dec l			;4bc3	2d 	- 
	ld b,e			;4bc4	43 	C 
	ld c,a			;4bc5	4f 	O 
	ld b,h			;4bc6	44 	D 
	ld b,l			;4bc7	45 	E 
	ld l,053h		;4bc8	2e 53 	. S 
	ld d,h			;4bca	54 	T 
	ld e,b			;4bcb	58 	X 
l4bcch:
	dec l			;4bcc	2d 	- 
l4bcdh:
	ld b,e			;4bcd	43 	C 
	ld c,a			;4bce	4f 	O 
	ld b,h			;4bcf	44 	D 
	ld b,l			;4bd0	45 	E 
l4bd1h:
	dec l			;4bd1	2d 	- 
	ld b,e			;4bd2	43 	C 
	ld d,d			;4bd3	52 	R 
	ld hl,(0204dh)		;4bd4	2a 4d 20 	* M   
	ld e,b			;4bd7	58 	X 
	ld c,l			;4bd8	4d 	M 
	ld c,c			;4bd9	49 	I 
	ld d,h			;4bda	54 	T 
	jr nz,l4c22h		;4bdb	20 45 	  E 
	ld d,e			;4bdd	53 	S 
	ld b,e			;4bde	43 	C 
	jr nz,l4c34h		;4bdf	20 53 	  S 
	ld b,l			;4be1	45 	E 
	ld d,c			;4be2	51 	Q 
	jr nz,l4c2bh		;4be3	20 46 	  F 
	ld c,a			;4be5	4f 	O 
	ld d,d			;4be6	52 	R 
	jr nz,69		;4be7	20 43 	  C 
	ld c,h			;4be9	4c 	L 
	ld b,l			;4bea	45 	E 
	ld b,c			;4beb	41 	A 
	ld d,d			;4bec	52 	R 
	jr nz,77		;4bed	20 4b 	  K 
	ld b,l			;4bef	45 	E 
	ld e,c			;4bf0	59 	Y 
l4bf1h:
	jr nz,l4c2dh		;4bf1	20 3a 	  : 
	ld l,059h		;4bf3	2e 59 	. Y 
	ld l,04eh		;4bf5	2e 4e 	. N 
	ld hl,(0204eh)		;4bf7	2a 4e 20 	* N   
	ld d,l			;4bfa	55 	U 
	cpl			;4bfb	2f 	/ 
	ld b,e			;4bfc	43 	C 
	jr nz,l4c56h		;4bfd	20 57 	  W 
	ld c,b			;4bff	48 	H 
	ld b,l			;4c00	45 	E 
	ld c,(hl)			;4c01	4e 	N 
	jr nz,82		;4c02	20 50 	  P 
	ld c,a			;4c04	4f 	O 
	ld d,a			;4c05	57 	W 
	ld b,l			;4c06	45 	E 
	ld d,d			;4c07	52 	R 
	jr nz,l4c5fh		;4c08	20 55 	  U 
	ld d,b			;4c0a	50 	P 
	jr nz,60		;4c0b	20 3a 	  : 
	ld l,059h		;4c0d	2e 59 	. Y 
	ld l,04eh		;4c0f	2e 4e 	. N 
	ld hl,(0204fh)		;4c11	2a 4f 20 	* O   
	ld c,e			;4c14	4b 	K 
	ld b,l			;4c15	45 	E 
	ld e,c			;4c16	59 	Y 
	ld b,d			;4c17	42 	B 
	ld b,h			;4c18	44 	D 
	jr nz,l4c67h		;4c19	20 4c 	  L 
	ld c,a			;4c1b	4f 	O 
	ld b,e			;4c1c	43 	C 
	ld c,e			;4c1d	4b 	K 
	jr nz,l4c77h		;4c1e	20 57 	  W 
	ld c,b			;4c20	48 	H 
	ld b,l			;4c21	45 	E 
l4c22h:
	ld c,(hl)			;4c22	4e 	N 
	jr nz,l4c75h		;4c23	20 50 	  P 
	ld d,d			;4c25	52 	R 
	ld c,c			;4c26	49 	I 
	ld c,(hl)			;4c27	4e 	N 
	ld d,h			;4c28	54 	T 
	jr nz,l4c65h		;4c29	20 3a 	  : 
l4c2bh:
	ld l,059h		;4c2b	2e 59 	. Y 
l4c2dh:
	ld l,04eh		;4c2d	2e 4e 	. N 
	ld hl,(02050h)		;4c2f	2a 50 20 	* P   
	ld b,c			;4c32	41 	A 
	ld d,l			;4c33	55 	U 
l4c34h:
	ld d,h			;4c34	54 	T 
	ld c,a			;4c35	4f 	O 
	jr nz,78		;4c36	20 4c 	  L 
	ld b,(hl)			;4c38	46 	F 
	jr nz,l4c8ah		;4c39	20 4f 	  O 
	ld c,(hl)			;4c3b	4e 	N 
	jr nz,l4c81h		;4c3c	20 43 	  C 
	ld d,d			;4c3e	52 	R 
	jr nz,l4c7bh		;4c3f	20 3a 	  : 
	ld l,04eh		;4c41	2e 4e 	. N 
	ld l,059h		;4c43	2e 59 	. Y 
	ld hl,(02051h)		;4c45	2a 51 20 	* Q   
	ld c,(hl)			;4c48	4e 	N 
	ld b,c			;4c49	41 	A 
	ld d,h			;4c4a	54 	T 
	jr nz,69		;4c4b	20 43 	  C 
	ld c,b			;4c4d	48 	H 
	ld b,c			;4c4e	41 	A 
	ld d,d			;4c4f	52 	R 
	jr nz,l4c72h		;4c50	20 20 	    
	ld a,(0552eh)		;4c52	3a 2e 55 	: . U 
	ld d,e			;4c55	53 	S 
l4c56h:
	jr nz,48		;4c56	20 2e 	  . 
	ld d,l			;4c58	55 	U 
	ld c,e			;4c59	4b 	K 
	jr nz,l4c8ah		;4c5a	20 2e 	  . 
	ld b,(hl)			;4c5c	46 	F 
	ld d,d			;4c5d	52 	R 
	ld b,l			;4c5e	45 	E 
l4c5fh:
	ld l,047h		;4c5f	2e 47 	. G 
	ld b,l			;4c61	45 	E 
	ld d,d			;4c62	52 	R 
	ld l,053h		;4c63	2e 53 	. S 
l4c65h:
	ld d,a			;4c65	57 	W 
	ld b,h			;4c66	44 	D 
l4c67h:
	ld l,04eh		;4c67	2e 4e 	. N 
	ld d,d			;4c69	52 	R 
	ld d,a			;4c6a	57 	W 
	ld l,053h		;4c6b	2e 53 	. S 
	ld d,b			;4c6d	50 	P 
	ld c,(hl)			;4c6e	4e 	N 
	ld l,049h		;4c6f	2e 49 	. I 
	ld d,h			;4c71	54 	T 
l4c72h:
	ld c,h			;4c72	4c 	L 
	ld l,047h		;4c73	2e 47 	. G 
l4c75h:
	ld d,d			;4c75	52 	R 
	ld b,c			;4c76	41 	A 
l4c77h:
	ld hl,(02052h)		;4c77	2a 52 20 	* R   
	ld b,l			;4c7a	45 	E 
l4c7bh:
	ld c,l			;4c7b	4d 	M 
	ld d,l			;4c7c	55 	U 
	ld c,h			;4c7d	4c 	L 
	ld b,c			;4c7e	41 	A 
	ld d,h			;4c7f	54 	T 
	ld c,c			;4c80	49 	I 
l4c81h:
	ld c,a			;4c81	4f 	O 
	ld c,(hl)			;4c82	4e 	N 
	jr nz,60		;4c83	20 3a 	  : 
	ld l,041h		;4c85	2e 41 	. A 
	ld c,l			;4c87	4d 	M 
	ld d,b			;4c88	50 	P 
	ld b,l			;4c89	45 	E 
l4c8ah:
	ld e,b			;4c8a	58 	X 
	ld l,049h		;4c8b	2e 49 	. I 
	ld d,c			;4c8d	51 	Q 
	ld sp,03032h		;4c8e	31 32 30 	1 2 0 
	ld l,052h		;4c91	2e 52 	. R 
	ld b,l			;4c93	45 	E 
	ld b,a			;4c94	47 	G 
	ld (02e35h),a		;4c95	32 35 2e 	2 5 . 
	ld b,c			;4c98	41 	A 
	ld b,h			;4c99	44 	D 
	ld c,l			;4c9a	4d 	M 
	dec (hl)			;4c9b	35 	5 
	jr nz,l4ccch		;4c9c	20 2e 	  . 
	ld d,(hl)			;4c9e	56 	V 
	ld c,c			;4c9f	49 	I 
	ld b,l			;4ca0	45 	E 
	ld d,a			;4ca1	57 	W 
	ld d,b			;4ca2	50 	P 
	ld l,056h		;4ca3	2e 56 	. V 
	ld d,h			;4ca5	54 	T 
	dec (hl)			;4ca6	35 	5 
	ld (02e20h),a		;4ca7	32 20 2e 	2   . 
	ld d,h			;4caa	54 	T 
	ld d,(hl)			;4cab	56 	V 
	add hl,sp			;4cac	39 	9 
	ld (02e30h),a		;4cad	32 30 2e 	2 0 . 
	ld d,h			;4cb0	54 	T 
	ld d,(hl)			;4cb1	56 	V 
	add hl,sp			;4cb2	39 	9 
	dec (hl)			;4cb3	35 	5 
	jr nc,48		;4cb4	30 2e 	0 . 
	ld c,b			;4cb6	48 	H 
	ld sp,03035h		;4cb7	31 35 30 	1 5 0 
	jr nc,l4ceah		;4cba	30 2e 	0 . 
	ld c,b			;4cbc	48 	H 
	ld sp,03134h		;4cbd	31 34 31 	1 4 1 
	jr nc,48		;4cc0	30 2e 	0 . 
	ld c,b			;4cc2	48 	H 
	ld sp,03234h		;4cc3	31 34 32 	1 4 2 
	jr nc,l4cf2h		;4cc6	30 2a 	0 * 
	ld d,e			;4cc8	53 	S 
	jr nz,l4d03h		;4cc9	20 38 	  8 
	ld d,h			;4ccb	54 	T 
l4ccch:
	ld c,b			;4ccc	48 	H 
	jr nz,l4d11h		;4ccd	20 42 	  B 
	ld c,c			;4ccf	49 	I 
	ld d,h			;4cd0	54 	T 
	jr nz,l4d22h		;4cd1	20 4f 	  O 
	ld b,(hl)			;4cd3	46 	F 
	jr nz,l4d26h		;4cd4	20 50 	  P 
	ld d,d			;4cd6	52 	R 
	ld c,c			;4cd7	49 	I 
	ld c,l			;4cd8	4d 	M 
	ld b,c			;4cd9	41 	A 
	ld d,d			;4cda	52 	R 
	ld e,c			;4cdb	59 	Y 
	jr nz,l4d18h		;4cdc	20 3a 	  : 
	ld l,030h		;4cde	2e 30 	. 0 
	ld l,031h		;4ce0	2e 31 	. 1 
	ld hl,(02054h)		;4ce2	2a 54 20 	* T   
	jr c,l4d3bh		;4ce5	38 54 	8 T 
	ld c,b			;4ce7	48 	H 
	jr nz,l4d2ch		;4ce8	20 42 	  B 
l4ceah:
	ld c,c			;4cea	49 	I 
	ld d,h			;4ceb	54 	T 
	jr nz,l4d3dh		;4cec	20 4f 	  O 
	ld b,(hl)			;4cee	46 	F 
	jr nz,l4d41h		;4cef	20 50 	  P 
	ld d,d			;4cf1	52 	R 
l4cf2h:
	ld c,c			;4cf2	49 	I 
	ld c,(hl)			;4cf3	4e 	N 
	ld d,h			;4cf4	54 	T 
	ld b,l			;4cf5	45 	E 
	ld d,d			;4cf6	52 	R 
	jr nz,l4d33h		;4cf7	20 3a 	  : 
	ld l,030h		;4cf9	2e 30 	. 0 
	ld l,031h		;4cfb	2e 31 	. 1 
	ld hl,(02055h)		;4cfd	2a 55 20 	* U   
	ld b,l			;4d00	45 	E 
	ld c,a			;4d01	4f 	O 
	ld c,l			;4d02	4d 	M 
l4d03h:
	jr nz,l4d48h		;4d03	20 43 	  C 
	ld c,a			;4d05	4f 	O 
	ld b,h			;4d06	44 	D 
	ld b,l			;4d07	45 	E 
	jr nz,l4d44h		;4d08	20 3a 	  : 
	ld l,04eh		;4d0a	2e 4e 	. N 
	ld c,a			;4d0c	4f 	O 
	dec l			;4d0d	2d 	- 
	ld b,e			;4d0e	43 	C 
	ld c,a			;4d0f	4f 	O 
	ld b,h			;4d10	44 	D 
l4d11h:
	ld b,l			;4d11	45 	E 
	ld l,045h		;4d12	2e 45 	. E 
	ld d,h			;4d14	54 	T 
	ld e,b			;4d15	58 	X 
	ld l,045h		;4d16	2e 45 	. E 
l4d18h:
	ld c,a			;4d18	4f 	O 
	ld d,h			;4d19	54 	T 
	ld l,043h		;4d1a	2e 43 	. C 
	ld d,d			;4d1c	52 	R 
	ld hl,(02056h)		;4d1d	2a 56 20 	* V   
	ld d,b			;4d20	50 	P 
	ld d,d			;4d21	52 	R 
l4d22h:
	ld c,c			;4d22	49 	I 
	ld c,(hl)			;4d23	4e 	N 
	ld d,h			;4d24	54 	T 
	ld b,l			;4d25	45 	E 
l4d26h:
	ld d,d			;4d26	52 	R 
	jr nz,68		;4d27	20 42 	  B 
	ld b,c			;4d29	41 	A 
	ld d,l			;4d2a	55 	U 
	ld b,h			;4d2b	44 	D 
l4d2ch:
	jr nz,84		;4d2c	20 52 	  R 
	ld b,c			;4d2e	41 	A 
	ld d,h			;4d2f	54 	T 
	ld b,l			;4d30	45 	E 
	jr nz,l4d53h		;4d31	20 20 	    
l4d33h:
	ld a,(02120h)		;4d33	3a 20 21 	:   ! 
	ld (hl),030h		;4d36	36 30 	6 0 
	jr nc,l4d64h		;4d38	30 2a 	0 * 
	ld d,h			;4d3a	54 	T 
l4d3bh:
	ld e,c			;4d3b	59 	Y 
	ld d,b			;4d3c	50 	P 
l4d3dh:
	ld b,l			;4d3d	45 	E 
	jr nz,l4d83h		;4d3e	20 43 	  C 
	ld d,h			;4d40	54 	T 
l4d41h:
	ld d,d			;4d41	52 	R 
	ld c,h			;4d42	4c 	L 
	cpl			;4d43	2f 	/ 
l4d44h:
	ld c,b			;4d44	48 	H 
	ld c,a			;4d45	4f 	O 
	ld c,l			;4d46	4d 	M 
	ld b,l			;4d47	45 	E 
l4d48h:
	jr nz,l4d9eh		;4d48	20 54 	  T 
	ld c,a			;4d4a	4f 	O 
	jr nz,l4d92h		;4d4b	20 45 	  E 
	ld e,b			;4d4d	58 	X 
	ld c,c			;4d4e	49 	I 
	ld d,h			;4d4f	54 	T 
	inc l			;4d50	2c 	, 
	jr nz,69		;4d51	20 43 	  C 
l4d53h:
	ld d,h			;4d53	54 	T 
	ld d,d			;4d54	52 	R 
	ld c,h			;4d55	4c 	L 
	cpl			;4d56	2f 	/ 
	ld d,e			;4d57	53 	S 
	jr nz,l4daeh		;4d58	20 54 	  T 
	ld c,a			;4d5a	4f 	O 
	jr nz,85		;4d5b	20 53 	  S 
	ld b,c			;4d5d	41 	A 
	ld d,(hl)			;4d5e	56 	V 
	ld b,l			;4d5f	45 	E 
	jr nz,67		;4d60	20 41 	  A 
	ld c,(hl)			;4d62	4e 	N 
	ld b,h			;4d63	44 	D 
l4d64h:
	jr nz,l4dabh		;4d64	20 45 	  E 
	ld e,b			;4d66	58 	X 
	ld c,c			;4d67	49 	I 
	ld d,h			;4d68	54 	T 
	inc l			;4d69	2c 	, 
	jr nz,67		;4d6a	20 41 	  A 
	ld c,(hl)			;4d6c	4e 	N 
	ld b,h			;4d6d	44 	D 
	jr nz,l4db1h		;4d6e	20 41 	  A 
	dec l			;4d70	2d 	- 
	ld d,(hl)			;4d71	56 	V 
	jr nz,86		;4d72	20 54 	  T 
	ld c,a			;4d74	4f 	O 
	jr nz,l4dbah		;4d75	20 43 	  C 
	ld c,b			;4d77	48 	H 
	ld b,c			;4d78	41 	A 
	ld c,(hl)			;4d79	4e 	N 
	ld b,a			;4d7a	47 	G 
	ld b,l			;4d7b	45 	E 
	jr nz,l4db8h		;4d7c	20 3a 	  : 
	ccf			;4d7e	3f 	? 
	sub 070h		;4d7f	d6 70 	. p 
	cp 030h		;4d81	fe 30 	. 0 
l4d83h:
	jr z,l4db3h		;4d83	28 2e 	( . 
	cp 03ah		;4d85	fe 3a 	. : 
	jr c,l4d93h		;4d87	38 0a 	8 . 
	sub 03ah		;4d89	d6 3a 	. : 
	ld c,a			;4d8b	4f 	O 
	ld b,000h		;4d8c	06 00 	. . 
	ld hl,l4dcdh		;4d8e	21 cd 4d 	! . M 
	add hl,bc			;4d91	09 	. 
l4d92h:
	ld a,(hl)			;4d92	7e 	~ 
l4d93h:
	ld c,a			;4d93	4f 	O 
	ld a,(0aa2bh)		;4d94	3a 2b aa 	: + . 
	and 020h		;4d97	e6 20 	.   
	jr nz,l4db7h		;4d99	20 1c 	  . 
	ld a,(ram_setup_flags_b9)		;4d9b	3a b9 aa 	: . . 
l4d9eh:
	bit 5,a		;4d9e	cb 6f 	. o 
	push af			;4da0	f5 	. 
	push bc			;4da1	c5 	. 
	ld c,01bh		;4da2	0e 1b 	. . 
	jr z,l4da8h		;4da4	28 02 	( . 
	ld c,002h		;4da6	0e 02 	. . 
l4da8h:
	rst 18h			;4da8	df 	. 
	pop bc			;4da9	c1 	. 
	rst 18h			;4daa	df 	. 
l4dabh:
	pop af			;4dab	f1 	. 
	bit 4,a		;4dac	cb 67 	. g 
l4daeh:
	ret z			;4dae	c8 	. 
	ld c,00dh		;4daf	0e 0d 	. . 
l4db1h:
	rst 18h			;4db1	df 	. 
	ret			;4db2	c9 	. 
l4db3h:
	ld a,02ch		;4db3	3e 2c 	> , 
	jr l4d93h		;4db5	18 dc 	. . 
l4db7h:
	ld a,c			;4db7	79 	y 
l4db8h:
	add a,040h		;4db8	c6 40 	. @ 
l4dbah:
	cp 06ch		;4dba	fe 6c 	. l 
	ld c,a			;4dbc	4f 	O 
	jr nz,l4dc1h		;4dbd	20 02 	  . 
	ld c,04dh		;4dbf	0e 4d 	. M 
l4dc1h:
	push bc			;4dc1	c5 	. 
	ld hl,ram_leadin_byte		;4dc2	21 99 aa 	! . . 
	ld c,(hl)			;4dc5	4e 	N 
	rst 18h			;4dc6	df 	. 
	ld c,03fh		;4dc7	0e 3f 	. ? 
	rst 18h			;4dc9	df 	. 
	pop bc			;4dca	c1 	. 
	rst 18h			;4dcb	df 	. 
	ret			;4dcc	c9 	. 
l4dcdh:
	jr nc,48		;4dcd	30 2e 	0 . 
	pop bc			;4dcf	c1 	. 
	ld hl,0ae1dh		;4dd0	21 1d ae 	! . . 
l4dd3h:
	ld (hl),000h		;4dd3	36 00 	6 . 
	dec hl			;4dd5	2b 	+ 
	bit 3,h		;4dd6	cb 5c 	. \ 
	jr nz,l4dd3h		;4dd8	20 f9 	  . 
	push bc			;4dda	c5 	. 
	ld (0aaa6h),ix		;4ddb	dd 22 a6 aa 	. " . . 
	ld (0aaa8h),de		;4ddf	ed 53 a8 aa 	. S . . 
	ld (0aaaah),a		;4de3	32 aa aa 	2 . . 
	ld a,037h		;4de6	3e 37 	> 7 
	ld (0abe9h),a		;4de8	32 e9 ab 	2 . . 
	ld a,036h		;4deb	3e 36 	> 6 
	ld (0abeah),a		;4ded	32 ea ab 	2 . . 
	call 00128h		;4df0	cd 28 01 	. ( . 
	ld hl,0aabah		;4df3	21 ba aa 	! . . 
	ld c,05ah		;4df6	0e 5a 	. Z 
	bit 0,(hl)		;4df8	cb 46 	. F 
	jr nz,l4dffh		;4dfa	20 03 	  . 
	call 01475h		;4dfc	cd 75 14 	. u . 
l4dffh:
	ld c,057h		;4dff	0e 57 	. W 
	call 01475h		;4e01	cd 75 14 	. u . 
	call 0017fh		;4e04	cd 7f 01 	.  . 
	call sub_4ec1h		;4e07	cd c1 4e 	. . N 
	call sub_4e97h		;4e0a	cd 97 4e 	. . N 
	call 03648h		;4e0d	cd 48 36 	. H 6 
	ld a,(0aaaah)		;4e10	3a aa aa 	: . . 
	and a			;4e13	a7 	. 
	jr nz,l4e70h		;4e14	20 5a 	  Z 
	ld a,(0503bh)		;4e16	3a 3b 50 	: ; P 
	and 00fh		;4e19	e6 0f 	. . 
	cp 009h		;4e1b	fe 09 	. . 
	call nz,sub_4edch		;4e1d	c4 dc 4e 	. . N 
	call sub_4e85h		;4e20	cd 85 4e 	. . N 
	ld de,0b000h		;4e23	11 00 b0 	. . . 
	ld hl,(0ae1eh)		;4e26	2a 1e ae 	* . . 
	and a			;4e29	a7 	. 
	sbc hl,de		;4e2a	ed 52 	. R 
	jr c,l4e34h		;4e2c	38 06 	8 . 
	jr z,l4e34h		;4e2e	28 04 	( . 
	ld (0ae1eh),de		;4e30	ed 53 1e ae 	. S . . 
l4e34h:
	ld b,014h		;4e34	06 14 	. . 
	ld ix,0ae20h		;4e36	dd 21 20 ae 	. !   . 
l4e3ah:
	push bc			;4e3a	c5 	. 
	ld b,002h		;4e3b	06 02 	. . 
l4e3dh:
	ld l,(ix+000h)		;4e3d	dd 6e 00 	. n . 
	ld h,(ix+001h)		;4e40	dd 66 01 	. f . 
	push hl			;4e43	e5 	. 
	and a			;4e44	a7 	. 
	sbc hl,de		;4e45	ed 52 	. R 
	jr c,l4e53h		;4e47	38 0a 	8 . 
	jr z,l4e53h		;4e49	28 08 	( . 
	ld (ix+000h),e		;4e4b	dd 73 00 	. s . 
	ld (ix+001h),d		;4e4e	dd 72 01 	. r . 
	pop hl			;4e51	e1 	. 
	push de			;4e52	d5 	. 
l4e53h:
	inc ix		;4e53	dd 23 	. # 
	inc ix		;4e55	dd 23 	. # 
	djnz l4e3dh		;4e57	10 e4 	. . 
	pop hl			;4e59	e1 	. 
	pop bc			;4e5a	c1 	. 
	and a			;4e5b	a7 	. 
	sbc hl,bc		;4e5c	ed 42 	. B 
	jr nc,l4e6dh		;4e5e	30 0d 	0 . 
	xor a			;4e60	af 	. 
	ld (ix-001h),a		;4e61	dd 77 ff 	. w . 
	ld (ix-002h),a		;4e64	dd 77 fe 	. w . 
	ld (ix-003h),a		;4e67	dd 77 fd 	. w . 
	ld (ix-004h),a		;4e6a	dd 77 fc 	. w . 
l4e6dh:
	pop bc			;4e6d	c1 	. 
	djnz l4e3ah		;4e6e	10 ca 	. . 
l4e70h:
	call 0b015h		;4e70	cd 15 b0 	. . . 
	call 002dbh		;4e73	cd db 02 	. . . 
	call 0022bh		;4e76	cd 2b 02 	. + . 
	call 00a99h		;4e79	cd 99 0a 	. . . 
	call 00353h		;4e7c	cd 53 03 	. S . 
	call 0b006h		;4e7f	cd 06 b0 	. . . 
	jp 001afh		;4e82	c3 af 01 	. . . 
sub_4e85h:
	ld b,002h		;4e85	06 02 	. . 
	ld hl,0ae1eh		;4e87	21 1e ae 	! . . 
	ld de,0503ch		;4e8a	11 3c 50 	. < P 
l4e8dh:
	push bc			;4e8d	c5 	. 
	ld b,0f1h		;4e8e	06 f1 	. . 
	call 002cfh		;4e90	cd cf 02 	. . . 
	pop bc			;4e93	c1 	. 
	djnz l4e8dh		;4e94	10 f7 	. . 
	ret			;4e96	c9 	. 
sub_4e97h:
	ld b,060h		;4e97	06 60 	. ` 
	xor a			;4e99	af 	. 
	ld hl,0aac7h		;4e9a	21 c7 aa 	! . . 
	ld (0ac1eh),hl		;4e9d	22 1e ac 	" . . 
l4ea0h:
	ld (hl),a			;4ea0	77 	w 
	inc a			;4ea1	3c 	< 
	inc hl			;4ea2	23 	# 
	djnz l4ea0h		;4ea3	10 fb 	. . 
	ld a,017h		;4ea5	3e 17 	> . 
	ld (0ab27h),a		;4ea7	32 27 ab 	2 ' . 
	ld (0ab2dh),a		;4eaa	32 2d ab 	2 - . 
	xor a			;4ead	af 	. 
	ld (0ab2eh),a		;4eae	32 2e ab 	2 . . 
	ld (0ac09h),a		;4eb1	32 09 ac 	2 . . 
	inc a			;4eb4	3c 	< 
	ld (0abf8h),a		;4eb5	32 f8 ab 	2 . . 
	call 03d43h		;4eb8	cd 43 3d 	. C = 
	call 02f22h		;4ebb	cd 22 2f 	. " / 
	jp 03ceeh		;4ebe	c3 ee 3c 	. . < 
sub_4ec1h:
	xor a			;4ec1	af 	. 
	ld (0aab0h),a		;4ec2	32 b0 aa 	2 . . 
	ld (0ac35h),a		;4ec5	32 35 ac 	2 5 . 
	ld (0ac36h),a		;4ec8	32 36 ac 	2 6 . 
	ld b,00ch		;4ecb	06 0c 	. . 
	ld de,0acfeh		;4ecd	11 fe ac 	. . . 
	ld hl,0ac29h		;4ed0	21 29 ac 	! ) . 
	ld a,0ffh		;4ed3	3e ff 	> . 
l4ed5h:
	ld (hl),a			;4ed5	77 	w 
	ld (de),a			;4ed6	12 	. 
	inc de			;4ed7	13 	. 
	inc hl			;4ed8	23 	# 
	djnz l4ed5h		;4ed9	10 fa 	. . 
	ret			;4edb	c9 	. 
sub_4edch:
	ld b,002h		;4edc	06 02 	. . 
	ld de,0ae70h		;4ede	11 70 ae 	. p . 
	ld hl,0503ch		;4ee1	21 3c 50 	! < P 
	ld a,e			;4ee4	7b 	{ 
l4ee5h:
	ld (hl),a			;4ee5	77 	w 
	rrca			;4ee6	0f 	. 
	rrca			;4ee7	0f 	. 
	rrca			;4ee8	0f 	. 
	rrca			;4ee9	0f 	. 
	inc hl			;4eea	23 	# 
	ld (hl),a			;4eeb	77 	w 
	inc hl			;4eec	23 	# 
	ld a,d			;4eed	7a 	z 
	djnz l4ee5h		;4eee	10 f5 	. . 
	ld b,0a0h		;4ef0	06 a0 	. . 
	ld hl,05040h		;4ef2	21 40 50 	! @ P 
l4ef5h:
	ld (hl),000h		;4ef5	36 00 	6 . 
	inc hl			;4ef7	23 	# 
	djnz l4ef5h		;4ef8	10 fb 	. . 
	ld hl,0503bh		;4efa	21 3b 50 	! ; P 
	ld (hl),009h		;4efd	36 09 	6 . 
	ret			;4eff	c9 	. 
version_string:
	ld b,c			;4f00	41 	A 
	ld c,l			;4f01	4d 	M 
	ld d,b			;4f02	50 	P 
	ld b,l			;4f03	45 	E 
	ld e,b			;4f04	58 	X 
	jr nz,70		;4f05	20 44 	  D 
	ld sp,03537h		;4f07	31 37 35 	1 7 5 
	jr nz,86		;4f0a	20 54 	  T 
	ld b,l			;4f0c	45 	E 
	ld d,d			;4f0d	52 	R 
	ld c,l			;4f0e	4d 	M 
	ld c,c			;4f0f	49 	I 
	ld c,(hl)			;4f10	4e 	N 
	ld b,c			;4f11	41 	A 
	ld c,h			;4f12	4c 	L 
	jr nz,l4f35h		;4f13	20 20 	    
	ld d,(hl)			;4f15	56 	V 
	jr nz,53		;4f16	20 33 	  3 
	ld l,035h		;4f18	2e 35 	. 5 
	dec a			;4f1a	3d 	= 
	ld hl,0aabah		;4f1b	21 ba aa 	! . . 
	ld a,(hl)			;4f1e	7e 	~ 
	and 0f0h		;4f1f	e6 f0 	. . 
	rrca			;4f21	0f 	. 
	rrca			;4f22	0f 	. 
	rrca			;4f23	0f 	. 
	rrca			;4f24	0f 	. 
	cp 009h		;4f25	fe 09 	. . 
	jr c,l4f2eh		;4f27	38 05 	8 . 
	ld a,(hl)			;4f29	7e 	~ 
	and 00fh		;4f2a	e6 0f 	. . 
	ld (hl),a			;4f2c	77 	w 
	xor a			;4f2d	af 	. 
l4f2eh:
	inc a			;4f2e	3c 	< 
	ld b,a			;4f2f	47 	G 
	ld c,a			;4f30	4f 	O 
	add a,040h		;4f31	c6 40 	. @ 
	cp 049h		;4f33	fe 49 	. I 
l4f35h:
	push bc			;4f35	c5 	. 
	ld c,a			;4f36	4f 	O 
	call c,01475h		;4f37	dc 75 14 	. u . 
	pop bc			;4f3a	c1 	. 
	ld a,080h		;4f3b	3e 80 	> . 
	and a			;4f3d	a7 	. 
l4f3eh:
	rla			;4f3e	17 	. 
	djnz l4f3eh		;4f3f	10 fd 	. . 
	ld (0aa89h),a		;4f41	32 89 aa 	2 . . 
	ld b,c			;4f44	41 	A 
	ld ix,00462h		;4f45	dd 21 62 04 	. ! b . 
	ld de,0000ch		;4f49	11 0c 00 	. . . 
	jr l4f50h		;4f4c	18 02 	. . 
l4f4eh:
	add ix,de		;4f4e	dd 19 	. . 
l4f50h:
	djnz l4f4eh		;4f50	10 fc 	. . 
	ld bc,00455h		;4f52	01 55 04 	. U . 
l4f55h:
	ld a,(bc)			;4f55	0a 	. 
	cp 0ffh		;4f56	fe ff 	. . 
	ret z			;4f58	c8 	. 
	ld e,a			;4f59	5f 	_ 
	ld hl,0ac6ah		;4f5a	21 6a ac 	! j . 
	add hl,de			;4f5d	19 	. 
	ld a,(ix+000h)		;4f5e	dd 7e 00 	. ~ . 
	inc bc			;4f61	03 	. 
	inc ix		;4f62	dd 23 	. # 
	ld (hl),a			;4f64	77 	w 
	jr l4f55h		;4f65	18 ee 	. . 
	rst 38h			;4f67	ff 	. 
	rst 38h			;4f68	ff 	. 
	rst 38h			;4f69	ff 	. 
	rst 38h			;4f6a	ff 	. 
	rst 38h			;4f6b	ff 	. 
	rst 38h			;4f6c	ff 	. 
	rst 38h			;4f6d	ff 	. 
	rst 38h			;4f6e	ff 	. 
	rst 38h			;4f6f	ff 	. 
	rst 38h			;4f70	ff 	. 
	rst 38h			;4f71	ff 	. 
	rst 38h			;4f72	ff 	. 
	rst 38h			;4f73	ff 	. 
	rst 38h			;4f74	ff 	. 
	rst 38h			;4f75	ff 	. 
	rst 38h			;4f76	ff 	. 
	rst 38h			;4f77	ff 	. 
	rst 38h			;4f78	ff 	. 
	rst 38h			;4f79	ff 	. 
	rst 38h			;4f7a	ff 	. 
	rst 38h			;4f7b	ff 	. 
	rst 38h			;4f7c	ff 	. 
	rst 38h			;4f7d	ff 	. 
	rst 38h			;4f7e	ff 	. 
	rst 38h			;4f7f	ff 	. 
	rst 38h			;4f80	ff 	. 
	rst 38h			;4f81	ff 	. 
	rst 38h			;4f82	ff 	. 
	rst 38h			;4f83	ff 	. 
	rst 38h			;4f84	ff 	. 
	rst 38h			;4f85	ff 	. 
	rst 38h			;4f86	ff 	. 
	rst 38h			;4f87	ff 	. 
	rst 38h			;4f88	ff 	. 
	rst 38h			;4f89	ff 	. 
	rst 38h			;4f8a	ff 	. 
	rst 38h			;4f8b	ff 	. 
	rst 38h			;4f8c	ff 	. 
	rst 38h			;4f8d	ff 	. 
	rst 38h			;4f8e	ff 	. 
	rst 38h			;4f8f	ff 	. 
	rst 38h			;4f90	ff 	. 
	rst 38h			;4f91	ff 	. 
	rst 38h			;4f92	ff 	. 
	rst 38h			;4f93	ff 	. 
	rst 38h			;4f94	ff 	. 
	rst 38h			;4f95	ff 	. 
	rst 38h			;4f96	ff 	. 
	rst 38h			;4f97	ff 	. 
	rst 38h			;4f98	ff 	. 
	rst 38h			;4f99	ff 	. 
	rst 38h			;4f9a	ff 	. 
	rst 38h			;4f9b	ff 	. 
	rst 38h			;4f9c	ff 	. 
	rst 38h			;4f9d	ff 	. 
	rst 38h			;4f9e	ff 	. 
	rst 38h			;4f9f	ff 	. 
	rst 38h			;4fa0	ff 	. 
	rst 38h			;4fa1	ff 	. 
	rst 38h			;4fa2	ff 	. 
	rst 38h			;4fa3	ff 	. 
	rst 38h			;4fa4	ff 	. 
	rst 38h			;4fa5	ff 	. 
	rst 38h			;4fa6	ff 	. 
	rst 38h			;4fa7	ff 	. 
	rst 38h			;4fa8	ff 	. 
	rst 38h			;4fa9	ff 	. 
	rst 38h			;4faa	ff 	. 
	rst 38h			;4fab	ff 	. 
	rst 38h			;4fac	ff 	. 
	rst 38h			;4fad	ff 	. 
	rst 38h			;4fae	ff 	. 
	rst 38h			;4faf	ff 	. 
	rst 38h			;4fb0	ff 	. 
	rst 38h			;4fb1	ff 	. 
	rst 38h			;4fb2	ff 	. 
	rst 38h			;4fb3	ff 	. 
	rst 38h			;4fb4	ff 	. 
	rst 38h			;4fb5	ff 	. 
	rst 38h			;4fb6	ff 	. 
	rst 38h			;4fb7	ff 	. 
	rst 38h			;4fb8	ff 	. 
	rst 38h			;4fb9	ff 	. 
	rst 38h			;4fba	ff 	. 
	rst 38h			;4fbb	ff 	. 
	rst 38h			;4fbc	ff 	. 
	rst 38h			;4fbd	ff 	. 
	rst 38h			;4fbe	ff 	. 
	rst 38h			;4fbf	ff 	. 
	rst 38h			;4fc0	ff 	. 
	rst 38h			;4fc1	ff 	. 
	rst 38h			;4fc2	ff 	. 
	rst 38h			;4fc3	ff 	. 
	rst 38h			;4fc4	ff 	. 
	rst 38h			;4fc5	ff 	. 
	rst 38h			;4fc6	ff 	. 
	rst 38h			;4fc7	ff 	. 
	rst 38h			;4fc8	ff 	. 
	rst 38h			;4fc9	ff 	. 
	rst 38h			;4fca	ff 	. 
	rst 38h			;4fcb	ff 	. 
	rst 38h			;4fcc	ff 	. 
	rst 38h			;4fcd	ff 	. 
	rst 38h			;4fce	ff 	. 
	rst 38h			;4fcf	ff 	. 
	rst 38h			;4fd0	ff 	. 
	rst 38h			;4fd1	ff 	. 
	rst 38h			;4fd2	ff 	. 
	rst 38h			;4fd3	ff 	. 
	rst 38h			;4fd4	ff 	. 
	rst 38h			;4fd5	ff 	. 
	rst 38h			;4fd6	ff 	. 
	rst 38h			;4fd7	ff 	. 
	rst 38h			;4fd8	ff 	. 
	rst 38h			;4fd9	ff 	. 
	rst 38h			;4fda	ff 	. 
	rst 38h			;4fdb	ff 	. 
	rst 38h			;4fdc	ff 	. 
	rst 38h			;4fdd	ff 	. 
	rst 38h			;4fde	ff 	. 
	rst 38h			;4fdf	ff 	. 
	rst 38h			;4fe0	ff 	. 
	rst 38h			;4fe1	ff 	. 
	rst 38h			;4fe2	ff 	. 
	rst 38h			;4fe3	ff 	. 
	rst 38h			;4fe4	ff 	. 
	rst 38h			;4fe5	ff 	. 
	rst 38h			;4fe6	ff 	. 
	rst 38h			;4fe7	ff 	. 
	rst 38h			;4fe8	ff 	. 
	rst 38h			;4fe9	ff 	. 
	rst 38h			;4fea	ff 	. 
	rst 38h			;4feb	ff 	. 
	rst 38h			;4fec	ff 	. 
	rst 38h			;4fed	ff 	. 
	rst 38h			;4fee	ff 	. 
	rst 38h			;4fef	ff 	. 
	rst 38h			;4ff0	ff 	. 
	rst 38h			;4ff1	ff 	. 
	rst 38h			;4ff2	ff 	. 
	rst 38h			;4ff3	ff 	. 
	rst 38h			;4ff4	ff 	. 
	rst 38h			;4ff5	ff 	. 
	rst 38h			;4ff6	ff 	. 
	rst 38h			;4ff7	ff 	. 
	rst 38h			;4ff8	ff 	. 
	rst 38h			;4ff9	ff 	. 
	rst 38h			;4ffa	ff 	. 
	rst 38h			;4ffb	ff 	. 
	rst 38h			;4ffc	ff 	. 
	rst 38h			;4ffd	ff 	. 
	rst 38h			;4ffe	ff 	. 
	and a			;4fff	a7 	. 

	end
