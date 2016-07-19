;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak uzywac makra szyfrujace UNREGISTERED_START i UNREGISTERED_END
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

    ; wyswietl komunikat w niezarejestrowanej wersji programu
    ;
    ; nalezy umiescic przynajmniej jedno makro DEMO_START lub FEATURE_x_START,
    ; aby mozna bylo skorzystac z makr UNREGISTERED_START
    UNREGISTERED_START

    MessageRequester("PELock", "To jest wersja niezarejestrowana, prosze zakupic pelna wersje!")

    UNREGISTERED_END

    ; kod pomiedzy makrami DEMO_START i DEMO_END bedzie zaszyfrowany
    ; w zabezpieczonym pliku i nie bedzie dostepny (wykonany) bez
    ; poprawnego klucza licencyjnego
    DEMO_START

    MessageRequester("PELock", "Witaj w pelnej wersji mojej aplikacji!")

    DEMO_END
