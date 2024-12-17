; ---------------------------------------------------------------------------
; Data RAM allocations
; ---------------------------------------------------------------------------

	rsset		WORKRAM+$FF000000

levelChunks:    	rs.b 	$A400
levelLayout:    	rs.b 	$400 
deformScrollBuffer:	rs.b 	$200
globalBuffer:   	rs.b 	$200 
spriteDrawQueue:	rs.b 	$400 
levelBlocks:    	rs.b 	$1800
sonicDMABuffer: 	rs.b 	$300 
sonicPosBuffer: 	rs.b 	$100 
hscroll:   			rs.b 	$400

; ---------------------------------------------------------------------------
; Object/Actor RAM allocation
; ---------------------------------------------------------------------------

OBJECTRAM       EQU $FFFFD000 
OBJSZ		EQU 64
OBJECTRAMSZ		EQU OBJECTRAME-OBJECTRAM    

	rsset		$FFFFD000 
objectSlot00:   	rs.b 	OBJSZ
objectSlot01:   	rs.b 	OBJSZ
objectSlot02:   	rs.b 	OBJSZ
objectSlot03:   	rs.b 	OBJSZ
objectSlot04:   	rs.b 	OBJSZ
objectSlot05:   	rs.b 	OBJSZ
objectSlot06:   	rs.b 	OBJSZ
objectSlot07:   	rs.b 	OBJSZ  
objectSlot08:   	rs.b 	OBJSZ  
objectSlot09:   	rs.b 	OBJSZ  
objectSlot0A:   	rs.b 	OBJSZ  
objectSlot0B:   	rs.b 	OBJSZ  
objectSlot0C:   	rs.b 	OBJSZ
objectSlot0D:   	rs.b 	OBJSZ
objectSlot0E:   	rs.b 	OBJSZ
objectSlot0F:   	rs.b 	OBJSZ
objectSlot10:   	rs.b 	OBJSZ  
objectSlot11:   	rs.b 	OBJSZ
objectSlot12:   	rs.b 	OBJSZ
objectSlot13:   	rs.b 	OBJSZ
objectSlot14:   	rs.b 	OBJSZ  
objectSlot15:   	rs.b 	OBJSZ
objectSlot16:   	rs.b 	OBJSZ
objectSlot17:   	rs.b 	OBJSZ
objectSlot18:   	rs.b 	OBJSZ  
objectSlot19:   	rs.b 	OBJSZ
objectSlot1A:   	rs.b 	OBJSZ
objectSlot1B:   	rs.b 	OBJSZ
objectSlot1C:   	rs.b 	OBJSZ
objectSlot1D:   	rs.b 	OBJSZ
objectSlot1E:   	rs.b 	OBJSZ
objectSlot1F:   	rs.b 	OBJSZ
objectsDynamic: 	rs.b 	OBJSZ*96
OBJECTRAME:

