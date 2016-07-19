////////////////////////////////////////////////////////////////////////////////
//
// Przyklad wykorzystania makr szyfrujacych FILE_CRYPT_START i FILE_CRYPT_END
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

// przykladowa procedura
void SaveConfig(void)
{
	unsigned int i = 0, j = 0;

	// kod pomiedzy makrami FILE_CRYPT_START i FILE_CRYPT_END bedzie zaszyfrowany
	// w zabezpieczonym pliku (jako klucz szyfrujacy uzyty jest dowolny plik)
	FILE_CRYPT_START

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

	FILE_CRYPT_END
}

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// inicjalizacja glownego okna
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

	// inicjalizuj kontrolki
	InitCommonControlsEx(&iccControls);

	// bez klucza, aplikacja nie wyswietli glownego okna
	DEMO_START

	DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);

	SaveConfig();

	DEMO_END

	return 0;
}
