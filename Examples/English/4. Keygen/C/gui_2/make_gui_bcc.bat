@echo off
call ..\..\..\..\SetCompilerVars.bat

set file=gui
bcc32.exe -w-8057 -w-8004 -c -I%PELOCK_SDK_C% %file%.c
ulink -aa -L%BCC_LIB_PATH% c0w32.obj %file%.obj uuid.lib cw32.lib %file%.res
del *.obj
if defined PELOCK_COMPILE_ALL goto end
pause
cls
:end