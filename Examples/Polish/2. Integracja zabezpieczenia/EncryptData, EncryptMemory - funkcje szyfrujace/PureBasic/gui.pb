;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak uzyc wbudowanych funkcji szyfrujacych (szyfr strumieniowy)
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

    test.s = "Przykladowy tekst"
    test_len.l = Len(test) ; lub StringByteLength dla stringow zapisanych w Unicode lub UTF-8

    key.s = "9876543210"
    key_len.l = Len(key) ; lub StringByteLength dla stringow zapisanych w Unicode lub UTF-8

    ;
    ; Algorytm szyfrujacy jest staly i nie bedzie zmieniany
    ; w przyszlosci, wiec mozna bez obaw szyfrowac wszelkiego
    ; rodzaju dane aplikacji jak pliki konfiguracyjne, bazy danych etc.
    ;
    MessageRequester("Niezaszyfrowany string", test)

    output_size = EncryptData(key, key_len, test, test_len)

    MessageRequester("Zaszyfrowany string", test)

    output_size = DecryptData(key, key_len, test, test_len)

    MessageRequester("Odszyfrowany string", test)


    ;
    ; Szyfruj i deszyfruj pamiec w tym samym procesie. Aplikacja
    ; uruchomiona w innym procesie nie bedzie w stanie odszyfrowac
    ; danych.
    ;
    MessageRequester("Niezaszyfrowany string (testowanie szyfrowania bez klucza)", test)

    output_size = EncryptMemory(test, test_len)

    MessageRequester("Zaszyfrowany string (szyfrowanie bez klucza)", test)

    output_size = DecryptMemory(test, test_len)

    MessageRequester("Odszyfrowany string (deszyfrowania bez klucza)", test)
