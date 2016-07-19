////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac informacje o statusie klucza licencyjnego
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
#include "pelock.h"

int main(int argc, char *argv[])
{
	int dwKeyStatus = PELOCK_KEY_NOT_FOUND;

	// odczytaj informacje o statusie klucza licencyjnego
	dwKeyStatus = GetKeyStatus();

	switch (dwKeyStatus)
	{

	//
	// klucz jest poprawny (wiec kod pomiedzy DEMO_START i DEMO_END powinien sie wykonac)
	//
	case PELOCK_KEY_OK:

		DEMO_START

		printf("Klucz licencyjny jest poprawny.");

		DEMO_END

		break;

	//
	// niepoprawny format klucza licencyjnego (uszkodzony)
	//
	case PELOCK_KEY_INVALID:

		printf("Klucz licencyjny jest niepoprawny (uszkodzony)!");
		break;

	//
	// klucz znajduje sie na liscie kluczy zablokowanych (kradzionych)
	//
	case PELOCK_KEY_STOLEN:

		printf("Klucz jest zablokowany!");
		break;

	//
	// komputer posiada inny identyfikator sprzetowy niz ten uzyty do zabezpieczenia klucza
	//
	case PELOCK_KEY_WRONG_HWID:

		printf("Identyfikator sprzetowy tego komputera nie pasuje do klucza licencyjnego!");
		break;

	//
	// klucz licencyjny jest wygasniety (nieaktywny)
	//
	case PELOCK_KEY_EXPIRED:

		printf("Klucz licencyjny jest wygasniety!");
		break;

	//
	// nie znaleziono klucza licencyjnego
	//
	case PELOCK_KEY_NOT_FOUND:
	default:

		printf("Nie znaleziono klucza licencyjnego.");
		break;
	}

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
