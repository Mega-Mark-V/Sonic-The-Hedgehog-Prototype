_playAnimate:                           
        lea     AniSpr_Sonic,a1
        moveq   #0,d0
        move.b  obj.Anim(a0),d0
        cmp.b   obj.LastAnim(a0),d0
        beq.s   .DoAnim
        move.b  d0,obj.LastAnim(a0)
        move.b  #0,obj.AnimFrame(a0)
        move.b  #0,obj.FrameTimer(a0)

.DoAnim:                               
        add.w   d0,d0
        adda.w  (a1,d0.w),a1
        move.b  (a1),d0
        bmi.s   .SpeedCalcFlag
        move.b  obj.Status(a0),d1
        andi.b  #1,d1
        andi.b  #$FC,obj.Render(a0)
        or.b    d1,obj.Render(a0)
        subq.b  #1,obj.FrameTimer(a0)
        bpl.s   .Delay
        move.b  d0,obj.FrameTimer(a0)

.LoadFrame:                            
        moveq   #0,d1
        move.b  obj.AnimFrame(a0),d1
        move.b  1(a1,d1.w),d0
        bmi.s   .LoopFlag

.Next:                                 
        move.b  d0,obj.Frame(a0)
        addq.b  #1,obj.AnimFrame(a0)

.Delay:                                
        rts

.LoopFlag:                             
        addq.b  #1,d0
        bne.s   .LoopBackFlag
        move.b  #0,obj.AnimFrame(a0)
        move.b  1(a1),d0
        bra.s   .Next

.LoopBackFlag:                         
        addq.b  #1,d0
        bne.s   .ChangeAnimFlag
        move.b  2(a1,d1.w),d0
        sub.b   d0,obj.AnimFrame(a0)
        sub.b   d0,d1
        move.b  1(a1,d1.w),d0
        bra.s   .Next

.ChangeAnimFlag:                       
        addq.b  #1,d0
        bne.s   .Exit
        move.b  2(a1,d1.w),obj.Anim(a0)

.Exit:                                 
        rts

.SpeedCalcFlag:                        
        subq.b  #1,obj.FrameTimer(a0)
        bpl.s   .Delay
        addq.b  #1,d0
        bne.w   .ChkRoll
        moveq   #0,d1
        move.b  obj.Angle(a0),d0
        move.b  obj.Status(a0),d2
        andi.b  #1,d2
        bne.s   loc_F53E
        not.b   d0

loc_F53E:                               
        addi.b  #$10,d0
        bpl.s   loc_F546
        moveq   #3,d1

loc_F546:                               
        andi.b  #$FC,obj.Render(a0)
        eor.b   d1,d2
        or.b    d2,obj.Render(a0)
        btst    #5,obj.Status(a0)
        bne.w   loc_F5E4
        lsr.b   #4,d0
        andi.b  #6,d0
        move.w  obj.Momentum(a0),d2
        bpl.s   loc_F56A
        neg.w   d2

loc_F56A:                               
        lea     sonicchg_Walk2,a1
        cmpi.w  #$600,d2
        bcc.s   loc_F582
        lea     sonicchg_Walk,a1
        move.b  d0,d1
        lsr.b   #1,d1
        add.b   d1,d0

loc_F582:                               
        add.b   d0,d0
        move.b  d0,d3
        neg.w   d2
        addi.w  #$800,d2
        bpl.s   loc_F590
        moveq   #0,d2

loc_F590:                               
        lsr.w   #8,d2
        move.b  d2,obj.FrameTimer(a0)
        bsr.w   .LoadFrame
        add.b   d3,obj.Frame(a0)
        rts

.ChkRoll:                              
        addq.b  #1,d0
        bne.s   loc_F5E4
        move.w  obj.Momentum(a0),d2
        bpl.s   loc_F5AC
        neg.w   d2

loc_F5AC:                               
        lea     sonicchg_Spin2,a1
        cmpi.w  #$600,d2
        bcc.s   loc_F5BE
        lea     sonicchg_Spin1,a1

loc_F5BE:                               
        neg.w   d2
        addi.w  #$400,d2
        bpl.s   loc_F5C8
        moveq   #0,d2

loc_F5C8:                               
        lsr.w   #8,d2
        move.b  d2,obj.FrameTimer(a0)
        move.b  obj.Status(a0),d1
        andi.b  #1,d1
        andi.b  #$FC,obj.Render(a0)
        or.b    d1,obj.Render(a0)
        bra.w   .LoadFrame

loc_F5E4:                               
        move.w  obj.Momentum(a0),d2
        bmi.s   loc_F5EC
        neg.w   d2

loc_F5EC:                               
        addi.w  #$800,d2
        bpl.s   loc_F5F4
        moveq   #0,d2

loc_F5F4:                               
        lsr.w   #6,d2
        move.b  d2,obj.FrameTimer(a0)
        lea     sonicchg_Push,a1
        move.b  obj.Status(a0),d1
        andi.b  #1,d1
        andi.b  #$FC,obj.Render(a0)
        or.b    d1,obj.Render(a0)
        bra.w   .LoadFrame

; ---------------------------------------------------------------------------

AniSpr_Sonic:   
        dc.w sonicchg_Walk-AniSpr_Sonic
        dc.w sonicchg_Walk2-AniSpr_Sonic
        dc.w sonicchg_Spin1-AniSpr_Sonic
        dc.w sonicchg_Spin2-AniSpr_Sonic
        dc.w sonicchg_Push-AniSpr_Sonic
        dc.w sonicchg_Idle-AniSpr_Sonic
        dc.w sonicchg_Balance-AniSpr_Sonic
        dc.w sonicchg_LookUp-AniSpr_Sonic
        dc.w sonicchg_LookDown-AniSpr_Sonic
        dc.w sonicchg_Squish1-AniSpr_Sonic
        dc.w sonicchg_Squish2-AniSpr_Sonic
        dc.w sonicchg_Squish3-AniSpr_Sonic
        dc.w sonicchg_Squish4-AniSpr_Sonic
        dc.w sonicchg_Skid-AniSpr_Sonic
        dc.w sonicchg_Floating-AniSpr_Sonic
        dc.w sonicchg_FallingSpin-AniSpr_Sonic
        dc.w sonicchg_Spring-AniSpr_Sonic
        dc.w sonicchg_HoldPole-AniSpr_Sonic
        dc.w sonicchg_Victory1-AniSpr_Sonic
        dc.w sonicchg_Victory2-AniSpr_Sonic
        dc.w sonicchg_Unk1-AniSpr_Sonic
        dc.w sonicchg_AirBubbleOld-AniSpr_Sonic
        dc.w sonicchg_FireDeath-AniSpr_Sonic
        dc.w sonicchg_Drown-AniSpr_Sonic
        dc.w sonicchg_Death-AniSpr_Sonic
        dc.w sonicchg_Placeholder1-AniSpr_Sonic
        dc.w sonicchg_Placeholder2-AniSpr_Sonic
sonicchg_Walk:  
	dc.b $FF,  8,  9, $A, $B,  6,  7,$FF 
sonicchg_Walk2: 
	dc.b $FF,$1E,$1F,$20,$21,$FF,$FF,$FF 
sonicchg_Spin1: 
	dc.b $FE,$2E,$2F,$30,$31,$32,$FF,$FF 
sonicchg_Spin2: 
	dc.b $FE,$2E,$2F,$32,$30,$31,$32,$FF 
sonicchg_Push:  
	dc.b $FD,$45,$46,$47,$48,$FF,$FF,$FF 
sonicchg_Idle:  
	dc.b $17,  1,  1,  1,  1,  1,  1,  1 
        dc.b   1,  1,  1,  1,  1,  3,  2,  2
        dc.b   2,  3,  4,$FE,  2,  0
sonicchg_Balance:
	dc.b $1F,$3A,$3B,$FF   
sonicchg_LookUp:
	dc.b $3F,  5,$FF,  0    
sonicchg_LookDown:	
	dc.b $3F,$39,$FF,  0  
sonicchg_Squish1:	
	dc.b $3F,$33,$FF,  0   
sonicchg_Squish2:	
	dc.b $3F,$34,$FF,  0   
sonicchg_Squish3:	
	dc.b $3F,$35,$FF,  0   
sonicchg_Squish4:	
	dc.b $3F,$36,$FF,  0   
sonicchg_Skid:  		
	dc.b   7,$37,$38,$FF    
sonicchg_Floating:	
	dc.b   7,$3C,$3F,$FF  
sonicchg_FallingSpin:
	dc.b   7,$3C,$3D,$53,$3E,$54,$FF,  0 
sonicchg_Spring:
	dc.b $2F,$40,$FD,  0    
sonicchg_HoldPole:
	dc.b   4,$41,$42,$FF  
sonicchg_Victory1:
	dc.b  $F,$43,$43,$43,$FE,  1 
sonicchg_Victory2:
	dc.b  $F,$43,$44,$FE,  1,  0 
sonicchg_Unk1:  
	dc.b $3F,$49,$FF,  0    
sonicchg_AirBubbleOld:
	dc.b $3F,$4A,$FF,  0 
sonicchg_FireDeath:
	dc.b   3,$4B,$FF,  0 
sonicchg_Drown: 
	dc.b   3,$4C,$FF,  0    
sonicchg_Death: 
	dc.b   3,$4D,$FF,  0    
sonicchg_Placeholder1:
	dc.b   3,$4E,$4F,$50,$51,$52,  0,$FE 
                dc.b   1,  0
sonicchg_Placeholder2:
	dc.b   3,$55,$FF,  0 

; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

_playDynamicGFX:                        
        moveq   #0,d0
        move.b  obj.Frame(a0),d0
        cmp.b   playerFrame.w,d0
        beq.s   .Exit
        move.b  d0,playerFrame.w
        lea     SprDyn_Sonic,a2
        add.w   d0,d0
        adda.w  (a2,d0.w),a2
        moveq   #0,d1
        move.b  (a2)+,d1
        subq.b  #1,d1
        bmi.s   .Exit
        lea     playerDMABuffer.w,a3
        move.b  #1,playerDrawFlag.w

.ReadEntry:                            
        moveq   #0,d2
        move.b  (a2)+,d2
        move.w  d2,d0
        lsr.b   #4,d0
        lsl.w   #8,d2
        move.b  (a2)+,d2
        lsl.w   #5,d2
        lea     ArtUnc_Sonic,a1
        adda.l  d2,a1

.LoadTile:                             
        movem.l (a1)+,d2-d6/a4-a6
        movem.l d2-d6/a4-a6,(a3)
        lea     32(a3),a3
        dbf     d0,.LoadTile
        dbf     d1,.ReadEntry

.Exit:                                 
        rts 
