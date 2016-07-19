////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dane zarejestrowanego uzytkownika z klucza licencyjnego
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

TCHAR[64] name = 0;

int main(string args[])
{
	// inicjalizuj klase PELock
	PELock myPELock = new PELock;

	int name_len = 0;

	mixin(DEMO_START);

	// odczytaj dane zarejestrowanego uzytkownika
	name_len = myPELock.GetRegistrationName(name.ptr, 64);

	writef("Program zarejestrowany na %s", name);

	mixin(DEMO_END);

	// sprawdz, czy w ogole zostaly odczytane jakies dane uzytkownika
	// sprawdz dlugosc nazwy uzytkownika (0 - brak klucza licencyjnego)
	if (name_len == 0)
	{
		writef("Aplikacja nie jest zarejestrowana!");
	}

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
