;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to use FILE_CRYPT_START and FILE_CRYPT_END macros
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

    ; code between FILE_CRYPT_START and FILE_CRYPT_END will be encrypted
    ; in protected file (external file is used as an encryption key)
    FILE_CRYPT_START

    MessageRequester("PELock", "Hello world!")

    FILE_CRYPT_END


