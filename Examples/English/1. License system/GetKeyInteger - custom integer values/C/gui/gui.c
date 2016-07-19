////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read custom integer values stored in the keyfile
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

char szTemp[256] = { 0 };
unsigned int nNumberOfItems = 0;

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// initialization of main window
		case WM_INITDIALOG:

			// set window's caption
			SetWindowText(hDlg, "PELock Test");

			// read integer stored in the keyfile
			DEMO_START

			nNumberOfItems = GetKeyInteger(7);

			sprintf(szTemp, "Number of items = %u", nNumberOfItems);

			SetDlgItemText(hDlg, IDC_INFO, szTemp);

			DEMO_END

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

	// without the key application won't show the main dialog
	DEMO_START

	DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);

	DEMO_END

	return 0;
}
