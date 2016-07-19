////////////////////////////////////////////////////////////////////////////////
//
// Przyklad wtyczki
//
// Wersja         : PELock v2.0
// Jezyk          : C/C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include <windows.h>
#include "pelock_plugin.h"

// makro pomocniczne do definiowania funkcji eksportowanych
#define EXPORT __declspec(dllexport) __stdcall

// globalny wskaznik do struktury interfejsu wtyczki PLUGIN_INTERFACE
PLUGIN_INTERFACE *g_lpPluginInterface = NULL;

// uchwyt procedury wykonywanej w watku
HANDLE g_hBeepThread = NULL;

////////////////////////////////////////////////////////////////////////////////
//
// procedura beepera
//
////////////////////////////////////////////////////////////////////////////////

DWORD WINAPI BeepProc(LPVOID lpParameter)
{
	while(1)
	{
		MessageBeep(-1);
		Sleep(1000);
	}

	return 0;
}

////////////////////////////////////////////////////////////////////////////////
//
// procedura wtyczki
//
// uwagi!
//
// w bibliotece wtyczki mozesz korzystac z oryginalnych funkcji WinApi/RTF np.
//
// ExitProcess(0);
// strlen(lpszString);
//
// lub mozesz skorzystac z procedur dostepnych poprzez strukture interfejsu
// PLUGIN_INTERFACE:
//
// lpPluginInterface->pe_ExitProcess(0);
// lpPluginInterface->pe_strlen(lpszString);
//
// ostrzezenie!
//
// wszystkie procedury dostepne poprzez interfejs PLUGIN_INTERFACE sa wersjami
// ANSI (kompatybilne ze wszystkimi wersjami systemow Windows), wiec nie mozna
// uzywac ich z parametrami UNICODE (typ danych wchar etc.)!
// Jesli we wtyczce chcesz skorzystac z funkcji obslugujacych unicode, skorzystaj
// z oryginalnych funkcji WinApi/RTC, a nie tych dostepnych poprzez interfejs wtyczki
// PLUGIN_INTERFACE.
//
////////////////////////////////////////////////////////////////////////////////

EXPORT void Plugin(PLUGIN_INTERFACE * lpPluginInterface)
{
	DWORD dwThreadId = 0;

	// sprawdz parametr wejsciowy
	if (lpPluginInterface == NULL)
	{
		return;
	}

	// zapisz wskaznik do interfejsu wtyczki do globalnej zmiennej
	g_lpPluginInterface = lpPluginInterface;

	// uruchom watek, ktory bedzie odgrywal dzwiek z glosnika systemowego
	g_hBeepThread = lpPluginInterface->pe_CreateThread(NULL, 0, &BeepProc, NULL, 0, &dwThreadId);

	// wyswietl informacje i wroc do kodu aplikacji
	MessageBox(NULL, "Witaj swiecie! Czy slyszysz dzwieki z glosnika? :)", "Wtyczka dla PELock", MB_ICONINFORMATION);

	//DebugBreak();
}

////////////////////////////////////////////////////////////////////////////////
//
// punkt wejsciowy biblioteki (LibMain dla LCC, DllMain dla innych kompilatorow)
//
////////////////////////////////////////////////////////////////////////////////

BOOL WINAPI LibMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
	switch (fdwReason)
	{
	case DLL_PROCESS_ATTACH:

		break;

	case DLL_THREAD_ATTACH:

		break;

	case DLL_THREAD_DETACH:

		break;

	case DLL_PROCESS_DETACH:

		// wyswietl informacje przy wyladowaniu wtyczki, wtyczki w formie plikow DLL
		// sa wyladowane pod koniec dzialania aplikacji
		MessageBox(NULL, "Wtyczka konczy dzialanie.", "Wtyczka dla PELock", MB_ICONINFORMATION);

		// zamknij watek
		if (g_hBeepThread != NULL)
		{
			TerminateThread(g_hBeepThread, 1);
		}

		break;
	}

	return TRUE;
}
