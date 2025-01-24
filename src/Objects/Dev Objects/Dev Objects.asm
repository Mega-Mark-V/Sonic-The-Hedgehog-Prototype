; --------------------------------------------------------------------------- 
; Development Objects
; These objects were used for testing the object system during development
;
; Dev1 and Dev2 were seen in a very early build in some on-site footage from
; SEGA R&D 2 in Feburary of 1990
; ---------------------------------------------------------------------------

dev.FrameTimer	EQU  $1E

TILE.DEV1	EQU  $4F0+$6000
TILE.DEV2	EQU  $680+$2000
TILE.DIGIT1	EQU  $4F0+$8000
TILE.DIGIT2	EQU  $470+$8000
; ---------------------------------------------------------------------------
; Development Object 1 - seems to test sprite rendering with _objectDraw
; ---------------------------------------------------------------------------

 objDev1:                                
        moveq   #0,d0
        move.b  obj.Action(a0),d0
        move.w  .Index(pc,d0.w),d1
        jmp     .Index(pc,d1.w)

; ---------------------------------------------------------------------------
.Index:                                
                dc.w Dev1_Init-.Index
                dc.w Dev1_Main-.Index
                dc.w Dev1_Exit-.Index
                dc.w Dev1_Exit-.Index
; ---------------------------------------------------------------------------

Dev1_Init:                            
        addq.b  #2,obj.Action(a0)
        move.w  #$200,obj.X(a0) 	; Sets hardcoded positions
        move.w  #$60,obj.Y(a0)

        move.l  #MapSpr_DevTest,obj.Map(a0)
        move.w  #TILE.DEV1,obj.Tile(a0) 	; Render on line 4

        move.b  #4,obj.Render(a0) 	; Render with CamA
        move.b  #1,obj.ColProp(a0) 	; ???
        move.b  #3,obj.Priority(a0)

Dev1_Main:                            
        bsr.w   _objectDraw
        subq.b  #1,dev.FrameTimer(a0)	; Wait timer depleted
        bpl.s   .Wait

        move.b  #16,dev.FrameTimer(a0)  ; Reset it

        move.b  obj.Frame(a0),d0
        addq.b  #1,d0  			; Increment frame
        cmpi.b  #2,d0 			; If frame number is 2 then cap
        bcs.s   .ChangeFrame

        moveq   #0,d0

.ChangeFrame:                          
        move.b  d0,obj.Frame(a0)

.Wait:                                 
        rts

Dev1_Exit:                            
        bsr.w   _objectDelete
        rts

; ---------------------------------------------------------------------------

	include	"Objects/Dev Objects/mapspr DevTest.asm"

; ---------------------------------------------------------------------------
; Development Object 2 - also looks to test sprite rendering
; ---------------------------------------------------------------------------

objDev2:                                

        moveq   #0,d0
        move.b  obj.Action(a0),d0
        move.w  .Index(pc,d0.w),d1
        jmp     .Index(pc,d1.w)
; ---------------------------------------------------------------------------
.Index:                                
                dc.w Dev2_Init-*
                dc.w Dev2_Main-.Index
                dc.w Dev2_Delete-.Index
                dc.w Dev2_Delete-.Index
; ---------------------------------------------------------------------------

Dev2_Init:                            
        addq.b  #2,obj.Action(a0)
        move.w  #$100,obj.X(a0) 	    	; Hardcoded positions
        move.w  #$40,obj.Y(a0)
        move.l  #MapSpr_DevTest,obj.Map(a0)
        move.w  #TILE.DEV1,obj.Tile(a0) 	; Render with palette line 4
        move.b  #4,obj.Render(a0)
        move.b  #1,obj.ColProp(a0)
        move.b  #3,obj.Frame(a0)
        move.b  #5,obj.Priority(a0)

Dev2_Main:                            
        bsr.w   _objectDraw
        subq.b  #1,dev.FrameTimer(a0) 		; Uses the same timer
        bpl.s   .Exit 				; But doesn't change frame
        move.b  #16,dev.FrameTimer(a0)

.Exit:                                 
        rts

Dev2_Delete:                          
        bsr.w   _objectDelete
        rts


; ---------------------------------------------------------------------------
; Development Object 3 - Render test but with a user X-position
; Maybe used for testing layout reading/loading? Unsure.
; ---------------------------------------------------------------------------

objDev3:                                

        moveq   #0,d0
        move.b  obj.Action(a0),d0
        move.w  .Index(pc,d0.w),d1
        jmp     .Index(pc,d1.w)
; ---------------------------------------------------------------------------
.Index:                                
                dc.w Dev3_Init-*
                dc.w Dev3_Main-.Index
                dc.w Dev3_Exit-.Index
                dc.w Dev3_Exit-.Index
; ---------------------------------------------------------------------------

Dev3_Init:                            
        addq.b  #2,obj.Action(a0)
        move.w  #$40,obj.Y(a0) 			; Set fixed Y
        move.l  #MapSpr_DevTest,obj.Map(a0)
        move.w  #TILE.DEV2,obj.Tile(a0)
        move.b  #4,obj.Render(a0)
        move.b  #1,obj.ColProp(a0)
        move.b  #2,obj.Frame(a0)
        move.b  #3,obj.Priority(a0)

Dev3_Main:                            
        bsr.w   _objectDraw
        subq.b  #1,dev.FrameTimer(a0)
        bpl.s   .Wait

        move.b  #20,dev.FrameTimer(a0)
        move.b  obj.Frame(a0),d0 
        addq.b  #1,d0 			; ...adjust frame number?
        cmpi.b  #4,d0 			; Check if frame 3+1
        bcs.s   .Skip
        moveq   #2,d0

.Skip:                            
        move.b  d0,obj.Frame(a0)

.Wait:                                 
        rts

Dev3_Exit:                            
        bsr.w   _objectDelete
        rts

; ---------------------------------------------------------------------------
; Development Object 5 - Development debugger digits
; Referenced in an unused routine over in GM_LEVEL, which loads an older
; version of the debug digits. 
;
; This object represents only 1 digit for each object.
; It expects its VRAM at tile 0x4F0 to contain characters 1-9 and hex A-F
; ---------------------------------------------------------------------------

objDevDigits1:                                
        moveq   #0,d0
        move.b  obj.Action(a0),d0
        move.w  .Index(pc,d0.w),d1
        jmp     .Index(pc,d1.w)

; ---------------------------------------------------------------------------
.Index:                                
        dc.w Test05_Init-.Index
        dc.w Test05_Main-.Index
        dc.w Test05_Exit-.Index
        dc.w Test05_Exit-.Index
; ---------------------------------------------------------------------------

Test05_Init:                            
        addq.b  #2,obj.Action(a0)
        move.l  #MapSpr_Digits,obj.Map(a0)
        move.w  #TILE.DIGIT1,obj.Tile(a0)
        move.b  #0,obj.Render(a0) 	; Render with constant screen pos.
        move.b  #7,obj.Priority(a0)

Test05_Main:                            
        bsr.w   _objectDraw
        rts

Test05_Exit:                            
        bsr.w   _objectDelete
        rts

; ---------------------------------------------------------------------------

	include	"Objects/Dev Objects/mapspr Digits.asm"

; ---------------------------------------------------------------------------
; Development Object 6 - More developer digits
; Basically the same object as objDevDigits1, but shifted onscreen by $A0
; It also uses a different VRAM position
; ---------------------------------------------------------------------------


objDevDigits2:                                
                moveq   #0,d0
                move.b  obj.Action(a0),d0
                move.w  .Index(pc,d0.w),d1
                jmp     .Index(pc,d1.w)
; ---------------------------------------------------------------------------
.Index:                                
                dc.w DevDigits2_Init-.Index
                dc.w DevDigits2_Main-.Index
                dc.w DevDigits2_Exit-.Index
                dc.w DevDigits2_Exit-.Index
; ---------------------------------------------------------------------------

DevDigits2_Init:                            
                addq.b  #2,obj.Action(a0)
                move.w  #$A0,obj.YScr(a0)
                move.l  #MapSpr_Digits,obj.Map(a0)
                move.w  #TILE.DIGIT2,obj.Tile(a0)
                move.b  #0,obj.Render(a0)
                move.b  #7,obj.Priority(a0)

DevDigits2_Main:                            
                bsr.w   _objectDraw
                rts
; ---------------------------------------------------------------------------

DevDigits2_Exit:                            
                bsr.w   _objectDelete
                rts


; ---------------------------------------------------------------------------
; Development Object 6 - Example Code? (Unknown)
; This object looks like it's the base code used for making the ones above
; Down to setting the active routine to 2 and looping forever doing nothing
; Take note of how each object has 2 exit routine entries just like this
; ---------------------------------------------------------------------------


objDev6:                                
                moveq   #0,d0
                move.b  obj.Action(a0),d0
                move.w  .Index(pc,d0.w),d1
                jmp     .Index(pc,d1.w)

; ---------------------------------------------------------------------------
.Index:                                
                dc.w Dev6_Init-.Index
                dc.w Dev6_Main-.Index
                dc.w Dev6_Exit-.Index
                dc.w Dev6_Exit-.Index
; ---------------------------------------------------------------------------

Dev6_Init:                            
                addq.b  #2,obj.Action(a0)

Dev6_Main:                            
                rts

; ---------------------------------------------------------------------------

Dev6_Exit:                            
                bsr.w   _objectDelete
                rts
