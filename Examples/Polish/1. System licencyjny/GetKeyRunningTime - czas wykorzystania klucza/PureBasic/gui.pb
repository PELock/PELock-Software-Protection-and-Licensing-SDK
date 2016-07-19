;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak odczytac czas wykorzystania klucza
;//
;// Wersja         : PELock v2.0
;// Jezyk          : PureBasic
;// Autor          : Bartosz Wójcik (support@pelock.com)
;// Strona domowa  : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\Polish\PureBasic\"
XIncludeFile "pelock.pb"

Global stRunTime.SYSTEMTIME

; start

    ; aby moc odczytac czas wykorzystania klucza licencyjnego potrzebny
    ; wymagane jest umieszczenie w programie chociaz jednego makra
    ; DEMO_START lub FEATURE_x_START, bez tego system licencyjny nie
    ; bedzie w ogole dostepny
    DEMO_START
    
    ; opoznienie
    Delay(2000);

    If (GetKeyRunningTime(stRunTime) = 1)

        MessageRequester("PELock", "Czas wykorzystania klucza " + LTrim(Str(stRunTime\wHour)) + " godzin " + LTrim(Str(stRunTime\wMinute)) + " minut " + LTrim(Str(stRunTime\wSecond)) + " sekund." )

    Else

        MessageRequester("PELock", "Nie mozna odczytac czasu wykorzystania klucza!")

    EndIf

    DEMO_END

