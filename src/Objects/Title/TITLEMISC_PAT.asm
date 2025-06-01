.pattbl
        dc.w tmisc_psb+1-.pattbl
        dc.w tmisc_psb-.pattbl
        dc.w tmisc_mask-.pattbl

tmisc_psb:      
        dc.b   6,  0, $C,  0,$F0,  0,  0,  0
        dc.b   0,$F3,$20,  0,  0,  0,$F3,$30
        dc.b   0, $C,  0,$F4,$38,  0,  8,  0
        dc.b $F8,$60,  0,  8,  0,$FB,$78

tmisc_mask:     
        dc.b $1E,$B8, $F,  0,  0,$80,$B8, $F
        dc.b   0,  0,$80,$B8, $F,  0,  0,$80
        dc.b $B8, $F,  0,  0,$80,$B8, $F,  0
        dc.b   0,$80,$B8, $F,  0,  0,$80,$B8
        dc.b  $F,  0,  0,$80,$B8, $F,  0,  0
        dc.b $80,$B8, $F,  0,  0,$80,$B8, $F
        dc.b   0,  0,$80,$D8, $F,  0,  0,$80
        dc.b $D8, $F,  0,  0,$80,$D8, $F,  0
        dc.b   0,$80,$D8, $F,  0,  0,$80,$D8
        dc.b  $F,  0,  0,$80,$D8, $F,  0,  0
        dc.b $80,$D8, $F,  0,  0,$80,$D8, $F
        dc.b   0,  0,$80,$D8, $F,  0,  0,$80
        dc.b $D8, $F,  0,  0,$80,$F8, $F,  0
        dc.b   0,$80,$F8, $F,  0,  0,$80,$F8
        dc.b  $F,  0,  0,$80,$F8, $F,  0,  0
        dc.b $80,$F8, $F,  0,  0,$80,$F8, $F
        dc.b   0,  0,$80,$F8, $F,  0,  0,$80
        dc.b $F8, $F,  0,  0,$80,$F8, $F,  0
        dc.b   0,$80,$F8, $F,  0,  0,$80