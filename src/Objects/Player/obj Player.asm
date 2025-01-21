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

.Index:                                          ; obj.Action:
                dc.w Player_Init-.Index          ; 0  
                dc.w Player_Main-.Index          ; 2
                dc.w Player_Damage-.Index        ; 4
                dc.w Player_Death-.Index         ; 6
                dc.w Player_Reset-.Index         ; 8

; ---------------------------------------------------------------------------

Player_Init:                             
        addq.b  #2,obj.Action(a0)               
        move.b  #19,obj.YRad(a0)
        move.b  #9,obj.XRad(a0)         

        move.l  #MapSpr_Player,obj.Map(a0)
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

        move.b  angleFront.w,play.FootFront(a0)
        move.b  angleBack.w,play.FootBack(a0)

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
        bsr.w   _playLevelLimits
        bsr.w   _objectSetSpeed
        bsr.w   _physFootCollision
        bsr.w   _playFallOff
        rts

Player_AirCtrl:                                  ; Status air bit set
        bsr.w   _playJumpHeight
        bsr.w   _playAirCtrl
        bsr.w   _playLevelLimits
        bsr.w   _objectFall
        bsr.w   _playJumpDir
        bsr.w   _physAirColCheck
        rts

Player_RollCtrl:                                 ; Status roll bit set
        bsr.w   _playJump
        bsr.w   _physRollDown
        bsr.w   _playRoll
        bsr.w   _playLevelLimits
        bsr.w   _objectSetSpeed
        bsr.w   _physFootCollision
        bsr.w   _playFallOff
        rts

Player_AirRollCtrl:                              ; Both statuses set
        bsr.w   _playJumpHeight
        bsr.w   _playAirCtrl
        bsr.w   _playLevelLimits
        bsr.w   _objectFall
        bsr.w   _playJumpDir
        bsr.w   _physAirColCheck
        rts

; ---------------------------------------------------------------------------
; Main player movement function.
; Controls moving left and right, looking up and down, and misc.
; ---------------------------------------------------------------------------

_playMove:                              
        move.w  playerMaxSpeed.w,d6
        move.w  playerAccel.w,d5
        move.w  playerDecel.w,d4

        tst.w   phys.Locked(a0)
        bne.w   _playLookChk

        btst    #2,joypadMirr.w
        beq.s   .NotLeft
        bsr.w   _playMoveLeft

.NotLeft:                              
        btst    #3,joypadMirr.w
        beq.s   .NotRight
        bsr.w   _playMoveRight

.NotRight:                             
        move.b  obj.Angle(a0),d0
        addi.b  #$20,d0
        andi.b  #$C0,d0
        bne.w   .CameraReset
        tst.w   phys.Momentum(a0)
        bne.w   .CameraReset
        bclr    #PHYS.PUSH,obj.Status(a0)
        move.b  #5,obj.Anim(a0)
        btst    #PHYS.HOISTED,obj.Status(a0)
        beq.s   .NotHoisted
        moveq   #0,d0
        move.b  phys.OnObject(a0),d0
        lsl.w   #6,d0

        lea     OBJECTRAM.w,a1
        lea     (a1,d0.w),a1
        tst.b   obj.Status(a1)
        bmi.s   _playLookChk

        moveq   #0,d1
        move.b  obj.XDraw(a1),d1
        move.w  d1,d2
        add.w   d2,d2
        subq.w  #4,d2
        add.w   obj.X(a0),d1
        sub.w   obj.X(a1),d1
        cmpi.w  #4,d1
        blt.s   .BalanceLeft
        cmp.w   d2,d1
        bge.s   .BalanceRight
        bra.s   _playLookChk

.NotHoisted:                           
        jsr     _objectFindFloor
        cmpi.w  #12,d1
        blt.s   _playLookChk
        cmpi.b  #3,phys.FootFront(a0)
        bne.s   .ChkBalanceLeft

.BalanceRight:                         
        bclr    #PHYS.DIR,obj.Status(a0)
        bra.s   .SetAnim

.ChkBalanceLeft:                       
        cmpi.b  #3,phys.FootBack(a0)
        bne.s   _playLookChk

.BalanceLeft:                          
        bset    #PHYS.DIR,obj.Status(a0)

.SetAnim:                              
        move.b  #6,obj.Anim(a0)
        bra.s   .CameraReset

; --------------------------------------

_playLookChk:                           
        btst    #0,joypadMirr.w
        beq.s   .Duck
        move.b  #7,obj.Anim(a0)
        cmpi.w  #200,camACenterY.w
        beq.s   .ScreenIsSet
        addq.w  #2,camACenterY.w
        bra.s   .ScreenIsSet

.Duck:                                 
        btst    #1,joypadMirr.w
        beq.s   .CameraReset
        move.b  #8,obj.Anim(a0)
        cmpi.w  #8,camACenterY.w
        beq.s   .ScreenIsSet
        subq.w  #2,camACenterY.w
        bra.s   .ScreenIsSet

.CameraReset:                          
        cmpi.w  #96,camACenterY.w
        beq.s   .ScreenIsSet
        bcc.s   .ScreenHigh
        addq.w  #4,camACenterY.w

.ScreenHigh:                           
        subq.w  #2,camACenterY.w

.ScreenIsSet:                          
        move.b  joypadMirr.w,d0
        andi.b  #$C,d0
        bne.s   .GetSpeed
        move.w  phys.Momentum(a0),d0
        beq.s   .GetSpeed
        bmi.s   .MomentumNeg
        sub.w   d5,d0
        bcc.s   .StillMvPos
        move.w  #0,d0

.StillMvPos:                           
        move.w  d0,phys.Momentum(a0)
        bra.s   .GetSpeed

.MomentumNeg:                          
        add.w   d5,d0
        bcc.s   .StillMvNeg
        move.w  #0,d0

.StillMvNeg:                           
        move.w  d0,phys.Momentum(a0)

.GetSpeed:                             
        move.b  obj.Angle(a0),d0
        jsr     CalcSinCos
        muls.w  phys.Momentum(a0),d1
        asr.l   #8,d1
        move.w  d1,obj.XSpeed(a0)
        muls.w  phys.Momentum(a0),d0
        asr.l   #8,d0
        move.w  d0,obj.YSpeed(a0)

; --------------------------------------

_playHitWall:                           
        move.b  #$40,d1
        tst.w   phys.Momentum(a0)
        beq.s   .Exit
        bmi.s   .IsMvLeft
        neg.w   d1

.IsMvLeft:                             
        move.b  obj.Angle(a0),d0
        add.b   d1,d0
        move.w  d0,-(sp)
        bsr.w   _physGetWallDist
        move.w  (sp)+,d0
        tst.w   d1
        bpl.s   .Exit
        move.w  #0,phys.Momentum(a0)
        bset    #5,obj.Status(a0)
        asl.w   #8,d1
        addi.b  #$20,d0
        andi.b  #$C0,d0
        beq.s   .HitDwn
        cmpi.b  #$40,d0
        beq.s   .HitLeft
        cmpi.b  #$80,d0
        beq.s   .HitUp

.HitRight:
        add.w   d1,obj.XSpeed(a0)
        rts

.HitUp:                                
        sub.w   d1,obj.YSpeed(a0)
        rts

.HitLeft:                              
        sub.w   d1,obj.XSpeed(a0)
        rts

.HitDwn:                               
        add.w   d1,obj.YSpeed(a0)

.Exit:                                 
        rts

; ---------------------------------------------------------------------------
; Move player left
; ---------------------------------------------------------------------------

_playMoveLeft:                          
        move.w  phys.Momentum(a0),d0
        beq.s   .NotMoving
        bpl.s   .Skidding

.NotMoving:                            
        bset    #PHYS.DIR,obj.Status(a0)
        bne.s   .FacingLeft
        bclr    #PHYS.PUSH,obj.Status(a0)
        move.b  #1,obj.LastAnim(a0)

.FacingLeft:                           
        sub.w   d5,d0
        move.w  d6,d1
        neg.w   d1
        cmp.w   d1,d0
        bgt.s   .BelowLimit
        move.w  d1,d0

.BelowLimit:                           
        move.w  d0,phys.Momentum(a0)
        move.b  #0,obj.Anim(a0)
        rts

.Skidding:                             
        sub.w   d4,d0
        bcc.s   .StillMoving
        move.w  #-$80,d0

.StillMoving:                          
        move.w  d0,phys.Momentum(a0)
        move.b  obj.Angle(a0),d0
        addi.b  #$20,d0
        andi.b  #$C0,d0
        bne.s   .Exit
        cmpi.w  #1024,d0
        blt.s   .Exit
        move.b  #$D,obj.Anim(a0)
        bclr    #0,obj.Status(a0)
        move.w  #SFXNO.Skid,d0
        jsr     QueueSoundB

.Exit:                                 
        rts

; ---------------------------------------------------------------------------
; Move player right
; ---------------------------------------------------------------------------

_playMoveRight:                         
        move.w  phys.Momentum(a0),d0
        bmi.s   .Skidding
        bclr    #PHYS.DIR,obj.Status(a0)
        beq.s   .FacingRight
        bclr    #PHYS.PUSH,obj.Status(a0)
        move.b  #1,obj.LastAnim(a0)

.FacingRight:                          
        add.w   d5,d0
        cmp.w   d6,d0
        blt.s   .BelowLimit
        move.w  d6,d0

.BelowLimit:                           
        move.w  d0,phys.Momentum(a0)
        move.b  #0,obj.Anim(a0)
        rts

.Skidding:                             
        add.w   d4,d0
        bcc.s   .StillMoving
        move.w  #$80,d0

.StillMoving:                          
        move.w  d0,phys.Momentum(a0)
        move.b  obj.Angle(a0),d0
        addi.b  #$20,d0
        andi.b  #$C0,d0
        bne.s   .Exit
        cmpi.w  #-$400,d0
        bgt.s   .Exit
        move.b  #$D,obj.Anim(a0)
        bset    #0,obj.Status(a0)
        move.w  #SFXNO.Skid,d0
        jsr     QueueSoundB

.Exit:                                 
        rts

; ---------------------------------------------------------------------------
; Player rolling
; ---------------------------------------------------------------------------

_playRoll:                          
        move.w  playerMaxSpeed.w,d6
        asl.w   #1,d6
        move.w  playerAccel.w,d5
        asr.w   #1,d5
        move.w  playerDecel.w,d4
        asr.w   #2,d4

        tst.w   phys.Locked(a0)
        bne.s   .Settle

        btst    #2,joypadMirr.w
        beq.s   .CheckRight

        bsr.w   _playRollLeft

.CheckRight:                           
        btst    #3,(joypadMirr).w
        beq.s   .Settle

        bsr.w   _playRollRight

.Settle:                               
        move.w  phys.Momentum(a0),d0
        beq.s   .CheckStop
        bmi.s   .SettleLeft

        sub.w   d5,d0
        bcc.s   .SetMomentum
        move.w  #0,d0

.SetMomentum:                          
        move.w  d0,phys.Momentum(a0)
        bra.s   .CheckStop

.SettleLeft:                           
        add.w   d5,d0
        bcc.s   .SetMomentum2
        move.w  #0,d0

.SetMomentum2:                         
        move.w  d0,phys.Momentum(a0)

.CheckStop:                            
        tst.w   phys.Momentum(a0)
        bne.s   .CalcSpeed

        bclr    #2,obj.Status(a0)
        move.b  #$13,obj.YRad(a0)
        move.b  #9,obj.XRad(a0)
        move.b  #5,obj.Anim(a0)
        subq.w  #5,obj.Y(a0)

.CalcSpeed:                            
        move.b  obj.Angle(a0),d0
        jsr     CalcSinCos
        muls.w  phys.Momentum(a0),d1
        asr.l   #8,d1
        move.w  d1,obj.XSpeed(a0)
        muls.w  phys.Momentum(a0),d0
        asr.l   #8,d0
        move.w  d0,obj.YSpeed(a0)
        bra.w   _playHitWall

; ---------------------------------------------------------------------------
; Player Roll Left
; ---------------------------------------------------------------------------


_playRollLeft:                          
        move.w  obj.Momentum(a0),d0
        beq.s   .StartRoll
        bpl.s   .Decelerate

.StartRoll:                            
        bset    #PHYS.DIR,obj.Status(a0)
        move.b  #2,obj.Anim(a0)
        rts

.Decelerate:                           
        sub.w   d4,d0
        bcc.s   .SetMomentum
        move.w  #-$80,d0

.SetMomentum:                          
        move.w  d0,obj.Momentum(a0)
        rts

; ---------------------------------------------------------------------------
; Player Roll Right
; ---------------------------------------------------------------------------

_playRollRight:                         
        move.w  phys.Momentum(a0),d0
        bmi.s   .Decelerate
        bclr    #0,obj.Status(a0)
        move.b  #2,obj.Anim(a0)
        rts

.Decelerate:                           
        add.w   d4,d0
        bcc.s   .SetMomentum
        move.w  #$80,d0

.SetMomentum:                          
        move.w  d0,obj.Momentum(a0)
        rts


; ---------------------------------------------------------------------------
; Airborne direction control
; ---------------------------------------------------------------------------

_playAirCtrl:                           
        move.w  playerMaxSpeed.w,d6
        move.w  playerAccel.w,d5
        asl.w   #1,d5
        btst    #PHYS.ROLLJUMP,obj.Status(a0)
        bne.s   .SetCamera
        move.w  obj.XSpeed(a0),d0
        btst    #2,joypad.w
        beq.s   .NotLeft
        bset    #PHYS.DIR,obj.Status(a0)
        sub.w   d5,d0
        move.w  d6,d1
        neg.w   d1
        cmp.w   d1,d0
        bgt.s   .NotLeft
        move.w  d1,d0

.NotLeft:                              
        btst    #3,joypad.w
        beq.s   .SetSpeed
        bclr    #PHYS.DIR,obj.Status(a0)
        add.w   d5,d0
        cmp.w   d6,d0
        blt.s   .SetSpeed
        move.w  d6,d0

.SetSpeed:                             
        move.w  d0,obj.XSpeed(a0)

.SetCamera:                            
        cmpi.w  #96,camACenterY.w
        beq.s   .CheckDrag
        bcc.s   .ShiftCam
        addq.w  #4,camACenterY.w

.ShiftCam:                             
        subq.w  #2,camACenterY.w

.CheckDrag:                            
        cmpi.w  #-$400,obj.YSpeed(a0)
        bcs.s   .Exit
        move.w  obj.XSpeed(a0),d0
        move.w  d0,d1
        asr.w   #5,d1
        beq.s   .Exit
        bmi.s   .MovingLeft
        sub.w   d1,d0
        bcc.s   .SetRAirDrag
        move.w  #0,d0

.SetRAirDrag:                          
        move.w  d0,obj.XSpeed(a0)
        rts

.MovingLeft:                           
        sub.w   d1,d0
        bcs.s   .SetLAirDrag
        move.w  #0,d0

.SetLAirDrag:                          
        move.w  d0,obj.XSpeed(a0)

.Exit:                                 
        rts


; ---------------------------------------------------------------------------
; Unused function, known as "hedcolchk" in source code
; ---------------------------------------------------------------------------


_playHeadChk:
        move.b  obj.Angle(a0),d0
        addi.b  #$20,d0
        andi.b  #$C0,d0
        bne.s   .Exit
        bsr.w   _physNoWallWalk
        tst.w   d1
        bpl.s   .Exit
        move.w  #0,phys.Momentum(a0)
        move.w  #0,obj.XSpeed(a0)
        move.w  #0,obj.YSpeed(a0)
        move.b  #$B,obj.Anim(a0)

.Exit:                                 
        rts

; ---------------------------------------------------------------------------
; Function to prevent player from moving beyond camera/level limits
; ---------------------------------------------------------------------------

_playLevelLimits:                       
        move.l  obj.X(a0),d1
        move.w  obj.XSpeed(a0),d0
        ext.l   d0
        asl.l   #8,d0
        add.l   d0,d1
        swap    d1
        move.w  limitALeft.w,d0
        addi.w  #16,d0
        cmp.w   d1,d0
        bhi.s   .Reset
        move.w  limitARight.w,d0
        addi.w  #$128,d0
        cmp.w   d1,d0
        bls.s   .Reset
        move.w  limitADown.w,d0
        addi.w  #224,d0
        cmp.w   obj.Y(a0),d0
        bcs.w   loc_FD78
        rts

.Reset:                                
        move.w  d0,obj.X(a0)
        move.w  #0,obj.YScr(a0)
        move.w  #0,obj.XSpeed(a0)
        move.w  #0,obj.Momentum(a0)
        rts

; ---------------------------------------------------------------------------
; Function to check for rolling while walking/running
; ---------------------------------------------------------------------------

_playRollChk:                           
        move.w  phys.Momentum(a0),d0
        bpl.s   .AlreadyPositive
        neg.w   d0

.AlreadyPositive:                      
        cmpi.w  #$80,d0
        bcs.s   .Exit
        move.b  joypadMirr.w,d0
        andi.b  #%1100,d0               ; Leave if L or R are pressed
        bne.s   .Exit
        btst    #1,joypadMirr.w
        bne.s   _playRollSet

.Exit:                                 
        rts

; ---------------------------------------------------------------------------
; Function to set parameters for rolling (hitbox, animation, status, etc)
; ---------------------------------------------------------------------------

_playRollSet:                           
        btst    #PHYS.ROLLING,obj.Status(a0)
        beq.s   .DoRoll
        rts

.DoRoll:                               
        bset    #2,obj.Status(a0)
        move.b  #$E,obj.YRad(a0)
        move.b  #7,obj.XRad(a0)
        move.b  #2,obj.Anim(a0)
        addq.w  #5,obj.Y(a0)
        move.w  #SFXNO.Spin,d0
        jsr     QueueSoundB
        tst.w   obj.Momentum(a0)
        bne.s   .Exit
        move.w  #$200,obj.Momentum(a0)

.Exit:                                 
        rts


; ---------------------------------------------------------------------------
; Function to check and set jumping
; ---------------------------------------------------------------------------

_playJumpChk:                           
        move.b  joypadPressMirr.w,d0
        andi.b  #%1110000,d0
        beq.w   .NotPressed

        moveq   #0,d0
        move.b  obj.Angle(a0),d0
        addi.b  #$80,d0
        bsr.w   _physGetCeilingDist

        cmpi.w  #6,d1
        blt.w   .NotPressed

        moveq   #0,d0
        move.b  obj.Angle(a0),d0
        subi.b  #64,d0
        jsr     CalcSinCos
        muls.w  #$680,d1
        asr.l   #8,d1
        add.w   d1,obj.XSpeed(a0)
        muls.w  #$680,d0
        asr.l   #8,d0
        add.w   d0,obj.YSpeed(a0)
        bset    #PHYS.AIRBORNE,obj.Status(a0)
        bclr    #PHYS.PUSH,obj.Status(a0)
        addq.l  #4,sp
        move.b  #1,phys.Jump(a0)
        move.w  #SFXNO.Jump,d0
        jsr     QueueSoundB
        move.b  #19,obj.YRad(a0)
        move.b  #9,obj.XRad(a0)

        tst.b   objSlot18.w
        bne.s   .VictoryAnim

        btst    #PHYS.ROLLING,obj.Status(a0)
        bne.s   .RollJump

        move.b  #14,obj.YRad(a0)
        move.b  #7,obj.XRad(a0)
        move.b  #2,obj.Anim(a0)
        bset    #PHYS.ROLLING,obj.Status(a0)
        addq.w  #5,obj.Y(a0)

.NotPressed:                           
        rts

.VictoryAnim:                          
        move.b  #$13,obj.Anim(a0)
        rts

.RollJump:                             
        bset    #PHYS.ROLLJUMP,obj.Status(a0)
        rts

; ---------------------------------------------------------------------------
; Function to check held jump buttons and calculate jump height accordingly
; ---------------------------------------------------------------------------

_playJumpHeight:                        
        tst.b   phys.Jump(a0)
        beq.s   .NotJumping
        cmpi.w  #-$400,obj.YSpeed(a0)
        bge.s   .HoldSpeed
        move.b  joypadMirr.w,d0
        andi.b  #%1110000,d0
        bne.s   .HoldSpeed
        move.w  #-$400,obj.YSpeed(a0)

.HoldSpeed:                            
        rts

.NotJumping:                           
        cmpi.w  #-$FC0,obj.YSpeed(a0)   ; ???????????
        bge.s   .Exit
        move.w  #-$FC0,obj.YSpeed(a0)

.Exit:                                 
        rts