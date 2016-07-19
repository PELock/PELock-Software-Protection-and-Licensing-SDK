;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak odczytac dane o ograniczeniu czasowym (date wygasniecia)
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

    stExpirationDate.SYSTEMTIME
    dwTrialStatus.l = #PELOCK_TRIAL_ABSENT

    CRYPT_START

    ; odczytaj status systemu ograniczenia czasowego
    dwTrialStatus = GetExpirationDate(stExpirationDate)

    Select dwTrialStatus

    ;
    ; system ograniczenia czasowego jest aktywny
    ;
    Case #PELOCK_TRIAL_ACTIVE:

        MessageRequester("PELock", "Wersja ograniczona, data wygasniecia  " + LTrim(Str(stExpirationDate\wDay)) + "-" + LTrim(Str(stExpirationDate\wMonth)) + "-" + LTrim(Str(stExpirationDate\wYear)) )

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
