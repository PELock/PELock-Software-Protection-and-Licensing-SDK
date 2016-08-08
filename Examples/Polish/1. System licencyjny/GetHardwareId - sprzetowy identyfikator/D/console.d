////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac identyfikator sprzetowy
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
TCHAR[PELOCK_MAX_HARDWARE_ID] hardware_id = 0;

int main(string args[])
{
	// inicjalizuj klase PELock
	PELock myPELock = new PELock;

	// dlugosc danych zarejestrowanego uzytkownika
	int name_len = 0;

	// odczytaj identyfikator sprzetowy do bufora hardware_id
	myPELock.GetHardwareId(hardware_id.ptr, hardware_id.length);

	// aby w ogole mozna bylo skorzystac z funkcji GetHardwareId()
	// wymagane jest, zeby program zawieral chociaz jedno makro DEMO_START
	// lub FEATURE_x_START, bez tego caly system licencyjny bedzie nieaktywny
	mixin(DEMO_START);

	// odczytaj dane zarejestrowanego uzytkownika
	name_len = myPELock.GetRegistrationName(name.ptr, name.length);

	// wyswietl dane zarejestrowanego uzytkownika
	writef("Program zarejestrowany dla %s", name);

	mixin(DEMO_END);

	// wyswietl sprzetowy identyfikator w przypadku, gdy aplikacja
	// nie jest jeszcze zarejestrowana
	if (name_len == 0)
	{
		writef("Aplikacja niezarejestrowana, przy rejestracji prosze podac ten ID %s", hardware_id);
	}

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
