////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak uzyc makr szyfrujacych systemu licencyjnego FEATURE_x_START
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

int ExtraFunctionality(void)
{
	int dwResult = 0;

	// przynajmniej jedno makro DEMO_START / DEMO_END i/lub FEATURE_x_START / FEATURE_x_END
	// jest wymagane, aby system licencyjny byl w ogole aktywny

	// markery szyfrujace FEATURE_x moga byc uzyte, aby umozliwic dostep tylko do niektorych
	// opcji programu w zaleznosci od ustawien klucza licencyjnego

	// zalecane jest umieszczanie markerow szyfrujacych bezposrednio pomiedzy klamrami
	// warunkowymi, tutaj idealnie nadaje sie procedura IsFeatureEnabled(), ktora
	// sprawdzi, czy odpowiedni bit opcji byl ustawiony
	if (IsFeatureEnabled(1) == TRUE)
	{
		// kod pomiedzy tymi markermi bedzie zaszyfrowany i nie bedzie dostepny
		// bez poprawnego klucza licencyjnego, ani bez odpowiednio ustawionych bitow
		// opcji zapisanych w kluczu licencyjnym
		FEATURE_1_START

		printf("Opcja 1 -> wlaczona\n");

		dwResult = 1;

		FEATURE_1_END
	}

	return dwResult;
}

int main(int argc, char *argv[])
{
	ExtraFunctionality();

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
