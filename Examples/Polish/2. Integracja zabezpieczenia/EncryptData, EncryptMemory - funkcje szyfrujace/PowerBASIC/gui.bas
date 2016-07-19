'////////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad jak uzyc wbudowanych funkcji szyfrujacych (szyfr strumieniowy)
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

    DIM test AS STRING
    DIM test_len AS INTEGER

    DIM key AS STRING
    DIM key_len AS INTEGER

    DIM output_size AS INTEGER


    test = "Przykladowy tekst"
    test_len = LEN(test)

    key = "9876543210"
    key_len = LEN(key)

    ;
    ; Algorytm szyfrujacy jest staly i nie bedzie zmieniany
    ; w przyszlosci, wiec mozna bez obaw szyfrowac wszelkiego
    ; rodzaju dane aplikacji jak pliki konfiguracyjne, bazy danych etc.
    ;
    MSGBOX test, %MB_OK, "Niezaszyfrowany string"

    output_size = EncryptData(key, key_len, test, test_len)

    MSGBOX test, %MB_OK, "Zaszyfrowany string"

    output_size = DecryptData(key, key_len, test, test_len)

    MSGBOX test, %MB_OK, "Odszyfrowany string"


    ;
    ; Szyfruj i deszyfruj pamiec w tym samym procesie. Aplikacja
    ; uruchomiona w innym procesie nie bedzie w stanie odszyfrowac
    ; danych.
    ;
    MSGBOX test, %MB_OK, "Niezaszyfrowany string (testowanie szyfrowania bez klucza)"

    output_size = EncryptMemory(test, test_len)

    MSGBOX test, %MB_OK, "Zaszyfrowany string (szyfrowanie bez klucza)"

    output_size = DecryptMemory(test, test_len)

    MSGBOX test, %MB_OK, "Odszyfrowany string (deszyfrowania bez klucza)"

END FUNCTION
