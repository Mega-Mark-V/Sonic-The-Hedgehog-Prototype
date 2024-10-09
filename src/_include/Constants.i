; ---------------------------------------------------------------------------
; Basic system memory location equates
; ---------------------------------------------------------------------------

musID_GHZ                         EQU         $81
musID_LZ                          EQU         $82
musID_MZ                          EQU         $83
musID_SLZ                         EQU         $84
musID_SZ                          EQU         $85
musID_CWZ                         EQU         $86
musID_Invincible          EQU         $87
musID_ExtraLife           EQU         $88
musID_Special                 EQU         $89
musID_TitleScreen         EQU         $8A
musID_Ending                  EQU         $8B
musID_Boss                        EQU         $8C
musID_Final                   EQU         $8D
musID_ZoneClear           EQU         $8E
musID_GameOver                EQU         $8F
musID_Continue                EQU         $90
musID_StaffRoll           EQU         $91

sfxID_Jump                        EQU         $A0
sfxID_Death                   EQU         $A3
sfxID_MissileExplode  EQU         $A5
sfxID_Spikes                  EQU         $A6
sfxID_Shield                  EQU         $AF
sfxID_Bumper                  EQU         $B4
sfxID_RingCollect         EQU         $B5
sfxID_Spin                        EQU         $BE
sfxID_Pop                         EQU         $C1
sndCMD_Stop                   EQU         $E0
sndCMD_e1                         EQU         $E1
sndCMD_Fast                   EQU         $E2
sndCMD_Slow                   EQU         $E3

errorBus                          EQU         $2
errorIllegal                  EQU         $4
errorAddress                  EQU         $6
errorZeroDiv                  EQU         $8
errorChkInst                  EQU         $A
errorTrapV                        EQU         $C
errorPrivilege                EQU         $E
errorTrace                        EQU         $10
errorLineA                        EQU         $12
errorLineF                        EQU         $14

vbID_Invalid                  EQU         $0
vbID_SEGAScreen           EQU         $2
vbID_TitleScr                 EQU         $4
vbID_Level                        EQU         $8
vbID_SpecialStg           EQU         $A
vbID_PalFunctions         EQU         $12
gmID_LOGO                         EQU         $0
gmID_TITLE                        EQU         $4
gmID_DEMO                         EQU         $8
gmID_LEVEL                        EQU         $C
gmID_SPECIAL                  EQU         $10

act1                                  EQU         $0
act2                                  EQU         $1
act3                                  EQU         $2
act4                                  EQU         $3

zoneID_GHZ                        EQU         $0
zoneID_LZ                         EQU         $1
zoneID_MZ                         EQU         $2
zoneID_SLZ                        EQU         $3
zoneID_SZ                         EQU         $4
zoneID_CWZ                        EQU         $5
zoneID_Unk                        EQU         $6


artID_EggmanBoss          EQU         $11
artID_LevelEnd                EQU         $12

_1      EQU         $1
_2      EQU         $2
_3      EQU         $3
_4	EQU	    $4
_5	EQU	    $5
_6	EQU	    $6
_7	EQU	    $7
_8	EQU	    $8
_9	EQU	    $9
_symHex	EQU	    $A
_symDas	EQU	    $B
_symEqu	EQU	    $C
_symPt1 EQU	    $D
_symPt2 EQU	    $E
_Y      EQU         $F
_Z      EQU         $10
_A      EQU         $11
_B      EQU         $12
_C      EQU         $13
_D      EQU         $14
_E      EQU         $15
_F      EQU         $16
_G      EQU         $17
_H      EQU         $18
_I      EQU         $19
_J      EQU         $1A
_K      EQU         $1B
_L      EQU         $1C
_M      EQU         $1D
_N      EQU         $1E
_O      EQU         $1F
_P      EQU         $20
_Q      EQU         $21
_R      EQU         $22
_S      EQU         $23
_T      EQU         $24
_U      EQU         $25
_V      EQU         $26
_W      EQU         $27
_X      EQU         $28
__      EQU         $FF

objID_Null                          EQU         $0
objID_Sonic                         EQU         $1
objID_ProjectileBall        EQU         $20
objID_SmallExplosion        EQU         $24
objID_LightExplosion        EQU         $27
objID_TitleCard                 EQU         $34
PAL_MODE                                EQU         $0
DMA_IN_PROGRESS                 EQU         $1
HBLANKING                           EQU         $2
VBLANKING                           EQU         $3
ODD_FRAME                           EQU         $4
SPRITE_COLLISION                EQU         $5
SPRITE_OVERFLOW                 EQU         $6
VBLANK_PENDING                  EQU         $7
FIFO_FULL                           EQU         $8
FIFO_EMPTY                          EQU         $9
VRAMREAD                                EQU         $0
VSRAMREAD                           EQU         $10
CRAMREAD                                EQU         $20
VRAMCOPY                                EQU         $C0
VRAMWRITE                           EQU         $40000000
VSRAMWRITE                          EQU         $40000010
VRAMDMA                                 EQU         $40000080
VSRAMDMA                                EQU         $40000090
CRAMWRITE                           EQU         $C0000000
CRAMDMA                                 EQU         $C0000080
HBLANK_VBLANK_ENABLE        EQU         $2300


