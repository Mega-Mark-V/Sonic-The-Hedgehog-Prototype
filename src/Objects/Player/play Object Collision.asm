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
        bne.s   .HasColInfo

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

.HasColInfo:                         
        andi.w  #$3F,d0
        add.w   d0,d0
        lea     .ObjColSizes-2(pc,d0.w),a2
        moveq   #0,d1
        move.b  (a2)+,d1
        move.w  obj.X(a1),d0
        sub.w   d1,d0
        sub.w   d2,d0
        bcc.s   loc_FBD8
        add.w   d1,d1
        add.w   d1,d0
        bcs.s   loc_FBDC
        bra.s   .NextObj

; ---------------------------------------------------------------------------

loc_FBD8:                               
        cmp.w   d4,d0
        bhi.s   .NextObj

loc_FBDC:                               
        moveq   #0,d1
        move.b  (a2)+,d1
        move.w  obj.Y(a1),d0
        sub.w   d1,d0
        sub.w   d3,d0
        bcc.s   loc_FBF2
        add.w   d1,d1
        add.w   d0,d1
        bcs.s   loc_FBF6
        bra.s   .NextObj
; ---------------------------------------------------------------------------

loc_FBF2:                               
        cmp.w   d5,d0
        bhi.s   .NextObj

loc_FBF6:                               
        move.b  obj.Collision(a1),d1
        andi.b  #$C0,d1

loc_FBFE:
        beq.w   loc_FC6A
        cmpi.b  #$C0,d1
        beq.w   loc_FDC4
        tst.b   d1
        bmi.w   loc_FCE0
        move.b  obj.Collision(a1),d0
        andi.b  #$3F,d0 ; '?'
        cmpi.b  #6,d0
        beq.s   loc_FC2E
        cmpi.w  #$5A,obj.field_30(a0) ; 'Z'
        bcc.w   locret_FC2C
        addq.b  #2,obj.Action(a1)

locret_FC2C:                            
        rts
; ---------------------------------------------------------------------------

loc_FC2E:                               
        tst.w   obj.YSpeed(a0)
        bpl.s   loc_FC58
        move.w  obj.Y(a0),d0
        subi.w  #$10,d0
        cmp.w   obj.Y(a1),d0
        bcs.s   locret_FC68
        neg.w   obj.YSpeed(a0)
        move.w  #-$180,obj.YSpeed(a1)
        tst.b   obj.SubAction(a1)
        bne.s   locret_FC68
        addq.b  #4,obj.SubAction(a1)
        rts
; ---------------------------------------------------------------------------

loc_FC58:                               
        cmpi.b  #2,obj.Anim(a0)
        bne.s   locret_FC68
        neg.w   obj.YSpeed(a0)
        addq.b  #2,obj.Action(a1)

locret_FC68:                            
        rts
; ---------------------------------------------------------------------------

loc_FC6A:                               
        tst.b   (invincible).w
        bne.s   loc_FC78
        cmpi.b  #2,obj.Anim(a0)
        bne.s   loc_FCE0

loc_FC78:                               
        tst.b   obj.ColProp(a1)
        beq.s   loc_FCA2
        neg.w   obj.XSpeed(a0)
        neg.w   obj.YSpeed(a0)
        asr     obj.XSpeed(a0)
        asr     obj.YSpeed(a0)
        move.b  #0,obj.Collision(a1)
        subq.b  #1,obj.ColProp(a1)
        bne.s   locret_FCA0
        bset    #7,obj.Status(a1)

locret_FCA0:                            
        rts
; ---------------------------------------------------------------------------

loc_FCA2:                               
        bset    #7,obj.Status(a1)
        moveq   #$A,d0
        bsr.w   _hudAddPoints
        move.b  #$27,obj.ID(a1) ; '''
        move.b  #0,obj.Action(a1)
        tst.w   obj.YSpeed(a0)
        bmi.s   loc_FCD0
        move.w  obj.Y(a0),d0
        cmp.w   obj.Y(a1),d0
        bcc.s   loc_FCD8
        neg.w   obj.YSpeed(a0)
        rts
; ---------------------------------------------------------------------------

loc_FCD0:                               
        addi.w  #$100,obj.YSpeed(a0)
        rts
; ---------------------------------------------------------------------------

loc_FCD8:                               
        subi.w  #$100,obj.YSpeed(a0)
        rts
; ---------------------------------------------------------------------------

loc_FCE0:                               
        tst.b   (invincible).w
        beq.s   loc_FCEA

loc_FCE6:                               
        moveq   #-1,d0
        rts
; ---------------------------------------------------------------------------

loc_FCEA:                               
        nop
        tst.w   obj.field_30(a0)
        bne.s   loc_FCE6
        movea.l a1,a2

loc_FCF4:                               
        tst.b   (shield).w
        bne.s   loc_FD18
        tst.w   (rings).w
        beq.s   loc_FD72
        bsr.w   _objectFindFreeSlot
        bne.s   loc_FD18
        move.b  #$37,obj.ID(a1) ; '7'
        move.w  obj.X(a0),obj.X(a1)
        move.w  obj.Y(a0),obj.Y(a1)

loc_FD18:                               
        move.b  #0,(shield).w
        move.b  #4,obj.Action(a0)
        bsr.w   _physSetOnFloor
        bset    #1,obj.Status(a0)
        move.w  #-$400,obj.YSpeed(a0)
        move.w  #-$200,obj.XSpeed(a0)
        move.w  obj.X(a0),d0
        cmp.w   8(a2),d0
        bcs.s   loc_FD48
        neg.w   obj.XSpeed(a0)

loc_FD48:                               
        move.w  #0,obj.Momentum(a0)
        move.b  #$1A,obj.Anim(a0)
        move.w  #$258,obj.field_30(a0)
        move.w  #sfxID_Death,d0
        cmpi.b  #$36,(a2) ; '6'
        bne.s   loc_FD68
        move.w  #sfxID_Spikes,d0

loc_FD68:                               
        jsr     (QueueSoundB).l
        moveq   #-1,d0
        rts
; ---------------------------------------------------------------------------

loc_FD72:                               
        tst.w   (debug).w
        bne.s   loc_FD18

loc_FD78:                               
        tst.w   (editMode).w
        bne.s   loc_FDC0
        move.b  #6,obj.Action(a0)
        bsr.w   _physSetOnFloor
        bset    #1,obj.Status(a0)
        move.w  #-$700,obj.YSpeed(a0)
        move.w  #0,obj.XSpeed(a0)
        move.w  #0,obj.Momentum(a0)
        move.w  obj.Y(a0),obj.field_38(a0)
        move.b  #$18,obj.Anim(a0)
        move.w  #sfxID_Death,d0
        cmpi.b  #$36,(a2) ; '6'
        bne.s   loc_FDBA
        move.w  #sfxID_Spikes,d0

loc_FDBA:                               
        jsr     (QueueSoundB).l

loc_FDC0:                               
        moveq   #-1,d0
        rts
; ---------------------------------------------------------------------------

loc_FDC4:                               
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
        bra.w   loc_FCE0
; ---------------------------------------------------------------------------

loc_FE08:                               
        bra.w   loc_FC6A
; ---------------------------------------------------------------------------

loc_FE0C:                               
        addq.b  #1,obj.ColProp(a1)
        rts