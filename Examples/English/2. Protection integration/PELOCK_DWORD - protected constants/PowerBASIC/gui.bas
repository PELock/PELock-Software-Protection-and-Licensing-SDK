'///////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to use PELock's protected constants
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

    DIM i AS DWORD, x AS DWORD, y AS DWORD
    DIM int_array(5) AS DWORD

    i = 0
    x = 0
    y = 5

    ' you can use PELOCK_DWORD() wherever you want, it will
    ' always return provided constant value
    FOR i = 0 TO PELOCK_DWORD(3)

        MSGBOX STR$(i)

    NEXT

    ' use PELOCK_SIZEOF (its using PELOCK_DWORD to protect the value) instead of sizeof keyword
    MSGBOX "sizeof(i) =" & STR$(PELOCK_SIZEOF(i))

    ' use it in calculations
    x = (1024 * y) + PELOCK_DWORD(&HFFFFFFFF)

    ' use it in WinApi calls with other constant values
    MessageBox(BYVAL %NULL, "PELock's protected constants", "Hello world :)", PELOCK_DWORD( %MB_ICONINFORMATION ) )

    ' use it to initialize array items
    int_array(0) = PELOCK_DWORD(0)
    int_array(1) = PELOCK_DWORD(&HFF) + 100


END FUNCTION
