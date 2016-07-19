////////////////////////////////////////////////////////////////////////////////
//
// Przyklad uzycia makr punktow kontrolnych PELOCK_CPUID
//
// Wersja         : PELock v2.0
// Jezyk          : C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"

//
// wstawiaj makra PELOCK_CPUID w rzadko uzywanych procedurach
// co spowoduje, ze znalezienie tych makr bedzie bardzo trudne
// dla kogos, kto bedzie probowal zlamac zabezpieczona aplikacje
//
void rarely_used_procedure()
{
	// ukryty marker
	PELOCK_CPUID
}

int main(int argc, char *argv[])
{
	int dwImportantArray[] = { 0, 1, 2, 3 };

	//
	// makra punktow kontrolnych w zaden sposob nie zaklocaja
	// pracy aplikacji, jesli jednak ktos bedzie chcial uruchomic
	// zlamana lub rozpakowana aplikacje, kod makra PELOCK_CPUID
	// wywola wyjatek, tak ze zlamana/rozpakowana aplikacja nie
	// bedzie w efekcie dzialac poprawnie (nie bedzie funkcjonalna)
	//
	PELOCK_CPUID

	//
	// mozesz wylapac wyjatki spowodowane przez PELOCK_CPUID
	// po usunieciu zabezpieczenia i obsluzyc ta sytuacje wedle
	// wlasnego uznania
	//
	__try
	{
		PELOCK_CPUID
	}
	__except(EXCEPTION_EXECUTE_HANDLER)
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

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
