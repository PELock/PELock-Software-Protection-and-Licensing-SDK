////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak wykorzystac procedure callback systemu ograniczenia czasowego
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

HWND hMainDialog = NULL;

//
// wstaw do tej procedury kod konczacy program, zamykajacy uchwyty itp.
//
// zwracane wartosci:
//
// 1 - aplikacja zostanie zamknieta
// 0 - aplikacja bedzie dzialac, nawet mimo przekroczenia czasu testowego
//
int TrialExpired()
{
	// to makro musi znajdowac sie na poczatku procedury callback
	TRIAL_EXPIRED

	MessageBox(hMainDialog, "Ta aplikacja wygasla, prosze zakupic pelna wersje!", "Uwaga", MB_ICONWARNING);

	// mozna samemu zakonczyc aplikacje lub pozostawic to loaderowi PELock'a,
	// aby zamknac aplikacje, zwroc wartosc 1
	ExitProcess(1);

	return 1;
}

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// inicjalizacja glownego okna, jest wywolywana tylko raz
		// dlatego mozna skorzystac z makr CLEAR_START i CLEAR_END
		case WM_INITDIALOG:

			// kod pomiedzy makrami CLEAR_START i CLEAR_END zostanie
			// wykonany, po czym wymazany z pamieci
			CLEAR_START

			SetWindowText(hDlg, "PELock Test");

			hMainDialog = hDlg;

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
