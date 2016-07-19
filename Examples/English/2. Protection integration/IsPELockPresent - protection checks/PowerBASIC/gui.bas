'///////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to check PELock protection presence
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

    ' protection checks will always return TRUE for the
    ' protected application, otherwise (unprotected application
    ' or cracked) it will return FALSE and you can (or should)
    ' do one of the following things:
    '
    ' - close the application (when it's not expected, use
    '   timers or background threads to perform the checks)
    ' - corrupt memory buffers
    ' - initialize important variables with wrong values
    ' - invoke exceptions (RaiseException())
    ' - perform incorrect calculations (it it very hard to detect
    '   for the person who is trying to crack the application,
    '   if he doesn't remove all the checks and the application
    '   will be released, it won't work correctly)
    '
    ' - DO NOT DISPLAY ANY WARNINGS THAT THE PROTECTION WAS
    '   REMOVED, THIS IS THE WORSE THING YOU CAN DO, BECAUSE
    '   IT CAN BE EASILY TRACED AND USED TO REMOVE THE
    '   PROTECTION CHECKS
    '
    ' use your imagination :)
    MSGBOX "Detect PELock protection presence:"

    IF (IsPELockPresent1 = %TRUE) THEN

        MSGBOX "1st method - PELock detected"

    ELSE

        MSGBOX "1st method - PELock protection not found!"

    END IF

    IF (IsPELockPresent2 = %TRUE) THEN

        MSGBOX "2nd method - PELock detected"

    ELSE

        MSGBOX "2nd method - PELock protection not found!"

    END IF

    IF (IsPELockPresent3 = %TRUE) THEN

        MSGBOX "3rd method - PELock detected"

    ELSE

        MSGBOX "3rd method - PELock protection not found!"

    END IF

    IF (IsPELockPresent4 = %TRUE) THEN

        MSGBOX "4th method - PELock detected"

    ELSE

        MSGBOX "4th method - PELock protection not found!"

    END IF

    IF (IsPELockPresent5 = %TRUE) THEN

        MSGBOX "5th method - PELock detected"

    ELSE

        MSGBOX "5th method - PELock protection not found!"

    END IF

    IF (IsPELockPresent6 = %TRUE) THEN

        MSGBOX "6th method - PELock detected"

    ELSE

        MSGBOX "6th method - PELock protection not found!"

    END IF

    IF (IsPELockPresent7 = %TRUE) THEN

        MSGBOX "7th method - PELock detected"

    ELSE

        MSGBOX "7th method - PELock protection not found!"

    END IF

    IF (IsPELockPresent8 = %TRUE) THEN

        MSGBOX "8th method - PELock detected"

    ELSE

        MSGBOX "8th method - PELock protection not found!"

    END IF

END FUNCTION
