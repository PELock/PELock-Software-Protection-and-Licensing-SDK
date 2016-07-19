'///////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to read trial info (trial period)
'//
'// Version        : PELock v2.0
'// Language       : PowerBASIC
'// Author         : Bartosz Wójcik (support@pelock.com)
'// Web page       : https://www.pelock.com
'//
'///////////////////////////////////////////////////////////////////////////////

#COMPILE EXE
%USEMACROS = 1

#INCLUDE "win32api.inc"
#INCLUDE "pelock.inc"

FUNCTION PBMAIN () AS LONG

    DIM stPeriodBegin AS SYSTEMTIME, stPeriodEnd AS SYSTEMTIME
    DIM dwTrialStatus AS DWORD

    dwTrialStatus = %PELOCK_TRIAL_ABSENT

    CRYPT_START

    ' read time trial information
    dwTrialStatus = GetTrialPeriod(stPeriodBegin, stPeriodEnd)

    SELECT CASE dwTrialStatus

    '
    ' time trial is active
    '
    CASE %PELOCK_TRIAL_ACTIVE:

        MSGBOX "Trial period for this application:" & $CRLF & _
               "Period begin " & LTRIM$(STR$(stPeriodBegin.wDay)) & "-" & LTRIM$(STR$(stPeriodBegin.wMonth)) & "-" & LTRIM$(STR$(stPeriodBegin.wYear)) & $CRLF & _
               "Period end   " & LTRIM$(STR$(stPeriodEnd.wDay)) & "-" & LTRIM$(STR$(stPeriodEnd.wMonth)) & "-" & LTRIM$(STR$(stPeriodEnd.wYear))

    '
    ' trial options are not enabled for this file
    '
    CASE ELSE ' including %PELOCK_TRIAL_ABSENT

        MSGBOX "No time trial limits."

    END SELECT

    CRYPT_END

END FUNCTION
