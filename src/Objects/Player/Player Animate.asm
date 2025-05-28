; ---------------------------------------------------------------------------
; Player animation script handler
; Separate from _objAnimate, since Sonic requires more dynamic animation
; ---------------------------------------------------------------------------

_playAnimate:
        lea     AniSpr_Sonic,a1
        moveq   #0,d0
        move.b  obj.Anim(a0),d0
        cmp.b   obj.AnimLast(a0),d0
        beq.s   .NoChg
        move.b  d0,obj.AnimLast(a0)
        move.b  #0,obj.AnimFrame(a0)
        move.b  #0,obj.FrameTimer(a0)

.NoChg:  
        add.w   d0,d0
        adda.w  (a1,d0.w),a1
        move.b  (a1),d0
        bmi.s   .AnimDynamic
        move.b  obj.Status(a0),d1
        andi.b  #1,d1
        andi.b  #%11111100,obj.Render(a0)
        or.b    d1,obj.Render(a0)
        subq.b  #1,obj.FrameTimer(a0)
        bpl.s   .Wait
        move.b  d0,obj.FrameTimer(a0)

.LoadFrame: 
        moveq   #0,d1
        move.b  obj.AnimFrame(a0),d1
        move.b  1(a1,d1.w),d0
        bmi.s   .LoopFlag

.Next:
        move.b  d0,obj.Frame(a0)
        addq.b  #1,obj.AnimFrame(a0)

.Wait:
        rts

; ---------------------------------------------------------------------------

.LoopFlag:  
        addq.b  #1,d0
        bne.s   .BackFlag
        move.b  #0,obj.AnimFrame(a0)
        move.b  1(a1),d0
        bra.s   .Next

; ---------------------------------------------------------------------------

.BackFlag:  
        addq.b  #1,d0
        bne.s   .ChgFlag
        move.b  2(a1,d1.w),d0
        sub.b   d0,obj.AnimFrame(a0)
        sub.b   d0,d1
        move.b  1(a1,d1.w),d0
        bra.s   .Next

; ---------------------------------------------------------------------------

.ChgFlag:
        addq.b  #1,d0
        bne.s   .Exit
        move.b  2(a1,d1.w),obj.Anim(a0)

.Exit:
        rts

; ---------------------------------------------------------------------------

.AnimDynamic:  
        subq.b  #1,obj.FrameTimer(a0)
        bpl.s   .Wait
        addq.b  #1,d0
        bne.w   .AnimRoll
        moveq   #0,d1
        move.b  obj.Angle(a0),d0
        move.b  obj.Status(a0),d2
        andi.b  #1,d2
        bne.s   .Flip
        not.b   d0

.Flip:
        addi.b  #$10,d0
        bpl.s   .NoFlipping
        moveq   #%11,d1

.NoFlipping:
        andi.b  #$FC,obj.Render(a0) ; apply flip flags
        eor.b   d1,d2
        or.b    d2,obj.Render(a0)
        btst    #5,obj.Status(a0)
        bne.w   .AnimPush
        lsr.b   #4,d0
        andi.b  #6,d0
        move.w  obj.Momentum(a0),d2
        bpl.s   .NotNeg2
        neg.w   d2

.NotNeg2:
        lea     AnimSonic_Walk2,a1
        cmpi.w  #$600,d2
        bcc.s   .Running
        lea     AnimSonic_Walk,a1
        move.b  d0,d1
        lsr.b   #1,d1
        add.b   d1,d0

.Running:
        add.b   d0,d0
        move.b  d0,d3
        neg.w   d2
        addi.w  #$800,d2
        bpl.s   .BelowMax
        moveq   #0,d2

.BelowMax:  
        lsr.w   #8,d2
        move.b  d2,obj.FrameTimer(a0)
        bsr.w   .LoadFrame
        add.b   d3,obj.Frame(a0)
        rts

; ---------------------------------------------------------------------------

.AnimRoll:  
        addq.b  #1,d0
        bne.s   .AnimPush
        move.w  obj.Momentum(a0),d2
        bpl.s   .NotNeg
        neg.w   d2

.NotNeg: 
        lea     AnimSonic_Spin2,a1
        cmpi.w  #$600,d2
        bcc.s   .Fast
        lea     AnimSonic_Spin1,a1

.Fast:
        neg.w   d2
        addi.w  #$400,d2
        bpl.s   .SkipClr2
        moveq   #0,d2

.SkipClr2:  
        lsr.w   #8,d2
        move.b  d2,obj.FrameTimer(a0)
        move.b  obj.Status(a0),d1
        andi.b  #1,d1
        andi.b  #$FC,obj.Render(a0)
        or.b    d1,obj.Render(a0)
        bra.w   .LoadFrame

; ---------------------------------------------------------------------------

.AnimPush:  
        move.w  obj.Momentum(a0),d2
        bmi.s   .IsNeg
        neg.w   d2

.IsNeg: 
        addi.w  #$800,d2
        bpl.s   .SkipClr
        moveq   #0,d2

.SkipClr:
        lsr.w   #6,d2
        move.b  d2,obj.FrameTimer(a0)
        lea     AnimSonic_Push,a1
        move.b  obj.Status(a0),d1
        andi.b  #1,d1
        andi.b  #$FC,obj.Render(a0)
        or.b    d1,obj.Render(a0)
        bra.w   .LoadFrame

; ---------------------------------------------------------------------------
; Animation table
; ---------------------------------------------------------------------------

AniSpr_Sonic:
        dc.w AnimSonic_Walk-AniSpr_Sonic
        dc.w AnimSonic_Walk2-AniSpr_Sonic
        dc.w AnimSonic_Spin1-AniSpr_Sonic
        dc.w AnimSonic_Spin2-AniSpr_Sonic
        dc.w AnimSonic_Push-AniSpr_Sonic
        dc.w AnimSonic_Idle-AniSpr_Sonic
        dc.w AnimSonic_Balance-AniSpr_Sonic
        dc.w AnimSonic_LookUp-AniSpr_Sonic
        dc.w AnimSonic_LookDown-AniSpr_Sonic
        dc.w AnimSonic_Squish1-AniSpr_Sonic
        dc.w AnimSonic_Squish2-AniSpr_Sonic
        dc.w AnimSonic_Squish3-AniSpr_Sonic
        dc.w AnimSonic_Squish4-AniSpr_Sonic
        dc.w AnimSonic_Skid-AniSpr_Sonic
        dc.w AnimSonic_Floating-AniSpr_Sonic
        dc.w AnimSonic_FallingSpin-AniSpr_Sonic
        dc.w AnimSonic_Spring-AniSpr_Sonic
        dc.w AnimSonic_HoldPole-AniSpr_Sonic
        dc.w AnimSonic_Victory1-AniSpr_Sonic
        dc.w AnimSonic_Victory2-AniSpr_Sonic
        dc.w AnimSonic_Unk1-AniSpr_Sonic
        dc.w AnimSonic_AirBubbleOld-AniSpr_Sonic
        dc.w AnimSonic_FireDeath-AniSpr_Sonic
        dc.w AnimSonic_Drown-AniSpr_Sonic
        dc.w AnimSonic_Death-AniSpr_Sonic
        dc.w AnimSonic_Unk2-AniSpr_Sonic
        dc.w AnimSonic_Unk3-AniSpr_Sonic

; ---------------------------------------------------------------------------

AnimSonic_Walk:
        dc.b    $FF,  8,  9, $A, $B,  6,  7,$FF 
        even

AnimSonic_Walk2: 
        dc.b    $FF,$1E,$1F,$20,$21,$FF,$FF,$FF 
        even

AnimSonic_Spin1: 
        dc.b    $FE,$2E,$2F,$30,$31,$32,$FF,$FF 
        even

AnimSonic_Spin2: 
        dc.b    $FE,$2E,$2F,$32,$30,$31,$32,$FF 
        even

AnimSonic_Push:  
        dc.b    $FD,$45,$46,$47,$48,$FF,$FF,$FF 
        even

AnimSonic_Idle:  
        dc.b    $17,  1,  1,  1,  1,  1,  1,  1 
        dc.b    1,  1,  1,  1,  1,  3,  2,  2
        dc.b    2,  3,  4,$FE,  2
        even

AnimSonic_Balance:
        dc.b $1F,$3A,$3B,$FF
        even

AnimSonic_LookUp:
        dc.b    $3F,  5,$FF
        even

AnimSonic_LookDown:
        dc.b    $3F,$39,$FF
        even

AnimSonic_Squish1:
        dc.b    $3F,$33,$FF
        even    

AnimSonic_Squish2:
        dc.b    $3F,$34,$FF
        even    

AnimSonic_Squish3:
        dc.b    $3F,$35,$FF
        even    

AnimSonic_Squish4:
        dc.b    $3F,$36,$FF
        even    

AnimSonic_Skid:  
        dc.b    7,$37,$38,$FF 
        even    

AnimSonic_Floating:
        dc.b    7,$3C,$3F,$FF  
        even    

AnimSonic_FallingSpin:
        dc.b    7,$3C,$3D,$53,$3E,$54,$FF
        even    

AnimSonic_Spring:
        dc.b    $2F,$40,$FD
        even    

AnimSonic_HoldPole:
        dc.b    4,$41,$42,$FF
        even    

AnimSonic_Victory1:
        dc.b    $F,$43,$43,$43,$FE,  1 
        even    

AnimSonic_Victory2:
        dc.b    $F,$43,$44,$FE,  1
        even    

AnimSonic_Unk1:
        dc.b    $3F,$49,$FF
        even    

AnimSonic_AirBubbleOld:
        dc.b    $3F,$4A,$FF
        even    

AnimSonic_FireDeath:
        dc.b    3,$4B,$FF
        even    

AnimSonic_Drown: 
        dc.b    3,$4C,$FF
        even    

AnimSonic_Death: 
        dc.b    3,$4D,$FF
        even    

AnimSonic_Unk2:  
        dc.b    3,$4E,$4F,$50,$51,$52,  0, $FE, 1
        even    

AnimSonic_Unk3:  
        dc.b    3,$55,$FF
        even    
