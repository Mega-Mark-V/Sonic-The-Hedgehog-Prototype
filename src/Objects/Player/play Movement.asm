_playMove:                              
        move.w  (playerMaxSpeed).w,d6
        move.w  (playerAccel).w,d5
        move.w  (playerDecel).w,d4
        tst.w   phys.Locked(a0)
        bne.w   .LookUp
        btst    #2,(joypadMirr).w
        beq.s   .NotLeft
        bsr.w   _playMoveLeft

.NotLeft:                              
        btst    #3,(joypadMirr).w
        beq.s   .NotRight
        bsr.w   _playMoveRight

.NotRight:                             
        move.b  obj.Angle(a0),d0
        addi.b  #$20,d0
        andi.b  #$C0,d0
        bne.w   .CameraReset
        tst.w   phys.Momentum(a0)
        bne.w   .CameraReset
        bclr    #5,obj.Status(a0)
        move.b  #5,obj.Anim(a0)
        btst    #3,obj.Status(a0)
        beq.s   .Balancing
        moveq   #0,d0
        move.b  phys.OnObject(a0),d0
        lsl.w   #6,d0
        lea     (objSlot00).w,a1
        lea     (a1,d0.w),a1
        tst.b   obj.Status(a1)
        bmi.s   .LookUp
        moveq   #0,d1
        move.b  obj.XDraw(a1),d1
        move.w  d1,d2
        add.w   d2,d2
        subq.w  #4,d2
        add.w   obj.X(a0),d1
        sub.w   obj.X(a1),d1
        cmpi.w  #4,d1
        blt.s   loc_EA92
        cmp.w   d2,d1
        bge.s   loc_EA82
        bra.s   .LookUp
; ---------------------------------------------------------------------------

.Balancing:                            
        jsr     _objectFindFloor
        cmpi.w  #12,d1
        blt.s   .LookUp
        cmpi.b  #3,phys.FootFront(a0)
        bne.s   loc_EA8A

loc_EA82:                               
        bclr    #0,obj.Status(a0)
        bra.s   loc_EA98
; ---------------------------------------------------------------------------

loc_EA8A:                               
        cmpi.b  #3,phys.FootBack(a0)
        bne.s   .LookUp

loc_EA92:                               
        bset    #0,obj.Status(a0)

loc_EA98:                               
        move.b  #6,obj.Anim(a0)
        bra.s   .CameraReset
; ---------------------------------------------------------------------------

.LookUp:                               
        btst    #0,(joypadMirr).w
        beq.s   .LookDown
        move.b  #7,obj.Anim(a0)
        cmpi.w  #200,(cameraYCenter).w
        beq.s   loc_EAEA
        addq.w  #2,(cameraYCenter).w
        bra.s   loc_EAEA
; ---------------------------------------------------------------------------

.LookDown:                             
        btst    #1,(joypadMirr).w
        beq.s   .CameraReset
        move.b  #8,obj.Anim(a0)
        cmpi.w  #8,(cameraYCenter).w
        beq.s   loc_EAEA
        subq.w  #2,(cameraYCenter).w
        bra.s   loc_EAEA
; ---------------------------------------------------------------------------

.CameraReset:                          
        cmpi.w  #96,(cameraYCenter).w
        beq.s   loc_EAEA
        bcc.s   loc_EAE6
        addq.w  #4,(cameraYCenter).w

loc_EAE6:                               
        subq.w  #2,(cameraYCenter).w

loc_EAEA:                               
        move.b  (joypadMirr).w,d0
        andi.b  #$C,d0
        bne.s   loc_EB16
        move.w  phys.Momentum(a0),d0
        beq.s   loc_EB16
        bmi.s   loc_EB0A
        sub.w   d5,d0
        bcc.s   loc_EB04
        move.w  #0,d0

loc_EB04:                               
        move.w  d0,phys.Momentum(a0)
        bra.s   loc_EB16
; ---------------------------------------------------------------------------

loc_EB0A:                               
        add.w   d5,d0
        bcc.s   loc_EB12
        move.w  #0,d0

loc_EB12:                               
        move.w  d0,phys.Momentum(a0)

loc_EB16:                               
        move.b  obj.Angle(a0),d0
        jsr     (CalcSinCos).l
        muls.w  phys.Momentum(a0),d1
        asr.l   #8,d1
        move.w  d1,obj.XSpeed(a0)
        muls.w  phys.Momentum(a0),d0
        asr.l   #8,d0
        move.w  d0,obj.YSpeed(a0)

_sonicCheckWall:                        
        move.b  #64,d1
        tst.w   phys.Momentum(a0)
        beq.s   .End
        bmi.s   .CheckAngle
        neg.w   d1

.CheckAngle:                           
        move.b  obj.Angle(a0),d0
        add.b   d1,d0
        move.w  d0,-(sp)
        bsr.w   _physGetWallDist
        move.w  (sp)+,d0
        tst.w   d1
        bpl.s   .End
        move.w  #0,phys.Momentum(a0)
        bset    #5,obj.Status(a0)
        asl.w   #8,d1
        addi.b  #32,d0
        andi.b  #$C0,d0
        beq.s   loc_EB8A
        cmpi.b  #64,d0
        beq.s   loc_EB84
        cmpi.b  #128,d0
        beq.s   loc_EB7E
        add.w   d1,obj.XSpeed(a0)
        rts
; ---------------------------------------------------------------------------

loc_EB7E:                               
        sub.w   d1,obj.YSpeed(a0)
        rts
; ---------------------------------------------------------------------------

loc_EB84:                               
        sub.w   d1,obj.XSpeed(a0)
        rts
; ---------------------------------------------------------------------------

loc_EB8A:                               
        add.w   d1,obj.YSpeed(a0)

.End:                                  
        rts
; End of function _playMove


; =============== S U B R O U T I N E =======================================


_playMoveLeft:                          
                move.w  phys.Momentum(a0),d0
                beq.s   .NotMoving
                bpl.s   loc_EBC4

.NotMoving:                            
                bset    #0,obj.Status(a0)
                bne.s   loc_EBAC
                bclr    #5,obj.Status(a0)
                move.b  #1,obj.AnimPrev(a0)

loc_EBAC:                               
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   loc_EBB8
                move.w  d1,d0

loc_EBB8:                               
                move.w  d0,phys.Momentum(a0)
                move.b  #0,obj.Anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_EBC4:                               
                sub.w   d4,d0
                bcc.s   loc_EBCC
                move.w  #-128,d0

loc_EBCC:                               
                move.w  d0,phys.Momentum(a0)
                move.b  obj.Angle(a0),d0
                addi.b  #%100000,d0
                andi.b  #%11000000,d0
                bne.s   locret_EBFA
                cmpi.w  #1024,d0
                blt.s   locret_EBFA
                move.b  #$D,obj.Anim(a0)
                bclr    #0,obj.Status(a0)
                move.w  #sfxID_Skid,d0
                jsr     (QueueSoundB).l

locret_EBFA:                            
                rts
; End of function _playMoveLeft


; =============== S U B R O U T I N E =======================================


_playMoveRight:                         
                move.w  phys.Momentum(a0),d0
                bmi.s   .Skidding
                bclr    #0,obj.Status(a0)
                beq.s   loc_EC16
                bclr    #5,obj.Status(a0)
                move.b  #1,obj.AnimPrev(a0)

loc_EC16:                               
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   loc_EC1E
                move.w  d6,d0

loc_EC1E:                               
                move.w  d0,phys.Momentum(a0)
                move.b  #0,obj.Anim(a0)
                rts
; ---------------------------------------------------------------------------

.Skidding:                             
                add.w   d4,d0
                bcc.s   loc_EC32
                move.w  #128,d0

loc_EC32:                               
                move.w  d0,phys.Momentum(a0)
                move.b  obj.Angle(a0),d0
                addi.b  #32,d0
                andi.b  #%11000000,d0
                bne.s   locret_EC60
                cmpi.w  #-$400,d0
                bgt.s   locret_EC60
                move.b  #$D,obj.Anim(a0)
                bset    #0,obj.Status(a0)
                move.w  #sfxID_Skid,d0
                jsr     (QueueSoundB).l

locret_EC60:                            
                rts
; End of function _playMoveRight


; =============== S U B R O U T I N E =======================================


_playRollCalc:                          
                move.w  (playerMaxSpeed).w,d6
                asl.w   #1,d6
                move.w  (playerAccel).w,d5
                asr.w   #1,d5
                move.w  (playerDecel).w,d4
                asr.w   #2,d4
                tst.w   phys.Locked(a0)
                bne.s   .Settle
                btst    #2,(joypadMirr).w
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
; ---------------------------------------------------------------------------

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
                jsr     (CalcSinCos).l
                muls.w  phys.Momentum(a0),d1
                asr.l   #8,d1
                move.w  d1,obj.XSpeed(a0)
                muls.w  phys.Momentum(a0),d0
                asr.l   #8,d0
                move.w  d0,obj.YSpeed(a0)
                bra.w   _sonicCheckWall
; End of function _playRollCalc


; =============== S U B R O U T I N E =======================================


_playRollLeft:                          
                move.w  phys.Momentum(a0),d0
                beq.s   .StartRoll
                bpl.s   .Decelerate

.StartRoll:                            
                bset    #0,obj.Status(a0)
                move.b  #2,obj.Anim(a0)
                rts
; ---------------------------------------------------------------------------

.Decelerate:                           
                sub.w   d4,d0
                bcc.s   .SetMomentum
                move.w  #$FF80,d0

.SetMomentum:                          
                move.w  d0,phys.Momentum(a0)
                rts
; End of function _playRollLeft


; =============== S U B R O U T I N E =======================================


_playRollRight:                         
                move.w  phys.Momentum(a0),d0
                bmi.s   .Decelerate
                bclr    #0,obj.Status(a0)
                move.b  #2,obj.Anim(a0)
                rts
; ---------------------------------------------------------------------------

.Decelerate:                           
                add.w   d4,d0
                bcc.s   .SetMomentum
                move.w  #128,d0

.SetMomentum:                          
                move.w  d0,phys.Momentum(a0)
                rts
; End of function _playRollRight


; =============== S U B R O U T I N E =======================================


_playAirCtrl:                           
                move.w  (playerMaxSpeed).w,d6
                move.w  (playerAccel).w,d5
                asl.w   #1,d5
                btst    #PHYS.ROLLJUMP,obj.Status(a0)
                bne.s   .SetCamera
                move.w  obj.XSpeed(a0),d0
                btst    #2,(joypad).w
                beq.s   .NotLeft
                bset    #PHYS.DIR,obj.Status(a0)
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   .NotLeft
                move.w  d1,d0

.NotLeft:                              
                btst    #3,(joypad).w
                beq.s   .SetSpeed
                bclr    #PHYS.DIR,obj.Status(a0)
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   .SetSpeed
                move.w  d6,d0

.SetSpeed:                             
                move.w  d0,obj.XSpeed(a0)

.SetCamera:                            
                cmpi.w  #96,(cameraYCenter).w
                beq.s   .CheckDrag
                bcc.s   .ShiftCam
                addq.w  #4,(cameraYCenter).w

.ShiftCam:                             
                subq.w  #2,(cameraYCenter).w

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
; ---------------------------------------------------------------------------

.MovingLeft:                           
                sub.w   d1,d0
                bcs.s   .SetLAirDrag
                move.w  #0,d0

.SetLAirDrag:                          
                move.w  d0,obj.XSpeed(a0)

.Exit:                                 
                rts
; End of function _playAirCtrl


; =============== S U B R O U T I N E =======================================


_playSquish:
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
; End of function _playSquish


; =============== S U B R O U T I N E =======================================


_playLevelBoundries:                    
                move.l  obj.X(a0),d1
                move.w  obj.XSpeed(a0),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d1
                swap    d1
                move.w  (eventLeftBound).w,d0
                addi.w  #16,d0
                cmp.w   d1,d0
                bhi.s   .Reset
                move.w  (eventRightBound).w,d0
                addi.w  #$128,d0
                cmp.w   d1,d0
                bls.s   .Reset
                move.w  (eventBottomBound).w,d0
                addi.w  #224,d0
                cmp.w   obj.Y(a0),d0
                bcs.w   loc_FD78
                rts
; ---------------------------------------------------------------------------

.Reset:                                
                move.w  d0,obj.X(a0)
                move.w  #0,obj.YScr(a0)
                move.w  #0,obj.XSpeed(a0)
                move.w  #0,obj.Momentum(a0)
                rts
; End of function _playLevelBoundries


; =============== S U B R O U T I N E =======================================


_playCheckRoll:                         
                move.w  phys.Momentum(a0),d0
                bpl.s   .AlreadyPositive
                neg.w   d0

.AlreadyPositive:                      
                cmpi.w  #$80,d0
                bcs.s   .Exit
                move.b  (joypadMirr).w,d0
                andi.b  #$C,d0
                bne.s   .Exit
                btst    #1,(joypadMirr).w
                bne.s   _playDoRoll

.Exit:                                 
                rts
; End of function _playCheckRoll


; =============== S U B R O U T I N E =======================================


_playDoRoll:                            
                btst    #2,obj.Status(a0)
                beq.s   .DoRoll
                rts
; ---------------------------------------------------------------------------

.DoRoll:                               
                bset    #2,obj.Status(a0)
                move.b  #$E,obj.YRad(a0)
                move.b  #7,obj.XRad(a0)
                move.b  #2,obj.Anim(a0)
                addq.w  #5,obj.Y(a0)
                move.w  #sfxID_Spin,d0
                jsr     (QueueSoundB).l
                tst.w   obj.Momentum(a0)
                bne.s   .Exit
                move.w  #$200,obj.Momentum(a0)

.Exit:                                 
                rts
; End of function _playDoRoll


; =============== S U B R O U T I N E =======================================


_playJump:                              
        move.b  (joypadPressMirr).w,d0
        move.b  joypadPressMirr.w,d0
        andi.b  #%1110000,d0                    ; Skip processing if 
        beq.w   .NotPressed                     ; no buttons pressed 

        moveq   #0,d0                           ; Get ceiling proximity 
        move.b  obj.Angle(a0),d0
        addi.b  #$80,d0
        bsr.w   _physGetCeilingDist
        cmpi.w  #6,d1
        blt.w   .NotPressed
        moveq   #0,d0
        move.b  obj.Angle(a0),d0
        subi.b  #64,d0
        jsr     (CalcSinCos).l
        muls.w  #$680,d1
        asr.l   #8,d1
        add.w   d1,obj.XSpeed(a0)
        muls.w  #$680,d0
        asr.l   #8,d0
        add.w   d0,obj.YSpeed(a0)
        bset    #PHYS.AIRPHYS,obj.Status(a0)
        bclr    #PHYS.PUSH,obj.Status(a0)
        addq.l  #4,sp
        move.b  #1,phys.Jump(a0)
        move.w  #sfxID_Jump,d0
        jsr     (QueueSoundB).l
        move.b  #19,obj.YRad(a0)
        move.b  #9,obj.XRad(a0)
        tst.b   (objSlot18).w
        bne.s   .VictoryAnim
        btst    #PHYS.ROLLPHYS,obj.Status(a0)
        bne.s   .RollJump
        move.b  #14,obj.YRad(a0)
        move.b  #7,obj.XRad(a0)
        move.b  #2,obj.Anim(a0)
        bset    #PHYS.ROLLPHYS,obj.Status(a0)
        addq.w  #5,obj.Y(a0)

.NotPressed:
        rts
; ---------------------------------------------------------------------------

.VictoryAnim:
        move.b  #$13,obj.Anim(a0)
        rts
; ---------------------------------------------------------------------------

.RollJump:
        bset    #PHYS.ROLLJUMP,obj.Status(a0)
        rts


; =============== S U B R O U T I N E =======================================


_playJumpHeight:                        
                tst.b   phys.Jump(a0)
                beq.s   .NotJumping
                cmpi.w  #-$400,obj.YSpeed(a0)
                bge.s   ??_sonicJumpHeightExit
                move.b  (joypadMirr).w,d0
                andi.b  #%1110000,d0
                bne.s   ??_sonicJumpHeightExit
                move.w  #-$400,obj.YSpeed(a0)

??_sonicJumpHeightExit:                 
                rts
; ---------------------------------------------------------------------------

.NotJumping:                           
                cmpi.w  #-$FC0,obj.YSpeed(a0)
                bge.s   .Exit
                move.w  #-$FC0,obj.YSpeed(a0)

.Exit:                                 
                rts
; End of function _playJumpHeight


; ---------------------------------------------------------------------------
; Calculate player jumping velocity off of current slope angle
; ---------------------------------------------------------------------------

_playerJump:                            
        move.b  joypadPressMirr.w,d0
        andi.b  #%1110000,d0                    ; Skip processing if 
        beq.w   .NotPressed                     ; no buttons pressed 

        moveq   #0,d0                           ; Get ceiling proximity 
        move.b  obj.Angle(a0),d0
        addi.b  #$80,d0                         
        bsr.w   _physChkCeilingProximity

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
        bset    #PLAY.AIRPHYS,obj.Status(a0)
        bclr    #PLAY.PUSH,obj.Status(a0)
        addq.l  #4,sp
        move.b  #1,play.Jump(a0)
        move.w  #sfxID_Jump,d0
        jsr     QueueSoundB
        move.b  #19,obj.YRad(a0)
        move.b  #9,obj.XRad(a0)
        tst.b   objectSlot18.w
        bne.s   .VictoryAnim
        btst    #PLAY.ROLLPHYS,obj.Status(a0)
        bne.s   .RollJump
        move.b  #14,obj.YRad(a0)
        move.b  #7,obj.XRad(a0)
        move.b  #2,obj.Anim(a0)
        bset    #PLAY.ROLLPHYS,obj.Status(a0)
        addq.w  #5,obj.Y(a0)

.NotPressed:                           
        rts

; ---------------------------------------------------------------------------

.VictoryAnim:                          
        move.b  #$13,obj.Anim(a0)
        rts

; ---------------------------------------------------------------------------

.RollJump:                             
        bset    #PLAY.ROLLJUMP,obj.Status(a0)
        rts