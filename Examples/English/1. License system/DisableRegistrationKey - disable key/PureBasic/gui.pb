;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to disable registration key at runtime
;//
;// Version        : PELock v2.0
;// Language       : PureBasic
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\English\PureBasic\"
XIncludeFile "pelock.pb"

Global regname.s{64}

; start

    DEMO_START

    ; read registered user name
    GetRegistrationName(regname, 64)

    MessageRequester("PELock", "Program registered to " + regname)

    DEMO_END

    ; something went wrong, disable registration key
    DisableRegistrationKey(#False)

    ; reset name
    regname = "")

    ; following code won't be executed after disabling
    ; license key!
    DEMO_START

    ; read registered user name
    GetRegistrationName(regname, 64)

    MessageRequester("PELock", "Program registered to " + regname)

    DEMO_END

    ; check registered user name length (0 - key not present)
    If (Len(regname) = 0)
        MessageRequester("PELock", "Evaluation version")
    EndIf
