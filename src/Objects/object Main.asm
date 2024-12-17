; ---------------------------------------------------------------------------
; Main Objects handling and function libraries
; ---------------------------------------------------------------------------

OBJ.GRAVITY    EQU     56              ; Gravity delta

; ---------------------------------------------------------------------------

RunObjects:                             
        lea     OBJECTRAM.w,a0
        moveq   #96-1,d7
        moveq   #0,d0
        cmpi.b  #6,objSlot00+obj.Action.w ; Sonic routine counter
        bcc.s   .Paused

.RunObjLoop:                       
        move.b  obj.ID(a0),d0
        beq.s   .EmptySlot
        add.w   d0,d0
        add.w   d0,d0
        movea.l ObjectIndex-4(pc,d0.w),a1 ; No zero offset - start at 1
        jsr     (a1)
        moveq   #0,d0

.EmptySlot:                            
        lea     OBJSZ(a0),a0
        dbf     d7,.RunObjLoop
        rts

.Paused:                               
        moveq   #32-1,d7
        bsr.s   .RunObjLoop
        moveq   #96-1,d7

.PauseObjLoop:                         
        moveq   #0,d0
        move.b  obj.ID(a0),d0
        beq.s   .SkipDisplay
        tst.b   obj.Render(a0)
        bpl.s   .SkipDisplay
        bsr.w   _objectDraw     ; Only display sprites while paused

.SkipDisplay:                          
        lea     OBJSZ(a0),a0
        dbf     d7,.PauseObjLoop
        rts

; ---------------------------------------------------------------------------
; Macro to create ids from objects
OBJDEF      macro   addr, id
        dc.l    \addr
\id     rs.b    1
        endm
; ---------------------------------------------------------------------------
; Main object list
; Objects are not listed in any particular order, here and in the ROM
; ---------------------------------------------------------------------------

ObjectIndex:    
        rsreset   
        OBJDEF  objPlayer,                 OBJID.PLAYER         
        OBJDEF  objDev1,                   OBJID.DEV1    
        OBJDEF  objDev2,                   OBJID.DEV2
        OBJDEF  objDev3,                   OBJID.DEV3
        OBJDEF  objDev4,                   OBJID.DEV4
        OBJDEF  objDev5,                   OBJID.DEV5
        OBJDEF  objDev6,                   OBJID.DEV6
        OBJDEF  .Null
        OBJDEF  objPlayerSpecial,          OBJID.PLAYSPECIAL
        OBJDEF  .Null
        OBJDEF  .Null
        OBJDEF  .Null
        OBJDEF  objGoal,                   OBJID.GOAL
        OBJDEF  objTitleSonic,             OBJID.TITLESONIC
        OBJDEF  objTitleMisc,              OBJID.TITLEMISC
        OBJDEF  objPlayerTest,             OBJID.PLAYTEST
        OBJDEF  objBridge,                 OBJID.BRIDGE       
        OBJDEF  objSceneryLamp,            OBJID.SCENERYLAMP
        OBJDEF  objFireShooter,            OBJID.FIRESHOOTER
        OBJDEF  objFireBall,               OBJID.FIREBALL
        OBJDEF  objSwingPlatform,          OBJID.SWINGPLAT
        OBJDEF  .Null
        OBJDEF  objSpikeBridge,            OBJID.SPIKEBRIDGE             
        OBJDEF  objPlatform,               OBJID.PLATFORM
        OBJDEF  objRollingBall,            OBJID.ROLLINGBALL
        OBJDEF  objCollapsingLedge,        OBJID.COLLAPSLEDGE
        OBJDEF  objUnkPlatform,            OBJID.UNKPLATFORM
        OBJDEF  objLevelScenery,           OBJID.LVLSCENERY
        OBJDEF  objHiddenSwitch,           OBJID.HIDDENSWITCH
        OBJDEF  objEnemyPig,               OBJID.ENEMYPIG
        OBJDEF  objEnemyCrab,              OBJID.ENEMYCRAB
        OBJDEF  objBallBomb,               OBJID.BALLBOMB
        OBJDEF  objHUD,                    OBJID.HUD
        OBJDEF  objEnemyBee,               OBJID.ENEMYBEE
        OBJDEF  objMissile,                OBJID.MISSILE
        OBJDEF  objMissileHit,             OBJID.MISSILEHIT
        OBJDEF  objRing,                   OBJID.RING
        OBJDEF  objMonitor,                OBJID.MONITOR
        OBJDEF  objLightExpl,              OBJID.LIGHTEXPL
        OBJDEF  objFriends,                OBJID.FRIENDS
        OBJDEF  objPoints,                 OBJID.POINTS
        OBJDEF  objTunnelDoor,             OBJID.TUNNELDOOR
        OBJDEF  objEnemyFish,              OBJID.ENEMYFISH
        OBJDEF  objEnemyFish2,             OBJID.ENEMYFISH2
        OBJDEF  objEnemyMole,              OBJID.ENEMYMOLE
        OBJDEF  objMonitorItem,            OBJID.MONITORITEM
        OBJDEF  objShiftingFloor,          OBJID.SHIFTFLOOR
        OBJDEF  objGlassBlock,             OBJID.GLASSBLOCK
        OBJDEF  objSpikeCrusherV,          OBJID.SPIKECRUSHV
        OBJDEF  objButton,                 OBJID.BUTTON
        OBJDEF  objPushable,               OBJID.PUSHABLE
        OBJDEF  objTitleCards,             OBJID.TITLECARD
        OBJDEF  objSpreadingFire,          OBJID.SPREADFIRE
        OBJDEF  objSpikes,                 OBJID.SPIKES
        OBJDEF  objRingLoss,               OBJID.RINGLOSS
        OBJDEF  objShield,                 OBJID.SHIELD
        OBJDEF  objGameOver,               OBJID.GAMEOVER
        OBJDEF  objActClear,               OBJID.ACTCLEAR
        OBJDEF  objRock,                   OBJID.ROCK
        OBJDEF  objBreakable,              OBJID.BREAKABLE
        OBJDEF  objBoss,                   OBJID.BOSS
        OBJDEF  objEggCapsule,             OBJID.EGGCAPSULE
        OBJDEF  objHeavyExpl,              OBJID.HEAVYEXPL
        OBJDEF  objEnemyBug,               OBJID.ENEMYBUG
        OBJDEF  objSpring,                 OBJID.SPRING
        OBJDEF  objEnemyChameleon,         OBJID.ENEMYCHAMELEON
        OBJDEF  objEnemyArmadillo,         OBJID.ENEMYARMADILLO
        OBJDEF  objEdgeWalls,              OBJID.EDGEWALLS
        OBJDEF  objSpikeCrusherH,          OBJID.SPIKECRUSHH
        OBJDEF  objBlock,                  OBJID.BLOCK
        OBJDEF  objBumper,                 OBJID.BUMPER
        OBJDEF  objBossWeapons,            OBJID.BOSSWEAPONS
        OBJDEF  objWaterfallSFX,           OBJID.WTRFALLSFX
        OBJDEF  objWarp,                   OBJID.WARP
        OBJDEF  objBigRing,                OBJID.BIGRING
        OBJDEF  objGeyserSpawn,            OBJID.GEYSERSPAWN
        OBJDEF  objGeyser,                 OBJID.GEYSER
        OBJDEF  objLavaChase,              OBJID.LAVACHASE
        OBJDEF  objEnemyRabbit,            OBJID.ENEMYRABBIT
        OBJDEF  objEnemySnail,             OBJID.ENEMYSNAIL
        OBJDEF  objSmashBlock,             OBJID.SMASHBLOCK
        OBJDEF  objMovingPlatform,         OBJID.MOVINGPLAT
        OBJDEF  objCollapsingFloor,        OBJID.COLLAPSFLOOR
        OBJDEF  objDamageTag,              OBJID.DAMAGETAG
        OBJDEF  objEnemyBat,               OBJID.ENEMYBAT
        OBJDEF  objBobbingBlocks,          OBJID.BOBBLOCK
        OBJDEF  objSpikeBall,              OBJID.SPIKEBALL
        OBJDEF  objBigSpikedBall,          OBJID.BIGSPIKEBALL
        OBJDEF  objAdvPlatform,            OBJID.ADVPLATFORM
        OBJDEF  objCirclingGirder,         OBJID.CIRCLEGIRDER
        OBJDEF  objStairBlocks,            OBJID.STAIRBLOCKS
        OBJDEF  objGirder,                 OBJID.GIRDER
        OBJDEF  objFan,                    OBJID.FAN
        OBJDEF  objSeeSaw,                 OBJID.SEESAW
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
        addi.w  #OBJ.GRAVITY,d0
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
; Function to set an object to render
; ---------------------------------------------------------------------------

_objectDraw:                            
        lea     spriteDrawQueue.w,a1
        move.b  obj.Priority(a0),d0
        andi.w  #7,d0
        lsl.w   #7,d0
        adda.w  d0,a1
        cmpi.w  #$7E,(a1) 
        bcc.s   .Exit
        addq.w  #2,(a1)
        adda.w  (a1),a1
        move.w  a0,(a1)

.Exit:                                 
        rts


; ---------------------------------------------------------------------------
; Function to set an object's child (or a1) to render
; ---------------------------------------------------------------------------

_objectDrawChild:                       
        lea     spriteDrawQueue.w,a2
        move.b  obj.Priority(a1),d0
        andi.w  #7,d0
        lsl.w   #7,d0
        adda.w  d0,a2
        cmpi.w  #$7E,(a2)
        bcc.s   .Exit
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
        moveq   #$F,d0

.Loop:                                 
        move.l  d1,(a1)+
        dbf     d0,.Loop
        rts

; ---------------------------------------------------------------------------
; Main routine to draw all sprites in the sprite draw queue
; ---------------------------------------------------------------------------

RenderCams:    
        dc.l 0
        dc.l cameraAPosX
        dc.l cameraBPosX
        dc.l cameraZPosX

; ---------------------------------------------------------------------------

DrawObjects:                            
        lea     vdpSprites.w,a2
        moveq   #0,d5
        lea     spriteDrawQueue.w,a4
        moveq   #7,d7

.Priority:                             
        tst.w   (a4)
        beq.w   .NextPriorityLevel
        moveq   #2,d6

.Object:                               
        movea.w (a4,d6.w),a0
        tst.b   obj.ID(a0)
        beq.w   .SkipObject
        bclr    #7,obj.Render(a0)
        move.b  obj.Render(a0),d0
        move.b  d0,d4
        andi.w  #%1100,d0
        beq.s   .DrawFixed
        movea.l RenderCams(pc,d0.w),a1
        moveq   #0,d0
        move.b  obj.XDraw(a0),d0
        move.w  obj.X(a0),d3
        sub.w   (a1),d3
        move.w  d3,d1
        add.w   d0,d1
        bmi.w   .SkipObject
        move.w  d3,d1
        sub.w   d0,d1
        cmpi.w  #$140,d1
        bge.s   .SkipObject
        addi.w  #$80,d3
        btst    #4,d4
        beq.s   .AssumeHeight
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

.DrawFixed:                            
        move.w  obj.YScr(a0),d2
        move.w  obj.X(a0),d3
        bra.s   .DrawObject

.AssumeHeight:                         
        move.w  obj.Y(a0),d2
        sub.w   4(a1),d2
        addi.w  #128,d2
        cmpi.w  #96,d2
        bcs.s   .SkipObject
        cmpi.w  #384,d2
        bcc.s   .SkipObject

.DrawObject:                           
        movea.l obj.Map(a0),a1
        moveq   #0,d1
        btst    #5,d4
        bne.s   .StaticMap
        move.b  obj.Frame(a0),d1
        add.b   d1,d1
        adda.w  (a1,d1.w),a1
        move.b  (a1)+,d1
        subq.b  #1,d1
        bmi.s   .SetVisible

.StaticMap:                            
        bsr.w   _spriteBuildToBuffer

.SetVisible:                           
        bset    #7,obj.Render(a0)

.SkipObject:                           
        addq.w  #2,d6
        subq.w  #2,(a4)
        bne.w   .Object

.NextPriorityLevel:                    
        lea     $80(a4),a4
        dbf     d7,.Priority
        move.b  d5,(spriteCount).w
        cmpi.b  #80,d5
        beq.s   .LimitReached
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
        cmpi.b  #$50,d5 ; 'P'
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
        cmpi.b  #$50,d5
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
        cmpi.b  #$50,d5
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
        sub.w   (cameraAPosX).w,d0
        bmi.s   .Offscreen
        cmpi.w  #320,d0
        bge.s   .Offscreen
        move.w  obj.Y(a0),d1
        sub.w   (cameraAPosY).w,d1
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
OBJTBL.SZ       EQU  6

objtbl          struct
X:              rs.w 1
Y:              rs.w 1
ID:             rs.b 1
Arg:            rs.b 1
                ends
; ---------------------------------------------------------------------------
; NOTES:
; objectChunkRight and objectChunkLeft are current list offset for each dir.
; objectChunk is the current chunk cameraA is in (so left scr. edge)
; !!! not finished here, working on it
; ---------------------------------------------------------------------------

GetObjects:                             
                moveq   #0,d0
                move.b  getObjectsMode.w,d0
                move.w  .Index(pc,d0.w),d0
                jmp     .Index(pc,d0.w)

; ---------------------------------------------------------------------------

.Index:                                
                dc.w GetObjects_Init-*
                dc.w GetObjects_Main-.Index

; ---------------------------------------------------------------------------

GetObjects_Init:                        
                addq.b  #2,getObjectsMode.w
                move.w  zone.w,d0
                lsl.b   #6,d0
                lsr.w   #4,d0
                lea     ObjPosIndex,a0
                movea.l a0,a1
                adda.w  (a0,d0.w),a0
                move.l  a0,objectChunkRight.w
                move.l  a0,objectChunkLeft.w
                adda.w  2(a1,d0.w),a1
                move.l  a1,objunkChunkRight.w   ; ! Unused
                move.l  a1,objunkChunkLeft.w
                lea     objectStates.w,a2       ; Reset object flags
                move.w  #$101,(a2)+
                move.w  #$5F-1,d0

.ClearStates:                          
                clr.l   (a2)+
                dbf     d0,.ClearStates
                move.w  #-1,objectChunk.w

; ---------------------------------------------------------------------------

GetObjects_Main:                        
        lea     objectStates.w,a2
        moveq   #0,d2
        move.w  cameraAPosX.w,d6     ; Get Cam A X position
        andi.w  #$FF80,d6            ; Shorten to multiples of 128
        cmp.w   objectChunk.w,d6     ; Check against chunk value
        beq.w   .Exit                ; Exit if within same chunk 
        bge.s   .GetObjectsRright    ; Get rightward if from chunk ahead
        move.w  d6,objectChunk.w     

.GetObjectsLeft:
        movea.l objectChunkLeft.w,a0
        subi.w  #$80,d6
        blo.s   .RightDone                     
        cmp.w   -OBJTBL.SZ(a0),d6
        bge.s   .RightDone
        subq.w  #OBJTBL.SZ,a0
        tst.b   objtbl.ID(a0)
        bpl.s   .SkipStateLeft
        subq.b  #1,1(a2)
        move.b  1(a2),d2

.SkipStateLeft:                       
        bsr.w   .LoadEntry
        bne.s   .Failed
        subq.w  #OBJTBL.SZ,a0
        bra.s   .RightLoop

.Failed:                               
        tst.b   objtbl.ID(a0)       ; If object MSB not set, no state entry
        bpl.s   .Rewind
        addq.b  #1,1(a2)

.Rewind:                               
        addq.w  #OBJTBL.SZ,a0

.RightDone:                            
        move.l  a0,objectChunkLeft.w
        movea.l objectChunkRight.w,a0
        addi.w  #(320)*2,d6              ; two screen sizes

.FindRightChunk:                       
        cmp.w   -OBJTBL.SZ(a0),d6
        bgt.s   .FoundRight
        tst.b   -2(a0)
        bpl.s   .NextObjRight
        subq.b  #1,(a2)

.NextObjRight:                         
        subq.w  #6,a0
        bra.s   .FindRightChunk

.FoundRight:                           
        move.l  a0,objectChunkRight.w
        rts

; ---------------------------------------------------------------------------

.GetObjectsRright:                       
                move.w  d6,objectChunk.w
                movea.l objectChunkRight.w,a0
                addi.w  #640,d6

.LeftLoop:                             
                cmp.w   objtbl.X(a0),d6
                bls.s   .LeftDone
                tst.b   objtbl.ID(a0)
                bpl.s   .SkipStateLeft
                move.b  (a2),d2
                addq.b  #1,(a2)

.SkipStateLeft:                        
                bsr.w   .LoadEntry
                beq.s   .LeftLoop

.LeftDone:                             
                move.l  a0,objectChunkRight.w
                movea.l objectChunkLeft.w,a0
                subi.w  #768,d6
                bcs.s   .FoundLeft

.FindLeftChunk:                        
                cmp.w   objtbl.X(a0),d6
                bls.s   .FoundLeft
                tst.b   objtbl.ID(a0)
                bpl.s   .NextObjLeft
                addq.b  #1,1(a2)

.NextObjLeft:                          
                addq.w  #6,a0
                bra.s   .FindLeftChunk

.FoundLeft:                            
                move.l  a0,objectChunkLeft.w
                rts

unusedZObjLoad:                   
                movea.l objunkChunkRight.w,a0   
                move.w  cameraZPosX.w,d0        
                addi.w  #320,d0                 ; Adjust to 1 screen (320pix) ahead
                andi.w  #$FF80,d0               ; Shorten to multiples of 128/$80
                cmp.w   objtbl.X(a0),d0         
                blo.s   .Exit                   ; Exit if not in position
                bsr.w   .LoadEntry              
                move.l  a0,objunkChunkRight.w   ; Store new entry
                bra.w   ??_getobjectsUnknown    ; Check for another entry

.Exit:                                 
                rts

.LoadEntry:                            
                tst.b   objtbl.ID(a0)           ; If no respawn info, create
                bpl.s   .Create
                bset    #7,2(a2,d2.w)           ; If set to respawn, create
                beq.s   .Create
                addq.w  #6,a0                   ; Increment entry, clear and exit
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
                rol.w   #2,d1                   ; Get that top nybble
                andi.b  #3,d1
                move.b  d1,obj.Render(a1)       ; Write to render and status
                move.b  d1,obj.Status(a1)
                move.b  (a0)+,d0                ; Get ID
                bpl.s   .NoState                ; If no state entry skip over
                andi.b  #$7F,d0                 ; Mask top bit out
                move.b  d2,obj.Respawn(a1)      ; Write respawn info

.NoState:                               
                move.b  d0,obj.ID(a1)           ; Write ID
                move.b  (a0)+,obj.Arg(a1)       ; Write argument
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
        tst.b   obj.ID(a1)
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
        tst.b   obj.ID(a1)
        beq.s   .Found
        lea     OBJSZ(a1),a1
        dbf     d0,.Loop

.Found:                                
        rts