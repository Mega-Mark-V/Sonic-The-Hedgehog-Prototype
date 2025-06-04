.pattbl:
	dc.w missileinitsp0-.pattbl   
        dc.w missileinitsp1-.pattbl
	dc.w missilemainsp2-.pattbl
        dc.w missilemainsp3-.pattbl

missileinitsp0:	dc.b   1,$F8,  5,  0,$24,$F8  
missileinitsp1:	dc.b   1,$F8,  5,  0,$28,$F8  
missilemainsp2:	dc.b   1,$F8,  5,  0,$2C,$F8  
missilemainsp3:	dc.b   1,$F8,  5,  0,$33,$F8  