; ---------------------------------------------------------------------------
; Unknown (Ending?) Chunk Patcher
; ---------------------------------------------------------------------------
; Now this is a bit speculative...
;
; This seems to patch data in for use in what would be the ending zone
;
; Although, the data it patches in is very peculiar and specific
; Chunks $5 and $1A are initially patched with what seems like two platforms
; Then, solidity in chunk $29's bottom right and $2A's bottom left are forced.
; 
; The data itself does not align with any existing chunk or block mappings.
; Notes and documentation are in ../doc/zone6
; ---------------------------------------------------------------------------

UnknownZoneRoutine:
        cmpi.b  #ZONE_UNK,zone.w
        bne.s   .Exit
        bsr.w   _patchSolids
        lea     levelChunks+$900,a1
        bsr.s   .PatchChunkBlks
        lea     levelChunks+$3380,a1

.PatchChunkBlks:                               
        lea     Unk_ChunkPatch,a0
        move.w  #32-1,d1

.Transfer:                             
        move.w  (a0)+,(a1)+
        dbf     d1,.Transfer

.Exit:                             
        rts
        
; ---------------------------------------------------------------------------

_patchSolids:                      
        lea     levelChunks,a1
        lea     Unk_SolidAddr,a0
        move.w  #12-1,d1

.Loop:                               
        move.w  (a0)+,d0
        ori.w   #$2000,(a1,d0.w)
        dbf     d1,.Loop
        rts


; ---------------------------------------------------------------------------
; Data to patch into chunks
; (See ../doc/zone6/zone6patch1.png)
; ---------------------------------------------------------------------------

Unk_ChunkPatch:  
        dc.w $2024,$2808,$2808,$2808,$207B,  0,  0,  0 
        dc.w $2024,$2808,$207B,  0,  0,  0,  0,  0
        dc.w $30C7,$30C7,$30C7,$30C7,$30C7,  0,  0,  0
        dc.w $3024,$3808,$307B,  0,  0,  0,  0,  0

; ---------------------------------------------------------------------------
; A list of addresses within chunk data to force top solidity on
; (See ../doc/zone6/zone6patch2.png)
; ---------------------------------------------------------------------------

Unk_SolidAddr: 
        dc.w $517E
        dc.w $519E
        dc.w $51BE
        dc.w $5360
        dc.w $5362
        dc.w $5364
        dc.w $5380
        dc.w $5382
        dc.w $5384
        dc.w $53A0
        dc.w $53A2
        dc.w $53A4