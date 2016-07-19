////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read key creation date
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
SYSTEMTIME stSysTime = { 0 };

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// initialization of main window
		case WM_INITDIALOG:

			// start marker, code between DEMO_START and DEMO_END
			// will be encrypted in protected file and unavailable
			// without valid license key

			// you *need* at least one DEMO_START/DEMO_END marker in the code
			// to be able to read key creation date
			DEMO_START

			// get registered user name
			GetRegistrationName(szUser, sizeof(szUser));

			// display registered user name
			SetDlgItemText(hDlg, IDC_REG, szUser);

			// read key creation date from the license key
			if (GetKeyCreationDate(&stSysTime) == 1)
			{
				wsprintf(szUser,"%lu-%lu-%lu (dd.mm.yy)", stSysTime.wDay, stSysTime.wMonth, stSysTime.wYear);
			}
			else
			{
				strcpy(szUser, "(not set)");
			}

			SetDlgItemText(hDlg, IDC_CREATION, szUser);

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
