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

sfxID_Jump              EQU         $A0
sfxID_Death             EQU         $A3
sfxID_MissileExplode    EQU         $A5
sfxID_Spikes            EQU         $A6
sfxID_Shield            EQU         $AF
sfxID_Bumper            EQU         $B4
sfxID_RingCollect       EQU         $B5
sfxID_Spin              EQU         $BE
sfxID_Pop               EQU         $C1

sndCMD_Stop             EQU         $E0
sndCMD_e1               EQU         $E1
sndCMD_Fast             EQU         $E2
sndCMD_Slow             EQU         $E3


; ---------------------------------------------------------------------------
; Sound RAM allocation
; ---------------------------------------------------------------------------

SOUNDRAM	EQU	$FFFFF000      
	rsset	SOUNDRAM
			rs.b $A   
soundqueueA:    	rs.b 1    
soundqueueB:    	rs.b 1    
soundqueueC:    	rs.b 1    
                	rs.b $5F3
