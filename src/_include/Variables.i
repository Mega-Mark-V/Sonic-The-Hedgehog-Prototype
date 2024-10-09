; ---------------------------------------------------------------------------
; Global Variables
; ---------------------------------------------------------------------------

VARIABLES       EQU $FFFFF600
	rsset	VARIABLES
gamemode:       	rs.b 2    
joypadMirror:   	rs.b 1    
joypadMirrorPress:	rs.b 1  
joypad:         	rs.b 1    
joypadPress:    	rs.b 1    
                	rs.b 6
vdpBuffer:      	rs.b 2    
                	rs.b 6
genericTimer:   	rs.b 2    
vdpPlaneAPosY:  	rs.b 2    
vdpPlaneBPosY:  	rs.b 2    
vdpPlaneAPosX:  	rs.b 2    
vdpPlaneBPosX:  	rs.b 2    
vdpPlaneZPosY:  	rs.b 2    
vdpPlaneZPosX:  	rs.b 2    
vdpPlaneZPosY2: 	rs.b 2    
vdpHBLANKLine:  	rs.b 1    
hblankLine:     	rs.b 1    
palFadeArgs:    	rs.b 1    
palFadeSize:    	rs.b 1    
vblankUnk1:     	rs.b 1    
vblankUnk2:    		rs.b 1    
vblankCmd:      	rs.b 1    
                	rs.b 1
spriteCount:    	rs.b 1    
                	rs.b 5
palCycCurrent:  	rs.b 2    
palCycTimer:    	rs.b 2    
randomUserSeed: 	rs.b 4    
paused:         	rs.b 2    
                	rs.b 8
vdpIntBuffer:   	rs.b 2    
                	rs.b 2
hblankFlag:     	rs.b 2    
                	rs.b 2
water:          	rs.b 2    
                	rs.b $12
segaUnk1:       	rs.b 2    
segaUnk2:       	rs.b 2    
                	rs.b 2
lvlselCurTimer: 	rs.b 2    
lvlselCurSelection:	rs.b 2 
lvlselCurSound: 	rs.b 2    
                	rs.b $14
decompBuffer:   	rs.b $60  
decompNemWrite: 	rs.b 4    
decompRepeat:   	rs.b 4    
decompPixel:    	rs.b 4    
decompRow:      	rs.b 4    
decompRead:     	rs.b 4    
decompShift:    	rs.b 4    
decompTileCount:	rs.b 2    
decompProcTileCnt:	rs.b 2  
                	rs.b 4
cameraMainX:    	rs.b 4    
cameraMainY:    	rs.b 4    
scrollBGX:      	rs.b 4    
scrollBGY:      	rs.b 4    
scrollBG2X:     	rs.b 4    
scrollBG2Y:     	rs.b 4    
scrollBG3X:     	rs.b 4    
scrollBG3Y:     	rs.b 4    
levelLeftBound: 	rs.b 2    
levelRightBound:	rs.b 2
levelTopBound:  	rs.b 2    
levelBottomBound:	rs.b 2   
eventLeftBound: 	rs.b 2    
eventRightBound:	rs.b 2    
eventTopBound:  	rs.b 2    
eventBottomBound:	rs.b 2   
eventUnkVar5:   	rs.b 2    
levelEndBounds: 	rs.b 2    
                	rs.b 6
scrollDiffX:    	rs.b 2    
scrollDiffY:    	rs.b 2    
cameraYCenter:  	rs.b 2    
scrollHReset:   	rs.b 1    
scrollVReset:   	rs.b 1    
levelCurEvent:  	rs.b 1    
                	rs.b 1
scrollBGFlag:   	rs.b 1    
                	rs.b 1
scrollUnk1:     	rs.b 1    
                	rs.b 1
scrollUnk2:     	rs.b 1    
                	rs.b 1
scrollFGBlockX: 	rs.b 1    
scrollFGBlockY: 	rs.b 1    
scrollBGBlockX: 	rs.b 1    
scrollBGBlockY: 	rs.b 1    
scrollBG2BlockX:	rs.b 1    
                	rs.b 5
scrollFGFlags:  	rs.b 2    
scrollBGFlags:  	rs.b 2    
scrollBG2Flags: 	rs.b 2    
scrollBG3Flags: 	rs.b 2
scrollBGVertFlag:	rs.b 2   
                	rs.b 1
                	rs.b 1
sonicSpeedLimit:	rs.b 2    
sonicAcceleration:	rs.b 2  
sonicDecelDelta:	rs.b 2    
sonicFrame:     	rs.b 1    
sonicRedrawFlag:	rs.b 1    
footFrontAngle: 	rs.b 2    
footBackAngle:  	rs.b 2    
objectLoadRoutine:	rs.b 2  
objectChunk:    	rs.b 2    
objectChunkRight:	rs.b 4   
objectChunkLeft:	rs.b 4    
objunkChunkRight:	rs.b 4   
objunkChunkLeft:	rs.b 4    
specialAngle:   	rs.b 2    
specialSpinSpeed:	rs.b 2
                	rs.b $C
joypadHeldTime: 	rs.b 2    
joypadHeldTimeMirror:	rs.b 1 
                	rs.b 1
demoHalfFade:   	rs.b 2    
levelCollision: 	rs.b 4    
specialCycCurrent:	rs.b 2  
specialCycTime: 	rs.b 2    
specialCycUnk1: 	rs.b 2    
specialCycTime2:	rs.b 2    
                	rs.b 2
marblePuzzleVar:	rs.b 2    
                	rs.b 1
bossFlag:       	rs.b 1    
trackPos:       	rs.b 1    
trackPosEntry:  	rs.b 1    
screenLocked:   	rs.b 2    
specialChunkIDs:	rs.b 4    
animGFXFrame1:  	rs.b 1    
animGFXTimer1:  	rs.b 1    
animGFXFrame2:  	rs.b 1    
animGFXTimer2:  	rs.b 1    
animGFXFrame3:  	rs.b 1    
animGFXTimer3:  	rs.b 1    
animGFXUnk1:    	rs.b 1    
                	rs.b $29
switchActive:   	rs.b 2    
                	rs.b $D
unkMarbleVar:   	rs.b 1    
scrollBlockSize:	rs.b 2    
                	rs.b $E
sprites:     		rs.b $280 
paletteWater:   	rs.b $80
palette:        	rs.b $80  
palFadeBuffer:  	rs.b $80  
objectStates:   	rs.b $40  
errorInfo:       	rs.b 4    
errorCode:      	rs.b 1    

GAMEINFO     EQU $FFFFFE00
	rsset	GAMEINFO
stack:          	rs.b 2    
restart:        	rs.b 2    
frameCount:     	rs.b 2    
editItem:       	rs.b 1    
                	rs.b 1
editMode:       	rs.b 2    
editXVel:       	rs.b 1    
editYVel:       	rs.b 1    
vblankCounter:  	rs.b 4    
zone:           	rs.b 1    
act:            	rs.b 1    
lives:          	rs.b 1    
                	rs.b 8
hudLives:       	rs.b 1    
hudLivesUpdate: 	rs.b 1    
hudRingsUpdate: 	rs.b 1    
hudTimeUpdate:  	rs.b 1    
hudScoreUpdate: 	rs.b 1    
rings:          	rs.b 2    
time:           	rs.b 1    
timeMinute:     	rs.b 1    
timeSecond:     	rs.b 1    
timeCentisec:   	rs.b 1
score:          	rs.b 4    
                	rs.b 2
shield:         	rs.b 1    
invincible:     	rs.b 1    
speedup:        	rs.b 1    
unkPowerup:     	rs.b 1    
                	rs.b 2
                	rs.b $1E
scoreMirror:    	rs.b 1    
                	rs.b 3
Lives2:          	rs.b 2    
savedLives:     	rs.b 1    
		   	rs.b 1
clearActUnk1:  		rs.b 6    
oscillatingData:	rs.b $62  
objectSyncAnim_Time0:	rs.b 1 
objectSyncAnim_Frame0:	rs.b 1
objectSyncAnim_Time1:	rs.b 1 
objectSyncAnim_Frame1:	rs.b 1
objectSyncAnim_Time2:	rs.b 1 
objectSyncAnim_Frame2:	rs.b 1
objectSyncAnim_Time3:	rs.b 1 
objectSyncAnim_Frame3:	rs.b 1
objectSyncAnim_Buf:	rs.b 2 
                	rs.b $116
levelselectFlag:	rs.b 2    
                	rs.b 6
hblankWaterFlag:	rs.b 2    
                	rs.b 6
demo:           	rs.b 2    
demoCurLevel:   	rs.b 2    
                	rs.b 4
hardwareVersion:	rs.b 2    
debug:          	rs.b 2    
bootFlag:       	rs.b 4    
VARIABLESSZ		EQU	__rs-VARIABLES

; -------------------------------------------------------------------------

