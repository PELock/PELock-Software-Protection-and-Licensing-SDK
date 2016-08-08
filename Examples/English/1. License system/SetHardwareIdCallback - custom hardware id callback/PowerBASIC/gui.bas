'///////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to set custom hardware id callback routine
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

GLOBAL regname AS ASCIIZ * %PELOCK_MAX_HARDWARE_ID
GLOBAL regname AS ASCIIZ * %PELOCK_MAX_USERNAME

'
' custom hardware id callback
'
' return values:
'
' 1 - hardware identifier successfully generated
' 0 - an error occured, for example when dongle key was
'     not present), please note that any further calls to
'     GetHardwareId() or functions to set/reload
'     registration key locked to hardware id will fail
'     in this case (error codes will be returned)
'
FUNCTION CUSTOM_HARDWARE_ID SDECL (BYVAL hardware_id AS BYTE PTR) AS DWORD

    '
    ' copy custom hardware identifier to output buffer (8 raw bytes)
    '
    ' you can create custome hardware identifier from:
    '
    ' - dongle (hardware key) hardware identifier
    ' - operating system information
    ' - etc.
    '
    FOR i% = 0 TO 7

        @hardware_id[i%] = i% + 1

    NEXT

    ' return 1 to indicate success
    FUNCTION = 1

END FUNCTION

FUNCTION PBMAIN () AS LONG

    ' set our own hardware id callback routine (you need to enable
    ' proper option in SDK tab)
    SetHardwareIdCallback(CUSTOM_HARDWARE_ID)

    ' reload registration key (from default locations)
    ReloadRegistrationKey

    ' read hardware id
    GetHardwareId(hardware_id, SIZEOF(hardware_id))

    ' to be able to read hardware id, application should contain at least one
    ' DEMO_START or FEATURE_x_START marker
    DEMO_START

    ' get name of registered user
    GetRegistrationName(regname, SIZEOF(regname))

    ' print registered user name
    MSGBOX "Program registered to " & regname

    DEMO_END

    ' display hardware ID in case of unregistered version
    IF (LEN(regname) = 0) THEN

        MSGBOX "Evaluation version, please provide this ID " & hardware_id

    END IF

END FUNCTION
