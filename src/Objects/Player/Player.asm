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
.Index:                                  ; obj.Action:
        dc.w Player_Init-       .Index          ; 0  
        dc.w Player_Main-       .Index          ; 2
        dc.w Player_Damage-     .Index          ; 4
        dc.w Player_Death-      .Index          ; 6
        dc.w Player_Reset-      .Index          ; 8
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

        tst.w   debug.w                 ; Skip if debug not enabled
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

        move.b  angleRight.w,play.FootRight(a0) 
        move.b  angleLeft.w,play.FootLeft(a0)

        bsr.w   _playAnimate            ; Handle Sonic's animation
        bsr.w   _playObjInteract        ; Handle player/object interactions           
        bsr.w   _playSpecialLvlChunks   ; Handle special chunks
        bsr.w   _playDynamicGFX         ; Handle dynamic GFX in VRAM
        rts

; ---------------------------------------------------------------------------

.PhysicsModes:                                
        dc.w Player_MainCtrl    -.PhysicsModes
        dc.w Player_AirCtrl     -.PhysicsModes
        dc.w Player_RollCtrl    -.PhysicsModes    
        dc.w Player_AirRollCtrl -.PhysicsModes

; ---------------------------------------------------------------------------
; Handle powerup state tracking, music, and drawing
; ---------------------------------------------------------------------------

ReturnBGM:
        dc.b musID_GHZ         
        dc.b musID_LZ
        dc.b musID_MZ
        dc.b musID_SLZ
        dc.b musID_SZ
        dc.b musID_CWZ
                
; --------------------------------------

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
        lea     ReturnBGM,a1
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

        move.w  #SNDCMD_TEMPORES,d0         ; Reset music tempo
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
        bsr.w   _playInputChk
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
; Note that this is a pretty large subroutine with a lot of locals. 
; ---------------------------------------------------------------------------

_playInputChk:                              
        move.w  playerMaxSpeed.w,d6     ; Set deltas to d4,d5,d6  
        move.w  playerAccel.w,d5
        move.w  playerDecel.w,d4

        tst.w   play.Locked(a0)         ; If ctrl. locked, skip all this
        bne.w   .LookUp

        btst    #2,joypadMirr.w         ; Skip if left input not pressed
        beq.s   .NotLeft
        bsr.w   _playMoveLeft

.NotLeft:                              
        btst    #3,joypadMirr.w         ; Skip if right input not pressed
        beq.s   .NotRight
        bsr.w   _playMoveRight

.NotRight:                             
        move.b  obj.Angle(a0),d0        ; Get current angle
        addi.b  #$20,d0                 ; Push as circle over 45 degrees
        andi.b  #$C0,d0                 ; Get highest 2 bits (direction) 
        bne.w   .CameraReset            ; If on wall or ceiling,
        tst.w   obj.Momentum(a0)        ; or if not moving,
        bne.w   .CameraReset            ; then skip ahead.

        bclr    #PHYS.PUSH,obj.Status(a0)       ; Not pushing
        move.b  #5,obj.Anim(a0)                 ; Use idle animation

        btst    #PHYS.LIFTED,obj.Status(a0)     ; Is player on platform?
        beq.s   .NotLifted                      ; If not, skip ahead

        ; ---- Check for balancing on a platform

        moveq   #0,d0
        move.b  play.OnObject(a0),d0    ; Get slot of interacting object 
        lsl.w   #6,d0                   ; Calculate address from slot
        lea     OBJECTRAM.w,a1
        lea     (a1,d0.w),a1            ; a1 = Interacting obj.

        tst.b   obj.Status(a1)          ; Test bit 7 (MSB) (STAT.KILLED)
        bmi.s   .LookUp                 ; If set, object is killed,
                                        ; so skip ahead
        moveq   #0,d1
        move.b  obj.XDraw(a1),d1        ; Get its X-draw radius
        move.w  d1,d2
        add.w   d2,d2                   ; XDraw*2
        subq.w  #4,d2
        add.w   obj.X(a0),d1            ; Add our X-pos to d1
        sub.w   obj.X(a1),d1            ; Then subtract the object's

        cmpi.w  #4,d1                   ; If in 4 pix of left edge...
        blt.s   .ChkBalanceLeft
        cmp.w   d2,d1                   ; ...or right edge
        bge.s   .BalanceRight           ; then balance
        bra.s   .LookUp         

        ; ---- Check for balancing normally
        ; NOTE: The above balancing checks branch into this 

.NotLifted:                           
        jsr     _objectFindFloor        ; Get floor distance
        cmpi.w  #12,d1                  ; Skip if 12pix drop ahead
        blt.s   .LookUp                

.ChkBalanceRight:
        cmpi.b  #PHYS_LIFTFLAG,play.FootRight(a0)
        bne.s   .ChkBalanceLeft             ; Skip if being lifted

.BalanceRight:                         
        bclr    #PHYS.DIR,obj.Status(a0)    ; Set facing right
        bra.s   .SetBalanceAnim

.ChkBalanceLeft:                       
        cmpi.b  #PHYS_LIFTFLAG,play.FootLeft(a0)
        bne.s   .LookUp

.BalanceLeft:                          
        bset    #PHYS.DIR,obj.Status(a0)    ; Set facing left

.SetBalanceAnim:                              
        move.b  #6,obj.Anim(a0)
        bra.s   .CameraReset        ; Skip, can't look while balancing

        ; ---- Check for looking up

.LookUp:                           
        btst    #0,joypadMirr.w     ; If up not pressed, skip
        beq.s   .Duck

        move.b  #7,obj.Anim(a0)     ; Set look anim., shift cam. up
        cmpi.w  #200,camACenterY.w
        beq.s   .SetMoveSpeed
        addq.w  #2,camACenterY.w
        bra.s   .SetMoveSpeed

        ; ---- Check for ducking
.Duck:                                 
        btst    #1,joypadMirr.w     ; If down not pressed, reset cam. 
        beq.s   .CameraReset        

        move.b  #8,obj.Anim(a0)     ; Set duck anim., shift cam. down      
        cmpi.w  #8,camACenterY.w
        beq.s   .SetMoveSpeed

        subq.w  #2,camACenterY.w
        bra.s   .SetMoveSpeed

        ; ---- Check if camera centered, and set if not

.CameraReset:                          
        cmpi.w  #96,camACenterY.w   ; Skip if camera is already centered
        beq.s   .SetMoveSpeed

        bhs.s   .ScreenHigh
        addq.w  #4,camACenterY.w    ; Move screen 4 pix up...
                                    ; See below line - making it 2 pix    
.ScreenHigh:                           
        subq.w  #2,camACenterY.w    ; Subtract 2

        ; ---- Get player's momentum and calc. X and Y speeds

.SetMoveSpeed:                          
        move.b  joypadMirr.w,d0
        andi.b  #%1100,d0           ; Skip if left or right pressed...
        bne.s   .CalcSpeed

        move.w  obj.Momentum(a0),d0     ; ...or if not moving
        beq.s   .CalcSpeed

        bmi.s   .MomentumNeg        ; Skip if negative momentum
        sub.w   d5,d0
        bcc.s   .StillMvPos         ; If it overflows down, clear
        move.w  #0,d0

.StillMvPos:                           
        move.w  d0,obj.Momentum(a0) ; Return new + momentum value
        bra.s   .CalcSpeed          ; Go set X+Y speeds based on this

.MomentumNeg:                          
        add.w   d5,d0
        bcc.s   .StillMvNeg         ; If it overflows up, clear   
        move.w  #0,d0

.StillMvNeg:                           
        move.w  d0,obj.Momentum(a0) ; Return new - momentum value

.CalcSpeed:                             
        move.b  obj.Angle(a0),d0    ; Get player angle input
        jsr     CalcSinCos          ; d0 = sin , d1 = cos

        muls.w  obj.Momentum(a0),d1 ; (momentum*cos) for X speed      
        asr.l   #8,d1               ; Divide by 100 (drop lowest byte)
        move.w  d1,obj.XSpeed(a0)

        muls.w  obj.Momentum(a0),d0 ; (momentum*sin) for Y speed 
        asr.l   #8,d0                
        move.w  d0,obj.YSpeed(a0)

        ; fall into _playHitWall

; ---------------------------------------------------------------------------
; Check if the player has hit a wall 
; ---------------------------------------------------------------------------

_playHitWall:                           
        move.b  #$40,d1             ; d1 = 90 degree push for calcs.
        tst.w   obj.Momentum(a0)    ; Exit if not moving
        beq.s   .Exit           

        bmi.s   .IsMvLeft
        neg.w   d1

.IsMvLeft:                             
        move.b  obj.Angle(a0),d0    ; Get angle
        add.b   d1,d0               ; Push it over 90 degrees

        move.w  d0,-(sp)    
        bsr.w   _physGetWallAhead
        move.w  (sp)+,d0

        tst.w   d1                  ; If dist. is +, we aren't hitting it
        bpl.s   .Exit

        move.w  #0,obj.Momentum(a0)         ; Clear momentum 
        bset    #PHYS.PUSH,obj.Status(a0)   ; Set as pushing against it

        asl.w   #8,d1
        addi.b  #$20,d0         ; Push angle 45 degrees for quadrants
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
        move.w  obj.Momentum(a0),d0
        beq.s   .NotMoving
        bpl.s   .Skidding

.NotMoving:                            
        bset    #PHYS.DIR,obj.Status(a0)
        bne.s   .FacingLeft

        bclr    #PHYS.PUSH,obj.Status(a0)
        move.b  #1,obj.LastAnim(a0)             ; Set anim update?

.FacingLeft:                           
        sub.w   d5,d0           ; Subtract acceleration delta
        move.w  d6,d1           ; Get negated max speed for leftwards chk.
        neg.w   d1              
        cmp.w   d1,d0           ; Check if met speed limit (d6)
        bgt.s   .BelowLimit
        move.w  d1,d0           ; Force as max speed if so

.BelowLimit:                           
        move.w  d0,obj.Momentum(a0)
        move.b  #0,obj.Anim(a0)         ; Set walking anim.
        rts

.Skidding:                             
        sub.w   d4,d0
        bcc.s   .StillMoving
        move.w  #-$80,d0

.StillMoving:                          
        move.w  d0,obj.Momentum(a0)     ; Get momentum w/ parity 
        move.b  obj.Angle(a0),d0        ; Combine with angle for direc.
        addi.b  #$20,d0                 ; Push 45 deg. for quadrant
        andi.b  #$C0,d0
        bne.s   .Exit
        cmpi.w  #$400,d0                ; If too slow, don't skid
        blt.s   .Exit

        move.b  #$D,obj.Anim(a0)                ; Set skidding anim.
        bclr    #PHYS.DIR,obj.Status(a0)        ; Set facing right
        move.w  #SFXNO_SKID,d0                  ; Play Skidding SFX
        jsr     QueueSoundB

.Exit:                                 
        rts

; ---------------------------------------------------------------------------
; Move player right
; ---------------------------------------------------------------------------

_playMoveRight:                         
        move.w  obj.Momentum(a0),d0
        bmi.s   .Skidding

        bclr    #PHYS.DIR,obj.Status(a0)
        beq.s   .FacingRight

        bclr    #PHYS.PUSH,obj.Status(a0)
        move.b  #1,obj.LastAnim(a0)

.FacingRight:                          
        add.w   d5,d0           ; Add acceleration delta
        cmp.w   d6,d0           ; Check if met speed limit (d6)
        blt.s   .BelowLimit
        move.w  d6,d0           ; Force as max speed

.BelowLimit:                           
        move.w  d0,obj.Momentum(a0)    
        move.b  #0,obj.Anim(a0)
        rts

.Skidding:                             
        add.w   d4,d0
        bcc.s   .StillMoving
        move.w  #$80,d0

.StillMoving:                          
        move.w  d0,obj.Momentum(a0)     ; Get momentum w/ parity 
        move.b  obj.Angle(a0),d0        ; Combine with angle for direc.
        addi.b  #$20,d0                 ; Push 45 deg. for quadrant
        andi.b  #$C0,d0
        bne.s   .Exit
        cmpi.w  #-$400,d0               ; If too slow, don't skid
        bgt.s   .Exit

        move.b  #$D,obj.Anim(a0)                ; Set skidding anim.
        bset    #PHYS.DIR,obj.Status(a0)        ; Set facing left
        move.w  #SFXNO_SKID,d0                  ; Play Skidding SFX
        jsr     QueueSoundB

.Exit:                                 
        rts

; ---------------------------------------------------------------------------
; Player rolling
; ---------------------------------------------------------------------------

_playRoll:                          
        move.w  playerMaxSpeed.w,d6
        asl.w   #1,d6                   ; d6 = maxspeed/2
        move.w  playerAccel.w,d5
        asr.w   #1,d5                   ; d5 = acceleration/2
        move.w  playerDecel.w,d4
        asr.w   #2,d4                   ; d4 = deceleration/4

        tst.w   play.Locked(a0)         ; If ctrl. locked, skip ctrl. code
        bne.s   .Settle

        btst    #2,joypadMirr.w
        beq.s   .CheckRight

        bsr.w   _playRollLeft

.CheckRight:                           
        btst    #3,joypadMirr.w
        beq.s   .Settle

        bsr.w   _playRollRight

.Settle:                               
        move.w  obj.Momentum(a0),d0
        beq.s   .CheckStop
        bmi.s   .SettleLeft

        sub.w   d5,d0
        bcc.s   .SetMomentum
        move.w  #0,d0

.SetMomentum:                          
        move.w  d0,obj.Momentum(a0)
        bra.s   .CheckStop

.SettleLeft:                           
        add.w   d5,d0
        bcc.s   .SetMomentum2
        move.w  #0,d0

.SetMomentum2:                         
        move.w  d0,obj.Momentum(a0)

.CheckStop:                            
        tst.w   obj.Momentum(a0)
        bne.s   .CalcSpeed

        bclr    #PHYS.ROLLING,obj.Status(a0)
        move.b  #19,obj.YRad(a0)
        move.b  #9,obj.XRad(a0)
        move.b  #5,obj.Anim(a0)
        subq.w  #5,obj.Y(a0)

.CalcSpeed:                            
        move.b  obj.Angle(a0),d0
        jsr     CalcSinCos
        muls.w  obj.Momentum(a0),d1
        asr.l   #8,d1
        move.w  d1,obj.XSpeed(a0)
        muls.w  obj.Momentum(a0),d0
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
        move.w  obj.Momentum(a0),d0
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
        move.w  #0,obj.Momentum(a0)
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
        cmp.w   obj.Y(a0),d0            ; !!!
        bcs.w   loc_FD78                ; If bottom lim hit, then die
        rts                             ; (_playObjCol) wip

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
        move.w  obj.Momentum(a0),d0
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
        bset    #PHYS.ROLLING,obj.Status(a0)    

        move.b  #14,obj.YRad(a0)        ; New radiuses for rolling
        move.b  #7,obj.XRad(a0)

        move.b  #2,obj.Anim(a0)         ; Use rolling animation

        addq.w  #5,obj.Y(a0)            ; Nudge position upwards (bugfix?)

        move.w  #SFXNO_SPIN,d0          ; Play spin sound
        jsr     QueueSoundB

        tst.w   obj.Momentum(a0)        ; If momentum not 0, exit
        bne.s   .Exit                   

        move.w  #$200,obj.Momentum(a0)  ; Otherwise, nudge forward?

.Exit:                                 
        rts


; ---------------------------------------------------------------------------
; Function to check and set jumping
; ---------------------------------------------------------------------------

_playJumpChk:                           
        move.b  joypadPressMirr.w,d0
        andi.b  #%1110000,d0
        beq.w   .Exit

        moveq   #0,d0
        move.b  obj.Angle(a0),d0
        addi.b  #$80,d0
        bsr.w   _physGetCeilingDist

        cmpi.w  #6,d1
        blt.w   .Exit

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

        bset    #PHYS.AIRBORNE,obj.Status(a0)   ; Set as airbourne,
        bclr    #PHYS.PUSH,obj.Status(a0)       ; not pushing

        addq.l  #4,sp                           

        move.b  #1,phys.Jump(a0)
        move.w  #SFXNO_JUMP,d0
        jsr     QueueSoundB
        move.b  #19,obj.YRad(a0)
        move.b  #9,obj.XRad(a0)

        tst.b   objSlot18.w                     ; !!! objmemZoneClear?
        bne.s   .VictoryAnim

        btst    #PHYS.ROLLING,obj.Status(a0)    ; If rolling already,
        bne.s   .RollJump                       ; skip to rolljump set

        move.b  #14,obj.YRad(a0)
        move.b  #7,obj.XRad(a0)
        move.b  #2,obj.Anim(a0)
        bset    #PHYS.ROLLING,obj.Status(a0)
        addq.w  #5,obj.Y(a0)

.Exit:                           
        rts

.VictoryAnim:                          
        move.b  #$13,obj.Anim(a0)               ; Use victory animation
        rts

.RollJump:                             
        bset    #PHYS.ROLLJUMP,obj.Status(a0)
        rts

; ---------------------------------------------------------------------------
; Function to check held jump buttons and calculate jump height accordingly
; ---------------------------------------------------------------------------

_playJumpHeight:                        
        tst.b   play.Jump(a0)           ; If not jumping, leave
        beq.s   .NotJumping

        cmpi.w  #-$400,obj.YSpeed(a0)   ; If Y speed already set, hold
        bge.s   .HoldSpeed

        move.b  joypadMirr.w,d0         ; Check if A, C, or B held
        andi.b  #%1110000,d0            ; If so, hold speed
        bne.s   .HoldSpeed              
        move.w  #-$400,obj.YSpeed(a0)   ; Otherwise, set a low Y-speed

.HoldSpeed:                            
        rts

.NotJumping:                           
        cmpi.w  #-$FC0,obj.YSpeed(a0)           ; Cap upwards Y-speed
        bge.s   .Exit
        move.w  #-$FC0,obj.YSpeed(a0)

.Exit:                                 
        rts