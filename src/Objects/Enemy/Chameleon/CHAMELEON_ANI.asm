.anitbl:
	dc.w chamani_invis-.anitbl
	dc.w chamani_emerg-.anitbl
	dc.w chamani_misl1-.anitbl
	dc.w chamani_misl2-.anitbl
	dc.w chamani_shoot-.anitbl

chamani_invis:	dc.b $F,$A,$FF,0
chamani_emerg:	dc.b $13,0,1,3,4,5,$FE,1
chamani_misl1:	dc.b 2,6,7,$FF
chamani_misl2:	dc.b 2,8,9,$FF
chamani_shoot:	dc.b $13,0,1,1,2,1,1,0,$FC,0 
