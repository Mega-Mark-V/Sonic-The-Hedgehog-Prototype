; ---------------------------------------------------------------------------
; Data RAM allocations
; ---------------------------------------------------------------------------

	rsset	WORKRAM
levelChunks:    	rs.b 	$A400
levelLayout:    	rs.b 	$400 
deformScrollBuffer:	rs.b 	$200
globalBuffer:   	rs.b 	$200 
spriteDrawQueue:	rs.b 	$400 
levelBlocks:    	rs.b 	$1800
sonicDMABuffer: 	rs.b 	$300 
sonicPosBuffer: 	rs.b 	$100 
hscroll:   			rs.b 	$400 
objectSlot00:   	rs.b 	$40  
objectSlot01:   	rs.b 	$40  
objectSlot02:   	rs.b 	$40  
objectSlot03:   	rs.b 	$40  
objectSlot04:   	rs.b 	$40  
objectSlot05:   	rs.b 	$40
objectSlot06:   	rs.b 	$40  
objectSlot07:   	rs.b 	$40  
objectSlot08:   	rs.b 	$40  
objectSlot09:   	rs.b 	$40  
objectSlot0A:   	rs.b 	$40  
objectSlot0B:   	rs.b 	$40  
objectSlot0C:   	rs.b 	$40
objectSlot0D:   	rs.b 	$40
objectSlot0E:   	rs.b 	$40
objectSlot0F:   	rs.b 	$40
objectSlot10:   	rs.b 	$40  
objectSlot11:   	rs.b 	$40
objectSlot12:   	rs.b 	$40
objectSlot13:   	rs.b 	$40
objectSlot14:   	rs.b 	$40  
objectSlot15:   	rs.b 	$40
objectSlot16:   	rs.b 	$40
objectSlot17:   	rs.b 	$40
objectSlot18:   	rs.b 	$40  
objectSlot19:   	rs.b 	$40
objectSlot1A:   	rs.b 	$40
objectSlot1B:   	rs.b 	$40
objectSlot1C:   	rs.b 	$40
objectSlot1D:   	rs.b 	$40
objectSlot1E:   	rs.b 	$40
objectSlot1F:   	rs.b 	$40
objectsDynamic: 	rs.b 	$1800

