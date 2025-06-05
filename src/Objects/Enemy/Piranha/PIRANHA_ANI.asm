.anitbl:
	dc.w	pirachompslow-.anitbl
	dc.w	pirachompfast-.anitbl
	dc.w	pirastopchomp-.anitbl

pirachompslow:	dc.b	7,0,1,$FF
		even
pirachompfast:	dc.b	3,0,1,$FF
		even
pirastopchomp:	dc.b	7,0,$FF
		even