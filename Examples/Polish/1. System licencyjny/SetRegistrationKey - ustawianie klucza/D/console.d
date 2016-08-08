////////////////////////////////////////////////////////////////////////////////
//
// Przyklad ustawiania klucza licencyjnego, ktory nie znajduje
// sie w glownym katalogu programu
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

TCHAR[PELOCK_MAX_USERNAME] name = 0;

int main(string args[])
{
	// inicjalizuj klase PELock
	PELock myPELock = new PELock;

	int name_len = 0;

	// ustaw sciezke do klucza licencyjnego, funkcja zadziala
	// tylko wtedy, gdy wczesniej nie zostal wykryty klucz
	// licencyjny w katalogu z programem lub w rejestrze systemowym
	//
	// aby mozna bylo w ogole skorzystac z tej funkcji, wymagane jest,
	// aby w programie byl umieszczony chociaz 1 marker DEMO_START
	// lub FEATURE_x_START, bez tego caly system licencyjny
	// bedzie nieaktywny
	myPELock.SetRegistrationKey(cast(TCHAR *)("c:\\key.lic"));

	// jesli klucz licencyjny byl poprawny, bedzie mozliwe
	// wykonanie kodu znajdujacego sie pomiedzy makrami
	mixin(DEMO_START);

	// odczytaj dane zarejestrowanego uzytkownika
	name_len = myPELock.GetRegistrationName(name.ptr, name.length);

	writef("Program zarejestrowany dla %s", name);

	mixin(DEMO_END);

	if (name_len == 0)
	{
		writef("Ta aplikacja nie jest zarejestrowana");
	}

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
