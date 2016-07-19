'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad jak uzywac makra szyfrujace DEMO_START i DEMO_END
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

    ' kod pomiedzy makrami DEMO_START i DEMO_END bedzie zaszyfrowany
    ' w zabezpieczonym pliku i nie bedzie dostepny (wykonany) bez
    ' poprawnego klucza licencyjnego
    DEMO_START

    MSGBOX "Witaj w pelnej wersji mojej aplikacji!"

    DEMO_END

END FUNCTION
