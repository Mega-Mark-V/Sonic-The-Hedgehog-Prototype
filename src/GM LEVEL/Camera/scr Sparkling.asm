; ---------------------------------------------------------------------------
; Sparkling Zone scrolling/parallax (basic/placeholder)
; ---------------------------------------------------------------------------

Scroll_Sparkling:                     
        move.w  camADiffX.w,d4
        ext.l   d4
        asl.l   #6,d4
        move.w  camADiffY.w,d5
        ext.l   d5
        asl.l   #4,d5
        move.l  d5,d1
        asl.l   #1,d5
        add.l   d1,d5
        bsr.w   _cameraBSetXY
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