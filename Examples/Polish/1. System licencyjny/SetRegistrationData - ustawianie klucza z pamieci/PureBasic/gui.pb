;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak ustawic klucz licencyjny z danych bufora pamieci
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

    regname.s{#PELOCK_MAX_USERNAME}
    keysize.l
    dwStatus.l


    ; domyslna wartosc
    regname = "Wersja niezarejestrowana"

    ; otworz plik zawierajacy dane licencyjne, dane
    ; moga byc zapisane gdziekolwiek, np. na kluczu
    ; sprzetowym, na dysku cd-rom itd.
    If (ReadFile(0, "C:\key.lic") <> 0)

      ; rozmiar pliku
      keysize = Lof(0)

      ; sprawdz rozmiar pliku, gdzie sa zapisane dane licencyjne
      If (keysize <> 0)

        ; zaalokuj pamiec, gdzie odczytamy dane licencyjne
        *keydata = AllocateMemory(keysize)

        ; sprawdz, czy udalo sie zaalokowac pamiec
        If (*keydata <> #Null)

          ; read file
          If (ReadData(0, *keydata, keysize) <> 0)

            ; ustaw dane licencyjne poprzez procedure
            ; PELock'a, od tej pory wszystkie zabezpieczone
            ; fragmenty kodu makrami szyfrujacymi beda
            ; dostepne
            dwStatus = SetRegistrationData(*keydata, keysize)

          EndIf

          ; zwolnij pamiec
          FreeMemory(*keydata)

        EndIf

      EndIf

    EndIf

    ; zamknij uchwyt pliku
    CloseFile(0)

    ; sprawdz kod bledu z funkcji SetRegistrationKey
    If (dwStatus = 1)

        DEMO_START

        ; jesli plik zawieral poprawne dane licencyjne, odczytaj
        ; dane zarejestrowanego uzytkownika
        GetRegistrationName(regname, SizeOf(regname))

        DEMO_END

    EndIf

    ; wyswietl informacje o rejestracji lub domyslna
    ; wiadomosc "Program niezarejestrowany")
    MessageRequester("PELock", "Program zarejestrowany dla " + regname)
