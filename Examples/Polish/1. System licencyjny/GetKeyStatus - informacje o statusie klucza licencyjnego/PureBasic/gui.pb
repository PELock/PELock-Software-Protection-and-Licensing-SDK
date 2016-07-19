;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak odczytac informacje o statusie klucza licencyjnego
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

    dwKeyStatus.l = #PELOCK_KEY_NOT_FOUND

    ; odczytaj informacje o statusie klucza licencyjnego
    dwKeyStatus = GetKeyStatus()

    Select dwKeyStatus

    ;
    ; klucz jest poprawny (wiec kod pomiedzy DEMO_START i DEMO_END powinien sie wykonac)
    ;
    Case #PELOCK_KEY_OK:

        DEMO_START

        MessageRequester("PELock", "Klucz licencyjny jest poprawny.")

        DEMO_START

    ;
    ; niepoprawny format klucza licencyjnego (uszkodzony)
    ;
    Case #PELOCK_KEY_INVALID:

        MessageRequester("PELock", "Klucz licencyjny jest niepoprawny (uszkodzony)!")

    ;
    ; klucz znajduje sie na liscie kluczy zablokowanych (kradzionych)
    ;
    Case #PELOCK_KEY_STOLEN:

        MessageRequester("PELock", "Klucz jest zablokowany!")

    ;
    ; komputer posiada inny identyfikator sprzetowy niz ten uzyty do zabezpieczenia klucza
    ;
    Case #PELOCK_KEY_WRONG_HWID:

        MessageRequester("PELock", "Identyfikator sprzetowy tego komputera nie pasuje do klucza licencyjnego!")

    ;
    ; klucz licencyjny jest wygasniety (nieaktywny)
    ;
    Case #PELOCK_KEY_EXPIRED:

        MessageRequester("PELock", "Klucz licencyjny jest wygasniety!")

    ;
    ; nie znaleziono klucza licencyjnego
    ;
    Default ; wlaczajac #PELOCK_KEY_NOT_FOUND

        MessageRequester("PELock", "Brak ograniczen czasowych lub aplikacja zostala zarejestrowana.")

    EndSelect
