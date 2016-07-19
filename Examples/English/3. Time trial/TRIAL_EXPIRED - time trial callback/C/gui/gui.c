////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use time trial callback procedure
//
// Version        : PELock v2.0
// Language       : C/C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include <windows.h>
#include <commctrl.h>
#include <stdio.h>
#include <math.h>
#include "gui.h"
#include "pelock.h"

HWND hMainDialog = NULL;

//
// put here finalization code, close file handles, save config etc.
//
// return values:
//
// 1 - application will be closed
// 0 - application will be running, even after trial time expiration
//
int TrialExpired()
{
	// call TrialExpired()
	TRIAL_EXPIRED

	MessageBox(hMainDialog, "This version expired, please buy full version!", "Warning", MB_ICONWARNING);

	// you are responsible for the application exit, or you can leave it up to
	// the pelock's code, just return 1 to close application or 0 to leave it running
	ExitProcess(1);

	return 1;
}

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// initialization of the main window, its executed only once
		// so we can use CLEAR_START and CLEAR_END macros
		case WM_INITDIALOG:

			// code between CLEAR_START and CLEAR_END will be executed
			// and then erased from the memory
			CLEAR_START

			SetWindowText(hDlg, "PELock Test");

			hMainDialog = hDlg;

			CLEAR_END

			return TRUE;

		case WM_COMMAND:

			switch (LOWORD (wParam))
			{
				case IDCANCEL:
					EndDialog(hDlg, 0);
					break;
			}

			break;
	}

	return FALSE;
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	INITCOMMONCONTROLSEX iccControls = { sizeof(INITCOMMONCONTROLSEX), ICC_WIN95_CLASSES | ICC_DATE_CLASSES };

	// initialize common controls
	InitCommonControlsEx(&iccControls);

	CLEAR_START

	DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);

	CLEAR_END

	return 0;
}
