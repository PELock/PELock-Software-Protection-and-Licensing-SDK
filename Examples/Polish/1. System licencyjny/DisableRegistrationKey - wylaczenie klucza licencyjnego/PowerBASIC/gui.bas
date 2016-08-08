'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad jak deaktywowac klucz licencyjny w czasie dzialania aplikacji
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

GLOBAL regname AS ASCIIZ * %PELOCK_MAX_USERNAME

FUNCTION PBMAIN () AS LONG

    DEMO_START

    ' odczytaj dane zarejestrowanego uzytkownika
    GetRegistrationName(regname, SIZEOF(regname))

    MSGBOX "Program zarejestrowany na " & regname

    DEMO_END

    ' cos w miedzyczasie poszlo nie tak, zablokuj klucz licencyjny!
    DisableRegistrationKey(%FALSE)

    ' zresetuj dane zarejestrowanego uzytkownika
    regname = ""

    ' po wylaczeniu klucza, ten kod nie zostanie wykonany
    ' aplikacja bedzie sie zachowywala, tak jak gdyby nie
    ' bylo klucza i wszystkie sekcje i funkcje systemu
    ' licencyjnego beda nieaktywne
    DEMO_START

    ' odczytaj dane zarejestrowanego uzytkownika
    GetRegistrationName(regname, SIZEOF(regname))

    MSGBOX "Program zarejestrowany na " & regname

    DEMO_END

    ' sprawdz, czy w ogole zostaly odczytane jakies dane uzytkownika
    ' sprawdz dlugosc nazwy uzytkownika (0 - brak klucza licencyjnego)
    IF (LEN(regname) = 0) THEN
        MSGBOX "Aplikacja nie jest zarejestrowana!"
    END IF

END FUNCTION
