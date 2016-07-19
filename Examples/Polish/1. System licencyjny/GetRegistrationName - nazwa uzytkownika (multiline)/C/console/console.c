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
#include <string.h>
#include <stdio.h>
#include <conio.h>
#include "pelock.h"

unsigned char name[64] = { 0 };
unsigned char *token = NULL;
unsigned char separators[] = "\r\n";
int i = 0;

int main(int argc, char *argv[])
{
	DEMO_START

	// odczytaj dane zarejestrowanego uzytkownika
	GetRegistrationName(name, 64);

	DEMO_END

	// sprawdz, czy w ogole zostaly odczytane jakies dane uzytkownika
	// sprawdz dlugosc nazwy uzytkownika (0 - brak klucza licencyjnego)
	if (strlen(name) != 0)
	{
		// podziel dane rejestracyjne na linie (puste linie sa ignorowane)
		token = strtok(name, separators);

		// wyswietl wszystkie linijki tekstu zapisane w kluczu (puste linie nie sa wyswietlane)
		while (token != NULL)
		{
			printf("Linia nr %u = \"%s\"\n", ++i, token);

			token = strtok(NULL, separators);
		}
	}
	else
	{
		printf("Aplikacja nie jest zarejestrowana!");
	}

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
