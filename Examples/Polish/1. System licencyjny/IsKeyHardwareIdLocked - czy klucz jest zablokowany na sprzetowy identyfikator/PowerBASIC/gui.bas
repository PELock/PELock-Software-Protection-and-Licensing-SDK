'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad jak sprawdzic czy klucz jest zablokowany na sprzetowy identyfikator
'//
'// Wersja         : PELock v2.09
'// Jezyk          : PowerBASIC
'// Autor          : Bartosz Wójcik (support@pelock.com)
'// Strona domowa  : https://www.pelock.com
'//
'///////////////////////////////////////////////////////////////////////////////

#COMPILE EXE
%USEMACROS = 1

#INCLUDE "win32api.inc"
#INCLUDE "pelock.inc"

FUNCTION PBMAIN () AS LONG

    DEMO_START

    ; czy klucz jest zablokowany na sprzetowy identyfikator
    IF (IsKeyHardwareIdLocked = %TRUE) THEN

        MSGBOX "Ten klucz jest zablokowany na sprzetowy identyfikator!"

    ELSE

        MSGBOX "Ten klucz NIE jest zablokowany na sprzetowy identyfikator!"

    END IF

    DEMO_END

END FUNCTION
