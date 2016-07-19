////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac informacje o statusie klucza licencyjnego
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

int dwKeyStatus = PELOCK_KEY_NOT_FOUND;
char szInfo[256] = { 0 };

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// inicjalizacja glownego okna, jest wykonywana tylko 1 raz
		// wiec mozna zastosowac makro CLEAR_START
		case WM_INITDIALOG:

			SetWindowText(hDlg, "PELock Test");

			// odczytaj informacje o statusie klucza licencyjnego
			dwKeyStatus = GetKeyStatus();

			switch (dwKeyStatus)
			{

			//
			// klucz jest poprawny (wiec kod pomiedzy DEMO_START i DEMO_END powinien sie wykonac)
			//
			case PELOCK_KEY_OK:

				DEMO_START

				sprintf(szInfo, "Klucz licencyjny jest poprawny.");

				DEMO_END

				break;

			//
			// niepoprawny format klucza licencyjnego (uszkodzony)
			//
			case PELOCK_KEY_INVALID:

				sprintf(szInfo, "Klucz licencyjny jest niepoprawny (uszkodzony)!");
				break;

			//
			// klucz znajduje sie na liscie kluczy zablokowanych (kradzionych)
			//
			case PELOCK_KEY_STOLEN:

				sprintf(szInfo, "Klucz jest zablokowany!");
				break;

			//
			// komputer posiada inny identyfikator sprzetowy niz ten uzyty do zabezpieczenia klucza
			//
			case PELOCK_KEY_WRONG_HWID:

				sprintf(szInfo, "Identyfikator sprzetowy tego komputera nie pasuje do klucza licencyjnego!");
				break;

			//
			// klucz licencyjny jest wygasniety (nieaktywny)
			//
			case PELOCK_KEY_EXPIRED:

				sprintf(szInfo, "Klucz licencyjny jest wygasniety!");
				break;

			//
			// nie znaleziono klucza licencyjnego
			//
			case PELOCK_KEY_NOT_FOUND:
			default:

				sprintf(szInfo, "Nie znaleziono klucza licencyjnego.");
				break;
			}

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
