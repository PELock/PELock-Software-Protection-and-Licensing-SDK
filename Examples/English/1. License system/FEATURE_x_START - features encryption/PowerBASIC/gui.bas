'///////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to use FEATURE_x_START macros
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

FUNCTION ExtraFunctionality AS LONG

DIM result AS LONG

    ' at least one DEMO_START / DEMO_END or FEATURE_x_START / FEATURE_x_END
    ' marker is required, so that the license system will be active for
    ' the protected application

    ' with FEATURE_x markers you can enable some parts of your software
    ' depending on the additional key settings

    ' it's recommended to enclose encrypted code chunks within
    ' some conditional code
    IF (IsFeatureEnabled(1) = TRUE) THEN

        ' code between those two markers will be encrypted, it won't
        ' be available without proper feature settings stored in the key file
        FEATURE_1_START

        MSGBOX "Feature 1 -> enabled"

        result = 1

        FEATURE_1_END

    END IF

    FUNCTION = result

END FUNCTION

FUNCTION PBMAIN () AS LONG

    ExtraFunctionality

END FUNCTION
