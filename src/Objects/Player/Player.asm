; ---------------------------------------------------------------------------
; Type-00 Player Object code [play00]
; The code for Sonic's main player object
; ---------------------------------------------------------------------------

objPlayer:                  
        tst.w   editMode.w      ; Load into editor object if enabled
        bne.w   EditMode

        moveq   #0,d0
        move.b  obj.Action(a0),d0
        move.w  .Index(pc,d0.w),d1
        jmp     .Index(pc,d1.w)

; ---------------------------------------------------------------------------

.Index:                                         ; obj.Action:
                dc.w Player_Init-.Index          ; 0  
                dc.w Player_Main-.Index          ; 2
                dc.w Player_Hurt-.Index          ; 4
                dc.w Player_Death-.Index         ; 6
                dc.w Player_Reset-.Index         ; 8

; ---------------------------------------------------------------------------

Player_Init:                             
        addq.b  #2,obj.Action(a0)               
        move.b  #19,obj.YRad(a0)
        move.b  #9,obj.XRad(a0)         

        move.l  #MapSpr_Sonic,obj.Map(a0)
        move.w  #$780,obj.Tile(a0)

        move.b  #2,obj.Priority(a0)
        move.b  #24,obj.XDraw(a0)      
        move.b  #%100,obj.Render(a0)    ; Draw based on playfield

        move.w  #$600,playerMaxSpeed.w  ; Set player physics deltas
        move.w  #12,playerAccel.w       
        move.w  #64,playerDecel.w

Player_Main:                             
        andi.w  #$7FF,obj.Y(a0)         ; Clamp Y pos. to $800 pix. max        
        andi.w  #$7FF,cameraMainY.w

        tst.w   debug.w                 ; Skip if debug enabled
        beq.s   .Skip
        btst    #4,joypadPressMirr.w    ; Turn on editor if B pressed
        beq.s   .Skip

        move.w  #1,editMode.w

.Skip:                             
        moveq   #0,d0
        move.b  obj.Status(a0),d0       
        andi.w  #%00000110,d0           ; Use bits 1-2 as offset

        move.w  .PhysicsModes(pc,d0.w),d1
        jsr     .PhysicsModes(pc,d1.w)

        bsr.s   _playTrackPowerups    ; Handle powerup states and drawing
        bsr.w   _playRecordPos        ; Record previous positions

        move.b  footFrontAngle.w,play.FootFront(a0)
        move.b  footBackAngle.w,play.FootBack(a0)

        bsr.w   _playAnimate            ; Handle Sonic's animation
        bsr.w   _playObjInteract        ; Handle player/object interactions           
        bsr.w   _playSpecialLvlChunks   ; Handle special chunks
        bsr.w   _playDynamicGFX         ; Handle dynamic GFX in VRAM
        rts

; ---------------------------------------------------------------------------

.PhysicsModes:                                
                dc.w Player_MainCtrl-.PhysicsModes
                dc.w Player_AirCtrl-.PhysicsModes
                dc.w Player_RollCtrl-.PhysicsModes    
                dc.w Player_AirRollCtrl-.PhysicsModes

; ---------------------------------------------------------------------------
; Handle powerup state tracking, music, and drawing
; ---------------------------------------------------------------------------

@ReturnBGM:
                dc.b musID_GHZ         
                dc.b musID_LZ
                dc.b musID_MZ
                dc.b musID_SLZ
                dc.b musID_SZ
                dc.b musID_CWZ

_playTrackPowerups:
        move.w  play.Timeout(a0),d0     ; Skip if timeout is over
        beq.s   .NoTimeout

        subq.w  #1,play.Timeout(a0)     ; Decrement timeout
        lsr.w   #3,d0                   
        bcc.s   .SkipDraw               ; Skip drawing for this frame     

.NoTimeout:                            
        bsr.w   _objectDraw

.SkipDraw:                          
        tst.b   invincible.w            ; Skip if invincible flag not set
        beq.s   .SkipMusicReturn
        tst.w   play.Invincible(a0)     ; Check if invincible timer depleted
        beq.s   .SkipMusicReturn
        subq.w  #1,play.Invincible(a0)
        bne.s   .SkipMusicReturn

        tst.b   boss.w
        bne.s   .BossActive

        moveq   #0,d0
        move.b  zone.w,d0       ; Get and play BGM based on current zone
        lea     @ReturnBGM,a1
        move.b  (a1,d0.w),d0
        jsr     QueueSoundA

.BossActive:                         
        move.b  #0,invincible.w

.SkipMusicReturn:                        
        tst.b   speedup.w               ; Skip if speedup flag not set
        beq.s   .Spedup
        tst.w   play.Speedup(a0)        ; Check if speedup timer depleted
        beq.s   .Spedup
        subq.w  #1,play.Speedup(a0)
        bne.s   .Spedup

        move.w  #$600,playerMaxSpeed.w  ; Reset player phys. deltas
        move.w  #12,playerAccel.w
        move.w  #64,playerDecel.w

        move.b  #0,speedup.w

        move.w  #sndCMD_Slow,d0         ; Reset music tempo
        jmp     QueueSoundB

.Spedup:                            
        rts

; ---------------------------------------------------------------------------
; Record previous player positions for use with powerups
; ---------------------------------------------------------------------------

_playRecordPos:
        move.w  trackPos.w,d0
        lea     playerPosBuffer.w,a1
        lea     a1,d0.w,a1
        move.w  obj.X(a0),(a1)+
        move.w  obj.Y(a0),(a1)+
        addq.b  #4,trackPosEntry.w
        rts

; ---------------------------------------------------------------------------
; Player physics routines
; See .PhysicsModes - each series of branches corresponds to obj.Status bits
; ---------------------------------------------------------------------------

Player_MainCtrl:                                 ; Status unset
        bsr.w   _playJump
        bsr.w   _playUpSlope
        bsr.w   _playMove
        bsr.w   _playCheckRoll
        bsr.w   _playLevelBoundries
        bsr.w   _objectSetSpeed
        bsr.w   _physFootCollision
        bsr.w   _playFallOff
        rts

Player_AirCtrl:                                  ; Status air bit set
        bsr.w   _playJumpHeight
        bsr.w   _playAirCtrl
        bsr.w   _playLevelBoundries
        bsr.w   _objectFall
        bsr.w   _playJumpDir
        bsr.w   _physAirColCheck
        rts

Player_RollCtrl:                                 ; Status roll bit set
        bsr.w   _playJump
        bsr.w   _physRollDown
        bsr.w   _playRollCalc
        bsr.w   _playLevelBoundries
        bsr.w   _objectSetSpeed
        bsr.w   _physFootCollision
        bsr.w   _playFallOff
        rts

Player_AirRollCtrl:                              ; Both statuses set
        bsr.w   _playJumpHeight
        bsr.w   _playAirCtrl
        bsr.w   _playLevelBoundries
        bsr.w   _objectFall
        bsr.w   _playJumpDir
        bsr.w   _physAirColCheck
        rts