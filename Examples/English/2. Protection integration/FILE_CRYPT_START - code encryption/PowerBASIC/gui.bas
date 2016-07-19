'///////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to use FILE_CRYPT_START and FILE_CRYPT_END macros
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

    ' code between FILE_CRYPT_START and FILE_CRYPT_END will be encrypted
    ' in protected file (external file is used as an encryption key)
    FILE_CRYPT_START

    MSGBOX "Hello world!"

    FILE_CRYPT_END


END FUNCTION
