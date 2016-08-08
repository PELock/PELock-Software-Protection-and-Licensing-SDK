////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac identyfikator sprzetowy
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
unsigned char szUser[PELOCK_MAX_USERNAME] = { 0 };

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// inicjalizacja glownego okna
		case WM_INITDIALOG:

			// aby w ogole mozna bylo skorzystac z funkcji GetHardwareId()
			// wymagane jest, zeby program zawieral chociaz jedno makro DEMO_START
			// lub FEATURE_x_START, bez tego caly system licencyjny bedzie nieaktywny
			DEMO_START

			// odczytaj dane zarejestrowanego uzytkownika
			GetRegistrationName(szUser, sizeof(szUser));

			// wyswietl dane zarejestrowanego uzytkownika
			SetDlgItemText(hDlg, IDC_REG, szUser);

			// koncowy marker
			DEMO_END

			// wyswietl sprzetowy identyfikator w przypadku, gdy aplikacja
			// nie jest jeszcze zarejestrowana
			if (strlen(szUser) == 0)
			{
				SetDlgItemText(hDlg, IDC_REG, "Aplikacja niezarejestrowana.\nProsze podac ten identyfikator, aby otrzymac klucz licencyjny:");

				// odczytaj identyfikator sprzetowy
				GetHardwareId(szUser, sizeof(szUser));

				// wyswietl identyfikator sprzetowy w okienku edycyjnym
				SetDlgItemText(hDlg, IDC_HARDWARE_ID, szUser);
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
