'///////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to read key creation date
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

    ' to be able to read key creation date, program should
    ' contain at least one DEMO_START & DEMO_END marker
    DEMO_START

    ' read key createion date (if it was set)
    ' key creation date is read into a SYSTEMTIME structure
    ' and only day/month/years fields are set
    IF (GetKeyCreationDate(stSysTime) = 1) THEN

        MSGBOX "Key creation date " & LTRIM$(STR$(stSysTime.wDay)) & "-" _
                                    & LTRIM$(STR$(stSysTime.wMonth)) & "-" _
                                    & LTRIM$(STR$(stSysTime.wYear))

    ELSE

        MSGBOX "This key doesn't have creation date set."

    END IF


    DEMO_END

END FUNCTION
