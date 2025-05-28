; ---------------------------------------------------------------------------
; Data RAM allocations
; ---------------------------------------------------------------------------

	rsset	WORKRAM+$FF000000

levelChunks:		rs.b	$A400
layoutA:	=	layoutMem+$00
layoutB:	=	layoutMem+$40
layoutMem:		rs.b 	$400
hscrollWork:		rs.b 	$200
globalBuffer:		rs.b 	$200
objDrawQueue:		rs.b 	$400
levelBlocks:		rs.b	$1800
playDMABuffer:		rs.b 	$300
playPosBuffer:		rs.b 	$100
hscroll:		rs.b 	$400

; ---------------------------------------------------------------------------
; Object/Actor RAM allocation
; ---------------------------------------------------------------------------

OBJECTRAM	EQU	$FFFFD000
OBJSZ		EQU	64
OBJECTRAMSZ	EQU	OBJECTRAME-OBJECTRAM 

	rsset	$FFFFD000
objSlot00:	rs.b 	OBJSZ
objSlot01:	rs.b 	OBJSZ
objSlot02:	rs.b 	OBJSZ
objSlot03:	rs.b 	OBJSZ
objSlot04:	rs.b 	OBJSZ
objSlot05:	rs.b 	OBJSZ
objSlot06:	rs.b 	OBJSZ
objSlot07:	rs.b 	OBJSZ  
objSlot08:	rs.b 	OBJSZ  
objSlot09:	rs.b 	OBJSZ  
objSlot0A:	rs.b 	OBJSZ  
objSlot0B:	rs.b 	OBJSZ  
objSlot0C:	rs.b 	OBJSZ
objSlot0D:	rs.b 	OBJSZ
objSlot0E:	rs.b 	OBJSZ
objSlot0F:	rs.b 	OBJSZ
objSlot10:	rs.b 	OBJSZ  
objSlot11:	rs.b 	OBJSZ
objSlot12:	rs.b 	OBJSZ
objSlot13:	rs.b 	OBJSZ
objSlot14:	rs.b 	OBJSZ  
objSlot15:	rs.b 	OBJSZ
objSlot16:	rs.b 	OBJSZ
objSlot17:	rs.b 	OBJSZ
objSlot18:	rs.b 	OBJSZ  
objSlot19:	rs.b 	OBJSZ
objSlot1A:	rs.b 	OBJSZ
objSlot1B:	rs.b 	OBJSZ
objSlot1C:	rs.b 	OBJSZ
objSlot1D:	rs.b 	OBJSZ
objSlot1E:	rs.b 	OBJSZ
objSlot1F:	rs.b 	OBJSZ
objsAlloc: 		rs.b 	OBJSZ*96
OBJECTRAME:

