; ---------------------------------------------------------------------------
; Global Variables
; ---------------------------------------------------------------------------

VARIABLES       EQU $FFFFF600 	; +FF000000 for sign extension optimization
	rsset	VARIABLES
gamemode:       	rs.b 2    
joypadMirror:   	rs.b 1    
joypadMirrorPress:	rs.b 1  
joypad:         	rs.b 1    
joypadPress:    	rs.b 1    
                	rs.b 6
displayMode:      	rs.b 2    
                	rs.b 6
genericTimer:   	rs.b 2    
mainAPosY:  		rs.b 2    
mainBPosY:  		rs.b 2    
mainAPosX:  		rs.b 2    
mainBPosX:  		rs.b 2    
mainZPosY:  		rs.b 2    
mainZPosX:  		rs.b 2    
vdpUnkPos: 		rs.b 2    
hblankLine:  		rs.b 2    
palFadeArgs:    	
palFadeOff:		rs.b 1    
palFadeSize:    	rs.b 1    
vblankUnk1:     	rs.b 1    
vblankUnk2:    		rs.b 1    
vblankCmd:      	rs.b 1    
                	rs.b 1
spriteCount:    	rs.b 1    
                	rs.b 5
palCycStep:  		rs.b 2    
palCycTimer:    	rs.b 2    
randomSeed: 		rs.b 4    
paused:         	rs.b 2    
                	rs.b 8
vdpIntBuffer:   	rs.b 2    
                	rs.b 2
hblankFlag:     	rs.b 2    
                	rs.b 2
water:          	rs.b 2    
                	rs.b $12
logoUnk1:       	rs.b 2    
logoUnk2:       	rs.b 2    
                	rs.b 2
zoneselTime: 		rs.b 2    
zoneselItem:		rs.b 2 
zoneselSnd: 		rs.b 2    
                	rs.b $14
decompQueue:   		rs.b $60  
decompNemWrite: 	rs.b 4    
decompRepeat:   	rs.b 4    
decompPixel:    	rs.b 4    
decompRow:      	rs.b 4    
decompRead:     	rs.b 4    
decompShift:    	rs.b 4    
decompTileCount:	rs.b 2    
decompProcTileCnt:	rs.b 2  
                	ds.b 4
cameraAPosX:    	ds.b 4                  
cameraAPosY:    	ds.b 4                  
cameraBPosX:    	ds.b 4                  
cameraBPosY:    	ds.b 4                  
cameraCPosX:    	ds.b 4                  
cameraCPosY:    	ds.b 4                  
cameraZPosX:    	ds.b 4                  
cameraZPosY:    	ds.b 4                  
eventLimALeft:  	ds.b 2                  
eventLimARight: 	ds.b 2
eventLimAUp:    	ds.b 2                  
eventLimADown:  	ds.b 2                  
limitALeft:     	ds.b 2                  
limitARight:    	ds.b 2                  
limitAUp:       	ds.b 2                  
limitADown:     	ds.b 2                  
camARoutine:    	ds.b 2                  
camAKeepH:      	ds.b 2                  
camAKeepV:      	ds.b 2
                	ds.b 2
                	ds.b 2
cameraDiffX:    	ds.b 2                  
cameraDiffY:    	ds.b 2                  
cameraCenterY:  	ds.b 2                  
autoscrollX:	   	ds.b 1                  
autoscrollY:   		ds.b 1                  
eventRoutine:   	ds.b 1                                 
                	ds.b 1
cameraLock:     	ds.b 1                  
                	ds.b 1
redrawUnk1:     	ds.b 2                  
redrawUnk2:     	ds.b 2                  
cameraAblkX:    	ds.b 1                  
cameraAblkY:    	ds.b 1                  
cameraBblkX:    	ds.b 1                  
cameraBblkY:    	ds.b 1                  
cameraCblkX:    	ds.b 1                  
cameraCblkY:    	ds.b 1
cameraZblkX:    	ds.b 1
cameraZblkY:    	ds.b 1
                	ds.b 1
                	ds.b 1
camDrawA:       	ds.b 2                  
camDrawB:       	ds.b 2                  
camDrawC:       	ds.b 2                  
camDrawZ:       	ds.b 2
vscrollFlag:    	ds.b 2                  
                	ds.b 2
playerMaxSpeed: 	ds.b 2                  
playerAccel:    	ds.b 2                  
playerDecel:    	ds.b 2                  
playerFrame:    	ds.b 1                  
playerDrawFlag: 	ds.b 1                  
angleFront: 		ds.b 2                  
angleBack:  		ds.b 2                  
getobjsMode:    	ds.b 2                  
camAChunkX:      	ds.b 2                  
objtblEntrRight:	ds.b 4                  
objtblEntrLeft: 	ds.b 4                  
objtblEntrRightZ:	ds.b 4                 
objtblEntrLeftZ:	ds.b 4                   
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
specialChunks:    
loopChunk1:     	ds.b 1
loopChunk2:     	ds.b 1                  
spinChunk1:     	ds.b 1                  
spinChunk2:     	ds.b 1                  
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
vdpSprites:     	rs.b $280 
paletteWater:   	rs.b $80
palette:        	rs.b $80  
fadingPalette:  	rs.b $80  
objectStates:   	rs.b $40  
errorInfo:       	rs.b 4    
errorCode:      	rs.b 1    

GAMEINFO     EQU $FFFFFE00
STACK        EQU $00FFFE00 		; for vector table entry 		

	rsset	GAMEINFO
stack:          	rs.b 2    
restart:        	rs.b 2    
frameCntr:     		rs.b 2    
editItem:       	rs.b 2
editMode:       	rs.b 2    
editXVel:       	rs.b 1    
editYVel:       	rs.b 1    
vblankCntr:  		rs.b 4    
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
timeFrame:   		rs.b 1
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
demoZone:   		rs.b 2    
                	rs.b 4
hardwareVersion:	rs.b 2    
debug:          	rs.b 2    
bootFlag:       	rs.b 4    
VARIABLESSZ		EQU	__rs-VARIABLES

; -------------------------------------------------------------------------

