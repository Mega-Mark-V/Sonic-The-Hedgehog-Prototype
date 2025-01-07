@echo off
set ASM68K="_bin/asm68k.exe" /p /o ae-,l.,ow+
set VASM="_bin/vasmm68k_psi-x.exe" -altlocal -m68000 -maxerrors=0 -Fbin -start=0

if not exist _built mkdir _built
%VASM% -o "_built/_ROM.MDRV" -L "_built/_ROM.LST" -Lall "MAIN.68k" 2> _built/_ROM.log