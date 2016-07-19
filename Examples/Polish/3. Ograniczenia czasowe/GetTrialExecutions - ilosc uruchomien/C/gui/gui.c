////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dane o ograniczeniu czasowym (ilosc uruchomien)
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

int dwRunsLeft = 0;
int dwTrialStatus = PELOCK_TRIAL_ABSENT;
char szInfo[256] = { 0 };

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// inicjalizacja glownego okna, jest wykonywana tylko 1 raz
		// wiec mozna zastosowac makro CLEAR_START
		case WM_INITDIALOG:

			// kod pomiedzy CLEAR_START i CLEAR_END zostanie wykonany,
			// a nastepnie wymazany z pamieci
			CLEAR_START

			SetWindowText(hDlg, "PELock Test");

			// read time trial information (read number of days left only)
			dwTrialStatus = GetTrialExecutions(NULL, &dwRunsLeft);

			switch (dwTrialStatus)
			{

			//
			// system ograniczenia czasowego jest aktywny
			//
			case PELOCK_TRIAL_ACTIVE:

				sprintf(szInfo, "Trial version, %u executions left.", dwRunsLeft);
				break;

			//
			// okres testowy wygasl, wyswietl wlasna informacje i zamknij aplikacje
			// kod zwracany tylko jesli bedzie wlaczona byla opcja
			// "Pozwol aplikacji na dzialanie po wygasnieciu" w przeciwnym wypadku
			// aplikacja jest automatycznie zamykana
			//
			case PELOCK_TRIAL_EXPIRED:

				sprintf(szInfo, "Ta aplikacja wygasla i bedzie zamknieta!");
				break;

			//
			// ograniczenia czasowe nie sa wlaczone dla tej aplikacji
			// lub aplikacja zostala zarejestrowana
			//
			case PELOCK_TRIAL_ABSENT:
			default:

				sprintf(szInfo, "Brak ograniczen czasowych lub aplikacja zostala zarejestrowana.");
				break;
			}

			SetDlgItemText(hDlg, IDC_INFO, szInfo);

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

	// inicjalizuj kontrolki
	InitCommonControlsEx(&iccControls);

	CLEAR_START

	DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);

	CLEAR_END

	return 0;
}
