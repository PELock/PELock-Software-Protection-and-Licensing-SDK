////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dodatkowe wartosci liczbowe klucza licencyjnego
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
	unsigned int nNumberOfItems = 0;

	// kod pomiedzy markerami DEMO_START i DEMO_END bedzie zaszyfrowany
	// w zabezpieczonym pliku i nie bedzie dostepny bez poprawnego klucza
	DEMO_START

	printf("To wersja oprogramowania jest zarejestrowana!\n");

	// odczytaj wartosc liczbowa zapisana w kluczu, PELock oferuje 16 indywidualnie ustawianych
	// wartosci, ktore moga byc uzyte jak tylko chcesz
	nNumberOfItems = GetKeyInteger(5);

	printf("Mozesz zapisac maksymalnie %u elementow w bazie danych\n", nNumberOfItems);

	DEMO_END

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
