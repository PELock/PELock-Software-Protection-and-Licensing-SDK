'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad jak ustawic wlasna procedure callback identyfikatora sprzetowego,
'// wykorzystujac makro HARDWARE_ID_CALLBACK
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

GLOBAL hardware_id AS ASCIIZ * 64
GLOBAL regname AS ASCIIZ * 64

'
' wlasna procedura callback identyfikatora sprzetowego
'
' zwracane wartosci:
'
' 1 - identyfikator sprzetowy poprawnie wygenerowany
' 0 - wystapil blad, przykladowo klucz sprzetowy nie
'     byl obecny), nalezy zauwazyc, ze w tej sytuacji
'     wszystkie wywolania do GetHardwareId() oraz
'     procedur ustawiajacych badz przeladowujacych klucz
'     zablokowany na sprzetowy identyfikator nie beda
'     funkcjonowaly (beda zwracane kody bledow)
'
FUNCTION CUSTOM_HARDWARE_ID SDECL (BYVAL hardware_id AS BYTE PTR) AS DWORD

    ' ten marker bedzie uzyty do zlokalizowania procedury CUSTOM_HARDWARE_ID()
    ' (nalezy wczesniej wlaczyc odpowiednia opcje w zakladce SDK)
    HARDWARE_ID_CALLBACK

    '
    ' kopiuj wlasny identyfikator sprzetowy do wyjsciowego bufora (8 bajtow)
    '
    ' identyfikator sprzetowy moze byc utworzony z:
    '
    ' - identyfikatora klucza sprzetowego (dongle)
    ' - informacji z systemu operacyjnego
    ' - etc.
    '
    FOR i% = 0 TO 7

        @hardware_id[i%] = i% + 1

    NEXT

    ' zwroc 1, co oznacza sukces
    FUNCTION = 1

END FUNCTION

FUNCTION PBMAIN () AS LONG

    ' odczytaj identyfikator sprzetowy do bufora hardware_id
    GetHardwareId(hardware_id, 64)

    ' aby w ogole mozna bylo skorzystac z funkcji GetHardwareId()
    ' wymagane jest, zeby program zawieral chociaz jedno makro DEMO_START
    ' lub FEATURE_x_START, bez tego caly system licencyjny bedzie nieaktywny
    DEMO_START

    ' odczytaj dane zarejestrowanego uzytkownika
    GetRegistrationName(regname, 64)

    ' wyswietl dane zarejestrowanego uzytkownika
    MSGBOX "Program zarejestrowany dla " & regname

    DEMO_END

    ' wyswietl sprzetowy identyfikator w przypadku, gdy aplikacja
    ' nie jest jeszcze zarejestrowana
    IF (LEN(regname) = 0) THEN

        MSGBOX "Aplikacja niezarejestrowana, przy rejestracji prosze podac ten ID " & hardware_id

    END IF

END FUNCTION
