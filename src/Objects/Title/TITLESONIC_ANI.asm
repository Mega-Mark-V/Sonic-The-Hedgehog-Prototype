.anitbl
	dc.w tsonic_main-.anitbl

tsonic_main: 
	dc.b	7			; Speed
	dc.b	0, 1, 2, 3, 4, 5, 6, 7	; Script
	dc.b	$FE, 2			; Repeat last 2 frames
	even