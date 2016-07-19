;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to read key expiration date
;//
;// Version        : PELock v2.0
;// Language       : PureBasic
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\English\PureBasic\"
XIncludeFile "pelock.pb"

Global stSysTime.SYSTEMTIME

; start

    ; to be able to read key expiration date, program should
    ; contain at least one DEMO_START + DEMO_END marker
    DEMO_START

    ; read key expiration date (if it was set)
    ; expiration date is read into a SYSTEMTIME structure
    ; and only day/month/years fields are set
    If (GetKeyCreationDate(stSysTime) = 1)

        MessageRequester("PELock", "Key expiration date " + LTrim(Str(stSysTime\wDay)) + "-" + LTrim(Str(stSysTime\wMonth)) + "-" + LTrim(Str(stSysTime\wYear)) )

    Else

        MessageRequester("PELock", "This is a full version without time limits.")

    EndIf


    DEMO_END
