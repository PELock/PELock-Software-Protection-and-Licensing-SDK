////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak deaktywowac klucz licencyjny w czasie dzialania aplikacji
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

	printf("Program zarejestrowany na %s\n", name);

	DEMO_END

	// cos w miedzyczasie poszlo nie tak, zablokuj klucz licencyjny!
	DisableRegistrationKey(FALSE);

	// zresetuj dane zarejestrowanego uzytkownika
	name[0] = 0;

	// po wylaczeniu klucza, ten kod nie zostanie wykonany
	// aplikacja bedzie sie zachowywala, tak jak gdyby nie
	// bylo klucza i wszystkie sekcje i funkcje systemu
	// licencyjnego beda nieaktywne
	DEMO_START

	// odczytaj dane zarejestrowanego uzytkownika
	GetRegistrationName(name, sizeof(name));

	printf("Program zarejestrowany na %s\n", name);

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
