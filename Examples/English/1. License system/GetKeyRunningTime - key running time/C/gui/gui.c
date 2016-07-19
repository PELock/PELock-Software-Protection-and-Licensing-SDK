////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read key expiration date
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

// registered user
unsigned char szUser[256] = { 0 };
SYSTEMTIME stRunTime = { 0 };

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// initialization of main window
		case WM_INITDIALOG:

			// start marker, code between DEMO_START and DEMO_END
			// will be encrypted in protected file and unavailable
			// without valid license key
			DEMO_START

			// get registered user name
			GetRegistrationName(szUser, sizeof(szUser));

			// display registered user name
			SetDlgItemText(hDlg, IDC_REG, szUser);

			// set timer to display key running time
			SetTimer(hDlg, 1, 1000, NULL);

			// end marker
			DEMO_END

			// check if anything was copied to the buffer
			// if not set to default
			if (strlen(szUser) == 0)
			{
				SetDlgItemText(hDlg, IDC_REG, "Unregistered version!");
			}

			SetWindowText(hDlg, "PELock Test");

			return TRUE;

		// display key running time
		case WM_TIMER:

			// get key running time (since it was set)
			if (GetKeyRunningTime(&stRunTime) == 1)
			{
				wsprintf(szUser,"%lu hours %lu minutes %lu seconds", stRunTime.wHour, stRunTime.wMinute, stRunTime.wSecond);
			}
			else
			{
				strcpy(szUser, "n/a");
			}

			SetDlgItemText(hDlg, IDC_RUN_TIME, szUser);

			return FALSE;

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

	DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);

	return 0;
}
