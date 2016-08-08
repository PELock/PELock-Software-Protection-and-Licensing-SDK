////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dane z klucza licencyjnego (tryb UNICODE)
//
// Wersja         : PELock v2.0
// Jezyk          : C/C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#define UNICODE
#define _UNICODE

#include <windows.h>
#include <commctrl.h>
#include <tchar.h>
#include <stdio.h>
#include <math.h>
#include "gui.h"
#include "pelock.h"

#define _countof(array) (sizeof(array) / sizeof(array[0]))

// bufor, gdzie zostanie odczytana nazwa zarejestrowanego uzytkownika
TCHAR szUser[PELOCK_MAX_USERNAME] = { 0 };

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// inicjalizacja glownego okna
		case WM_INITDIALOG:

			// umiesc kod wykorzystujacy makra w klamrach warunkowych, bez tego,
			// niektore kompilatory C (Pelles C, LCC) wyprodukuja kod, ktory po
			// zabezpieczeniu pliku nie bedzie prawidlowo dzialac, spowodowane
			// jest to specyficzna organizacja stosu w przypadku uzycia makr
			// szyfrujacych
			if (IsPELockPresent1() == 1)
			{
				// kod pomiedzy makrami DEMO_START i DEMO_END bedzie zaszyfrowany
				// w zabezpieczonym pliku i nie bedzie dostepny (wykonany) bez
				// poprawnego klucza licencyjnego
				DEMO_START

				// odczytaj dane zarejestrowanego uzytkownika
				GetRegistrationName(szUser, _countof(szUser));

				// wyswietl dane zarejestrowanego uzytkownika
				SetDlgItemText(hDlg, IDC_REG, szUser);

				// koncowy marker
				DEMO_END
			}

			// sprawdz dlugosc odczytanych danych rejestracyjnych
			// uzytkownika, jesli bedzie = 0, oznaczac to bedzie
			// brak klucza licencyjnego (lub klucz niepoprawny)
			if (_tcslen(szUser) == 0)
			{
				SetDlgItemText(hDlg, IDC_REG, _T("Niezarejestrowany!"));
			}

			// ustaw tytul glownego okna
			SetWindowText(hDlg, _T("PELock Test"));

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

	DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);

	return 0;
}
