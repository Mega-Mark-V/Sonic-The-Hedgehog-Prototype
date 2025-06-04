.pattbl:
	dc.w mole_spr00-.pattbl
	dc.w mole_spr01-.pattbl
	dc.w mole_spr02-.pattbl
	dc.w mole_spr03-.pattbl
	dc.w mole_spr04-.pattbl
	dc.w mole_spr05-.pattbl
	dc.w mole_spr06-.pattbl

mole_spr00:	dc.b   2,$EC, $A,  0,  0,$F0,  4,  9,  0,  9,$F4
mole_spr01:	dc.b   2,$EC, $A,  0, $F,$F0,  4,  9,  0,$18,$F4
mole_spr02:	dc.b   2,$E8, $A,  0,$1E,$F4,  0, $A,  0,$27,$F4
mole_spr03:	dc.b   2,$E8, $A,  0,$30,$F4,  0, $A,  0,$39,$F4
mole_spr04:	dc.b   2,$E8, $A,  0, $F,$F0,  0, $A,  0,$42,$F4
mole_spr05:	dc.b   2,$F4,  6,  0,$4B,$E8,$F4, $A,  0,$51,$F8
mole_spr06:	dc.b   2,$EC, $A,  0, $F,$F0,  4,  9,  0,  9,$F4
		even