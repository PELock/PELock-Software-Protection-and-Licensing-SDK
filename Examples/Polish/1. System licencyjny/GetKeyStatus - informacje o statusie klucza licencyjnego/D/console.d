////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac informacje o statusie klucza licencyjnego
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

	int dwKeyStatus = myPELock.KeyStatusCodes.PELOCK_KEY_NOT_FOUND;

	// odczytaj informacje o statusie klucza licencyjnego
	dwKeyStatus = myPELock.GetKeyStatus();

	switch (dwKeyStatus)
	{

	//
	// klucz jest poprawny (wiec kod pomiedzy DEMO_START i DEMO_END powinien sie wykonac)
	//
	case myPELock.KeyStatusCodes.PELOCK_KEY_OK:

		mixin(DEMO_START);

		writef("Klucz licencyjny jest poprawny.");

		mixin(DEMO_END);

		break;

	//
	// niepoprawny format klucza licencyjnego (uszkodzony)
	//
	case myPELock.KeyStatusCodes.PELOCK_KEY_INVALID:

		writef("Klucz licencyjny jest niepoprawny (uszkodzony)!");
		break;

	//
	// klucz znajduje sie na liscie kluczy zablokowanych (kradzionych)
	//
	case myPELock.KeyStatusCodes.PELOCK_KEY_STOLEN:

		writef("Klucz jest zablokowany!");
		break;

	//
	// komputer posiada inny identyfikator sprzetowy niz ten uzyty do zabezpieczenia klucza
	//
	case myPELock.KeyStatusCodes.PELOCK_KEY_WRONG_HWID:

		writef("Identyfikator sprzetowy tego komputera nie pasuje do klucza licencyjnego!");
		break;

	//
	// klucz licencyjny jest wygasniety (nieaktywny)
	//
	case myPELock.KeyStatusCodes.PELOCK_KEY_EXPIRED:

		writef("Klucz licencyjny jest wygasniety!");
		break;

	//
	// nie znaleziono klucza licencyjnego
	//
	case myPELock.KeyStatusCodes.PELOCK_KEY_NOT_FOUND:
	default:

		writef("Nie znaleziono klucza licencyjnego.");
		break;
	}

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
