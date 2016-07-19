////////////////////////////////////////////////////////////////////////////////
//
// Przyklad ustawiania klucza licencyjnego, ktory nie znajduje
// sie w glownym katalogu programu
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

// bufor na sciezke do klucza licencyjnego
unsigned char szWindowsPath[512] = { 0 };

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// inicjalizacja glownego okna
		case WM_INITDIALOG:

			// kod pomiedzy makrami DEMO_START i DEMO_END bedzie zaszyfrowany
			// w zabezpieczonym pliku i nie bedzie dostepny (wykonany) bez
			// poprawnego klucza licencyjnego
			DEMO_START

			// odczytaj dane zarejestrowanego uzytkownika
			GetRegistrationName(szUser, sizeof(szUser));

			// wyswietl dane zarejestrowanego uzytkownika
			SetDlgItemText(hDlg, IDC_REG, szUser);

			// koncowy marker
			DEMO_END

			// sprawdz dlugosc odczytanych danych rejestracyjnych
			// uzytkownika, jesli bedzie = 0, oznaczac to bedzie
			// brak klucza licencyjnego (lub klucz niepoprawny)
			if (strlen(szUser) == 0)
			{
				SetDlgItemText(hDlg, IDC_REG, "Niezarejestrowany!");
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

	// przykladowo zakladamy, ze klucz licencyjny musi znajdowac
	// sie w katalogu domowym Windows'a
	GetWindowsDirectory(szWindowsPath, sizeof(szWindowsPath));

	// zbuduj sciezke do pliku licencyjnego
	strcat(szWindowsPath, "\\key.lic");

	// ustaw sciezke do klucza licencyjnego, funkcja zadziala
	// tylko wtedy, gdy wczesniej nie zostal wykryty klucz
	// licencyjny w katalogu z programem lub w rejestrze systemowym
	//
	// aby mozna bylo w ogole skorzystac z tej funkcji, wymagane jest,
	// aby w programie byl umieszczony chociaz 1 marker DEMO_START
	// lub FEATURE_x_START, bez tego caly system licencyjny
	// bedzie nieaktywny
	SetRegistrationKey(szWindowsPath);

	DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);

	return 0;
}
