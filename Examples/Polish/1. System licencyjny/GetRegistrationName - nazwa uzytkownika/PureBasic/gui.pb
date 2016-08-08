;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak uzywac makra szyfrujace DEMO_START i DEMO_END
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

    ; sprawdz, czy w ogole zostaly odczytane jakies dane uzytkownika
    ; sprawdz dlugosc nazwy uzytkownika (0 - brak klucza licencyjnego)
    If (Len(regname) = 0)

        MessageRequester("PELock", "Aplikacja nie jest zarejestrowana!")

    EndIf
