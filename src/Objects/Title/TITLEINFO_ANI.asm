.anitbl
	dc.w pressstart_flash-.anitbl

pressstart_flash: 
	dc.b	31		; Speed
	dc.b	0, 1		; Script
	dc.b	$FF		; Loop
	even