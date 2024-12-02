; ---------------------------------------------------------------------------
; General purpose macros for defining pointer data
; ---------------------------------------------------------------------------

dclww	macro	long, word1, word2,
	dc.l 	\long
	dc.w 	\word1
	dc.w 	\word2
	endm

; ---------------------------------------------------------------------------
; Stop the Z80
; ---------------------------------------------------------------------------

Z80STOP macro
	move.w	#$100,Z80BUS			; Request Z80 bus access
.Wait\@:
	btst	#0,Z80BUS			; Was the request acknowledged?
	bne.s	.Wait\@				; If not, wait
	endm

; ---------------------------------------------------------------------------
; Stop the Z80
; ---------------------------------------------------------------------------

Z80START macro
	move.w	#0,Z80BUS
	endm

; ---------------------------------------------------------------------------
; VDP command set
; ---------------------------------------------------------------------------

VDPCMD macro ins, addr, type, rwd, end, end2
	local	cmd
cmd	= (\type\\rwd\)|(((\addr)&$3FFF)<<16)|((\addr)/$4000)
	if narg=5
		\ins	#\#cmd,\end
	elseif narg>=6
		\ins	#(\#cmd)\end,\end2
	else
		\ins	cmd
	endif
	endm

; ---------------------------------------------------------------------------
; Wait for DMA
; ---------------------------------------------------------------------------

DMAWAIT macro ctrl
.Wait\@:
	if narg>0
		btst	#1,1(\ctrl)		; Is DMA active?
	else
		move.w	VDPCTRL,d0		; Is DMA active?
		btst	#1,d0
	endif
	bne.s	.Wait\@				; If so, wait
	endm

; ---------------------------------------------------------------------------
; VDP DMA from 68000 memory to VDP memory
; ---------------------------------------------------------------------------
; PARAMETERS:
;	src  - Source address in 68000 memory
;	dest - Destination address in VDP memory
;	len  - Length of data in bytes
;	type - Type of VDP memory
;	port - Address register for the VDP port
; ---------------------------------------------------------------------------

VDPDMA  macro src, dest, len, type, port
	; DMA data
	lea	VDPCTRL,\port
	move.l	#$94009300|((((\len)/2)&$FF00)<<8)|(((\len)/2)&$FF),(\port)
	move.l	#$96009500|((((\src)/2)&$FF00)<<8)|(((\src)/2)&$FF),(\port)
	move.w	#$9700|(((\src)>>17)&$7F),(\port)
	VDPCMD	move.w,\dest,\type,DMA,>>16,(\port)
	VDPCMD	move.w,\dest,\type,DMA,&$FFFF,vdpIntBuffer.w
	move.w	vdpIntBuffer.w,(\port)
	endm

; -------------------------------------------------------------------------
; VDP DMA fill VRAM with byte
; -------------------------------------------------------------------------
; PARAMETERS:
;	addr - Address in VRAM
;	len  - Length of fill in bytes
;	byte - Byte to fill VRAM with
;	inc  - VDP autoincrement value
;	port - Control port address register
; -------------------------------------------------------------------------

VDPFILL macro addr, len, byte, inc, port
	; DMA fill
	lea	VDPCTRL,\port
	move.w	#$8F00+\inc,(\port)
	move.l	#$93009400|((((\len)-1)&$FF00)>>8)|((((\len)-1)&$FF)<<16),(\port)
	move.w	#$9780,(\port)
	VDPCMD	move.l,\addr,VRAM,DMA,(\port)
	move.w	#(\byte)<<8,VDPDATA
	DMAWAIT	\port

	VDPFILL $C000,$1FFE,$00,1,a6

