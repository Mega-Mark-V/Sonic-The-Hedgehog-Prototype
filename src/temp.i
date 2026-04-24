	rsreset
OBJNO_TITLEMISC:	rs.b 0		;	Title screen text (TM, press start, mask)
OBJNO_TITLESONIC:	rs.b 0		;	Title screen Sonic

; ---------------------------------------------------------------------------
; Sound RAM allocation
; ---------------------------------------------------------------------------

sound_ram	EQU	$FFFFF000      
		rsset	0
			rs.b $A   
buf1:			rs.b 1    
buf2:			rs.b 1    
buf3:			rs.b 1    
			rs.b $5F3
