;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak odczytac identyfikator sprzetowy
;//
;// Wersja         : PELock v2.0
;// Jezyk          : PureBasic
;// Autor          : Bartosz Wójcik (support@pelock.com)
;// Strona domowa  : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\Polish\PureBasic\"
XIncludeFile "pelock.pb"

Global hardware_id.s{64}
Global regname.s{64}

; start

    ; odczytaj identyfikator sprzetowy do bufora hardware_id
    GetHardwareId(hardware_id, 64)

    ; aby w ogole mozna bylo skorzystac z funkcji GetHardwareId()
    ; wymagane jest, zeby program zawieral chociaz jedno makro DEMO_START
    ; lub FEATURE_x_START, bez tego caly system licencyjny bedzie nieaktywny
    DEMO_START

    ; odczytaj dane zarejestrowanego uzytkownika
    GetRegistrationName(regname, 64)

    ; wyswietl dane zarejestrowanego uzytkownika
    MessageRequester("PELock", "Program zarejestrowany dla " + regname)

    DEMO_END

    ; wyswietl sprzetowy identyfikator w przypadku, gdy aplikacja
    ; nie jest jeszcze zarejestrowana
    If (Len(regname) = 0)

        SetClipboardText(hardware_id)

        MessageRequester("PELock", "Aplikacja niezarejestrowana, przy rejestracji prosze podac ten ID " + hardware_id + " (skopiowano do schowka)")

    EndIf
