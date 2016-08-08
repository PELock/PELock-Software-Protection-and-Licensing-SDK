;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak ustawic wlasna procedure callback identyfikatora sprzetowego,
;// wykorzystujac makro HARDWARE_ID_CALLBACK
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
Global regname.s{#PELOCK_MAX_USERNAME}

;
; wlasna procedura callback identyfikatora sprzetowego
;
; zwracane wartosci:
;
; 1 - identyfikator sprzetowy poprawnie wygenerowany
; 0 - wystapil blad, przykladowo klucz sprzetowy nie
;     byl obecny), nalezy zauwazyc, ze w tej sytuacji
;     wszystkie wywolania do GetHardwareId() oraz
;     procedur ustawiajacych badz przeladowujacych klucz
;     zablokowany na sprzetowy identyfikator nie beda
;     funkcjonowaly (beda zwracane kody bledow)
;
Procedure custom_hardware_id(*output)

    ' ten marker bedzie uzyty do zlokalizowania procedury custom_hardware_id()
    ' (nalezy wczesniej wlaczyc odpowiednia opcje w zakladce SDK)
    HARDWARE_ID_CALLBACK

    ;
    ; kopiuj wlasny identyfikator sprzetowy do wyjsciowego bufora (8 bajtow)
    ;
    ; identyfikator sprzetowy moze byc utworzony z:
    ;
    ; - identyfikatora klucza sprzetowego (dongle)
    ; - informacji z systemu operacyjnego
    ; - etc.
    ;
    For i.l = 0 To 7

      PokeB(*output + i, i + 1)

    Next

    ; zwroc 1, co oznacza sukces
    ProcedureReturn 1

EndProcedure

; start

    ; odczytaj identyfikator sprzetowy do bufora hardware_id
    GetHardwareId(hardware_id, SizeOf(hardware_id))

    ; aby w ogole mozna bylo skorzystac z funkcji GetHardwareId()
    ; wymagane jest, zeby program zawieral chociaz jedno makro DEMO_START
    ; lub FEATURE_x_START, bez tego caly system licencyjny bedzie nieaktywny
    DEMO_START

    ; odczytaj dane zarejestrowanego uzytkownika
    GetRegistrationName(regname, SizeOf(regname))

    ; wyswietl dane zarejestrowanego uzytkownika
    MessageRequester("PELock", "Program zarejestrowany dla " + regname)

    DEMO_END

    ; wyswietl sprzetowy identyfikator w przypadku, gdy aplikacja
    ; nie jest jeszcze zarejestrowana
    If (Len(regname) = 0)

        SetClipboardText(hardware_id)

        MessageRequester("PELock", "Aplikacja niezarejestrowana, przy rejestracji prosze podac ten ID " + hardware_id + " (skopiowano do schowka)")

    EndIf

    ; ochrona przed optymalizacja kompilatora (zeby nie usunal nieuzywanych funkcji)
    If (@custom_hardware_id() = 0)
        custom_hardware_id(0)
    EndIf
