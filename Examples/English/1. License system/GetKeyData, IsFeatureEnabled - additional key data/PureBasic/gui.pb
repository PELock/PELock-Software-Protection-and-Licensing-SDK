;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to use IsFeatureEnabled() api
;//
;// Version        : PELock v2.0
;// Language       : PureBasic
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\English\PureBasic\"
XIncludeFile "pelock.pb"

; start

    ; code between DEMO_START and DEMO_END will be encrypted
    ; in protected file and will not be available without license key
    DEMO_START

    MessageRequester("PELock", "Hello world from the full version of my software!")

    If (IsFeatureEnabled(1) = #True)

        FEATURE_1_START

        MessageRequester("PELock", "This is an extended version.")

        FEATURE_1_END

    EndIf

    DEMO_END
