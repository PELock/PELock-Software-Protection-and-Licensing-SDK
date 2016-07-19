////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak deaktywowac klucz licencyjny w czasie dzialania aplikacji
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

	mixin(DEMO_START);

	// odczytaj dane zarejestrowanego uzytkownika
	myPELock.GetRegistrationName(name.ptr, 64);

	writef("Program zarejestrowany na %s\n", name);

	mixin(DEMO_END);

	// cos w miedzyczasie poszlo nie tak, zablokuj klucz licencyjny!
	myPELock.DisableRegistrationKey(FALSE);

	// zresetuj dane zarejestrowanego uzytkownika
	name[0] = 0;

	// po wylaczeniu klucza, ten kod nie zostanie wykonany
	// aplikacja bedzie sie zachowywala, tak jak gdyby nie
	// bylo klucza i wszystkie sekcje i funkcje systemu
	// licencyjnego beda nieaktywne
	mixin(DEMO_START);

	// odczytaj dane zarejestrowanego uzytkownika
	myPELock.GetRegistrationName(name.ptr, 64);

	writef("Program zarejestrowany na %s\n", name);

	mixin(DEMO_END);

	// sprawdz, czy w ogole zostaly odczytane jakies dane uzytkownika
	// sprawdz dlugosc nazwy uzytkownika (0 - brak klucza licencyjnego)
	if (name[0] == 0)
	{
		writef("Aplikacja nie jest zarejestrowana!");
	}

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
