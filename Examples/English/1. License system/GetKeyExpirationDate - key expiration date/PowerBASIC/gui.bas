'///////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to read key expiration date
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

GLOBAL stSysTime AS SYSTEMTIME

FUNCTION PBMAIN () AS LONG

    ' to be able to read key expiration date, program should
    ' contain at least one DEMO_START & DEMO_END marker
    DEMO_START

    ' read key expiration date (if it was set)
    ' expiration date is read into a SYSTEMTIME structure
    ' and only day/month/years fields are set
    IF (GetKeyCreationDate(stSysTime) = 1) THEN

        MSGBOX "Key expiration date " & LTRIM$(STR$(stSysTime.wDay)) & "-" _
                                      & LTRIM$(STR$(stSysTime.wMonth)) & "-" _
                                      & LTRIM$(STR$(stSysTime.wYear))

    ELSE

        MSGBOX "This is a full version without time limits."

    END IF


    DEMO_END

END FUNCTION
