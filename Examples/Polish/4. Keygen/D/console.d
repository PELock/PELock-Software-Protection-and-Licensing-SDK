////////////////////////////////////////////////////////////////////////////////
//
// Przyklad uzycia biblioteki generatora kluczy licencyjnych
//
// Wersja         : PELock v2.0
// Jezyk          : D
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

import std.stdio;
import std.string;
import core.stdc.stdio;
import core.sys.windows.windows;
import std.file: getcwd;
import std.path;
import std.conv;
import core.stdc.stdio;
import core.memory : GC;
import PELockKeygen;

// prototyp funkcji Keygen() z biblioteki KEYGEN.dll
PELOCK_KEYGEN KeygenProc;

// prototyp funkcji VerifyKey() z biblioteki KEYGEN.dll
PELOCK_VERIFY_KEY VerifyKeyProc;

string[] lpszKeyFormats = [ "KEY_FORMAT_BIN", "KEY_FORMAT_REG", "KEY_FORMAT_TXT" ];

///////////////////////////////////////////////////////////////////////////////
//
// wyswietl komunikat bledu i zaczekaj, az uzytkownik nacisnie dowolny klawisz
//
///////////////////////////////////////////////////////////////////////////////

void print_error(const char[] lpszErrorMessage)
{
	if (lpszErrorMessage != null)
	{
		writef(lpszErrorMessage);
	}

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();
}

///////////////////////////////////////////////////////////////////////////////
//
// poczatek
//
///////////////////////////////////////////////////////////////////////////////

int main(string args[])
{
	HMODULE hKeygen = null;
	string szProjectPath;

	File hKey;
	BYTE[] lpKeyData;
	DWORD dwKeyDataSize = 0;

	KEYGEN_PARAMS kpKeygenParams;
	KEYGEN_VERIFY_PARAMS kvpKeygenVerifyParams;

	DWORD dwResult = 0;
	DWORD dwVerifyResult = 0;

	char[] szUsername = new char[PELOCK_MAX_USERNAME];

	///////////////////////////////////////////////////////////////////////////////
	//
	// zaladuj biblioteke KEYGEN.dll
	//
	///////////////////////////////////////////////////////////////////////////////

	hKeygen = LoadLibraryA("KEYGEN.dll");

	// sprawdz uchwyt biblioteki
	if (hKeygen == null)
	{
		print_error("Nie mozna zaladowac biblioteki KEYGEN.dll!");
		return 1;
	}

	// pobierz adres procedury "Keygen" z biblioteki generatora kluczy
	KeygenProc = cast(PELOCK_KEYGEN)GetProcAddress(hKeygen, "Keygen");

	if (KeygenProc == null)
	{
		print_error("Nie mozna znalezc procedury Keygen() w bibliotece KEYGEN.dll!");
		return 1;
	}

	// pobierz adres procedury "VerifyKey" z biblioteki generatora kluczy
	VerifyKeyProc = cast(PELOCK_VERIFY_KEY)GetProcAddress(hKeygen, "VerifyKey");

	if (VerifyKeyProc == null)
	{
		print_error("Nie mozna znalezc procedury VerifyKey() w bibliotece KEYGEN.dll!");
		return 1;
	}

	///////////////////////////////////////////////////////////////////////////////
	//
	// zbuduj sciezke do pliku projektu, w ktorym zapisane sa klucze szyfrujace
	//
	///////////////////////////////////////////////////////////////////////////////

	szProjectPath = buildPath(getcwd(), "test.plk");

	///////////////////////////////////////////////////////////////////////////////
	//
	// zaalokuj pamiec potrzebna do utworzenia klucza licencyjnego
	//
	///////////////////////////////////////////////////////////////////////////////

	lpKeyData = new BYTE[PELOCK_SAFE_KEY_SIZE];

	if (lpKeyData == null)
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
	kpKeygenParams.lpOutputBuffer = lpKeyData.ptr;

	// wskaznik do wartosci DWORD, gdzie zostanie zapisany rozmiar wygenerowanego klucza
	kpKeygenParams.lpdwOutputSize = &dwKeyDataSize;

	// wyjsciowy format klucza
	// KEY_FORMAT_BIN - binarny klucz
	// KEY_FORMAT_REG - klucz w formie zrzutu rejestru Windows
	// KEY_FORMAT_TXT - klucz tekstowy (w formacie MIME Base64)
	kpKeygenParams.dwOutputFormat = KEY_FORMAT_BIN;

	// sciezka do odpowiedniego pliku projektu
	kpKeygenParams.lpszProjectPath = cast(char*)toStringz(szProjectPath);

	// czy uzywamy tekstowego bufora z zawartoscia pliku projektu (zamiast samego pliku projektu)?
	kpKeygenParams.bProjectBuffer = FALSE;

	// czy automatycznie dodac uzytkownika, dla ktorego generowany jest klucz do pliku projektu?
	kpKeygenParams.bUpdateProject = FALSE;

	// wskaznik do wartosci BOOL, gdzie zostanie zapisany status czy udalo sie dodac uzytkownika do pliku projektu
	kpKeygenParams.lpbProjectUpdated = null;

	// wskaznik do nazwy uzytkownika (lub innych danych licencyjnych, moga to byc dane binarne etc.)
	kpKeygenParams.lpszUsername = "Laura Palmer".dup.ptr;

	// rozmiar nazwy uzytkownika lub innych danych licencyjnych (max. 8192 znakow/bajtow)
	kpKeygenParams.dwUsernameLength = "Laura Palmer".length;

	// flaga czy korzystac z blokady na sprzetowy identyfikator?
	kpKeygenParams.bSetHardwareLock = FALSE;

	// czy zaszyfrowac nazwe uzytkownika i dodatkowe pola klucza wedlug identyfikatora sprzetowego
	kpKeygenParams.bSetHardwareEncryption = FALSE;

	// ciag znakow identyfikatora sprzetowego
	kpKeygenParams.lpszHardwareId = null;

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
	// lub:
	// dwResult = Keygen(&kpKeygenParams);

	switch (dwResult)
	{
	// klucz licencyjny poprawnie wygenerowany
	case KEYGEN_SUCCESS:

		try
		{
			// zapisz dane klucza licencyjnego do pliku
			switch (kpKeygenParams.dwOutputFormat)
			{
			default:
			case KEY_FORMAT_BIN: hKey = File("key.lic", "wb+"); break;
			case KEY_FORMAT_REG: hKey = File("key.reg", "wb+"); break;
			case KEY_FORMAT_TXT: hKey = File("key.txt", "wb+"); break;
			}

			// ustaw rozmiar danych
			lpKeyData.length = dwKeyDataSize;

			// zapisz plik
			hKey.rawWrite(lpKeyData);

			// zamknij uchwyt pliku
			hKey.close();

			writef("Klucz licencyjny zostal poprawnie wygenerowany!");

			//
			// zweryfikuj klucz
			//
			writef("\nWeryfikowanie klucza...\n");

			// sciezka do odpowiedniego pliku projektu
			kvpKeygenVerifyParams.lpszProjectPath = cast(char*)toStringz(szProjectPath);

			// czy uzywamy tekstowego bufora z zawartoscia pliku projektu (zamiast samego pliku projektu)?
			kvpKeygenVerifyParams.bProjectBuffer = FALSE;

			// bufor pamieci z zawartoscia klucza
			kvpKeygenVerifyParams.lpKeyBuffer = cast(PBYTE)lpKeyData;

			// czy uzywamy bufora pamieci z zawartoscia klucza (zamiast samego pliku klucza)?
			kvpKeygenVerifyParams.bKeyBuffer = TRUE;

			// rozmiar bufora pamieci z zawartoscia klucza
			kvpKeygenVerifyParams.dwKeyBufferSize = dwKeyDataSize;

			// bufor pamieci, gdzie zostanie odczytana nazwa zarejestrowanego uzytkownika (lub dowolne inne dane licencyjne)
			kvpKeygenVerifyParams.lpszUsername = szUsername.ptr;

			// zweryfikuj klucz
			dwVerifyResult = VerifyKeyProc(&kvpKeygenVerifyParams);
			// lub
			// dwVerifyResult = VerifyKey(&kvpKeygenVerifyParams);

			switch (dwVerifyResult)
			{
			// dane licencyjne poprawnie zweryfikowane
			case KEYGEN_VERIFY_SUCCESS:

				szUsername.length = kvpKeygenVerifyParams.dwUsernameLength;

				writef("Klucz poprawnie zweryfikowany, szczegoly:\n\n");

				writef("Nazwa uzytkownika: %s (dlugosc %d)\n", szUsername, kvpKeygenVerifyParams.dwUsernameLength);
				writef("Dodatkowe opcje bitowe: %08X", kvpKeygenVerifyParams.dwFeatureBits);
				writef("Klucz jest w formacie: %s", lpszKeyFormats[kvpKeygenVerifyParams.dwOutputFormat]);

				break;

			// nieprawidlowe parametry (lub brakujace)
			case KEYGEN_VERIFY_INVALID_PARAMS:

				writef("Niepoprawne parametry wejsciowe (sprawdz strukture KEYGEN_VERIFY_PARAMS)!");
				break;

			// nieprawidlowy plik projektu
			case KEYGEN_VERIFY_INVALID_PROJECT:

				writef("Nieprawidlowy plik projektu, byc moze jest on uszkodzony!");
				break;

			// blad alokacji pamieci w funkcji VerifyKey()
			case KEYGEN_VERIFY_OUT_MEMORY:

				writef("Zabraklo pamieci do zweryfikowania klucza!");
				break;

			// blad podczas weryfikowania poprawnosci klucza
			case KEYGEN_VERIFY_DATA_ERROR:

				writef("Wystapil blad podczas weryfikacji danych licencyjnych, prosze skontaktowac sie z autorem!");
				break;

			// nie mozna otworzyc pliku klucza (jesli podany)
			case KEYGEN_VERIFY_FILE_ERROR:

				writef("Nie mozna otworzyc pliku klucza licencyjnego!");
				break;

			// nieznane bledy
			default:

				writef("Nieznany blad, prosze skontaktowac sie z autorem!");
				break;
			}
		}
		catch(Exception e)
		{
			writef("Nie mozna utworzyc pliku klucza licencyjnego!");
		}

		break;

	// nieprawidlowe parametry wejsciowe (lub brakujace parametry)
	case KEYGEN_INVALID_PARAMS:

		writef("Niepoprawne parametry wejsciowe (sprawdz strukture PELOCK_KEY_PARAMS)!");
		break;

	// nieprawidlowy plik projektu
	case KEYGEN_INVALID_PROJECT:

		writef("Nieprawidlowy plik projektu, byc moze jest on uszkodzony!");
		break;

	// blad alokacji pamieci w funkcji Keygen()
	case KEYGEN_OUT_MEMORY:

		writef("Zabraklo pamieci do wygenerowania klucza!");
		break;

	// blad generacji danych klucza licencyjnego
	case KEYGEN_DATA_ERROR:

		writef("Wystapil blad podczas generowania danych licencyjnych, prosze skontaktowac sie z autorem!");
		break;

	// nieznane bledy
	default:

		writef("Nieznany blad, prosze skontaktowac sie z autorem!");
		break;
	}

	print_error(null);

	return 0;
}
