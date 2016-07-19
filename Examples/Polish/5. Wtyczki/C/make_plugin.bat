@echo off
call ..\..\..\SetCompilerVars.bat

set file=pelock_plugin
lcc.exe -O -I%PELOCK_SDK_C% %file%.c
lcclnk.exe -s -subsystem windows -dll -nounderscores %file%.obj
del *.obj
del *.lib
del *.exp
pause
cls