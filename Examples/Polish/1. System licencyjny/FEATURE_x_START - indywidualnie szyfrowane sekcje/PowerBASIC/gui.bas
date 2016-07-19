'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad jak uzyc makr szyfrujacych systemu licencyjnego FEATURE_x_START
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

FUNCTION ExtraFunctionality AS LONG

DIM result AS LONG

    ' przynajmniej jedno makro DEMO_START / DEMO_END i/lub FEATURE_x_START / FEATURE_x_END
    ' jest wymagane, aby system licencyjny byl w ogole aktywny

    ' markery szyfrujace FEATURE_x moga byc uzyte, aby umozliwic dostep tylko do niektorych
    ' opcji programu w zaleznosci od ustawien klucza licencyjnego

    ' zalecane jest umieszczanie markerow szyfrujacych bezposrednio pomiedzy klamrami
    ' warunkowymi, tutaj idealnie nadaje sie procedura IsFeatureEnabled(), ktora
    ' sprawdzi, czy odpowiedni bit opcji byl ustawiony
    IF (IsFeatureEnabled(1) = TRUE) THEN

        ' kod pomiedzy tymi markermi bedzie zaszyfrowany i nie bedzie dostepny
        ' bez poprawnego klucza licencyjnego, ani bez odpowiednio ustawionych bitow
        ' opcji zapisanych w kluczu licencyjnym
        FEATURE_1_START

        MSGBOX "Opcja 1 -> wlaczona"

        result = 1

        FEATURE_1_END

    END IF

    FUNCTION = result

END FUNCTION

FUNCTION PBMAIN () AS LONG

    ExtraFunctionality

END FUNCTION
