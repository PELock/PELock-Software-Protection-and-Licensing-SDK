'///////////////////////////////////////////////////////////////////////////////
'//
'// Setting license key from external file (placed, somewhere else than
'// protected application directory)
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

    ' set license key path, this function will
    ' work only if no other key was previously
    ' set (either from file or registry)
    SetRegistrationKey("c:\key.lic")

    ' to be able to read registered user name, application
    ' should contain at least one DEMO_START or
    ' FEATURE_x_START marker
    DEMO_START

    ' get name of registered user
    GetRegistrationName(regname, 64)

    MSGBOX "Program registered to " & regname

    DEMO_END

    IF (LEN(regname) = 0) THEN

        MSGBOX "Evaluation version"

    END IF

END FUNCTION
