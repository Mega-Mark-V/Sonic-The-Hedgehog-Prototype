.anitbl:
	dc.w byte_B9F0-.anitbl
	dc.w byte_B9F4-.anitbl
	dc.w byte_B9FA-.anitbl

byte_B9F0:	dc.b  $F,  2,$FF,  0
byte_B9F4:	dc.b   7,  0,  1,  0,  2,$FF
byte_B9FA:	dc.b   1,  3,  6,  3,  6,  4,  6,  4
		dc.b   6,  4,  6,  5,$FC
		even