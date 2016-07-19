////////////////////////////////////////////////////////////////////////////////
//
// Przyklad uzycia klasy CPELock z typami CString
//
// Wersja         : PELock v2.0
// Jezyk          : C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "main.h"

CWinApp theApp;

// nazwa zarejestrowanego uzytkownika
CString szRegisteredUsername;

// identyfikator sprzetowy
CString szHardwareId;

// deklaracja klasy CPELock
CPELock myPELock;

using namespace std;

int _tmain(int argc, TCHAR* argv[], TCHAR* envp[])
{
	//
	// inicjalizuj MFC i jesli wystapi blad, wyswietl kod bledu
	//
	if (!AfxWinInit(::GetModuleHandle(NULL), NULL, ::GetCommandLine(), 0))
	{
		_tprintf(_T("Blad: Inicjalizacja MFC nie powiodla sie\n"));

		return 1;
	}

	//
	// odczytaj nazwe zarejestrowanego uzytkownika
	//
	DEMO_START

	szRegisteredUsername = myPELock.GetRegistrationName();

	_tprintf(_T("Aplikacja zarejestrowana na %s\n"), szRegisteredUsername);

	DEMO_END

	//
	// jesli aplikacja jest niezarejestrowana, wyswietl identyfikator sprzetowy
	//
	if (szRegisteredUsername == "")
	{
		szHardwareId = myPELock.GetHardwareId();

		_tprintf(_T("Aplikacja niezarejestrowana, twoj identyfikator sprzetowy to %s\n"), szHardwareId);

	}

	_tprintf(_T("\nNacisnij dowolny klawisz, aby kontynuowac . . .\n"));

	_getch();

	return 0;
}
