'///////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to use PELOCK_INIT_CALLBACK macros
'//
'// Version        : PELock v2.0
'// Language       : PowerBASIC
'// Author         : Bartosz Wójcik (support@pelock.com)
'// Web page       : https://www.pelock.com
'//
'///////////////////////////////////////////////////////////////////////////////

#COMPILE EXE
%USEMACROS = 1

#INCLUDE "win32api.inc"
#INCLUDE "pelock.inc"

' initialize variables
GLOBAL dwSecretValue1 AS DWORD
GLOBAL dwSecretValue2 AS DWORD

'
' initialization callbacks are called only once before application
' start, it can be used to initialize sensitive variables, it is
' called only for the protected applications, so if the protection
' gets removed those functions won't be called (extra protection
' against code unpacking)
'
' those function has to be used somewhere in the code, so it won't
' be removed by the compiler optimizations (which in most cases
' removes unused and unreferenced functions), you can use a simple
' trick to protect against it, check the function pointer anywhere
' in the code eg.:
'
' if ((&pelock_initalization_callback_1 == NULL) return 0;
'
' also keep in mind that those functions are called before
' application initialization code, so if your application
' depends on some libraries (either static or dynamic), make
' sure to keep this code simple without any references to those
' libraries and their functions
'
SUB pelock_initalization_callback_1(hInstance AS DWORD, dwReserved AS DWORD)

    ' initialization callback marker
    PELOCK_INIT_CALLBACK

    ' initialization callbacks are called only once, so
    ' it's safe to erase its code after execution
    CLEAR_START

    dwSecretValue1 = 2

    CLEAR_END

END SUB

'
' second callback, you can place as many callbacks as you want
'
SUB pelock_initalization_callback_2(hInstance AS DWORD, dwReserved AS DWORD)

    ' initialization callback marker
    PELOCK_INIT_CALLBACK

    ' initialization callbacks are called only once, so
    ' it's safe to erase its code after execution
    CLEAR_START

    dwSecretValue2 = 2

    CLEAR_END

END SUB

FUNCTION PBMAIN () AS LONG

    MSGBOX "Calculation result 2 + 2 =" & STR$(dwSecretValue1 + dwSecretValue2)

    ' protection against compiler optimizations
    IF (CODEPTR(pelock_initalization_callback_1) = 0) OR (CODEPTR(pelock_initalization_callback_2) = 0) THEN
        FUNCTION = 1
    END IF

END FUNCTION
