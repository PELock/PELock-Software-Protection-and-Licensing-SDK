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
#include <stdio.h>
#include <conio.h>
#include "keygen.h"

// prototyp funkcji Keygen() z biblioteki KEYGEN.dll
PELOCK_KEYGEN KeygenProc;

///////////////////////////////////////////////////////////////////////////////
//
// wyswietl komunikat bledu i zaczekaj, az uzytkownik nacisnie dowolny klawisz
//
///////////////////////////////////////////////////////////////////////////////

void print_error(const char *lpszErrorMessage)
{
	if (lpszErrorMessage)
	{
		printf(lpszErrorMessage);
	}

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();
}

///////////////////////////////////////////////////////////////////////////////
//
// czyta zawartosc pliku tekstowego
//
///////////////////////////////////////////////////////////////////////////////

char *read_text_file(const char *lpszFilePath)
{
	FILE *hFile = NULL;
	char *lpszMemoryBuffer = NULL;
	DWORD dwFileSize = 0;

	hFile = fopen(lpszFilePath, "rb");

	if (hFile != NULL)
	{
		fseek(hFile, 0, SEEK_END);

		dwFileSize = ftell(hFile);

		if (dwFileSize != 0)
		{
			lpszMemoryBuffer = calloc(dwFileSize + 1, 1);

			if (lpszMemoryBuffer != NULL)
			{
				fseek(hFile, 0, SEEK_SET);

				if (fread(lpszMemoryBuffer, 1, dwFileSize, hFile) != dwFileSize)
				{
					free(lpszMemoryBuffer);
					lpszMemoryBuffer = NULL;
				}
			}
		}

		fclose(hFile);
	}

	return lpszMemoryBuffer;
}

///////////////////////////////////////////////////////////////////////////////
//
// poczatek
//
///////////////////////////////////////////////////////////////////////////////

int main(int argc, char *argv[])
{
	HMODULE hKeygen = NULL;
	char szProjectPath[512] = { 0 };
	char *lpszProjectBuffer = NULL;

	FILE *hKey = NULL;
	char *lpKeyData = NULL;
	DWORD dwKeyDataSize = 0;

	KEYGEN_PARAMS kpKeygenParams = { 0 };

	DWORD dwResult = 0;

	///////////////////////////////////////////////////////////////////////////////
	//
	// zaladuj biblioteke KEYGEN.dll
	//
	///////////////////////////////////////////////////////////////////////////////

	hKeygen = LoadLibrary("KEYGEN.dll");

	// sprawdz uchwyt biblioteki
	if (hKeygen == NULL)
	{
		print_error("Nie mozna zaladowac biblioteki KEYGEN.dll!");
		return 1;
	}

	// pobierz adres procedury "Keygen" z biblioteki generatora kluczy
	KeygenProc = (PELOCK_KEYGEN)GetProcAddress(hKeygen, "Keygen");

	if (KeygenProc == NULL)
	{
		print_error("Nie mozna znalezc procedury Keygen() w bibliotece KEYGEN.dll!");
		return 1;
	}

	///////////////////////////////////////////////////////////////////////////////
	//
	// zbuduj sciezke do pliku projektu, w ktorym zapisane sa klucze szyfrujace
	//
	///////////////////////////////////////////////////////////////////////////////

	GetModuleFileName(NULL, szProjectPath, sizeof(szProjectPath));

	*(strrchr(szProjectPath, '\\') + 1) = '\0';

	strcat(szProjectPath, "test.plk");

	///////////////////////////////////////////////////////////////////////////////
	//
	// odczytaj plik projektu do bufora pamieci
	//
	///////////////////////////////////////////////////////////////////////////////

	lpszProjectBuffer = read_text_file(szProjectPath);

	if (lpszProjectBuffer == NULL)
	{
		print_error("Nie mozna odczytac pliku projektu!");
		return 1;
	}

	///////////////////////////////////////////////////////////////////////////////
	//
	// zaalokuj pamiec potrzebna do utworzenia klucza licencyjnego
	//
	///////////////////////////////////////////////////////////////////////////////

	lpKeyData = malloc(PELOCK_SAFE_KEY_SIZE);

	if (lpKeyData == NULL)
	{
		free(lpszProjectBuffer);

		print_error("Nie mozna zaalokowac pamieci!");
		return 1;
	}

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
	//kpKeygenParams.lpszProjectPath = szProjectPath;

	// bufor tekstowy z zawartoscia pliku projektu
	kpKeygenParams.lpszProjectBuffer = lpszProjectBuffer;

	// czy uzywamy tekstowego bufora z zawartoscia pliku projektu (zamiast samego pliku projektu)?
	kpKeygenParams.bProjectBuffer = TRUE;

	// czy automatycznie dodac uzytkownika, dla ktorego generowany jest klucz do pliku projektu?
	kpKeygenParams.bUpdateProject = FALSE;

	// wskaznik do wartosci BOOL, gdzie zostanie zapisany status czy udalo sie dodac uzytkownika do pliku projektu
	kpKeygenParams.lpbProjectUpdated = NULL;

	// wskaznik do nazwy uzytkownika (lub innych danych licencyjnych, moga to byc dane binarne etc.)
	kpKeygenParams.lpszUsername = "Laura Palmer";

	// rozmiar nazwy uzytkownika lub innych danych licencyjnych (max. 8192 znakow/bajtow)
	kpKeygenParams.dwUsernameLength = strlen("Laura Palmer");

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

		// zapisz dane klucza licencyjnego do pliku key.lic
		switch (kpKeygenParams.dwOutputFormat)
		{
		case KEY_FORMAT_BIN: hKey = fopen("key.lic", "wb+"); break;
		case KEY_FORMAT_REG: hKey = fopen("key.reg", "wb+"); break;
		case KEY_FORMAT_TXT: hKey = fopen("key.txt", "wb+"); break;
		}

		if (hKey != NULL)
		{
			// zapisz plik
			fwrite(lpKeyData, dwKeyDataSize, 1, hKey);

			// zamknij uchwyt pliku
			fclose(hKey);

			printf("Klucz licencyjny zostal poprawnie wygenerowany!");
		}
		else
		{
			printf("Nie mozna utworzyc pliku klucza licencyjnego!");
		}

		break;

	// nieprawidlowe parametry wejsciowe (lub brakujace parametry)
	case KEYGEN_INVALID_PARAMS:

		printf("Niepoprawne parametry wejsciowe (sprawdz strukture PELOCK_KEY_PARAMS)!");
		break;

	// nieprawidlowy plik projektu
	case KEYGEN_INVALID_PROJECT:

		printf("Nieprawidlowy plik projektu, byc moze jest on uszkodzony!");
		break;

	// blad alokacji pamieci w procedurze Keygen()
	case KEYGEN_OUT_MEMORY:

		printf("Zabraklo pamieci do wygenerowania klucza!");
		break;

	// blad generacji danych klucza licencyjnego
	case KEYGEN_DATA_ERROR:

		printf("Wystapil blad podczas generowania danych licencyjnych, prosze skontaktowac sie z autorem!");
		break;

	// nieznane bledy
	default:

		printf("Nieznany blad, prosze skontaktowac sie z autorem!");
		break;
	}

	// zwolnij pamiec
	free(lpszProjectBuffer);
	free(lpKeyData);

	print_error(NULL);

	return 0;
}
