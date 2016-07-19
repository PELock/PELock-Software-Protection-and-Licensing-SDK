@echo off

set PELOCK_COMPILE_ALL=1

set EXAMPLE=%CD%

set CONSOLE_SCRIPT=make_console_d.bat
set GUI_SCRIPT=make_gui_d.bat

call "SetCompilerVars.bat"

call :compile_go "%EXAMPLE%\English\1. License system\DEMO_START - license keys\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\1. License system\DisableRegistrationKey - disable key\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\1. License system\FEATURE_x_START - features encryption\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\1. License system\GetHardwareId - hardware identifier\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\1. License system\GetKeyCreationDate - key creation date\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\1. License system\GetKeyData, IsFeatureEnabled - additional key data\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\1. License system\GetKeyExpirationDate - key expiration date\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\1. License system\GetKeyInteger - custom integer values\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\1. License system\GetKeyRunningTime - key running time\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\1. License system\GetKeyStatus - license key status information\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\1. License system\GetRegistrationName - user name\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\1. License system\HARDWARE_ID_CALLBACK - custom hardware id callback\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\1. License system\SetHardwareIdCallback - custom hardware id callback\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\1. License system\SetRegistrationKey - setting key\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\1. License system\UNREGISTERED_START - unregistered mode\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\2. Protection integration\CLEAR_START - code clear\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\2. Protection integration\CRYPT_START - code encryption\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\2. Protection integration\EncryptData, EncryptMemory - encryption functions\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\2. Protection integration\FILE_CRYPT_START - code encryption\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\2. Protection integration\IsPELockPresent - protection checks\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\2. Protection integration\PELOCK_CHECKPOINT - checkpoints\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\2. Protection integration\PELOCK_CPUID - checkpoints\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\2. Protection integration\PELOCK_DWORD - protected constants\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\2. Protection integration\PELOCK_INIT_CALLBACK - initalization callbacks\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\2. Protection integration\PELOCK_MEMORY_GAP - memory gaps\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\3. Time trial\GetExpirationDate - trial expiration\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\3. Time trial\GetTrialDays - trial days\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\3. Time trial\GetTrialExecutions - trial executions\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\3. Time trial\GetTrialPeriod - trial period\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\English\4. Keygen\D\" "%CONSOLE_SCRIPT%"

call :compile_go "%EXAMPLE%\Polish\1. System licencyjny\DEMO_START - klucze licencyjne\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\1. System licencyjny\DisableRegistrationKey - wylaczenie klucza licencyjnego\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\1. System licencyjny\FEATURE_x_START - indywidualnie szyfrowane sekcje\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\1. System licencyjny\GetHardwareId - sprzetowy identyfikator\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\1. System licencyjny\GetKeyCreationDate - data utworzenia klucza\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\1. System licencyjny\GetKeyData, IsFeaturePresent - dodatkowe dane klucza\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\1. System licencyjny\GetKeyExpirationDate - data wygasniecia klucza\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\1. System licencyjny\GetKeyInteger - dodatkowe wartosci liczbowe\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\1. System licencyjny\GetKeyRunningTime - czas wykorzystania klucza\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\1. System licencyjny\GetKeyStatus - informacje o statusie klucza licencyjnego\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\1. System licencyjny\GetRegistrationName - nazwa uzytkownika\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\1. System licencyjny\HARDWARE_ID_CALLBACK - wlasna procedura identyfikatora sprzetowego\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\1. System licencyjny\SetHardwareIdCallback - wlasna procedura identyfikatora sprzetowego\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\1. System licencyjny\SetRegistrationKey - ustawianie klucza\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\1. System licencyjny\UNREGISTERED_START - tryb niezarejestrowany\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\2. Integracja zabezpieczenia\CLEAR_START - zamazywanie kodu\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\2. Integracja zabezpieczenia\CRYPT_START - szyfrowanie kodu\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\2. Integracja zabezpieczenia\EncryptData, EncryptMemory - funkcje szyfrujace\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\2. Integracja zabezpieczenia\FILE_CRYPT_START - szyfrowanie kodu\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\2. Integracja zabezpieczenia\IsPELockPresent - stan zabezpieczenia\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\2. Integracja zabezpieczenia\PELOCK_CHECKPOINT - punkty kontrolne\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\2. Integracja zabezpieczenia\PELOCK_CPUID - punkty kontrolne\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\2. Integracja zabezpieczenia\PELOCK_DWORD - chronione wartosci\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\2. Integracja zabezpieczenia\PELOCK_INIT_CALLBACK - funkcje inicjalizujace\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\2. Integracja zabezpieczenia\PELOCK_MEMORY_GAP - przerwy w pamieci\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\3. Ograniczenia czasowe\GetExpirationDate - data wygasniecia\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\3. Ograniczenia czasowe\GetTrialDays - ilosc dni dzialania\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\3. Ograniczenia czasowe\GetTrialExecutions - ilosc uruchomien\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\3. Ograniczenia czasowe\GetTrialPeriod - okres dzialania aplikacji\D\" "%CONSOLE_SCRIPT%"
call :compile_go "%EXAMPLE%\Polish\4. Keygen\D\" "%CONSOLE_SCRIPT%"

pause
exit

:compile_go

echo "%~p1"
cd "%1"
call "%2"

if errorlevel 0 goto compiled_ok
pause
:compiled_ok

@exit /B 0