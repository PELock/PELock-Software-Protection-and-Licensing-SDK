////////////////////////////////////////////////////////////////////////////////
//
// Przyklad uzycia chronionych wartosci PELOCK_DWORD
//
// Wersja         : PELock v2.0
// Jezyk          : C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////
#include "stdafx.h"

// deklaracja klasy CPELock
CPELock g_PELock;

int main(int argc, char* argv[])
{
	// chronione zmienne moga byc wykorzystane zarowno jako makro
	// PELOCK_DWORD() lub jako element klasy CPELock (zalezne
	// od opcji PELOCK_DWORD_CLASS)
	for (unsigned int i = 0; i < g_PELock.PELOCK_DWORD(5); i++)
	{
		printf("Iteracja numer %u\n", i);
	}

	// chronione wartosci moga byc uzywane do obliczen,
	// jako stale wartosci funkcji, jako wartosci zwracane
	// w funkcjach etc.
	unsigned int x = g_PELock.PELOCK_DWORD(100) + g_PELock.PELOCK_DWORD(200);

	printf("Wynik = %u\n", x);

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;

}
