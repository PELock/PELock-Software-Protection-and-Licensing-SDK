;////////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to read license key status information
;//
;// Version        : PELock v2.0
;// Language       : PureBasic
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;////////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\English\PureBasic\"
XIncludeFile "pelock.pb"

; start

    dwKeyStatus.l = #PELOCK_KEY_NOT_FOUND

    ; read license key status information
    dwKeyStatus = GetKeyStatus()

    Select dwKeyStatus

    ;
    ; key is valid (so the code between DEMO_START and DEMO_END should be executed)
    ;
    Case #PELOCK_KEY_OK:

        DEMO_START

        MessageRequester("PELock", "License key is valid.")

        DEMO_END

    ;
    ; invalid format of the key (corrupted)
    ;
    Case #PELOCK_KEY_INVALID:

        MessageRequester("PELock", "License key is invalid (corrupted)!")

    ;
    ; license key was on the blocked keys list (stolen)
    ;
    Case #PELOCK_KEY_STOLEN:

        MessageRequester("PELock", "License key is blocked!")

    ;
    ; hardware identifier is different from the one used to encrypt license key
    ;
    Case #PELOCK_KEY_WRONG_HWID:

        MessageRequester("PELock", "Hardware identifier doesn't match to the license key!")

    ;
    ; license key is expired (not active)
    ;
    Case #PELOCK_KEY_EXPIRED:

        MessageRequester("PELock", "License key is expired!")

    ;
    ; license key not found
    ;
    Default ; including #PELOCK_KEY_NOT_FOUND

        MessageRequester("PELock", "License key not found.")

    EndSelect
