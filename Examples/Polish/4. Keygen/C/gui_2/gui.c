////////////////////////////////////////////////////////////////////////////////
//
// Przyklad uzycia biblioteki generatora kluczy licencyjnych
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
#include "keygen.h"

// prototyp funkcji Keygen() z biblioteki KEYGEN.dll
PELOCK_KEYGEN KeygenProc;

HINSTANCE hInst = NULL;
OPENFILENAME lpFn = { 0 };
HWND hDatePicker = NULL;
char szProjectPath[512] = { 0 };

////////////////////////////////////////////////////////////////////////////////
//
// zaladuj biblioteke KEYGEN.dll
//
////////////////////////////////////////////////////////////////////////////////

void InitializeKeygen(void)
{
	HMODULE hKeygen = NULL;

	// zaladuj biblioteke KEYGEN.dll
	hKeygen = LoadLibrary("KEYGEN.dll");

	if (hKeygen != NULL)
	{
		// pobierz adres procedury "Keygen" z biblioteki generatora kluczy
		KeygenProc = (PELOCK_KEYGEN)GetProcAddress(hKeygen, "Keygen");
	}
	else
	{
		// nie udalo sie zaladowac biblioteki, wyswietl informacje o bledzie
		MessageBox(NULL, "Nie mozna zaladowac biblioteki KEYGEN.dll!", "Blad!", MB_ICONEXCLAMATION);

		// zakoncz dzialanie
		ExitProcess(-1);
	}
}

////////////////////////////////////////////////////////////////////////////////
//
// generate license key
//
////////////////////////////////////////////////////////////////////////////////

void GenerateKey(HWND hMain)
{
	unsigned char szUserName[256] = { 0 }, szHardwareId[256] = { 0 }, szLicenseKey[256] = { 0 };
	unsigned int dwUserNameSize = 0, dwHardwareId = 0;

	PBYTE lpKeyData = NULL;
	DWORD dwKeyDataSize = 0;
	HANDLE hFile = NULL;
	DWORD dwWritten = 0;

	DWORD dwResult = 0;
	BOOL bTrans = FALSE;

	KEYGEN_PARAMS kpKeygenParams = { 0 };

	// odczytaj nazwe uzytkownika, dla ktorego generujemy klucz
	dwUserNameSize = GetDlgItemText(hMain, IDC_USER_NAME, szUserName, sizeof(szUserName));

	if (dwUserNameSize != 0)
	{
		// odczytaj dodatkowe dane (sprzetowy identyfikator)
		dwHardwareId = GetDlgItemText(hMain, IDC_HARDWARE_ID, szHardwareId, 16+1);

		// zaalokuj pamiec potrzebna do utworzenia klucza licencyjnego
		lpKeyData = malloc(PELOCK_SAFE_KEY_SIZE);

		///////////////////////////////////////////////////////////////////////////////
		//
		// wypelnij strukture PELOCK_KEYGEN_PARAMS
		//
		///////////////////////////////////////////////////////////////////////////////

		// wskaznik do bufora wyjsciowego na klucz licencyjny (musi byc odpowiednio duzy)
		kpKeygenParams.lpOutputBuffer = lpKeyData;

		// wskaznik do wartosci DWORD, gdzie zostanie zapisany rozmiar wygenerowanego klucza
		kpKeygenParams.lpdwOutputSize = &dwKeyDataSize;

		// wyjsciowy format klucza
		// KEY_FORMAT_BIN - binarny klucz
		// KEY_FORMAT_REG - klucz w formie zrzutu rejestru Windows
		// KEY_FORMAT_TXT - klucz tekstowy (w formacie MIME Base64)
		kpKeygenParams.dwOutputFormat = KEY_FORMAT_BIN;

		// sciezka do odpowiedniego pliku projektu
		kpKeygenParams.lpszProjectPath = szProjectPath;

		// czy uzywamy tekstowego bufora z zawartoscia pliku projektu (zamiast samego pliku projektu)?
		kpKeygenParams.bProjectBuffer = FALSE;

		// czy automatycznie dodac uzytkownika, dla ktorego generowany jest klucz do pliku projektu?
		kpKeygenParams.bUpdateProject = (BOOL)IsDlgButtonChecked(hMain, IDB_UPDATE_PROJECT);

		// wskaznik do wartosci BOOL, gdzie zostanie zapisany status czy udalo sie dodac uzytkownika do pliku projektu
		kpKeygenParams.lpbProjectUpdated = NULL;

		// wskaznik do nazwy uzytkownika (lub innych danych licencyjnych, moga to byc dane binarne etc.)
		kpKeygenParams.lpszUsername = szUserName;

		// rozmiar nazwy uzytkownika lub innych danych licencyjnych (max. 8192 znakow/bajtow)
		kpKeygenParams.dwUsernameLength = dwUserNameSize;

		// czy korzystac z blokady na sprzetowy identyfikator?
		if (dwHardwareId != 0)
		{
			kpKeygenParams.bSetHardwareLock = TRUE;

			// ciag znakow identyfikatora sprzetowego
			kpKeygenParams.lpszHardwareId = szHardwareId;
		}
		else
		{
			kpKeygenParams.bSetHardwareLock = FALSE;
			kpKeygenParams.lpszHardwareId = NULL;
		}

		// czy zaszyfrowac nazwe uzytkownika i dodatkowe pola klucza wedlug identyfikatora sprzetowego
		kpKeygenParams.bSetHardwareEncryption = FALSE;

		// czy ustawic dodatkowe wartosci liczbowe w kluczu licencyjnym
		kpKeygenParams.bSetKeyIntegers = TRUE;

		// 16 dodatkowych wartosci liczbowych, ktore zostana zapisane w kluczu (jesli byla ustawiona flaga)
		kpKeygenParams.dwKeyIntegers[0] = 1;
		kpKeygenParams.dwKeyIntegers[1] = 2;
		kpKeygenParams.dwKeyIntegers[2] = 3;
		kpKeygenParams.dwKeyIntegers[3] = 4;
		kpKeygenParams.dwKeyIntegers[4] = 5;
		kpKeygenParams.dwKeyIntegers[5] = 6;
		kpKeygenParams.dwKeyIntegers[6] = 7;
		kpKeygenParams.dwKeyIntegers[7] = 8;
		kpKeygenParams.dwKeyIntegers[8] = 9;
		kpKeygenParams.dwKeyIntegers[9] = 10;
		kpKeygenParams.dwKeyIntegers[10] = 11;
		kpKeygenParams.dwKeyIntegers[11] = 12;
		kpKeygenParams.dwKeyIntegers[12] = 13;
		kpKeygenParams.dwKeyIntegers[13] = 14;
		kpKeygenParams.dwKeyIntegers[14] = 15;
		kpKeygenParams.dwKeyIntegers[15] = 16;

		// flaga czy ustawic date utworzenia klucza
		kpKeygenParams.bSetKeyCreationDate = TRUE;

		// data utworzenia klucza (SYSTEMTIME)
		GetLocalTime(&kpKeygenParams.stKeyCreation);
		//kpKeygenParams.stKeyCreation.wDay = 01;
		//kpKeygenParams.stKeyCreation.wMonth = 01;
		//kpKeygenParams.stKeyCreation.wYear = 2012;

		// ustaw date wygasniecia klucza
		if (SendMessage(hDatePicker, DTM_GETSYSTEMTIME, 0, (LPARAM)&kpKeygenParams.stKeyExpiration) == GDT_VALID)
		{
			// flaga czy ustawic date wygasniecia klucza
			kpKeygenParams.bSetKeyExpirationDate = TRUE;
		}
		else
		{
			kpKeygenParams.bSetKeyExpirationDate = FALSE;
		}

		// flaga czy ustawic dodatkowe znaczniki bitowe (obsluga m.in. sekcji FEATURE_x_START)
		kpKeygenParams.bSetFeatureBits = TRUE;

		// znaczniki bitowe (w formie 4 wartosci BYTE, ale mozna ustawiac je indywidualnie)
		kpKeygenParams.dwKeyData1 = (BYTE)GetDlgItemInt(hMain, IDC_ADDITIONAL_1, &bTrans, FALSE);
		kpKeygenParams.dwKeyData2 = (BYTE)GetDlgItemInt(hMain, IDC_ADDITIONAL_2, &bTrans, FALSE);
		kpKeygenParams.dwKeyData3 = (BYTE)GetDlgItemInt(hMain, IDC_ADDITIONAL_3, &bTrans, FALSE);
		kpKeygenParams.dwKeyData4 = (BYTE)GetDlgItemInt(hMain, IDC_ADDITIONAL_4, &bTrans, FALSE);

		///////////////////////////////////////////////////////////////////////////////
		//
		// utworz klucz licencyjny
		//
		///////////////////////////////////////////////////////////////////////////////

		dwResult = KeygenProc(&kpKeygenParams);

		switch (dwResult)
		{
		// klucz licencyjny poprawnie wygenerowany
		case KEYGEN_SUCCESS:

			// save key file
			memset(&lpFn, 0, sizeof(OPENFILENAME));

			// copy default license key name
			strcpy(szLicenseKey, "key.lic");

			lpFn.lStructSize = sizeof(OPENFILENAME);
			lpFn.nMaxFile = sizeof(szLicenseKey);
			lpFn.lpstrFile = szLicenseKey;
			lpFn.Flags = OFN_HIDEREADONLY;
			lpFn.lpstrFilter = "PELock License File (key.lic)\0key.lic\0";

			if (GetSaveFileName(&lpFn) != 0)
			{
				// create new file
				hFile = CreateFile(szLicenseKey, GENERIC_READ | GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);

				if (hFile != INVALID_HANDLE_VALUE)
				{
					// save license key data in key.lic file
					if (WriteFile(hFile, lpKeyData, dwKeyDataSize, &dwWritten, NULL) != 0)
					{
						MessageBox(hMain, "Klucz licencyjny zostal poprawnie wygenerowany!", "Info", MB_ICONINFORMATION);
					}
					else
					{
						MessageBox(hMain, "Nie mozna zapisac danych do pliku klucza licencyjnego!", "Blad!", MB_ICONEXCLAMATION);
					}

					// close file handle
					CloseHandle(hFile);
				}
				else
				{
					MessageBox(hMain, "Nie mozna utworzyc pliku klucza licencyjnego!", "Blad!", MB_ICONEXCLAMATION);
				}
			}

			break;

		// nieprawidlowe parametry wejsciowe (lub brakujace parametry)
		case KEYGEN_INVALID_PARAMS:

			MessageBox(hMain, "Niepoprawne parametry wejsciowe (sprawdz strukture PELOCK_KEY_PARAMS)!", "Blad!", MB_ICONEXCLAMATION);
			break;

		// nieprawidlowy plik projektu
		case KEYGEN_INVALID_PROJECT:

			MessageBox(hMain, "Nieprawidlowy plik projektu, byc moze jest on uszkodzony!", "Blad!", MB_ICONEXCLAMATION);
			break;

		// blad alokacji pamieci w procedurze Keygen()
		case KEYGEN_OUT_MEMORY:

			MessageBox(hMain, "Zabraklo pamieci do wygenerowania klucza!", "Blad!", MB_ICONEXCLAMATION);
			break;

		// blad generacji danych klucza licencyjnego
		case KEYGEN_DATA_ERROR:

			MessageBox(hMain, "Wystapil blad podczas generowania danych licencyjnych, prosze skontaktowac sie z autorem!", "Blad!", MB_ICONEXCLAMATION);
			break;

		// nieznane bledy
		default:

			MessageBox(hMain, "Nieznany blad, prosze skontaktowac sie z autorem!", "Blad!", MB_ICONEXCLAMATION);
			break;
		}

		// zwolnij pamiec
		free(lpKeyData);
	}
	else
	{
		MessageBox(hMain, "Wpisz poprawne imie uzytkownika i sprobuj ponownie.", "Niepoprawna nazwa uzytkownika!", MB_ICONEXCLAMATION);
	}
}

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// inicjalizacja okna dialogowego
		case WM_INITDIALOG:

			// ustaw tytul okna
			SetWindowText(hDlg, "PELock Test Generatora Kluczy");

			// utworz kontrolke date pickera
			hDatePicker = CreateWindowEx(	0,
							DATETIMEPICK_CLASS,
							"DateTime",
							WS_BORDER | WS_CHILD | WS_VISIBLE | DTS_SHOWNONE,
							5, 150, 200, 25,
							hDlg,
							NULL,
							hInst,
							NULL);

			// domyslnie wylacz kontrolke
			SendMessage(hDatePicker, DTM_SETSYSTEMTIME, GDT_NONE, 0);

			return TRUE;

		case WM_COMMAND:

			switch (LOWORD (wParam))
			{
				case IDCANCEL:
					EndDialog(hDlg, 0);
					break;

				case IDB_GEN :
					GenerateKey(hDlg);
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

	hInst = hInstance;

	// zaladuj biblioteke KEYGEN.dll
	InitializeKeygen();

	lpFn.lStructSize = sizeof(OPENFILENAME);
	lpFn.nMaxFile = sizeof(szProjectPath);
	lpFn.lpstrFile = szProjectPath;
	lpFn.Flags = OFN_HIDEREADONLY;
	lpFn.lpstrFilter = "Pliki projektu PELocka (*.plk)\0*.plk\0";

	// wybierz plik projektu, na podstawie ktorego zostanie utworzony klucz
	if (GetOpenFileName(&lpFn) != 0)
	{
		DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);
	}

	return 0;
}
