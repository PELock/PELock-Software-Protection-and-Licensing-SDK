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

// prototyp funkcji VerifyKey() z biblioteki KEYGEN.dll
PELOCK_VERIFY_KEY VerifyKeyProc;

static char *lpszKeyFormats[] = { "KEY_FORMAT_BIN", "KEY_FORMAT_REG", "KEY_FORMAT_TXT" };

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
// poczatek
//
///////////////////////////////////////////////////////////////////////////////

int main(int argc, char *argv[])
{
	HMODULE hKeygen = NULL;
	char szProjectPath[512] = { 0 };

	FILE *hKey = NULL;
	char *lpKeyData = NULL;
	DWORD dwKeyDataSize = 0;

	KEYGEN_PARAMS kpKeygenParams = { 0 };
	KEYGEN_VERIFY_PARAMS kvpKeygenVerifyParams = { 0 };

	DWORD dwResult = 0;
	DWORD dwVerifyResult = 0;

	char szUsername[256] = { 0 };

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

	// pobierz adres procedury "VerifyKey" z biblioteki generatora kluczy
	VerifyKeyProc = (PELOCK_VERIFY_KEY)GetProcAddress(hKeygen, "VerifyKey");

	if (VerifyKeyProc == NULL)
	{
		print_error("Nie mozna znalezc procedury VerifyKey() w bibliotece KEYGEN.dll!");
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
	// zaalokuj pamiec potrzebna do utworzenia klucza licencyjnego
	//
	///////////////////////////////////////////////////////////////////////////////

	lpKeyData = malloc(PELOCK_SAFE_KEY_SIZE);

	if (lpKeyData == NULL)
	{
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
	kpKeygenParams.lpszProjectPath = szProjectPath;

	// czy uzywamy tekstowego bufora z zawartoscia pliku projektu (zamiast samego pliku projektu)?
	kpKeygenParams.bProjectBuffer = FALSE;

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
	kpKeygenParams.bSetFeatureBits = TRUE;

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

		// zapisz dane klucza licencyjnego do pliku
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

			//
			// zweryfikuj klucz
			//
			printf("\nWeryfikowanie klucza...\n");

			// sciezka do odpowiedniego pliku projektu
			kvpKeygenVerifyParams.lpszProjectPath = szProjectPath;

			// czy uzywamy tekstowego bufora z zawartoscia pliku projektu (zamiast samego pliku projektu)?
			kvpKeygenVerifyParams.bProjectBuffer = FALSE;

			// bufor pamieci z zawartoscia klucza
			kvpKeygenVerifyParams.lpKeyBuffer = lpKeyData;

			// czy uzywamy bufora pamieci z zawartoscia klucza (zamiast samego pliku klucza)?
			kvpKeygenVerifyParams.bKeyBuffer = TRUE;

			// rozmiar bufora pamieci z zawartoscia klucza
			kvpKeygenVerifyParams.dwKeyBufferSize = dwKeyDataSize;

			// bufor pamieci, gdzie zostanie odczytana nazwa zarejestrowanego uzytkownika (lub dowolne inne dane licencyjne)
			kvpKeygenVerifyParams.lpszUsername = szUsername;

			// zweryfikuj klucz
			dwVerifyResult = VerifyKeyProc(&kvpKeygenVerifyParams);

			switch (dwVerifyResult)
			{
			// dane licencyjne poprawnie zweryfikowane
			case KEYGEN_VERIFY_SUCCESS:

				printf("Klucz poprawnie zweryfikowany, szczegoly:\n\n");

				printf("Nazwa uzytkownika: %s (dlugosc %u)\n", szUsername, kvpKeygenVerifyParams.dwUsernameLength);
				printf("Dodatkowe opcje bitowe: %08X", kvpKeygenVerifyParams.dwFeatureBits);
				printf("Klucz jest w formacie: %s", lpszKeyFormats[kvpKeygenVerifyParams.dwOutputFormat]);

				break;

			// nieprawidlowe parametry (lub brakujace)
			case KEYGEN_VERIFY_INVALID_PARAMS:

				printf("Niepoprawne parametry wejsciowe (sprawdz strukture KEYGEN_VERIFY_PARAMS)!");
				break;

			// nieprawidlowy plik projektu
			case KEYGEN_VERIFY_INVALID_PROJECT:

				printf("Nieprawidlowy plik projektu, byc moze jest on uszkodzony!");
				break;

			// blad alokacji pamieci w funkcji VerifyKey()
			case KEYGEN_VERIFY_OUT_MEMORY:

				printf("Zabraklo pamieci do zweryfikowania klucza!");
				break;

			// blad podczas weryfikowania poprawnosci klucza
			case KEYGEN_VERIFY_DATA_ERROR:

				printf("Wystapil blad podczas weryfikacji danych licencyjnych, prosze skontaktowac sie z autorem!");
				break;

			// nie mozna otworzyc pliku klucza (jesli podany)
			case KEYGEN_VERIFY_FILE_ERROR:

				printf("Nie mozna otworzyc pliku klucza licencyjnego!");
				break;

			// nieznane bledy
			default:

				printf("Nieznany blad, prosze skontaktowac sie z autorem!");
				break;
			}
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

	// blad alokacji pamieci w funkcji Keygen()
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
	free(lpKeyData);

	print_error(NULL);

	return 0;
}
