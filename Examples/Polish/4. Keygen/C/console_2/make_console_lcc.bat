@echo off
call ..\..\..\..\SetCompilerVars.bat

set file=console
lcc.exe -O -I%PELOCK_SDK_C% %file%.c
lcclnk.exe -reloc -s -subsystem console %file%.obj
del *.obj
if defined PELOCK_COMPILE_ALL goto end
pause
cls
:end