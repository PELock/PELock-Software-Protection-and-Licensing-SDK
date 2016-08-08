////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dane zarejestrowanego uzytkownika z klucza licencyjnego
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

unsigned char name[PELOCK_MAX_USERNAME] = { 0 };

int main(int argc, char *argv[])
{
	DEMO_START

	// odczytaj dane zarejestrowanego uzytkownika
	GetRegistrationName(name, sizeof(name));

	printf("Program zarejestrowany na %s", name);

	DEMO_END

	// sprawdz, czy w ogole zostaly odczytane jakies dane uzytkownika
	// sprawdz dlugosc nazwy uzytkownika (0 - brak klucza licencyjnego)
	if (strlen(name) == 0)
	{
		printf("Aplikacja nie jest zarejestrowana!");
	}

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
