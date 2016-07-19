@echo off
set file=pelock_plugin
e:\dev\fasm\fasm.exe %file%.asm
del *.bin
pause
cls