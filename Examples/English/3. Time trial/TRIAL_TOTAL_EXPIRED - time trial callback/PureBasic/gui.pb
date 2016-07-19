;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to use trial total time expiration callback
;//
;// Version        : PELock v2.0
;// Language       : PureBasic
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\English\PureBasic\"
XIncludeFile "pelock.pb"

;
; put here finalization code, close file handles, save config etc.
;
; return values:
;
; 1 - application will be closed
; 0 - application will be running, even after trial time expiration
;
Procedure TrialTotalExpired()

    ; call TrialTotalExpired()
    TRIAL_TOTAL_EXPIRED

    ; main window handle
    hMainDialog = WindowID(0)

    MessageBox_(hMainDialog, "This version expired, please buy full version!", "Warning", #MB_ICONWARNING)

    ; you are responsible for the application exit, or you can leave it up to
    ; the pelock's code, just return 1 to close application or 0 to leave it running
    End 1 ;ExitProcess_(1)

    ;ProcedureReturn 1

EndProcedure

; start

    ; create a new dialog window
    If OpenWindow(0, 0, 0, 200, 100, "PELock Test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

      ; add controls to the dialog window
      If CreateGadgetList(WindowID(0))

        TextGadget(0, 8, 8, 280, 25, "This is a trial version!")
        ButtonGadget(1, 8, 65, 70, 25, "&Close")

      EndIf

    EndIf

    ; display dialog window
    Repeat

      EventID = WaitWindowEvent()

      If EventID = #PB_Event_Gadget

        If EventGadget() = 1

          CloseWindow(0)
          End

          ; bogus call so that the compiler won't remove TrialTotalExpired()
          ; from the executable (optimization)!
          TrialTotalExpired()

        EndIf


      EndIf

    Until EventID = #PB_Event_CloseWindow
