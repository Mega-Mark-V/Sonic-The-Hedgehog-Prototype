; ---------------------------------------------------------------------------
; Basic system memory location equates
; ---------------------------------------------------------------------------

CARTRIDGE       EQU     $0                    
CARTRIDGEE      EQU     $80000
CARTRIDGESZ     EQU     CARTRIDGEE-CARTRIDGE

WORKRAM         EQU     $FF0000
WORKRAME        EQU     $1000000
WORKRAMSZ       EQU     WORKRAME-WORKRAM

Z80RAM          EQU     $A00000
Z80RAME		EQU	$A02000
Z80RAMSZ	EQU	Z80RAME-Z80RAM
Z80BUS		EQU	$A11100
Z80RES	        EQU	$A11200

CARTRAM         EQU     CARTRIDGEE		
; ---------------------------------------------------------------------------
; System and VDP registers 
; ---------------------------------------------------------------------------

; I/O

; Word
VERSION_	EQU	$A10000		; Hardware version
IODATA1_	EQU	$A10002		; Pad 1 Data
IODATA2_	EQU	$A10004         ; Pad 2 Data
IODATA3_	EQU	$A10006         ; EXT Data
IOCTRL1_	EQU	$A10008         ; Pad 1 Ctrl
IOCTRL2_	EQU	$A1000A         ; Pad 2 Ctrl
IOCTRL3_	EQU	$A1000C         ; EXT Ctrl

; Byte
VERSION         EQU     VERSION_+1
IODATA1         EQU     IODATA1_+1
IODATA2         EQU     IODATA2_+1
IODATA3         EQU     IODATA3_+1
IOCTRL1         EQU     IOCTRL1_+1
IOCTRL2         EQU     IOCTRL2_+1
IOCTRL3         EQU     IOCTRL3_+1

; Sound
YMADDR0		EQU	$A04000		; YM2612 address port 0
YMDATA0		EQU	$A04001		; YM2612 data port 0
YMADDR1		EQU	$A04002		; YM2612 address port 1
YMDATA1		EQU	$A04003		; YM2612 data port 1
PSGCTRL		EQU	$C00011		; PSG control port

; VDP
VDPDATA		EQU	$C00000		; VDP data port
VDPCTRL		EQU	$C00004		; VDP control port
VDPHVCNT	EQU	$C00008		; VDP H/V counter
VDPDEBUG	EQU	$C0001C		; VDP debug register

; TMSS
TMSSSEGA	EQU	$A14000		; TMSS "SEGA" register
TMSSMODE	EQU	$A14100		; TMSS bus mode

; ---------------------------------------------------------------------------
; VDP operation codes
; ---------------------------------------------------------------------------

VRAMWRITE	EQU	$40000000		; VRAM write
CRAMWRITE	EQU	$C0000000		; CRAM write
VSRAMWRITE	EQU	$40000010		; VSRAM write
VRAMREAD	EQU	$00000000		; VRAM read
CRAMREAD	EQU	$00000020		; CRAM read
VSRAMREAD	EQU	$00000010		; VSRAM read
VRAMDMA		EQU	$40000080		; VRAM DMA
CRAMDMA		EQU	$C0000080		; CRAM DMA
VSRAMDMA	EQU	$40000090		; VSRAM DMA
VRAMCOPY	EQU	$000000C0		; VRAM DMA copy

; ---------------------------------------------------------------------------
; VDP status codes
; ---------------------------------------------------------------------------

PAL:             	EQU 0
DMA:                EQU 1 
HBLANKING:       	EQU 2
VBLANKING:       	EQU 3
ODDFRAME:        	EQU 4
SPRITE_COLLIDE:		EQU 5
SPRITE_OVERFLOW: 	EQU 6
VBLANK_PENDING:  	EQU 7
FIFO_FULL:       	EQU 8
FIFO_EMPTY:      	EQU 9


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
