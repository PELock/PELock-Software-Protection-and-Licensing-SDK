'///////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to disable registration key at runtime
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

GLOBAL regname AS ASCIIZ * 64

FUNCTION PBMAIN () AS LONG

    DEMO_START

    ' read registered user name
    GetRegistrationName(regname, 64)

    MSGBOX "Program registered to " & regname

    DEMO_END

    ' something went wrong, disable registration key
    DisableRegistrationKey(%FALSE)

    ' reset name
    regname = ""

    ' following code won't be executed after disabling
    ' license key!
    DEMO_START

    ' read registered user name
    GetRegistrationName(regname, 64)

    MSGBOX "Program registered to " & regname

    DEMO_END

    ' check registered user name length (0 - key not present)
    IF (LEN(regname) = 0) THEN
        MSGBOX "Evaluation version"
    END IF

END FUNCTION
