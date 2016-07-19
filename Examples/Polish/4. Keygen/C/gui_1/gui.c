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
// generowanie klucza licencyjnego
//
////////////////////////////////////////////////////////////////////////////////

void GenerateKey(HWND hMain)
{
	unsigned char szUserName[256] = { 0 }, szLicensePath[512] = { 0 };
	unsigned int dwUserNameSize = 0;
	DWORD dwResult = 0, dwKeyDataSize = 0;
	PBYTE lpKeyData = NULL;
	HANDLE hFile = 0;
	DWORD dwWritten = 0;
	KEYGEN_PARAMS kpKeygenParams = { 0 };

	// odczytaj nazwe uzytkownika, dla ktorego generujemy klucz
	dwUserNameSize = GetDlgItemText(hMain, IDC_USER_NAME, szUserName, sizeof(szUserName));

	if (dwUserNameSize != 0)
	{
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
		kpKeygenParams.dwOutputFormat = KEY_FORMAT_REG;

		// sciezka do odpowiedniego pliku projektu
		kpKeygenParams.lpszProjectPath = szProjectPath;

		// czy uzywamy tekstowego bufora z zawartoscia pliku projektu (zamiast samego pliku projektu)?
		kpKeygenParams.bProjectBuffer = FALSE;

		// czy automatycznie dodac uzytkownika, dla ktorego generowany jest klucz do pliku projektu?
		kpKeygenParams.bUpdateProject = FALSE;

		// wskaznik do wartosci BOOL, gdzie zostanie zapisany status czy udalo sie dodac uzytkownika do pliku projektu
		kpKeygenParams.lpbProjectUpdated = NULL;

		// wskaznik do nazwy uzytkownika (lub innych danych licencyjnych, moga to byc dane binarne etc.)
		kpKeygenParams.lpszUsername = szUserName;

		// rozmiar nazwy uzytkownika lub innych danych licencyjnych (max. 8192 znakow/bajtow)
		kpKeygenParams.dwUsernameLength = dwUserNameSize;

		// flaga czy korzystac z blokady na sprzetowy identyfikator?
		kpKeygenParams.bSetHardwareLock = FALSE;

		// czy zaszyfrowac nazwe uzytkownika i dodatkowe pola klucza wedlug identyfikatora sprzetowego
		kpKeygenParams.bSetHardwareEncryption = FALSE;

		// ciag znakow identyfikatora sprzetowego
		kpKeygenParams.lpszHardwareId = NULL;

		// czy ustawic dodatkowe wartosci liczbowe w kluczu licencyjnym
		kpKeygenParams.bSetKeyIntegers = FALSE;

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

		// flaga czy ustawic date wygasniecia klucza
		kpKeygenParams.bSetKeyExpirationDate = FALSE;

		// data wygasniecia klucza
		//kpKeygenParams.stKeyExpiration.wDay = 01;
		//kpKeygenParams.stKeyExpiration.wMonth = 01;
		//kpKeygenParams.stKeyExpiration.wYear = 2012;

		// flaga czy ustawic dodatkowe znaczniki bitowe (obsluga m.in. sekcji FEATURE_x_START)
		kpKeygenParams.bSetFeatureBits = FALSE;

		// znaczniki bitowe (w formie wartosci DWORD, ale mozna ustawiac je indywidualnie)
		kpKeygenParams.dwFeatureBits = 0xFFFFFFFF;

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

			// zbuduj sciezke, gdzie zostanie zapisany plik klucza
			GetModuleFileName(NULL, szLicensePath, sizeof(szLicensePath));
			*(strrchr(szLicensePath, '\\') + 1) = '\0';

			// dodaj nazwe katalogu do sciezki (taka sama jak nazwa uzytkownika)
			strcat(szLicensePath, szUserName);

			// utworz nowy katalog, gdzie zostanie zapisany plik licencyjny
			CreateDirectory(szLicensePath, NULL);

			// ustaw biezacy katalog
			SetCurrentDirectory(szLicensePath);

			// ustaw nazwe pliku licencyjnego
			strcpy(szLicensePath, "key.reg");

			// utworz plik klucza licencyjnego (nadpisuj istniejace pliki)
			hFile = CreateFile(szLicensePath, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_ARCHIVE, NULL);

			if (hFile != INVALID_HANDLE_VALUE)
			{
				// zapisz dane licencyjne do pliku
				WriteFile(hFile, lpKeyData, dwKeyDataSize, &dwWritten, NULL);

				// zamknij uchwyt pliku
				CloseHandle(hFile);

				MessageBox(hMain, "Klucz licencyjny zostal poprawnie wygenerowany!", "Info", MB_ICONINFORMATION);
			}
			else
			{
				MessageBox(hMain, "Nie mozna utworzyc pliku klucza licencyjnego!", "Blad!", MB_ICONEXCLAMATION);
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

	memset(&lpFn, 0, sizeof(OPENFILENAME));

	lpFn.lStructSize = sizeof(OPENFILENAME);

	lpFn.nMaxFile = sizeof(szProjectPath);
	lpFn.lpstrFile = szProjectPath;
	lpFn.Flags = OFN_HIDEREADONLY;
	lpFn.lpstrFilter = "Pliki projektu PELocka (*.plk)\0*.plk\0";

	// wybierz plik projektu, na podstawie ktorego zostanie utworzony klucz
	if (GetOpenFileName(&lpFn) != 0)
	{
		// wyswietl glowne okno dialogowe
		DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);
	}

	return 0;
}
