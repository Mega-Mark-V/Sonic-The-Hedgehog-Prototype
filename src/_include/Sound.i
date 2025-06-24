; ---------------------------------------------------------------------------
; Sound Command IDs
; ---------------------------------------------------------------------------
; Music
; ---------------------------------------------------------------------------

BGMNO_GHZ               EQU	$81
BGMNO_LZ                EQU	$82
BGMNO_MZ                EQU	$83
BGMNO_SLZ               EQU	$84
BGMNO_SZ                EQU	$85
BGMNO_CWZ               EQU	$86
BGMNO_INVINC	        EQU	$87
BGMNO_1UP	        EQU	$88
BGMNO_SPECIAL           EQU	$89
BGMNO_TITLE             EQU	$8A
BGMNO_ENDING            EQU	$8B
BGMNO_BOSS            	EQU	$8C
BGMNO_FINAL           	EQU	$8D
BGMNO_ZONECLR       	EQU	$8E
BGMNO_GAMEOVER        	EQU	$8F
BGMNO_CONTINUE        	EQU	$90
BGMNO_CREDITS       	EQU	$91

; ---------------------------------------------------------------------------
; Sound Effects equates
; ---------------------------------------------------------------------------

SFXNO_JUMP              EQU	$A0
SFXNO_UNK_A1	        EQU	$A1	
SFXNO_UNK_A2	        EQU	$A2	
SFXNO_DAMAGE           	EQU	$A3
SFXNO_SKID:      	EQU	$A4 
SFXNO_BOMBHIT		EQU	$A5
SFXNO_SPIKEDMG          EQU	$A6
SFXNO_PUSHING      	EQU	$A7
SFXNO_WARP      	EQU	$A8
SFXNO_UNK_A9      	EQU	$A9	
SFXNO_SPLASH      	EQU	$AA
SFXNO_UNK_AB      	EQU	$AB	
SFXNO_BOSSHIT      	EQU	$AC
SFXNO_POP1      	EQU	$AD	
SFXNO_FIREBALL          EQU	$AE
SFXNO_GETSHIELD         EQU	$AF
SFXNO_UNK_B0	        EQU	$B0	
SFXNO_UNK_B1	        EQU	$B1	
SFXNO_UNK_B2	        EQU	$B2	
SFXNO_UNK_B3	        EQU	$B3	
SFXNO_BUMPER            EQU	$B4
SFXNO_RING       	EQU	$B5
SFXNO_SPIKES       	EQU	$B6 
SFXNO_RUMBLE		EQU	$B7	
SFXNO_UNK_B8		EQU	$B8	
SFXNO_COLLAPSE1		EQU	$B9
SFXNO_UNK_BA		EQU	$BA	
SFXNO_DOOR		EQU	$BB
SFXNO_LAUNCH		EQU	$BC	
SFXNO_HEAVYHIT		EQU	$BD
SFXNO_SPIN              EQU	$BE
SFXNO_UNK_BF            EQU	$BF
SFXNO_WINGFLAP          EQU	$C0
SFXNO_POP2              EQU	$C1
SFXNO_POP3              EQU	$C2
SFXNO_EXPLODE1          EQU	$C3
SFXNO_EXPLODE2          EQU	$C4
SFXNO_TALLYDONE         EQU	$C5
SFXNO_LOSERINGS         EQU	$C6
SFXNO_CHAINPING         EQU	$C7
SFXNO_FLAME     	EQU	$C8
SFXNO_UNK_C9     	EQU	$C9
SFXNO_UNK_CA     	EQU	$CA
SFXNO_COLLAPSE2         EQU	$CB
SFXNO_SPRING     	EQU	$CC
SFXNO_BUTTON        	EQU	$CD
SFXNO_RINGLEFT        	EQU	$CE
SFXNO_GOAL        	EQU	$CF

; ---------------------------------------------------------------------------
; Sound Command IDs
; ---------------------------------------------------------------------------

SNDCMD_FADE		EQU	$E0
SNDCMD_UNK		EQU	$E1
SNDCMD_FAST		EQU	$E2
SNDCMD_TEMPORES		EQU	$E3

; ---------------------------------------------------------------------------
; Sound RAM allocation
; ---------------------------------------------------------------------------

SOUNDRAM	EQU	$FFFFF000      
		rsset	SOUNDRAM
			rs.b $A   
soundqueue1:		rs.b 1    
soundqueue2:		rs.b 1    
soundqueue3:		rs.b 1    
			rs.b $5F3
