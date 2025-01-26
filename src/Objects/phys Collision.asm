; ---------------------------------------------------------------------------
; Object collision physics library for walking on level terrain
; This is also Sonic's main collision detection code. 
; ---------------------------------------------------------------------------

; ---------------------------------------------------------------------------
; local enums

PHYS_UPMAX      EQU     14              ; Max distances to register on floor
PHYS_DOWNMAX    EQU     -14             
PHYS_GRAVITY    EQU     56              ; Gravity delta
PHYS_LIFTFLAG   EQU     3               ; "Lifted" numerical flag

BLK.XFLIP       EQU     $B              ; Collision Bit assig. in chunk data
BLK.YFLIP       EQU     $C
BLK.TOPSOLID    EQU     $D
BLK.BTMSOLID    EQU     $E

; ---------------------------------------------------------------------------

_physFootCollision:                     
        btst    #PHYS.PLATFORM,obj.Status(a0)
        beq.s   .NotOnPlatform
        moveq   #0,d0                   ; Clear sensor angle information
        move.b  d0,angleRight.w
        move.b  d0,angleLeft.w
        rts

.NotOnPlatform:                             
        moveq   #PHYS_LIFTFLAG,d0       ; Set flag for angle stack
        move.b  d0,angleRight.w
        move.b  d0,angleLeft.w

        move.b  obj.Angle(a0),d0
        addi.b  #$20,d0                 ; Rotate unit circle 45 degrees
        andi.b  #$C0,d0                 ; Use top bits for orientation

        cmpi.b  #$40,d0                 ; $40 = 90 degrees
        beq.w   _physFootColLeft
        cmpi.b  #$80,d0                 ; $80 = 180 degrees
        beq.w   _physFootColUp
        cmpi.b  #$C0,d0                 ; $C0 = 270 degrees
        beq.w   _physFootColRight

        ; Otherwise, we're on the floor, so check and apply physics downward:

_physFootColDown:

        ; ---- Get right sensor information

        move.w  obj.Y(a0),d2            
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.YRad(a0),d0         ; Get the bottom edge of the object's radius
        ext.w   d0                      ; and set as y input for subroutine branch
        add.w   d0,d2                   
        move.b  obj.XRad(a0),d0         ; Get right edge of the object's radius
        ext.w   d0                      ; and also set as x input for branch
        add.w   d0,d3
        lea     angleRight.w,a4         ; Set angle output location in a4
        movea.w #16,a3                  ; Set block height
        move.w  #0,d6                   ; Set orientation
        moveq   #BLK.TOPSOLID,d5        ; Set Checking top solidity
        bsr.w   _physGetFloorAttr       ; Get floor distance and angle based on inputs

        move.w  d1,-(sp)                ; Push d1 (output distance) to stack

        ; ---- Get left sensor information

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
        lea     angleLeft.w,a4
        movea.w #16,a3                  ; Set block height
        move.w  #0,d6                   ; Set orientation
        moveq   #BLK.TOPSOLID,d5        ; Solidity bit
        bsr.w   _physGetFloorAttr

        move.w  (sp)+,d0                ; Pop output distance to d0 for input
        bsr.w   _physPickFoot           ; Pick foot sensor to stand on

        tst.w   d1
        beq.s   .OnFloor
        bpl.s   .AboveFloor

        cmpi.w  #PHYS_DOWNMAX,d1        ; Exit if out of downward radius
        blt.s   _physUnkObjectFall

        add.w   d1,obj.Y(a0)            ; Otherwise set to floor

.OnFloor:                                 
        rts

.AboveFloor:                               
        cmpi.w  #PHYS_UPMAX,d1          ; Exit if out of upward radius
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
        move.w  #PHYS_GRAVITY,d0
        ext.l   d0
        asl.l   #8,d0
        sub.l   d0,d3
        move.l  d3,obj.Y(a0)
        rts

; Called at _physFootColRight and _physFootColLeft...  huh

_physUnkFallReverse:                       
        rts
        move.l  obj.Y(a0),d3
        move.w  obj.YSpeed(a0),d0
        subi.w  #PHYS_GRAVITY,d0
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
        move.b  angleLeft.w,d2      ; Set to use back sensor
        cmp.w   d0,d1                   ; Check against front 
        ble.s   .BackFootHigher         ; Skip over if higher    
        move.b  angleRight.w,d2
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

_physFootColRight:              

        ; ---- Get right (top) sensor information

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
        lea     angleRight.w,a4     ; Same inputs as before:
        movea.w #16,a3                  ; Block height
        move.w  #0,d6                   ; Orientation
        moveq   #BLK.TOPSOLID,d5        ; Solidity bit
        bsr.w   _physGetWallAttr

        move.w  d1,-(sp)

        ; ---- Get left (bottom) sensor information

        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.XRad(a0),d0
        ext.w   d0
        add.w   d0,d2                   ; Y
        move.b  obj.YRad(a0),d0
        ext.w   d0
        add.w   d0,d3                   ; X
        lea     angleLeft.w,a4          ; Angle output
        movea.w #16,a3                  ; Block height
        move.w  #0,d6                   ; Orientation
        moveq   #BLK.TOPSOLID,d5        ; Solidity bit
        bsr.w   _physGetWallAttr

        move.w  (sp)+,d0                ; Choose foot from distances
        bsr.w   _physPickFoot

        tst.w   d1
        beq.s   .OnFloor
        bpl.s   .AboveFloor

        cmpi.w  #PHYS_DOWNMAX,d1
        blt.w   _physUnkFallReverse

        add.w   d1,obj.X(a0)

.OnFloor:                            
        rts

.AboveFloor:                               
        cmpi.w  #PHYS_UPMAX,d1
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

_physFootColUp:      

        ; ---- Get right sensor information

        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.YRad(a0),d0         ; For ceiling, top edge of course
        ext.w   d0
        sub.w   d0,d2                   ; Y
        eori.w  #$F,d2                  ; Reverse low nybble to reverse pos. in block
        move.b  obj.XRad(a0),d0
        ext.w   d0
        add.w   d0,d3                   ; X
        lea     angleRight.w,a4         ; Angle output
        movea.w #-16,a3                 ; Block height
        move.w  #(1<<BLK.YFLIP),d6      ; Orientation
        moveq   #BLK.TOPSOLID,d5        ; Solidity bit
        bsr.w   _physGetFloorAttr

        move.w  d1,-(sp)

        ; ---- Get left sensor information

        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.YRad(a0),d0
        ext.w   d0
        sub.w   d0,d2                   ; Y
        eori.w  #$F,d2                  ; Reverse low nybble to reverse pos. in block
        move.b  obj.XRad(a0),d0
        ext.w   d0
        sub.w   d0,d3                   ; X
        lea     angleRight.w,a4         ; Angle output
        movea.w #-16,a3                 ; Block height
        move.w  #(1<<BLK.YFLIP),d6      ; Orientation
        moveq   #BLK.TOPSOLID,d5        ; Solidity bit
        bsr.w   _physGetFloorAttr

        move.w  (sp)+,d0
        bsr.w   _physPickFoot

        tst.w   d1
        beq.s   .OnFloor
        bpl.s   .AboveFloor

        cmpi.w  #PHYS_DOWNMAX,d1
        blt.w   _physUnkFallReverse
        
        sub.w   d1,obj.Y(a0)

        ; NOTE: these are named relative to our orientation 
        ; the ceiling is *technically* a floor here, so...  

.OnFloor:                                 
        rts

.AboveFloor:                  
        cmpi.w  #PHYS_UPMAX,d1
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

_physFootColLeft:               

        ; ---- Get right sensor information

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
        lea     angleRight.w,a4     ; Angle output loc
        movea.w #-16,a3                 ; Block Height
        move.w  #(1<<BLK.XFLIP),d6      ; Orientation
        moveq   #BLK.TOPSOLID,d5        ; Solidity
        bsr.w   _physGetWallAttr

        move.w  d1,-(sp)

        ; ---- Get left sensor information

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
        lea     angleLeft.w,a4          ; Angle output loc
        movea.w #-16,a3                 ; Block Height
        move.w  #(1<<BLK.XFLIP),d6      ; Orientation
        moveq   #BLK.TOPSOLID,d5        ; Solidity
        bsr.w   _physGetWallAttr

        move.w  (sp)+,d0
        bsr.w   _physPickFoot

        tst.w   d1
        beq.s   .OnFloor
        bpl.s   .AboveFloor

        cmpi.w  #PHYS_DOWNMAX,d1
        blt.w   _physUnkFallReverse
        
        sub.w   d1,obj.X(a0)

.OnFloor:                           
        rts

.AboveFloor:                              
        cmpi.w  #PHYS_UPMAX,d1
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

        lea     layoutA.w,a1        
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
; return all their relevant attributes based on HEIGHT data and user input.
; Used when running on a floor or ceiling.
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
        bsr.s   _physFindBlock          ; a1 = Block address in chunk mem.
        move.w  (a1),d0                 ; Get solid, orientation and block ID
        move.w  d0,d4                   ; d4 = block attributes from blk addr.       
        andi.w  #$7FF,d0                ; Mask out info bits
        beq.s   .TryNext

        btst    d5,d4                   ; Does this have solids the user needs?
        bne.s   .GetBlkAttrib           ; If so, get other attributes

.TryNext:                                 
        add.w   a3,d2                   ; Add height for block below this one
        bsr.w   _physGetFloorAttrAdj    ; Try to find block adjacent
        sub.w   a3,d2                   ; Re-adjust up by block size
        addi.w  #16,d1                  ; Set distance 1 block below
        rts

.GetBlkAttrib:                          
        movea.l collisionPtr.w,a2       ; Get collision height ID
        move.b  (a2,d0.w),d0            
        andi.w  #$FF,d0                 ; Get only low byte
        beq.s   .TryNext                ; Try next block down if empty

        lea     AngleMap,a2             ; Get angle value
        move.b  (a2,d0.w),(a4)
        lsl.w   #4,d0                   ; Multiply by 16 for data offset
        move.w  d3,d1                   ; Xpos to d1
        btst    #BLK.XFLIP,d4           ; Skip ahead if no Xflip
        beq.s   .NotXFlip

        not.w   d1                      ; Reverse position within block height
        neg.b   (a4)                    ; Negate angle value

.NotXFlip:                              
        btst    #BLK.YFLIP,d4           ; Skip ahead if no Yflip
        beq.s   .NotYFlip               

        addi.b  #$40,(a4)               ; Push over 90 degrees
        neg.b   (a4)
        subi.b  #$40,(a4)               ; Push back for negated "refracted" angle

.NotYFlip:                              
        andi.w  #$F,d1                  ; Mask to only low nybble for xpos. in block
        add.w   d0,d1                   ; Add x-pos to data offset
        lea     BlkColHeights,a2        ; Use it to get location within heightmap
        move.b  (a2,d1.w),d0

        ext.w   d0                      ; !!! SIGN USED HERE - doublecheck this doc.
        eor.w   d6,d4                   ; Set user orientation mask
        btst    #BLK.YFLIP,d4
        beq.s   .NotUserYFlip  
               
        neg.w   d0                      ; Negate height for Y flip 

.NotUserYFlip:                              
        tst.w   d0                      ; If our height is 0, try block below this one.
        beq.s   .TryNext

        bmi.s   .NegativeHeight         ; If it's negative, branch ahead 

        cmpi.b  #16,d0                  ; If max height, check block ABOVE this one.
        beq.s   .MaxHeight  

        move.w  d2,d1                   ; Get Ypos low nybble for in-block loc.
        andi.w  #$F,d1                  
        add.w   d1,d0                   ; Add to height                 
        move.w  #16-1,d1     
        sub.w   d0,d1
        rts

.NegativeHeight:                              
        move.w  d2,d1
        andi.w  #$F,d1
        add.w   d1,d0
        bpl.w   .TryNext                

.MaxHeight:                              
        sub.w   a3,d2                   ; Subtract for block above this one
        bsr.w   _physGetFloorAttrAdj    ; Check for it instead
        add.w   a3,d2                   ; Re-adjust down by block size      
        subi.w  #16,d1                  ; Set distance 1 block above
        rts

; ---------------------------------------------------------------------------
; Simpler version of above routine that exits if no good block info found
; ---------------------------------------------------------------------------

_physGetFloorAttrAdj:                   
        bsr.s   _physFindBlock          ; a1 = Block address
        move.w  (a1),d0                 ; Get attribute information
        move.w  d0,d4                   ; d4 = attributes       
        andi.w  #$7FF,d0                ; Mask out info bits
        beq.s   .Return

        btst    d5,d4                   ; If solid matches then get attributes
        bne.s   .GetBlkAttrib

.Return:                              
        move.w  #$F,d1
        move.w  d2,d0
        andi.w  #$F,d0
        sub.w   d0,d1
        rts

.GetBlkAttrib:                              
        movea.l collisionPtr.w,a2
        move.b  (a2,d0.w),d0
        andi.w  #$FF,d0
        beq.s   .Return

        lea     AngleMap,a2
        move.b  (a2,d0.w),(a4)
        lsl.w   #4,d0
        move.w  d3,d1
        btst    #BLK.XFLIP,d4
        beq.s   .NotXFlip

        not.w   d1
        neg.b   (a4)

.NotXFlip:                              
        btst    #BLK.YFLIP,d4
        beq.s   .NotYFlip

        addi.b  #$40,(a4) 
        neg.b   (a4)
        subi.b  #$40,(a4) 

.NotYFlip:                              
        andi.w  #$F,d1
        add.w   d0,d1
        lea     BlkColHeights,a2
        move.b  (a2,d1.w),d0

        ext.w   d0
        eor.w   d6,d4
        btst    #BLK.YFLIP,d4
        beq.s   .NotUserYFlip

        neg.w   d0

.NotUserYFlip:                              
        tst.w   d0
        beq.s   .Return

        bmi.s   .NegativeHeight

        move.w  d2,d1
        andi.w  #$F,d1
        add.w   d1,d0
        move.w  #16-1,d1
        sub.w   d0,d1
        rts

.NegativeHeight:                              
        move.w  d2,d1
        andi.w  #$F,d1
        add.w   d1,d0
        bpl.w   .Return

        not.w   d1
        rts

; ---------------------------------------------------------------------------
; Routine to get the current block in a chunk from two points, and then      
; return all their relevant attributes based on WIDTH data and user input.
; Used when running on walls.
;
; INPUTS:
;       d2.w = Y point
;       d3.w = X point
;       d5.w = Solidity bit
;       d6.w = Orientation bits
;       a3.w = Width of the tile 
;       a4   = Angle information output location
;
; OUTPUTS:
;       d1.w   = Distance from floor
;       a1     = Block address in the chunk map
;       (a4).b = Angle of block stood on
;
; ---------------------------------------------------------------------------


_physGetWallAttr:                       
        bsr.w   _physFindBlock
        move.w  (a1),d0
        move.w  d0,d4
        andi.w  #$7FF,d0
        beq.s   .TryNext

        btst    d5,d4
        bne.s   .GetBlkAttrib

.TryNext:                              
        add.w   a3,d3                   ; Add for tile to right of this one
        bsr.w   _physGetWallAttrAdj     ; Get its attributes
        sub.w   a3,d3                   ; Re-adjust
        addi.w  #16,d1                  ; Set distance 1 block over
        rts

.GetBlkAttrib:                              
        movea.l collisionPtr.w,a2       ; Get collision width ID
        move.b  (a2,d0.w),d0
        andi.w  #$FF,d0                 ; Get only low byte
        beq.s   .TryNext                ; Try next block over if empty

        lea     AngleMap,a2             ; Get angle value
        move.b  (a2,d0.w),(a4)
        lsl.w   #4,d0                   ; Multiply by 16 for data offset
        move.w  d2,d1                   ; Ypos to d1
        btst    #BLK.YFLIP,d4           ; Skip ahead if no Yflip
        beq.s   .NotYFlip

        not.w   d1                      ; Reverse position within block width
        addi.b  #$40,(a4)               ; Push over 90 degrees
        neg.b   (a4)
        subi.b  #$40,(a4)               ; Push back for negated "refracted" angle

.NotYFlip:                              
        btst    #BLK.XFLIP,d4           ; Skip ahead if no Xflip
        beq.s   .NotXFlip

        neg.b   (a4)                    ; Negate angle value

.NotXFlip:                              
        andi.w  #$F,d1
        add.w   d0,d1
        lea     BlkColWidths,a2
        move.b  (a2,d1.w),d0

        ext.w   d0                      ; !!!
        eor.w   d6,d4                   ; Set user orientation
        btst    #BLK.XFLIP,d4
        beq.s   .NotUserXFlip
        neg.w   d0

.NotUserXFlip:                              
        tst.w   d0                      ; If width is 0, try block to right
        beq.s   .TryNext

        bmi.s   .NegativeWidth          ; If neg, skip ahead

        cmpi.b  #16,d0                  ; If max width, check block to left
        beq.s   .MaxWidth

        move.w  d3,d1
        andi.w  #$F,d1
        add.w   d1,d0
        move.w  #16-1,d1
        sub.w   d0,d1
        rts

.NegativeWidth:                              
        move.w  d3,d1
        andi.w  #$F,d1
        add.w   d1,d0
        bpl.w   .TryNext

.MaxWidth:                              
        sub.w   a3,d3                   ; Subtract for block to left of this one
        bsr.w   _physGetWallAttrAdj     ; Check its attributes
        add.w   a3,d3                   ; Re-adjust down by block size      
        subi.w  #16,d1                  ; Return attributes for above block
        rts

; ---------------------------------------------------------------------------
; Again, simpler version of above.
; ---------------------------------------------------------------------------


_physGetWallAttrAdj:                    
        bsr.w   _physFindBlock
        move.w  (a1),d0
        move.w  d0,d4
        andi.w  #$7FF,d0
        beq.s   .Return

        btst    d5,d4
        bne.s   .GetBlkAttrib

.Return:                              
        move.w  #$F,d1
        move.w  d3,d0
        andi.w  #$F,d0
        sub.w   d0,d1
        rts

.GetBlkAttrib:                              
        movea.l collisionPtr.w,a2
        move.b  (a2,d0.w),d0
        andi.w  #$FF,d0
        beq.s   .Return

        lea     AngleMap,a2
        move.b  (a2,d0.w),(a4)
        lsl.w   #4,d0
        move.w  d2,d1
        btst    #BLK.YFLIP,d4
        beq.s   .NotYFlip

        not.w   d1
        addi.b  #$40,(a4) 
        neg.b   (a4)
        subi.b  #$40,(a4) 

.NotYFlip:                              
        btst    #BLK.XFLIP,d4
        beq.s   .NotXFlip
        neg.b   (a4)

.NotXFlip:                              
        andi.w  #$F,d1
        add.w   d0,d1
        lea     BlkColWidths,a2
        move.b  (a2,d1.w),d0
        ext.w   d0
        eor.w   d6,d4
        btst    #BLK.XFLIP,d4
        beq.s   .NotUserXFlip
        neg.w   d0

.NotUserXFlip:                              
        tst.w   d0
        beq.s   .Return
        bmi.s   .NegativeWidth
        move.w  d3,d1
        andi.w  #$F,d1
        add.w   d1,d0
        move.w  #$F,d1
        sub.w   d0,d1
        rts

.NegativeWidth:                              
        move.w  d3,d1
        andi.w  #$F,d1
        add.w   d1,d0
        bpl.w   .Return
        not.w   d1
        rts

; ---------------------------------------------------------------------------
; A function that would convert the original source code solids array into
; two separate height and width maps for use with the above calculations
;
; The original source file, blkcol.bct, is in a 1BPP "arcade-style" format,
; where everything is stored rotated at -90 degrees
; So basically, heights are able to read per-column, which is faster
; 
; The arcade-style format could be from working around arcade game libraries,
; as the sine calculation function angles are also rotated -90 degrees
; ---------------------------------------------------------------------------
; This is no longer used, as the solidity array was finalized by this point.
; It also would not work in its current form on stock Mega Drive hardware,
; so it presumably would have used a development system's memory, much like
; how the demo recording function does, but here, it seems like it may
; have just overwritten the data it was processing as it goes along.
;
; Angle and collision data is aligned out to 0x68000 in ROM
; Height starts at 0x68100, Widths start at 0x69100
; ---------------------------------------------------------------------------

        COLSOLIDSBITMAP    EQU  $68100

ConvertBlkCol: 
        rts                             ; Exit without running, nullsub
        lea     COLSOLIDSBITMAP,a1
        lea     COLSOLIDSBITMAP,a2
        move.w  #256-1,d3             

.LoopBlock:                            
        moveq   #16,d5
        move.w  #16-1,d2

.LoopColumn:                           
        moveq   #0,d4
        move.w  #16-1,d1

.LoopRow:                              
        move.w  (a1)+,d0
        lsr.l   d5,d0
        addx.w  d4,d4
        dbf     d1,.LoopRow
        move.w  d4,(a2)+
        suba.w  #32,a1
        subq.w  #1,d5
        dbf     d2,.LoopColumn
        adda.w  #32,a1
        dbf     d3,.LoopBlock
        lea     COLSOLIDSBITMAP,a1
        lea     BlkColWidths,a2
        bsr.s   .ConvertToColBlk
        lea     COLSOLIDSBITMAP,a1
        lea     BlkColHeights,a2

.ConvertToColBlk:                      
        move.w  #$1000-1,d3

.MainLoop:                             
        moveq   #0,d2
        move.w  #16-1,d1
        move.w  (a1)+,d0
        beq.s   .EmptyColumn
        bmi.s   .UpsideDwnBlk

.NormalBlk:                            
        lsr.w   #1,d0
        bcc.s   .EmptyPix
        addq.b  #1,d2

.EmptyPix:                             
        dbf     d1,.NormalBlk
        bra.s   .ColumnDone

.UpsideDwnBlk:                         
        cmpi.w  #$FFFF,d0
        beq.s   .ColumnFullSolid

.GetColumnHeight:                      
        lsl.w   #1,d0
        bcc.s   .EmptyPix2
        subq.b  #1,d2

.EmptyPix2:                            
        dbf     d1,.GetColumnHeight
        bra.s   .ColumnDone

.ColumnFullSolid:                      
        move.w  #16,d0

.EmptyColumn:                          
        move.w  d0,d2

.ColumnDone:                           
        move.b  d2,(a2)+
        dbf     d3,.MainLoop
        rts

; ---------------------------------------------------------------------------
; Function for checking the distance to a wall ahead?
; !!! Called at _playHitWall, so I assume so... doublecheck
; ---------------------------------------------------------------------------

_physGetWallAhead:                       
        move.l  obj.X(a0),d3
        move.l  obj.Y(a0),d2
        move.w  obj.XSpeed(a0),d1
        ext.l   d1
        asl.l   #8,d1
        add.l   d1,d3
        move.w  obj.YSpeed(a0),d1
        ext.l   d1
        asl.l   #8,d1
        add.l   d1,d2
        swap    d2
        swap    d3
        move.b  d0,angleRight.w
        move.b  d0,angleLeft.w
        move.b  d0,d1
        addi.b  #$20,d0
        andi.b  #$C0,d0
        beq.w   _physChkDown.User
        cmpi.b  #$80,d0
        beq.w   _physChkUp.User
        andi.b  #$38,d1 
        bne.s   .SkipSub
        addq.w  #8,d2

.SkipSub:                              
        cmpi.b  #$40,d0 
        beq.w   _physChkLeft.User
        bra.w   _physChkRight.User

; ---------------------------------------------------------------------------
; A set of functions similar to the foot collision ones (_physFootCollision) 
; These get the attributes of the "foot sensors" (radius edges) without 
; applying any "walking" on it, and report back their info
;
; This is the main function here, which will get the applicable angle needed
;
; Also some simpler directional checks for physics objs. and normal objs.
; ---------------------------------------------------------------------------

_physFootChk:                         
        move.b  d0,angleRight.w 
        move.b  d0,angleLeft.w
        addi.b  #$20,d0 
        andi.b  #$C0,d0
        cmpi.b  #$40,d0                 ; $40 = 90 degrees
        beq.w   _physFootChkLeft
        cmpi.b  #$80,d0                 ; $80 = 180 degrees
        beq.w   _physFootChkUp
        cmpi.b  #$C0,d0                 ; $C0 = 270 degrees
        beq.w   _physFootChkRight

; Otherwise, we're on the floor, so check downward:

_physFootChkDown:            

        ; ---- Get Primary foot sensor information

        move.w  obj.Y(a0),d2            
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.YRad(a0),d0         ; Get the bottom edge of the object's radius
        ext.w   d0                      ; and set as y input for subroutine branch
        add.w   d0,d2                   
        move.b  obj.XRad(a0),d0         ; Get right edge of the object's radius
        ext.w   d0                      ; and also set as x input for branch
        add.w   d0,d3
        lea     angleRight.w,a4         ; Set angle output location in a4
        movea.w #16,a3                  ; Set block height
        move.w  #0,d6                   ; Set orientation
        moveq   #BLK.TOPSOLID,d5        ; Set Checking top solidity
        bsr.w   _physGetFloorAttr       ; Get floor distance and angle based on inputs

        move.w  d1,-(sp)                ; Push d1 (output distance) to stack

        ; ---- Get Secondary foot sensor information

        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.YRad(a0),d0         ; Same as above
        ext.w   d0
        add.w   d0,d2                   ; Y
        move.b  obj.XRad(a0),d0         
        ext.w   d0
        sub.w   d0,d3                   ; X
        lea     angleLeft.w,a4
        movea.w #16,a3                  ; Set block height
        move.w  #0,d6                   ; Set orientation
        moveq   #BLK.TOPSOLID,d5        ; Solidity bit
        bsr.w   _physGetFloorAttr

        move.w  (sp)+,d0                ; Pop output distance to d0 for input
        move.b  #0,d2
        ; fall into _physFootChkPick

; ---------------------------------------------------------------------------
; Pick output between the two foot sensors to use
; Used for the FootChk routines below, at their routine ends
; ---------------------------------------------------------------------------

_physFootChkPick:                        
        move.b  angleLeft.w,d3
        cmp.w   d0,d1
        ble.s   .UseLeft
        move.b  angleRight.w,d3
        move.w  d0,d1

.UseLeft:                              
        btst    #0,d3
        beq.s   .Exit
        move.b  d2,d3

.Exit:                                 
        rts

; ---------------------------------------------------------------------------
; Basic collision check downwards which only uses object origin (Y+10), (X)
; ---------------------------------------------------------------------------


_physChkDown:
        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3
.User:                     
        addi.w  #10,d2                  ; Add 10 from origin Y

        lea     angleRight.w,a4         ; Set angle output location
        movea.w #16,a3                  ; Set block size
        move.w  #0,d6                   ; Set orientation bits
        moveq   #BLK.BTMSOLID,d5        ; Set solidity bit
        bsr.w   _physGetFloorAttr       ; Get info

        move.b  #0,d2

; Small function to clear the angle 

_physRoundAngle:                        
        move.b  angleRight.w,d3 
        btst    #0,d3
        beq.s   .Exit
        move.b  d2,d3

.Exit:                                 
        rts

; ---------------------------------------------------------------------------
; 
; ---------------------------------------------------------------------------

_objectColChkDown:                       
        move.w  obj.X(a0),d3

.UserX:                   
        move.w  obj.Y(a0),d2
        moveq   #0,d0
        move.b  obj.YRad(a0),d0
        ext.w   d0
        add.w   d0,d2
        lea     angleRight.w,a4
        move.b  #0,(a4)
        movea.w #16,a3
        move.w  #0,d6
        moveq   #BLK.TOPSOLID,d5
        bsr.w   _physGetFloorAttr
        move.b  angleRight.w,d3
        btst    #0,d3
        beq.s   .Exit
        move.b  #0,d3

.Exit:                                 
        rts

; ---------------------------------------------------------------------------
; Check foot-ground information rightwards, pick foot, and report back info
; ---------------------------------------------------------------------------

_physFootChkRight:                  
        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.XRad(a0),d0
        ext.w   d0
        sub.w   d0,d2
        move.b  obj.YRad(a0),d0
        ext.w   d0
        add.w   d0,d3
        lea     angleRight.w,a4
        movea.w #16,a3
        move.w  #0,d6
        moveq   #BLK.BTMSOLID ,d5
        bsr.w   _physGetWallAttr

        move.w  d1,-(sp)

        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.XRad(a0),d0
        ext.w   d0
        add.w   d0,d2
        move.b  obj.YRad(a0),d0
        ext.w   d0
        add.w   d0,d3
        lea     angleLeft.w,a4
        movea.w #16,a3
        move.w  #0,d6
        moveq   #BLK.BTMSOLID ,d5
        bsr.w   _physGetWallAttr

        move.w  (sp)+,d0

        move.b  #$C0,d2
        bra.w   _physFootChkPick

; ---------------------------------------------------------------------------
; Basic collision check rightwards which only uses object origin (Y), (X+10)
; ---------------------------------------------------------------------------

_physChkRight:                     
        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3

.User:                 
        addi.w  #10,d3                  ; Add 10 to origin X-pos

        lea     angleRight.w,a4
        movea.w #16,a3
        move.w  #0,d6
        moveq   #$E,d5
        bsr.w   _physGetWallAttr
        move.b  #$C0,d2
        bra.w   _physRoundAngle

; ---------------------------------------------------------------------------
; 
; ---------------------------------------------------------------------------

_objectColChkRight:                   
        add.w   obj.X(a0),d3
        move.w  obj.Y(a0),d2
        lea     angleRight.w,a4
        move.b  #0,(a4)
        movea.w #16,a3
        move.w  #0,d6
        moveq   #$E,d5
        bsr.w   _physGetWallAttr
        move.b  angleRight.w,d3
        btst    #0,d3
        beq.s   .NoSnap
        move.b  #$C0,d3

.NoSnap:                               
        rts

; ---------------------------------------------------------------------------
; Check foot-ground information upwards, pick foot, and report back info
; ---------------------------------------------------------------------------

_physFootChkUp:                    
        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.YRad(a0),d0
        ext.w   d0
        sub.w   d0,d2
        eori.w  #$F,d2
        move.b  obj.XRad(a0),d0
        ext.w   d0
        add.w   d0,d3
        lea     angleRight.w,a4
        movea.w #-16,a3
        move.w  #(1<<BLK.YFLIP),d6
        moveq   #BLK.BTMSOLID,d5
        bsr.w   _physGetFloorAttr

        move.w  d1,-(sp)

        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.YRad(a0),d0
        ext.w   d0
        sub.w   d0,d2
        eori.w  #$F,d2
        move.b  obj.XRad(a0),d0
        ext.w   d0
        sub.w   d0,d3
        lea     angleLeft.w,a4
        movea.w #-16,a3
        move.w  #(1<<BLK.YFLIP),d6
        moveq   #BLK.BTMSOLID,d5
        bsr.w   _physGetFloorAttr

        move.w  (sp)+,d0

        move.b  #$80,d2
        bra.w   _physFootChkPick

; ---------------------------------------------------------------------------
; Basic collision check downwards which only uses object origin (Y-10), (X)
; ---------------------------------------------------------------------------

_physChkUp:
        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3

.User:                  
        subi.w  #10,d2          ; Subtract 10 from origin Y-pos
        eori.w  #$F,d2          ; Reverse position within block

        lea     angleRight.w,a4
        movea.w #-16,a3
        move.w  #(1<<BLK.YFLIP),d6
        moveq   #BLK.BTMSOLID,d5
        bsr.w   _physGetFloorAttr
        move.b  #$80,d2
        bra.w   _physRoundAngle

; ---------------------------------------------------------------------------

_objectColChkUp:                     
        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.YRad(a0),d0
        ext.w   d0
        sub.w   d0,d2
        eori.w  #$F,d2
        lea     angleRight.w,a4
        movea.w #-16,a3
        move.w  #(1<<BLK.YFLIP),d6
        moveq   #BLK.BTMSOLID,d5
        bsr.w   _physGetFloorAttr
        move.b  angleRight.w,d3
        btst    #0,d3
        beq.s   .Exit
        move.b  #$80,d3

.Exit:                                 
        rts

; ---------------------------------------------------------------------------
; Check foot-ground information leftwards, pick foot, and report back info
; ---------------------------------------------------------------------------

_physFootChkLeft:                   
        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.XRad(a0),d0
        ext.w   d0
        sub.w   d0,d2
        move.b  obj.YRad(a0),d0
        ext.w   d0
        sub.w   d0,d3
        eori.w  #$F,d3
        lea     angleRight.w,a4
        movea.w #-16,a3
        move.w  #(1<<BLK.XFLIP),d6
        moveq   #BLK.BTMSOLID,d5
        bsr.w   _physGetWallAttr

        move.w  d1,-(sp)

        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3
        moveq   #0,d0
        move.b  obj.XRad(a0),d0
        ext.w   d0
        add.w   d0,d2
        move.b  obj.YRad(a0),d0
        ext.w   d0
        sub.w   d0,d3
        eori.w  #$F,d3
        lea     angleLeft.w,a4
        movea.w #-16,a3
        move.w  #(1<<BLK.XFLIP),d6
        moveq   #BLK.BTMSOLID,d5
        bsr.w   _physGetWallAttr

        move.w  (sp)+,d0

        move.b  #$40,d2 
        bra.w   _physFootChkPick

; ---------------------------------------------------------------------------
; Basic collision check leftwards which only uses object origin (Y), (X-10)
; ---------------------------------------------------------------------------


_physChkLeft:                      
        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3

.User:                  
        subi.w  #10,d3          ; Subtract 10 from origin X-pos
        eori.w  #$F,d3          ; Reverse position in block

        lea     angleRight.w,a4
        movea.w #-16,a3
        move.w  #(1<<BLK.XFLIP),d6
        moveq   #BLK.BTMSOLID ,d5
        bsr.w   _physGetWallAttr
        move.b  #$40,d2 
        bra.w   _physRoundAngle

; ---------------------------------------------------------------------------

_objectColChkLeft:                    
        add.w   obj.X(a0),d3
        move.w  obj.Y(a0),d2
        lea     angleRight.w,a4
        move.b  #0,(a4)
        movea.w #-16,a3
        move.w  #(1<<BLK.XFLIP),d6
        moveq   #BLK.BTMSOLID,d5
        bsr.w   _physGetWallAttr
        move.b  angleRight.w,d3
        btst    #0,d3
        beq.s   .Exit
        move.b  #$40,d3 

.Exit:                                 
        rts