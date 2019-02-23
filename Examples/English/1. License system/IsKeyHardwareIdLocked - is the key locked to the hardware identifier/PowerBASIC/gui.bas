;////////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to check if the key is locked to the hardware identifier
;//
;// Version        : PELock v2.09
;// Language       : PowerBASIC
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;////////////////////////////////////////////////////////////////////////////////

#COMPILE EXE
%USEMACROS = 1

#INCLUDE "win32api.inc"
#INCLUDE "pelock.inc"

FUNCTION PBMAIN () AS LONG

    DEMO_START

    ; is the key locked to the hardware identifier
    IF (IsKeyHardwareIdLocked = %TRUE) THEN

        MSGBOX "This key is locked to the hardware identifier!"

    ELSE

        MSGBOX "This key is NOT locked to the hardware identifier!"

    END IF

    DEMO_END

END FUNCTION
