;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak sprawdzic czy klucz jest zablokowany na sprzetowy identyfikator
;//
;// Wersja         : PELock v2.09
;// Jezyk          : PureBasic
;// Autor          : Bartosz Wójcik (support@pelock.com)
;// Strona domowa  : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\Polish\PureBasic\"
XIncludeFile "pelock.pb"

; start

    DEMO_START

    ; czy klucz jest zablokowany na sprzetowy identyfikator
    If (IsKeyHardwareIdLocked() = #True)

        MessageRequester("PELock", "Ten klucz jest zablokowany na sprzetowy identyfikator!")

    Else

        MessageRequester("PELock", "Ten klucz NIE jest zablokowany na sprzetowy identyfikator!")

    EndIf

    DEMO_END
