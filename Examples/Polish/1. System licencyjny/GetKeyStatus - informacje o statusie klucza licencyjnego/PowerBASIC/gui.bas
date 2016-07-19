'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad jak odczytac informacje o statusie klucza licencyjnego
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

FUNCTION PBMAIN () AS LONG

    DIM dwKeyStatus AS DWORD

    dwKeyStatus = %PELOCK_KEY_NOT_FOUND

    ' odczytaj informacje o statusie klucza licencyjnego
    dwKeyStatus = GetKeyStatus()

    SELECT CASE dwKeyStatus

    '
    ' klucz jest poprawny (wiec kod pomiedzy DEMO_START i DEMO_END powinien sie wykonac)
    '
    CASE %PELOCK_KEY_OK:

        DEMO_START

        MSGBOX "Klucz licencyjny jest poprawny."

        DEMO_END

    '
    ' niepoprawny format klucza licencyjnego (uszkodzony)
    '
    CASE %PELOCK_KEY_INVALID:

        MSGBOX "Klucz licencyjny jest niepoprawny (uszkodzony)!"

    '
    ' klucz znajduje sie na liscie kluczy zablokowanych (kradzionych)
    '
    CASE %PELOCK_KEY_STOLEN:

        MSGBOX "Klucz jest zablokowany!"

    '
    ' komputer posiada inny identyfikator sprzetowy niz ten uzyty do zabezpieczenia klucza
    '
    CASE %PELOCK_KEY_WRONG_HWID:

        MSGBOX "Identyfikator sprzetowy tego komputera nie pasuje do klucza licencyjnego!"

    '
    ' klucz licencyjny jest wygasniety (nieaktywny)
    '
    CASE %PELOCK_KEY_EXPIRED:

        MSGBOX "Klucz licencyjny jest wygasniety!"

    '
    ' nie znaleziono klucza licencyjnego
    '
    CASE ELSE ' wlaczajac %PELOCK_KEY_NOT_FOUND

        MSGBOX "Nie znaleziono klucza licencyjnego."

    END SELECT

END FUNCTION
