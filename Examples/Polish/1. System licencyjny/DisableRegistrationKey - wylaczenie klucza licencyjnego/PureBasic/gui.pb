;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak deaktywowac klucz licencyjny w czasie dzialania aplikacji
;//
;// Wersja         : PELock v2.0
;// Jezyk          : PureBasic
;// Autor          : Bartosz Wójcik (support@pelock.com)
;// Strona domowa  : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\Polish\PureBasic\"
XIncludeFile "pelock.pb"

Global regname.s{#PELOCK_MAX_USERNAME}

; start

    DEMO_START

    ; odczytaj dane zarejestrowanego uzytkownika
    GetRegistrationName(regname, SizeOf(regname))

    MessageRequester("PELock", "Program zarejestrowany na " + regname)

    DEMO_END

    ; cos w miedzyczasie poszlo nie tak, zablokuj klucz licencyjny!
    DisableRegistrationKey(#False)

    ; zresetuj dane zarejestrowanego uzytkownika
    regname = ""

    ; po wylaczeniu klucza, ten kod nie zostanie wykonany
    ; aplikacja bedzie sie zachowywala, tak jak gdyby nie
    ; bylo klucza i wszystkie sekcje i funkcje systemu
    ; licencyjnego beda nieaktywne
    DEMO_START

    ; odczytaj dane zarejestrowanego uzytkownika
    GetRegistrationName(regname, SizeOf(regname))

    MessageRequester("PELock", "Program zarejestrowany na " + regname)

    DEMO_END

    ; sprawdz, czy w ogole zostaly odczytane jakies dane uzytkownika
    ; sprawdz dlugosc nazwy uzytkownika (0 - brak klucza licencyjnego)
    If (Len(regname) = 0)
        MessageRequester("PELock", "Aplikacja nie jest zarejestrowana!")
    EndIf
