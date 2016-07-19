;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to use CRYPT_START and CRYPT_END macros
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

    ; code between CRYPT_START and CRYPT_END will be encrypted
    ; in protected file
    CRYPT_START

    MessageRequester("PELock", "Hello world!")

    CRYPT_END

