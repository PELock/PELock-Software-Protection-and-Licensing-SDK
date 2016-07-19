'///////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to use PELOCK_CHECKPOINT macros
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

'
' put PELOCK_CHECKPOINT macros in rarely used procedures
' so it would be harder to trace it's presence for someone
' trying to fully rebuild your protected application
'
SUB rarely_used_procedure

    ' hidden marker
    PELOCK_CHECKPOINT

END SUB

FUNCTION PBMAIN () AS LONG

    DIM dwImportantArray(4) AS LONG

    dwImportantArray(0) = 100

    '
    ' these protection checks doesn't affect your application
    ' in any way, but when someone will try to run cracked or
    ' unpacked application, PELOCK_CHECKPOINT code will cause an
    ' exception, so the cracked/unpacked application won't
    ' work correctly
    '
    PELOCK_CHECKPOINT

    '
    ' you can catch exceptions caused by PELOCK_CHECKPOINT and
    ' handle protection removal your own way
    '
    TRY

        PELOCK_CHECKPOINT

    CATCH

        '
        ' - close application
        ' - damage memory area
        ' - disable some controls
        ' - change some important variables
        '
        ' DON'T DISPLAY ANY WARNING MESSAGES!!!
        '
        dwImportantArray(0) = 4

    END TRY

    MSGBOX "Calculation result 100 + 100 =" & STR$(dwImportantArray(0) + dwImportantArray(0))

END FUNCTION
