; ---------------------------------------------------------------------------
; Camera System level initialize routines
; Player start position is updated here, for some reason.
; ---------------------------------------------------------------------------

CameraInit:                       
	moveq   #0,d0
	move.b  d0,autoscrollX.w
	move.b  d0,autoscrollY.w
	move.b  d0,redrawUnk1.w
	move.b  d0,redrawUnk2.w
	move.b  d0,eventRoutine.w

	move.w  zone.w,d0
	lsl.b   #6,d0
	lsr.w   #4,d0
	move.w  d0,d1
	add.w   d0,d0
	add.w   d1,d0
	lea     CamInitTbl(pc,d0.w),a0

	move.w  (a0)+,d0 		; Set camA routine no. (unused)
	move.w  d0,camARoutine.w

	move.l  (a0)+,d0 		; Set Left and Right limits
	move.l  d0,limitALeft.w 	; (Each lim is a word in memory)
	move.l  d0,eventLimALeft.w 

	cmp.w   limitALeft.w,d0 	; ..check value right after setting it?
	bne.s   .NoXReset		
	move.b  #1,autoscrollX.w

.NoXReset:                             
	move.l  (a0)+,d0 		; Set Up and Down limits
	move.l  d0,limitAUp.w
	move.l  d0,eventLimAUp.w

	cmp.w   limitAUp.w,d0 		 ; ..and again
	bne.s   .NoYReset
	move.b  #1,autoscrollY.w

.NoYReset:                             
	move.w  limitALeft.w,d0
	addi.w  #576,d0
	move.w  d0,camAKeepH.w 		; Set camA "H keep", unknown, unused
	move.w  (a0)+,d0 		; (see ../doc/camera)
	move.w  d0,camACenterY.w

	bra.w   InitPlayerInfo 		; Initialize player object (and exit)

; ---------------------------------------------------------------------------

CamInitTbl:
	;     r_no,  left, 	right,	       up,	down,   center
	dc.w	4,	0,	$24BF,		0,	$300,	$60 	; GHZ
	dc.w 	4,	0,	$1EBF,		0,	$300,	$60 	;
	dc.w	4,	0,	$2960,		0,	$300,	$60 	;
	dc.w	4,	0,	$2ABF,		0,	$300,	$60 	;
		
	dc.w	4,	0,	$17BF,		0,	$720,	$60 	; LZ
	dc.w	4,	0,	 $EBF,		0,	$720,	$60 	;
	dc.w	4,	0,	$1EBF,		0,	$720,	$60 	;
	dc.w	4,	0,	$1EBF,		0,	$720,	$60 	;
		
	dc.w	4,	0,	$17BF,		0,	$1D0,	$60 	; MZ
	dc.w	4,	0,	$1BBF,		0,	$520,	$60 	;
	dc.w	4,	0,	$163F,		0,	$720,	$60 	;
	dc.w	4,	0,	$16BF,		0,	$720,	$60 	;
		
	dc.w	4,	0,	$1EBF,		0,	$640,	$60 	; SLZ
	dc.w	4,	0,	$20BF,		0,	$640,	$60 	;
	dc.w	4,	0,	$1EBF,		0,	$6C0,	$60 	;
	dc.w	4,	0,	$3EC0,		0,	$720,	$60 	;
		
	dc.w	4,	0,	$22C0,		0,	$420,	$60 	; SZ
	dc.w	4,	0,	$28C0,		0,	$520,	$60 	;
	dc.w	4,	0,	$2EC0,		0,	$620,	$60 	;
	dc.w	4,	0,	$29C0,		0,	$620,	$60 	;
		
	dc.w	4,	0,	$3EC0,		0,	$720,	$60 	; CWZ
	dc.w	4,	0,	$3EC0,		0,	$720,	$60 	;
	dc.w	4,	0,	$3EC0,		0,	$720,	$60 	;
	dc.w	4,	0,	$3EC0,		0,	$720,	$60 	;
		
	dc.w	4,	0,	$2FFF,		0,	$320,	$60 	; Unk
	dc.w	4,	0,	$2FFF,		0,	$320,	$60 	;
	dc.w	4,	0,	$2FFF,		0,	$320,	$60 	;
	dc.w	4,	0,	$2FFF,		0,	$320,	$60 	;
	
; ---------------------------------------------------------------------------
; Initialize 
; ---------------------------------------------------------------------------

InitPlayerInfo:                    
	move.w  zone.w,d0
	cmpi.b  #ACT4,d0        ; Check if act 4
	bne.s   .NotAct4
	subq.b  #1,act.w      	; If so, subtract 1 and set zone to act 3

.NotAct4:                              
	lsl.b   #6,d0
	lsr.w   #4,d0
	lea     PlayStartLocs(pc,d0.w),a1
	moveq   #0,d1
	move.w  (a1)+,d1
	move.w  d1,(objSlot00+obj.X).w
	subi.w  #$A0,d1
	bcc.s   .UsePlayPosX
	moveq   #0,d1

.UsePlayPosX:                          
	move.w  d1,(cameraAPosX).w
	moveq   #0,d0
	move.w  (a1),d0
	move.w  d0,(objSlot00+obj.Y).w
	subi.w  #$60,d0
	bcc.s   .UsePlayPosY
	moveq   #0,d0

.UsePlayPosY:                          
	cmp.w   limitADown.w,d0
	blt.s   .LimNotMet
	move.w  limitADown.w,d0

.LimNotMet:                            
	move.w  d0,cameraAPosY.w
	bsr.w   InitBgCams
	moveq   #0,d0
	move.b  zone.w,d0
	lsl.b   #2,d0
	move.l  SpecialChunkIDs(pc,d0.w),specialChunks.w
	bra.w   InitScrollBlocks

; ---------------------------------------------------------------------------

PlayStartLocs:                         
	dc.w $50,$3B0 	; GHZ
	dc.w $50,$FC
	dc.w $50,$3B0
	dc.w $80,$A8

	dc.w $60,$6C 	; LZ
	dc.w $50,$EC
	dc.w $50,$2EC
	dc.w $80,$A8

	dc.w $30,$266 	; MZ
	dc.w $30,$266
	dc.w $30,$166
	dc.w $80,$A8

	dc.w $40,$2EC 	; SLZ
	dc.w $40,$16C
	dc.w $40,$16C
	dc.w $80,$A8

	dc.w $30,$3BD   ; SZ
	dc.w $30,$18E
	dc.w $30,$EC
	dc.w $80,$A8

	dc.w $30,$48C   ; CWZ
	dc.w $98,$28C
	dc.w $80,$A8
	dc.w $80,$A8

	dc.w $80,$A8    ; Unk
	dc.w $80,$A8
	dc.w $80,$A8
	dc.w $80,$A8

; ---------------------------------------------------------------------------

SpecialChunkIDs:                        
	dc.b $B5,$7F,$1F,$20    ; GHZ
	dc.b $7F,$7F,$7F,$7F    ; LZ
	dc.b $7F,$7F,$7F,$7F    ; MZ
	dc.b $B5,$A8,$7F,$7F    ; SLZ
	dc.b $7F,$7F,$7F,$7F    ; SZ
	dc.b $7F,$7F,$7F,$7F	; CWZ

; ---------------------------------------------------------------------------

InitScrollBlocks:                       
	moveq   #0,d0
	move.b  zone.w,d0
	lsl.w   #3,d0
	lea     .Limits(pc,d0.w),a1
	lea     camASizeY.w,a2
	move.l  (a1)+,(a2)+
	move.l  (a1)+,(a2)+
	rts

; ---------------------------------------------------------------------------
.Limits:                               
	dc.w $70 	; GHZ
	dc.w $100
	dc.w $100
	dc.w $100

	dc.w $800 	; LZ
	dc.w $100
	dc.w $100
	dc.w 0

	dc.w $800 	; MZ
	dc.w $100
	dc.w $100
	dc.w 0

	dc.w $800	; SLZ
	dc.w $100
	dc.w $100
	dc.w 0

	dc.w $800	; SZ
	dc.w $100
	dc.w $100
	dc.w 0

	dc.w $800	; CWZ
	dc.w $100
	dc.w $100
	dc.w 0


; ---------------------------------------------------------------------------
; Initialize all background cameras (B, C, and Z)
;
; INPUTS: 
;	d0  =  Player Y-pos
;	d1  =  Player X-pos
; ---------------------------------------------------------------------------


InitBgCams:                             
	move.w  d0,cameraBPosY.w
	move.w  d0,cameraCPosY.w
	swap    d1
	move.l  d1,cameraBPosX.w
	move.l  d1,cameraCPosX.w
	move.l  d1,cameraZPosX.w
	moveq   #0,d2
	move.b  zone.w,d2
	add.w   d2,d2
	move.w  .BGIndex(pc,d2.w),d2
	jmp     .BGIndex(pc,d2.w)
; ---------------------------------------------------------------------------

.BGIndex:                              
	dc.w BgInit_GHZ-.BGIndex
	dc.w BgInit_LZ -.BGIndex
	dc.w BgInit_MZ -.BGIndex
	dc.w BgInit_SLZ-.BGIndex
	dc.w BgInit_SZ -.BGIndex
	dc.w BgInit_CWZ-.BGIndex

; ---------------------------------------------------------------------------

BgInit_GHZ:                             
	bra.w   Scroll_GreenHill

; ---------------------------------------------------------------------------

BgInit_LZ:                              
	rts

; ---------------------------------------------------------------------------

BgInit_MZ:                              
	rts

; ---------------------------------------------------------------------------

BgInit_SLZ:                             
	asr.l   #1,d0
	addi.w  #$C0,d0
	move.w  d0,cameraBPosY.w
	rts

; ---------------------------------------------------------------------------

BgInit_SZ:                              
	asl.l   #4,d0
	move.l  d0,d2
	asl.l   #1,d0
	add.l   d2,d0
	asr.l   #8,d0
	move.w  d0,cameraBPosY.w
	move.w  d0,cameraCPosY.w
	rts

; ---------------------------------------------------------------------------

BgInit_CWZ:                             
	rts