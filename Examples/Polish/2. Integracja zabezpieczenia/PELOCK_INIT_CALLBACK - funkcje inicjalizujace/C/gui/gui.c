////////////////////////////////////////////////////////////////////////////////
//
// Przyklad uzycia makr dla funkcji inicjalizujacych PELOCK_INIT_CALLBACK
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

static int dwSecretValue1 = 0;
static int dwSecretValue2 = 0;
static char cTemp[128] = { 0 };

//
// funkcje inicjalizujace sa wywolywane tylko raz po uruchomieniu
// aplikacji, moga byc uzywane do inicjalizacji waznych wartosci,
// sa one wywolywane tylko w przypadku zabezpieczonych aplikacji,
// wiec jesli zabezpiecznie zostanie usuniete, te funkcje nie
// zostana wywolane (dodatkowa ochrona przed rozpakowaniem kodu)
//
// funkcje inicjalizujace musza byc gdzies uzywane w kodzie, aby
// kompilator w trakcie optymalizacji ich nie usunal (co zdarza
// sie w wiekszosci przypadkow, gdy kompilator napotka nieuzywane
// funkcje), mozna w takim przypadku skorzystac z prostej sztuczki
// sprawdzajac w dowolnym miejscu aplikacji wskaznik do funkcji
// inicjalizujacej np.:
//
// if ((&pelock_initalization_callback_1 == NULL) return 0;
//
// nalezy rowniez pamietac, ze te funkcje sa wywolywane przed
// kodem inicjalizujacym aplikacje, wiec jesli twoja aplikacja
// polega na dodatkowych bibliotekach (statycznych lub
// dynamicznych), ktore same wymagaja inicjalizacji, upewnij
// sie, zeby funkcje oznaczone PELOCK_INIT_CALLBACK byly proste
// i nie wykorzystywaly dodatkowych bibliotek i ich funkcji
//
void pelock_initalization_callback_1(HINSTANCE hInstance, DWORD dwReserved)
{
	// znacznik funkcji inicjalizujacej
	PELOCK_INIT_CALLBACK

	// funkcje inicjalizujace sa wywolywane tylko jeden raz,
	// wiec mozna dodatkowo wymazac ich kod po wykonaniu,
	// korzystajac z makr CLEAR_START i CLEAR_END
	CLEAR_START

	dwSecretValue1 = 2;

	CLEAR_END
}

//
// druga funkcja inicjalizujaca, mozna umiescic dowolna liczbe funkcji inicjalizujacych
//
void pelock_initalization_callback_2(HINSTANCE hInstance, DWORD dwReserved)
{
	// znacznik funkcji inicjalizujacej
	PELOCK_INIT_CALLBACK

	// funkcje inicjalizujace sa wywolywane tylko jeden raz,
	// wiec mozna dodatkowo wymazac ich kod po wykonaniu,
	// korzystajac z makr CLEAR_START i CLEAR_END
	CLEAR_START

	dwSecretValue2 = 2;

	CLEAR_END
}

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// inicjalizacja glownego okna
		case WM_INITDIALOG:

			wsprintf(cTemp, "Wynik obliczenia 2 + 2 = %lu\n", dwSecretValue1 + dwSecretValue2);

			SetDlgItemText(hDlg, IDC_INFO, cTemp);

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

	// ochrona przed optymalizacjami kompilatora
	if ( (&pelock_initalization_callback_1 == NULL) || (&pelock_initalization_callback_2 == NULL) )
	{
		return 0;
	}

	return 0;
}
