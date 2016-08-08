////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dane z klucza licencyjnego (tryb UNICODE)
//
// Wersja         : PELock v2.0
// Jezyk          : C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"

#define _countof(array) (sizeof(array) / sizeof(array[0]))

TCHAR name[PELOCK_MAX_USERNAME] = { 0 };
TCHAR hardwareid[PELOCK_MAX_HARDWARE_ID] = { 0 };

// deklaracja klasy CPELock
CPELock myPELock;


#pragma optimize("", off) // wylacz optymalizacje dla tej procedury (makra szyfrujace sa uzyte)

int _tmain(int argc, _TCHAR* argv[])
{
	// odczytaj identyfikator sprzetowy (do tego nie jest
	// potrzebny klucz licencyjny)
	if (myPELock.GetHardwareId(hardwareid, _countof(hardwareid)) != 0)
	{
		_tprintf(_T("Twoj identyfikator sprzetowy to %s\n"), hardwareid);
	}

	DEMO_START

	// odczytaj dane uzytkownika z klucza licencyjnego
	myPELock.GetRegistrationName(name, _countof(name));

	_tprintf(_T("Program zarejestrowany dla %s"), name);

	DEMO_END

	// sprawdz dlugosc odczytanych danych rejestracyjnych
	// uzytkownika, jesli bedzie = 0, oznaczac to bedzie
	// brak klucza licencyjnego (lub klucz niepoprawny)
	if (_tcsclen(name) == 0)
	{
		_tprintf(_T("Ta aplikacja nie jest zarejestrowana!"));
	}

	_tprintf(_T("\n\nNacisnij dowolny klawisz, aby kontynuowac . . ."));

	_getch();

	return 0;
}

#pragma optimize("", on) // z powrotem wlacz optymalizacje
