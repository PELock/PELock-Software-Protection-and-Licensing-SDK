'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad uzycia makr punktow kontrolnych PELOCK_CPUID
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

'
' wstawiaj makra PELOCK_CPUID w rzadko uzywanych procedurach
' co spowoduje, ze znalezienie tych makr bedzie bardzo trudne
' dla kogos, kto bedzie probowal zlamac zabezpieczona aplikacje
'
SUB rarely_used_procedure

    ' ukryty marker
    PELOCK_CPUID

END SUB

FUNCTION PBMAIN () AS LONG

    DIM dwImportantArray(4) AS LONG

    dwImportantArray(0) = 100

    '
    ' makra punktow kontrolnych w zaden sposob nie zaklocaja
    ' pracy aplikacji, jesli jednak ktos bedzie chcial uruchomic
    ' zlamana lub rozpakowana aplikacje, kod makra PELOCK_CPUID
    ' wywola wyjatek, tak ze zlamana/rozpakowana aplikacja nie
    ' bedzie w efekcie dzialac poprawnie (nie bedzie funkcjonalna)
    '
    PELOCK_CPUID

    '
    ' mozesz wylapac wyjatki spowodowane przez PELOCK_CPUID
    ' po usunieciu zabezpieczenia i obsluzyc ta sytuacje wedle
    ' wlasnego uznania
    '
    TRY

        PELOCK_CPUID

    CATCH

        '
        ' - zamknij aplikacje
        ' - uszkodz pamiec aplikacji
        ' - wylacz jakies kontrolki
        ' - zmien jakies wazne zmienne
        '
        ' NIE WYSWIETLAJ ZADNYCH INFORMACJI OSTRZEGAWCZYCH!!!
        '
        dwImportantArray(0) = 4

    END TRY

    MSGBOX "Wynik obliczenia 100 + 100 =" & STR$(dwImportantArray(0) + dwImportantArray(0))

END FUNCTION
