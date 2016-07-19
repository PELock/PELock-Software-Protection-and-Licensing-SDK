////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac czas wykorzystania klucza
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

SYSTEMTIME stRunTime = { 0 };

int main(string args[])
{
	int i = 0;

	// inicjalizuj klase PELock
	PELock myPELock = new PELock;

	// aby moc odczytac czas uzytkownia klucza licencyjnego potrzebny
	// wymagane jest umieszczenie w programie chociaz jednego makra
	// DEMO_START lub FEATURE_x_START, bez tego system licencyjny nie
	// bedzie w ogole dostepny
	mixin(DEMO_START);

	writef("Czas wykorzystania klucza:\n\n");

	for (i = 0; i < 5; i++)
	{
		myPELock.GetKeyRunningTime(&stRunTime);

		writef("%d dni, %d miesiecy, %d lat (%d godzin, %d minut, %d sekund)\n", stRunTime.wDay, stRunTime.wMonth, stRunTime.wYear, stRunTime.wHour, stRunTime.wMinute, stRunTime.wSecond);

		// delay
		Sleep(1000);
	}

	mixin(DEMO_END);

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
