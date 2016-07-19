'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad jak odczytac czas wykorzystania klucza
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

GLOBAL stRunTime AS SYSTEMTIME

FUNCTION PBMAIN () AS LONG

    ' aby moc odczytac czas wykorzystania klucza licencyjnego potrzebny
    ' wymagane jest umieszczenie w programie chociaz jednego makra
    ' DEMO_START lub FEATURE_x_START, bez tego system licencyjny nie
    ' bedzie w ogole dostepny
    DEMO_START

    ' opoznienie
    SLEEP 2000

    IF (GetKeyRunningTime(stRunTime) = 1) THEN

        MSGBOX "Czas wykorzystania klucza " & LTRIM$(STR$(stRunTime.wHour)) & " godzin " _
                                            & LTRIM$(STR$(stRunTime.wMinute)) & " minut " _
                                            & LTRIM$(STR$(stRunTime.wSecond)) & " sekund "

    ELSE

        MSGBOX "To jest pelna wersja programu bez ograniczen czasowych."

    END IF


    DEMO_END

END FUNCTION
