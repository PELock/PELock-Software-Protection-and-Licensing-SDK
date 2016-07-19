;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to read trial info (expiration date)
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

    stExpirationDate.SYSTEMTIME
    dwTrialStatus.l = #PELOCK_TRIAL_ABSENT


    CRYPT_START

    ; read time trial information
    dwTrialStatus = GetExpirationDate(stExpirationDate)

    Select dwTrialStatus

    ;
    ; time trial is active
    ;
    Case #PELOCK_TRIAL_ACTIVE:

        MessageRequester("PELock", "Trial version, it will expire on " + LTrim(Str(stExpirationDate\wDay)) + "-" + LTrim(Str(stExpirationDate\wMonth)) + "-" + LTrim(Str(stExpirationDate\wYear)) )

    ;
    ; trial expired, display custom nagscreen and close application
    ; returned only when "Allow application to expire" option is enabled
    ;
    Case #PELOCK_TRIAL_EXPIRED

        MessageRequester("PELock", "This version has expired and it will be closed!")

    ;
    ; trial options are not enabled for this file
    ;
    Default ; including #PELOCK_TRIAL_ABSENT

        MessageRequester("PELock", "No time trial limits.")

    EndSelect

    CRYPT_END


