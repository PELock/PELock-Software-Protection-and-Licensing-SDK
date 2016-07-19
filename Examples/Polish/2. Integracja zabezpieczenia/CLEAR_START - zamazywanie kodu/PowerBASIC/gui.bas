'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad wykorzystania makr zamazujacych kod CLEAR_START i CLEAR_END
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

GLOBAL i AS LONG
GLOBAL j AS LONG

SUB initialize_app()

    ' kod pomiedzy makrami CLEAR_START i CLEAR_END bedzie zaszyfrowany
    ' w zabezpieczonym pliku, po wykonaniu tego kodu, zostanie on
    ' zamazany w pamieci, ponowna proba wykonania kodu, spowoduje
    ' ze zostanie on ominiety (tak jakby go tam nie bylo)
    CLEAR_START

    i = 1
    j = 2

    CLEAR_END

END SUB

FUNCTION PBMAIN () AS LONG

    ' inicjalizuj aplikacje
    initialize_app

    ' kod pomiedzy markerami CRYPT_START i CRYPT_END bedzie zaszyfrowany
    ' w zabezpieczonym pliku
    CRYPT_START

    MSGBOX "Witaj swiecie!"

    CRYPT_END

END FUNCTION
