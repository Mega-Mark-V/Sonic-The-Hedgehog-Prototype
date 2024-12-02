 ; ---------------------------------------------------------------------------
 ; Palette-related functions library (Loading, Fading, Cycling)
 ;
 ; NOTES:
 ; Each palette color entry is 2 bytes, or a word
 ; Stored as "0BGR", First nybble is unread by MD. 
 ;
 ; It's easier to read the offset for each starting entry as ($XY*2)
 ; X = Line (starting from 0)
 ; Y = Entry
 ;
 ; For the cycling palette on the SEGA screen, see "_logoCycPal"
 ; ---------------------------------------------------------------------------

CyclePalettes:                          
        moveq   #0,d2
        moveq   #0,d0
        move.b  zone.w,d0
        add.w   d0,d0
        move.w  .Index(pc,d0.w),d0
        jmp     .Index(pc,d0.w)

; ---------------------------------------------------------------------------
.Index:                                
                dc.w CycPal_GreenHill-.Index
                dc.w CycPal_Labyrinth-.Index
                dc.w CycPal_Marble-.Index
                dc.w CycPal_Starlight-.Index
                dc.w CycPal_Sparkling-.Index
                dc.w CycPal_ClockWork-.Index
                dc.w CycPal_Unknown-.Index
; ---------------------------------------------------------------------------

; ---------------------------------------------------------------------------
; This is a subroutine for the title loop to call instead of CyclePalettes
;
; In much earlier builds, the title's palette cycle was just Green Hill's
; as they used to use the same color for the water in the background.
;
; However, when the water's color changed for only the zone in-gameplay, 
; the cycle color data was not updated to account for this initially
;
; This small little trampoline is their solution for it, it simply provides
; the original cycling data and runs only the code needed, while the zone
; uses the updated variant to better match its brighter water.
; ---------------------------------------------------------------------------

_titleDoPalCyc:                         
        lea     PalCycData_Title,a0
        bra.s   CycPal_GreenHill.DoCycle

; ---------------------------------------------------------------------------
; Green Hill cycle
; ---------------------------------------------------------------------------

CycPal_GreenHill:                       
        lea     PalCycData_GreenHill,a0

.DoCycle:                           
        subq.w  #1,palCycTimer.w 	; Decrement timer until depleted
        bpl.s   .Wait			

        move.w  #5,palCycTimer.w
        move.w  palCycStep.w,d0
        addq.w  #1,palCycStep.w
        andi.w  #3,d0
        lsl.w   #3,d0
        lea     palette+$50.w,a1
        move.l  (a0,d0.w),(a1)+
        move.l  4(a0,d0.w),(a1)

.Wait:                            
        rts

; ---------------------------------------------------------------------------
; Labyrinth cycle
; 
; This appears to be work-in-progress, and seems bugged, but not entirely
; It looks to be targetting the wrong palette line. 
;
; But if it's set to use the palette line before it, it looks like it's 
; trying to fill the black (empty) colors in the palette. 
; 
; However, the first entry it overwrites *is* used for the black colors on
; the chiseled blocks in the foreground.
;
; This may be for an early version of Labyrinth's tileset, or a just mistake. 
; --------------------------------------------------------------------------- 

CycPal_Labyrinth:                       
        rts 	; Dummied out

        subq.w  #1,palCycTimer.w
        bpl.s   .Wait

        move.w  #5,palCycTimer.w

        move.w  palCycStep.w,d0
        addq.w  #1,palCycStep.w
        andi.w  #3,d0
        lsl.w   #3,d0
        lea     PalCycData_Labyrinth,a0
        adda.w  d0,a0
        lea     palette+($37*2).w,a1 	; Set target write addr.
        move.w  (a0)+,(a1)+ 		; write the first color
        addq.w  #4*2,a1 		; ...skip 4 color entries
        move.w  (a0)+,(a1)+ 		; write the next 3 colors
        move.l  (a0)+,(a1)+

.Wait:                                 
        rts

; ---------------------------------------------------------------------------
; Marble cycle 
; No code exists, but data does at "PalCycData_Marble", which corresponds to
; the lava's color information, but shifted right for 6 entries in a loop.
;
; A reimplementation of this does not look good with this prototype's tileset
; But may have worked much better with the tileset seen in earlier builds
; ---------------------------------------------------------------------------

CycPal_Marble:                          
                rts

; ---------------------------------------------------------------------------
; Starlight cycle 
; ---------------------------------------------------------------------------

CycPal_Starlight:                       
        subq.w  #1,palCycTimer.w
        bpl.s   .Wait

        move.w  #16,palCycTimer.w

        move.w  palCycStep.w,d0
        addq.w  #1,d0
        cmpi.w  #6,d0    		; Set step count maximum
        bcs.s   .NotMax
        moveq   #0,d0

.NotMax:                               
        move.w  d0,palCycStep.w
        move.w  d0,d1
        add.w   d1,d1
        add.w   d1,d0
        add.w   d0,d0
        lea     PalCycData_StarLight,a0
        lea     palette+($2B*2).w,a1
        move.w  (a0,d0.w),(a1)
        move.l  2(a0,d0.w),4(a1)

.Wait:                            
        rts
; ---------------------------------------------------------------------------
; Sparkling cycle 
; ---------------------------------------------------------------------------

CycPal_Sparkling:                       
        subq.w  #1,palCycTimer.w
        bpl.s   .Wait

        move.w  #5,palCycTimer.w

        move.w  palCycStep.w,d0
        move.w  d0,d1 				; Store step in d1
        addq.w  #1,palCycStep.w
        andi.w  #3,d0
        lsl.w   #3,d0
        lea     PalCycData_Sparkling1,a0
        lea     palette+($37*2).w,a1
        move.l  (a0,d0.w),(a1)+
        move.l  4(a0,d0.w),(a1)

        andi.w  #3,d1 				; Use stored step
        move.w  d1,d0
        add.w   d1,d1
        add.w   d0,d1
        add.w   d1,d1
        lea     PalCycData_Sparkling2,a0
        lea     palette+($3B*2).w,a1
        move.l  (a0,d1.w),(a1)
        move.w  4(a0,d1.w),6(a1)

.Wait:                            
        rts
; ---------------------------------------------------------------------------
; ClockWork cycle dummy
; ---------------------------------------------------------------------------

CycPal_ClockWork:                       
        rts

; ---------------------------------------------------------------------------
; A cycle routine dummy for what would likely be the ending sequence
; ---------------------------------------------------------------------------

CycPal_Unknown:                         
        rts

; ---------------------------------------------------------------------------
; !!! split these later 

PalCycData_TitleScreen:
	dc.w $C42,$E86,$ECA,$EEC 
        dc.w $EEC,$C42,$E86,$ECA
        dc.w $ECA,$EEC,$C42,$E86
        dc.w $E86,$ECA,$EEC,$C42

PalCycData_GreenHill:
	dc.w $A86,$E86,$EA8,$ECA 
        dc.w $ECA,$A86,$E86,$EA8
        dc.w $EA8,$ECA,$A86,$E86
        dc.w $E86,$EA8,$ECA,$A86

PalCycData_Labyrinth:
	dc.w $CE6,$680,$8A2,$AC4 
        dc.w $AC4,$CE6,$680,$8A2
        dc.w $8A2,$AC4,$CE6,$680
        dc.w $680,$8A2,$AC4,$CE6

PalCycData_Marble:
	dc.w $EEE,   8,  $E, $4E, $8E, $EE
        dc.w  $EE,$EEE,   8,  $E, $4E, $8E
        dc.w  $8E, $EE,$EEE,   8,  $E, $4E
        dc.w  $4E, $8E, $EE,$EEE,   8,  $E
        dc.w   $E, $4E, $8E, $EE,$EEE,   8
        dc.w    8,  $E, $4E, $8E, $EE,$EEE

PalCycData_StarLight:
	dc.w $EE0,  6,$66,$AA0 
        dc.w  $A,$22,$660, $E
        dc.w $66,$220, $A,$AA
        dc.w $660,  6,$EE,$AA0
        dc.w   2,$AA
PalCycData_Sparkling1:
	dc.w $EE,$AA,$66,$22 
        dc.w $AA,$66,$22,$EE
        dc.w $66,$22,$EE,$AA
        dc.w $22,$EE,$AA,$66
PalCycData_Sparkling2:
	dc.w  $E,$EEE,$E88,$66E 
        dc.w $E88,$E22,$EEE,$C00
        dc.w $C00,$66E,$E88,$E22

; ---------------------------------------------------------------------------
; Function to fade the palette in from black 
; ---------------------------------------------------------------------------
; !!! palFadeArgs represents word location of 2 arguments; document

PalFadeIn:                              
        move.w  #64-1,palFadeArgs.w 	; Set full size fade

.UserArgs:                     
        moveq   #0,d0 			; Get arguments
        lea     palette.w,a0
        move.b  palFadeArgs.w,d0        ; Offset
        adda.w  d0,a0
        moveq   #0,d1
        move.b  palFadeSize.w,d0        ; Size

.FillBlack:                            
        move.w  d1,(a0)+
        dbf     d0,.FillBlack
        move.w  #21-1,d4 	        ; Time in frames	

.Loop:                                 
        move.b  #vbID_PALFUNC,vblankCmd.w
        bsr.w   VSync

        bsr.s   .DoFadeCalc
        bsr.w   ProcessArtLoading
        dbf     d4,.Loop
        rts

.DoFadeCalc:                           
        moveq   #0,d0
        lea     palette.w,a0
        lea     palFadeBuffer.w,a1
        move.b  palFadeArgs.w,d0
        adda.w  d0,a0
        adda.w  d0,a1
        move.b  palFadeSize.w,d0

.DoRequestedSize:                      
        bsr.s   .CalcColor 		
        dbf     d0,.DoRequestedSize    ; Loop for the size provided
        rts

; ---------------------------------------------------------------------------

.CalcColor:                            
        move.w  (a1)+,d2
        move.w  (a0),d3
        cmp.w   d2,d3
        beq.s   .NextColor
.AddBlue:
        move.w  d3,d1
        addi.w  #$200,d1
        cmp.w   d2,d1
        bhi.s   .AddGreen
        move.w  d1,(a0)+
        rts

.AddGreen:                             
        move.w  d3,d1
        addi.w  #$20,d1
        cmp.w   d2,d1
        bhi.s   .AddRed
        move.w  d1,(a0)+
        rts

.AddRed:                               
        addq.w  #2,(a0)+
        rts

.NextColor:                            
        addq.w  #2,a0
        rts

; ---------------------------------------------------------------------------
; Function to fade a palette to black
; ---------------------------------------------------------------------------

PalFadeOut:                             
        move.w  #64-1,palFadeArgs.w
        move.w  #21-1,d4

.Loop:                                 
        move.b  #vbID_PALFUNC,(vblankCmd).w
        bsr.w   VSync

        bsr.s   .DoFadeCalc
        bsr.w   ProcessArtLoading
        dbf     d4,.Loop
        rts

; !!! note: _levelDoFadeCalc equals PalFadeOut.DoFadeCalc                    
.DoFadeCalc:
        moveq   #0,d0
        lea     palette.w,a0
        move.b  palFadeArgs.w,d0
        adda.w  d0,a0
        move.b  (palFadeSize).w,d0

.DoRequestedSize:                               
        bsr.s   .CalcColor
        dbf     d0,.DoRequestedSize
        rts

; ---------------------------------------------------------------------------

.CalcColor:                               
        move.w  (a0),d2
        beq.s   .NextColor
.DecRed:
        move.w  d2,d1
        andi.w  #$00E,d1
        beq.s   .DecGreen
        subq.w  #2,(a0)+
        rts

.DecGreen:                               
        move.w  d2,d1
        andi.w  #$0E0,d1
        beq.s   .DecBlue
        subi.w  #$20,(a0)+
        rts

.DecBlue:                               
        move.w  d2,d1
        andi.w  #$E00,d1
        beq.s   .NextColor
        subi.w  #$200,(a0)+
        rts

.NextColor:                               
        addq.w  #2,a0
        rts

; ---------------------------------------------------------------------------
; Subroutine exclusive to the SEGA screen (GM_LOGO)
; ---------------------------------------------------------------------------

_logoCycPal:                      
        subq.w  #1,palCycTimer.w
        bpl.s   .Exit
        move.w  #3,palCycTimer.w
        move.w  palCycStep.w,d0
        bmi.s   .Exit
        subq.w  #2,palCycStep.w
        lea     PalCyc_LOGO,a0
        lea     palette+(2*2).w,a1
        adda.w  d0,a0
        move.l  (a0)+,(a1)+
        move.l  (a0)+,(a1)+
        move.l  (a0)+,(a1)+
        move.l  (a0)+,(a1)+
        move.l  (a0)+,(a1)+
        move.w  (a0)+,(a1)+

.Exit:                                 
        rts

; ---------------------------------------------------------------------------
; !!! split
PalCyc_LOGO: 	
	dc.w $EC0               
        dc.w $EA0
        dc.w $E80
        dc.w $E60
        dc.w $E40
        dc.w $E20
        dc.w $E00
        dc.w $C00
        dc.w $A00
        dc.w $800
        dc.w $600
        dc.w $800
        dc.w $A00
        dc.w $C00
        dc.w $E00
        dc.w $E20
        dc.w $E40
        dc.w $E60
        dc.w $E80
        dc.w $EA0
        dc.w $EC0
        dc.w $EA0
        dc.w $E80
        dc.w $E60
        dc.w $E40
        dc.w $E20
        dc.w $E00
        dc.w $C00
        dc.w $A00
        dc.w $800
        dc.w $600

; ---------------------------------------------------------------------------
; Load a palette into the palette fading buffer, queueing it for when
; a fade in or out is called.
; ---------------------------------------------------------------------------

PalQueueForFade:                        
        lea     PaletteIndex,a1
        lsl.w   #3,d0
        adda.w  d0,a1
        movea.l (a1)+,a2 	; Get palette data address
        movea.w (a1)+,a3 	; Get target address
        adda.w  #palFadeBuffer-palette,a3  ; Move into fade buffer
        move.w  (a1)+,d7 	; Get size

.LoadToQueue:                          
        move.l  (a2)+,(a3)+
        dbf     d7,.LoadToQueue
        rts

; ---------------------------------------------------------------------------
; Load a palette into the palette loading buffer
; ---------------------------------------------------------------------------

PalLoad:                                
        lea     PaletteIndex,a1
        lsl.w   #3,d0
        adda.w  d0,a1
        movea.l (a1)+,a2 	; Get palette data address
        movea.w (a1)+,a3 	; Get target address
        move.w  (a1)+,d7 	; Get loading size 

.LoadToBuffer:                         
        move.l  (a2)+,(a3)+
        dbf     d7,.LoadToBuffer
        rts


; ---------------------------------------------------------------------------
; Macro for defining these easier (see "_include/Macros.i" for "dclww")

palentr	macro	dataddr, off, size
	dclww   \dataddr, (palette+(\off)*2).w, ((\size)/2)-1
	endm

; ---------------------------------------------------------------------------
; Palette ID entries
; ---------------------------------------------------------------------------

PaletteIndex:	      
; 	         Data       Color num.	       Size
	palentr  Pal_LOGO,	0,		64
        palentr  Pal_TITLE,	0,		64
        palentr  Pal_SELECT,	0,		64
        palentr  Pal_Sonic,	0,		16
        palentr  Pal_GHZ,	16,		48
        palentr  Pal_LZ,	16,		48
        palentr  Pal_MZ,	16,		48
        palentr  Pal_SLZ,	16,		48
        palentr  Pal_SZ,	16,		48
        palentr  Pal_CWZ,	16,		48
        palentr  Pal_SPECIAL,	0,		64
        palentr  Pal_Unk,	0,		64
; !!! split
Pal_LOGO:       dc.w   0,$EEE,$EC0,$EA0,$E80,$E60,$E40,$E20 
                dc.w $E00,$C00,$A00,$800,$600,  0,  0,  0
                dc.w   0,  0,  0,  0,  0,  0,  0,  0
                dc.w   0,  0,  0,  0,  0,  0,  0,  0
                dc.w   0,  0,  0,  0,  0,  0,  0,  0
                dc.w   0,  0,  0,  0,  0,  0,  0,  0
                dc.w   0,  0,  0,  0,  0,  0,  0,  0
                dc.w   0,  0,  0,  0,  0,  0,  0,  0
Pal_TITLE:      dc.b  $A,$20,  6,  0, $C,  0, $E,$44 
                dc.b  $E,$66, $E,$88, $E,$EE,  0,$AE
                dc.b   0,$6A,  0,$26,  0,$EE, $E,$AA
                dc.b   0, $C,  0,  6,  0,  2,  0,  0
                dc.b   0,  0, $C,  0, $E,$22, $E,$44
                dc.b  $E,$66, $E,$88, $E,$EE, $A,$AA
                dc.b   8,$88,  6,$66,  4,$44,  2,$48
                dc.b   8,$AE,  6,$8C,  0,  0,  0, $E
                dc.b   8,  0,  0,  2, $E,$EE,  0,$26
                dc.b   0,$48,  0,$6C,  0,$8E,  0,$CE
                dc.b  $C,$42, $E,$86, $E,$CA, $E,$EC
                dc.b   0,$40,  0,$60,  0,$A4,  0,$E8
                dc.b  $C,$82, $A,  2, $C,$42, $E,$86
                dc.b  $E,$CA, $E,$EC, $E,$EE, $E,$AC
                dc.b  $E,$8A, $E,$68,  0,$E8,  0,$A4
                dc.b   0,  2,  0,$26,  0,$6C,  0,$CE
Pal_SELECT:     dc.b   0,  0,  0,  0,  0,  2,  0,  2 
                dc.b   2,$24,  2,$24,  4,$46,  4,$46
                dc.b   2,$24,  2,$24,  4,$46,  6,$68
                dc.b   2,$24,  0,  2,  0,  0,  0,  0
                dc.b   0,  0,  0,  0,  0,  2,  2,$24
                dc.b   2,$24,  4,$46,  6,$68,  2,$24
                dc.b   4,$46,  2,$24,  0,  2,  2,$24
                dc.b   4,$46,  2,$24,  0,  0,  2,$24
                dc.b   0,  0,  0,$EE,  0,  0,  0,  0
                dc.b   0,  0,  0,  0,  0,$EE,  0,  0
                dc.b   0,  0,  0,  0,  0,  0,  0,  0
                dc.b   0,  0,  0,  0,  0,  0,  0,  0
                dc.b   0,  0, $E,$EC,  0,  0,  0,  0
                dc.b   0,  0,  0,  0, $E,$EC,  0,  0
                dc.b   0,  0,  0,  0,  0,  0,  0,  0
                dc.b   0,  0,  0,  0,  0,  0,  0,  0
Pal_Sonic:      dc.b   0,  0,  0,  0,  8,$22, $A,$44 
                dc.b  $C,$66, $E,$88, $E,$EE, $A,$AA
                dc.b   8,$88,  4,$44,  8,$AE,  4,$6A
                dc.b   0, $E,  0,  8,  0,  4,  0,$EE
Pal_GHZ:        dc.b   8,  0,  0,  0,  6,  8,  8,$2A 
                dc.b  $A,$4C, $C,$6E, $E,$EE, $A,$AA
                dc.b   8,$88,  4,$44, $A,$E4,  6,$A2
                dc.b   0,$EE,  0,$88,  0,$44,  0,  0
                dc.b  $E,$80,  0,  2, $E,$EE,  0,$26
                dc.b   0,$48,  0,$6C,  0,$8E,  0,$CE
                dc.b  $A,$86, $E,$86, $E,$A8, $E,$CA
                dc.b   0,$40,  0,$60,  0,$A4,  0,$E8
                dc.b  $C,$82, $A,  2, $C,$42, $E,$86
                dc.b  $E,$CA, $E,$EC, $E,$EE, $E,$AC
                dc.b  $E,$8A, $E,$68,  0,$E8,  0,$A4
                dc.b   0,  2,  0,$26,  0,$6C,  0,$CE
Pal_LZ:         dc.b   0,  0,  0,  0,  0,  0,  0,  0 
                dc.b   0,  0,  0,  0,  0,  0,  0,  0
                dc.b   0,  0,  0,  0,  0,  0,  0,  0
                dc.b   0,  0,  0,  0,  0,  0,  0,  0
                dc.b   0,  0,  0,$26,  0,$48,  0,$6A
                dc.b   2,$8C,  4,$CE,  6,$EE,  0,  0
                dc.b   0,$C0,  0,$80,  0,$40,  0,  0
                dc.b   0,  0,  0,  0,  0,  0, $E,$EE
                dc.b   0,  0,  0,  0,  0,  2,  0,$24
                dc.b   0,$46,  8,$22, $A,$66, $E,$AA
                dc.b   6,$4A,  8,$6C, $A,$8E,  0,$26
                dc.b   0,$48,  0,$6A,  0,$68, $E,$EE
Pal_Unk:        dc.b   4,  0,  0,  0,  4,  0,  6,  0 
                dc.b   8,$22, $C,$44, $C,$CC,  6,$66
                dc.b   4,$44,  0,  0,  4,$6C,  0,$26
                dc.b   0, $C,  0,  4,  0,  0,  0,$CC
                dc.b   4,  0,  0,  0,  2,  4,  4,  6
                dc.b   6,  8,  8,$2C, $C,$CC,  6,$66
                dc.b   4,$44,  0,  0,  6,$C0,  2,$60
                dc.b   0,$CC,  0,$44,  0,  0,  0,  0
                dc.b   0,  0,  0,  0, $A,$AA,  0,  2
                dc.b   0,  4,  0,$28,  0,$4A,  0,$8A
                dc.b   8,  0, $A,$42, $A,$86, $A,$A8
                dc.b   0,  0,  0,$20,  0,$60,  0,$A4
                dc.b   4,  0,  0,  0,  8,  0, $C,$42
                dc.b  $C,$86, $C,$C8, $C,$CC, $C,$48
                dc.b   6,  4,  2,  0,  0,  6,  4,$2C
                dc.b   8,$6C,  0,  0,  0,  0,  0,  0
Pal_MZ:         dc.b   8,  0,  0,  0,  6,  8,  8,$2A 
                dc.b  $A,$4C, $C,$6E, $E,$EE, $A,$AA
                dc.b   8,$88,  4,$44, $A,$E4,  6,$A2
                dc.b   0,$EE,  0,$88,  0,$44,  0,  0
                dc.b  $A,  0,  2,  2, $E,$EE,  6,$24
                dc.b   8,$46, $A,$68, $C,$8A, $E,$AC
                dc.b   0,$40,  6,$86,  8,$A8, $A,$CA
                dc.b   4,$64,  0,$62,  0,$A4,  0,$E8
                dc.b  $A,  0,  4,  2, $E,$EE,  0,  4
                dc.b   0,  8,  0, $E,  0,$8E,  0,$EE
                dc.b   8,$20, $A,$60, $C,$80, $E,$A0
                dc.b   0,$A4,  0,$E8, $E,$C0,  6,$24
Pal_SLZ:        dc.b   8,  0,  0,  0,  6,  8,  8,$2A 
                dc.b  $A,$4C, $C,$6E, $E,$EE, $A,$AA
                dc.b   8,$88,  4,$44, $A,$E4,  6,$A2
                dc.b   0,$EE,  0,$88,  0,$44,  0,  0
                dc.b   0,  0,  2,$22,  4,$44,  6,$66
                dc.b   8,$88, $A,$AA, $C,$CC,  6,$A8
                dc.b   4,$86,  2,$64,  0,$42, $E,$E0
                dc.b   0,$20,  0, $E,  0,$EE, $E,$EE
                dc.b   0,  0,  0,  2,  2,$24,  4,$46
                dc.b   0,  0,  0,  0,  0,$22,  6,  2
                dc.b   4,  0, $A,$22, $A,$44, $A,$66
                dc.b   0,  0,  0,$24,  0,$44,  0,  0
Pal_SZ:         dc.b   0,$C0,  0,  0,  4,$24,  8,$48 
                dc.b  $A,$6A, $E,$8E, $E,$EE, $A,$AA
                dc.b   8,$88,  4,$44, $A,$E4,  6,$A2
                dc.b   0,$EE,  0,$88,  0,$44,  0,  0
                dc.b   4,  0,  0,  0, $E,$EE,  8,$AE
                dc.b   4,$8C,  2,$4A,  0,$28,  0,  6
                dc.b   0,  4,  6,$C6,  2,$82,  0,$40
                dc.b  $A,$C8,  6,$84,  2,$40, $C,$4A
                dc.b   4,  0,  0,  0,  4,  6,  6,$28
                dc.b   8,$4A, $A,$6C,  0,  0,  0,$EE
                dc.b   0,$AA,  0,$66,  0,$22,  0, $E
                dc.b  $A,$60, $E,$EE, $E,$88, $C,  0
Pal_CWZ:        dc.b   0,  0,  0,  0,  0,  0,  0,  0 
                dc.b   0,  0,  0,  0, $E,$EE,  0,  0
                dc.b   8,$88,  4,$44,  0,  0,  0,  0
                dc.b   0,$EE,  0,$88,  0,$44,  0,  0
                dc.b  $A,  0,  0,  0, $E,$EE,  2,$20
                dc.b   4,$42,  6,$64,  8,$86, $C,$CA
                dc.b   0,$44,  8,$A2,  0, $E,  0, $A
                dc.b  $C,$AA,  8,$66,  4,$22,  0,  6
                dc.b   0,  0,  0,  0,  0,  0,  0,  0
                dc.b   0,  0,  0,  0,  0,  0,  0,  0
                dc.b   0,  0,  0,  0,  0,  0,  0,  0
                dc.b   0,  0,  0,  0,  0,  0,  0,  0
Pal_SPECIAL:    dc.b   4,  0,  0,  0,  8,$22, $A,$44 
                dc.b  $C,$66, $E,$88, $E,$EE, $A,$AA
                dc.b   8,$88,  4,$44,  8,$AE,  4,$6A
                dc.b   0, $E,  0,  8,  0,  4,  0,$EE
                dc.b   4,  0,  0,  0,  0,$24,  0,$68
                dc.b   0,$AC,  2,$EE, $E,$EE, $A,$AA
                dc.b   8,$88,  4,$44, $A,$E4,  6,$A2
                dc.b   0,$EE,  0,$88,  0,$44,  0,  0
                dc.b   4,  0,  0,  0,  2,  4,  6,$28
                dc.b  $A,$4C, $C,$6E, $E,$CE,  8,  0
                dc.b  $C,$42, $E,$86, $E,$CA, $E,$EC
                dc.b   0,  0, $E,$E0, $A,$A0,  4,$40
                dc.b   4,  0,  0,  0,  0,$60,  0,$A0
                dc.b   0,$C6,  0,$EA, $A,$EC, $E,$EA
                dc.b  $E,$E0, $A,$A0,  8,$80,  6,$60
                dc.b   4,$40, $E,$E0, $A,$A0,  4,$40