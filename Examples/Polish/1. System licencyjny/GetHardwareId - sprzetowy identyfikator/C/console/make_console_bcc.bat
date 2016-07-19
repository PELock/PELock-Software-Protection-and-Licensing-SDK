@echo off
call ..\..\..\..\..\SetCompilerVars.bat

set file=console
bcc32.exe -w-8057 -w-8004 -c -I%PELOCK_SDK_C% %file%.c
ulink -L%BCC_LIB_PATH% c0x32.obj %file%.obj uuid.lib cw32.lib
del *.obj
if defined PELOCK_COMPILE_ALL goto end
pause
cls
:end