@echo off
set file=pelock_plugin
e:\dev\masm\bin\ml.exe /c /coff /Cp %file%.asm
e:\dev\masm\bin\link.exe /OPT:NOWIN98 /SECTION:.text,RWE /SUBSYSTEM:WINDOWS,4.0 %file%.obj
del *.obj
del *.bin
pause
cls