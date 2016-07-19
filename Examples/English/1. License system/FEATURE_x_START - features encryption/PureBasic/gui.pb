;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to use FEATURE_x_START macros
;//
;// Version        : PELock v2.0
;// Language       : PureBasic
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\English\PureBasic\"
XIncludeFile "pelock.pb"

Procedure ExtraFunctionality()

    result.l = 0

    ; at least one DEMO_START / DEMO_END or FEATURE_x_START / FEATURE_x_END
    ; marker is required, so that the license system will be active for
    ; the protected application

    ; with FEATURE_x markers you can enable some parts of your software
    ; depending on the additional key settings

    ; it's recommended to enclose encrypted code chunks within
    ; some conditional code
    If (IsFeatureEnabled(1) = #True)

        ; code between those two markers will be encrypted, it won't
        ; be available without proper feature settings stored in the key file
        FEATURE_1_START

        MessageRequester("PELock", "Feature 1 -> enabled")

        result = 1

        FEATURE_1_END

    EndIf

    ProcedureReturn result

EndProcedure

; start

    ExtraFunctionality()
