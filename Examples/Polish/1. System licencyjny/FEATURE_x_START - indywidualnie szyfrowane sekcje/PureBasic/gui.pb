;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak uzyc makr szyfrujacych systemu licencyjnego FEATURE_x_START
;//
;// Wersja         : PELock v2.0
;// Jezyk          : PureBasic
;// Autor          : Bartosz Wójcik (support@pelock.com)
;// Strona domowa  : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\Polish\PureBasic\"
XIncludeFile "pelock.pb"

Procedure ExtraFunctionality()

    result.l = 0

    ; przynajmniej jedno makro DEMO_START / DEMO_END i/lub FEATURE_x_START / FEATURE_x_END
    ; jest wymagane, aby system licencyjny byl w ogole aktywny

    ; markery szyfrujace FEATURE_x moga byc uzyte, aby umozliwic dostep tylko do niektorych
    ; opcji programu w zaleznosci od ustawien klucza licencyjnego

    ; zalecane jest umieszczanie markerow szyfrujacych bezposrednio pomiedzy klamrami
    ; warunkowymi, tutaj idealnie nadaje sie procedura IsFeatureEnabled(), ktora
    ; sprawdzi, czy odpowiedni bit opcji byl ustawiony
    If (IsFeatureEnabled(1) = #True)

        ; kod pomiedzy tymi markermi bedzie zaszyfrowany i nie bedzie dostepny
        ; bez poprawnego klucza licencyjnego, ani bez odpowiednio ustawionych bitow
        ; opcji zapisanych w kluczu licencyjnym
        FEATURE_1_START

        MessageRequester("PELock", "Opcja 1 -> wlaczona")

        result = 1

        FEATURE_1_END

    EndIf

    ProcedureReturn result

EndProcedure

; start

    ExtraFunctionality()

