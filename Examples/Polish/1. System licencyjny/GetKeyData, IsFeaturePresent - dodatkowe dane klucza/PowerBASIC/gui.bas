'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad jak skorzystac z funkcji IsFeatureEnabled()
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

    ' kod pomiedzy markerami DEMO_START i DEMO_END bedzie zaszyfrowany
    ' w zabezpieczonej aplikacji i nie bedzie dostepny bez poprawnego
    ' klucza licencyjnego
    DEMO_START

    MSGBOX "Witaj, to jest pelna wersja oprogramowania!"

    ' sprawdz, czy 1 bit opcji klucza w ogole byl ustawiony
    IF (IsFeatureEnabled(1) = %TRUE) THEN

        FEATURE_1_START

        MSGBOX "To wersja rozszerzona aplikacji (np. PRO)."

        FEATURE_1_END

    END IF

    DEMO_END

END FUNCTION
