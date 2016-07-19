;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to use PELock's protected constants
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

    Dim int_array.l(5)

    i.l = 0
    x.l = 0
    y.l = 5

    ; you can use PELOCK_DWORD() wherever you want, it will
    ; always return provided constant value
    For i = 0 To PELOCK_DWORD(3)

        MessageRequester("PELock", Str(i))

    Next

    ; use PELOCK_SIZEOF (its using PELOCK_DWORD to protect the value) instead of sizeof keyword
    MessageRequester("PELock", "sizeof(i) = " + Str(PELOCK_SIZEOF(i)) )

    ; use it in calculations
    x = (1024 * y) + PELOCK_DWORD(-1)

    ; use it in WinApi calls with other constant values
    MessageBox_(#Null, "PELock's protected constants", "Hello world :)", PELOCK_DWORD( #MB_ICONINFORMATION ) )

    ; use it to initialize array items
    int_array(0) = PELOCK_DWORD(0)
    int_array(1) = PELOCK_DWORD($FF) + 100
