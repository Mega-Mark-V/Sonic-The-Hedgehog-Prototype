; ---------------------------------------------------------------------------
; Object foot collision physics library for walking on level terrain
; This is also Sonic's main collision detection code. 
; ---------------------------------------------------------------------------

; ---------------------------------------------------------------------------
; local enums

PHYS.UPMAX      EQU     14              ; Max distances to register on floor
PHYS.DOWNMAX    EQU     -14             
PHYS.GRAVITY    EQU     56              ; Gravity delta

BLK.XFLIP       EQU     $B              ; Collision Bit flags in chunk data
BLK.YFLIP       EQU     $C
BLK.TOPSOLID    EQU     $D
BLK.BTMSOLID    EQU     $E

; ---------------------------------------------------------------------------

_physFootCollision:                     
        btst    #PHYS.PLATFORM,obj.Status(a0)
        beq.s   .NotOnPlatform
        moveq   #0,d0                   ; Clear sensor angle information
        move.b  d0,footFrontAngle.w
        move.b  d0,footBackAngle.w
        rts

.NotOnPlatform:                             
        moveq   #3,d0                   ;   ...flag foot sensors?
        move.b  d0,footFrontAngle.w
        move.b  d0,footBackAngle.w

        move.b  obj.Angle(a0),d0
        addi.b  #$20,d0                 ; Rotate unit circle 45 degrees
        andi.b  #$C0,d0                 ; Use top bits for orientation

        cmpi.b  #$40,d0                 ; $40 = 90 degrees
        beq.w   _physWalkWallLeft
        cmpi.b  #$80,d0                 ; $80 = 180 degrees
        beq.w   _physWalkCeiling
        cmpi.b  #$C0,d0                 ; $C0 = 270 degrees
        beq.w   _physWalkWallRight

        ; Otherwise, we're on the floor, so apply floor physics:

_physWalkFloor:

        ; ---- Get Primary sensor information

        move.w  obj.Y(a0),d2            
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.YRad(a0),d0         ; Get the bottom edge of the object's radius
        ext.w   d0                      ; and set as y input for subroutine branch
        add.w   d0,d2                   
        move.b  obj.XRad(a0),d0         ; Get right edge of the object's radius
        ext.w   d0                      ; and also set as x input for branch
        add.w   d0,d3
        lea     footFrontAngle.w,a4     ; Set angle output location in a4
        movea.w #16,a3                  ; Set block height
        move.w  #0,d6                   ; Set orientation
        moveq   #BLK.TOPSOLID,d5        ; Set Checking top solidity
        bsr.w   _physGetFloorAttr       ; Get floor distance and angle based on inputs

        move.w  d1,-(sp)                ; Push d1 (output distance) to stack

        ; ---- Get Secondary sensor information

        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.YRad(a0),d0         ; Same as above
        ext.w   d0
        add.w   d0,d2                   ; Y
        move.b  obj.XRad(a0),d0         
        ext.w   d0
        neg.w   d0                      ; Except get left edge of radius this time
        add.w   d0,d3                   ; X
        lea     footBackAngle.w,a4
        movea.w #16,a3                  ; Set block height
        move.w  #0,d6                   ; Set orientation
        moveq   #BLK.TOPSOLID,d5        ; Solidity bit
        bsr.w   _physGetFloorAttr

        move.w  (sp)+,d0                ; Pop output distance to d0 for input
        bsr.w   _physPickFoot           ; Pick foot sensor to stand on

        tst.w   d1
        beq.s   .OnFloor
        bpl.s   .AboveFloor

        cmpi.w  #PHYS.DOWNMAX,d1        ; Exit if out of downward radius
        blt.s   _physUnkObjectFall

        add.w   d1,obj.Y(a0)            ; Otherwise set to floor

.OnFloor:                                 
        rts

.AboveFloor:                               
        cmpi.w  #PHYS.UPMAX,d1          ; Exit if out of upward radius
        bgt.s   .InAir
        add.w   d1,obj.Y(a0)
        rts

.InAir:                               
        bset    #PHYS.AIRPHYS,obj.Status(a0)    ; Set air status bit
        bclr    #PHYS.PUSH,obj.Status(a0)       ; Clear pushing status bit
        move.b  #1,obj.AnimPrev(a0)             ; ???
        rts

; ---------------------------------------------------------------------------
; These appear to be routines that would calculate speed and apply gravity on
; the current object when exiting from a slope... 
; (if you no longer registered as on collision)
;
; They're stubbed out with an rts, and physics is done through calls to 
; _objectFall, so these appear to be from an earlier physics implementation
; ---------------------------------------------------------------------------

_physUnkObjectFall:                       
        rts
        move.l  obj.X(a0),d2
        move.w  obj.XSpeed(a0),d0
        ext.l   d0
        asl.l   #8,d0
        sub.l   d0,d2
        move.l  d2,obj.X(a0)
        move.w  #PHYS.GRAVITY,d0
        ext.l   d0
        asl.l   #8,d0
        sub.l   d0,d3
        move.l  d3,obj.Y(a0)
        rts

; Called at _physWalkWallRight and _physWalkWallLeft...  huh

_physUnkFallReverse:                       
        rts
        move.l  obj.Y(a0),d3
        move.w  obj.YSpeed(a0),d0
        subi.w  #PHYS.GRAVITY,d0
        move.w  d0,obj.YSpeed(a0)
        ext.l   d0
        asl.l   #8,d0
        sub.l   d0,d3
        move.l  d3,obj.Y(a0)
        rts

; Exactly the same as _objectSetSpeed, but stubbed

_physUnkSetSpeed    
        rts
        move.l  obj.X(a0),d2
        move.l  obj.Y(a0),d3
        move.w  obj.XSpeed(a0),d0
        ext.l   d0
        asl.l   #8,d0
        sub.l   d0,d2
        move.w  obj.YSpeed(a0),d0
        ext.l   d0
        asl.l   #8,d0
        sub.l   d0,d3
        move.l  d2,obj.X(a0)
        move.l  d3,obj.Y(a0)
        rts

; ---------------------------------------------------------------------------
; Subroutine to choose foot sensor to stand on
; ---------------------------------------------------------------------------

_physPickFoot:                          
        move.b  footBackAngle.w,d2      ; Set to use back sensor
        cmp.w   d0,d1                   ; Check against front 
        ble.s   .BackFootHigher         ; Skip over if higher    
        move.b  footFrontAngle.w,d2
        move.w  d0,d1

.BackFootHigher:                               
        btst    #0,d2
        bne.s   .NotSloped
        move.b  d2,obj.Angle(a0)        ; Set angle if not sloped
        rts

.NotSloped:                               
        move.b  obj.Angle(a0),d2        ; Shift 45 degrees and save angle
        addi.b  #$20,d2
        andi.b  #$C0,d2
        move.b  d2,obj.Angle(a0)
        rts


; ---------------------------------------------------------------------------
; Function for walking on wall to the right
; ---------------------------------------------------------------------------

_physWalkWallRight:              

        ; ---- Get Primary (top) sensor information

        move.w  obj.Y(a0),d2            ; Since we're sideways, the inputs are crossed
        move.w  obj.X(a0),d3            
        moveq   #0,d0
        move.b  obj.XRad(a0),d0         ; So X pos. is worked against XRad
        ext.w   d0                      
        neg.w   d0
        add.w   d0,d2                   ; for Y position input
        move.b  obj.YRad(a0),d0         ; ..and X from YRad
        ext.w   d0
        add.w   d0,d3                   ; for X position input
        lea     footFrontAngle.w,a4     ; Same inputs as before:
        movea.w #16,a3                  ; Block height
        move.w  #0,d6                   ; Orientation
        moveq   #BLK.TOPSOLID,d5        ; Solidity bit
        bsr.w   _physGetWallAttr

        move.w  d1,-(sp)

        ; ---- Get Secondary (bottom) sensor information

        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.XRad(a0),d0
        ext.w   d0
        add.w   d0,d2                   ; Y
        move.b  obj.YRad(a0),d0
        ext.w   d0
        add.w   d0,d3                   ; X
        lea     footBackAngle.w,a4      ; Angle output
        movea.w #16,a3                  ; Block height
        move.w  #0,d6                   ; Orientation
        moveq   #BLK.TOPSOLID,d5        ; Solidity bit
        bsr.w   _physGetWallAttr

        move.w  (sp)+,d0                ; Choose foot from distances
        bsr.w   _physPickFoot

        tst.w   d1
        beq.s   .OnFloor
        bpl.s   .AboveFloor

        cmpi.w  #PHYS.DOWNMAX,d1
        blt.w   _physUnkFallReverse

        add.w   d1,obj.X(a0)

.OnFloor:                            
        rts

.AboveFloor:                               
        cmpi.w  #PHYS.UPMAX,d1
        bgt.s   .InAir
        add.w   d1,obj.X(a0)
        rts

.InAir:                              
        bset    #PHYS.AIRPHYS,obj.Status(a0)
        bclr    #PHYS.PUSH,obj.Status(a0)
        move.b  #1,obj.AnimPrev(a0)             ; ???
        rts


; ---------------------------------------------------------------------------
; Function for walking on ceiling
; ---------------------------------------------------------------------------

_physWalkCeiling:      

        ; ---- Get Primary sensor information

        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.YRad(a0),d0         ; For ceiling, top edge of course
        ext.w   d0
        sub.w   d0,d2                   
        eori.w  #$F,d2                  ; Y
        move.b  obj.XRad(a0),d0
        ext.w   d0
        add.w   d0,d3                   ; X
        lea     footFrontAngle.w,a4     ; Angle output
        movea.w #-16,a3                 ; Block height
        move.w  #(1<<BLK.YFLIP),d6      ; Orientation
        moveq   #BLK.TOPSOLID,d5        ; Solidity bit
        bsr.w   _physGetFloorAttr

        move.w  d1,-(sp)

        ; ---- Get Secondary sensor information

        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.YRad(a0),d0
        ext.w   d0
        sub.w   d0,d2                   
        eori.w  #$F,d2                  ; Y
        move.b  obj.XRad(a0),d0
        ext.w   d0
        sub.w   d0,d3                   ; X
        lea     footFrontAngle.w,a4     ; Angle output
        movea.w #-16,a3                 ; Block height
        move.w  #(1<<BLK.YFLIP),d6      ; Orientation
        moveq   #BLK.TOPSOLID,d5        ; Solidity bit
        bsr.w   _physGetFloorAttr

        move.w  (sp)+,d0
        bsr.w   _physPickFoot

        tst.w   d1
        beq.s   .OnFloor
        bpl.s   .AboveFloor

        cmpi.w  #PHYS.DOWNMAX,d1
        blt.w   _physUnkFallReverse
        
        sub.w   d1,obj.Y(a0)

        ; NOTE: these are named relative to our orientation 
        ; the ceiling is *technically* a floor here, so...  

.OnFloor:                                 
        rts

.AboveFloor:                  
        cmpi.w  #PHYS.UPMAX,d1
        bgt.s   .InAir
        sub.w   d1,obj.Y(a0)
        rts

.InAir:                              
        bset    #PHYS.AIRPHYS,obj.Status(a0)
        bclr    #PHYS.PUSH,obj.Status(a0)
        move.b  #1,obj.AnimPrev(a0)             ; ???
        rts


; ---------------------------------------------------------------------------
; Function for walking on wall to the left
; ---------------------------------------------------------------------------

_physWalkWallLeft:               

        ; ---- Get Primary sensor information

        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.XRad(a0),d0
        ext.w   d0
        sub.w   d0,d2                   ; X
        move.b  obj.YRad(a0),d0
        ext.w   d0
        sub.w   d0,d3
        eori.w  #$F,d3                  ; Y
        lea     footFrontAngle.w,a4     ; Angle output loc
        movea.w #-16,a3                 ; Block Height
        move.w  #(1<<BLK.XFLIP),d6      ; Orientation
        moveq   #BLK.TOPSOLID,d5        ; Solidity
        bsr.w   _physGetWallAttr

        move.w  d1,-(sp)

        ; ---- Get Secondary sensor information

        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.XRad(a0),d0
        ext.w   d0
        add.w   d0,d2                   ; X
        move.b  obj.YRad(a0),d0
        ext.w   d0
        sub.w   d0,d3
        eori.w  #$F,d3                  ; Y
        lea     footBackAngle.w,a4      ; Angle output loc
        movea.w #-16,a3                 ; Block Height
        move.w  #(1<<BLK.XFLIP),d6      ; Orientation
        moveq   #BLK.TOPSOLID,d5        ; Solidity
        bsr.w   _physGetWallAttr

        move.w  (sp)+,d0
        bsr.w   _physPickFoot

        tst.w   d1
        beq.s   .OnFloor
        bpl.s   .AboveFloor

        cmpi.w  #PHYS.DOWNMAX,d1
        blt.w   _physUnkFallReverse
        
        sub.w   d1,obj.X(a0)

.OnFloor:                           
        rts

.AboveFloor:                              
        cmpi.w  #PHYS.UPMAX,d1
        bgt.s   .InAir

        sub.w   d1,obj.X(a0)
        rts

.InAir:                              
        bset    #PHYS.AIRPHYS,obj.Status(a0)
        bclr    #PHYS.PUSH,obj.Status(a0)
        move.b  #1,obj.AnimPrev(a0)             ; ???
        rts

; ---------------------------------------------------------------------------
; Routine to get which block in a chunk two X and Y points correspond to
; Used in the routines below it where attributes are gotten from the output
;
; INPUTS:
;       d2.w = Y point
;       d3.w = X point
;
; OUTPUTS:
;       a1   = Address 
;       
; ---------------------------------------------------------------------------

_physFindBlock:
        move.w  d2,d0                   ; Get Y input and divide it by 2
        lsr.w   #1,d0
        andi.w  #$380,d0                ; Get high byte for chunk grid number

        move.w  d3,d1                   ; Get X input and divide it by 256
        lsr.w   #8,d1                   ;
        andi.w  #$7F,d1
        add.w   d1,d0

        moveq   #$FFFFFFFF,d1           ; Set d1 signed for RAM address

        lea     levelLayout.w,a1        
        move.b  (a1,d0.w),d1            ; Use d0 to get chunk ID
        beq.s   .Blank                  ; If the ID is 00 (blank) then exit
        bmi.s   .SpecialChunk           ; If the ID is >$7F then handle as special

        ; Make the address

        subq.b  #1,d1                   ; Shift every ID down 1
        ext.w   d1                      ; Extend to a word for $00xx
        ror.w   #7,d1                   ; Swap to $xx00

        move.w  d2,d0                   ; Copy Y to d0
        add.w   d0,d0                   ; Double for two bytes in each block
        andi.w  #$1E0,d0                ; Read only high bit for address
        add.w   d0,d1                   ; Add to address        

        move.w  d3,d0                   ; Copy X to d0
        lsr.w   #3,d0                   ; Divide by 8(?)
        andi.w  #$1E,d0                 ; Mask out lower bits for high nybble * 2(?)
        add.w   d0,d1                   ; Add to address for final location

.Blank:                               
        movea.l d1,a1                   ; Return address in a1
        rts

.SpecialChunk:                        
        andi.w  #$7F,d1                         ; Mask out MSB
        btst    #REND.BEHIND,obj.Render(a0)     ; Skip if object behind chunk
        beq.s   .TryNext                          
        addq.w  #1,d1                           ; adjust ID?
        cmpi.w  #$28+1,d1                       ; If chunk ID is $28, replace with $51
        bne.s   .TryNext                          
        move.w  #$51,d1                         

.Skip:       
        ; Make the address (same as code above basically)

        subq.b  #1,d1
        ror.w   #7,d1
        move.w  d2,d0
        add.w   d0,d0
        andi.w  #$1E0,d0
        add.w   d0,d1
        move.w  d3,d0
        lsr.w   #3,d0
        andi.w  #$1E,d0
        add.w   d0,d1
        movea.l d1,a1
        rts

; ---------------------------------------------------------------------------
; Routine to get the current block in a chunk from two points, and then      
; return all their relevant attributes based on user inputs
;
; INPUTS:
;       d2.w = Y point
;       d3.w = X point
;       d5.w = Solidity bit
;       d6.w = Orientation bits
;       a3.w = Height of the tile 
;       a4   = Angle information output location
;
; OUTPUTS:
;       d1.w   = Distance from floor
;       a1     = Block address in the chunk map
;       (a4).b = Angle of block stood on
;
; ---------------------------------------------------------------------------


_physGetFloorAttr:
        bsr.s   _physFindBlock
        move.w  (a1),d0                         ; a1 = Block address
        move.w  d0,d4                           
        andi.w  #$7FF,d0                        ; Mask out info bits
        beq.s   .Skip
        btst    d5,d4
        bne.s   .DoFloorCalc

.Skip:                                 
        add.w   a3,d2                           ; Add height for adjacent block
        bsr.w   _physGetFloorAttrAdj            ; Try to find block adjacent to this one
        sub.w   a3,d2 
        addi.w  #16,d1
        rts

.DoFloorCalc:                          
        movea.l collisionPtr.w,a2
        move.b  (a2,d0.w),d0
        andi.w  #$FF,d0                         ; Mask out top bytes
        beq.s   .TryNext                        ; Try next block down if empty
        lea     AngleMap,a2
        move.b  (a2,d0.w),(a4)
        lsl.w   #4,d0
        move.w  d3,d1
        btst    #$B,d4
        beq.s   loc_10202
        not.w   d1
        neg.b   (a4)

loc_10202:                              
        btst    #$C,d4
        beq.s   loc_10212
        addi.b  #$40,(a4)
        neg.b   (a4)
        subi.b  #$40,(a4) 

loc_10212:                              
        andi.w  #$F,d1
        add.w   d0,d1
        lea     BlkColHeights,a2
        move.b  (a2,d1.w),d0
        ext.w   d0
        eor.w   d6,d4
        btst    #$C,d4
        beq.s   loc_1022E
        neg.w   d0

loc_1022E:                              
        tst.w   d0
        beq.s   .Skip
        bmi.s   loc_1024A
        cmpi.b  #$10,d0
        beq.s   loc_10256
        move.w  d2,d1
        andi.w  #$F,d1
        add.w   d1,d0
        move.w  #$F,d1
        sub.w   d0,d1
        rts

loc_1024A:                              
        move.w  d2,d1
        andi.w  #$F,d1
        add.w   d1,d0
        bpl.w   .Skip

loc_10256:                              
        sub.w   a3,d2
        bsr.w   _physGetFloorAttrAdj
        add.w   a3,d2
        subi.w  #$10,d1
        rts

; =============== S U B R O U T I N E =======================================


_physGetFloorAttrAdj:                   
        bsr.w   _physFindBlock
        move.w  (a1),d0
        move.w  d0,d4
        andi.w  #$7FF,d0
        beq.s   loc_10276
        btst    d5,d4
        bne.s   loc_10284

loc_10276:                              
        move.w  #$F,d1
        move.w  d2,d0
        andi.w  #$F,d0
        sub.w   d0,d1
        rts

loc_10284:                              
        movea.l collisionPtr.w,a2
        move.b  (a2,d0.w),d0
        andi.w  #$FF,d0
        beq.s   loc_10276
        lea     AngleMap,a2
        move.b  (a2,d0.w),(a4)
        lsl.w   #4,d0
        move.w  d3,d1
        btst    #$B,d4
        beq.s   loc_102AA
        not.w   d1
        neg.b   (a4)

loc_102AA:                              
        btst    #$C,d4
        beq.s   loc_102BA
        addi.b  #$40,(a4) 
        neg.b   (a4)
        subi.b  #$40,(a4) 

loc_102BA:                              
        andi.w  #$F,d1
        add.w   d0,d1
        lea     BlkColHeights,a2
        move.b  (a2,d1.w),d0
        ext.w   d0
        eor.w   d6,d4
        btst    #$C,d4
        beq.s   loc_102D6
        neg.w   d0

loc_102D6:                              
        tst.w   d0
        beq.s   loc_10276
        bmi.s   loc_102EC
        move.w  d2,d1
        andi.w  #$F,d1
        add.w   d1,d0
        move.w  #$F,d1
        sub.w   d0,d1
        rts
; ---------------------------------------------------------------------------

loc_102EC:                              
        move.w  d2,d1
        andi.w  #$F,d1
        add.w   d1,d0
        bpl.w   loc_10276
        not.w   d1
        rts

; =============== S U B R O U T I N E =======================================


_physGetWallAttr:                       
        bsr.w   _physFindBlock
        move.w  (a1),d0
        move.w  d0,d4
        andi.w  #$7FF,d0
        beq.s   loc_1030E
        btst    d5,d4
        bne.s   loc_1031C

loc_1030E:                              
        add.w   a3,d3
        bsr.w   _physGetWallAttrAdj
        sub.w   a3,d3
        addi.w  #$10,d1
        rts

loc_1031C:                              
        movea.l collisionPtr.w,a2
        move.b  (a2,d0.w),d0
        andi.w  #$FF,d0
        beq.s   loc_1030E
        lea     AngleMap,a2
        move.b  (a2,d0.w),(a4)
        lsl.w   #4,d0
        move.w  d2,d1
        btst    #$C,d4
        beq.s   loc_1034A
        not.w   d1
        addi.b  #$40,(a4) 
        neg.b   (a4)
        subi.b  #$40,(a4) 

loc_1034A:                              
        btst    #$B,d4
        beq.s   loc_10352
        neg.b   (a4)

loc_10352:                              
        andi.w  #$F,d1
        add.w   d0,d1
        lea     BlkColWidths,a2
        move.b  (a2,d1.w),d0
        ext.w   d0
        eor.w   d6,d4
        btst    #$B,d4
        beq.s   loc_1036E
        neg.w   d0

loc_1036E:                              
        tst.w   d0
        beq.s   loc_1030E
        bmi.s   loc_1038A
        cmpi.b  #$10,d0
        beq.s   loc_10396
        move.w  d3,d1
        andi.w  #$F,d1
        add.w   d1,d0
        move.w  #$F,d1
        sub.w   d0,d1
        rts

loc_1038A:                              
        move.w  d3,d1
        andi.w  #$F,d1
        add.w   d1,d0
        bpl.w   loc_1030E

loc_10396:                              
        sub.w   a3,d3
        bsr.w   _physGetWallAttrAdj
        add.w   a3,d3
        subi.w  #$10,d1
        rts

; =============== S U B R O U T I N E =======================================


_physGetWallAttrAdj:                    
        bsr.w   _physFindBlock
        move.w  (a1),d0
        move.w  d0,d4
        andi.w  #$7FF,d0
        beq.s   loc_103B6
        btst    d5,d4
        bne.s   loc_103C4

loc_103B6:                              
        move.w  #$F,d1
        move.w  d3,d0
        andi.w  #$F,d0
        sub.w   d0,d1
        rts

loc_103C4:                              
        movea.l collisionPtr.w,a2
        move.b  (a2,d0.w),d0
        andi.w  #$FF,d0
        beq.s   loc_103B6
        lea     AngleMap,a2
        move.b  (a2,d0.w),(a4)
        lsl.w   #4,d0
        move.w  d2,d1
        btst    #$C,d4
        beq.s   loc_103F2
        not.w   d1
        addi.b  #$40,(a4) 
        neg.b   (a4)
        subi.b  #$40,(a4) 

loc_103F2:                              
        btst    #$B,d4
        beq.s   loc_103FA
        neg.b   (a4)

loc_103FA:                              
        andi.w  #$F,d1
        add.w   d0,d1
        lea     BlkColWidths,a2
        move.b  (a2,d1.w),d0
        ext.w   d0
        eor.w   d6,d4
        btst    #$B,d4
        beq.s   loc_10416
        neg.w   d0

loc_10416:                              
        tst.w   d0
        beq.s   loc_103B6
        bmi.s   loc_1042C
        move.w  d3,d1
        andi.w  #$F,d1
        add.w   d1,d0
        move.w  #$F,d1
        sub.w   d0,d1
        rts

loc_1042C:                              
        move.w  d3,d1
        andi.w  #$F,d1
        add.w   d1,d0
        bpl.w   loc_103B6
        not.w   d1
                rts