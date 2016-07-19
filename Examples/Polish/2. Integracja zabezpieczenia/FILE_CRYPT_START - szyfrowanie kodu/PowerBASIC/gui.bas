'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad wykorzystania makr szyfrujacych FILE_CRYPT_START i FILE_CRYPT_END
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

    ' kod pomiedzy makrami FILE_CRYPT_START i FILE_CRYPT_END bedzie zaszyfrowany
    ' w zabezpieczonym pliku (jako klucz szyfrujacy uzyty jest dowolny plik)
    FILE_CRYPT_START

    MSGBOX "Witaj swiecie!"

    FILE_CRYPT_END


END FUNCTION
