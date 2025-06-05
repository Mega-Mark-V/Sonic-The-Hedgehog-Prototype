.pattbl:
	dc.w byte_BA16-.pattbl
	dc.w byte_BA2B-.pattbl
	dc.w byte_BA40-.pattbl
	dc.w byte_BA5A-.pattbl
	dc.w byte_BA60-.pattbl
	dc.w byte_BA66-.pattbl
	dc.w byte_BA6C-.pattbl

byte_BA16:	dc.b   4,$F0, $D,  0,  0,$EC,  0, $C
		dc.b   0,  8,$EC,$F8,  1,  0, $C, $C
		dc.b   8,  8,  0, $E,$F4
byte_BA2B:	dc.b   4,$F1, $D,  0,  0,$EC,  1, $C
		dc.b   0,  8,$EC,$F9,  1,  0, $C, $C
		dc.b   9,  8,  0,$11,$F4
byte_BA40:	dc.b   5,$F0, $D,  0,  0,$EC,  0, $C
		dc.b   0,$14,$EC,$F8,  1,  0, $C, $C
		dc.b   8,  4,  0,$18,$EC,  8,  4,  0
		dc.b $12,$FC
byte_BA5A:	dc.b   1,$FA,  0,  0,$1A,$10
byte_BA60:	dc.b   1,$FA,  0,  0,$1B,$10
byte_BA66:	dc.b   1,$FA,  0,  0,$1C,$10
byte_BA6C:	dc.b   0,  0