;////////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to check if the key is locked to the hardware identifier
;//
;// Version        : PELock v2.09
;// Language       : PureBasic
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;////////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\English\PureBasic\"
XIncludeFile "pelock.pb"

; start

    DEMO_START

    ; is the key locked to the hardware identifier
    If (IsKeyHardwareIdLocked() = #True)

        MessageRequester("PELock", "This key is locked to the hardware identifier!")

    Else

        MessageRequester("PELock", "This key is NOT locked to the hardware identifier!")

    EndIf

    DEMO_END

