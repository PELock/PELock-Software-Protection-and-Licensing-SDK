////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac czas wykorzystania klucza
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
SYSTEMTIME stRunTime = { 0 };

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// inicjalizacja glownego okna
		case WM_INITDIALOG:

			// aby moc odczytac czas wykorzystania klucza licencyjnego
			// wymagane jest umieszczenie w programie chociaz jednego makra
			// DEMO_START lub FEATURE_x_START, bez tego system licencyjny nie
			// bedzie w ogole dostepny
			DEMO_START

			// odczytaj dane zarejestrowanego uzytkownika
			GetRegistrationName(szUser, sizeof(szUser));

			// wyswietl dane zarejestrowanego uzytkownika
			SetDlgItemText(hDlg, IDC_REG, szUser);

			// ustaw timer do wyswietlania czasu wykorzystania klucza
			SetTimer(hDlg, 1, 1000, NULL);

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

		// wyswietl czas wykorzystania klucza
		case WM_TIMER:

			// odczytaj czas wykorzystania klcuza (odkad zostal ustawiony)
			if (GetKeyRunningTime(&stRunTime) == 1)
			{
				wsprintf(szUser,"%lu godzin %lu minut %lu sekund", stRunTime.wHour, stRunTime.wMinute, stRunTime.wSecond);
			}
			else
			{
				strcpy(szUser, "n/a");
			}

			SetDlgItemText(hDlg, IDC_RUN_TIME, szUser);

			return FALSE;

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
