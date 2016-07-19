;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to read key running time
;//
;// Version        : PELock v2.0
;// Language       : PureBasic
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\English\PureBasic\"
XIncludeFile "pelock.pb"

Global stRunTime.SYSTEMTIME

; start

    ; to be able to read key running time, program should
    ; contain at least one DEMO_START + DEMO_END marker
    DEMO_START
    
    ; delay
    Delay(2000);

    If (GetKeyRunningTime(stRunTime) = 1)

        MessageRequester("PELock", "Key running time " + LTrim(Str(stRunTime\wHour)) + " hours " + LTrim(Str(stRunTime\wMinute)) + " minutes " + LTrim(Str(stRunTime\wSecond)) + " seconds." )

    Else

        MessageRequester("PELock", "Cannot read key running time!")

    EndIf

    DEMO_END
