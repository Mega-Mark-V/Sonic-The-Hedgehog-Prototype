@echo off
set ASM68K="_bin/asm68k.exe" /p /o ae-,l.,ow+
set VASM68K="_bin/vasmm68k_psi-x.exe" -altlocal -m68000 -maxerrors=0 -Fbin -start=0 -no-opt
set VASMZ80="_bin/vasmz80_psi-x.exe" -altlocal -altnum -spaces -maxerrors=0 -Fbin -start=0

if not exist _built mkdir _built
cd _built
if not exist sound mkdir sound
cd ..
%VASMZ80% -o "_built/sound/Z80.bin" -L "_built/sound/Z80.lst" -Lall "Sound/PCM/mddr11.src" 2> _built/sound/Z80.log

%VASM68K% -o "_built/_ROM.MDRV" -L "_built/_ROM.LST" -Lall "MAIN.68k" 2> _built/_ROM.log

fc s1proto.base.bin _built/_ROM.MDRV > _built/_ROM.diff.txt