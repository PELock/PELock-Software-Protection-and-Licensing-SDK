'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad jak odczytac date utworzenia klucza (o ile byla ustawiona)
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

GLOBAL stSysTime AS SYSTEMTIME

FUNCTION PBMAIN () AS LONG

    ' aby moc odczytac date utworzenia klucza licencyjnego
    ' wymagane jest umieszczenie w programie chociaz jednego makra
    ' DEMO_START lub FEATURE_x_START, bez tego system licencyjny nie
    ' bedzie w ogole dostepny
    DEMO_START

    ' odczytaj date utworzenia klucza (jesli byla w ogole ustawiona)
    ' dane sa odczytywane do struktury SYSTEMTIME i wykorzystane sa
    ' tylko pola dzien/miesiac/rok
    IF (GetKeyCreationDate(stSysTime) = 1) THEN

        MSGBOX "Data utworzenia klucza " & LTRIM$(STR$(stSysTime.wDay)) & "-" _
                                         & LTRIM$(STR$(stSysTime.wMonth)) & "-" _
                                         & LTRIM$(STR$(stSysTime.wYear))

    ELSE

        MSGBOX "Klucz nie posiada zapisanej daty utworzenia."

    END IF


    DEMO_END

END FUNCTION
