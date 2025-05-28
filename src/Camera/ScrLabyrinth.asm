; ---------------------------------------------------------------------------
; Labyrinth Zone scrolling/parallax (placeholder)
; ---------------------------------------------------------------------------
Scroll_Labyrinth:                     
        lea     hscroll.w,a1
        move.w  #224-1,d1
        move.w  cameraAPosX.w,d0
        neg.w   d0
        swap    d0
        move.w  cameraBPosX.w,d0
        move.w  #0,d0
        neg.w   d0

.WriteHScroll:                         
        move.l  d0,(a1)+
        dbf     d1,.WriteHScroll
        rts