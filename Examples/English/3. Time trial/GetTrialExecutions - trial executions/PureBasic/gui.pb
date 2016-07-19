;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to read trial info (number of trial executions)
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

    dwExecsTotal.l
    dwExecsLeft.l
    dwTrialStatus.l = #PELOCK_TRIAL_ABSENT


    CRYPT_START

    ; read time trial information
    dwTrialStatus = GetTrialExecutions(dwExecsTotal, dwExecsLeft)

    Select dwTrialStatus

    ;
    ; time trial is active
    ;
    Case #PELOCK_TRIAL_ACTIVE:

        MessageRequester("PELock", "Trial version, " + Str(dwExecsLeft) + " executions out of " + Str(dwExecsTotal) + " left.")

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

