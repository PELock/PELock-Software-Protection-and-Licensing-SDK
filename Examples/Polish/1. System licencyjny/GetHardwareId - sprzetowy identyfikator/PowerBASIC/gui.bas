'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad jak odczytac identyfikator sprzetowy
'//
'// Wersja         : PELock v2.0
'// Jezyk          : PowerBASIC
'// Autor          : Bartosz Wójcik (support@pelock.com)
'// Strona domowa  : https://www.pelock.com
'//
'///////////////////////////////////////////////////////////////////////////////

#COMPILE EXE
%USEMACROS = 1

#INCLUDE "win32api.inc"
#INCLUDE "pelock.inc"

GLOBAL hardware_id AS ASCIIZ * 64
GLOBAL regname AS ASCIIZ * 64

FUNCTION PBMAIN () AS LONG

    ' odczytaj identyfikator sprzetowy do bufora hardware_id
    GetHardwareId(hardware_id, 64)

    ' aby w ogole mozna bylo skorzystac z funkcji GetHardwareId()
    ' wymagane jest, zeby program zawieral chociaz jedno makro DEMO_START
    ' lub FEATURE_x_START, bez tego caly system licencyjny bedzie nieaktywny
    DEMO_START

    ' odczytaj dane zarejestrowanego uzytkownika
    GetRegistrationName(regname, 64)

    ' wyswietl dane zarejestrowanego uzytkownika
    MSGBOX "Program zarejestrowany dla " & regname

    DEMO_END

    ' wyswietl sprzetowy identyfikator w przypadku, gdy aplikacja
    ' nie jest jeszcze zarejestrowana
    IF (LEN(regname) = 0) THEN

        MSGBOX "Aplikacja niezarejestrowana, przy rejestracji prosze podac ten ID " & hardware_id

    END IF

END FUNCTION
