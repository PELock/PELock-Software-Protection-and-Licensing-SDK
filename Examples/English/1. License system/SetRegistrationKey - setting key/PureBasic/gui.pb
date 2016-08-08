;///////////////////////////////////////////////////////////////////////////////
;//
;// Setting license key from external file (placed, somewhere else than
;// protected application directory)
;//
;// Version        : PELock v2.0
;// Language       : PureBasic
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\English\PureBasic\"
XIncludeFile "pelock.pb"

Global regname.s{#PELOCK_MAX_USERNAME}

; start

    ; set license key path, this function will
    ; work only if no other key was previously
    ; set (either from file or registry)
    SetRegistrationKey("c:\key.lic")

    ; to be able to read registered user name, application
    ; should contain at least one DEMO_START or
    ; FEATURE_x_START marker
    DEMO_START

    ; get name of registered user
    GetRegistrationName(regname, SizeOf(regname))

    MessageRequester("PELock", "Program registered to " + regname)

    DEMO_END

    If (Len(regname) = 0)

        MessageRequester("PELock", "Evaluation version")

    EndIf

