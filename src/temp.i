ObjListTbl:		;	this is the table that defines where to load a level's object position
pcm_top:		;	this is the Z80 blob for the sound driver, compiled independently until we can link it (needed for final game)
LevelEvents:		;	this is the code that handles events that trigger across the level, often checking the player position
ArtListIndex:		;	an index for the various art lists
UpdateHUD:		;	routine that redraws the HUD's dynamic VRAM
AnimatedLevelGFX:	;	routine handles the animated graphics in levels
sound:			;	Sound Source, VBLANK routine
GMNO_TITLE:		rs.b	0	;	the title screen game mode
GMNO_SPECIAL:		rs.b	0	;	the special stage game mode
_specialstgPalCyc:	rs.b	0	;	

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
