; ---------------------------------------------------------------------------
; Level Initialization Subroutines
; ---------------------------------------------------------------------------

; ---------------------------------------------------------------------------
; Process level header, loading the chunks, blocks, layout, and art list
; ---------------------------------------------------------------------------

ProcessZoneHeader:                     
        moveq   #0,d0
        move.b  zone.w,d0
        lsl.w   #4,d0
        lea     LevelHeaders,a2
        lea     (a2,d0.w),a2
        move.l  a2,-(sp)
        addq.l  #4,a2
        movea.l (a2)+,a0
        lea     levelBlocks.w,a4
        move.w  #$5FF,d0

.Loop:                                 
        move.l  (a0)+,(a4)+
        dbf     d0,.Loop
        movea.l (a2)+,a0
        lea     levelChunks,a1
        bsr.w   KosDec
        bsr.w   InitZoneLayout
        move.w  (a2)+,d0
        move.w  (a2),d0
        andi.w  #$FF,d0
        bsr.w   PalQueueForFade
        movea.l (sp)+,a2
        addq.w  #4,a2
        moveq   #0,d0
        move.b  (a2),d0
        beq.s   .Return
        bsr.w   LoadArtList

.Return:                               
        rts

; ---------------------------------------------------------------------------
; Unused function to draw an arcade styled lives system to the window plane
; This draws to the corner of the screen, using unknown tiles
; ---------------------------------------------------------------------------

DrawLivesWindow:
        moveq   #0,d0
        move.b  lives.w,d1
        cmpi.b  #2,d1           ; Check if initializing
        bcs.s   .StartDraw      ; Initialize if so
        move.b  d1,d0
        subq.b  #1,d0
        cmpi.b  #5,d0           ; Check if more than 4 lives
        bcs.s   .StartDraw      ; If not, draw current amount
        move.b  #4,d0           ; But if so, limit to 4 icons

.StartDraw:                            
        lea     VDPDATA,a6
        move.l  #$6CBE0002,VDPCTRL      ; Set write addr to 0xACBE
        move.l  #$8579857A,d2           ; Set top 2 tile IDs with high priority
        bsr.s   .GetDrawCount
        move.l  #$6D3E0002,VDPCTRL      ; Set write addr to 0xAD3E
        move.l  #$857B857C,d2           ; Set bottom 2 tile IDs with high priority

.GetDrawCount:                         
        moveq   #0000,d3                ; Represent empty lives with empty box
        moveq   #4-1,d1                 ; Set amount to 4
        sub.w   d0,d1                   ; Should we immediately draw lives?
        bcs.s   .StartIconDraw          ; If so, draw a life in every box

.DrawEmptyBox:                         
        move.l  d3,(a6)                  ; Otherwise, draw empty lives box
        dbf     d1,.DrawEmptyBox

.StartIconDraw:                        
        move.w  d0,d1
        subq.w  #1,d1          ; Decrement loop count
        bcs.s   .Exit          ; Exit when finished

.DrawIcon:                             
        move.l  d2,(a6)
        dbf     d1,.DrawIcon

.Exit:                                 
        rts

; ---------------------------------------------------------------------------
; Load the current zone's A and B layouts into layout RAM
; In RAM they are merged to an alternating pattern of A,B,A,B every 64 bytes
; ---------------------------------------------------------------------------

InitZoneLayout:                        
        lea     layoutA.w,a3
        move.w  #512-1,d1
        moveq   #0,d0

.ClearLoop:                            
        move.l  d0,(a3)+
        dbf     d1,.ClearLoop
        lea     layoutA.w,a3
        moveq   #0,d1
        bsr.w   .LoadLayout
        lea     layoutB.w,a3
        moveq   #2,d1

.LoadLayout:                           
        move.w  zone.w,d0       ; Use current zone as index value
        lsl.b   #6,d0           ; act
        lsr.w   #5,d0           ; Calculate
        move.w  d0,d2
        add.w   d0,d0
        add.w   d2,d0
        add.w   d1,d0
        lea     LevelLayoutIndex,a1
        move.w  (a1,d0.w),d0
        lea     (a1,d0.w),a1    ; a1 = Current level layout data
        moveq   #0,d1
        move.w  d1,d2
        move.b  (a1)+,d1        ; Get width and height
        move.b  (a1)+,d2

.LoopHeight:                           
        move.w  d1,d0
        movea.l a3,a0

.LoopWidth:                          
        move.b  (a1)+,(a0)+
        dbf     d0,.LoopWidth
        lea     128(a3),a3
        dbf     d2,.LoopHeight
        rts