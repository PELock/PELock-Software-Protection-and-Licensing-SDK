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
Global regname.s{#PELOCK_MAX_USERNAME}

;
; custom hardware id callback
;
; return values:
;
; 1 - hardware identifier successfully generated
; 0 - an error occured, for example when dongle key was
;     not present), please note that any further calls to
;     GetHardwareId() or functions to set/reload
;     registration key locked to hardware id will fail
;     in this case (error codes will be returned)
;
Procedure custom_hardware_id(*output)

    ;
    ; copy custom hardware identifier To output buffer (8 bytes)
    ;
    ; you can create custome hardware identifier from:
    ;
    ; - dongle (hardware key) hardware identifier
    ; - operating system information
    ; - etc.
    ;
    For i.l = 0 To 7

      PokeB(*output + i, i + 1)

    Next

    ; return 1 to indicate success
    ProcedureReturn 1

EndProcedure

; start

    ; set our own hardware id callback routine (you need to enable
    ; proper option in SDK tab)
    SetHardwareIdCallback(custom_hardware_id)

    ; reload registration key (from default locations)
    ReloadRegistrationKey()

    ; read hardware id
    GetHardwareId(hardware_id, SizeOf(hardware_id))

    ; to be able to read hardware id, application should contain at least one
    ; DEMO_START or FEATURE_x_START marker
    DEMO_START

    ; get name of registered user
    GetRegistrationName(regname, SizeOf(regname))

    ; print registered user name
    MessageRequester("PELock", "Program registered to " + regname)

    DEMO_END

    ; display hardware ID in case of unregistered version
    If (Len(regname) = 0)

        SetClipboardText(hardware_id)

        MessageRequester("PELock", "Evaluation version, please provide this ID " + hardware_id + " (copied to clipboard)")

    EndIf
