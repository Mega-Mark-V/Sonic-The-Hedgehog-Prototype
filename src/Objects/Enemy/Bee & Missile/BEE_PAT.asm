.pattbl:
	dc.w beetonflysp0-.pattbl     
	dc.w beetonflysp1-.pattbl
	dc.w beetonflysp2-.pattbl
	dc.w beetonflysp3-.pattbl
	dc.w beetonattsp4-.pattbl
	dc.w beetonattsp5-.pattbl

beetonflysp0:   dc.b   6,$F4,  9,  0,  0,$E8,$F4,  9 
		dc.b   0, $F,  0,  4,  8,  0,$15,$E8
		dc.b   4,  4,  0,$18,  0,$F1,  8,  0
		dc.b $1A,$EC,$F1,  4,  0,$1D,  4
beetonflysp1:   dc.b   6,$F4,  9,  0,  0,$E8,$F4,  9 
		dc.b   0, $F,  0,  4,  8,  0,$15,$E8
		dc.b   4,  4,  0,$18,  0,$F4,  8,  0
		dc.b $1F,$EC,$F4,  4,  0,$22,  4
beetonflysp2:   dc.b   7,  4,  0,  0,$30, $C,$F4,  9 
		dc.b   0,  0,$E8,$F4,  9,  0, $F,  0
		dc.b   4,  8,  0,$15,$E8,  4,  4,  0
		dc.b $18,  0,$F1,  8,  0,$1A,$EC,$F1
		dc.b   4,  0,$1D,  4
beetonflysp3:   dc.b   7,  4,  4,  0,$31, $C,$F4,  9 
		dc.b   0,  0,$E8,$F4,  9,  0, $F,  0
		dc.b   4,  8,  0,$15,$E8,  4,  4,  0
		dc.b $18,  0,$F4,  8,  0,$1F,$EC,$F4
		dc.b   4,  0,$22,  4
beetonattsp4:   dc.b   6,$F4, $D,  0,  0,$EC,  4, $C 
		dc.b   0,  8,$EC,  4,  0,  0, $C, $C
		dc.b  $C,  4,  0, $D,$F4,$F1,  8,  0
		dc.b $1A,$EC,$F1,  4,  0,$1D,  4
beetonattsp5:   dc.b   4,$F4, $D,  0,  0,$EC,  4, $C 
		dc.b   0,  8,$EC,  4,  0,  0, $C, $C
		dc.b  $C,  4,  0, $D,$F4,$F4,  8,  0
		dc.b $1F,$EC,$F4,  4,  0,$22,  4