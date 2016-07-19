'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad jak ustawic klucz licencyjny z danych bufora pamieci
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

    DIM regname AS ASCIIZ * 64
    DIM keydata AS STRING
    DIM keysize AS LONG
    DIM keyfile AS LONG
    DIM dwStatus AS LONG

    ' domyslna wartosc
    regname = "Wersja niezarejestrowana"

    ' otworz plik zawierajacy dane licencyjne, dane
    ' moga byc zapisane gdziekolwiek, np. na kluczu
    ' sprzetowym, na dysku cd-rom itd.
    OPEN "C:\key.lic" FOR BINARY AS keyfile

    ' rozmiar pliku
    keysize = LOF(keyfile)

    ' sprawdz rozmiar pliku, gdzie sa zapisane dane licencyjne
    IF (keysize <> 0) THEN

        GET$ keyfile, keysize, keydata

        ' ustaw dane licencyjne poprzez procedure
        ' PELock'a, od tej pory wszystkie zabezpieczone
        ' fragmenty kodu makrami szyfrujacymi beda
        ' dostepne
        dwStatus = SetRegistrationData(keydata, keysize)

    END IF

    ' zamknij uchwyt pliku
    CLOSE keyfile


    ' sprawdz kod bledu z funkcji SetRegistrationKey
    IF (dwStatus = 1) THEN

        DEMO_START

        ' jesli plik zawieral poprawne dane licencyjne, odczytaj
        ' dane zarejestrowanego uzytkownika
        GetRegistrationName(regname, 64)

        DEMO_END

    END IF

    ' wyswietl informacje o rejestracji lub domyslna
    ' wiadomosc "Program niezarejestrowany"
    MSGBOX "Program zarejestrowany dla " & regname

END FUNCTION
