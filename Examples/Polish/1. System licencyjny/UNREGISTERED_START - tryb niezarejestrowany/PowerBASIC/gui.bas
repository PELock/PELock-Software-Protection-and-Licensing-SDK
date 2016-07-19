'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad jak uzywac makra szyfrujace UNREGISTERED_START i UNREGISTERED_END
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

    ' wyswietl komunikat w niezarejestrowanej wersji programu
    '
    ' nalezy umiescic przynajmniej jedno makro DEMO_START lub FEATURE_x_START,
    ' aby mozna bylo skorzystac z makr UNREGISTERED_START
    UNREGISTERED_START

    MSGBOX "To jest wersja niezarejestrowana, prosze zakupic pelna wersje!"

    UNREGISTERED_END

    ' kod pomiedzy makrami DEMO_START i DEMO_END bedzie zaszyfrowany
    ' w zabezpieczonym pliku i nie bedzie dostepny (wykonany) bez
    ' poprawnego klucza licencyjnego
    DEMO_START

    MSGBOX "Witaj w pelnej wersji mojej aplikacji!"

    DEMO_END

END FUNCTION
