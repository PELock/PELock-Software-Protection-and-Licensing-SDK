;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad wykorzystania makr szyfrujacych FILE_CRYPT_START i FILE_CRYPT_END
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

    ; kod pomiedzy makrami FILE_CRYPT_START i FILE_CRYPT_END bedzie zaszyfrowany
    ; w zabezpieczonym pliku (jako klucz szyfrujacy uzyty jest dowolny plik)
    FILE_CRYPT_START

    MessageRequester("PELock", "Witaj swiecie!")

    FILE_CRYPT_END
