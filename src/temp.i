ObjListTbl:				;	this is the table that defines where to load a level's object position
LevelEvents:		equ $4914	;	this is the code that handles events that trigger across the level, often checking the player position
ArtListIndex:		equ $1226A	;	an index for the various art lists
UpdateHUD:		equ $1167A	;	routine that redraws the HUD's dynamic VRAM
AnimatedLevelGFX:	equ $1128C	;	routine handles the animated graphics in levels
GM_LEVEL:		equ $2BCE	;	Level game mode
GM_SPECIAL:		equ $34FC	;	Special stage game mode
_specialstgPalCyc:	equ $3730	;	Palette cycle routine for special stage
InitZoneLayout:		equ $48BA	;	Loads chunk layout into RAM
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
