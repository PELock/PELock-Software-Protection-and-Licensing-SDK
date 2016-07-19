////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak ustawic wlasna procedure callback identyfikatora sprzetowego,
// wykorzystujac makro HARDWARE_ID_CALLBACK
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

TCHAR[64] hardware_id = 0, name = 0;

//
// wlasna procedura callback identyfikatora sprzetowego
//
// zwracane wartosci:
//
// 1 - identyfikator sprzetowy poprawnie wygenerowany
// 0 - wystapil blad, przykladowo klucz sprzetowy nie
//     byl obecny), nalezy zauwazyc, ze w tej sytuacji
//     wszystkie wywolania do GetHardwareId() oraz
//     procedur ustawiajacych badz przeladowujacych klucz
//     zablokowany na sprzetowy identyfikator nie beda
//     funkcjonowaly (beda zwracane kody bledow)
//
extern (Windows) DWORD custom_hardware_id(LPBYTE output)
{
	int i = 0;

	// ten marker bedzie uzyty do zlokalizowania procedury custom_hardware_id()
	// (nalezy wczesniej wlaczyc odpowiednia opcje w zakladce SDK)
	mixin(HARDWARE_ID_CALLBACK);

	//
	// kopiuj wlasny identyfikator sprzetowy do wyjsciowego bufora (8 bajtow)
	//
	// identyfikator sprzetowy moze byc utworzony z:
	//
	// - identyfikatora klucza sprzetowego (dongle)
	// - informacji z systemu operacyjnego
	// - etc.
	//
	for (i = 0; i < 8 ; i++)
	{
		output[i] = cast(BYTE)(i + 1);
	}

	// zwroc 1, co oznacza sukces
	return 1;
}

int main(string args[])
{
	// inicjalizuj klase PELock
	PELock myPELock = new PELock;

	// dlugosc danych zarejestrowanego uzytkownika
	int name_len = 0;

	// odczytaj identyfikator sprzetowy do bufora hardware_id
	myPELock.GetHardwareId(hardware_id.ptr, 64);

	// aby w ogole mozna bylo skorzystac z funkcji GetHardwareId()
	// wymagane jest, zeby program zawieral chociaz jedno makro DEMO_START
	// lub FEATURE_x_START, bez tego caly system licencyjny bedzie nieaktywny
	mixin(DEMO_START);

	// odczytaj dane zarejestrowanego uzytkownika
	name_len = myPELock.GetRegistrationName(name.ptr, 64);

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

	// ochrona przed optymalizacja kompilatora (zeby nie usunal nieuzywanej funkcji)
	if (&custom_hardware_id == null) custom_hardware_id(null);

	getchar();

	return 0;
}
