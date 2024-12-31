; ---------------------------------------------------------------------------
; Camera System main program library
; ---------------------------------------------------------------------------
; local enums

DRAW.TOP        =  0
DRAW.BTM        =  1
DRAW.LEFT       =  2
DRAW.RIGHT      =  3

PLANE_A         =  $C000
PLANE_B         =  $E000

; ---------------------------------------------------------------------------

CameraScroll:                           
        tst.b   cameraLock.w
        bne.s   .SetBGScroll
        tst.b   camAResetX.w
        bne.w   _cameraAResetX
        bsr.w   _cameraASetX

.ReturnX:                         
        tst.b   camAResetY.w
        bne.w   _cameraAResetY
        bsr.w   _cameraASetY

.ReturnY:                         
        bsr.w   LevelEvents

.SetBGScroll:                          
        move.w  cameraAPosX.w,mainAPosX.w
        move.w  cameraAPosY.w,mainAPosY.w
        move.w  cameraBPosX.w,mainBPosX.w
        move.w  cameraBPosY.w,mainBPosY.w
        move.w  cameraZPosX.w,mainZPosX.w
        move.w  cameraZPosY.w,mainZPosY.w
        moveq   #0,d0
        move.b  zone.w,d0
        add.w   d0,d0
        move.w  .ScrollIndex(pc,d0.w),d0
        jmp     .ScrollIndex(pc,d0.w)

; ---------------------------------------------------------------------------

.ScrollIndex:                        
        dc.w Scroll_GreenHill-.ScrollIndex
        dc.w Scroll_Labyrinth-.ScrollIndex
        dc.w Scroll_Marble   -.ScrollIndex
        dc.w Scroll_StarLight-.ScrollIndex
        dc.w Scroll_Sparkling-.ScrollIndex
        dc.w Scroll_ClockWork-.ScrollIndex

; ---------------------------------------------------------------------------
; Parallax/Scrolling scripts
; ---------------------------------------------------------------------------

        include "Camera/scr GreenHill.asm"
        include "Camera/scr Labyrinth.asm"
        include "Camera/scr Marble.asm"
        include "Camera/scr StarLight.asm"        
        include "Camera/scr Sparkling.asm"   
        include "Camera/scr ClockWork.asm"   


; ---------------------------------------------------------------------------
; Set camera A X-pos from player position and argument variables
; ---------------------------------------------------------------------------

_cameraASetX:                           
        move.w  cameraAPosX.w,d4
        bsr.s   .GetPlayPos
        move.w  cameraAPosX.w,d0
        andi.w  #16,d0
        move.b  cameraAblkX.w,d1
        eor.b   d1,d0
        bne.s   .Exit
        eori.b  #16,cameraAblkX.w
        move.w  cameraAPosX.w,d0
        sub.w   d4,d0
        bpl.s   .DrawFwd
        bset    #DRAW.LEFT,camDrawA.w
        rts

.DrawFwd:                              
        bset    #DRAW.RIGHT,camDrawA.w

.Exit:                                 
        rts

; --------------------------------------

.GetPlayPos:                           
        move.w  objSlot00+obj.X.w,d0
        sub.w   cameraAPosX.w,d0
        subi.w  #144,d0
        bcs.s   .BehindMid
        subi.w  #16,d0
        bcc.s   .AheadMid
        clr.w   camADiffX.w
        rts

.AheadMid:                             
        cmpi.w  #16,d0
        bcs.s   .InScrCenter
        move.w  #16,d0

.InScrCenter:                          
        add.w   cameraAPosX.w,d0
        cmp.w   limitARight.w,d0
        blt.s   .LimsNotHit
        move.w  limitARight.w,d0

.LimsNotHit:                           
        move.w  d0,d1
        sub.w   cameraAPosX.w,d1
        asl.w   #8,d1
        move.w  d0,cameraAPosX.w
        move.w  d1,camADiffX.w
        rts

.BehindMid:                            
        add.w   cameraAPosX.w,d0
        cmp.w   limitALeft.w,d0
        bgt.s   .LimsNotHit
        move.w  limitALeft.w,d0
        bra.s   .LimsNotHit

; --------------------------------------
; Orphaned unused code for what looks to adjust for an X-center shift?
; Also maybe autoscrolling? But unlikely (see similar code below this)
; Unknown. 
; --------------------------------------

.unkCenterAdj:
        tst.w   d0
        bpl.s   .AutoFwd
        move.w  #-2,d0
        bra.s   .BehindMid

.AutoFwd:                              
        move.w  #2,d0
        bra.s   .AheadMid

; ---------------------------------------------------------------------------
; Set camera A Y-pos from player position and argument variables
; ---------------------------------------------------------------------------

_cameraASetY:                           
        moveq   #0,d1
        move.w  objSlot00+obj.Y.w,d0
        sub.w   cameraAPosY.w,d0
        btst    #PHYS.ROLLING,(objSlot00+obj.Status).w
        beq.s   .NotRolling
        subq.w  #5,d0

.NotRolling:                           
        btst    #PHYS.AIRBORNE,(objSlot00+obj.Status).w
        beq.s   .OnGround
        addi.w  #32,d0
        sub.w   camACenterY.w,d0
        bcs.s   .AirNotCentered
        subi.w  #64,d0
        bcc.s   .AirNotCentered
        tst.b   vscrollFlag.w
        bne.s   .DoVScroll
        bra.s   .NoVScroll

; --------------------------------------

.OnGround:                             
        sub.w   camACenterY.w,d0
        bne.s   .GndNotCentered
        tst.b   vscrollFlag.w
        bne.s   .DoVScroll

.NoVScroll:                            
        clr.w   camADiffY.w
        rts


.GndNotCentered:                       
        cmpi.w  #96,camACenterY.w
        bne.s   .CenterShifted
        move.w  #$600,d1
        cmpi.w  #6,d0
        bgt.s   .DwnCenter
        cmpi.w  #-6,d0
        blt.s   .UpCenter
        bra.s   .InMidpoint

.CenterShifted:                        
        move.w  #$200,d1
        cmpi.w  #2,d0
        bgt.s   .DwnCenter
        cmpi.w  #-2,d0
        blt.s   .UpCenter
        bra.s   .InMidpoint

; --------------------------------------

.AirNotCentered:                       
        move.w  #$1000,d1
        cmpi.w  #16,d0
        bgt.s   .DwnCenter
        cmpi.w  #-16,d0
        blt.s   .UpCenter
        bra.s   .InMidpoint

.DoVScroll:                            
        moveq   #0,d0
        move.b  d0,vscrollFlag.w

.InMidpoint:                           
        moveq   #0,d1
        move.w  d0,d1
        add.w   cameraAPosY.w,d1
        tst.w   d0
        bpl.w   .UnderMidpoint
        bra.w   .AboveMidpoint

; --------------------------------------

.UpCenter:                             
        neg.w   d1
        ext.l   d1
        asl.l   #8,d1
        add.l   cameraAPosY.w,d1
        swap    d1

.AboveMidpoint:                        
        cmp.w   limitAUp.w,d1
        bgt.s   .SetDrawFlags
        move.w  limitAUp.w,d1
        bra.s   .SetDrawFlags

; --------------------------------------

.DwnCenter:                            
        ext.l   d1
        asl.l   #8,d1
        add.l   cameraAPosY.w,d1
        swap    d1

.UnderMidpoint:                        
        cmp.w   limitADown.w,d1
        blt.s   .SetDrawFlags
        move.w  limitADown.w,d1

.SetDrawFlags:                         
        move.w  cameraAPosY.w,d4
        swap    d1
        move.l  d1,d3
        sub.l   cameraAPosY.w,d3
        ror.l   #8,d3
        move.w  d3,camADiffY.w
        move.l  d1,cameraAPosY.w
        move.w  cameraAPosY.w,d0
        andi.w  #16,d0
        move.b  cameraAblkY.w,d1
        eor.b   d1,d0
        bne.s   .NotMet
        eori.b  #16,cameraAblkY.w
        move.w  cameraAPosY.w,d0
        sub.w   d4,d0
        bpl.s   .SetBtmDraw
        bset    #DRAW.TOP,camDrawA.w
        rts
.SetBtmDraw:                           
        bset    #DRAW.BTM,camDrawA.w

.NotMet:                               
        rts

; ---------------------------------------------------------------------------
; Reset camA X-position
; ---------------------------------------------------------------------------

_cameraAResetX: 
        move.w  limitALeft.w,d0
        moveq   #1,d1
        sub.w   cameraAPosX.w,d0
        beq.s   .LimitMet
        bpl.s   .NotMet
        moveq   #-1,d1

.NotMet:
        add.w   d1,cameraAPosX.w
        move.w  d1,d0

.LimitMet:
        move.w  d0,camADiffX.w
        bra.w  CameraScroll.ReturnX     ; Return to CameraScroll

; ---------------------------------------------------------------------------
; Reset camA Y-position
; ---------------------------------------------------------------------------

_cameraAResetY:                         
        move.w  limitAUp.w,d0
        addi.w  #32,d0
        moveq   #1,d1
        sub.w   cameraAPosY.w,d0
        beq.s   .LimitMet
        bpl.s   .NotMet
        moveq   #-1,d1

.NotMet:                               
        add.w   d1,cameraAPosY.w
        move.w  d1,d0

.LimitMet:                             
        move.w  d0,camADiffY.w
        bra.w   CameraScroll.ReturnY     ; Return to CameraScroll

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
        bset    #DRAW.LEFT,camDrawB.w
        bra.s   .XNotMet

.SetRight:                             
        bset    #DRAW.RIGHT,camDrawB.w

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
        bset    #DRAW.TOP,camDrawB.w
        rts

.SetBtm:                               
        bset    #DRAW.BTM,camDrawB.w

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
        bset    #DRAW.TOP,camDrawB.w
        rts

.SetBtm:                               
        bset    #DRAW.BTM,camDrawB.w

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
        bset    #DRAW.TOP,camDrawB.w
        rts

.SetBtm:                               
        bset    #DRAW.BTM,camDrawB.w

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
        bset    #DRAW.LEFT,camDrawC.w
        bra.s   .NotMet

.SetRight:                             
        bset    #DRAW.RIGHT,camDrawC.w

.NotMet:                               
        rts

; ---------------------------------------------------------------------------
; Main functions to handle drawing/redrawing scrolling tiles
; Will redraw blocks based on the above "_camera" subroutines
;
; This code is seriously complex and does a lot of VDP interfacing.
; ---------------------------------------------------------------------------
; Register equates to make this a bit easier to read

@VDPCTRL:       equr    a5    
@VDPDATA:       equr    a6

cam.X           =       0
cam.Y           =       4

; ---------------------------------------------------------------------------      
; Only draw cameras B and C for the titlescreen
; ---------------------------------------------------------------------------


_titleDrawCams:          

        lea     VDPCTRL,a5
        lea     VDPDATA,a6

        lea     camDrawB.w,a2
        lea     cameraBPosX.w,a3
        lea     layoutB.w,a4
        move.w  #$6000,d2
        bsr.w   _drawCamB

        lea     camDrawC.w,a2
        lea     cameraCPosX.w,a3
        bra.w   _drawCamC

; ---------------------------------------------------------------------------
; Draw Cameras B, C, and A in that order. 
; ---------------------------------------------------------------------------

DrawCameras:    

        lea     VDPCTRL,a5
        lea     VDPDATA,a6

        lea     camDrawB.w,a2
        lea     cameraBPosX.w,a3
        lea     layoutB.w,a4
        move.w  #$6000,d2
        bsr.w   _drawCamB

        lea     camDrawC.w,a2
        lea     cameraCPosX.w,a3
        bra.w   _drawCamC

        lea     camDrawA.w,a2
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
        move.w  cameraLimits.w,d4
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


; ---------------------------------------------------------------------------
; Check draw flags in camera Z and draw tiles if set (Unused)
; This only draws 3 blocks from the bottom of the screen
; It also uses a lower nametable address ($8000 or $A000)
; See INTERRUPTS.68k --> UNUSED_HBLANK2
; ---------------------------------------------------------------------------


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

TILEROW         = $800000               ; Tile row delta

; ---------------------------------------------------------------------------
; Function to draw 16x16 blocks row-wise
; ---------------------------------------------------------------------------

_drawRow:                               
        moveq   #22-1,d6  ;      Draw width of screen + 2 blocks

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
        moveq   #16-1,d6          ; Draw entire height of VDP plane

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