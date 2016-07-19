;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to read custom integer values stored in the keyfile
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

    nNumberOfItems.l = 0

    ; code between DEMO_START and DEMO_END will be encrypted
    ; in protected file and will not be available without license key
    DEMO_START

    MessageRequester("PELock", "Hello world from the full version of my software!")

    ; read key integer value, you can use it however you want
    nNumberOfItems = GetKeyInteger(5)

    MessageRequester("PELock", "You can store up to " + Str(nNumberOfItems) + " items in the database")

    DEMO_END

