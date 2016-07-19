;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak odczytac date utworzenia klucza (o ile byla ustawiona)
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

    ; aby moc odczytac date utworzenia klucza licencyjnego
    ; wymagane jest umieszczenie w programie chociaz jednego makra
    ; DEMO_START lub FEATURE_x_START, bez tego system licencyjny nie
    ; bedzie w ogole dostepny
    DEMO_START

    ; odczytaj date utworzenia klucza (jesli byla w ogole ustawiona)
    ; dane sa odczytywane do struktury SYSTEMTIME i wykorzystane sa
    ; tylko pola dzien/miesiac/rok
    If (GetKeyCreationDate(stSysTime) = 1)

        MessageRequester("PELock", "Data utworzenia klucza " + LTrim(Str(stSysTime\wDay)) + "-" + LTrim(Str(stSysTime\wMonth)) + "-" + LTrim(Str(stSysTime\wYear)) )

    Else

        MessageRequester("PELock", "Klucz nie posiada zapisanej daty utworzenia.")

    EndIf


    DEMO_END
