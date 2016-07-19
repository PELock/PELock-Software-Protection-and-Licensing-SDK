;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to use PELOCK_CPUID macros
;//
;// Version        : PELock v2.0
;// Language       : PureBasic
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\English\PureBasic\"
XIncludeFile "pelock.pb"

;
; put PELOCK_CPUID macros in rarely used procedures
; so it would be harder to trace it's presence for someone
; trying to fully rebuild your protected application
;
Procedure rarely_used_procedure()

    ; hidden marker
    PELOCK_CPUID

EndProcedure

; start

    Dim dwImportantArray.l(4)

    dwImportantArray(0) = 100

    ;
    ; these protection checks doesn't affect your application
    ; in any way, but when someone will try to run cracked or
    ; unpacked application, PELOCK_CPUID code will cause an
    ; exception, so the cracked/unpacked application won't
    ; work correctly
    ;
    PELOCK_CPUID

    ;
    ; you can catch exceptions caused by PELOCK_CPUID and
    ; handle protection removal your own way
    ;
    OnErrorGoto(?ProtectionRemoved)

        PELOCK_CPUID

        Goto ProtectionPresent

    ProtectionRemoved:

        ;
        ; - close application
        ; - damage memory area
        ; - disable some controls
        ; - change some important variables
        ;
        ; DON'T DISPLAY ANY WARNING MESSAGES!!!
        ;
        dwImportantArray(0) = 4

    ProtectionPresent:

    MessageRequester("PELock", "Calculation result 100 + 100 = " + Str(dwImportantArray(0) + dwImportantArray(0)) )
    