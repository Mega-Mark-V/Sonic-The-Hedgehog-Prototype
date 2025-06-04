.anitbl:
	dc.w moleani_idle-.anitbl
	dc.w moleani_move-.anitbl
	dc.w moleani_jump-.anitbl
	dc.w moleani_fall-.anitbl

moleani_idle:	dc.b   3,  0,  6,$FF
moleani_move:	dc.b   3,  0,  1,$FF
moleani_jump:	dc.b   3,  2,  3,$FF
moleani_fall:	dc.b   3,  4,$FF
		even