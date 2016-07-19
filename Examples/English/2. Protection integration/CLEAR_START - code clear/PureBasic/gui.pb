;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to use CLEAR_START and CLEAR_END macros
;//
;// Version        : PELock v2.0
;// Language       : PureBasic
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\English\PureBasic\"
XIncludeFile "pelock.pb"

Global i.l
Global j.l

Procedure initialize_app()

    ; code between CLEAR_START and CLEAR_END will be encrypted, and
    ; once executed it will be erased from the memory
    CLEAR_START

    i = 1
    j = 2

    CLEAR_END

EndProcedure

; start

    ; initialize application
    initialize_app()

    ; code between CRYPT_START and CRYPT_END will be encrypted
    ; in protected file
    CRYPT_START

    MessageRequester("PELock", "Hello world!")

    CRYPT_END

