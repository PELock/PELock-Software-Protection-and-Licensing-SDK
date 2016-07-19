;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak odczytac dane o ograniczeniu czasowym (okres testowy)
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

    stPeriodBegin.SYSTEMTIME
    stPeriodEnd.SYSTEMTIME
    dwTrialStatus.l = #PELOCK_TRIAL_ABSENT

    CRYPT_START

    ; odczytaj status systemu ograniczenia czasowego
    dwTrialStatus = GetTrialPeriod(stPeriodBegin, stPeriodEnd)

    Select dwTrialStatus

    ;
    ; system ograniczenia czasowego jest aktywny
    ;
    Case #PELOCK_TRIAL_ACTIVE:

        MessageRequester("PELock", "Okres dzialania dla tej aplikacji:" + Chr(13) + Chr(10) + "Poczatek okresu " + LTrim(Str(stPeriodBegin\wDay)) + "-" + LTrim(Str(stPeriodBegin\wMonth)) + "-" + LTrim(Str(stPeriodBegin\wYear)) + Chr(13) + Chr(10) + "Koniec okresu   " + LTrim(Str(stPeriodEnd\wDay)) + "-" + LTrim(Str(stPeriodEnd\wMonth)) + "-" + LTrim(Str(stPeriodEnd\wYear)) )

    ;
    ; ograniczenia czasowe nie sa wlaczone dla tej aplikacji
    ; lub aplikacja zostala zarejestrowana
    ;
    Default ; wlaczajac #PELOCK_TRIAL_ABSENT

        MessageRequester("PELock", "Brak ograniczen czasowych lub aplikacja zostala zarejestrowana.")

    EndSelect

    CRYPT_END
