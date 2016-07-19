'///////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to read custom integer values stored in the keyfile
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

    DIM nNumberOfItems AS LONG

    nNumberOfItems = 0

    ' code between DEMO_START and DEMO_END will be encrypted
    ' in protected file and will not be available without license key
    DEMO_START

    MSGBOX "Hello world from the full version of my software!"

    ' read key integer value, you can use it however you want
    nNumberOfItems = GetKeyInteger(5)

    MSGBOX "You can store up to" & STR$(nNumberOfItems) & " items in the database"

    DEMO_END

END FUNCTION
