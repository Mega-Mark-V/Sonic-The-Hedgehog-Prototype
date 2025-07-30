.tbl:  	
	dc.w spring_pat00-.tbl
	dc.w spring_pat01-.tbl
	dc.w spring_pat02-.tbl
	dc.w spring_pat03-.tbl
	dc.w spring_pat04-.tbl
	dc.w spring_pat05-.tbl

spring_pat00:
	dc.b	2,$F8, $C,  0,  0,$F0,  0, $C
	dc.b	0,  4,$F0
spring_pat01:   
	dc.b	1,  0, $C,  0,  0,$F0
spring_pat02:   
	dc.b	3,$E8, $C,  0,  0,$F0,$F0,  5
	dc.b	0,  8,$F8,  0, $C,  0, $C,$F0
spring_pat03:
	dc.b   1,$F0,  7,  0,  0,$F8
spring_pat04:
	dc.b   1,$F0,  3,  0,  4,$F8
spring_pat05:
	dc.b   4,$F0,  3,  0,  4,$10,$F8,  9
	dc.b   0,  8,$F8,$F0,  0,  0,  0,$F8
	dc.b   8,  0,  0,  3,$F8