'///////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to read registered user name from the license key
'//
'// Version        : PELock v2.0
'// Language       : PowerBASIC
'// Author         : Bartosz Wójcik (support@pelock.com)
'// Web page       : https://www.pelock.com
'//
'///////////////////////////////////////////////////////////////////////////////

#COMPILE EXE
%USEMACROS = 1

#INCLUDE "win32api.inc"
#INCLUDE "pelock.inc"

GLOBAL regname AS ASCIIZ * %PELOCK_MAX_USERNAME

FUNCTION PBMAIN () AS LONG

    DEMO_START

    ' read registered user name
    GetRegistrationName(regname, SIZEOF(regname))

    MSGBOX "Program registered to " & regname

    DEMO_END

    ' check registered user name length (0 - key not present)
    IF (LEN(regname) = 0) THEN

        MSGBOX "Evaluation version"

    END IF

END FUNCTION
