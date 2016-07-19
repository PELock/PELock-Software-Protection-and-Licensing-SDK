@echo off
call ..\..\..\..\SetCompilerVars.bat

set file=console
dmd.exe %file%.d %PELOCK_SDK_D%\pelock.d
del *.obj
if defined PELOCK_COMPILE_ALL goto end
pause
cls
:end