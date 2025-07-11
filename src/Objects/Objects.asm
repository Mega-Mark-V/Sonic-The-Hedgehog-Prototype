; ---------------------------------------------------------------------------
; Main Objects handling and function libraries
; ---------------------------------------------------------------------------
; enums
OBJ_GRAVITY = 56	; Gravity delta

; ---------------------------------------------------------------------------
; Standard object struct (Known by patented-name "Action Status Table")
; ---------------------------------------------------------------------------

obj             struct
No:		dc.b 1
Render:		dc.b 1
Tile:		dc.w 1
Pat:		dc.l 1
X:		dc.w 1
YScr:		dc.w 1
Y:		dc.w 1
YSub:		dc.w 1
XSpeed:		dc.w 1
YSpeed:		dc.w 1
Momentum:	dc.w 1
YRad:		dc.b 1
XRad:		dc.b 1
XRender:	dc.b 1
Priority:	dc.b 1
Frame:		dc.b 1
AnimFrame: 	dc.b 1
Anim:		dc.b 1
LastAnim:	dc.b 1
FrameTimer:	dc.b 1
FrameMirr:	dc.b 1
Collision:	dc.b 1
ColliCnt:	dc.b 1
Status:		dc.b 1
Respawn:	dc.b 1
Action:		dc.b 1
SubAction:	dc.b 1
Angle:		dc.w 1
Args:		dc.b 1
		ends

; "Normal" object status bitfield

STAT.XDIR	= 0
STAT.YDIR	= 1
STAT.UNK2	= 2
STAT.LIFTING	= 3 
STAT.UNK4	= 4
STAT.PUSHED	= 5 
STAT.UNK6	= 6
STAT.KILLED	= 7

; "Physics" object status bitfield

PHYS.DIR	= 0
PHYS.AIRBORNE	= 1
PHYS.ROLLING	= 2
PHYS.LIFTED	= 3
PHYS.ROLLJUMP	= 4
PHYS.PUSH	= 5
PHYS.WATER	= 6
PHYS.KILLED	= 7

; Object rendering bitfield

REND.XMIRR	= 0
REND.YMIRR	= 1
REND.CAMOFF	= 2
REND.CAMOFF2	= 3
REND.HEIGHT	= 4
REND.RAW	= 5
REND.BEHIND	= 6
REND.TOGGLE	= 7

; ---------------------------------------------------------------------------
; Function to run all objects loaded into memory
; ---------------------------------------------------------------------------

RunObjects: 
	lea	OBJECTRAM.w,a0	; Object memory starting location
	moveq	#128-1,d7
	moveq	#0,d0
	cmpi.b	#6,objSlot00	; Sonic routine counter
	bcc.s	.Paused

.RunObjLoop:
	move.b	obj.No(a0),d0	; Check object number
	beq.s	.EmptySlot	; If empty, skip over it
	add.w	d0,d0
	add.w	d0,d0
	movea.l	ObjectIndex-4(pc,d0.w),a1 ; No zero offset - start at 1
	jsr	(a1)		; Jump to object's code

	moveq   #0,d0

.EmptySlot:
	lea	OBJSZ(a0),a0	; Move forward to next object slot in RAM
	dbf	d7,.RunObjLoop
	rts

.Paused:
	moveq	#32-1,d7
	bsr.s	.RunObjLoop
	moveq	#96-1,d7

.PauseObjLoop:  
	moveq	#0,d0
	move.b	obj.No(a0),d0
	beq.s	.SkipDisplay
	tst.b	obj.Render(a0)
	bpl.s	.SkipDisplay
	bsr.w	_objectDraw	; Only display sprites while paused

.SkipDisplay:
	lea	OBJSZ(a0),a0
	dbf	d7,.PauseObjLoop
	rts

; ---------------------------------------------------------------------------
; Macro to create ids from objects
OBJDEF	macro	addr, id
	dc.l	\addr
\id	rs.b	1
	endm
; ---------------------------------------------------------------------------
; Main object list
; Objects are not listed in any particular order, here and in the ROM
; ---------------------------------------------------------------------------

ObjectIndex:
	rsreset
	rs.b	1	; No 0 index

	OBJDEF	ObjPlayer,			OBJNO_PLAYER
	OBJDEF	ObjDev1,			OBJNO_DEV1
	OBJDEF	ObjDev2,			OBJNO_DEV2
	OBJDEF	ObjDev3,			OBJNO_DEV3
	OBJDEF	ObjDev4,			OBJNO_DEV4
	OBJDEF	ObjDev5,			OBJNO_DEV5
	OBJDEF	ObjDev6,			OBJNO_DEV6
	OBJDEF	.Null
	OBJDEF	ObjPlayerSpecial,		OBJNO_PLAYSPECIAL
	OBJDEF	.Null
	OBJDEF	.Null
	OBJDEF	.Null
	OBJDEF	ObjGoal,			OBJNO_GOAL
	OBJDEF	ObjTitleSonic,			OBJNO_TITLESONIC
	OBJDEF	ObjTitleMisc,			OBJNO_TITLEMISC
	OBJDEF	ObjPlayerTest,			OBJNO_PLAYTEST
	OBJDEF	ObjBridge,			OBJNO_BRIDGE
	OBJDEF	ObjSceneryLamp,			OBJNO_SCENERYLAMP
	OBJDEF	ObjFireShooter,			OBJNO_FIRESHOOTER
	OBJDEF	ObjFireBall,			OBJNO_FIREBALL
	OBJDEF	ObjSwingPlatform,		OBJNO_SWINGPLAT
	OBJDEF	.Null
	OBJDEF	ObjSpikeBridge,			OBJNO_SPIKEBRIDGE
	OBJDEF	ObjPlatform,			OBJNO_PLATFORM
	OBJDEF	ObjRollingBall,			OBJNO_ROLLINGBALL
	OBJDEF	ObjCollapsingLedge,		OBJNO_COLLAPSLEDGE
	OBJDEF	ObjUnkPlatform,			OBJNO_UNKPLATFORM
	OBJDEF	ObjLevelScenery,		OBJNO_LVLSCENERY
	OBJDEF	ObjHiddenSwitch,		OBJNO_HIDDENSWITCH
	OBJDEF	ObjEnemyPig,			OBJNO_ENEMYPIG
	OBJDEF	ObjEnemyCrab,			OBJNO_ENEMYCRAB
	OBJDEF	ObjBallBomb,			OBJNO_BALLBOMB
	OBJDEF	ObjHUD,				OBJNO_HUD
	OBJDEF	ObjEnemyBee,			OBJNO_ENEMYBEE
	OBJDEF	ObjMissile,			OBJNO_MISSILE
	OBJDEF	ObjBombHit,			OBJNO_BOMBHIT
	OBJDEF	ObjRing,			OBJNO_RING
	OBJDEF	ObjMonitor,			OBJNO_MONITOR
	OBJDEF	ObjLightExpl,			OBJNO_LIGHTEXPL
	OBJDEF	ObjFriends,			OBJNO_FRIENDS
	OBJDEF	ObjPoints,			OBJNO_POINTS
	OBJDEF	ObjTunnelDoor,			OBJNO_TUNNELDOOR
	OBJDEF	ObjEnemyPirahna,		OBJNO_ENEMYPIRAHNA
	OBJDEF	ObjEnemyShark,			OBJNO_ENEMYSHARK
	OBJDEF	ObjEnemyMole,			OBJNO_ENEMYMOLE
	OBJDEF	ObjMonitorItem,			OBJNO_MONITORITEM
	OBJDEF	ObjShiftingFloor,		OBJNO_SHIFTFLOOR
	OBJDEF	ObjGlassBlock,			OBJNO_GLASSBLOCK
	OBJDEF	ObjSpikeCrusherV,		OBJNO_SPIKECRUSHV
	OBJDEF	ObjButton,			OBJNO_BUTTON
	OBJDEF	ObjPushable,			OBJNO_PUSHABLE
	OBJDEF	ObjTitleCards,			OBJNO_TITLECARD
	OBJDEF	ObjSpreadingFire,		OBJNO_SPREADFIRE
	OBJDEF	ObjSpikes,			OBJNO_SPIKES
	OBJDEF	ObjRingLoss,			OBJNO_RINGLOSS
	OBJDEF	ObjShield,			OBJNO_SHIELD
	OBJDEF	ObjGameOver,			OBJNO_GAMEOVER
	OBJDEF	ObjActClear,			OBJNO_ACTCLEAR
	OBJDEF	ObjRock,			OBJNO_ROCK
	OBJDEF	ObjBreakable,			OBJNO_BREAKABLE
	OBJDEF	ObjBoss,			OBJNO_BOSS
	OBJDEF	ObjEggCapsule,			OBJNO_EGGCAPSULE
	OBJDEF	ObjHeavyExpl,			OBJNO_HEAVYEXPL
	OBJDEF	ObjEnemyBug,			OBJNO_ENEMYBUG
	OBJDEF	ObjSpring,			OBJNO_SPRING
	OBJDEF	ObjEnemyChameleon,		OBJNO_ENEMYCHAMELEON
	OBJDEF	ObjEnemyArmadillo,		OBJNO_ENEMYARMADILLO
	OBJDEF	ObjEdgeWalls,			OBJNO_EDGEWALLS
	OBJDEF	ObjSpikeCrusherH,		OBJNO_SPIKECRUSHH
	OBJDEF	ObjBlock,			OBJNO_BLOCK
	OBJDEF	ObjBumper,			OBJNO_BUMPER
	OBJDEF	ObjBossWeapons,			OBJNO_BOSSWEAPONS
	OBJDEF	ObjWaterfallSFX,		OBJNO_WTRFALLSFX
	OBJDEF	ObjWarp,			OBJNO_WARP
	OBJDEF	ObjBigRing,			OBJNO_BIGRING
	OBJDEF	ObjGeyserSpawn,			OBJNO_GEYSERSPAWN
	OBJDEF	ObjGeyser,			OBJNO_GEYSER
	OBJDEF	ObjLavaChase,			OBJNO_LAVACHASE
	OBJDEF	ObjEnemyRabbit,			OBJNO_ENEMYRABBIT
	OBJDEF	ObjEnemyHermit,			OBJNO_ENEMYHERMIT
	OBJDEF	ObjSmashBlock,			OBJNO_SMASHBLOCK
	OBJDEF	ObjMovingPlatform,		OBJNO_MOVINGPLAT
	OBJDEF	ObjCollapsingFloor,		OBJNO_COLLAPSFLOOR
	OBJDEF	ObjDamageTag,			OBJNO_DAMAGETAG
	OBJDEF	ObjEnemyBat,			OBJNO_ENEMYBAT
	OBJDEF	ObjBobbingBlocks,		OBJNO_BOBBLOCK
	OBJDEF	ObjSpikeBall,			OBJNO_SPIKEBALL
	OBJDEF	ObjBigSpikedBall,		OBJNO_BIGSPIKEBALL
	OBJDEF	ObjAdvPlatform,			OBJNO_ADVPLATFORM
	OBJDEF	ObjCirclingGirder,		OBJNO_CIRCLEGIRDER
	OBJDEF	ObjStairBlocks,			OBJNO_STAIRBLOCKS
	OBJDEF	ObjGirder,			OBJNO_GIRDER
	OBJDEF	ObjFan,				OBJNO_FAN
	OBJDEF	ObjSeeSaw,			OBJNO_SEESAW
.Null:

; ---------------------------------------------------------------------------
; Object function to make an object move and fall using its X and Y speeds
; ---------------------------------------------------------------------------

_objectFall:
	move.l  obj.X(a0),d2
	move.l  obj.Y(a0),d3
	move.w  obj.XSpeed(a0),d0
	ext.l   d0
	asl.l   #8,d0
	add.l   d0,d2
	move.w  obj.YSpeed(a0),d0
	addi.w  #OBJ_GRAVITY,d0
	move.w  d0,obj.YSpeed(a0)
	ext.l   d0
	asl.l   #8,d0
	add.l   d0,d3
	move.l  d2,obj.X(a0)
	move.l  d3,obj.Y(a0)
	rts

; ---------------------------------------------------------------------------
; Object function to make an object only move using its X and Y speeds
; ---------------------------------------------------------------------------

_objectSetSpeed:
	move.l  obj.X(a0),d2
	move.l  obj.Y(a0),d3
	move.w  obj.XSpeed(a0),d0
	ext.l   d0
	asl.l   #8,d0
	add.l   d0,d2
	move.w  obj.YSpeed(a0),d0
	ext.l   d0
	asl.l   #8,d0
	add.l   d0,d3
	move.l  d2,obj.X(a0)
	move.l  d3,obj.Y(a0)
	rts

; ---------------------------------------------------------------------------
; Function to queue an object for rendering
; ---------------------------------------------------------------------------

_objectDraw:
	lea     objDrawQueue.w,a1    
	move.b  obj.Priority(a0),d0     ; Get object priority
	andi.w  #7,d0                   ; Clamp to 7
	lsl.w   #7,d0                   ; Shift low byte into high byte

	adda.w  d0,a1                   ; Jump to priority level in queue
	cmpi.w  #$7E,(a1)               ; If it's full, exit
	bhs.s   .Exit

	addq.w  #2,(a1)                 ; Increment object draw count
	adda.w  (a1),a1                 ; Jump to free slot 
	move.w  a0,(a1)                 ; Store object's memory location

.Exit:     
	rts


; ---------------------------------------------------------------------------
; Function to queue an object's child (or obj(a1)) for rendering 
; ---------------------------------------------------------------------------

_objectDrawChild: 
	lea     objDrawQueue.w,a2
	move.b  obj.Priority(a1),d0
	andi.w  #7,d0
	lsl.w   #7,d0
	adda.w  d0,a2
	cmpi.w  #$7E,(a2)
	bhs.s   .Exit
	addq.w  #2,(a2)
	adda.w  (a2),a2
	move.w  a1,(a2)

.Exit:     
	rts

; ---------------------------------------------------------------------------
; Clear/Deallocate an object's memory space
; ---------------------------------------------------------------------------

_objectDelete:   
	movea.l a0,a1

.Child:
	moveq   #0,d1
	moveq   #(OBJSZ/4)-1,d0

.Loop:     
	move.l  d1,(a1)+
	dbf     d0,.Loop
	rts

; ---------------------------------------------------------------------------
; Main routine to draw all sprites in the sprite draw queue
;
; The draw queue in memory is split into priority sections of 128 bytes
; The higher the obj.Priority value, the higher its draw priority
;
; Each section has a word-sized sprite counter at its start addr.
; Then there are 63 word entries as memory addrs. for the objs. to draw 
; ---------------------------------------------------------------------------

RenderCams:    
	dc.l 0                  ; Camera no. 0 (unset)
	dc.l cameraAPosX        ; Camera no. 1 
	dc.l cameraBPosX        ; Camera no. 2 
	dc.l cameraZPosX        ; Camera no. 3

; ---------------------------------------------------------------------------

DrawObjects:
	lea     sprites.w,a2            ; Set VDP sprite table buffer = a2 
	moveq   #0,d5
	lea     objDrawQueue.w,a4       ; Set draw queue = a4

	moveq   #8-1,d7                 ; Set 8 priority level loops

.DrawPriorityLvl: 
	tst.w   (a4)
	beq.w   .NextPriorityLvl
	moveq   #2,d6

.ObjLoop:   
	movea.w (a4,d6.w),a0            ; Get object address
	tst.b   obj.No(a0)
	beq.w   .SkipObject

	bclr    #REND.TOGGLE,obj.Render(a0)   ; Clear draw toggle 

	move.b  obj.Render(a0),d0       ; Get render info
	move.b  d0,d4                   ; Save to d4 for later

	andi.w  #%1100,d0               ; Mask to only camera num
	beq.s   .DrawFixed              ; If not given, draw as fixed onscr. 

; ---- Drawing relative to camera 

	movea.l RenderCams(pc,d0.w),a1  ; Otherwise, get camera number
	moveq   #0,d0
	move.b  obj.XRender(a0),d0        ; obj.XRender = d0
	move.w  obj.X(a0),d3            ; obj.X     = d3

	sub.w   (a1),d3         ; Subtract for pos. relative to cam.

	move.w  d3,d1           ; Get relative pos. to d1
	add.w   d0,d1           ; Adjust X draw rad. right
	bmi.w   .SkipObject     ; Skip drawing if off left side of screen

	move.w  d3,d1           ; Get relative pos. to d1           
	sub.w   d0,d1           ; Adjust X draw rad. left
	cmpi.w  #320,d1         ; Skip drawing if off right side of screen
	bge.s   .SkipObject

	addi.w  #128,d3         ; Adjust for VDP sprite position

	btst    #REND.HEIGHT,d4 ; If not using user's height, 
	beq.s   .AssumeHeight   ; assume a generic height

; ---- Draw with user height (obj.YRad)

	moveq   #0,d0
	move.b  obj.YRad(a0),d0
	move.w  obj.Y(a0),d2
	sub.w   4(a1),d2
	move.w  d2,d1
	add.w   d0,d1
	bmi.s   .SkipObject
	move.w  d2,d1
	sub.w   d0,d1
	cmpi.w  #$E0,d1
	bge.s   .SkipObject
	addi.w  #$80,d2
	bra.s   .DrawObject

; ---- Drawing to fixed screen position

.DrawFixed:
	move.w  obj.YScr(a0),d2 ; Use obj.YScr and obj.X
	move.w  obj.X(a0),d3
	bra.s   .DrawObject

; ---- Draw with generic user height value

.AssumeHeight:  
	move.w  obj.Y(a0),d2
	sub.w   4(a1),d2
	addi.w  #128,d2
	cmpi.w  #96,d2
	bcs.s   .SkipObject
	cmpi.w  #384,d2
	bcc.s   .SkipObject

; ---- Actually draw each object

.DrawObject:    
	movea.l obj.Pat(a0),a1     ; Get sprite map addr. 
	moveq   #0,d1
	btst    #REND.RAW,d4       ; Skip ahead if this is raw format
	bne.s   .RawSprite

	move.b  obj.Frame(a0),d1   ; Index map tbl. with frame no.
	add.b   d1,d1
	adda.w  (a1,d1.w),a1 
	move.b  (a1)+,d1           ; Get mappings entry sprite count
	subq.b  #1,d1              ; Subtract 1 for dbf
	bmi.s   .SkipDraw          ; Skip draw if no sprite pieces 

.RawSprite:
	bsr.w   _spriteBuildToBuffer    ; Go to actually draw to buffer

.SkipDraw:    
	bset    #REND.TOGGLE,obj.Render(a0)

.SkipObject:    
	addq.w  #2,d6
	subq.w  #2,(a4)
	bne.w   .ObjLoop

.NextPriorityLvl:
	lea     128(a4),a4          ; Shift forward to next priority tbl.
	dbf     d7,.DrawPriorityLvl ; Loop for no. of tables

	move.b  d5,spriteCount.w    ; Report the total number of sprites
	cmpi.b  #80,d5              ; Has it reached a max of 80 sprites?
	beq.s   .LimitReached       ; If so, exit
	move.l  #0,(a2)
	rts

.LimitReached:  
	move.b  #0,-5(a2)
	rts


; ---------------------------------------------------------------------------
; Draw sprite information using inputs from a0 (objects)
; ---------------------------------------------------------------------------

_spriteBuildToBuffer:
	movea.w obj.Tile(a0),a3
	btst    #0,d4
	bne.s   _spriteBuildXFlip
	btst    #1,d4
	bne.w   _spriteBuildYFlip

_spriteBuild:    
	cmpi.b  #80,d5
	beq.s   .LimitReached
	move.b  (a1)+,d0
	ext.w   d0
	add.w   d2,d0
	move.w  d0,(a2)+
	move.b  (a1)+,(a2)+
	addq.b  #1,d5
	move.b  d5,(a2)+
	move.b  (a1)+,d0
	lsl.w   #8,d0
	move.b  (a1)+,d0
	add.w   a3,d0
	move.w  d0,(a2)+
	move.b  (a1)+,d0
	ext.w   d0
	add.w   d3,d0
	andi.w  #$1FF,d0
	bne.s   .WriteX
	addq.w  #1,d0

.WriteX:   
	move.w  d0,(a2)+
	dbf     d1,_spriteBuild

.LimitReached:  
	rts

_spriteBuildXFlip:
	btst    #1,d4
	bne.w   _spriteBuildXYFlip

.Loop:     
	cmpi.b  #80,d5
	beq.s   .LimitReached
	move.b  (a1)+,d0
	ext.w   d0
	add.w   d2,d0
	move.w  d0,(a2)+
	move.b  (a1)+,d4
	move.b  d4,(a2)+
	addq.b  #1,d5
	move.b  d5,(a2)+
	move.b  (a1)+,d0
	lsl.w   #8,d0
	move.b  (a1)+,d0
	add.w   a3,d0
	eori.w  #$800,d0
	move.w  d0,(a2)+
	move.b  (a1)+,d0
	ext.w   d0
	neg.w   d0
	add.b   d4,d4
	andi.w  #$18,d4
	addq.w  #8,d4
	sub.w   d4,d0
	add.w   d3,d0
	andi.w  #$1FF,d0
	bne.s   .WriteX
	addq.w  #1,d0

.WriteX:   
	move.w  d0,(a2)+
	dbf     d1,.Loop

.LimitReached:  
	rts

_spriteBuildYFlip:
	cmpi.b  #80,d5
	beq.s   .LimitReached
	move.b  (a1)+,d0
	move.b  (a1),d4
	ext.w   d0
	neg.w   d0
	lsl.b   #3,d4
	andi.w  #$18,d4
	addq.w  #8,d4
	sub.w   d4,d0
	add.w   d2,d0
	move.w  d0,(a2)+
	move.b  (a1)+,(a2)+
	addq.b  #1,d5
	move.b  d5,(a2)+
	move.b  (a1)+,d0
	lsl.w   #8,d0
	move.b  (a1)+,d0
	add.w   a3,d0
	eori.w  #$1000,d0
	move.w  d0,(a2)+
	move.b  (a1)+,d0
	ext.w   d0
	add.w   d3,d0
	andi.w  #$1FF,d0
	bne.s   .WriteX
	addq.w  #1,d0

.WriteX:   
	move.w  d0,(a2)+
	dbf     d1,_spriteBuildYFlip

.LimitReached:  
	rts

_spriteBuildXYFlip:
	cmpi.b  #80,d5
	beq.s   .LimitReached
	move.b  (a1)+,d0
	move.b  (a1),d4
	ext.w   d0
	neg.w   d0
	lsl.b   #3,d4
	andi.w  #$18,d4
	addq.w  #8,d4
	sub.w   d4,d0
	add.w   d2,d0
	move.w  d0,(a2)+
	move.b  (a1)+,d4
	move.b  d4,(a2)+
	addq.b  #1,d5
	move.b  d5,(a2)+
	move.b  (a1)+,d0
	lsl.w   #8,d0
	move.b  (a1)+,d0
	add.w   a3,d0
	eori.w  #$1800,d0
	move.w  d0,(a2)+
	move.b  (a1)+,d0
	ext.w   d0
	neg.w   d0
	add.b   d4,d4
	andi.w  #$18,d4
	addq.w  #8,d4
	sub.w   d4,d0
	add.w   d3,d0
	andi.w  #$1FF,d0
	bne.s   .WriteX
	addq.w  #1,d0

.WriteX:   
	move.w  d0,(a2)+
	dbf     d1,_spriteBuildXYFlip

.LimitReached:  
	rts


; ---------------------------------------------------------------------------
; Function to check if an object is offscreen (relative to camera A)
; ---------------------------------------------------------------------------

_objectChkOnscreen:
	move.w  obj.X(a0),d0
	sub.w   cameraAPosX.w,d0
	bmi.s   .Offscreen
	cmpi.w  #320,d0
	bge.s   .Offscreen
	move.w  obj.Y(a0),d1
	sub.w   cameraAPosY.w,d1
	bmi.s   .Offscreen
	cmpi.w  #224,d1
	bge.s   .Offscreen
	moveq   #0,d0
	rts

.Offscreen:
	moveq   #1,d0
	rts


; ---------------------------------------------------------------------------
; Main object layout handler
; Reads an object layout list during active gameplay and allocates memory
; for each object as it is read. 
; ---------------------------------------------------------------------------

OBJENTRSZ       EQU  6

objentr         struct
X:              dc.w 1
Y:              dc.w 1
ID:             dc.b 1
Arg:            dc.b 1
		ends

; ---------------------------------------------------------------------------

GetObjects: 
	moveq   #0,d0
	move.b  getobjsMode.w,d0
	move.w  .Index(pc,d0.w),d0
	jmp     .Index(pc,d0.w)

; ---------------------------------------------------------------------------

.Index:    
	dc.w GetObjects_Init-.Index
	dc.w GetObjects_Main-.Index

; ---------------------------------------------------------------------------

GetObjects_Init: 
	addq.b  #2,getobjsMode.w

	move.w  zone.w,d0               ; Get current zone objtbls
	lsl.b   #6,d0
	lsr.w   #4,d0
	lea     ObjPosIndex,a0
	movea.l a0,a1

	adda.w  (a0,d0.w),a0            ; Store index tables 'A' (main)
	move.l  a0,objtblEntrRight.w
	move.l  a0,objtblEntrLeft.w

	adda.w  2(a1,d0.w),a1           ; Store index tables 'Z'
	move.l  a1,objtblEntrRightZ.w  
	move.l  a1,objtblEntrLeftZ.w

	lea     objectStates.w,a2       ; Reset object states
	move.w  #$101,(a2)+
	move.w  #$5F-1,d0

.ClearStates:   
	clr.l   (a2)+
	dbf     d0,.ClearStates
	
	move.w  #-1,camAChunkX.w

; ---------------------------------------------------------------------------

GetObjects_Main: 
	lea     objectStates.w,a2
	moveq   #0,d2
	move.w  cameraAPosX.w,d6        ; Get Cam A X position
	andi.w  #$FF80,d6               ; Shorten to multiples of 128
	cmp.w   camAChunkX.w,d6      ; Check against chunk value
	beq.w   _getobjExit             ; Exit if within same chunk 
	bge.s   _getobjRight            ; Get rightward if from chunk ahead  

; ---------------------------------------------------------------------------
; Get and spawn objects for leftwards camera movement 
; ---------------------------------------------------------------------------

_getobjsLeft:
	move.w  d6,camAChunkX.w   
	movea.l objtblEntrLeft.w,a0
	subi.w  #128,d6
	bcs.s   .CheckRight

.FindLeft:            

	cmp.w   -OBJENTRSZ(a0),d6
	bge.s   .CheckRight

	subq.w  #OBJENTRSZ,a0
	tst.b   objentr.ID(a0)
	bpl.s   .NoStateInf
	
	subq.b  #1,1(a2)
	move.b  1(a2),d2

.NoStateInf:  
	bsr.w   _getobjCreate           ; Try to spawn object 
					; (and increment current entry)
	bne.s   .Failed                 ; Perform rightward check if failed

	subq.w  #OBJENTRSZ,a0           ; Otherwise dec. entry and try again
	bra.s   .FindLeft

.Failed:   
	tst.b   objentr.ID(a0)
	bpl.s   .NoStInf2
	addq.b  #1,1(a2)

.NoStInf2:   
	addq.w  #OBJENTRSZ,a0

; --------------------------------------

.CheckRight:    
	move.l  a0,objtblEntrLeft.w
	movea.l objtblEntrRight.w,a0
	addi.w  #256*3,d6

.FindRight: 
	cmp.w   -OBJENTRSZ(a0),d6
	bgt.s   .FoundLeft
	tst.b   -2(a0)                  ; objentr.ID ref. *backwards*
	bpl.s   .TryNextLeft
	subq.b  #1,(a2)

.TryNextLeft:   
	subq.w  #OBJENTRSZ,a0
	bra.s   .FindRight

.FoundLeft:
	move.l  a0,objtblEntrRight.w
	rts

; ---------------------------------------------------------------------------
; Get and create objects for rightwards camera movement 
; ---------------------------------------------------------------------------

_getobjRight:
	move.w  d6,camAChunkX.w     ; cameraAPosX in multiples of 128 for "chunks"
	movea.l objtblEntrRight.w,a0
	addi.w  #320*2,d6              ; Range is 2 screens forward (scr+320)

.FindRight:
	cmp.w   objentr.X(a0),d6       ; Branch if out of fwd. range
	bls.s   .CheckLeft

	tst.b   objentr.ID(a0)         ; Skip state set if MSB unset
	bpl.s   .NoStateInfo

	move.b  (a2),d2
	addq.b  #1,(a2)

.NoStateInfo:
	bsr.w   _getobjCreate           ; Try to spawn object 
					; (and increment current entry)
	beq.s   .FindRight              ; Loop if object spawned successfully

; --------------------------------------

.CheckLeft:
	move.l  a0,objtblEntrRight.w    ; Save new location in entry table rightward
	movea.l objtblEntrLeft.w,a0
	subi.w  #256*3,d6               ; Move 3 chunks back (So scrX-128 now)
	blo.s   .FoundLeft

.FindLeft:
	cmp.w   objentr.X(a0),d6
	bls.s   .FoundLeft

	tst.b   objentr.ID(a0)
	bpl.s   .NoStInf2

	addq.b  #1,1(a2)

.NoStInf2:  
	addq.w  #OBJENTRSZ,a0
	bra.s   .FindLeft

.FoundLeft:    
	move.l  a0,objtblEntrLeft.w
	rts

; ---------------------------------------------------------------------------
; Get and create objects for camera Z movement (forwards)
; ---------------------------------------------------------------------------

_getobjZ:
	movea.l objtblEntrRightZ.w,a0   
	move.w  cameraZPosX.w,d0        
	addi.w  #320,d0                 ; Adjust to 1 screen (320pix) ahead
	andi.w  #$FF80,d0               ; Shorten to multiples of 128/$80
	cmp.w   objentr.X(a0),d0         
	blo.s   _getobjExit             ; Exit if not in position
	bsr.w   _getobjCreate               
	move.l  a0,objtblEntrRightZ.w  ; Store new entry
	bra.w   _getobjZ                ; Check for another entry

; ---------------------------------------------------------------------------
; Exit routine (empty, return only)
; ---------------------------------------------------------------------------

_getobjExit:     
	rts

; ---------------------------------------------------------------------------
; Create an object based on object table entry input
; ---------------------------------------------------------------------------

_getobjCreate: 
					; Check state info    
	tst.b   objentr.ID(a0)          ; If no respawn info, create
	bpl.s   .Create

	bset    #7,2(a2,d2.w)           ; If set to respawn, create
	beq.s   .Create

	addq.w  #6,a0; Increment entry, clear and exit
	moveq   #0,d0
	rts

.Create:   
	bsr.w   _objectFindFreeSlot
	bne.s   .NoSlotFound
	move.w  (a0)+,obj.X(a1)         ; Write X
	move.w  (a0)+,d0                ; Get Y
	move.w  d0,d1      
	andi.w  #$0FFF,d0               ; Mask out top nybble
	move.w  d0,obj.Y(a1)            ; Write Y
	rol.w   #2,d1; Get that top nybble (orientation)
	andi.b  #3,d1
	move.b  d1,obj.Render(a1)       ; Write to render and status
	move.b  d1,obj.Status(a1)
	move.b  (a0)+,d0                ; Get ID
	bpl.s   .NoState                ; If no state entry skip over
	andi.b  #$7F,d0                 ; Mask top bit out
	move.b  d2,obj.Respawn(a1)      ; Write respawn info

.NoState:   
	move.b  d0,obj.No(a1)           ; Write ID
	move.b  (a0)+,obj.Args(a1)      ; Write argument
	moveq   #0,d0

.NoSlotFound:
	rts

; ---------------------------------------------------------------------------
; Function to find a free slot in dynamic object memory for an object
; ---------------------------------------------------------------------------

_objectFindFreeSlot:
	lea     objsAlloc.w,a1
	move.w  #96-1,d0

.Loop:     
	tst.b   obj.No(a1)
	beq.s   .Found
	lea     OBJSZ(a1),a1
	dbf     d0,.Loop

.Found:    
	rts

; ---------------------------------------------------------------------------
; Find a free slot for an object's child, which should come after the parent
; ---------------------------------------------------------------------------

_objectFindChildSlot:
	movea.l a0,a1
	move.w  #$F000,d0
	sub.w   a0,d0
	lsr.w   #6,d0
	subq.w  #1,d0
	bcs.s   .Found

.Loop:     
	tst.b   obj.No(a1)
	beq.s   .Found
	lea     OBJSZ(a1),a1
	dbf     d0,.Loop

.Found:    
	rts