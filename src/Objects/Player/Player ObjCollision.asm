_playObjCollision:                      
	nop
	moveq   #0,d5
	move.b  obj.YRad(a0),d5
	subq.b  #3,d5
	move.w  obj.X(a0),d2
	move.w  obj.Y(a0),d3
	subq.w  #8,d2
	sub.w   d5,d3
	move.w  #16,d4
	add.w   d5,d5

	lea     objsAlloc.w,a1
	move.w  #96-1,d6

.Loop:                                 
	tst.b   obj.Render(a1)
	bpl.s   .NextObj
	move.b  obj.Collision(a1),d0
	bne.s   .HasCollision

.NextObj:                              
	lea     obj.Size(a1),a1
	dbf     d6,.Loop
	moveq   #0,d0
	rts
; ---------------------------------------------------------------------------
.ObjColSizes:   
	dc.b  20, 20            
	dc.b  12, 20
	dc.b  20, 12
	dc.b   4, 16
	dc.b  12, 18
	dc.b  16, 16
	dc.b   6,  6
	dc.b  24, 12
	dc.b  12, 16
	dc.b  16, 12
	dc.b   8,  8
	dc.b  20, 16
	dc.b  20,  8
	dc.b  14, 14
	dc.b  24, 24
	dc.b  40, 16
	dc.b  16, 24
	dc.b  12, 32
	dc.b  32,112
	dc.b  64, 32
	dc.b 128, 32
	dc.b  32, 32
	dc.b   8,  8
	dc.b   4,  4
	dc.b  32,  8
; ---------------------------------------------------------------------------

.HasCollision:
	andi.w  #%111111,d0     ; ignore type flags
	add.w   d0,d0
	lea     .ObjColSizes-2(pc,d0.w),a2
	moveq   #0,d1
	move.b  (a2)+,d1        ; get size
	move.w  obj.X(a1),d0
	sub.w   d1,d0
	sub.w   d2,d0
	bcc.s   .ToLeft
	add.w   d1,d1
	add.w   d1,d0
	bcs.s   .InXRange
	bra.s   .NextObj

.ToLeft:                               
	cmp.w   d4,d0
	bhi.s   .NextObj

.InXRange:                             
	moveq   #0,d1
	move.b  (a2)+,d1
	move.w  obj.Y(a1),d0
	sub.w   d1,d0
	sub.w   d3,d0
	bcc.s   .Above
	add.w   d1,d1
	add.w   d0,d1
	bcs.s   .InYRange
	bra.s   .NextObj

.Above:                                
	cmp.w   d5,d0
	bhi.s   .NextObj

.InYRange:                             
	move.b  obj.Collision(a1),d1
	andi.b  #$C0,d1
	beq.w   _objcolTypeEnemy
	cmpi.b  #$C0,d1
	beq.w   _objcolTypeUser
	tst.b   d1
	bmi.w   _objcolTypeHurt
	move.b  obj.Collision(a1),d0
	andi.b  #%111111,d0
	cmpi.b  #6,d0
	beq.s   _objcolTypeItem
	cmpi.w  #90,play.Timeout(a0)
	bcc.w   .Invuln
	addq.b  #2,obj.Action(a1)

.Invuln:                               
	rts
; ---------------------------------------------------------------------------

_objcolTypeItem:                        
	tst.w   obj.YSpeed(a0)
	bpl.s   .BelowItem
	move.w  obj.Y(a0),d0
	subi.w  #16,d0
	cmp.w   obj.Y(a1),d0
	bcs.s   .AboveItem
	neg.w   obj.YSpeed(a0)
	move.w  #-$180,obj.YSpeed(a1)
	tst.b   obj.SubAction(a1)
	bne.s   .AboveItem
	addq.b  #4,obj.SubAction(a1)
	rts
; ---------------------------------------------------------------------------

.BelowItem:                            
	cmpi.b  #2,obj.Anim(a0)
	bne.s   .AboveItem
	neg.w   obj.YSpeed(a0)
	addq.b  #2,obj.Action(a1)

.AboveItem:                            
	rts
; ---------------------------------------------------------------------------

_objcolTypeEnemy:                       
	tst.b   (invincible).w
	bne.s   .Invincible
	cmpi.b  #2,obj.Anim(a0)
	bne.s   _objcolTypeHurt

.Invincible:                           
	tst.b   obj.ColliCnt(a1)
	beq.s   .EnemyKill
	neg.w   obj.XSpeed(a0)
	neg.w   obj.YSpeed(a0)
	asr     obj.XSpeed(a0)
	asr     obj.YSpeed(a0)
	move.b  #0,obj.Collision(a1)
	subq.b  #1,obj.ColliCnt(a1)
	bne.s   .CntNotOut
	bset    #7,obj.Status(a1)

.CntNotOut:                            
	rts
; ---------------------------------------------------------------------------

.EnemyKill:                            
	bset    #7,obj.Status(a1)
	moveq   #10,d0
	bsr.w   _hudAddPoints
	move.b  #$27,obj.No(a1) ; ''' ; make into explosion
	move.b  #0,obj.Action(a1) ; clear action
	tst.w   obj.YSpeed(a0)
	bmi.s   .BounceDown
	move.w  obj.Y(a0),d0
	cmp.w   obj.Y(a1),d0
	bcc.s   .BounceUp
	neg.w   obj.YSpeed(a0)
	rts
; ---------------------------------------------------------------------------

.BounceDown:                           
	addi.w  #$100,obj.YSpeed(a0)
	rts
; ---------------------------------------------------------------------------

.BounceUp:                             
	subi.w  #$100,obj.YSpeed(a0)
	rts
; ---------------------------------------------------------------------------

_objcolTypeHurt:                        
	tst.b   (invincible).w
	beq.s   .NotInvincible

.WaitTimeout:                          
	moveq   #-1,d0
	rts
; ---------------------------------------------------------------------------

.NotInvincible:                        
	nop
	tst.w   play.Timeout(a0)
	bne.s   .WaitTimeout
	movea.l a1,a2

_playDamageSet:                         
	tst.b   (shield).w
	bne.s   .HasShield
	tst.w   (rings).w
	beq.s   .DoKill
	bsr.w   _objectFindFreeSlot
	bne.s   .HasShield
	move.b  #$37,obj.No(a1) ; '7'
	move.w  obj.X(a0),obj.X(a1)
	move.w  obj.Y(a0),obj.Y(a1)

.HasShield:                            
	move.b  #0,(shield).w
	move.b  #4,obj.Action(a0)
	bsr.w   _physAirExit
	bset    #1,obj.Status(a0)
	move.w  #-$400,obj.YSpeed(a0)
	move.w  #-$200,obj.XSpeed(a0)
	move.w  obj.X(a0),d0
	cmp.w   8(a2),d0
	bcs.s   .IsLeft
	neg.w   obj.XSpeed(a0)

.IsLeft:                               
	move.w  #0,obj.Momentum(a0)
	move.b  #$1A,obj.Anim(a0)
	move.w  #$258,obj.field_30(a0)
	move.w  #SFXNO_DEATH,d0
	cmpi.b  #$36,(a2) ; '6'
	bne.s   .NotSpikes1
	move.w  #SFXNO_SPIKEDMG,d0

.NotSpikes1:                           
	jsr     (SndSetSFX).l
	moveq   #-1,d0
	rts
; ---------------------------------------------------------------------------

.DoKill:                               
	tst.w   (debug).w
	bne.s   .HasShield

_playKillSet:                           
	tst.w   (editMode).w
	bne.s   .IsEditing
	move.b  #6,obj.Action(a0)
	bsr.w   _physAirExit
	bset    #1,obj.Status(a0)
	move.w  #-$700,obj.YSpeed(a0)
	move.w  #0,obj.XSpeed(a0)
	move.w  #0,obj.Momentum(a0)
	move.w  obj.Y(a0),obj.field_38(a0)
	move.b  #$18,obj.Anim(a0)
	move.w  #SFXNO_DEATH,d0
	cmpi.b  #$36,(a2)
	bne.s   .NotSpikes
	move.w  #SFXNO_SPIKEDMG,d0

.NotSpikes:                            
	jsr     (SndSetSFX).l

.IsEditing:                            
	moveq   #-1,d0
	rts
; ---------------------------------------------------------------------------

_objcolTypeUser:                        
	move.b  obj.Collision(a1),d1
	andi.b  #$3F,d1 ; '?'
	cmpi.b  #$C,d1
	beq.s   loc_FDDA
	cmpi.b  #$17,d1
	beq.s   loc_FE0C
	rts
; ---------------------------------------------------------------------------

loc_FDDA:                               
	sub.w   d0,d5
	cmpi.w  #8,d5
	bcc.s   loc_FE08
	move.w  obj.X(a1),d0
	subq.w  #4,d0
	btst    #0,obj.Status(a1)
	beq.s   loc_FDF4
	subi.w  #$10,d0

loc_FDF4:                               
	sub.w   d2,d0
	bcc.s   loc_FE00
	addi.w  #$18,d0
	bcs.s   loc_FE04
	bra.s   loc_FE08
; ---------------------------------------------------------------------------

loc_FE00:                               
	cmp.w   d4,d0
	bhi.s   loc_FE08

loc_FE04:                               
	bra.w   _objcolTypeHurt
; ---------------------------------------------------------------------------

loc_FE08:                               
	bra.w   _objcolTypeEnemy
; ---------------------------------------------------------------------------

loc_FE0C:                               
	addq.b  #1,obj.ColliCnt(a1)
	rts