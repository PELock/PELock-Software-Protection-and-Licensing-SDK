;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to use antidump PELOCK_MEMORY_GAP macro
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

    ; this macro will create a 'memory hole' within your application
    ; process space, this hole will be unavailable to the application
    ; itself and other tools, including tools used to dump the memory
    ; of the application, you can place this macro wherever you want,
    ; it doesn't change execution of your application in any way
    PELOCK_MEMORY_GAP

    MessageRequester("PELock", "Hello world!")

