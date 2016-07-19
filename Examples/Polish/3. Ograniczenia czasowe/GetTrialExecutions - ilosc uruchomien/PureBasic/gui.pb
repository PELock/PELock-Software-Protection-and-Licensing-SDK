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

; start

    dwExecsTotal.l
    dwExecsLeft.l
    dwTrialStatus.l = #PELOCK_TRIAL_ABSENT

    CRYPT_START

    ; odczytaj status systemu ograniczenia czasowego
    dwTrialStatus = GetTrialExecutions(dwExecsTotal, dwExecsLeft)

    Select dwTrialStatus

    ;
    ; system ograniczenia czasowego jest aktywny
    ;
    Case #PELOCK_TRIAL_ACTIVE:

        MessageRequester("PELock", "Wersja ograniczona, pozostalo " + Str(dwExecsLeft) + " uruchomien z " + Str(dwExecsTotal) )

    ;
    ; okres testowy wygasl, wyswietl wlasna informacje i zamknij aplikacje
    ; kod zwracany tylko jesli bedzie wlaczona byla opcja
    ; "Pozwol aplikacji na dzialanie po wygasnieciu" w przeciwnym wypadku
    ; aplikacja jest automatycznie zamykana
    ;
    Case #PELOCK_TRIAL_EXPIRED

        MessageRequester("PELock", "Ta aplikacja wygasla i bedzie zamknieta!")

    ;
    ; ograniczenia czasowe nie sa wlaczone dla tej aplikacji
    ; lub aplikacja zostala zarejestrowana
    ;
    Default ; wlaczajac #PELOCK_TRIAL_ABSENT

        MessageRequester("PELock", "Brak ograniczen czasowych lub aplikacja zostala zarejestrowana.")

    EndSelect

    CRYPT_END
