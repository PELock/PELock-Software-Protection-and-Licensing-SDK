////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read trial info (number of trial days)
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

int dwDaysLeft = 0;
int dwTrialStatus = PELOCK_TRIAL_ABSENT;
char szInfo[256] = { 0 };

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// initialization of main window, its executed only one time
		// so we can use CLEAR_START and CLEAR_END macros
		case WM_INITDIALOG:

			// code between CLEAR_START and CLEAR_END will be executed
			// and then erased from the memory
			CLEAR_START

			SetWindowText(hDlg, "PELock Test");

			// read time trial information (read number of days left only)
			dwTrialStatus = GetTrialDays(NULL, &dwDaysLeft);

			switch (dwTrialStatus)
			{

			//
			// time trial is active
			//
			case PELOCK_TRIAL_ACTIVE:

				sprintf(szInfo, "Trial version, %u days left.", dwDaysLeft);
				break;

			//
			// trial expired, display custom nagscreen and close application
			//
			case PELOCK_TRIAL_EXPIRED:

				sprintf(szInfo, "This version has expired and it will be closed!");
				break;

			//
			// trial options are not enabled for this file
			//
			case PELOCK_TRIAL_ABSENT:
			default:

				sprintf(szInfo, "No time trial limits.");
				break;
			}

			SetDlgItemText(hDlg, IDC_INFO, szInfo);

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
