;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to read trial info (trial period)
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

    stPeriodBegin.SYSTEMTIME
    stPeriodEnd.SYSTEMTIME
    dwTrialStatus.l = #PELOCK_TRIAL_ABSENT


    CRYPT_START

    ; read time trial information
    dwTrialStatus = GetTrialPeriod(stPeriodBegin, stPeriodEnd)

    Select dwTrialStatus

    ;
    ; time trial is active
    ;
    Case #PELOCK_TRIAL_ACTIVE

        MessageRequester("PELock", "Trial period for this application:" + Chr(13) + Chr(10) + "Period begin " + LTrim(Str(stPeriodBegin\wDay)) + "-" + LTrim(Str(stPeriodBegin\wMonth)) + "-" + LTrim(Str(stPeriodBegin\wYear)) + Chr(13) + Chr(10) + "Period end   " + LTrim(Str(stPeriodEnd\wDay)) + "-" + LTrim(Str(stPeriodEnd\wMonth)) + "-" + LTrim(Str(stPeriodEnd\wYear)) )

    ;
    ; trial options are not enabled for this file
    ;
    Default ; including #PELOCK_TRIAL_ABSENT

        MessageRequester("PELock", "No time trial limits.")

    EndSelect

    CRYPT_END

