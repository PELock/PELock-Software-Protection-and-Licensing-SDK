'///////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to use CLEAR_START and CLEAR_END macros
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

GLOBAL i AS LONG
GLOBAL j AS LONG

SUB initialize_app()

    ' code between CLEAR_START and CLEAR_END will be encrypted, and
    ' once executed it will be erased from the memory
    CLEAR_START

    i = 1
    j = 2

    CLEAR_END

END SUB

FUNCTION PBMAIN () AS LONG

    ' initialize application
    initialize_app

    ' code between CRYPT_START and CRYPT_END will be encrypted
    ' in protected file
    CRYPT_START

    MSGBOX "Hello world!"

    CRYPT_END

END FUNCTION
