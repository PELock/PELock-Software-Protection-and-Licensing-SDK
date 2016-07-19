;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak odczytac dane o ograniczeniu czasowym (ilosc dni)
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

    dwDaysTotal.l
    dwDaysLeft.l
    dwTrialStatus.l = #PELOCK_TRIAL_ABSENT

    CRYPT_START

    ; odczytaj status systemu ograniczenia czasowego
    dwTrialStatus = GetTrialDays(dwDaysTotal, dwDaysLeft)

    Select dwTrialStatus

    ;
    ; system ograniczenia czasowego jest aktywny
    ;
    Case #PELOCK_TRIAL_ACTIVE:

        MessageRequester("PELock", "Wersja ograniczona, pozostalo " + Str(dwDaysLeft) + " dni z " + Str(dwDaysTotal) )

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
