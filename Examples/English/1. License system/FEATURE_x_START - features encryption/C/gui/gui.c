////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use FEATURE_x_START macros
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

int ExtraFunctionality(HWND hMain)
{
	int dwResult = 0;

	// at least one DEMO_START / DEMO_END or FEATURE_x_START / FEATURE_x_END
	// marker is required, so that the license system will be active for
	// the protected application

	// with FEATURE_x markers you can enable some parts of your software
	// depending on the additional key settings

	// it's recommended to enclose encrypted code chunks within
	// some conditional code
	if (IsFeatureEnabled(1) == TRUE)
	{
		// code between those two markers will be encrypted, it won't
		// be available without proper feature settings stored in the key file
		FEATURE_1_START

		SetDlgItemText(hMain, IDC_INFO, "Feature 1 -> enabled");

		dwResult = 1;

		FEATURE_1_END
	}
	else
	{
		SetDlgItemText(hMain, IDC_INFO, "Feature 1 -> disabled");
	}

	return dwResult;
}

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// initialization of main window
		case WM_INITDIALOG:

			// set window's caption
			SetWindowText(hDlg, "PELock Test");

			// call function that make use of a FEATURE_x_START marker
			ExtraFunctionality(hDlg);

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
