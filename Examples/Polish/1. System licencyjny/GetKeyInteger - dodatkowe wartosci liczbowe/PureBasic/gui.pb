;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak odczytac dodatkowe wartosci liczbowe klucza licencyjnego
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

    nNumberOfItems.l = 0

    ; kod pomiedzy markerami DEMO_START i DEMO_END bedzie zaszyfrowany
    ; w zabezpieczonym pliku i nie bedzie dostepny bez poprawnego klucza
    DEMO_START

    MessageRequester("PELock", "To wersja oprogramowania jest zarejestrowana!")

    ; odczytaj wartosc liczbowa zapisana w kluczu, PELock oferuje 16 indywidualnie ustawianych
    ; wartosci, ktore moga byc uzyte jak tylko chcesz
    nNumberOfItems = GetKeyInteger(5)

    MessageRequester("PELock", "Mozesz zapisac maksymalnie " + Str(nNumberOfItems) + " elementow w bazie danych")

    DEMO_END
