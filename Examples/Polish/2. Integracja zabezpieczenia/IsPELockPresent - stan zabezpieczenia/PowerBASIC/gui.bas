'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad jak sprawdzic obecnosc zabezpieczenia PELock'a
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

    ' jesli zabezpieczysz aplikacje, procedury sprawdzajace
    ' obecnosc zabezpieczenia ZAWSZE beda zwracaly wartosc TRUE,
    ' w przeciwym wypadku oznaczaloby to, ze zabezpieczenie
    ' zostalo usuniete z pliku przez jego zlamanie/rozpakowanie
    ' i mozesz (powinienes), zrobic jedna z ponizszych rzeczy:
    '
    ' - zamknij aplikacje (kiedy nie jest to spodziewane,
    '   skorzystaj z procedur timera)
    ' - uszkodz jakis obszar pamieci
    ' - zainicjalizuj jakies zmienne blednymi wartosciami
    ' - wywolaj wyjatki (RaiseException())
    ' - spowoduj blad w obliczeniach (jest to bardzo trudne
    '   do wysledzenia dla osoby, ktora probuje zlamac aplikacje,
    '   jesli taka nie do konca zlamana aplikacja zostanie
    '   opublikowana i tak nie bedzie dzialac poprawnie)
    '
    ' - NIE WYSWIETLAJ ZADNYCH INFORMACJI, ZE ZABEZPIECZENIE
    '   ZOSTALO USUNIETE, JEST TO NAJGORSZA RZECZ, KTORA
    '   MOZNA ZROBIC, GDYZ POZWALA TO ZNALEZC ODWOLANIA
    '   DO FUNKCJI SPRAWDZAJACYCH I TYM SAMYM ICH USUNIECIE
    '
    ' uzyj wyobrazni :)

    MSGBOX "Sprawdzanie obecnosci zabezpieczenia PELock'a"

    IF (IsPELockPresent1 = %TRUE) THEN

        MSGBOX "1 metoda - PELock wykryty"

    ELSE

        MSGBOX "1 metoda - zabezpiecenie PELock'a nie zostalo wykryte!"

    END IF

    IF (IsPELockPresent2 = %TRUE) THEN

        MSGBOX "2 metoda - PELock wykryty"

    ELSE

        MSGBOX "2 metoda - zabezpiecenie PELock'a nie zostalo wykryte!"

    END IF

    IF (IsPELockPresent3 = %TRUE) THEN

        MSGBOX "3 metoda - PELock wykryty"

    ELSE

        MSGBOX "3 metoda - zabezpiecenie PELock'a nie zostalo wykryte!"

    END IF

    IF (IsPELockPresent4 = %TRUE) THEN

        MSGBOX "4 metoda - PELock wykryty"

    ELSE

        MSGBOX "4 metoda - zabezpiecenie PELock'a nie zostalo wykryte!"

    END IF

    IF (IsPELockPresent5 = %TRUE) THEN

        MSGBOX "5 metoda - PELock wykryty"

    ELSE

        MSGBOX "5 metoda - zabezpiecenie PELock'a nie zostalo wykryte!"

    END IF

    IF (IsPELockPresent6 = %TRUE) THEN

        MSGBOX "6 metoda - PELock wykryty"

    ELSE

        MSGBOX "6 metoda - zabezpiecenie PELock'a nie zostalo wykryte!"

    END IF

    IF (IsPELockPresent7 = %TRUE) THEN

        MSGBOX "7 metoda - PELock wykryty"

    ELSE

        MSGBOX "7 metoda - zabezpiecenie PELock'a nie zostalo wykryte!"

    END IF

    IF (IsPELockPresent8 = %TRUE) THEN

        MSGBOX "8 metoda - PELock wykryty"

    ELSE

        MSGBOX "8 metoda - zabezpiecenie PELock'a nie zostalo wykryte!"

    END IF

END FUNCTION
