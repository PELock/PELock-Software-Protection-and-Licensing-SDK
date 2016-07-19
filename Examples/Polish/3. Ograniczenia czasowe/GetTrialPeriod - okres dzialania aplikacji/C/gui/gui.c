////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dane o ograniczeniu czasowym (okres testowy)
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

SYSTEMTIME stPeriodEnd = { 0 };
int dwTrialStatus = PELOCK_TRIAL_ABSENT;
char szInfo[256] = { 0 };

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	// marker punktu kontrolnego, przykladowe uzycie
	PELOCK_CHECKPOINT

	switch (uMsg)
	{
		// inicjalizacja glownego okna, jest wykonywana tylko 1 raz
		// wiec mozna zastosowac makro CLEAR_START
		case WM_INITDIALOG:

			// kod pomiedzy CLEAR_START i CLEAR_END zostanie wykonany,
			// a nastepnie wymazany z pamieci
			CLEAR_START

			SetWindowText(hDlg, "PELock Test");

			// odczytaj stan ograniczenia czasowego (jedynie date wygasniecia)
			dwTrialStatus = GetTrialPeriod(NULL, &stPeriodEnd);

			switch (dwTrialStatus)
			{

			//
			// system ograniczenia czasowego jest aktywny
			//
			case PELOCK_TRIAL_ACTIVE:

				sprintf(szInfo, "Aplikacja wygasnie %u/%u/%u.", stPeriodEnd.wDay, stPeriodEnd.wMonth, stPeriodEnd.wYear);
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
