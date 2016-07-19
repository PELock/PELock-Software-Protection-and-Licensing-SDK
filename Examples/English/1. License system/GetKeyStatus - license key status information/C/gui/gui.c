////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read license key status information
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

int dwKeyStatus = PELOCK_KEY_NOT_FOUND;
char szInfo[256] = { 0 };

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// initialization of main window, its executed only one time
		// so we can use CLEAR_START and CLEAR_END macros
		case WM_INITDIALOG:

			SetWindowText(hDlg, "PELock Test");

			// read license key status information
			dwKeyStatus = GetKeyStatus();

			switch (dwKeyStatus)
			{

			//
			// key is valid (so the code between DEMO_START and DEMO_END should be executed)
			//
			case PELOCK_KEY_OK:

				DEMO_START

				sprintf(szInfo, "License key is valid.");

				DEMO_END

				break;

			//
			// invalid format of the key (corrupted)
			//
			case PELOCK_KEY_INVALID:

				sprintf(szInfo, "License key is invalid (corrupted)!");
				break;

			//
			// license key was on the blocked keys list (stolen)
			//
			case PELOCK_KEY_STOLEN:

				sprintf(szInfo, "License key is blocked!");
				break;

			//
			// hardware identifier is different from the one used to encrypt license key
			//
			case PELOCK_KEY_WRONG_HWID:

				sprintf(szInfo, "Hardware identifier doesn't match to the license key!");
				break;

			//
			// license key is expired (not active)
			//
			case PELOCK_KEY_EXPIRED:

				sprintf(szInfo, "License key is expired!");
				break;

			//
			// license key not found
			//
			case PELOCK_KEY_NOT_FOUND:
			default:

				sprintf(szInfo, "License key not found.");
				break;
			}

			SetDlgItemText(hDlg, IDC_INFO, szInfo);

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
