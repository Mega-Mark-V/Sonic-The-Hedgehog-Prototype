; ---------------------------------------------------------------------------
; Star Light Zone scrolling/parallax
; ---------------------------------------------------------------------------

Scroll_StarLight:                     
        move.w  camADiffX.w,d4
        ext.l   d4
        asl.l   #7,d4
        move.w  camADiffY.w,d5
        ext.l   d5
        asl.l   #7,d5
        bsr.w   _cameraBMoveDrawY
        move.w  cameraBPosY.w,mainBPosY.w
        bsr.w   _scrslzSetupSects
        lea     hscrollWork.w,a2              ; this is the only zone to use this buffer
        move.w  cameraBPosY.w,d0
        move.w  d0,d2
        subi.w  #$C0,d0
        andi.w  #$3F0,d0
        lsr.w   #3,d0
        lea     (a2,d0.w),a2
        lea     hscroll.w,a1
        move.w  #$E,d1
        move.w  cameraAPosX.w,d0
        neg.w   d0
        swap    d0
        andi.w  #$F,d2
        add.w   d2,d2
        move.w  (a2)+,d0
        jmp     .TransferAmount(pc,d2.w)

.Loop:                                 
        move.w  (a2)+,d0

.TransferAmount:
        move.l  d0,(a1)+
        move.l  d0,(a1)+
        move.l  d0,(a1)+
        move.l  d0,(a1)+
        move.l  d0,(a1)+
        move.l  d0,(a1)+
        move.l  d0,(a1)+
        move.l  d0,(a1)+
        move.l  d0,(a1)+
        move.l  d0,(a1)+
        move.l  d0,(a1)+
        move.l  d0,(a1)+
        move.l  d0,(a1)+
        move.l  d0,(a1)+
        move.l  d0,(a1)+
        move.l  d0,(a1)+
        dbf     d1,.Loop
        rts

; ---------------------------------------------------------------------------

_scrslzSetupSects:                    
        lea     hscrollWork.w,a1
        move.w  cameraAPosX.w,d2
        neg.w   d2
        move.w  d2,d0
        asr.w   #3,d0
        sub.w   d2,d0
        ext.l   d0
        asl.l   #4,d0
        divs.w  #28,d0
        ext.l   d0
        asl.l   #4,d0
        asl.l   #8,d0
        moveq   #0,d3
        move.w  d2,d3
        move.w  #28-1,d1

.Block1:                               
        move.w  d3,(a1)+
        swap    d3
        add.l   d0,d3
        swap    d3
        dbf     d1,.Block1
        move.w  d2,d0
        asr.w   #3,d0
        move.w  #5-1,d1

.Block2:                               
        move.w  d0,(a1)+
        dbf     d1,.Block2
        move.w  d2,d0
        asr.w   #2,d0
        move.w  #5-1,d1

.Block3:                               
        move.w  d0,(a1)+
        dbf     d1,.Block3
        move.w  d2,d0
        asr.w   #1,d0
        move.w  #30-1,d1

.Block4:                               
        move.w  d0,(a1)+
        dbf     d1,.Block4
        rts