////////////////////////////////////////////////////////////////////////////////
//
// Przyklad uzycia makr punktow kontrolnych PELOCK_CHECKPOINT
//
// Wersja         : PELock v2.0
// Jezyk          : C/C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include "pelock.h"

//
// wstawiaj makra PELOCK_CHECKPOINT w rzadko uzywanych procedurach
// co spowoduje, ze znalezienie tych makr bedzie bardzo trudne
// dla kogos, kto bedzie probowal zlamac zabezpieczona aplikacje
//
void rarely_used_procedure()
{
	// ukryty marker
	PELOCK_CHECKPOINT
}

int main(int argc, char *argv[])
{
	int dwImportantArray[] = { 100, 200, 300, 400 };

	//
	// makra punktow kontrolnych w zaden sposob nie zaklocaja
	// pracy aplikacji, jesli jednak ktos bedzie chcial uruchomic
	// zlamana lub rozpakowana aplikacje, kod makra PELOCK_CHECKPOINT
	// wywola wyjatek, tak ze zlamana/rozpakowana aplikacja nie
	// bedzie w efekcie dzialac poprawnie (nie bedzie funkcjonalna)
	//
	PELOCK_CHECKPOINT

	//
	// mozesz wylapac wyjatki spowodowane przez PELOCK_CHECKPOINT
	// po usunieciu zabezpieczenia i obsluzyc ta sytuacje wedle
	// wlasnego uznania
	//
	__try
	{
		PELOCK_CHECKPOINT
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

	printf("Wynik obliczenia 100 + 100 = %lu\n", dwImportantArray[0] + dwImportantArray[0] );

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
