////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak skorzystac z funkcji IsFeatureEnabled()
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

	// kod pomiedzy markerami DEMO_START i DEMO_END bedzie zaszyfrowany
	// w zabezpieczonej aplikacji i nie bedzie dostepny bez poprawnego
	// klucza licencyjnego
	mixin(DEMO_START);

	writef("Witaj, to jest pelna wersja oprogramowania!");

	mixin(DEMO_END);

	// sprawdz, czy 1 bit opcji klucza w ogole byl ustawiony
	if (myPELock.IsFeatureEnabled(1) == TRUE)
	{
		mixin(FEATURE_1_START);

		writef("\nTo wersja rozszerzona aplikacji (np. PRO).\n");

		mixin(FEATURE_1_END);
	}

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
