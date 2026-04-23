ObjListTbl:				;	this is the table that defines where to load a level's object position
pcm_top:		equ $756D0	;	this is the Z80 blob for the sound driver, compiled independently until we can link it (needed for final game)
LevelEvents:		equ $4914	;	this is the code that handles events that trigger across the level, often checking the player position
ArtListIndex:		equ $1226A	;	an index for the various art lists
UpdateHUD:		equ $1167A	;	routine that redraws the HUD's dynamic VRAM
AnimatedLevelGFX:	equ $1128C	;	routine handles the animated graphics in levels
sound:			equ $741D2	;	Sound Source, VBLANK routine
GM_LOGO:		equ $2484	;	Sega game mode
GM_TITLE:		equ $254C	;	Title game mode
GM_LEVEL:		equ $2BCE	;	Level game mode
GM_SPECIAL:		equ $34FC	;	Special stage game mode
_specialstgPalCyc:	equ $3730	;	Palette cycle routine for special stage

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
