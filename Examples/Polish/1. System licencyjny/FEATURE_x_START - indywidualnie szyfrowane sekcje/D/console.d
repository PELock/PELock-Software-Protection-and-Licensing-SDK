////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak uzyc makr szyfrujacych systemu licencyjnego FEATURE_x_START
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

int ExtraFunctionality()
{
	// inicjalizuj klase PELock
	PELock myPELock = new PELock;

	int dwResult = 0;

	// przynajmniej jedno makro DEMO_START / DEMO_END i/lub FEATURE_x_START / FEATURE_x_END
	// jest wymagane, aby system licencyjny byl w ogole aktywny

	// markery szyfrujace FEATURE_x moga byc uzyte, aby umozliwic dostep tylko do niektorych
	// opcji programu w zaleznosci od ustawien klucza licencyjnego

	// zalecane jest umieszczanie markerow szyfrujacych bezposrednio pomiedzy klamrami
	// warunkowymi, tutaj idealnie nadaje sie procedura IsFeatureEnabled(), ktora
	// sprawdzi, czy odpowiedni bit opcji byl ustawiony
	if (myPELock.IsFeatureEnabled(1) == TRUE)
	{
		// kod pomiedzy tymi markermi bedzie zaszyfrowany i nie bedzie dostepny
		// bez poprawnego klucza licencyjnego, ani bez odpowiednio ustawionych bitow
		// opcji zapisanych w kluczu licencyjnym
		mixin(FEATURE_1_START);

		writef("Opcja 1 -> wlaczona\n");

		dwResult = 1;

		mixin(FEATURE_1_END);
	}

	return dwResult;
}

int main(string args[])
{
	ExtraFunctionality();

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
