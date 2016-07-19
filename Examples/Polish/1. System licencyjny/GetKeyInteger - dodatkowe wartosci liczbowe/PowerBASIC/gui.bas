'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad jak odczytac dodatkowe wartosci liczbowe klucza licencyjnego
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

    DIM nNumberOfItems AS LONG

    nNumberOfItems = 0

    ' kod pomiedzy markerami DEMO_START i DEMO_END bedzie zaszyfrowany
    ' w zabezpieczonym pliku i nie bedzie dostepny bez poprawnego klucza
    DEMO_START

    MSGBOX "To wersja oprogramowania jest zarejestrowana!"

    ' odczytaj wartosc liczbowa zapisana w kluczu, PELock oferuje 16 indywidualnie ustawianych
    ' wartosci, ktore moga byc uzyte jak tylko chcesz
    nNumberOfItems = GetKeyInteger(5)

    MSGBOX "Mozesz zapisac maksymalnie" & STR$(nNumberOfItems) & " elementow w bazie danych"

    DEMO_END

END FUNCTION
