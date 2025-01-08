ObjListTbl:   
	dc.w ObjList_GHZ1-ObjListTbl,ObjList_NULL-ObjListTbl
        dc.w ObjList_GHZ2-ObjListTbl,ObjList_NULL-ObjListTbl
        dc.w ObjList_GHZ3-ObjListTbl,ObjList_NULL-ObjListTbl
        dc.w ObjList_GHZ1-ObjListTbl,ObjList_NULL-ObjListTbl

        dc.w ObjList_LZ1-ObjListTbl,ObjList_NULL-ObjListTbl
        dc.w ObjList_LZ2-ObjListTbl,ObjList_NULL-ObjListTbl
        dc.w ObjList_LZ3-ObjListTbl,ObjList_NULL-ObjListTbl
        dc.w ObjList_LZ1-ObjListTbl,ObjList_NULL-ObjListTbl

        dc.w ObjList_MZ1-ObjListTbl,ObjList_NULL-ObjListTbl
        dc.w ObjList_MZ2-ObjListTbl,ObjList_NULL-ObjListTbl
        dc.w ObjList_MZ3-ObjListTbl,ObjList_NULL-ObjListTbl
        dc.w ObjList_MZ1-ObjListTbl,ObjList_NULL-ObjListTbl

        dc.w ObjList_SLZ1-ObjListTbl,ObjList_NULL-ObjListTbl
        dc.w ObjList_SLZ2-ObjListTbl,ObjList_NULL-ObjListTbl
        dc.w ObjList_SLZ3-ObjListTbl,ObjList_NULL-ObjListTbl
        dc.w ObjList_SLZ1-ObjListTbl,ObjList_NULL-ObjListTbl

        dc.w ObjList_SZ1-ObjListTbl,ObjList_NULL-ObjListTbl
        dc.w ObjList_SZ2-ObjListTbl,ObjList_NULL-ObjListTbl
        dc.w ObjList_SZ3-ObjListTbl,ObjList_NULL-ObjListTbl
        dc.w ObjList_SZ1-ObjListTbl,ObjList_NULL-ObjListTbl
        
        dc.w ObjList_CWZ1-ObjListTbl,ObjList_NULL-ObjListTbl
        dc.w ObjList_CWZ2-ObjListTbl,ObjList_NULL-ObjListTbl
        dc.w ObjList_CWZ3-ObjListTbl,ObjList_NULL-ObjListTbl
        dc.w ObjList_CWZ1-ObjListTbl,ObjList_NULL-ObjListTbl

        ; I think this is for zone 6 as a placeholder
ObjList_Unk:        
                dc.w -1,0,0

ObjList_GHZ1:
        incbin  "GM LEVEL/Objects/Layout/GHZ/GHZ1_A.bin"
ObjList_GHZ2:
        incbin  "GM LEVEL/Objects/Layout/GHZ/GHZ2_A.bin"
ObjList_GHZ3:
        incbin  "GM LEVEL/Objects/Layout/GHZ/GHZ3_A.bin"      

ObjList_LZ1: 
        incbin  "GM LEVEL/Objects/Layout/LZ/LZ1_A.bin"
ObjList_LZ2: 
        incbin  "GM LEVEL/Objects/Layout/LZ/LZ2_A.bin"  
ObjList_LZ3: 
        incbin  "GM LEVEL/Objects/Layout/LZ/LZ3_A.bin"

ObjList_MZ1: 
        incbin  "GM LEVEL/Objects/Layout/MZ/MZ1_A.bin"
ObjList_MZ2: 
        incbin  "GM LEVEL/Objects/Layout/MZ/MZ2_A.bin"
ObjList_MZ3:
        incbin  "GM LEVEL/Objects/Layout/MZ/MZ3_A.bin"

ObjList_SLZ1:
        incbin  "GM LEVEL/Objects/Layout/SLZ/SLZ1_A.bin"                
ObjList_SLZ2:    
        incbin  "GM LEVEL/Objects/Layout/SLZ/SLZ2_A.bin"   
ObjList_SLZ3:    
        incbin  "GM LEVEL/Objects/Layout/SLZ/SLZ3_A.bin"   

ObjList_SZ1: 
        incbin  "GM LEVEL/Objects/Layout/SZ/SZ1_A.bin"  
ObjList_SZ2: 
        incbin  "GM LEVEL/Objects/Layout/SZ/SZ2_A.bin"  
ObjList_SZ_Old:
        incbin  "GM LEVEL/Objects/Layout/SZ/SZ_A.bin"            
ObjList_SZ3: 
        incbin  "GM LEVEL/Objects/Layout/SZ/SZ3_A.bin"  

ObjList_CWZ1:
        incbin  "GM LEVEL/Objects/Layout/CWZ/CWZ1_A.bin"  
ObjList_CWZ2:
        incbin  "GM LEVEL/Objects/Layout/CWZ/CWZ2_A.bin"  
ObjList_CWZ3:
        incbin  "GM LEVEL/Objects/Layout/CWZ/CWZ3_A.bin"  

ObjList_NULL:
        dc.w -1,0,0