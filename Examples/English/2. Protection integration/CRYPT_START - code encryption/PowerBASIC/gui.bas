'///////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to use CRYPT_START and CRYPT_END macros
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

    ' code between CRYPT_START and CRYPT_END will be encrypted
    ' in protected file
    CRYPT_START

    MSGBOX "Hello world!"

    CRYPT_END

END FUNCTION
