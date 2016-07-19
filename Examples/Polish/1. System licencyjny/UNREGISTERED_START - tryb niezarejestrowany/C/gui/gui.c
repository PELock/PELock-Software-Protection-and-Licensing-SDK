////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak uzywac makra szyfrujace UNREGISTERED_START i UNREGISTERED_END
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

	// kod pomiedzy makrami DEMO_START i DEMO_END bedzie zaszyfrowany
	// w zabezpieczonym pliku i nie bedzie dostepny (wykonany) bez
	// poprawnego klucza licencyjnego
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
		// inicjalizacja glownego okna
		case WM_INITDIALOG:

			// ustaw tytul glownego okna
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

	// wyswietl komunikat w niezarejestrowanej wersji programu
	//
	// nalezy umiescic przynajmniej jedno makro DEMO_START lub FEATURE_x_START,
	// aby mozna bylo skorzystac z makr UNREGISTERED_START
	UNREGISTERED_START

	MessageBox(NULL, "To jest wersja niezarejestrowana, prosze zakupic pelna wersje!", "PELock Test", MB_ICONWARNING);

	UNREGISTERED_END
	
	// bez klucza, aplikacja nie wyswietli glownego okna
	DEMO_START

	DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);

	SaveConfig();

	DEMO_END

	return 0;
}
