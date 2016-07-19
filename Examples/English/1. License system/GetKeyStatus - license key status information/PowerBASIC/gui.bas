;////////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to read license key status information
;//
;// Version        : PELock v2.0
;// Language       : PowerBASIC
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;////////////////////////////////////////////////////////////////////////////////

#COMPILE EXE
%USEMACROS = 1

#INCLUDE "win32api.inc"
#INCLUDE "pelock.inc"

FUNCTION PBMAIN () AS LONG

    DIM dwKeyStatus AS DWORD

    dwKeyStatus = %PELOCK_KEY_NOT_FOUND

    ' read license key status information
    dwKeyStatus = GetKeyStatus()

    SELECT CASE dwKeyStatus

    '
    ' key is valid (so the code between DEMO_START and DEMO_END should be executed)
    '
    CASE %PELOCK_KEY_OK:

        DEMO_START

        MSGBOX "License key is valid."

        DEMO_END

    '
    ' invalid format of the key (corrupted)
    '
    CASE %PELOCK_KEY_INVALID:

        MSGBOX "License key is invalid (corrupted)!"

    '
    ' license key was on the blocked keys list (stolen)
    '
    CASE %PELOCK_KEY_STOLEN:

        MSGBOX "License key is blocked!"

    '
    ' hardware identifier is different from the one used to encrypt license key
    '
    CASE %PELOCK_KEY_WRONG_HWID:

        MSGBOX "Hardware identifier doesn't match to the license key!"

    '
    ' license key is expired (not active)
    '
    CASE %PELOCK_KEY_EXPIRED:

        MSGBOX "License key is expired!"

    '
    ' license key not found
    '
    CASE ELSE ' including %PELOCK_KEY_NOT_FOUND

        MSGBOX "License key not found."

    END SELECT

END FUNCTION
