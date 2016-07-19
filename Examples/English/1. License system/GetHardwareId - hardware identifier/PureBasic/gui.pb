;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to use DEMO_START and DEMO_END macros
;//
;// Version        : PELock v2.0
;// Language       : PureBasic
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\English\PureBasic\"
XIncludeFile "pelock.pb"

Global hardware_id.s{64}
Global regname.s{64}

; start

    ; read hardware id
    GetHardwareId(hardware_id, 64)

    ; to be able to read hardware id, application should contain at least one
    ; DEMO_START or FEATURE_x_START marker
    DEMO_START

    ; get name of registered user
    GetRegistrationName(regname, 64)

    ; print registered user name
    MessageRequester("PELock", "Program registered to " + regname)

    DEMO_END

    ; display hardware ID in case of unregistered version
    If (Len(regname) = 0)

        SetClipboardText(hardware_id)

        MessageRequester("PELock", "Evaluation version, please provide this ID " + hardware_id + " (copied to clipboard)")

    EndIf
