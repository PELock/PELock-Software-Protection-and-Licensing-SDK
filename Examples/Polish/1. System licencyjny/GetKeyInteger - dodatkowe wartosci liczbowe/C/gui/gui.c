////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dodatkowe wartosci liczbowe klucza licencyjnego
//
// Wersja         : PELock v2.0
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

char szTemp[256] = { 0 };
unsigned int nNumberOfItems = 0;

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// inicjalizacja glownego okna
		case WM_INITDIALOG:

			// ustaw tytul glownego okna
			SetWindowText(hDlg, "PELock Test");

			// odczytaj wartosc liczbowa, zapisana w kluczu
			DEMO_START

			nNumberOfItems = GetKeyInteger(7);

			sprintf(szTemp, "Ilosc elementow = %u", nNumberOfItems);

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

	// inicjalizuj kontrolki
	InitCommonControlsEx(&iccControls);

	// bez klucza, aplikacja nie wyswietli glownego okna
	DEMO_START

	DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);

	DEMO_END

	return 0;
}
