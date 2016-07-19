;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad ustawiania klucza licencyjnego, ktory nie znajduje
;// sie w glownym katalogu programu
;//
;// Wersja         : PELock v2.0
;// Jezyk          : PureBasic
;// Autor          : Bartosz Wójcik (support@pelock.com)
;// Strona domowa  : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\Polish\PureBasic\"
XIncludeFile "pelock.pb"

Global regname.s{64}

; start

    ; ustaw sciezke do klucza licencyjnego, funkcja zadziala
    ; tylko wtedy, gdy wczesniej nie zostal wykryty klucz
    ; licencyjny w katalogu z programem lub w rejestrze systemowym
    ;
    ; aby mozna bylo w ogole skorzystac z tej funkcji, wymagane jest,
    ; aby w programie byl umieszczony chociaz 1 marker DEMO_START
    ; lub FEATURE_x_START, bez tego caly system licencyjny
    ; bedzie nieaktywny
    SetRegistrationKey("c:\key.lic")

    ; jesli klucz licencyjny byl poprawny, bedzie mozliwe
    ; wykonanie kodu znajdujacego sie pomiedzy makrami
    DEMO_START

    ; odczytaj dane zarejestrowanego uzytkownika
    GetRegistrationName(regname, 64)

    MessageRequester("PELock", "Program zarejestrowany dla " + regname)

    DEMO_END

    If (Len(regname) = 0)

        MessageRequester("PELock", "Ta aplikacja nie jest zarejestrowana")

    EndIf
