; ---------------------------------------------------------------------------
; Sound Command IDs
; ---------------------------------------------------------------------------
; Music
; ---------------------------------------------------------------------------

; enum 	musID
BGMNO.GHZ               EQU     $81
BGMNO.LZ                EQU     $82
BGMNO.MZ                EQU     $83
BGMNO.SLZ               EQU     $84
BGMNO.SZ                EQU     $85
BGMNO.CWZ               EQU     $86
BGMNO.Invincible        EQU     $87
BGMNO.ExtraLife         EQU     $88
BGMNO.Special           EQU     $89
BGMNO.Title             EQU     $8A
BGMNO.Ending            EQU     $8B
BGMNO.Boss            	EQU     $8C
BGMNO.Final           	EQU     $8D
BGMNO.ZoneClear       	EQU     $8E
BGMNO.GameOver        	EQU     $8F
BGMNO.Continue        	EQU     $90
BGMNO.StaffRoll       	EQU     $91

; ---------------------------------------------------------------------------
; Sound Effects
; ---------------------------------------------------------------------------

; enum	sfxID
SFXNO.Jump              EQU         	$A0
SFXNO.Death             EQU         	$A3
SFXNO.Skid:      	EQU 		$A4 
SFXNO.MissileExplode    EQU         	$A5
SFXNO.Spikes            EQU         	$A6
SFXNO.Shield            EQU         	$AF
SFXNO.Bumper            EQU         	$B4
SFXNO.RingCollect       EQU         	$B5
SFXNO.Spin              EQU         	$BE
SFXNO.Pop               EQU         	$C1

; ---------------------------------------------------------------------------
; Sound Command IDs
; ---------------------------------------------------------------------------

; enum	sndCMD
SNDCMD.Fade             EQU         $E0
SNDCMD.e1               EQU         $E1
SNDCMD.Fast             EQU         $E2
SNDCMD.Slow             EQU         $E3

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
