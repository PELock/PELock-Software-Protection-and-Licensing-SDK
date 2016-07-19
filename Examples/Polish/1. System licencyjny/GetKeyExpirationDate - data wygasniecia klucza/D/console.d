////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac date wygasniecia klucza (o ile byla ustawiona)
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

SYSTEMTIME stSysTime = { 0 };

int main(string args[])
{
	// inicjalizuj klase PELock
	PELock myPELock = new PELock;

	// aby moc odczytac date wygasniecia klucza licencyjnego potrzebny
	// wymagane jest umieszczenie w programie chociaz jednego makra
	// DEMO_START lub FEATURE_x_START, bez tego system licencyjny nie
	// bedzie w ogole dostepny
	mixin(DEMO_START);

	// odczytaj date wygasniecia klucza (jesli byla w ogole ustawiona)
	// dane sa odczytywane do struktury SYSTEMTIME i wykorzystane sa
	// tylko pola dzien/miesiac/rok
	if (myPELock.GetKeyExpirationDate(&stSysTime) == 1)
	{
		writef("Data wygasniecia klucza %d-%d-%d", stSysTime.wDay, stSysTime.wMonth, stSysTime.wYear);
	}
	else
	{
		writef("To jest pelna wersja programu bez ograniczen czasowych.");
	}

	mixin(DEMO_END);

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
