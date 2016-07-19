////////////////////////////////////////////////////////////////////////////////
//
// Przyklad uzycia makr punktow kontrolnych PELOCK_CPUID
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

//
// wstawiaj makra PELOCK_CPUID w rzadko uzywanych procedurach
// co spowoduje, ze znalezienie tych makr bedzie bardzo trudne
// dla kogos, kto bedzie probowal zlamac zabezpieczona aplikacje
//

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// inicjalizacja glownego okna
		case WM_INITDIALOG:

			//
			// makra punktow kontrolnych w zaden sposob nie zaklocaja
			// pracy aplikacji, jesli jednak ktos bedzie chcial uruchomic
			// zlamana lub rozpakowana aplikacje, kod makra PELOCK_CPUID
			// wywola wyjatek, tak ze zlamana/rozpakowana aplikacja nie
			// bedzie w efekcie dzialac poprawnie (nie bedzie funkcjonalna)
			//
			PELOCK_CPUID

			SetWindowText(hDlg, "PELock Test");

			return TRUE;

		case WM_COMMAND:

			switch (LOWORD (wParam))
			{
				case IDCANCEL:

					// mozesz ich uzywac w dowolnych punktach programu
					PELOCK_CPUID

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
