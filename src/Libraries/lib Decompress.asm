; -------------------------------------------------------------------------
; Decompress Nemesis data into RAM 
; (Documentation taken from Sonic CD Disassembly)
; ---------------------------------------------------------------------------
; PARAMETERS:
;       a0 - Nemesis data pointer
;       a4 - Destination if decompressing to RAM
; ---------------------------------------------------------------------------

NemDec:
        movem.l d0-a1/a3-a5,-(sp)
        lea     NemPCD_WriteRowToVDP,a3         ; Write all data to the same location
        lea     VDPDATA,a4                      ; VDP data port
        bra.s   NemDecMain

.ToRAM:
        movem.l d0-a1/a3-a5,-(sp)
        lea     NemPCD_WriteRowToRAM,a3         ; Advance to the next location after each write

; ---------------------------------------------------------------------------

NemDecMain:
        lea     globalBuffer.w,a1               ; Prepare decompression buffer
        move.w  (a0)+,d2                        ; Get number of patterns
        lsl.w   #1,d2
        bcc.s   .NormalMode                     ; Branch if not in XOR mode
        adda.w  #NemPCD_WriteRowToVDP_XOR-NemPCD_WriteRowToVDP,a3

.NormalMode:
        lsl.w   #2,d2                           ; Get number of 8-pixel rows in the uncompressed data
        movea.w d2,a5                           ; and store it in a5
        moveq   #8,d3                           ; 8 pixels in a pattern row
        moveq   #0,d2
        moveq   #0,d4
        bsr.w   NemDec_BuildCodeTable
        move.b  (a0)+,d5                        ; Get first word of compressed data
        asl.w   #8,d5
        move.b  (a0)+,d5
        move.w  #16,d6                          ; Set initial shift value
        bsr.s   NemDec_ProcessCompressedData
        movem.l (sp)+,d0-a1/a3-a5
        rts

; ---------------------------------------------------------------------------

NemDec_ProcessCompressedData:
        move.w  d6,d7
        subq.w  #8,d7                           ; Get shift value
        move.w  d5,d1
        lsr.w   d7,d1                           ; Shift so that the high bit of the code is in bit 7
        cmpi.b  #%11111100,d1                   ; Are the high 6 bits set?
        bcc.s   NemPCD_InlineData               ; If they are, it signifies inline data
        andi.w  #$FF,d1
        add.w   d1,d1
        move.b  (a1,d1.w),d0                    ; Get the length of the code in bits
        ext.w   d0
        sub.w   d0,d6                           ; Subtract from shift value so that the next code is read next time around
        cmpi.w  #9,d6                           ; Does a new byte need to be read?
        bcc.s   .GotEnoughBits                  ; If not, branch
        addq.w  #8,d6
        asl.w   #8,d5
        move.b  (a0)+,d5                        ; Read next byte

.GotEnoughBits:
        move.b  1(a1,d1.w),d1
        move.w  d1,d0
        andi.w  #$F,d1                          ; Get palette index for pixel
        andi.w  #$F0,d0

NemDec_GetRunLength:
        lsr.w   #4,d0                           ; Get repeat count

NemDec_RunLoop:
        lsl.l   #4,d4                           ; Shift up by a nibble
        or.b    d1,d4                           ; Write pixel
        subq.w  #1,d3                           ; Has an entire 8-pixel row been written?
        bne.s   NemPCD_WritePixel_Loop          ; If not, loop
        jmp     (a3)                            ; Otherwise, write the row to its destination

; ---------------------------------------------------------------------------

NemPCD_NewRow:
        moveq   #0,d4           ; Reset row
        moveq   #8,d3           ; Reset nibble counter

NemPCD_WritePixel_Loop:
        dbf     d0,NemDec_RunLoop
        bra.s   NemDec_ProcessCompressedData

; ---------------------------------------------------------------------------

NemPCD_InlineData:
        subq.w  #6,d6           ; 6 bits needed to signal inline data
        cmpi.w  #9,d6
        bcc.s   .GotEnoughBits
        addq.w  #8,d6
        asl.w   #8,d5
        move.b  (a0)+,d5

.GotEnoughBits:
        subq.w  #7,d6           ; And 7 bits needed for the inline data itself
        move.w  d5,d1
        lsr.w   d6,d1           ; Shift so that the low bit of the code is in bit 0
        move.w  d1,d0
        andi.w  #$F,d1          ; Get palette index for pixel
        andi.w  #$70,d0         ; High nibble is repeat count for pixel
        cmpi.w  #9,d6
        bcc.s   NemDec_GetRunLength
        addq.w  #8,d6
        asl.w   #8,d5
        move.b  (a0)+,d5
        bra.s   NemDec_GetRunLength

; ---------------------------------------------------------------------------

NemPCD_WriteRowToVDP:
        move.l  d4,(a4)         ; Write 8-pixel row
        subq.w  #1,a5
        move.w  a5,d4           ; Have all the 8-pixel rows been written?
        bne.s   NemPCD_NewRow   ; If not, branch
        rts

; ---------------------------------------------------------------------------

NemPCD_WriteRowToVDP_XOR:
        eor.l   d4,d2           ; XOR the previous row with the current row
        move.l  d2,(a4)                         ; and store it
        subq.w  #1,a5
        move.w  a5,d4           ; Have all the 8-pixel rows been written?
        bne.s   NemPCD_NewRow   ; If not, branch
        rts

; ---------------------------------------------------------------------------

NemPCD_WriteRowToRAM:
        move.l  d4,(a4)+        ; Write 8-pixel row
        subq.w  #1,a5
        move.w  a5,d4           ; Have all the 8-pixel rows been written?
        bne.s   NemPCD_NewRow   ; If not, branch
        rts

; ---------------------------------------------------------------------------

NemPCD_WriteRowToRAM_XOR:
        eor.l   d4,d2           ; XOR the previous row with the current row
        move.l  d2,(a4)+        ; and store it
        subq.w  #1,a5
        move.w  a5,d4           ; Have all the 8-pixel rows been written?
        bne.s   NemPCD_NewRow   ; If not, branch
        rts

; ---------------------------------------------------------------------------

NemDec_BuildCodeTable:
        move.b  (a0)+,d0                        ; Read first byte

NemBCT_ChkEnd:
        cmpi.b  #$FF,d0                         ; Has the end of the code table description been reached?
        bne.s   NemBCT_NewPalIndex              ; If not, branch
        rts

NemBCT_NewPalIndex:
        move.w  d0,d7

NemBCT_Loop:
        move.b  (a0)+,d0                        ; Read next byte
        cmpi.b  #$80,d0                         ; Sign bit signifies a new palette index
        bcc.s   NemBCT_ChkEnd

        move.b  d0,d1
        andi.w  #$F,d7                          ; Get palette index
        andi.w  #$70,d1                         ; Get repeat count for palette index
        or.w    d1,d7                           ; Combine the 2
        andi.w  #$F,d0                          ; Get the length of the code in bits
        move.b  d0,d1
        lsl.w   #8,d1
        or.w    d1,d7                           ; Combine with palette index and repeat count to form code table entry
        moveq   #8,d1
        sub.w   d0,d1                           ; Is the code 8 bits long?
        bne.s   NemBCT_ShortCode                ; If not, a bit of extra processing is needed
        move.b  (a0)+,d0                        ; Get code
        add.w   d0,d0                           ; Each code gets a word sized entry in the table
        move.w  d7,(a1,d0.w)                    ; Store the entry for the code

        bra.s   NemBCT_Loop                     ; Loop

NemBCT_ShortCode:
        move.b  (a0)+,d0                        ; Get code
        lsl.w   d1,d0                           ; Get index into code table
        add.w   d0,d0                           ; Shift so that the high bit is in bit 7
        moveq   #1,d5
        lsl.w   d1,d5
        subq.w  #1,d5                           ; d5 = 2^d1 - 1

NemBCT_ShortCode_Loop:
        move.w  d7,(a1,d0.w)                    ; Store entry
        addq.w  #2,d0                           ; Increment index
        dbf     d5,NemBCT_ShortCode_Loop        ; Repeat for required number of entries

        bra.s   NemBCT_Loop                     ; Loop 
        
; ---------------------------------------------------------------------------
; Load an art list (known as "PLCs" elsewhere)
; ---------------------------------------------------------------------------
; PARAMETERS:
;       d0.w - Artlist ID
; ---------------------------------------------------------------------------

LoadArtList:                         
        movem.l a1-a2,-(sp)

        lea     ArtListIndex,a1
        add.w   d0,d0
        move.w  (a1,d0.w),d0
        lea     (a1,d0.w),a1
        lea     decompQueue.w,a2

.Loop:                                 
        tst.l   (a2)
        beq.s   .FoundFree
        addq.w  #6,a2
        bra.s   .Loop

.FoundFree:                            
        move.w  (a1)+,d0
        bmi.s   .End

.Load:                                 
        move.l  (a1)+,(a2)+
        move.w  (a1)+,(a2)+
        dbf     d0,.Load

.End:                                  
        movem.l (sp)+,a1-a2

        rts


; ---------------------------------------------------------------------------
; Clear any existing queue entries and initialize with a new art list
; ---------------------------------------------------------------------------
; PARAMETERS:
;       d0.w - Artlist ID
; ---------------------------------------------------------------------------

InitArtListLoad:                           
        movem.l a1-a2,-(sp)
        lea     ArtListIndex,a1
        add.w   d0,d0
        move.w  (a1,d0.w),d0
        lea     (a1,d0.w),a1
        bsr.s   ClearArtListQueue
        lea     decompQueue.w,a2
        move.w  (a1)+,d0
        bmi.s   .End

.Load:                               
        move.l  (a1)+,(a2)+
        move.w  (a1)+,(a2)+
        dbf     d0,.Load

.End:                               
        movem.l (sp)+,a1-a2
        rts


; ---------------------------------------------------------------------------
; Clear the art list queue
; ---------------------------------------------------------------------------

ClearArtListQueue:                      
        lea     decompQueue.w,a2
        moveq   #32-1,d0

.Loop:                                 
        clr.l   (a2)+
        dbf     d0,.Loop
        rts

; ---------------------------------------------------------------------------
; Process any entries in the art list decompression queue
; ---------------------------------------------------------------------------

ProcessArtLoading:                      
        tst.l   decompQueue.w
        beq.s   .End

        tst.w   decompTileCount.w
        bne.s   .End

        movea.l decompQueue.w,a0
        lea     NemPCD_WriteRowToVDP,a3
        lea     globalBuffer.w,a1
        move.w  (a0)+,d2
        bpl.s   .NotXOR
        adda.w  #NemPCD_WriteRowToVDP_XOR-NemPCD_WriteRowToVDP,a3

.NotXOR:                               
        andi.w  #$7FFF,d2
        move.w  d2,decompTileCount.w

        bsr.w   NemDec_BuildCodeTable

        move.b  (a0)+,d5
        asl.w   #8,d5
        move.b  (a0)+,d5
        moveq   #16,d6

        moveq   #0,d0
        move.l  a0,decompQueue.w
        move.l  a3,decompNemWrite.w
        move.l  d0,decompRepeat.w
        move.l  d0,decompPixel.w
        move.l  d0,decompRow.w
        move.l  d5,decompRead.w
        move.l  d6,decompShift.w

.End:                                  
        rts

; ---------------------------------------------------------------------------
; Decompress an art list
; The user defines whether it's fast or slow on their end
; ---------------------------------------------------------------------------

DecompArtList:

.Fast                     
        tst.w   decompTileCount.w
        beq.w   .Done

        move.w  #9,decompProcTileCnt.w
        moveq   #0,d0
        move.w  decompQueue+4.w,d0
        addi.w  #9*32,decompQueue+4.w
        bra.s   .Main

; ---------------------------------------------------------------------------

.Slow:                     
        tst.w   decompTileCount.w
        beq.s   .Done
        move.w  #3,decompProcTileCnt.w
        moveq   #0,d0
        move.w  decompQueue+4.w,d0
        addi.w  #$60,decompQueue+4.w

; -------------------------------------------------------------------------

.Main:                               
        lea     VDPCTRL,a4              ; Set a4 = VDPCTRL
        lsl.l   #2,d0
        lsr.w   #2,d0
        ori.w   #$4000,d0
        swap    d0
        move.l  d0,(a4)
        subq.w  #4,a4

        movea.l decompQueue.w,a0        ; Set decompression registers
        movea.l decompNemWrite.w,a3
        move.l  decompRepeat.w,d0
        move.l  decompPixel.w,d1
        move.l  decompRow.w,d2
        move.l  decompRead.w,d5
        move.l  decompShift.w,d6

        lea     globalBuffer.w,a1       ; Get bufferspace

.Decomp:                               
        movea.w #8,a5
        bsr.w   NemPCD_NewRow
        subq.w  #1,decompTileCount.w
        beq.s   .Pop
        subq.w  #1,decompProcTileCnt.w
        bne.s   .Decomp
        move.l  a0,decompQueue.w
        move.l  a3,decompNemWrite.w
        move.l  d0,decompRepeat.w
        move.l  d1,decompPixel.w
        move.l  d2,decompRow.w
        move.l  d5,decompRead.w
        move.l  d6,decompShift.w

.Done:                            
        rts

; ---------------------------------------------------------------------------

.Pop:                               
        lea     decompQueue.w,a0
        moveq   #$15,d0

.Loop:                                  
        move.l  6(a0),(a0)+
        dbf     d0,.Loop
        rts

; ---------------------------------------------------------------------------
; Decompress an art list immediately 
; ---------------------------------------------------------------------------

LoadArtListImm:                         
        lea     ArtListIndex,a1
        add.w   d0,d0
        move.w  (a1,d0.w),d0
        lea     (a1,d0.w),a1
        move.w  (a1)+,d1

.Load:                                 
        movea.l (a1)+,a0
        moveq   #0,d0
        move.w  (a1)+,d0
        lsl.l   #2,d0
        lsr.w   #2,d0
        ori.w   #$4000,d0
        swap    d0
        move.l  d0,VDPCTRL
        bsr.w   NemDec
        dbf     d1,.Load
        rts

; -------------------------------------------------------------------------
; Decompress Enigma tilemap data into RAM
; -------------------------------------------------------------------------
; PARAMETERS:
;       a0.l - Enigma data pointer
;       a1.l - Destination buffer pointer
;       d0.w - Base tile
; -------------------------------------------------------------------------

EniDec:
        movem.l d0-d7/a1-a5,-(sp)
        movea.w d0,a3                           ; Store base tile
        move.b  (a0)+,d0
        ext.w   d0
        movea.w d0,a5                           ; Store number of bits in inline copy value
        move.b  (a0)+,d4
        lsl.b   #3,d4                           ; Store PCCVH flags bitfield
        movea.w (a0)+,a2
        adda.w  a3,a2                           ; Store incremental copy word
        movea.w (a0)+,a4
        adda.w  a3,a4                           ; Store literal copy word
        move.b  (a0)+,d5
        asl.w   #8,d5
        move.b  (a0)+,d5                        ; Get first word in format list
        moveq   #16,d6                          ; Initial shift value

EniDec_Loop:
        moveq   #7,d0                           ; Assume a format list entry is 7 bits
        move.w  d6,d7
        sub.w   d0,d7
        move.w  d5,d1
        lsr.w   d7,d1
        andi.w  #$7F,d1                         ; Get format list entry
        move.w  d1,d2                           ; and copy it
        cmpi.w  #$40,d1                         ; Is the high bit of the entry set?
        bcc.s   .SevenBitEntry
        moveq   #6,d0                           ; If it isn't, the entry is actually 6 bits
        lsr.w   #1,d2

.SevenBitEntry:
        bsr.w   EniDec_ChkGetNextByte
        andi.w  #$F,d2                          ; Get repeat count
        lsr.w   #4,d1
        add.w   d1,d1
        jmp     EniDec_JmpTable(pc,d1.w)

; -------------------------------------------------------------------------

EniDec_Sub0:
        move.w  a2,(a1)+                        ; Copy incremental copy word
        addq.w  #1,a2                           ; Increment it
        dbf     d2,EniDec_Sub0                  ; Repeat
        bra.s   EniDec_Loop

; -------------------------------------------------------------------------

EniDec_Sub4:
        move.w  a4,(a1)+                        ; Copy literal copy word
        dbf     d2,EniDec_Sub4                  ; Repeat
        bra.s   EniDec_Loop

; -------------------------------------------------------------------------

EniDec_Sub8:
        bsr.w   EniDec_GetInlineCopyVal

.Loop:
        move.w  d1,(a1)+                        ; Copy inline value
        dbf     d2,.Loop                        ; Repeat
        bra.s   EniDec_Loop

; -------------------------------------------------------------------------

EniDec_SubA:
        bsr.w   EniDec_GetInlineCopyVal

.Loop:
        move.w  d1,(a1)+                        ; Copy inline value
        addq.w  #1,d1                           ; Increment it
        dbf     d2,.Loop                        ; Repeat
        bra.s   EniDec_Loop

; -------------------------------------------------------------------------

EniDec_SubC:
        bsr.w   EniDec_GetInlineCopyVal

.Loop:
        move.w  d1,(a1)+                        ; Copy inline value
        subq.w  #1,d1                           ; Decrement it
        dbf     d2,.Loop                        ; Repeat
        bra.s   EniDec_Loop

; -------------------------------------------------------------------------

EniDec_SubE:
        cmpi.w  #$F,d2
        beq.s   EniDec_End

.Loop4:
        bsr.w   EniDec_GetInlineCopyVal         ; Fetch new inline value
        move.w  d1,(a1)+                        ; Copy it
        dbf     d2,.Loop4                       ; Repeat
        bra.s   EniDec_Loop

; -------------------------------------------------------------------------

EniDec_JmpTable:
        bra.s   EniDec_Sub0
        bra.s   EniDec_Sub0
        bra.s   EniDec_Sub4
        bra.s   EniDec_Sub4
        bra.s   EniDec_Sub8
        bra.s   EniDec_SubA
        bra.s   EniDec_SubC
        bra.s   EniDec_SubE

; -------------------------------------------------------------------------

EniDec_End:
        subq.w  #1,a0                           ; Go back by one byte
        cmpi.w  #16,d6                          ; Were we going to start a completely new byte?
        bne.s   .NotNewByte                     ; If not, branch
        subq.w  #1,a0                           ; And another one if needed

.NotNewByte:
        move.w  a0,d0
        lsr.w   #1,d0                           ; Are we on an odd byte?
        bcc.s   .Even                           ; If not, branch
        addq.w  #1,a0                           ; Ensure we're on an even byte

.Even:
        movem.l (sp)+,d0-d7/a1-a5
        rts

; -------------------------------------------------------------------------

EniDec_GetInlineCopyVal:
        move.w  a3,d3                           ; Copy base tile
        move.b  d4,d1                           ; Copy PCCVH bitfield
        add.b   d1,d1                           ; Is the priority bit set?
        bcc.s   .NoPriority                     ; If not, branch
        subq.w  #1,d6
        btst    d6,d5                           ; Is the priority bit set in the inline render flags?
        beq.s   .NoPriority                     ; If not, branch
        ori.w   #$8000,d3                       ; Set priority bit in the base tile

.NoPriority:
        add.b   d1,d1                           ; Is the high palette line bit set?
        bcc.s   .NoPal1                         ; If not, branch
        subq.w  #1,d6
        btst    d6,d5                           ; Is the high palette line bit set in the inline render flags?
        beq.s   .NoPal1                         ; If not, branch
        addi.w  #$4000,d3                       ; Set second palette line bit

.NoPal1:
        add.b   d1,d1                           ; Is the low palette line bit set?
        bcc.s   .NoPal0                         ; If not, branch
        subq.w  #1,d6
        btst    d6,d5                           ; Is the low palette line bit set in the inline render flags?
        beq.s   .NoPal0                         ; If not, branch
        addi.w  #$2000,d3                       ; Set first palette line bit

.NoPal0:
        add.b   d1,d1                           ; Is the Y flip bit set?
        bcc.s   .NoYFlip                        ; If not, branch
        subq.w  #1,d6
        btst    d6,d5                           ; Is the Y flip bit set in the inline render flags?
        beq.s   .NoYFlip                        ; If not, branch
        ori.w   #$1000,d3                       ; Set Y flip bit

.NoYFlip:
        add.b   d1,d1                           ; Is the X flip bit set?
        bcc.s   .NoXFlip                        ; If not, branch
        subq.w  #1,d6
        btst    d6,d5                           ; Is the X flip bit set in the inline render flags?
        beq.s   .NoXFlip                        ; If not, branch
        ori.w   #$800,d3                        ; Set X flip bit

.NoXFlip:
        move.w  d5,d1
        move.w  d6,d7
        sub.w   a5,d7                           ; Subtract length in bits of inline copy value
        bcc.s   .GotEnoughBits                  ; Branch if a new word doesn't need to be read
        move.w  d7,d6
        addi.w  #16,d6
        neg.w   d7                              ; Calculate bit deficit
        lsl.w   d7,d1                           ; and make space for that many bits
        move.b  (a0),d5                         ; Get next byte
        rol.b   d7,d5                           ; and rotate the required bits into the lowest positions
        add.w   d7,d7
        and.w   EniDec_Masks-2(pc,d7.w),d5
        add.w   d5,d1                           ; Combine upper bits with lower bits

.AddBits:
        move.w  a5,d0                           ; Get length in bits of inline copy value
        add.w   d0,d0
        and.w   EniDec_Masks-2(pc,d0.w),d1      ; Mask value
        add.w   d3,d1                           ; Add base tile
        move.b  (a0)+,d5
        lsl.w   #8,d5
        move.b  (a0)+,d5
        rts

.GotEnoughBits:
        beq.s   .JustEnough                     ; If the word has been exactly exhausted, branch
        lsr.w   d7,d1                           ; Get inline copy value
        move.w  a5,d0
        add.w   d0,d0
        and.w   EniDec_Masks-2(pc,d0.w),d1      ; Mask it
        add.w   d3,d1                           ; Add base tile
        move.w  a5,d0
        bra.s   EniDec_ChkGetNextByte

.JustEnough:
        moveq   #16,d6                          ; Reset shift value
        bra.s   .AddBits

; -------------------------------------------------------------------------

EniDec_Masks:
        dc.w    1,     3,     7,     $F
        dc.w    $1F,   $3F,   $7F,   $FF
        dc.w    $1FF,  $3FF,  $7FF,  $FFF
        dc.w    $1FFF, $3FFF, $7FFF, $FFFF

; -------------------------------------------------------------------------

EniDec_ChkGetNextByte:
        sub.w   d0,d6   ; Subtract length of current entry from shift value
                        ; so that next entry is read next time around
        cmpi.w  #9,d6   ; Does a new byte need to be read?
        bcc.s   .End    ; If not, branch
        addq.w  #8,d6
        asl.w   #8,d5
        move.b  (a0)+,d5

.End:
        rts

; -------------------------------------------------------------------------
; Decompress Kosinski data into RAM
; -------------------------------------------------------------------------
; PARAMETERS:
;       a0.l - Kosinski data pointer
;       a1.l - Destination buffer pointer
; -------------------------------------------------------------------------

KosDec:
        subq.l  #2,sp                           ; Allocate 2 bytes on the stack
        move.b  (a0)+,1(sp)
        move.b  (a0)+,(sp)
        move.w  (sp),d5                         ; Get first description field
        moveq   #$F,d4                          ; Set to loop for 16 bits

KosDec_Loop:
        lsr.w   #1,d5                           ; Shift bit into the C flag
        move    sr,d6
        dbf     d4,.ChkBit
        move.b  (a0)+,1(sp)
        move.b  (a0)+,(sp)
        move.w  (sp),d5
        moveq   #$F,d4

.ChkBit:
        move    d6,ccr                          ; Was the bit set?
        bcc.s   KosDec_RLE                      ; If not, branch

        move.b  (a0)+,(a1)+                     ; Copy byte as is
        bra.s   KosDec_Loop

; -------------------------------------------------------------------------

KosDec_RLE:
        moveq   #0,d3
        lsr.w   #1,d5                           ; Get next bit
        move    sr,d6
        dbf     d4,.ChkBit
        move.b  (a0)+,1(sp)
        move.b  (a0)+,(sp)
        move.w  (sp),d5
        moveq   #$F,d4

.ChkBit:
        move    d6,ccr                          ; Was the bit set?
        bcs.s   KosDec_SeparateRLE              ; If yes, branch

        lsr.w   #1,d5                           ; Shift bit into the X flag
        dbf     d4,.Loop
        move.b  (a0)+,1(sp)
        move.b  (a0)+,(sp)
        move.w  (sp),d5
        moveq   #$F,d4

.Loop:
        roxl.w  #1,d3                           ; Get high repeat count bit
        lsr.w   #1,d5
        dbf     d4,.Loop2
        move.b  (a0)+,1(sp)
        move.b  (a0)+,(sp)
        move.w  (sp),d5
        moveq   #$F,d4

.Loop2:
        roxl.w  #1,d3                           ; Get low repeat count bit
        addq.w  #1,d3                           ; Increment repeat count
        moveq   #$FFFFFFFF,d2
        move.b  (a0)+,d2                        ; Calculate offset
        bra.s   KosDec_RLELoop

; -------------------------------------------------------------------------

KosDec_SeparateRLE:
        move.b  (a0)+,d0                        ; Get first byte
        move.b  (a0)+,d1                        ; Get second byte
        moveq   #$FFFFFFFF,d2
        move.b  d1,d2
        lsl.w   #5,d2
        move.b  d0,d2                           ; Calculate offset
        andi.w  #7,d1                           ; Does a third byte need to be read?
        beq.s   KosDec_SeparateRLE2             ; If yes, branch
        move.b  d1,d3                           ; Copy repeat count
        addq.w  #1,d3                           ; Increment

KosDec_RLELoop:
        move.b  (a1,d2.w),d0                    ; Copy appropriate byte
        move.b  d0,(a1)+                        ; Repeat
        dbf     d3,KosDec_RLELoop
        bra.s   KosDec_Loop

; -------------------------------------------------------------------------

KosDec_SeparateRLE2:
        move.b  (a0)+,d1
        beq.s   KosDec_Done                     ; 0 indicates end of compressed data
        cmpi.b  #1,d1
        beq.w   KosDec_Loop                     ; 1 indicates new description to be read
        move.b  d1,d3                           ; Otherwise, copy repeat count
        bra.s   KosDec_RLELoop

; -------------------------------------------------------------------------

KosDec_Done:
        addq.l  #2,sp                           ; Deallocate the 2 bytes
        rts
