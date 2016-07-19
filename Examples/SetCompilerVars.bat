@echo off

if defined PELOCK_COMPILER_VARS goto end
set PELOCK_COMPILER_VARS=1

REM --------------------------------------------------------------------
REM Setup SDK path
REM --------------------------------------------------------------------

set PELOCK_SDK_C="%~dp0..\SDK\English\C"
set PELOCK_SDK_D="%~dp0..\SDK\English\D"

REM --------------------------------------------------------------------
REM Setup compiler paths
REM --------------------------------------------------------------------

call :lcc_compiler_path
call :bcc_compiler_path
call :d_compiler_path


goto :end

REM --------------------------------------------------------------------
REM Setup LCC compiler paths
REM --------------------------------------------------------------------
:lcc_compiler_path

FOR /F "tokens=2*" %%A IN ('REG.EXE QUERY "HKCU\Software\lcc" /V "lccroot" 2^>NUL ^| FIND "REG_SZ"') DO SET PATH="%%B\bin";%PATH%;

@exit /B 0

REM --------------------------------------------------------------------
REM Setup BCC compiler paths
REM
REM Latest UniLink is available at ftp://ftp.styx.cabel.net/pub/UniLink/
REM --------------------------------------------------------------------
:bcc_compiler_path

set PATH="E:\dev\hll_compilers\bcb551\bin\bcc32.exe";%PATH%;
set PATH="E:\dev\hll_compilers\bcb551\Lib";%PATH%;
set PATH="E:\dev\hll_compilers\ulink\";%PATH%;
set BCC_LIB_PATH="E:\dev\hll_compilers\bcb551\Lib"

@exit /B 0

REM --------------------------------------------------------------------
REM Setup D compiler paths
REM --------------------------------------------------------------------
:d_compiler_path

FOR /F "tokens=2*" %%A IN ('REG.EXE QUERY "HKLM\Software\D" /V "Install_Dir" 2^>NUL ^| FIND "REG_SZ"') DO SET PATH="%%B\windows\bin";%PATH%;

@exit /B 0

REM --------------------------------------------------------------------
REM Exit
REM --------------------------------------------------------------------

:end
