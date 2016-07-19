'///////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to use trial total time expiration callback
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

%IDC_LABEL = %WM_USER + 2048

GLOBAL hMainDialog AS DWORD


'
' put here finalization code, close file handles, save config etc.
'
' return values:
'
' 1 - application will be closed
' 0 - application will be running, even after trial time expiration
'
FUNCTION TrialTotalExpired () AS DWORD

    ' call TrialTotalExpired()
    TRIAL_TOTAL_EXPIRED

    MessageBox(hMainDialog, "This version expired, please buy full version!", "Warning", %MB_ICONWARNING)

    ' you are responsible for the application exit, or you can leave it up to
    ' the pelock's code, just return 1 to close application or 0 to leave it running
    ExitProcess(1)

    FUNCTION = 1

END FUNCTION

CALLBACK FUNCTION DlgProc

    SELECT CASE CBMSG

    CASE %WM_COMMAND

        IF CBCTL = %IDCANCEL THEN DIALOG END CBHNDL, 0

    END SELECT

END FUNCTION


FUNCTION PBMAIN () AS LONG

    ' create a new dialog window
    DIALOG NEW %NULL, "PELock Test",,, 200, 100, %WS_SYSMENU TO hMainDialog

    ' add controls to the dialog window
    CONTROL ADD LABEL, hMainDialog, %IDC_LABEL, "This is a trial version!", 8, 8, 280, 14
    CONTROL ADD BUTTON, hMainDialog, %IDCANCEL, "&Close", 8, 65, 50, 14

    ' display dialog window
    DIALOG SHOW MODAL hMainDialog CALL DlgProc

END FUNCTION
