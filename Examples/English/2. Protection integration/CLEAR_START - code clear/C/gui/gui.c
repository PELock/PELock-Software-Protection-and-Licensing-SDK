////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use CLEAR_START and CLEAR_END macros
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

	CRYPT_START

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

	CRYPT_END
}

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

	SaveConfig();

	return 0;
}
