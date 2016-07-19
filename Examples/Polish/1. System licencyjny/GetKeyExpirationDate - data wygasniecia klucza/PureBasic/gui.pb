;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak odczytac date wygasniecia klucza (o ile byla ustawiona)
;//
;// Wersja         : PELock v2.0
;// Jezyk          : PureBasic
;// Autor          : Bartosz Wójcik (support@pelock.com)
;// Strona domowa  : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\Polish\PureBasic\"
XIncludeFile "pelock.pb"

Global stSysTime.SYSTEMTIME

; start

    ; aby moc odczytac date wygasniecia klucza licencyjnego potrzebny
    ; wymagane jest umieszczenie w programie chociaz jednego makra
    ; DEMO_START lub FEATURE_x_START, bez tego system licencyjny nie
    ; bedzie w ogole dostepny
    DEMO_START

    ; odczytaj date wygasniecia klucza (jesli byla w ogole ustawiona)
    ; dane sa odczytywane do struktury SYSTEMTIME i wykorzystane sa
    ; tylko pola dzien/miesiac/rok
    If (GetKeyCreationDate(stSysTime) = 1)

        MessageRequester("PELock", "Data wygasniecia klucza " + LTrim(Str(stSysTime\wDay)) + "-" + LTrim(Str(stSysTime\wMonth)) + "-" + LTrim(Str(stSysTime\wYear)) )

    Else

        MessageRequester("PELock", "To jest pelna wersja programu bez ograniczen czasowych.")

    EndIf


    DEMO_END
