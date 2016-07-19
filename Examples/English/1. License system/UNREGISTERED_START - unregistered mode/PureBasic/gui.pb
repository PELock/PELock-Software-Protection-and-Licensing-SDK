;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to use UNREGISTERED_START and UNREGISTERED_END macros
;//
;// Version        : PELock v2.0
;// Language       : PureBasic
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\English\PureBasic\"
XIncludeFile "pelock.pb"

    ; display a message in unregistered version
    ;
    ; you need to put at least one DEMO_START or FEATURE_x_START
    ; encryption macro in order to use UNREGISTERED_START macros
    UNREGISTERED_START

    MessageRequester("PELock", "This is an unregistered version, please buy a full version!")

    UNREGISTERED_END

    ; code between DEMO_START and DEMO_END will be encrypted
    ; in protected file and will not be available without license key
    DEMO_START

    MessageRequester("PELock", "Hello world from the full version of my software!")

    DEMO_END
