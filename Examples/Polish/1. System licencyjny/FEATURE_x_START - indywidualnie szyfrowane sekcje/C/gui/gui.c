////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak uzyc makr szyfrujacych systemu licencyjnego FEATURE_x_START
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

int ExtraFunctionality(HWND hMain)
{
	int dwResult = 0;

	// przynajmniej jedno makro DEMO_START / DEMO_END i/lub FEATURE_x_START / FEATURE_x_END
	// jest wymagane, aby system licencyjny byl w ogole aktywny

	// markery szyfrujace FEATURE_x moga byc uzyte, aby umozliwic dostep tylko do niektorych
	// opcji programu w zaleznosci od ustawien klucza licencyjnego

	// zalecane jest umieszczanie markerow szyfrujacych bezposrednio pomiedzy klamrami
	// warunkowymi, tutaj idealnie nadaje sie procedura IsFeatureEnabled(), ktora
	// sprawdzi, czy odpowiedni bit opcji byl ustawiony
	if (IsFeatureEnabled(1) == TRUE)
	{
		// kod pomiedzy tymi markermi bedzie zaszyfrowany i nie bedzie dostepny
		// bez poprawnego klucza licencyjnego, ani bez odpowiednio ustawionych bitow
		// opcji zapisanych w kluczu licencyjnym
		FEATURE_1_START

		SetDlgItemText(hMain, IDC_INFO, "Opcja 1 -> wlaczona");

		dwResult = 1;

		FEATURE_1_END
	}
	else
	{
		SetDlgItemText(hMain, IDC_INFO, "Opcja 1 -> wylaczona");
	}

	return dwResult;
}

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// inicjalizacja glownego okna
		case WM_INITDIALOG:

			// ustaw tytul glownego okna
			SetWindowText(hDlg, "PELock Test");

			// wywolaj funkcje korzystajaca z makr FEATURE_x_START
			ExtraFunctionality(hDlg);

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

	// bez klucza, aplikacja nie wyswietli glownego okna
	DEMO_START

	DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);

	DEMO_END

	return 0;
}
