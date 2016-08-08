'///////////////////////////////////////////////////////////////////////////////
'//
'// Setting license key from external file (placed, somewhere else than
'// protected application directory)
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

    DIM regname AS ASCIIZ * %PELOCK_MAX_USERNAME
    DIM keydata AS STRING
    DIM keysize AS LONG
    DIM keyfile AS LONG
    DIM dwStatus AS LONG

    ' default value
    regname = "Evaluation version"

    ' open keyfile
    OPEN "C:\key.lic" FOR BINARY AS keyfile

    ' keyfile size (current file position)
    keysize = LOF(keyfile)

    ' check key size
    IF (keysize <> 0) THEN

        GET$ keyfile, keysize, keydata

        ' set license data
        dwStatus = SetRegistrationData(keydata, keysize)

    END IF

    ' close file handle
    CLOSE keyfile


    ' read registration name
    IF (dwStatus = 1) THEN

        DEMO_START

        ' get registered user name
        GetRegistrationName(regname, SIZEOF(regname))

        DEMO_END

    END IF

    ' show registered user name
    MSGBOX "Registered to " & regname

END FUNCTION
