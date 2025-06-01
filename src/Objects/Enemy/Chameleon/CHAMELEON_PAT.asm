.pattbl
	dc.w cham_spr00-.pattbl
	dc.w cham_spr01-.pattbl
	dc.w cham_spr02-.pattbl
	dc.w cham_spr03-.pattbl
	dc.w cham_spr04-.pattbl
	dc.w cham_spr05-.pattbl
	dc.w cham_spr06-.pattbl
	dc.w cham_spr07-.pattbl
	dc.w cham_spr08-.pattbl
	dc.w cham_spr09-.pattbl
	dc.w cham_spr0A-.pattbl

cham_spr00:	dc.b	3,$EC, $D,  0,  0,$EC,$F4,  0 
		dc.b	0,  8, $C,$FC, $E,  0,  9,$F4
cham_spr01:	dc.b	3,$EC,  6,  0,$15,$EC,$EC,  9 
		dc.b	0,$1B,$FC,$FC, $A,  0,$21,$FC
cham_spr02:	dc.b	3,$EC,  6,  0,$2A,$EC,$EC,  9 
		dc.b	0,$1B,$FC,$FC, $A,  0,$21,$FC
cham_spr03:	dc.b	4,$EC,  6,  0,$30,$EC,$EC,  9 
		dc.b	0,$1B,$FC,$FC,  9,  0,$36,$FC
		dc.b	$C,  0,  0,$3C, $C
cham_spr04:	dc.b	3,$F4, $D,  0,$3D,$EC,$FC,  0 
		dc.b	0,$20, $C,  4,  8,  0,$45,$FC
cham_spr05:	dc.b	2,$F8, $D,  0,$48,$EC,$F8,  1 
		dc.b	0,$50, $C
cham_spr06:	dc.b	3,$F8, $D,  0,$48,$EC,$F8,  1 
		dc.b	0,$50, $C,$FE,  0,  0,$52,$14
cham_spr07:	dc.b	3,$F8, $D,  0,$48,$EC,$F8,  1 
		dc.b	0,$50, $C,$FE,  4,  0,$53,$14
cham_spr08:	dc.b	3,$F8, $D,  0,$48,$EC,$F8,  1 
		dc.b	0,$50, $C,$FE,  0,$E0,$52,$14
cham_spr09:	dc.b	3,$F8, $D,  0,$48,$EC,$F8,  1 
		dc.b	0,$50, $C,$FE,  4,$E0,$53,$14
cham_spr0A:	dc.w	0 
