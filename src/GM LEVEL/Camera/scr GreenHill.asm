; ---------------------------------------------------------------------------
; Green Hill Zone parallax script
; ---------------------------------------------------------------------------

Scroll_GreenHill:                     
        move.w  camADiffX.w,d4          ; Get info from last execution
        ext.l   d4
        asl.l   #5,d4
        move.l  d4,d1
        asl.l   #1,d4
        add.l   d1,d4
        moveq   #0,d5
        bsr.w   _cameraBMoveDraw           ; Use as cam info inputs
        bsr.w   _cameraCSetX
        lea     hscroll.w,a1            ; Start calculating new scroll info
        move.w  cameraAPosY.w,d0
        andi.w  #$7FF,d0
        lsr.w   #5,d0
        neg.w   d0
        addi.w  #38,d0
        move.w  d0,cameraCPosY.w
        move.w  d0,d4
        bsr.w   _cameraBUserSetY
        move.w  cameraBPosY.w,mainBPosY.w
        move.w  #112-1,d1               ; Set abs. size of initial scroll
        sub.w   d4,d1                   ; Subtract how far upwards we are
        move.w  cameraAPosX.w,d0

        cmpi.b  #GAMEMD_TITLE,gamemode.w
        bne.s   .NotAutoScroll

        moveq   #0,d0

.NotAutoScroll:                        
        neg.w   d0
        swap    d0
        move.w  cameraBPosX.w,d0
        neg.w   d0

.Clouds:                               
        move.l  d0,(a1)+                ; Write scroll values
        dbf     d1,.Clouds
        move.w  #40-1,d1
        move.w  cameraCPosX.w,d0
        neg.w   d0

.Cliffs:                               
        move.l  d0,(a1)+
        dbf     d1,.Cliffs
        move.w  cameraCPosX.w,d0
        addi.w  #0,d0
        move.w  cameraAPosX.w,d2
        addi.w  #-$200,d2
        sub.w   d0,d2
        ext.l   d2
        asl.l   #8,d2
        divs.w  #$68,d2
        ext.l   d2
        asl.l   #8,d2
        moveq   #0,d3
        move.w  d0,d3
        move.w  #72-1,d1
        add.w   d4,d1

.SkewWater:                            
        move.w  d3,d0
        neg.w   d0
        move.l  d0,(a1)+
        swap    d3
        add.l   d2,d3
        swap    d3
        dbf     d1,.SkewWater
        rts