////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac date wygasniecia klucza (o ile byla ustawiona)
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

// bufor, gdzie zostanie odczytana nazwa zarejestrowanego uzytkownika
unsigned char szUser[256] = { 0 };
SYSTEMTIME stSysTime = { 0 };

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// inicjalizacja glownego okna
		case WM_INITDIALOG:

			// aby moc odczytac date wygasniecia klucza licencyjnego potrzebny
			// wymagane jest umieszczenie w programie chociaz jednego makra
			// DEMO_START lub FEATURE_x_START, bez tego system licencyjny nie
			// bedzie w ogole dostepny
			DEMO_START

			// odczytaj dane zarejestrowanego uzytkownika
			GetRegistrationName(szUser, sizeof(szUser));

			// wyswietl dane zarejestrowanego uzytkownika
			SetDlgItemText(hDlg, IDC_REG, szUser);

			// odczytaj date wygasniecia klucza (jesli byla w ogole ustawiona)
			// dane sa odczytywane do struktury SYSTEMTIME i wykorzystane sa
			// tylko pola dzien/miesiac/rok
			if (GetKeyExpirationDate(&stSysTime) == 1)
			{
				wsprintf(szUser, "%lu-%lu-%lu (dd.mm.yy)", stSysTime.wDay, stSysTime.wMonth, stSysTime.wYear);
			}
			else
			{
				strcpy(szUser, "n/a");
			}

			SetDlgItemText(hDlg, IDC_EXP, szUser);

			// koncowy marker
			DEMO_END

			// sprawdz dlugosc odczytanych danych rejestracyjnych
			// uzytkownika, jesli bedzie = 0, oznaczac to bedzie
			// brak klucza licencyjnego (lub klucz niepoprawny)
			if (strlen(szUser) == 0)
			{
				SetDlgItemText(hDlg, IDC_REG, "Wersja niezarejestrowana!");
			}

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

	DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);

	return 0;
}
