////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use antidump PELOCK_MEMORY_GAP macro
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

	// this macro doesn't interfere with your code
	// so you can place it anywhere you want
	PELOCK_MEMORY_GAP

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
}

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// initialization of main window
		case WM_INITDIALOG:

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

	// without the key appliation will not run
	DEMO_START

	DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);

	SaveConfig();

	DEMO_END

	return 0;
}
