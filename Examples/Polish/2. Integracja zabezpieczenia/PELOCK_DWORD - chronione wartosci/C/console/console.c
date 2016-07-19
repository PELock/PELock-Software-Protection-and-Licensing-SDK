////////////////////////////////////////////////////////////////////////////////
//
// Przyklad uzycia chronionych wartosci PELOCK_DWORD
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
	unsigned int i = 0, x = 0, y = 5;
	DWORD array[5];

	// mozesz uzywac PELOCK_DWORD() gdzie tylko chcesz, poniewaz zawsze
	// bedzie zwracac okreslona wartosc liczbowa, bledne wartosci beda
	// zwracane TYLKO I WYLACZNIE, gdy ktos usunie zabezpieczenie PELock'a
	// z wczesniej zabezpieczonej aplikacji
	for (i = 0; i < PELOCK_DWORD(3) ; i++ )
	{
		printf("%u\n", i);
	}

	// redefinicja slowa kluczowego sizeof korzysta z makra PELOCK_DWORD
	// #define sizeof(x) PELOCK_DWORD(sizeof(x))
	printf("sizeof(array) = %u\n", sizeof(array));

	// najlepszy sposobem na ochrone aplikacji przed pelnym zlamaniem
	// jest uzywanie PELOCK_DWORD we wszelkiego rodzaju obliczeniach
	x = x + (1024 * y) + PELOCK_DWORD(-1);

	// chronionych wartosci PELOCK_DWORD mozna takze uzywac do
	// przekazywania stalych flag funkcjom WinApi
	MessageBox(NULL, "Chronione wartosci PELock'a w akcji", "Witaj swiecie :)", PELOCK_DWORD( MB_ICONINFORMATION ) );

	// inicjalizuj wartosci liczbowe
	array[0] = PELOCK_DWORD(0);
	array[1] = PELOCK_DWORD(0xFF) + 100;

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
