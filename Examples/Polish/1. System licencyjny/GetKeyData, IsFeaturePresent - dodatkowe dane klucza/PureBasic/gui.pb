;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak skorzystac z funkcji IsFeatureEnabled()
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

    ; kod pomiedzy markerami DEMO_START i DEMO_END bedzie zaszyfrowany
    ; w zabezpieczonej aplikacji i nie bedzie dostepny bez poprawnego
    ; klucza licencyjnego
    DEMO_START

    MessageRequester("PELock", "Witaj, to jest pelna wersja oprogramowania!")

    ; sprawdz, czy 1 bit opcji klucza w ogole byl ustawiony
    If (IsFeatureEnabled(1) = #True)

        FEATURE_1_START

        MessageRequester("PELock", "To wersja rozszerzona aplikacji (np. PRO).")

        FEATURE_1_END

    EndIf

    DEMO_END
