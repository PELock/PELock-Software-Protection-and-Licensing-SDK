////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read registered user name from the license key
//
// Version        : PELock v2.0
// Language       : C/C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#define UNICODE
#define _UNICODE

#include <windows.h>
#include <commctrl.h>
#include <tchar.h>
#include <stdio.h>
#include <math.h>
#include "gui.h"
#include "pelock.h"

#define _countof(array) (sizeof(array) / sizeof(array[0]))

// registered user name buffer
TCHAR szUser[PELOCK_MAX_USERNAME] = { 0 };

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// initialization of main window
		case WM_INITDIALOG:

			// put this code in conditional braces, without it, some C compilers
			// might produce invalid code (for example LCC, PellesC), it's
			// caused by the way stack is organized when encryption markers are used
			if (IsPELockPresent1() == 1)
			{
				// start marker, code between DEMO_START and DEMO_END
				// will be encrypted in protected file and unavailable
				// without valid license key
				DEMO_START

				// get registered user name
				GetRegistrationName(szUser, _countof(szUser));

				// display registered user name
				SetDlgItemText(hDlg, IDC_REG, szUser);

				// end marker
				DEMO_END
			}

			// check if anything was copied to the buffer
			// if not set to default
			if (_tcslen(szUser) == 0)
			{
				SetDlgItemText(hDlg, IDC_REG, _T("Unregistered!"));
			}

			// set main window caption
			SetWindowText(hDlg, _T("PELock Test"));

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
