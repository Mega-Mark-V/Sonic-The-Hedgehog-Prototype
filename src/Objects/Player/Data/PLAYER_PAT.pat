.pattbl
        dc.w sonicnullsp00-.pattbl
        dc.w sonicidlesp01-.pattbl
        dc.w sonicwaitsp02-.pattbl
        dc.w sonicwaitsp03-.pattbl
        dc.w sonicwaitsp04-.pattbl
        dc.w soniclkupsp05-.pattbl
        dc.w sonicwalksp06-.pattbl
        dc.w sonicwalksp07-.pattbl
        dc.w sonicwalksp08-.pattbl
        dc.w sonicwalksp09-.pattbl
        dc.w sonicwalksp0A-.pattbl
        dc.w sonicwalksp0B-.pattbl
        dc.w sonicwalksp0C-.pattbl
        dc.w sonicwalksp0D-.pattbl
        dc.w sonicwalksp0E-.pattbl
        dc.w sonicwalksp0F-.pattbl
        dc.w sonicwalksp10-.pattbl
        dc.w sonicwalksp11-.pattbl
        dc.w sonicwalksp12-.pattbl
        dc.w sonicwalksp13-.pattbl
        dc.w sonicwalksp14-.pattbl
        dc.w sonicwalksp15-.pattbl
        dc.w sonicwalksp16-.pattbl
        dc.w sonicwalksp17-.pattbl
        dc.w sonicwalksp18-.pattbl
        dc.w sonicwalksp19-.pattbl
        dc.w sonicwalksp1A-.pattbl
        dc.w sonicwalksp1B-.pattbl
        dc.w sonicwalksp1C-.pattbl
        dc.w sonicwalksp1D-.pattbl
        dc.w sonicfastsp1E-.pattbl
        dc.w sonicfastsp1F-.pattbl
        dc.w sonicfastsp20-.pattbl
        dc.w sonicfastsp21-.pattbl
        dc.w sonicfastsp22-.pattbl
        dc.w sonicfastsp23-.pattbl
        dc.w sonicfastsp24-.pattbl
        dc.w sonicfastsp25-.pattbl
        dc.w sonicfastsp26-.pattbl
        dc.w sonicfastsp27-.pattbl
        dc.w sonicfastsp28-.pattbl
        dc.w sonicfastsp29-.pattbl
        dc.w sonicfastsp2A-.pattbl
        dc.w sonicfastsp2B-.pattbl
        dc.w sonicfastsp2C-.pattbl
        dc.w sonicfastsp2D-.pattbl
        dc.w sonicspinsp2E-.pattbl
        dc.w sonicspinsp2F-.pattbl
        dc.w sonicspinsp30-.pattbl
        dc.w sonicspinsp31-.pattbl
        dc.w sonicballsp32-.pattbl
        dc.w sonicunknsp33-.pattbl
        dc.w sonicunknsp34-.pattbl
        dc.w sonicunknsp35-.pattbl
        dc.w sonicunknsp36-.pattbl
        dc.w sonicskidsp37-.pattbl
        dc.w sonicskidsp38-.pattbl
        dc.w sonicducksp39-.pattbl
        dc.w sonicblncsp3A-.pattbl
        dc.w sonicblncsp3B-.pattbl
        dc.w sonicfloasp3C-.pattbl
        dc.w sonicfloasp3D-.pattbl
        dc.w sonicfloasp3E-.pattbl
        dc.w sonicfloasp3F-.pattbl
        dc.w sonicsprisp40-.pattbl
        dc.w sonicgrabsp41-.pattbl
        dc.w sonicgrabsp42-.pattbl
        dc.w sonicvictsp43-.pattbl
        dc.w sonicvictsp44-.pattbl
        dc.w sonicpushsp45-.pattbl
        dc.w sonicpushsp46-.pattbl
        dc.w sonicpushsp47-.pattbl
        dc.w sonicpushsp48-.pattbl
        dc.w sonicunknsp49-.pattbl
        dc.w sonicbubbsp4A-.pattbl
        dc.w sonicfiresp4B-.pattbl
        dc.w sonicwdiesp4C-.pattbl
        dc.w sonicndiesp4D-.pattbl
        dc.w sonicfallsp4E-.pattbl
        dc.w sonicfallsp4F-.pattbl
        dc.w sonicfallsp50-.pattbl
        dc.w sonicfallsp51-.pattbl
        dc.w sonicfallsp52-.pattbl
        dc.w sonicfloasp53-.pattbl
        dc.w sonicfloasp54-.pattbl
        dc.w sonichurtsp55-.pattbl
sonicnullsp00:   
        dc.b 0                  
sonicidlesp01:  
        dc.b   4,$EC,  8,  0,  0,$F0,$F4, $D 
        dc.b   0,  3,$F0,  4,  8,  0, $B,$F0
        dc.b  $C,  8,  0, $E,$F8
sonicwaitsp02:  
        dc.b   3,$EC,  9,  0,  0,$F0,$FC,  9 
        dc.b   0,  6,$F0, $C,  8,  0, $C,$F8
sonicwaitsp03:   
        dc.b   3,$EC,  9,  0,  0,$F0,$FC,  9 
        dc.b   0,  6,$F0, $C,  8,  0, $C,$F8
sonicwaitsp04:   
        dc.b   3,$EC,  9,  0,  0,$F0,$FC,  9 
        dc.b   0,  6,$F0, $C,  8,  0, $C,$F8
soniclkupsp05:   
        dc.b   3,$EC, $A,  0,  0,$F0,  4,  8 
        dc.b   0,  9,$F0, $C,  8,  0, $C,$F8
sonicwalksp06:   
        dc.b   4,$EB, $D,  0,  0,$EC,$FB,  9 
        dc.b   0,  8,$EC,$FB,  6,  0, $E,  4
        dc.b  $B,  4,  0,$14,$EC
sonicwalksp07:   
        dc.b   2,$EC, $D,  0,  0,$ED,$FC, $E 
        dc.b   0,  8,$F5
sonicwalksp08:   
        dc.b   2,$ED,  9,  0,  0,$F3,$FD, $A 
        dc.b   0,  6,$F3
sonicwalksp09:   
        dc.b   4,$EB,  9,  0,  0,$F4,$FB,  9 
        dc.b   0,  6,$EC,$FB,  6,  0, $C,  4
        dc.b  $B,  4,  0,$12,$EC
sonicwalksp0A:   
        dc.b   2,$EC,  9,  0,  0,$F3,$FC, $E 
        dc.b   0,  6,$EB
sonicwalksp0B:   
        dc.b   3,$ED, $D,  0,  0,$EC,$FD, $C 
        dc.b   0,  8,$F4,  5,  9,  0, $C,$F4
sonicwalksp0C:   
        dc.b   5,$EB,  9,  0,  0,$EB,$EB,  6 
        dc.b   0,  6,  3,$FB,  8,  0, $C,$EB
        dc.b   3,  9,  0, $F,$F3,$13,  0,  0
        dc.b $15,$FB
sonicwalksp0D:   
        dc.b   6,$EC,  9,  0,  0,$EC,$EC,  1 
        dc.b   0,  6,  4,$FC, $C,  0,  8,$EC
        dc.b   4,  9,  0, $C,$F4,$FC,  5,  0
        dc.b $12, $C,$F4,  0,  0,$16,$14
sonicwalksp0E:   
        dc.b   4,$ED,  9,  0,  0,$ED,$ED,  1 
        dc.b   0,  6,  5,$FD, $D,  0,  8,$F5
        dc.b  $D,  8,  0,$10,$FD
sonicwalksp0F:   
        dc.b   5,$EB,  9,  0,  0,$EB,$EB,  5 
        dc.b   0,  6,  3,$FB, $D,  0, $A,$F3
        dc.b  $B,  8,  0,$12,$F3,$13,  4,  0
        dc.b $15,$FB
sonicwalksp10:  
        dc.b   4,$EC,  9,  0,  0,$EC,$EC,  1 
        dc.b   0,  6,  4,$FC, $D,  0,  8,$F4
        dc.b  $C,  8,  0,$10,$FC
sonicwalksp11:  
        dc.b   5,$ED,  9,  0,  0,$ED,$ED,  1 
        dc.b   0,  6,  5,$FD,  0,  0,  8,$ED
        dc.b $FD, $D,  0,  9,$F5, $D,  8,  0
        dc.b $11,$FD
sonicwalksp12:  
        dc.b   4,$F4,  7,  0,  0,$EB,$EC,  9 
        dc.b   0,  8,$FB,$FC,  4,  0, $E,$FB
        dc.b   4,  9,  0,$10,$FB
sonicwalksp13:  
        dc.b   2,$F4,  7,  0,  0,$EC,$EC, $B 
        dc.b   0,  8,$FC
sonicwalksp14:  
        dc.b   2,$F4,  6,  0,  0,$ED,$F4, $A 
        dc.b   0,  6,$FD
sonicwalksp15:  
        dc.b   4,$F4,  6,  0,  0,$EB,$EC,  9 
        dc.b   0,  6,$FB,$FC,  4,  0, $C,$FB
        dc.b   4,  9,  0, $E,$FB
sonicwalksp16:  
        dc.b   2,$F4,  6,  0,  0,$EC,$F4, $B 
        dc.b   0,  6,$FC
sonicwalksp17:  
        dc.b   3,$F4,  7,  0,  0,$ED,$EC,  0 
        dc.b   0,  8,$FD,$F4, $A,  0,  9,$FD
sonicwalksp18:  
        dc.b   6,$FD,  6,  0,  0,$EB,$ED,  4 
        dc.b   0,  6,$F3,$F5,  4,  0,  8,$EB
        dc.b $F5, $A,  0, $A,$FB, $D,  0,  0
        dc.b $13,$FB,$FD,  0,  0,$14,$13
sonicwalksp19:  
        dc.b   6,$FC,  6,  0,  0,$EC,$E4,  8 
        dc.b   0,  6,$F4,$EC,  4,  0,  9,$FC
        dc.b $F4,  4,  0, $B,$EC,$F4, $A,  0
        dc.b  $D,$FC, $C,  0,  0,$16,$FC
sonicwalksp1A:  
        dc.b   4,$FB,  6,  0,  0,$ED,$F3,  4 
        dc.b   0,  6,$ED,$EB, $A,  0,  8,$FD
        dc.b   3,  4,  0,$11,$FD
sonicwalksp1B:  
        dc.b   5,$FD,  6,  0,  0,$EB,$ED,  8 
        dc.b   0,  6,$F3,$F5,  4,  0,  9,$EB
        dc.b $F5, $D,  0, $B,$FB,  5,  8,  0
        dc.b $13,$FB
sonicwalksp1C:  
        dc.b   4,$FC,  6,  0,  0,$EC,$F4,  4 
        dc.b   0,  6,$EC,$EC, $A,  0,  8,$FC
        dc.b   4,  4,  0,$11,$FC
sonicwalksp1D:  
        dc.b   5,$FB,  6,  0,  0,$ED,$EB, $A 
        dc.b   0,  6,$FD,$F3,  4,  0, $F,$ED
        dc.b   3,  4,  0,$11,$FD, $B,  0,  0
        dc.b $13,$FD
sonicfastsp1E:  
        dc.b   2,$EE,  9,  0,  0,$F4,$FE, $E 
        dc.b   0,  6,$EC
sonicfastsp1F:  
        dc.b   2,$EE,  9,  0,  0,$F4,$FE, $E 
        dc.b   0,  6,$EC
sonicfastsp20:  
        dc.b   2,$EE,  9,  0,  0,$F4,$FE, $E 
        dc.b   0,  6,$EC
sonicfastsp21:  
        dc.b   2,$EE,  9,  0,  0,$F4,$FE, $E 
        dc.b   0,  6,$EC
sonicfastsp22:  
        dc.b   4,$EE,  9,  0,  0,$EE,$EE,  1 
        dc.b   0,  6,  6,$FE, $E,  0,  8,$F6
        dc.b $FE,  0,  0,$14,$EE
sonicfastsp23:  
        dc.b   3,$EE,  9,  0,  0,$EE,$EE,  1 
        dc.b   0,  6,  6,$FE, $E,  0,  8,$F6
sonicfastsp24:  
        dc.b   4,$EE,  9,  0,  0,$EE,$EE,  1 
        dc.b   0,  6,  6,$FE, $E,  0,  8,$F6
        dc.b $FE,  0,  0,$14,$EE
sonicfastsp25:  
        dc.b   3,$EE,  9,  0,  0,$EE,$EE,  1 
        dc.b   0,  6,  6,$FE, $E,  0,  8,$F6
sonicfastsp26:  
        dc.b   2,$F4,  6,  0,  0,$EE,$F4, $B 
        dc.b   0,  6,$FE
sonicfastsp27:  
        dc.b   2,$F4,  6,  0,  0,$EE,$F4, $B 
        dc.b   0,  6,$FE
sonicfastsp28:  
        dc.b   2,$F4,  6,  0,  0,$EE,$F4, $B 
        dc.b   0,  6,$FE
sonicfastsp29:  
        dc.b   2,$F4,  6,  0,  0,$EE,$F4, $B 
        dc.b   0,  6,$FE
sonicfastsp2A:  
        dc.b   4,$FA,  6,  0,  0,$EE,$F2,  4 
        dc.b   0,  6,$EE,$EA, $B,  0,  8,$FE
        dc.b  $A,  0,  0,$14,$FE
sonicfastsp2B:  
        dc.b   2,$F2,  7,  0,  0,$EE,$EA, $B 
        dc.b   0,  8,$FE
sonicfastsp2C:  
        dc.b   4,$FA,  6,  0,  0,$EE,$F2,  4 
        dc.b   0,  6,$EE,$EA, $B,  0,  8,$FE
        dc.b  $A,  0,  0,$14,$FE
sonicfastsp2D:  
        dc.b   2,$F2,  7,  0,  0,$EE,$EA, $B 
        dc.b   0,  8,$FE
sonicspinsp2E:  
        dc.b   1,$F0, $F,  0,  0,$F0 
sonicspinsp2F:  
        dc.b   1,$F0, $F,  0,  0,$F0 
sonicspinsp30:  
        dc.b   1,$F0, $F,  0,  0,$F0 
sonicspinsp31:  
        dc.b   1,$F0, $F,  0,  0,$F0 
sonicballsp32:  
        dc.b   1,$F0, $F,  0,  0,$F0 
sonicunknsp33:  
        dc.b   2,$F4, $E,  0,  0,$EC,$F4,  2 
        dc.b   0, $C, $C
sonicunknsp34:  
        dc.b   1,$F0, $F,  0,  0,$F0 
sonicunknsp35:  
        dc.b   2,$EC, $B,  0,  0,$F4, $C,  8 
        dc.b   0, $C,$F4
sonicunknsp36:  
        dc.b   1,$F0, $F,  0,  0,$F0 
sonicskidsp37:  
        dc.b   2,$ED,  9,  0,  0,$F0,$FD, $E 
        dc.b   0,  6,$F0
sonicskidsp38:  
        dc.b   4,$ED,  9,  0,  0,$F0,$FD, $D 
        dc.b   0,  6,$F0, $D,  4,  0, $E,  0
        dc.b   5,  0,  0,$10,$E8
sonicducksp39:  dc.b   4,$F4,  4,  0,  0,$FC,$FC, $D 
        dc.b   0,  2,$F4, $C,  8,  0, $A,$F4
        dc.b   4,  0,  0, $D,$EC
sonicblncsp3A:  
        dc.b   3,$EC,  8,  8,  0,$E8,$F4,  2 
        dc.b   8,  3,  0,$F4, $F,  8,  6,$E0
sonicblncsp3B:  
        dc.b   3,$EC, $E,  8,  0,$E8,  4, $D 
        dc.b   8, $C,$E0, $C,  0,$18,$14,  0
sonicfloasp3C:  
        dc.b   3,$F4, $D,  0,  0,$FC,$FC,  5 
        dc.b   0,  8,$EC,  4,  8,  0, $C,$FC
sonicfloasp3D:  
        dc.b   2,$F4, $A,  0,  0,$E8,$F4, $A 
        dc.b   8,  0,  0
sonicfloasp3E:  
        dc.b   3,$F4, $D,  0,  0,$E4,$FC,  0 
        dc.b   0,  8,  4,  4, $C,  0,  9,$EC
sonicfloasp3F:  
        dc.b   3,$F4, $D,  0,  0,$FC,$FC,  5 
        dc.b   0,  8,$EC,  4,  8,  0, $C,$FC
sonicsprisp40:  
        dc.b   3,$E8, $B,  0,  0,$F0,  8,  4 
        dc.b   0, $C,$F8,$10,  0,  0, $E,$F8
sonicgrabsp41:  
        dc.b   4,$F8, $E,  0,  0,$E8,  0,  5 
        dc.b   0, $C,  8,$F8,  0,  0,$10,  8
        dc.b $F0,  0,  0,$11,$F8
sonicgrabsp42:  
        dc.b   4,$F8, $E,  0,  0,$E8,  0,  5 
        dc.b   0, $C,  8,$F8,  0,  0,$10,  8
        dc.b $F0,  0,  0,$11,$F8
sonicvictsp43:  
        dc.b   5,$E8, $A,  0,  0,$F4,$F0,  1 
        dc.b   0,  9, $C,  0,  9,  0, $B,$F4
        dc.b $10,  4,  0,$11,$F4,  0,  0,  0
        dc.b $13,$EC
sonicvictsp44:  
        dc.b   5,$E8, $A,  0,  0,$F4,$E8,  1 
        dc.b   0,  9, $C,  0,  9,  0, $B,$F4
        dc.b $10,  4,  0,$11,$F4,  0,  0,  0
        dc.b $13,$EC
sonicpushsp45:  
        dc.b   2,$ED, $A,  0,  0,$F3,  5, $D 
        dc.b   0,  9,$EB
sonicpushsp46:  
        dc.b   3,$EC, $A,  0,  0,$F3,  4,  8 
        dc.b   0,  9,$F3, $C,  4,  0, $C,$F3
sonicpushsp47:  
        dc.b   2,$ED, $A,  0,  0,$F3,  5, $D 
        dc.b   0,  9,$EB
sonicpushsp48:  
        dc.b   3,$EC, $A,  0,  0,$F3,  4,  8 
        dc.b   0,  9,$F3, $C,  4,  0, $C,$F3
sonicunknsp49:  
        dc.b   2,$EC,  9,  0,  0,$F0,$FC, $E 
        dc.b   0,  6,$F0
sonicbubbsp4A:  
        dc.b   3,$EC, $A,  0,  0,$F0,  4,  5 
        dc.b   0,  9,$F8,$E4,  0,  0, $D,$F8
sonicfiresp4B:  
        dc.b   3,$E8, $D,  0,  0,$EC,$E8,  1 
        dc.b   0,  8, $C,$F8, $B,  0, $A,$F4
sonicwdiesp4C:  
        dc.b   5,$E8, $D,  0,  0,$EC,$E8,  1 
        dc.b   0,  8, $C,$F8,  9,  0, $A,$F4
        dc.b   8, $C,  0,$10,$F4,$10,  0,  0
        dc.b $14,$F4
sonicndiesp4D:  
        dc.b   5,$E8, $D,  0,  0,$EC,$E8,  1 
        dc.b   0,  8, $C,$F8,  9,  0, $A,$F4
        dc.b   8, $C,  0,$10,$F4,$10,  0,  0
        dc.b $14,$F4
sonicfallsp4E:  
        dc.b   2,$EC,  8,  0,  0,$F0,$F4, $F 
        dc.b   0,  3,$F0
sonicfallsp4F:  
        dc.b   3,$EC,  8,  0,  0,$F0,$F4, $E 
        dc.b   0,  3,$F0, $C,  8,  0, $F,$F8
sonicfallsp50:  
        dc.b   1,$F0, $B,  0,  0,$F4 
sonicfallsp51:  
        dc.b   1,$F4,  6,  0,  0,$F8 
sonicfallsp52:  
        dc.b   1,$F8,  1,  0,  0,$FC 
sonicfloasp53:  
        dc.b   3,$F4, $D,  8,  0,$E4,$FC,  5 
        dc.b   8,  8,  4,  4,  8,  8, $C,$EC
sonicfloasp54:  
        dc.b   3,$F4, $D,  8,  0,$FC,$FC,  0 
        dc.b   8,  8,$F4,  4, $C,  8,  9,$F4
sonichurtsp55:  
        dc.b   3,$F0, $E,  0,  0,$EC,$F8,  1 
        dc.b   0, $C, $C,  8, $C,  0, $E,$F4
        dc.b   0