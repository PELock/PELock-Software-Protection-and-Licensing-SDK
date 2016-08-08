////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak sprawdzic obecnosc zabezpieczenia PELock'a
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

			// jesli zabezpieczysz aplikacje, procedury sprawdzajace
			// obecnosc zabezpieczenia ZAWSZE beda zwracaly wartosc True,
			// w przeciwym wypadku oznaczaloby to, ze zabezpieczenie
			// zostalo usuniete z pliku przez jego zlamanie/rozpakowanie
			// i mozesz (powinienes), zrobic jedna z ponizszych rzeczy:
			//
			// - zamknij aplikacje (kiedy nie jest to spodziewane,
			//   skorzystaj z procedur timera)
			// - uszkodz jakis obszar pamieci
			// - zainicjalizuj jakies zmienne blednymi wartosciami
			// - wywolaj wyjatki (RaiseException())
			// - spowoduj blad w obliczeniach (jest to bardzo trudne
			//   do wysledzenia dla osoby, ktora probuje zlamac aplikacje,
			//   jesli taka nie do konca zlamana aplikacja zostanie
			//   opublikowana i tak nie bedzie dzialac poprawnie)
			//
			// - NIE WYSWIETLAJ ZADNYCH INFORMACJI, ZE ZABEZPIECZENIE
			//   ZOSTALO USUNIETE, JEST TO NAJGORSZA RZECZ, KTORA
			//   MOZNA ZROBIC, GDYZ POZWALA TO ZNALEZC ODWOLANIA
			//   DO FUNKCJI SPRAWDZAJACYCH I TYM SAMYM ICH USUNIECIE
			//
			// uzyj wyobrazni :)

			if (IsPELockPresent8() == FALSE)
			{
				// zabezpieczenie PELock'a nie zostalo wykryte
				// zamknij aplikacje
				ExitProcess(1);
			}

			// kod odczytujacy dane o kluczu licencyjnym bedzie zaszyfrowany
			DEMO_START

			// odczytaj dane zarejestrowanego uzytkownika
			GetRegistrationName(szUser, sizeof(szUser));

			// wyswietl dane zarejestrowanego uzytkownika
			SetDlgItemText(hDlg, IDC_REG, szUser);

			// koncowy marker
			DEMO_END

			// sprawdz, czy cokolwiek zostalo skpiowane do bufora
			// z nazwa zarejestrowanego uzytkowniak, jesli nie
			// oznacza to, ze aplikacja jest nadal niezarejestrowana
			if (strlen(szUser) == 0)
			{
				SetDlgItemText(hDlg, IDC_REG, "Niezarejestrowana!");
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
