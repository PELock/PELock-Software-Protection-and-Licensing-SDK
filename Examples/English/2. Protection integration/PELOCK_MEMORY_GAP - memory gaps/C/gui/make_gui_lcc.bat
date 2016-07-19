@echo off
call ..\..\..\..\..\SetCompilerVars.bat

set file=gui
lcc.exe -O -I%PELOCK_SDK_C% %file%.c
lcclnk.exe -reloc -s -subsystem windows %file%.obj %file%.res
del *.obj
if defined PELOCK_COMPILE_ALL goto end
pause
cls
:end