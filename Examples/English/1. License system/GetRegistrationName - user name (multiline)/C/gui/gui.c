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

#include <windows.h>
#include <commctrl.h>
#include <stdio.h>
#include <math.h>
#include "gui.h"
#include "pelock.h"

// registered user name buffer
unsigned char szUser[PELOCK_MAX_USERNAME] = { 0 };
int i = 0;
char *szToken = NULL;

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

			// end marker
			DEMO_END

			// check if anything was copied to the buffer
			// if not set to default
			if (strlen(szUser) != 0)
			{
				// split string (ignore empty lines)
				szToken = strtok(szUser, "\r\n");

				i = 1;

				// display tokens
				while (szToken != NULL)
				{
					// display only 3rd line from the registered user name
					if (i == 3)
					{
						// display registered user name
						SetDlgItemText(hDlg, IDC_REG, szToken);

						break;
					}

					szToken = strtok(NULL, "\r\n");
				}
			}
			else
			{
				SetDlgItemText(hDlg, IDC_REG, "Unregistered!");
			}

			// set main window caption
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
