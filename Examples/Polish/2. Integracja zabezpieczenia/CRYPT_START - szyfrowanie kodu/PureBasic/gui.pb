;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad wykorzystania makr szyfrujacych CRYPT_START i CRYPT_END
;//
;// Wersja         : PELock v2.0
;// Jezyk          : PureBasic
;// Autor          : Bartosz Wójcik (support@pelock.com)
;// Strona domowa  : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\Polish\PureBasic\"
XIncludeFile "pelock.pb"

; start

    ; kod pomiedzy makrami CRYPT_START i CRYPT_END bedzie zaszyfrowany
    ; w zabezpieczonym pliku
    CRYPT_START

    MessageRequester("PELock", "Witaj swiecie!")

    CRYPT_END
