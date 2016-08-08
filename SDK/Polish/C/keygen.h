////////////////////////////////////////////////////////////////////////////////
//
// Plik naglowkowy biblioteki generatora kluczy licencyjnych
//
// Wersja         : PELock v2.0
// Jezyk          : C/C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#ifndef __PELOCK_KEYGEN__
#define __PELOCK_KEYGEN__

#define PELOCK_MAX_USERNAME		8193		// max. rozmiar nazwy uzytkownika zapisanej w kluczu, wlaczajac konczace zero
#define PELOCK_MAX_HARDWARE_ID		17		// max. liczba znakow identyfikatora sprzetowego, wlaczajac konczace zero
#define PELOCK_SAFE_KEY_SIZE		(40*1024)	// bezpieczny rozmiar bufora na dane wyjsciowe klucza

// formaty wyjsciowe kluczy
#define KEY_FORMAT_BIN			0		// klucz w formie binarnej
#define KEY_FORMAT_REG			1		// klucz w formie zrzutu rejestru Windows (.reg)
#define KEY_FORMAT_TXT			2		// klucz tekstowy (w formacie MIME Base64)

// kody bledow dla funkcji Keygen()
#define KEYGEN_SUCCESS			0		// dane licencyjne poprawnie wygenerowane
#define KEYGEN_INVALID_PARAMS		1		// nieprawidlowe parametry (lub brakujace)
#define KEYGEN_INVALID_PROJECT		2		// nieprawidlowy plik projektu (np. uszkodzony)
#define KEYGEN_OUT_MEMORY		3		// brak pamieci
#define KEYGEN_DATA_ERROR		4		// wewnetrzny blad podczas generowania klucza

// kody bledow dla funkcji VerifyKey()
#define KEYGEN_VERIFY_SUCCESS		0		// dane licencyjne poprawnie zweryfikowane
#define KEYGEN_VERIFY_INVALID_PARAMS	1		// nieprawidlowe parametry (lub brakujace)
#define KEYGEN_VERIFY_INVALID_PROJECT	2		// nieprawidlowy plik projektu (np. uszkodzony)
#define KEYGEN_VERIFY_OUT_MEMORY	3		// brak pamieci
#define KEYGEN_VERIFY_DATA_ERROR	4		// blad podczas weryfikowania poprawnosci klucza
#define KEYGEN_VERIFY_FILE_ERROR	5		// nie mozna otworzyc pliku klucza

//
// struktura opisujaca parametry dla generowanego klucza
//
typedef struct _KEYGEN_PARAMS {

	PBYTE lpOutputBuffer;				// wskaznik bufora na dane wyjsciowe (musi byc odpowiednio duzy)
	PDWORD lpdwOutputSize;				// wskaznik na wartosc DWORD, gdzie zostanie zapisany rozmiar danych licencynych

	DWORD dwOutputFormat;				// wyjsciowy format klucza (klucz w formie binarnej, w formie zrzutu rejestru Windows etc.)

	union
	{
		const char *lpszProjectPath;		// sciezka pliku projektu
		const char *lpszProjectBuffer;		// bufor tekstowy z zawartoscia pliku projektu
	};

	BOOL bProjectBuffer;				// czy lpszProjectBuffer wskazuje na bufor tekstowy zamiast na plik

	BOOL bUpdateProject;				// flaga okreslajaca czy ma byc uaktualniony plik projektu (czy dodac uzytkownika)
	PBOOL lpbProjectUpdated;			// wskaznik do wartosci BOOL, gdzie zostanie zapisany status uaktualnienia projektu

	union
	{
		const char *lpszUsername;		// wskaznik do nazwy uzytkownika
		PVOID lpUsernameRawData;		// wskaznik do innych danych licencyjnych (dowolnych, np. binarnych)
	};

	union
	{
		DWORD dwUsernameLength;			// rozmiar nazwy uzytkownika (max. 8192 znakow)
		DWORD dwUsernameRawSize;		// rozmiar danych binarnych (max. 8192 bajtow)
	};

	BOOL bSetHardwareLock;				// czy uzyc blokowania licencji na identyfikator sprzetowy
	BOOL bSetHardwareEncryption;			// czy zaszyfrowac nazwe uzytkownika i dodatkowe pola klucza wedlug identyfikatora sprzetowego
	const char *lpszHardwareId;			// identyfikator sprzetowy

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

		struct					// dodatkowe opcje bitowe jako indywidualne bity
		{
			unsigned bFeature1 : 1;
			unsigned bFeature2 : 1;
			unsigned bFeature3 : 1;
			unsigned bFeature4 : 1;
			unsigned bFeature5 : 1;
			unsigned bFeature6 : 1;
			unsigned bFeature7 : 1;
			unsigned bFeature8 : 1;
			unsigned bFeature9 : 1;
			unsigned bFeature10: 1;
			unsigned bFeature11: 1;
			unsigned bFeature12: 1;
			unsigned bFeature13: 1;
			unsigned bFeature14: 1;
			unsigned bFeature15: 1;
			unsigned bFeature16: 1;
			unsigned bFeature17: 1;
			unsigned bFeature18: 1;
			unsigned bFeature19: 1;
			unsigned bFeature20: 1;
			unsigned bFeature21: 1;
			unsigned bFeature22: 1;
			unsigned bFeature23: 1;
			unsigned bFeature24: 1;
			unsigned bFeature25: 1;
			unsigned bFeature26: 1;
			unsigned bFeature27: 1;
			unsigned bFeature28: 1;
			unsigned bFeature29: 1;
			unsigned bFeature30: 1;
			unsigned bFeature31: 1;
			unsigned bFeature32: 1;
		};
	};


} KEYGEN_PARAMS, *PKEYGEN_PARAMS;

//
// struktura opisujaca parametry dla weryfikacji klucza
//
typedef struct _KEYGEN_VERIFY_PARAMS {

	union
	{
		const char *lpszKeyPath;		// sciezka pliku klucza (wejscie)
		PBYTE lpKeyBuffer;			// bufor pamieci z zawartoscia klucza (wejscie)
	};

	BOOL bKeyBuffer;				// czy lpKeyBuffer wskazuje na bufor z zawartoscia klucza (wejscie)
	DWORD dwKeyBufferSize;				// rozmiar klucza w buforze lpKeyBuffer (wejscie)

	union
	{
		const char *lpszProjectPath;		// sciezka pliku projektu (wejscie)
		const char *lpszProjectBuffer;		// bufor tekstowy z zawartoscia pliku projektu (wejscie)
	};

	BOOL bProjectBuffer;				// czy lpszProjectBuffer wskazuje na bufor tekstowy zamiast na plik

	DWORD dwOutputFormat;				// wyjsciowy format klucza (klucz w formie binarnej, w formie zrzutu rejestru Windows etc.)

	union
	{
		const char *lpszUsername;		// wskaznik do nazwy uzytkownika
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

		struct					// dodatkowe opcje bitowe jako indywidualne bity
		{
			unsigned bFeature1 : 1;
			unsigned bFeature2 : 1;
			unsigned bFeature3 : 1;
			unsigned bFeature4 : 1;
			unsigned bFeature5 : 1;
			unsigned bFeature6 : 1;
			unsigned bFeature7 : 1;
			unsigned bFeature8 : 1;
			unsigned bFeature9 : 1;
			unsigned bFeature10: 1;
			unsigned bFeature11: 1;
			unsigned bFeature12: 1;
			unsigned bFeature13: 1;
			unsigned bFeature14: 1;
			unsigned bFeature15: 1;
			unsigned bFeature16: 1;
			unsigned bFeature17: 1;
			unsigned bFeature18: 1;
			unsigned bFeature19: 1;
			unsigned bFeature20: 1;
			unsigned bFeature21: 1;
			unsigned bFeature22: 1;
			unsigned bFeature23: 1;
			unsigned bFeature24: 1;
			unsigned bFeature25: 1;
			unsigned bFeature26: 1;
			unsigned bFeature27: 1;
			unsigned bFeature28: 1;
			unsigned bFeature29: 1;
			unsigned bFeature30: 1;
			unsigned bFeature31: 1;
			unsigned bFeature32: 1;
		};
	};

	BYTE cKeyChecksum[32];				// suma kontrolna klucza (moze byc wykorzystana do umieszczenia go na liscie zablokowanych kluczy)

} KEYGEN_VERIFY_PARAMS, *PKEYGEN_VERIFY_PARAMS;


// prototyp funkcji Keygen()
typedef DWORD (__stdcall * PELOCK_KEYGEN)(PKEYGEN_PARAMS lpKeygenParams);

// prototyp funkcji VerifyKey()
typedef DWORD (__stdcall * PELOCK_VERIFY_KEY)(PKEYGEN_VERIFY_PARAMS lpKeygenVerifyParams);

#ifdef __cplusplus
extern "C" {
#endif

DWORD __stdcall Keygen(PKEYGEN_PARAMS lpKeygenParams);
DWORD __stdcall VerifyKey(PKEYGEN_VERIFY_PARAMS lpKeygenVerifyParams);

#ifdef __cplusplus
} // extern "C"
#endif

#endif // __PELOCK_KEYGEN__
