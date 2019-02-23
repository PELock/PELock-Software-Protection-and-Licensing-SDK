////////////////////////////////////////////////////////////////////////////////
//
// Example of how to check if the key is locked to the hardware identifier
//
// Version        : PELock v2.09
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

BOOL bIsKeyHardwareIdLocked = FALSE;
char szInfo[256] = { 0 };

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// initialization of main window, its executed only one time
		// so we can use CLEAR_START and CLEAR_END macros
		case WM_INITDIALOG:

			SetWindowText(hDlg, "PELock Test");

			DEMO_START

			// is the key locked to the hardware identifier
			bIsKeyHardwareIdLocked = IsKeyHardwareIdLocked();

			if (bIsKeyHardwareIdLocked == TRUE)
			{
				sprintf(szInfo, "This key is locked to the hardware identifier!");
			}
			else
			{
				sprintf(szInfo, "This key is NOT locked to the hardware identifier!");
			}

			DEMO_END

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
