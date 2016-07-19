////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use UNREGISTERED_START and UNREGISTERED_END macros
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

// example procedure
void SaveConfig(void)
{
	unsigned int i = 0, j = 0;

	DEMO_START

	j = 1;

	for (i = 0; i < 10; i++)
	{
		j += i;
	}

	j = 5;

	j = 3;

	if (j == 3)
	{
		i = 1;
	}
	else
	{
		i = 0;
	}

	DEMO_END

}

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// initialization of main window
		case WM_INITDIALOG:

			// set window's caption
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

	// display a message in unregistered version
	//
	// you need to put at least one DEMO_START or FEATURE_x_START
	// encryption macro in order to use UNREGISTERED_START macros
	UNREGISTERED_START

	MessageBox(NULL, "This is an unregistered version, please buy a full version!", "PELock Test", MB_ICONWARNING);

	UNREGISTERED_END

	// without the key application won't show the main dialog
	DEMO_START

	DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);

	SaveConfig();

	DEMO_END

	return 0;
}
