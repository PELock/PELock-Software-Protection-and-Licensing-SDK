'///////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to use DEMO_START and DEMO_END macros
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

GLOBAL hardware_id AS ASCIIZ * 64
GLOBAL regname AS ASCIIZ * 64

FUNCTION PBMAIN () AS LONG

    ' read hardware id
    GetHardwareId(hardware_id, 64)

    ' to be able to read hardware id, application should contain at least one
    ' DEMO_START or FEATURE_x_START marker
    DEMO_START

    ' get name of registered user
    GetRegistrationName(regname, 64)

    ' print registered user name
    MSGBOX "Program registered to " & regname

    DEMO_END

    ' display hardware ID in case of unregistered version
    IF (LEN(regname) = 0) THEN

        MSGBOX "Evaluation version, please provide this ID " & hardware_id

    END IF

END FUNCTION
