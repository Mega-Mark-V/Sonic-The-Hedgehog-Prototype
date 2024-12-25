; ---------------------------------------------------------------------------
; Main Scrolling Library (wip)
; ---------------------------------------------------------------------------
; local enums

DRAW.TOP        =  0
DRAW.BTM        =  1
DRAW.LEFT       =  2
DRAW.RIGHT      =  3

PLANE_A         =  $C000
PLANE_B         =  $E000

; ---------------------------------------------------------------------------
; Updates camera-B X and Y and sets flags for block redraw
; 
; INPUTS:
;       d4.l = X Delta
;       d5.l = Y Delta
; ---------------------------------------------------------------------------

_cameraBMoveDraw:                          
        move.l  cameraBPosX.w,d2
        move.l  d2,d0
        add.l   d4,d0
        move.l  d0,cameraBPosX.w

        move.l  d0,d1
        swap    d1
        andi.w  #16,d1
        move.b  cameraBblkX.w,d3
        eor.b   d3,d1
        bne.s   .XNotMet
        eori.b  #16,cameraBblkX.w
        sub.l   d2,d0
        bpl.s   .SetRight
        bset    #DRAW.LEFT,cameraBDraw.w
        bra.s   .XNotMet

.SetRight:                             
        bset    #DRAW.RIGHT,cameraBDraw.w

.XNotMet:                              
        move.l  cameraBPosY.w,d3
        move.l  d3,d0
        add.l   d5,d0
        move.l  d0,cameraBPosY.w

        move.l  d0,d1
        swap    d1
        andi.w  #16,d1
        move.b  cameraBblkY.w,d2
        eor.b   d2,d1
        bne.s   .YNotMet
        eori.b  #16,cameraBblkY.w
        sub.l   d3,d0
        bpl.s   .SetBtm
        bset    #DRAW.TOP,cameraBDraw.w
        rts

.SetBtm:                               
        bset    #DRAW.BTM,cameraBDraw.w

.YNotMet:                              
        rts

; ---------------------------------------------------------------------------
; Updates camera-B X and Y, and set for block redraw on Y only
; 
; INPUTS:
;       d4.l = X Delta
;       d5.l = Y Delta
; ---------------------------------------------------------------------------

_cameraBMoveDrawY:                      
        move.l  cameraBPosX.w,d2        ; Apply X scroll delta
        move.l  d2,d0
        add.l   d4,d0
        move.l  d0,cameraBPosX.w

        move.l  cameraBPosY.w,d3        ; Apply Y scroll delta
        move.l  d3,d0
        add.l   d5,d0
        move.l  d0,cameraBPosY.w

        move.l  d0,d1
        swap    d1
        andi.w  #16,d1
        move.b  cameraBblkY.w,d2
        eor.b   d2,d1
        bne.s   .NotMet
        eori.b  #16,cameraBblkY.w
        sub.l   d3,d0
        bpl.s   .SetBtm
        bset    #DRAW.TOP,cameraBDraw.w
        rts

.SetBtm:                               
        bset    #DRAW.BTM,cameraBDraw.w

.NotMet:                               
        rts

; ---------------------------------------------------------------------------
; Replaces camera-B Y position with user calculated input.
; Checks old value for block redraw
;
; INPUTS:
;       d0.w    New camera-B Y pos. 
; ---------------------------------------------------------------------------

_cameraBUserSetY:                           
        move.w  cameraBPosY.w,d3
        move.w  d0,cameraBPosY.w
        move.w  d0,d1
        andi.w  #16,d1
        move.b  cameraBblkY.w,d2
        eor.b   d2,d1
        bne.s   .NotMet
        eori.b  #16,cameraBblkY.w
        sub.w   d3,d0
        bpl.s   .SetBtm
        bset    #DRAW.TOP,cameraBDraw.w
        rts

.SetBtm:                               
        bset    #DRAW.BTM,cameraBDraw.w

.NotMet:                               
        rts

; ---------------------------------------------------------------------------
; Updates camera-C X position based on camera-A diff.
; 
; PARAMETERS:
;       d4.l = X Delta
;       d5.l = Y Delta
; ---------------------------------------------------------------------------

_cameraCSetX:                           
        move.w  cameraCPosX.w,d2
        move.w  cameraCPosY.w,d3

        move.w  cameraDiffX.w,d0
        ext.l   d0
        asl.l   #7,d0
        add.l   d0,cameraCPosX.w

        move.w  cameraCPosX.w,d0
        andi.w  #16,d0
        move.b  cameraCblkX.w,d1
        eor.b   d1,d0
        bne.s   .NotMet
        eori.b  #16,cameraCblkX.w
        move.w  cameraCPosX.w,d0
        sub.w   d2,d0
        bpl.s   .SetRight
        bset    #DRAW.LEFT,cameraCDraw.w
        bra.s   .NotMet

.SetRight:                             
        bset    #DRAW.RIGHT,cameraCDraw.w

.NotMet:                               
        rts

; ---------------------------------------------------------------------------
; Main functions to handle drawing/redrawing scrolling tiles
; Will redraw blocks based on the above "_camera" subroutines
;
; This code is seriously complex and does a lot of VDP interfacing.
; ---------------------------------------------------------------------------
; Register equates to make this a bit easier to read

@VDPCTRL        equr    a5    
@VDPDATA        equr    a6

cam.X           =       0
cam.Y           =       4

; ---------------------------------------------------------------------------      
; Only draw cameras B and C for the titlescreen
; ---------------------------------------------------------------------------


_titleDrawMovingTiles:          

        lea     VDPCTRL,a5
        lea     VDPDATA,a6

        lea     cameraBDraw.w,a2
        lea     cameraBPosX.w,a3
        lea     layoutB.w,a4
        move.w  #$6000,d2
        bsr.w   _drawCamB

        lea     cameraCDraw.w,a2
        lea     cameraCPosX.w,a3
        bra.w   _drawCamC

; ---------------------------------------------------------------------------
; Only draw cameras B and C for the titlescreen
; ---------------------------------------------------------------------------

DrawMovingTiles:    

        lea     VDPCTRL,a5
        lea     VDPDATA,a6

        lea     cameraBDraw.w,a2
        lea     cameraBPosX.w,a3
        lea     layoutB.w,a4
        move.w  #$6000,d2
        bsr.w   _drawCamB

        lea     cameraCDraw.w,a2
        lea     cameraCPosX.w,a3
        bra.w   _drawCamC

        lea     cameraADraw.w,a2
        lea     cameraAPosX.w,a3
        lea     layoutA.w,a4
        move.w  #$4000,d2
        ; Falls into _drawCamA


; ---------------------------------------------------------------------------
; Check draw flags in camera A and draw tiles if set
; ---------------------------------------------------------------------------

_drawCamA:
        tst.b   (a2)
        beq.s   .Exit
        bclr    #DRAW.TOP,(a2)
        beq.s   .NotTop
        moveq   #-16,d4
        moveq   #-16,d5
        bsr.w   _drawCalcAddrHi
        moveq   #-16,d4
        moveq   #-16,d5
        bsr.w   _drawRow

.NotTop:                               
        bclr    #DRAW.BTM,(a2)
        beq.s   .NotBtm
        move.w  #224,d4
        moveq   #-16,d5
        bsr.w   _drawCalcAddrHi
        move.w  #224,d4
        moveq   #-16,d5
        bsr.w   _drawRow

.NotBtm:                               
        bclr    #DRAW.LEFT,(a2)
        beq.s   .NotLeft
        moveq   #-16,d4
        moveq   #-16,d5
        bsr.w   _drawCalcAddrHi
        moveq   #-16,d4
        moveq   #-16,d5
        bsr.w   _drawColumn

.NotLeft:                              
        bclr    #DRAW.RIGHT,(a2)
        beq.s   .Exit
        moveq   #-16,d4
        move.w  #320,d5
        bsr.w   _drawCalcAddrHi
        moveq   #-16,d4
        move.w  #320,d5
        bsr.w   _drawColumn

.Exit:                           
        rts

; ---------------------------------------------------------------------------
; Check draw flags in camera B and draw tiles if set
; ---------------------------------------------------------------------------

_drawCamB:                              
        tst.b   (a2)
        beq.w   .Exit
        bclr    #DRAW.TOP,(a2)
        beq.s   .NotTop
        moveq   #-16,d4
        moveq   #-16,d5
        bsr.w   _drawCalcAddrHi
        moveq   #-16,d4
        moveq   #-16,d5
        moveq   #32-1,d6
        bsr.w   _drawRow.UserSz

.NotTop:                               
        bclr    #DRAW.BTM,(a2)
        beq.s   .NotBtm
        move.w  #224,d4
        moveq   #-16,d5
        bsr.w   _drawCalcAddrHi
        move.w  #224,d4
        moveq   #-16,d5
        moveq   #32-1,d6
        bsr.w   _drawRow.UserSz

.NotBtm:                               
        bclr    #DRAW.LEFT,(a2)
        beq.s   .NotLeft
        moveq   #-16,d4
        moveq   #-16,d5
        bsr.w   _drawCalcAddrHi
        moveq   #-16,d4
        moveq   #-16,d5
        move.w  cameraLimits.w,d6
        move.w  cam.Y(a3),d1
        andi.w  #$FFF0,d1
        sub.w   d1,d6
        blt.s   .NotLeft
        lsr.w   #4,d6
        cmpi.w  #16-1,d6
        blo.s   .CapLeft
        moveq   #16-1,d6

.CapLeft:                               
        bsr.w   _drawColumn.UserSz

.NotLeft:                              
        bclr    #DRAW.RIGHT,(a2)
        beq.s   .Exit
        moveq   #-16,d4
        move.w  #320,d5
        bsr.w   _drawCalcAddrHi
        moveq   #-16,d4
        move.w  #320,d5
        move.w  cameraLimits.w,d6
        move.w  cam.Y(a3),d1
        andi.w  #$FFF0,d1
        sub.w   d1,d6
        blt.s   .Exit
        lsr.w   #4,d6
        cmpi.w  #16-1,d6
        blo.s   .CapRight
        moveq   #16-1,d6

.CapRight:                              
        bsr.w   _drawColumn.UserSz

.Exit:                                 
        rts

; ---------------------------------------------------------------------------
; Check draw flags in camera C and draw tiles if set
; ---------------------------------------------------------------------------


_drawCamC:                              
        tst.b   (a2)
        beq.w   .Exit
        bclr    #2,(a2)
        beq.s   .SkipRedraw
        cmpi.w  #$10,cam.X(a3)
        bcs.s   .SkipRedraw
        move.w  (cameraLimits).w,d4
        move.w  cam.Y(a3),d1
        andi.w  #$FFF0,d1
        sub.w   d1,d4
        move.w  d4,-(sp)
        moveq   #-16,d5
        bsr.w   _drawCalcAddrHi
        move.w  (sp)+,d4
        moveq   #-16,d5
        move.w  (cameraLimits).w,d6
        move.w  cam.Y(a3),d1
        andi.w  #$FFF0,d1
        sub.w   d1,d6
        blt.s   .SkipRedraw
        lsr.w   #4,d6
        subi.w  #$E,d6
        bcc.s   .SkipRedraw
        neg.w   d6
        bsr.w   _drawColumn.UserSz

.SkipRedraw:                           
        bclr    #3,(a2)
        beq.s   .Exit
        move.w  cameraLimits.w,d4
        move.w  cam.Y(a3),d1
        andi.w  #$FFF0,d1
        sub.w   d1,d4
        move.w  d4,-(sp)
        move.w  #320,d5
        bsr.w   _drawCalcAddrHi
        move.w  (sp)+,d4
        move.w  #320,d5
        move.w  cameraLimits.w,d6
        move.w  cam.Y(a3),d1
        andi.w  #$FFF0,d1
        sub.w   d1,d6
        blt.s   .Exit
        lsr.w   #4,d6
        subi.w  #$E,d6
        bcc.s   .Exit
        neg.w   d6
        bsr.w   _drawColumn.UserSz

.Exit:                                 
                rts


; =============== S U B R O U T I N E =======================================


_drawCamZ:
        tst.b   (a2)
        beq.s   .Exit
        bclr    #2,(a2)
        beq.s   .AlreadyDrawn
        move.w  #208,d4
        move.w  cam.Y(a3),d1
        andi.w  #$FFF0,d1
        sub.w   d1,d4
        move.w  d4,-(sp)
        moveq   #-16,d5
        bsr.w   _drawCalcAddrLo
        move.w  (sp)+,d4
        moveq   #-16,d5
        moveq   #2,d6
        bsr.w   _drawColumn.UserSz

.AlreadyDrawn:                         
        bclr    #3,(a2)
        beq.s   .Exit
        move.w  #208,d4
        move.w  cam.Y(a3),d1
        andi.w  #$FFF0,d1
        sub.w   d1,d4
        move.w  d4,-(sp)
        move.w  #320,d5
        bsr.w   _drawCalcAddrLo
        move.w  (sp)+,d4
        move.w  #320,d5
        moveq   #2,d6
        bsr.w   _drawColumn.UserSz

.Exit:                                 
        rts
; End of function _drawCamZ


; ---------------------------------------------------------------------------
; VDP Block Write Interface functions
; ---------------------------------------------------------------------------
; INPUTS:
;       d0.l  =  VRAM addr. 
;       d2.w  =  VRAMWRITE + nametable addr.
;       d4.w  =  Y point
;       d5.w  =  X point
;       d6.w  =  Amount of tiles to draw (dbf)
;
;       a4    =  Layout addr.
;
;       a5    =  VDPCTRL (as equr)
;       a6    =  VDPDATA (as equr)  
; ---------------------------------------------------------------------------

ROWDELTA         = $800000               ; Tile row delta

; ---------------------------------------------------------------------------
; Function to draw 16x16 blocks row-wise
; ---------------------------------------------------------------------------

_drawRow:                               
        moveq   #((320+(16*2)/16)-1,d6  ; Draw width of screen + 2 blocks

.UserSz:                            
        move.l  #TILEROW,d7
        move.l  d0,d1

.Loop:                                 
        movem.l d4-d5,-(sp)
        bsr.w   _getBlock
        move.l  d1,d0
        bsr.w   _drawBlock
        addq.b  #4,d1
        andi.b  #$7F,d1
        movem.l (sp)+,d4-d5
        addi.w  #16,d5
        dbf     d6,.Loop
        rts


; ---------------------------------------------------------------------------
; Function to draw 16x16 blocks column-wise to the screen
; ---------------------------------------------------------------------------


_drawColumn:                            
        moveq   #(256/16)-1,d6          ; Draw entire height of VDP plane

.UserSz:                         
        move.l  #TILEROW,d7
        move.l  d0,d1

.Loop:                                 
        movem.l d4-d5,-(sp)
        bsr.w   _getBlock
        move.l  d1,d0
        bsr.w   _drawBlock
        addi.w  #256,d1
        andi.w  #$FFF,d1
        movem.l (sp)+,d4-d5
        addi.w  #16,d4
        dbf     d6,.Loop
        rts

; ---------------------------------------------------------------------------
; Function to draw a 16x16 block to the screen
; ---------------------------------------------------------------------------

_drawBlock:                             
        or.w    d2,d0
        swap    d0
        btst    #4,(a0)
        bne.s   .FlipY
        btst    #3,(a0)
        bne.s   .FlipX
        move.l  d0,(@VDPCTRL)
        move.l  (a1)+,(@VDPDATA)
        add.l   d7,d0
        move.l  d0,(@VDPCTRL)
        move.l  (a1)+,(@VDPDATA)
        rts

.FlipX:                                
        move.l  d0,(@VDPCTRL)
        move.l  (a1)+,d4
        eori.l  #$8000800,d4
        swap    d4
        move.l  d4,(@VDPDATA)
        add.l   d7,d0           ; Try next row
        move.l  d0,(@VDPCTRL)
        move.l  (a1)+,d4
        eori.l  #$8000800,d4
        swap    d4
        move.l  d4,(@VDPDATA)
        rts

.FlipY:                                
        btst    #3,(a0)
        bne.s   .FlipXY
        move.l  d0,(@VDPCTRL)
        move.l  (a1)+,d5
        move.l  (a1)+,d4
        eori.l  #$10001000,d4
        move.l  d4,(@VDPDATA)
        add.l   d7,d0
        move.l  d0,(@VDPCTRL)
        eori.l  #$10001000,d5
        move.l  d5,(@VDPDATA)
        rts

.FlipXY:                               
        move.l  d0,(@VDPCTRL)
        move.l  (a1)+,d5
        move.l  (a1)+,d4
        eori.l  #$18001800,d4
        swap    d4
        move.l  d4,(@VDPDATA)
        add.l   d7,d0
        move.l  d0,(@VDPCTRL)
        eori.l  #$18001800,d5
        swap    d5
        move.l  d5,(@VDPDATA)
        rts

; ---------------------------------------------------------------------------
; Unused function to "highlight" drawn blocks by incrementing their palette
;
; This may have been used with the above function to see if block orientation
; is being read correctly. Ignores flipping bits
; ---------------------------------------------------------------------------


_drawHighlight:
        rts
        move.l  d0,(@VDPCTRL)
        move.w  #$2000,d5
        move.w  (a1)+,d4
        add.w   d5,d4
        move.w  d4,(@VDPDATA)
        move.w  (a1)+,d4
        add.w   d5,d4
        move.w  d4,(@VDPDATA)
        add.l   d7,d0
        move.l  d0,(@VDPCTRL)
        move.w  (a1)+,d4
        add.w   d5,d4
        move.w  d4,(@VDPDATA)
        move.w  (a1)+,d4
        add.w   d5,d4
        move.w  d4,(@VDPDATA)
        rts

; ---------------------------------------------------------------------------
; Function to get the current block at a given screen coordinate
;
; INPUTS:
;       d4.w  =  Y point
;       d5.w  =  X point
;       a3    =  Selected camera
;       a4    =  Level layout addr.     
; ---------------------------------------------------------------------------

_getBlock:                           
        lea     levelBlocks.w,a1
        add.w   cam.Y(a3),d4
        add.w   cam.X(a3),d5
        move.w  d4,d3
        lsr.w   #1,d3
        andi.w  #$380,d3

        lsr.w   #3,d5
        move.w  d5,d0
        lsr.w   #5,d0
        andi.w  #$7F,d0

        add.w   d3,d0
        moveq   #-1,d3
        move.b  (a4,d0.w),d3
        andi.b  #$7F,d3
        beq.s   .Exit

        subq.b  #1,d3
        ext.w   d3
        ror.w   #7,d3

        add.w   d4,d4
        andi.w  #$1E0,d4

        andi.w  #$1E,d5

        add.w   d4,d3
        add.w   d5,d3
        movea.l d3,a0
        move.w  (a0),d3

        andi.w  #$3FF,d3
        lsl.w   #3,d3
        adda.w  d3,a1

.Exit:                                 
        rts


; ---------------------------------------------------------------------------      
; Calculate address in high VRAM nametables ($8000)
; ---------------------------------------------------------------------------

_drawCalcAddrHi:                        
        add.w   cam.Y(a3),d4
        add.w   cam.X(a3),d5
        andi.w  #$F0,d4
        andi.w  #$1F0,d5
        lsl.w   #4,d4
        lsr.w   #2,d5
        add.w   d5,d4
        moveq   #$C000>>14,d0
        swap    d0
        move.w  d4,d0
        rts


; ---------------------------------------------------------------------------      
; Calculate address in low VRAM nametables ($8000) (unused, see _drawCamZ)
; ---------------------------------------------------------------------------

_drawCalcAddrLo:                        
        add.w   cam.Y(a3),d4
        add.w   cam.X(a3),d5
        andi.w  #$F0,d4
        andi.w  #$1F0,d5
        lsl.w   #4,d4
        lsr.w   #2,d5
        add.w   d5,d4
        moveq   #$8000>>14,d0
        swap    d0
        move.w  d4,d0
        rts