; ---------------------------------------------------------------------------
; Sound Command IDs
; ---------------------------------------------------------------------------
; Music

musID_GHZ               EQU     $81
musID_LZ                EQU     $82
musID_MZ                EQU     $83
musID_SLZ               EQU     $84
musID_SZ                EQU     $85
musID_CWZ               EQU     $86
musID_Invincible        EQU     $87
musID_ExtraLife         EQU     $88
musID_Special           EQU     $89
musID_TitleScreen       EQU     $8A
musID_Ending            EQU     $8B
musID_Boss            	EQU     $8C
musID_Final           	EQU     $8D
musID_ZoneClear       	EQU     $8E
musID_GameOver        	EQU     $8F
musID_Continue        	EQU     $90
musID_StaffRoll       	EQU     $91

; ---------------------------------------------------------------------------
; Sound RAM allocation
; ---------------------------------------------------------------------------

SOUNDRAM	EQU	$FFF000      
	rsset	SOUNDRAM
			rs.b $A   
soundqueueA:    	rs.b 1    
soundqueueB:    	rs.b 1    
soundqueueC:    	rs.b 1    
                	rs.b $5F3
