////////////////////////////////////////////////////////////////////////////////
//
// Przyklad biblioteki kompresji uzytkownika
//
// Wersja         : PELock v2.0
// Jezyk          : C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"

// nazwa algorytmu kompresji (na potrzeby logowania)
const char szCompressionName[] = "CCX";

//
// DWORD __stdcall Compress(const PBYTE lpInput, DWORD dwInput, PBYTE lpOutput, PDWORD lpdwOutput, LPCOMPRESSION_PROGRESS lpCompressionProgress, const char *lpszConfig, DWORD Reserved)
//
// procedura kompresji
//
// [wejscie]
// lpInput - dane zrodlowe, ktore maja byc skompresowane
// dwInput - rozmiar danych zrodlowych w bajtach
// lpOutput - bufor wyjsciowy (juz zaalokowany przez kod PELock'a, jest wiekszy niz rozmiar wejsciowych danych, dlatego ratio moze byc ujemne)
// lpdwOutput - wskaznik na wartosc DWORD, gdzie zostanie zapisany rozmiar skompresowanych danych
// lpCompressionProgress - procedura callback (dla wyswietlania postepu kompresji)
// lpszConfig - wskaznik na sciezke biezacego pliku konfiguracyjnego (pelock.ini lub plik projektu)
// Reserved - nieuzywane, ustaw na 0
//
// [wyjscie]
// 0 sukces, wszystko rozne od != 0 oznacza blad (kod bledu bedzie zalogowany)
//
EXPORT DWORD __stdcall Compress(const PBYTE lpInput, DWORD dwInput, PBYTE lpOutput, PDWORD lpdwOutput, LPCOMPRESSION_PROGRESS lpCompressionProgress, const char *lpszConfig, DWORD Reserved)
{
	PBYTE lpIn = NULL, lpOut = NULL;
	DWORD i = 0;

	//
	// sprawdz parametry wejsciowe (w praktyce nigdy nie beda niepoprawne)
	//
	if ( (lpInput == NULL) || (dwInput == 0) || (lpOutput == NULL) )
	{
		return COMPESSION_ERROR_PARAM;
	}

	// ustaw pomocniczne zmienne
	lpIn = lpInput;
	lpOut = lpOutput;

	//
	// zapisz rozmiar zdekompresowanych danych w buforze wyjsciowym (tak, zeby procedura dekompresji znala ten rozmiar)
	//
	*(DWORD *)lpOut = dwInput;
	lpOut += sizeof(DWORD);

	//
	// przykladowa procedura kompresji (w tym przypadku dane sa jedynie kopiowane)
	//
	for (i = 0; i < dwInput; i++)
	{
		*lpOut++ = *lpIn++;

		// wywoluj procedure callback wykorzystywana do aktualizacji paska postepu, parametrami sa pozycja danych
		// zrodlowych oraz pozycja w buforze wyjsciowym, procedure wywoluj raz na 1 kB przetworzonych danych, zeby
		// nie obciazac procesora
		if ((i % 1024) == 0)
		{
			lpCompressionProgress(i, i, 0);
		}
	}

	// zadanie wykonane na 100%, poinforumuj o tym procedure callback
	lpCompressionProgress(i, i, 0);

	//
	// zwroc rozmiar skompresowanych danych (w tym przykladzie rozmiar danych wyjsciowych jest taki
	// sam jak rozmiar danych wejsciowych + rozmiar dodatkowej wartosci DWORD)
	//
	if (lpdwOutput != NULL)
	{
		*lpdwOutput = dwInput + sizeof(DWORD);
	}

	//
	// zwroc 0 (sukces), wszystko inne != 0 bedzie potraktowane jako blad
	//
	return COMPRESSION_OK;
}

//
// DWORD __cdecl DecompressionProc(PDEPACK_INTERFACE lpDepackInterface, PVOID lpInputData, PVOID lpOutputData)
//
// procedura dekompresji (binarny kod), ten kod bedzie bezposrednio polaczony z
// kodem programu ladujacego (loaderem) PELocka, aby wszystko dzialalo prawidlowo
// nalezy spelnic kilka waznych warunkow:
//
// * wszystkie rejestry (oprocz EAX) MUSZA BYC zachowane (skorzystaj z instrukcji pushad i popad), flagi moga byc zmienione
// * nalezy zwrocic rozmiar zdekompresowanych danych w rejestrze EAX
// * procedura musi byc w konwencji __cdecl, NIE MOZNA korygowac stosu poprzez wyjscie z procedury instrukcja ret 12
// * mozna uzywac bufora lpInputData jako bufor tymczasowy
//
// [wejscie]
// lpDepackInterface - wskaznik struktury DEPACK_INTERFACE, gdzie zapisane sa adresy podstawowych
// funkcji WinApi, dzieki ktorym mozna tworzyc skomplikowane procedury dekompresji
// lpInputData - wskaznik skompresowanych danych
// lpOutputData - wskaznik pamieci, gdzie maja byc umieszczone zdekompresowane dane
//
// [wyjscie]
// rozmiar zdekompresowanych danych
//
__declspec(naked) DWORD DecompressionRoutine(PDEPACK_INTERFACE lpDepackInterface, PVOID lpInputData, PVOID lpOutputData)
{
	__asm
	{
		pushad							// zachowaj wszystkie rejestry

		mov	ebx, dword ptr [esp + 36]	// lpDepackInterface (tabela z adresami podstawowych funkcji WinApi)
		mov	esi, dword ptr [esp + 40]	// lpInputData
		mov	edi, dword ptr [esp + 44]	// lpOutputData

		mov	eax, dword ptr[esi]			// 1szy DWORD w strukturze danych wejsciowych okresla rozmiar skompresowanych danych (nasz wlasny format)
		add	esi,4
		mov	dword ptr [esp + 28], eax	// zwroc wartosc zdekompresowanych danych (bedzie zwrocony w rejestrze EAX po powrocie z tej procedury)

		mov	ecx,eax						// procedura dekompresji (w tym przykladzie to jedynie zwykle kopiowanie pamieci)
		shr	ecx,2
		and	eax,3
		rep	movsd
		mov	ecx,eax
		rep	movsb

		popad							// przywroc stan wszystkich rejestrow (EAX = rozmiar zdekompresowanych danych)

		retn							// powrot (retn = ret 0, nasza procedura jest w konwencji __cdecl, NIE UZYWAJ instrukcji ret 12!)

		_emit 0xAA						// pomocniczy marker, pozwalajacy recznie obliczyc rozmiar procedury
		_emit 0xFF						// dekompresji (obejscie niedoskonalosci jezyka C++)
		_emit 0xFF						//
		_emit 0xAA						//
	}
}

//
// void __stdcall DecompressionProc(PVOID **lppDecompProc, DWORD *lpdwDecompProc, DWORD Reserved)
//
// procedura zwraca wskaznik do kodu procedury dekompresji oraz jej rozmiar
//
// [wejscie]
// Reserved - nieuzywana wartosc, ustaw na 0
//
// [wyjscie]
// lppDecompProc - wskaznik, gdzie zostanie zapisany adres procedury dekompresji
// lpdwDecompProc - wskaznik wartosci DWORD, gdzie zostanie zapisany rozmiar procedury dekompresji
//
// [uwagi]
// ta procedura jest wywolywana tylko JEDEN RAZ podczas sesji zabezpieczania pliku, wiec mozliwe jest
// np. dynamiczne wygenerowanie kodu procedury dekompresji (przykladowo wykorzystujac engine polimorifczne),
// potem jedynie wystarczy zwolnic pamiec tak dynamicznie wygenerowanej procedury przy DLL_PROCESS_DETACH
//
EXPORT void __stdcall DecompressionProc(PVOID *lppDecompProc, PDWORD lpdwDecompProc, DWORD Reserved)
{
	DWORD dwDecompProc = 0;
	PBYTE lpDecompProc = (PBYTE)&DecompressionRoutine;
	BYTE cMarker[] = { 0xAA, 0xFF, 0xFF, 0xAA };

	// marker w procedurze dekompresji, dzieki ktoremu odnajdujemy rozmiar procedury dekompresji
	for (dwDecompProc = 0; dwDecompProc < 1024; dwDecompProc++)
	{
		if ( memcmp(&lpDecompProc[dwDecompProc], cMarker, sizeof(cMarker) ) == 0)
		{
			break;
		}
	}

	*lppDecompProc = (PVOID)&DecompressionRoutine;
	*lpdwDecompProc = dwDecompProc;
}

//
// const char * __stdcall Name(DWORD Reserved)
//
// procedura zwraca wskaznik do nazwy algorytmu kompresji
//
// [wejscie]
// Reserved - nieuzywane, ustaw na 0
//
// [wyjscie]
// wskaznik do nazwy algorytmu kompresji (ansi)
//
EXPORT const char * __stdcall Name(DWORD Reserved)
{
	return szCompressionName;
}

//
// void __stdcall Configure(HWND hParent, const char *lpszConfig, DWORD Reserved)
//
// procedura konfiguracji biblioteki kompresji, wywolywana z interfejsu PELock'a
// pozwala zapisac wlasne opcje konfiguracyjne w biezacym pliku konfiguracyjnym
// PELock'a, a nastepnie przy procedurze kompresji je odczytac
//
// [wejscie]
// hWndParent - uchwyt okna rodzica (glowne okno PELock'a)
// lpszConfig - wskaznik na sciezke biezacego pliku konfiguracyjnego (pelock.ini lub plik projektu)
// Reserved - nieuzywane, ustaw na 0
//
EXPORT void __stdcall Configure(HWND hWndParent, const char *lpszConfig, DWORD Reserved)
{
	MessageBox(hWndParent, szCompressionName, lpszConfig, MB_ICONINFORMATION);
}

//
// punkt wejsciowy
//
BOOL APIENTRY DllMain(HINSTANCE hModule, DWORD ul_reason_for_call, LPVOID lpReserved)
{
	switch(ul_reason_for_call)
	{
	// inicjalizacja biblioteki (mozna tutaj zaalokowac pamiec etc.)
	case DLL_PROCESS_ATTACH:

		DisableThreadLibraryCalls(hModule);
		break;

	// cleanup
	case DLL_PROCESS_DETACH:

		break;
	}

	return TRUE;
}
