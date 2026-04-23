; ---------------------------------------------------------------------------
; Function to calculate a (psuedo) random number 
;
; OUTPUTS:
; d0.l = Randon num. 1
; d1.l = Randon num. 2
; ---------------------------------------------------------------------------

CalcRandom:
	move.l  randomSeed.w,d1
	bne.s   .NoSeedGiven
	move.l  #$2A6D365A,d1

.NoSeedGiven:
	move.l  d1,d0
	asl.l   #2,d1
	add.l   d0,d1
	asl.l   #3,d1
	add.l   d0,d1
	move.w  d1,d0
	swap    d1
	add.w   d1,d0
	move.w  d0,d1
	swap    d1
	move.l  d1,randomSeed.w
	rts

; ---------------------------------------------------------------------------
; Function to get the sine and cosine from an angle unit
; There are only 256 degree units... to store that of a full 360 circle
;
; 45  degrees = $20 units
; 90  degrees = $40 units
; 180 degrees = $80 units
; ...and so on.
;
; INPUT:
; d0.w  = Angle Unit
;
; OUTPUT:
; d0.w  =  Sine
; d1.w  =  Cosine
; ---------------------------------------------------------------------------

CalcSinCos:
	andi.w  #$FF,d0
	add.w   d0,d0
	addi.w  #$80,d0
	move.w  SineData(pc,d0.w),d1
	subi.w  #$80,d0
	move.w  SineData(pc,d0.w),d0
	rts

; ---------------------------------------------------------------------------
SineData:       
	dc.w    0,   6,  $C, $12, $19, $1F, $25, $2B    ; Conversion Table
	dc.w  $31, $38, $3E, $44, $4A, $50, $56, $5C
	dc.w  $61, $67, $6D, $73, $78, $7E, $83, $88
	dc.w  $8E, $93, $98, $9D, $A2, $A7, $AB, $B0
	dc.w  $B5, $B9, $BD, $C1, $C5, $C9, $CD, $D1
	dc.w  $D4, $D8, $DB, $DE, $E1, $E4, $E7, $EA
	dc.w  $EC, $EE, $F1, $F3, $F4, $F6, $F8, $F9
	dc.w  $FB, $FC, $FD, $FE, $FE, $FF, $FF, $FF
	dc.w $100, $FF, $FF, $FF, $FE, $FE, $FD, $FC
	dc.w  $FB, $F9, $F8, $F6, $F4, $F3, $F1, $EE
	dc.w  $EC, $EA, $E7, $E4, $E1, $DE, $DB, $D8
	dc.w  $D4, $D1, $CD, $C9, $C5, $C1, $BD, $B9
	dc.w  $B5, $B0, $AB, $A7, $A2, $9D, $98, $93
	dc.w  $8E, $88, $83, $7E, $78, $73, $6D, $67
	dc.w  $61, $5C, $56, $50, $4A, $44, $3E, $38
	dc.w  $31, $2B, $25, $1F, $19, $12,  $C,   6
	dc.w    0,  -6, -$C,-$12,-$19,-$1F,-$25,-$2B
	dc.w -$31,-$38,-$3E,-$44,-$4A,-$50,-$56,-$5C
	dc.w -$61,-$67,-$6D,-$75,-$78,-$7E,-$83,-$88
	dc.w -$8E,-$93,-$98,-$9D,-$A2,-$A7,-$AB,-$B0
	dc.w -$B5,-$B9,-$BD,-$C1,-$C5,-$C9,-$CD,-$D1
	dc.w -$D4,-$D8,-$DB,-$DE,-$E1,-$E4,-$E7,-$EA
	dc.w -$EC,-$EE,-$F1,-$F3,-$F4,-$F6,-$F8,-$F9
	dc.w -$FB,-$FC,-$FD,-$FE,-$FE,-$FF,-$FF,-$FF
	dc.w -$100,-$FF,-$FF,-$FF,-$FE,-$FE,-$FD,-$FC
	dc.w -$FB,-$F9,-$F8,-$F6,-$F4,-$F3,-$F1,-$EE
	dc.w -$EC,-$EA,-$E7,-$E4,-$E1,-$DE,-$DB,-$D8
	dc.w -$D4,-$D1,-$CD,-$C9,-$C5,-$C1,-$BD,-$B9
	dc.w -$B5,-$B0,-$AB,-$A7,-$A2,-$9D,-$98,-$93
	dc.w -$8E,-$88,-$83,-$7E,-$78,-$75,-$6D,-$67
	dc.w -$61,-$5C,-$56,-$50,-$4A,-$44,-$3E,-$38
	dc.w -$31,-$2B,-$25,-$1F,-$19,-$12, -$C,  -6
	dc.w    0,   6,  $C, $12, $19, $1F, $25, $2B
	dc.w  $31, $38, $3E, $44, $4A, $50, $56, $5C
	dc.w  $61, $67, $6D, $73, $78, $7E, $83, $88
	dc.w  $8E, $93, $98, $9D, $A2, $A7, $AB, $B0
	dc.w  $B5, $B9, $BD, $C1, $C5, $C9, $CD, $D1
	dc.w  $D4, $D8, $DB, $DE, $E1, $E4, $E7, $EA
	dc.w  $EC, $EE, $F1, $F3, $F4, $F6, $F8, $F9
	dc.w  $FB, $FC, $FD, $FE, $FE, $FF, $FF, $FF

; ---------------------------------------------------------------------------
; Calculate square root of a 16-bit value(?)
; d0.w  =  INPUT/OUTPUT
; ---------------------------------------------------------------------------

CalcSquare:
	movem.l d1-d2,-(sp)
	move.w  d0,d1
	swap    d1
	moveq   #0,d0
	move.w  d0,d1
	moveq   #8-1,d2

.Loop:
	rol.l   #2,d1
	add.w   d0,d0
	addq.w  #1,d0
	sub.w   d0,d1
	bhs.s   .Subtract
	add.w   d0,d1
	subq.w  #1,d0
	dbf     d2,.Loop
	lsr.w   #1,d0
	movem.l (sp)+,d1-d2
	rts

.Subtract:
	addq.w  #1,d0
	dbf     d2,.Loop
	lsr.w   #1,d0
	movem.l (sp)+,d1-d2
	rts

; ---------------------------------------------------------------------------
; Calculate arctangent (angle) off of X and Y distance inputs
;
; INPUTS:
; d1.w  =  Y dist.
; d2.w  =  X dist.
;
; OUTPUTS:
; d0.w  =  Angle
; ---------------------------------------------------------------------------

CalcATan:   
	movem.l d3-d4,-(sp)
	moveq   #0,d3
	moveq   #0,d4
	move.w  d1,d3
	move.w  d2,d4
	or.w    d3,d4
	beq.s   .ZeroDist       
	move.w  d2,d4
	tst.w   d3
	bpl.w   .XPositive
	neg.w   d3

.XPositive:
	tst.w   d4
	bpl.w   .YPositive
	neg.w   d4

.YPositive:
	cmp.w   d3,d4
	bcc.w   .YGreater
	lsl.l   #8,d4
	divu.w  d3,d4
	moveq   #0,d0
	move.b  AngleTable(pc,d4.w),d0
	bra.s   .ChkDir
; ---------------------------------------------------------------------------

.YGreater: 
	lsl.l   #8,d3   ; multiply by 256
	divu.w  d4,d3   ; divide by Y dist.
	moveq   #$40,d0
	sub.b   AngleTable(pc,d3.w),d0 

.ChkDir:   
	tst.w   d1
	bpl.w   .XPositive2
	neg.w   d0
	addi.w  #$80,d0 ; add 180 degrees

.XPositive2:   
	tst.w   d2
	bpl.w   .YPositive2
	neg.w   d0
	addi.w  #$100,d0; add 360 degrees?

.YPositive2:   
	movem.l (sp)+,d3-d4
	rts
; ---------------------------------------------------------------------------

.ZeroDist: 
	move.w  #$40,d0 ; return 90 degrees?
	movem.l (sp)+,d3-d4
	rts

; ---------------------------------------------------------------------------

AngleTable:     
	dc.b   0,  0,  0,  0,  1,  1,  1,  1
	dc.b   1,  1,  2,  2,  2,  2,  2,  2
	dc.b   3,  3,  3,  3,  3,  3,  3,  4
	dc.b   4,  4,  4,  4,  4,  5,  5,  5
	dc.b   5,  5,  5,  6,  6,  6,  6,  6
	dc.b   6,  6,  7,  7,  7,  7,  7,  7
	dc.b   8,  8,  8,  8,  8,  8,  8,  9
	dc.b   9,  9,  9,  9,  9, $A, $A, $A
	dc.b  $A, $A, $A, $A, $B, $B, $B, $B
	dc.b  $B, $B, $B, $C, $C, $C, $C, $C
	dc.b  $C, $C, $D, $D, $D, $D, $D, $D
	dc.b  $D, $E, $E, $E, $E, $E, $E, $E
	dc.b  $F, $F, $F, $F, $F, $F, $F,$10
	dc.b $10,$10,$10,$10,$10,$10,$11,$11
	dc.b $11,$11,$11,$11,$11,$11,$12,$12
	dc.b $12,$12,$12,$12,$12,$13,$13,$13
	dc.b $13,$13,$13,$13,$13,$14,$14,$14
	dc.b $14,$14,$14,$14,$14,$15,$15,$15
	dc.b $15,$15,$15,$15,$15,$15,$16,$16
	dc.b $16,$16,$16,$16,$16,$16,$17,$17
	dc.b $17,$17,$17,$17,$17,$17,$17,$18
	dc.b $18,$18,$18,$18,$18,$18,$18,$18
	dc.b $19,$19,$19,$19,$19,$19,$19,$19
	dc.b $19,$19,$1A,$1A,$1A,$1A,$1A,$1A
	dc.b $1A,$1A,$1A,$1B,$1B,$1B,$1B,$1B
	dc.b $1B,$1B,$1B,$1B,$1B,$1C,$1C,$1C
	dc.b $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C
	dc.b $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D
	dc.b $1D,$1D,$1D,$1E,$1E,$1E,$1E,$1E
	dc.b $1E,$1E,$1E,$1E,$1E,$1E,$1F,$1F
	dc.b $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
	dc.b $1F,$1F,$20,$20,$20,$20,$20,$20
	dc.b $20,  0