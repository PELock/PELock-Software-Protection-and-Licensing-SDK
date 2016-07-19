////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak uzyc wbudowanych funkcji szyfrujacych (szyfr strumieniowy)
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

void EncryptDataTest(HWND hDlg)
{
	unsigned char szSecretData[] = "SEKRET";
	unsigned char szKey[] = "987654321";

	//
	// Algorytm szyfrujacy jest staly i nie bedzie zmieniany
	// w przyszlosci, wiec mozna bez obaw szyfrowac wszelkiego
	// rodzaju dane aplikacji jak pliki konfiguracyjne, bazy danych etc.
	//
	MessageBox(hDlg, szSecretData, "Niezaszyfrowany string", MB_OK);

	// encrypt data
	EncryptData(szKey, sizeof(szKey), szSecretData, sizeof(szSecretData));

	MessageBox(hDlg, szSecretData, "Zaszyfrowany string", MB_OK);

	// decrypt data
	DecryptData(szKey, sizeof(szKey), szSecretData, sizeof(szSecretData));

	MessageBox(hDlg, szSecretData, "Odszyfrowany string", MB_OK);
}

void EncryptMemoryTest(HWND hDlg)
{
	unsigned char szSecretData[] = "SEKRET";

	//
	// Szyfruj i deszyfruj pamiec w tym samym procesie. Aplikacja
	// uruchomiona w innym procesie nie bedzie w stanie odszyfrowac
	// danych.
	//
	MessageBox(hDlg, szSecretData, "Niezaszyfrowany string (testowanie szyfrowania bez klucza)", MB_OK);

	// encrypt data
	EncryptMemory(szSecretData, sizeof(szSecretData));

	MessageBox(hDlg, szSecretData, "Zaszyfrowany string (szyfrowanie bez klucza)", MB_OK);

	// decrypt data
	DecryptMemory(szSecretData, sizeof(szSecretData));

	MessageBox(hDlg, szSecretData, "Odszyfrowany string (deszyfrowania bez klucza)", MB_OK);
}

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// initialization of main window
		case WM_INITDIALOG:

			SetWindowText(hDlg, "PELock Test");

			return TRUE;

		case WM_COMMAND:

			switch (LOWORD (wParam))
			{
				case IDB_ENCRYPT_DATA:

					EncryptDataTest(hDlg);
					break;

				case IDB_ENCRYPT_MEMORY:

					EncryptMemoryTest(hDlg);
					break;

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
