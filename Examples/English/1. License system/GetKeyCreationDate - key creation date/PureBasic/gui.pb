;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to read key creation date
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

    ; to be able to read key creation date, program should
    ; contain at least one DEMO_START + DEMO_END marker
    DEMO_START

    ; read key createion date (if it was set)
    ; key creation date is read into a SYSTEMTIME structure
    ; and only day/month/years fields are set
    If (GetKeyCreationDate(stSysTime) = 1)

        MessageRequester("PELock", "Key creation date " + LTrim(Str(stSysTime\wDay)) + "-" + LTrim(Str(stSysTime\wMonth)) + "-" + LTrim(Str(stSysTime\wYear)) )

    Else

        MessageRequester("PELock", "This key doesn't have creation date set.")

    EndIf


    DEMO_END
