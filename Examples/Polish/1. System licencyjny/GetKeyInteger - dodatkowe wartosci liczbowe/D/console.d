////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dodatkowe wartosci liczbowe klucza licencyjnego
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

	uint nNumberOfItems = 0;

	// kod pomiedzy markerami DEMO_START i DEMO_END bedzie zaszyfrowany
	// w zabezpieczonym pliku i nie bedzie dostepny bez poprawnego klucza
	mixin(DEMO_START);

	writef("To wersja oprogramowania jest zarejestrowana!\n");

	// odczytaj wartosc liczbowa zapisana w kluczu, PELock oferuje 16 indywidualnie ustawianych
	// wartosci, ktore moga byc uzyte jak tylko chcesz
	nNumberOfItems = myPELock.GetKeyInteger(5);

	writef("Mozesz zapisac maksymalnie %d elementow w bazie danych\n", nNumberOfItems);

	mixin(DEMO_END);

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
