////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak skorzystac z funkcji IsFeatureEnabled()
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

int main(int argc, char *argv[])
{
	// kod pomiedzy markerami DEMO_START i DEMO_END bedzie zaszyfrowany
	// w zabezpieczonej aplikacji i nie bedzie dostepny bez poprawnego
	// klucza licencyjnego
	DEMO_START

	printf("Witaj, to jest pelna wersja oprogramowania!");

	DEMO_END

	// sprawdz, czy 1 bit opcji klucza w ogole byl ustawiony
	if (IsFeatureEnabled(1) == TRUE)
	{
		FEATURE_1_START

		printf("\nTo wersja rozszerzona aplikacji (np. PRO).\n");

		FEATURE_1_END
	}

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
