'///////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to read key running time
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

GLOBAL stRunTime AS SYSTEMTIME

FUNCTION PBMAIN () AS LONG

    ' to be able to read key running time, program should
    ' contain at least one DEMO_START & DEMO_END marker
    DEMO_START

    ' delay
    SLEEP 2000

    IF (GetKeyRunningTime(stRunTime) = 1) THEN

        MSGBOX "Key running time " & LTRIM$(STR$(stRunTime.wHour)) & " hours " _
                                   & LTRIM$(STR$(stRunTime.wMinute)) & " minutes " _
                                   & LTRIM$(STR$(stRunTime.wSecond)) & " seconds "

    ELSE

        MSGBOX "Cannot read key running time!"

    END IF


    DEMO_END

END FUNCTION
