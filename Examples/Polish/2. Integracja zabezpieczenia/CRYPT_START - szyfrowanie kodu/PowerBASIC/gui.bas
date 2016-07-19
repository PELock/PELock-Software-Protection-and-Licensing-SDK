'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad wykorzystania makr szyfrujacych CRYPT_START i CRYPT_END
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

    ' kod pomiedzy makrami CRYPT_START i CRYPT_END bedzie zaszyfrowany
    ' w zabezpieczonym pliku
    CRYPT_START

    MSGBOX "Witaj swiecie!"

    CRYPT_END

END FUNCTION
