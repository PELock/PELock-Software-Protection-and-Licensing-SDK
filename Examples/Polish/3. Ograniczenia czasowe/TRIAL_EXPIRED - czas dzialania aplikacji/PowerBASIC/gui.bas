'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad jak wykorzystac procedure callback systemu ograniczenia czasowego
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

%IDC_LABEL = %WM_USER + 2048

GLOBAL hMainDialog AS DWORD


'
' wstaw do tej procedury kod konczacy program, zamykajacy uchwyty itp.
'
' zwracane wartosci:
'
' 1 - aplikacja zostanie zamknieta
' 0 - aplikacja bedzie dzialac, nawet mimo przekroczenia czasu testowego
'
FUNCTION TrialExpired () AS DWORD

    ' to makro musi znajdowac sie na poczatku procedury callback
    TRIAL_EXPIRED

    MessageBox(hMainDialog, "Ta aplikacja wygasla, prosze zakupic pelna wersje!", "Uwaga", %MB_ICONWARNING)

    ' mozna samemu zakonczyc aplikacje lub pozostawic to loaderowi PELock'a,
    ' aby zamknac aplikacje, zwroc wartosc 1
    ExitProcess(1)

    FUNCTION = 1

END FUNCTION

CALLBACK FUNCTION DlgProc

    SELECT CASE CBMSG

    CASE %WM_COMMAND

        IF CBCTL = %IDCANCEL THEN DIALOG END CBHNDL, 0

    END SELECT

END FUNCTION


FUNCTION PBMAIN () AS LONG

    ' utworz nowe okno dialogowe
    DIALOG NEW %NULL, "PELock Test",,, 200, 100, %WS_SYSMENU TO hMainDialog

    ' dodaj kontrolki do okna dialogowego
    CONTROL ADD LABEL, hMainDialog, %IDC_LABEL, "To jest wersja testowa!", 8, 8, 280, 14
    CONTROL ADD BUTTON, hMainDialog, %IDCANCEL, "&Zamknij", 8, 65, 50, 14

    ' wyswietl okno dialogowe
    DIALOG SHOW MODAL hMainDialog CALL DlgProc

END FUNCTION
