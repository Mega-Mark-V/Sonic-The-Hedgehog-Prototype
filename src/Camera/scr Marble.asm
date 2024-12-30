; ---------------------------------------------------------------------------
; Marble Zone scrolling/parallax
; ---------------------------------------------------------------------------

Scroll_Marble:                        
        move.w  camADiffX.w,d4
        ext.l   d4
        asl.l   #6,d4
        move.l  d4,d1
        asl.l   #1,d4
        add.l   d1,d4
        moveq   #0,d5
        bsr.w   _cameraBSetXY
        move.w  #$200,d0
        move.w  cameraAPosY.w,d1
        subi.w  #456,d1
        bcs.s   .CapScrollY
        move.w  d1,d2
        add.w   d1,d1
        add.w   d2,d1
        asr.w   #2,d1
        add.w   d1,d0

.CapScrollY:                           
        move.w  d0,cameraCPosY.w
        bsr.w   _cameraBSetY
        move.w  cameraBPosY.w,mainBPosY.w
        lea     hscroll.w,a1
        move.w  #224-1,d1
        move.w  cameraAPosX.w,d0
        neg.w   d0
        swap    d0
        move.w  cameraBPosX.w,d0
        neg.w   d0

.WriteHScroll:                         
        move.l  d0,(a1)+
        dbf     d1,.WriteHScroll
        rts