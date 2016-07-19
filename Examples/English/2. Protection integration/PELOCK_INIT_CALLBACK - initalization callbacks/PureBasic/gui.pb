;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to use PELOCK_CHECKPOINT macros
;//
;// Version        : PELock v2.0
;// Language       : PureBasic
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\English\PureBasic\"
XIncludeFile "pelock.pb"

; initialize variables
Global dwSecretValue1.l
Global dwSecretValue2.l

;
; initialization callbacks are called only once before application
; start, it can be used to initialize sensitive variables, it is
; called only for the protected applications, so if the protection
; gets removed those functions won't be called (extra protection
; against code unpacking)
;
; those function has to be used somewhere in the code, so it won't
; be removed by the compiler optimizations (which in most cases
; removes unused and unreferenced functions), you can use a simple
; trick to protect against it, check the function pointer anywhere
; in the code eg.:
;
; if ((&pelock_initalization_callback_1 == NULL) return 0;
;
; also keep in mind that those functions are called before
; application initialization code, so if your application
; depends on some libraries (either static or dynamic), make
; sure to keep this code simple without any references to those
; libraries and their functions
;
Procedure pelock_initalization_callback_1(hInstance.l, dwReserved.l)

    ; initialization callback marker
    PELOCK_INIT_CALLBACK

    ; initialization callbacks are called only once, so
    ; it's safe to erase its code after execution
    CLEAR_START

    dwSecretValue1 = 2;

    CLEAR_END

EndProcedure

;
; second callback, you can place as many callbacks as you want
;
Procedure pelock_initalization_callback_2(hInstance.l, dwReserved.l)

    ; initialization callback marker
    PELOCK_INIT_CALLBACK

    ; initialization callbacks are called only once, so
    ; it's safe to erase its code after execution
    CLEAR_START

    dwSecretValue2 = 2;

    CLEAR_END

EndProcedure

; start
    MessageRequester("PELock", "Calculation result 2 + 2 = " + Str(dwSecretValue1 + dwSecretValue2) )

    ; protection against compiler optimizations
    If @pelock_initalization_callback_1() = 0
        End 1
    EndIf

    If @pelock_initalization_callback_2() = 0
        End 1
    EndIf

; IDE Options = PureBasic 5.30 (Windows - x86)
; Executable = tst.exe