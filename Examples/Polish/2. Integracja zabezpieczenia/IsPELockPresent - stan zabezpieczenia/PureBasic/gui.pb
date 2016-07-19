;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak sprawdzic obecnosc zabezpieczenia PELock'a
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

    ; jesli zabezpieczysz aplikacje, procedury sprawdzajace
    ; obecnosc zabezpieczenia ZAWSZE beda zwracaly wartosc TRUE,
    ; w przeciwym wypadku oznaczaloby to, ze zabezpieczenie
    ; zostalo usuniete z pliku przez jego zlamanie/rozpakowanie
    ; i mozesz (powinienes), zrobic jedna z ponizszych rzeczy:
    ;
    ; - zamknij aplikacje (kiedy nie jest to spodziewane,
    ;   skorzystaj z procedur timera)
    ; - uszkodz jakis obszar pamieci
    ; - zainicjalizuj jakies zmienne blednymi wartosciami
    ; - wywolaj wyjatki (RaiseException())
    ; - spowoduj blad w obliczeniach (jest to bardzo trudne
    ;   do wysledzenia dla osoby, ktora probuje zlamac aplikacje,
    ;   jesli taka nie do konca zlamana aplikacja zostanie
    ;   opublikowana i tak nie bedzie dzialac poprawnie)
    ;
    ; - NIE WYSWIETLAJ ZADNYCH INFORMACJI, ZE ZABEZPIECZENIE
    ;   ZOSTALO USUNIETE, JEST TO NAJGORSZA RZECZ, KTORA
    ;   MOZNA ZROBIC, GDYZ POZWALA TO ZNALEZC ODWOLANIA
    ;   DO FUNKCJI SPRAWDZAJACYCH I TYM SAMYM ICH USUNIECIE
    ;
    ; uzyj wyobrazni :)

    MessageRequester("PELock", "Sprawdzanie obecnosci zabezpieczenia PELock'a")

    If (IsPELockPresent1() = #True)

        MessageRequester("PELock", "1 metoda - PELock wykryty")

    Else

        MessageRequester("PELock", "1 metoda - zabezpiecenie PELock'a nie zostalo wykryte!")

    EndIf

    If (IsPELockPresent2() = #True)

        MessageRequester("PELock", "2 metoda - PELock wykryty")

    Else

        MessageRequester("PELock", "2 metoda - zabezpiecenie PELock'a nie zostalo wykryte!")

    EndIf

    If (IsPELockPresent3() = #True)

        MessageRequester("PELock", "3 metoda - PELock wykryty")

    Else

        MessageRequester("PELock", "3 metoda - zabezpiecenie PELock'a nie zostalo wykryte!")

    EndIf

    If (IsPELockPresent4() = #True)

        MessageRequester("PELock", "4 metoda - PELock wykryty")

    Else

        MessageRequester("PELock", "4 metoda - zabezpiecenie PELock'a nie zostalo wykryte!")

    EndIf

    If (IsPELockPresent5() = #True)

        MessageRequester("PELock", "5 metoda - PELock wykryty")

    Else

        MessageRequester("PELock", "5 metoda - zabezpiecenie PELock'a nie zostalo wykryte!")

    EndIf

    If (IsPELockPresent6() = #True)

        MessageRequester("PELock", "6 metoda - PELock wykryty")

    Else

        MessageRequester("PELock", "6 metoda - zabezpiecenie PELock'a nie zostalo wykryte!")

    EndIf

    If (IsPELockPresent7() = #True)

        MessageRequester("PELock", "7 metoda - PELock wykryty")

    Else

        MessageRequester("PELock", "7 metoda - zabezpiecenie PELock'a nie zostalo wykryte!")

    EndIf

    If (IsPELockPresent8() = #True)

        MessageRequester("PELock", "8 metoda - PELock wykryty")

    Else

        MessageRequester("PELock", "8 metoda - zabezpiecenie PELock'a nie zostalo wykryte!")

    EndIf
