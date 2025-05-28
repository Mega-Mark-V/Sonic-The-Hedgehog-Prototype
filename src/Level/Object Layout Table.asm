; ---------------------------------------------------------------------------
; Object Layout Table
; 
; Each level has 2 entries, one for layout A, and one for Z (unused)
; ---------------------------------------------------------------------------

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

	; Basic null placeholder?
ObjList_Unk:
	dc.w -1,0,0

ObjList_GHZ1:
	incbin  "Level/Data/ObjLayout/GHZ/GHZ1_A.bin"
ObjList_GHZ2:
	incbin  "Level/Data/ObjLayout/GHZ/GHZ2_A.bin"
ObjList_GHZ3:
	incbin  "Level/Data/ObjLayout/GHZ/GHZ3_A.bin"      

ObjList_LZ1: 
	incbin  "Level/Data/ObjLayout/LZ/LZ1_A.bin"
ObjList_LZ2: 
	incbin  "Level/Data/ObjLayout/LZ/LZ2_A.bin"  
ObjList_LZ3: 
	incbin  "Level/Data/ObjLayout/LZ/LZ3_A.bin"

ObjList_MZ1: 
	incbin  "Level/Data/ObjLayout/MZ/MZ1_A.bin"
ObjList_MZ2: 
	incbin  "Level/Data/ObjLayout/MZ/MZ2_A.bin"
ObjList_MZ3:
	incbin  "Level/Data/ObjLayout/MZ/MZ3_A.bin"

ObjList_SLZ1:
	incbin  "Level/Data/ObjLayout/SLZ/SLZ1_A.bin"                
ObjList_SLZ2:    
	incbin  "Level/Data/ObjLayout/SLZ/SLZ2_A.bin"   
ObjList_SLZ3:    
	incbin  "Level/Data/ObjLayout/SLZ/SLZ3_A.bin"   

ObjList_SZ1: 
	incbin  "Level/Data/ObjLayout/SZ/SZ1_A.bin"  
ObjList_SZ2: 
	incbin  "Level/Data/ObjLayout/SZ/SZ2_A.bin"  
ObjList_SZ_Old:
	incbin  "Level/Data/ObjLayout/SZ/SZ_A.bin"            
ObjList_SZ3: 
	incbin  "Level/Data/ObjLayout/SZ/SZ3_A.bin"  

ObjList_CWZ1:
	incbin  "Level/Data/ObjLayout/CWZ/CWZ1_A.bin"  
ObjList_CWZ2:
	incbin  "Level/Data/ObjLayout/CWZ/CWZ2_A.bin"  
ObjList_CWZ3:
	incbin  "Level/Data/ObjLayout/CWZ/CWZ3_A.bin"  

ObjList_NULL:
	dc.w -1,0,0