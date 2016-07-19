////////////////////////////////////////////////////////////////////////////////
//
// Przyklad uzycia chronionych wartosci PELOCK_DWORD
//
// Wersja         : PELock v2.0
// Jezyk          : D
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

import std.stdio;
import std.string;
import core.stdc.stdio;
import core.sys.windows.windows;
import PELock;

int main(string args[])
{
	// inicjalizuj klase PELock
	PELock myPELock = new PELock;

	uint i = 0, x = 0, y = 5;
	DWORD[5] array;

	// mozesz uzywac PELOCK_DWORD() gdzie tylko chcesz, poniewaz zawsze
	// bedzie zwracac okreslona wartosc liczbowa, bledne wartosci beda
	// zwracane TYLKO I WYLACZNIE, gdy ktos usunie zabezpieczenie PELock'a
	// z wczesniej zabezpieczonej aplikacji
	for (i = 0; i < myPELock.PELOCK_DWORD(3) ; i++ )
	{
		printf("%d\n", i);
	}

	// najlepszy sposobem na ochrone aplikacji przed pelnym zlamaniem
	// jest uzywanie PELOCK_DWORD we wszelkiego rodzaju obliczeniach
	x = x + (1024 * y) + myPELock.PELOCK_DWORD(-1);

	// chronionych wartosci PELOCK_DWORD mozna takze uzywac do
	// przekazywania stalych flag funkcjom WinApi
	MessageBoxA(null, "Chronione wartosci PELock'a w akcji", "Witaj swiecie :)", myPELock.PELOCK_DWORD( MB_ICONINFORMATION ) );

	// inicjalizuj wartosci liczbowe
	array[0] = myPELock.PELOCK_DWORD(0);
	array[1] = myPELock.PELOCK_DWORD(0xFF) + 100;

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
