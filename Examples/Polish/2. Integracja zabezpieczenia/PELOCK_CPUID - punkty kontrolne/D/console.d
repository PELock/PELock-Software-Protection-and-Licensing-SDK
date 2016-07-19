////////////////////////////////////////////////////////////////////////////////
//
// Przyklad uzycia makr punktow kontrolnych PELOCK_CPUID
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

//
// wstawiaj makra PELOCK_CPUID w rzadko uzywanych procedurach
// co spowoduje, ze znalezienie tych makr bedzie bardzo trudne
// dla kogos, kto bedzie probowal zlamac zabezpieczona aplikacje
//
void rarely_used_procedure()
{
	// ukryty marker
	mixin(PELOCK_CPUID);
}

int main(string args[])
{
	int[4] dwImportantArray = [ 100, 200, 300, 400 ];

	//
	// makra punktow kontrolnych w zaden sposob nie zaklocaja
	// pracy aplikacji, jesli jednak ktos bedzie chcial uruchomic
	// zlamana lub rozpakowana aplikacje, kod makra PELOCK_CPUID
	// wywola wyjatek, tak ze zlamana/rozpakowana aplikacja nie
	// bedzie w efekcie dzialac poprawnie (nie bedzie funkcjonalna)
	//
	mixin(PELOCK_CPUID);

	//
	// mozesz wylapac wyjatki spowodowane przez PELOCK_CPUID
	// po usunieciu zabezpieczenia i obsluzyc ta sytuacje wedle
	// wlasnego uznania
	//
	try
	{
		mixin(PELOCK_CPUID);
	}
	catch(Exception e)
	{
		//
		// - zamknij aplikacje
		// - uszkodz pamiec aplikacji
		// - wylacz jakies kontrolki
		// - zmien jakies wazne zmienne
		//
		// NIE WYSWIETLAJ ZADNYCH INFORMACJI OSTRZEGAWCZYCH!!!
		//
		dwImportantArray[0] += 4;
	}

	writef("Wynik obliczenia 100 + 100 = %d\n", dwImportantArray[0] + dwImportantArray[0] );

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
