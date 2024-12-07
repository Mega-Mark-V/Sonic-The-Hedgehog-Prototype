; ---------------------------------------------------------------------------
; Sound Command IDs
; ---------------------------------------------------------------------------
; Music
; ---------------------------------------------------------------------------

; enum 	musID
musID.GHZ               EQU     $81
musID.LZ                EQU     $82
musID.MZ                EQU     $83
musID.SLZ               EQU     $84
musID.SZ                EQU     $85
musID.CWZ               EQU     $86
musID.Invincible        EQU     $87
musID.ExtraLife         EQU     $88
musID.Special           EQU     $89
musID.TitleScreen       EQU     $8A
musID.Ending            EQU     $8B
musID.Boss            	EQU     $8C
musID.Final           	EQU     $8D
musID.ZoneClear       	EQU     $8E
musID.GameOver        	EQU     $8F
musID.Continue        	EQU     $90
musID.StaffRoll       	EQU     $91

; ---------------------------------------------------------------------------
; Sound Effects
; ---------------------------------------------------------------------------

; enum	sfxID
sfxID.Jump              EQU         $A0
sfxID.Death             EQU         $A3
sfxID.MissileExplode    EQU         $A5
sfxID.Spikes            EQU         $A6
sfxID.Shield            EQU         $AF
sfxID.Bumper            EQU         $B4
sfxID.RingCollect       EQU         $B5
sfxID.Spin              EQU         $BE
sfxID.Pop               EQU         $C1

; ---------------------------------------------------------------------------
; Sound Command IDs
; ---------------------------------------------------------------------------

; enum	sndCMD
sndCMD.Fade             EQU         $E0
sndCMD.e1               EQU         $E1
sndCMD.Fast             EQU         $E2
sndCMD.Slow             EQU         $E3

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
