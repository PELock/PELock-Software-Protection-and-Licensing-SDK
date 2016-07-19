////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dane z klucza licencyjnego (tryb UNICODE)
//
// Wersja         : PELock v2.0
// Jezyk          : C/C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#define UNICODE
#define _UNICODE

#include <windows.h>
#include <tchar.h>
#include <stdio.h>
#include <conio.h>
#include "pelock.h"

#define _countof(array) (sizeof(array) / sizeof(array[0]))

TCHAR name[64] = { 0 };
TCHAR hardwareid[64] = { 0 };

int main(int argc, char *argv[])
{
	// odczytaj identyfikator sprzetowy (do tego nie jest
	// potrzebny klucz licencyjny)
	if (GetHardwareId(hardwareid, _countof(hardwareid)) != 0)
	{
		_tprintf(_T("Twoj identyfikator sprzetowy to %s\n"), hardwareid);
	}

	// umiesc kod wykorzystujacy makra w klamrach warunkowych, bez tego,
	// niektore kompilatory C (Pelles C, LCC) wyprodukuja kod, ktory po
	// zabezpieczeniu pliku nie bedzie prawidlowo dzialac, spowodowane
	// jest to specyficzna organizacja stosu w przypadku uzycia makr
	// szyfrujacych
	if (IsPELockPresent1() == 1)
	{
		DEMO_START

		// odczytaj dane rejestracyjne uzytkownika z klucza licencyjnego
		GetRegistrationName(name, _countof(name));

		_tprintf(_T("Program zarejestrowany dla %s"), name);

		DEMO_END
	}

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
