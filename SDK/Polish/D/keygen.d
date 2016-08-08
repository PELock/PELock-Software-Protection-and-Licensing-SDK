////////////////////////////////////////////////////////////////////////////////
//
// Plik naglowkowy biblioteki generatora kluczy licencyjnych
//
// Wersja         : PELock v2.0
// Jezyk          : D
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

module PELockKeygen;

pragma(lib, "keygen.lib");

import std.string;
import core.runtime;
import core.memory;
import core.sys.windows.windows;
import std.bitmanip;

const int PELOCK_MAX_USERNAME			= 8193;		// max. rozmiar nazwy uzytkownika zapisanej w kluczu, wlaczajac konczace zero
const int PELOCK_MAX_HARDWARE_ID		= 17;		// max. liczba znakow identyfikatora sprzetowego, wlaczajac konczace zero
const int PELOCK_SAFE_KEY_SIZE			= 40*1024;	// bezpieczny rozmiar bufora na dane wyjsciowe klucza

// formaty wyjsciowe kluczy
const DWORD KEY_FORMAT_BIN			= 0;		// klucz w formie binarnej
const DWORD KEY_FORMAT_REG			= 1;		// klucz w formie zrzutu rejestru Windows (.reg)
const DWORD KEY_FORMAT_TXT			= 2;		// klucz tekstowy (w formacie MIME Base64)

// kody bledow dla funkcji Keygen()
const DWORD KEYGEN_SUCCESS			= 0;		// dane licencyjne poprawnie wygenerowane
const DWORD KEYGEN_INVALID_PARAMS		= 1;		// nieprawidlowe parametry (lub brakujace)
const DWORD KEYGEN_INVALID_PROJECT		= 2;		// nieprawidlowy plik projektu (np. uszkodzony)
const DWORD KEYGEN_OUT_MEMORY			= 3;		// brak pamieci
const DWORD KEYGEN_DATA_ERROR			= 4;		// wewnetrzny blad podczas generowania klucza

// kody bledow dla funkcji VerifyKey()
const DWORD KEYGEN_VERIFY_SUCCESS		= 0;		// dane licencyjne poprawnie zweryfikowane
const DWORD KEYGEN_VERIFY_INVALID_PARAMS	= 1;		// nieprawidlowe parametry (lub brakujace)
const DWORD KEYGEN_VERIFY_INVALID_PROJECT	= 2;		// nieprawidlowy plik projektu (np. uszkodzony)
const DWORD KEYGEN_VERIFY_OUT_MEMORY		= 3;		// brak pamieci
const DWORD KEYGEN_VERIFY_DATA_ERROR		= 4;		// blad podczas weryfikowania poprawnosci klucza
const DWORD KEYGEN_VERIFY_FILE_ERROR		= 5;		// nie mozna otworzyc pliku klucza

//
// struktura opisujaca parametry dla generowanego klucza
//
struct KEYGEN_PARAMS {

	PBYTE lpOutputBuffer;				// wskaznik bufora na dane wyjsciowe (musi byc odpowiednio duzy)
	PDWORD lpdwOutputSize;				// wskaznik na wartosc DWORD, gdzie zostanie zapisany rozmiar danych licencynych

	DWORD dwOutputFormat;				// wyjsciowy format klucza (klucz w formie binarnej, w formie zrzutu rejestru Windows etc.)

	union
	{
		char *lpszProjectPath;			// sciezka pliku projektu
		char *lpszProjectBuffer;		// bufor tekstowy z zawartoscia pliku projektu
	};

	BOOL bProjectBuffer;				// czy lpszProjectBuffer wskazuje na bufor tekstowy zamiast na plik

	BOOL bUpdateProject;				// flaga okreslajaca czy ma byc uaktualniony plik projektu (czy dodac uzytkownika)
	PBOOL lpbProjectUpdated;			// wskaznik do wartosci BOOL, gdzie zostanie zapisany status uaktualnienia projektu

	union
	{
		char *lpszUsername;			// wskaznik do nazwy uzytkownika
		PVOID lpUsernameRawData;		// wskaznik do innych danych licencyjnych (dowolnych, np. binarnych)
	};

	union
	{
		DWORD dwUsernameLength;			// rozmiar nazwy uzytkownika (max. 8192 znakow)
		DWORD dwUsernameRawSize;		// rozmiar danych binarnych (max. 8192 bajtow)
	};

	BOOL bSetHardwareLock;				// czy uzyc blokowania licencji na identyfikator sprzetowy
	BOOL bSetHardwareEncryption;			// czy zaszyfrowac nazwe uzytkownika i dodatkowe pola klucza wedlug identyfikatora sprzetowego
	char *lpszHardwareId;				// identyfikator sprzetowy

	BOOL bSetKeyIntegers;				// czy ustawic dodatkowe wartosci liczbowe klucza
	DWORD dwKeyIntegers[16];			// dodatkowych 16 wartosci liczbowych klucza

	BOOL bSetKeyCreationDate;			// czy ustawic date utworzenia klucza
	SYSTEMTIME stKeyCreation;			// data utworzenia klucza

	BOOL bSetKeyExpirationDate;			// czy ustawic date wygasniecia klucza
	SYSTEMTIME stKeyExpiration;			// data wygasniecia klucza

	BOOL bSetFeatureBits;				// czy ustawic dodatkowe opcje bitowe klucza (obsluga sekcji FEATURE_x_START)

	union
	{
		DWORD dwFeatureBits;			// dodatkowe opcje bitowe w formie DWORDa

		struct					// dodatkowe opcje bitowe w formie 4 bajtow
		{
			BYTE dwKeyData1;
			BYTE dwKeyData2;
			BYTE dwKeyData3;
			BYTE dwKeyData4;
		};

		mixin(bitfields!(			// dodatkowe opcje bitowe jako indywidualne bity
			bool, "bFeature1", 1,
			bool, "bFeature2", 1,
			bool, "bFeature3", 1,
			bool, "bFeature4", 1,
			bool, "bFeature5", 1,
			bool, "bFeature6", 1,
			bool, "bFeature7", 1,
			bool, "bFeature8", 1,
			bool, "bFeature9", 1,
			bool, "bFeature10", 1,
			bool, "bFeature11", 1,
			bool, "bFeature12", 1,
			bool, "bFeature13", 1,
			bool, "bFeature14", 1,
			bool, "bFeature15", 1,
			bool, "bFeature16", 1,
			bool, "bFeature17", 1,
			bool, "bFeature18", 1,
			bool, "bFeature19", 1,
			bool, "bFeature20", 1,
			bool, "bFeature21", 1,
			bool, "bFeature22", 1,
			bool, "bFeature23", 1,
			bool, "bFeature24", 1,
			bool, "bFeature25", 1,
			bool, "bFeature26", 1,
			bool, "bFeature27", 1,
			bool, "bFeature28", 1,
			bool, "bFeature29", 1,
			bool, "bFeature30", 1,
			bool, "bFeature31", 1,
			bool, "bFeature32", 1,
		));
	};


}
alias KEYGEN_PARAMS* PKEYGEN_PARAMS;


//
// struktura opisujaca parametry dla weryfikacji klucza
//
struct KEYGEN_VERIFY_PARAMS {

	union
	{
		char *lpszKeyPath;			// sciezka pliku klucza (wejscie)
		PBYTE lpKeyBuffer;			// bufor pamieci z zawartoscia klucza (wejscie)
	};

	BOOL bKeyBuffer;				// czy lpKeyBuffer wskazuje na bufor z zawartoscia klucza (wejscie)
	DWORD dwKeyBufferSize;				// rozmiar klucza w buforze lpKeyBuffer (wejscie)

	union
	{
		char *lpszProjectPath;			// sciezka pliku projektu (wejscie)
		char *lpszProjectBuffer;		// bufor tekstowy z zawartoscia pliku projektu (wejscie)
	};

	BOOL bProjectBuffer;				// czy lpszProjectBuffer wskazuje na bufor tekstowy zamiast na plik

	DWORD dwOutputFormat;				// wyjsciowy format klucza (klucz w formie binarnej, w formie zrzutu rejestru Windows etc.)

	union
	{
		char *lpszUsername;			// wskaznik do nazwy uzytkownika
		PVOID lpUsernameRawData;		// wskaznik do innych danych licencyjnych (dowolnych, np. binarnych)
	};

	union
	{
		DWORD dwUsernameLength;			// rozmiar nazwy uzytkownika (max. 8192 znakow)
		DWORD dwUsernameRawSize;		// rozmiar danych binarnych (max. 8192 bajtow)
	};

	BOOL bHardwareLock;				// czy uzyte jest blokowanie licencji na identyfikator sprzetowy
	BOOL bHardwareEncryption;			// czy nazwa uzytkownika i dodatkowe pola klucza sa zaszyfrowane wedlug identyfikatora sprzetowego

	BOOL bKeyIntegers;				// czy ustawione sa dodatkowe wartosci liczbowe klucza
	DWORD dwKeyIntegers[16];			// dodatkowych 16 wartosci liczbowych klucza

	BOOL bKeyCreationDate;				// czy ustawiona jest data utworzenia klucza
	SYSTEMTIME stKeyCreation;			// data utworzenia klucza

	BOOL bKeyExpirationDate;			// czy ustawiona jest data wygasniecia klucza
	SYSTEMTIME stKeyExpiration;			// data wygasniecia klucza

	BOOL bFeatureBits;				// czy ustawione sa dodatkowe opcje bitowe klucza (obsluga sekcji FEATURE_x_START)

	union
	{
		DWORD dwFeatureBits;			// dodatkowe opcje bitowe w formie DWORDa

		struct					// dodatkowe opcje bitowe w formie 4 bajtow
		{
			BYTE dwKeyData1;
			BYTE dwKeyData2;
			BYTE dwKeyData3;
			BYTE dwKeyData4;
		};

		mixin(bitfields!(			// dodatkowe opcje bitowe jako indywidualne bity
			bool, "bFeature1", 1,
			bool, "bFeature2", 1,
			bool, "bFeature3", 1,
			bool, "bFeature4", 1,
			bool, "bFeature5", 1,
			bool, "bFeature6", 1,
			bool, "bFeature7", 1,
			bool, "bFeature8", 1,
			bool, "bFeature9", 1,
			bool, "bFeature10", 1,
			bool, "bFeature11", 1,
			bool, "bFeature12", 1,
			bool, "bFeature13", 1,
			bool, "bFeature14", 1,
			bool, "bFeature15", 1,
			bool, "bFeature16", 1,
			bool, "bFeature17", 1,
			bool, "bFeature18", 1,
			bool, "bFeature19", 1,
			bool, "bFeature20", 1,
			bool, "bFeature21", 1,
			bool, "bFeature22", 1,
			bool, "bFeature23", 1,
			bool, "bFeature24", 1,
			bool, "bFeature25", 1,
			bool, "bFeature26", 1,
			bool, "bFeature27", 1,
			bool, "bFeature28", 1,
			bool, "bFeature29", 1,
			bool, "bFeature30", 1,
			bool, "bFeature31", 1,
			bool, "bFeature32", 1,
		));
	};

	BYTE cKeyChecksum[32];				// suma kontrolna klucza (moze byc wykorzystana do umieszczenia go na liscie zablokowanych kluczy)

}
alias KEYGEN_VERIFY_PARAMS* PKEYGEN_VERIFY_PARAMS;

version (Windows)
{
	// prototyp funkcji Keygen()
	extern (Windows) alias DWORD function(PKEYGEN_PARAMS) PELOCK_KEYGEN;

	// prototyp funkcji VerifyKey()
	extern (Windows) alias DWORD function(PKEYGEN_VERIFY_PARAMS) PELOCK_VERIFY_KEY;

}

version (Windows):
extern (Windows):
nothrow:
export
{
	DWORD Keygen(PKEYGEN_PARAMS lpKeygenParams);
	DWORD VerifyKey(PKEYGEN_VERIFY_PARAMS lpKeygenVerifyParams);
}
