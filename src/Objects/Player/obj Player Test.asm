objPlayerTest:                          
        moveq   #0,d0
        move.b  obj.Action(a0),d0
        move.w  .Index(pc,d0.w),d1
        jmp     .Index(pc,d1.w)
; ---------------------------------------------------------------------------
.Index:                                
        dc.w PlayTest_Init-.Index
        dc.w PlayTest_Do-.Index
        dc.w PlayTest_Delete-.Index
        dc.w PlayTest_Delete-.Index
; ---------------------------------------------------------------------------

PlayTest_Init:                         
        addq.b  #2,obj.Action(a0)
        move.b  #18,obj.YRad(a0)
        move.b  #9,obj.XRad(a0)
        move.l  #MapSpr_Player,obj.Map(a0)
        move.w  #$780,obj.Tile(a0)
        move.b  #4,obj.Render(a0)
        move.b  #2,obj.Priority(a0)
        move.b  #1,obj.Frame

PlayTest_Do:                           
        bsr.w   _objectJoypadCtrl
        bsr.w   _playDynamicGFX
        jmp     _objectDraw
; ---------------------------------------------------------------------------

_objectJoypadCtrl:                      
        move.b  joypadMirr.w,d4
        move.w  obj.Y(a0),d2
        move.w  obj.X(a0),d3
        moveq   #1,d1
        btst    #0,d4
        beq.s   .NoUp
        sub.w   d1,d2

.NoUp:                                 
        btst    #1,d4
        beq.s   .NoDown
        add.w   d1,d2

.NoDown:                               
        btst    #2,d4
        beq.s   .NoLeft
        sub.w   d1,d3

.NoLeft:                               
        btst    #3,d4
        beq.s   .NoRight
        add.w   d1,d3

.NoRight:                              
        move.w  d2,obj.Y(a0)
        move.w  d3,obj.X(a0)
        btst    #4,joypadPressMirr.w
        beq.s   .NoB
        move.b  obj.Render(a0),d0
        move.b  d0,d1
        addq.b  #1,d0
        andi.b  #3,d0
        andi.b  #$FC,d1
        or.b    d1,d0
        move.b  d0,obj.Render(a0)

.NoB:                                  
        btst    #5,joypadPressMirr.w
        beq.s   .NoC
        addq.b  #1,obj.Anim(a0)
        cmpi.b  #$19,obj.Anim(a0)
        bcs.s   .NoC
        move.b  #0,obj.Anim(a0)

.NoC:                                  
        jsr     _playAnimate
        rts

; ---------------------------------------------------------------------------

PlayTest_Delete:                     
        jmp     _objectDelete 
