'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad jak odczytac dane o ograniczeniu czasowym (okres testowy)
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

    DIM stPeriodBegin AS SYSTEMTIME, stPeriodEnd AS SYSTEMTIME
    DIM dwTrialStatus AS DWORD

    dwTrialStatus = %PELOCK_TRIAL_ABSENT

    CRYPT_START

    ' odczytaj status systemu ograniczenia czasowego
    dwTrialStatus = GetTrialPeriod(stPeriodBegin, stPeriodEnd)

    SELECT CASE dwTrialStatus

    '
    ' system ograniczenia czasowego jest aktywny
    '
    CASE %PELOCK_TRIAL_ACTIVE:

        MSGBOX "Okres dzialania dla tej aplikacji:" & $CRLF & _
               "Poczatek okresu " & LTRIM$(STR$(stPeriodBegin.wDay)) & "-" & LTRIM$(STR$(stPeriodBegin.wMonth)) & "-" & LTRIM$(STR$(stPeriodBegin.wYear)) & $CRLF & _
               "Koniec okresu   " & LTRIM$(STR$(stPeriodEnd.wDay)) & "-" & LTRIM$(STR$(stPeriodEnd.wMonth)) & "-" & LTRIM$(STR$(stPeriodEnd.wYear))

    '
    ' ograniczenia czasowe nie sa wlaczone dla tej aplikacji
    ' lub aplikacja zostala zarejestrowana
    '
    CASE ELSE ' wlaczajac %PELOCK_TRIAL_ABSENT

        MSGBOX "Brak ograniczen czasowych lub aplikacja zostala zarejestrowana."

    END SELECT

    CRYPT_END

END FUNCTION
