;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak uzywac makra szyfrujace DEMO_START i DEMO_END
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

    ; kod pomiedzy makrami DEMO_START i DEMO_END bedzie zaszyfrowany
    ; w zabezpieczonym pliku i nie bedzie dostepny (wykonany) bez
    ; poprawnego klucza licencyjnego
    DEMO_START

    MessageRequester("PELock", "Witaj w pelnej wersji mojej aplikacji!")

    DEMO_END
