;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to check PELock protection presence
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

    ; protection checks will always return TRUE for the
    ; protected application, otherwise (unprotected application
    ; or cracked) it will return FALSE and you can (or should)
    ; do one of the following things:
    ;
    ; - close the application (when it's not expected, use
    ;   timers or background threads to perform the checks)
    ; - corrupt memory buffers
    ; - initialize important variables with wrong values
    ; - invoke exceptions (RaiseException())
    ; - perform incorrect calculations (it it very hard to detect
    ;   for the person who is trying to crack the application,
    ;   if he doesn't remove all the checks and the application
    ;   will be released, it won't work correctly)
    ;
    ; - DO NOT DISPLAY ANY WARNINGS THAT THE PROTECTION WAS
    ;   REMOVED, THIS IS THE WORSE THING YOU CAN DO, BECAUSE
    ;   IT CAN BE EASILY TRACED AND USED TO REMOVE THE
    ;   PROTECTION CHECKS
    ;
    ; use your imagination :)
    MessageRequester("PELock", "Detect PELock protection presence:")

    If (IsPELockPresent1() = #True)

        MessageRequester("PELock", "1st method - PELock detected")

    Else

        MessageRequester("PELock", "1st method - PELock protection not found!")

    EndIf

    If (IsPELockPresent2() = #True)

        MessageRequester("PELock", "2nd method - PELock detected")

    Else

        MessageRequester("PELock", "2nd method - PELock protection not found!")

    EndIf

    If (IsPELockPresent3() = #True)

        MessageRequester("PELock", "3rd method - PELock detected")

    Else

        MessageRequester("PELock", "3rd method - PELock protection not found!")

    EndIf

    If (IsPELockPresent4() = #True)

        MessageRequester("PELock", "4th method - PELock detected")

    Else

        MessageRequester("PELock", "4th method - PELock protection not found!")

    EndIf

    If (IsPELockPresent5() = #True)

        MessageRequester("PELock", "5th method - PELock detected")

    Else

        MessageRequester("PELock", "5th method - PELock protection not found!")

    EndIf

    If (IsPELockPresent6() = #True)

        MessageRequester("PELock", "6th method - PELock detected")

    Else

        MessageRequester("PELock", "6th method - PELock protection not found!")

    EndIf

    If (IsPELockPresent7() = #True)

        MessageRequester("PELock", "7th method - PELock detected")

    Else

        MessageRequester("PELock", "7th method - PELock protection not found!")

    EndIf

    If (IsPELockPresent8() = #True)

        MessageRequester("PELock", "8th method - PELock detected")

    Else

        MessageRequester("PELock", "8th method - PELock protection not found!")

    EndIf

