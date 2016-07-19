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

FUNCTION PBMAIN () AS LONG

    ' code between DEMO_START and DEMO_END will be encrypted
    ' in protected file and will not be available without license key
    DEMO_START

    MSGBOX "Hello world from the full version of my software!"

    DEMO_END

END FUNCTION
