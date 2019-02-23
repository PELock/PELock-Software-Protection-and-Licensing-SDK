////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak sprawdzic czy klucz jest zablokowany na sprzetowy identyfikator
//
// Wersja         : PELock v2.09
// Jezyk          : C/C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
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
		// inicjalizacja glownego okna, jest wykonywana tylko 1 raz
		// wiec mozna zastosowac makro CLEAR_START
		case WM_INITDIALOG:

			SetWindowText(hDlg, "PELock Test");

			DEMO_START

			// czy klucz jest zablokowany na sprzetowy identyfikator
			bIsKeyHardwareIdLocked = IsKeyHardwareIdLocked();

			if (bIsKeyHardwareIdLocked == TRUE)
			{
				sprintf(szInfo, "Ten klucz jest zablokowany na sprzetowy identyfikator!");
			}
			else
			{
				sprintf(szInfo, "Ten klucz NIE jest zablokowany na sprzetowy identyfikator!");
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

	// inicjalizuj kontrolki
	InitCommonControlsEx(&iccControls);

	CLEAR_START

	DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);

	CLEAR_END

	return 0;
}
