////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak ustawic wlasna procedure callback identyfikatora sprzetowego,
// wykorzystujac makro HARDWARE_ID_CALLBACK
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

//
// wlasna procedura callback identyfikatora sprzetowego
//
// zwracane wartosci:
//
// 1 - identyfikator sprzetowy poprawnie wygenerowany
// 0 - wystapil blad, przykladowo klucz sprzetowy nie
//     byl obecny), nalezy zauwazyc, ze w tej sytuacji
//     wszystkie wywolania do GetHardwareId() oraz
//     procedur ustawiajacych badz przeladowujacych klucz
//     zablokowany na sprzetowy identyfikator nie beda
//     funkcjonowaly (beda zwracane kody bledow)
//
int CustomHardwareId(unsigned char cOutput[8])
{
	int i = 0;

	// ten marker bedzie uzyty do zlokalizowania procedury CustomHardwareId()
	// (nalezy wczesniej wlaczyc odpowiednia opcje w zakladce SDK)
	HARDWARE_ID_CALLBACK

	//
	// kopiuj wlasny identyfikator sprzetowy do wyjsciowego bufora (8 bajtow)
	//
	// identyfikator sprzetowy moze byc utworzony z:
	//
	// - identyfikatora klucza sprzetowego (dongle)
	// - informacji z systemu operacyjnego
	// - etc.
	//
	for (i = 0; i < 8 ; i++)
	{
		cOutput[i] = i + 1;
	}

	// zwroc 1, co oznacza sukces
	return 1;
}

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
