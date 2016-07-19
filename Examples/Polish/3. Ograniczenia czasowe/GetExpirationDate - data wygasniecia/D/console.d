////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dane o ograniczeniu czasowym (date wygasniecia)
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

	SYSTEMTIME stExpirationDate = { 0 };
	int dwTrialStatus = myPELock.TrialCodes.PELOCK_TRIAL_ABSENT;

	mixin(CRYPT_START);

	// odczytaj status systemu ograniczenia czasowego
	dwTrialStatus = myPELock.GetExpirationDate(&stExpirationDate);

	switch (dwTrialStatus)
	{

	//
	// system ograniczenia czasowego jest aktywny
	//
	case myPELock.TrialCodes.PELOCK_TRIAL_ACTIVE:

		writef("Wersja ograniczona, data wygasniecia %d/%d/%d.", stExpirationDate.wDay, stExpirationDate.wMonth, stExpirationDate.wYear);
		break;

	//
	// okres testowy wygasl, wyswietl wlasna informacje i zamknij aplikacje
	// kod zwracany tylko jesli bedzie wlaczona byla opcja
	// "Pozwol aplikacji na dzialanie po wygasnieciu" w przeciwnym wypadku
	// aplikacja jest automatycznie zamykana
	//
	case myPELock.TrialCodes.PELOCK_TRIAL_EXPIRED:

		writef("Ta aplikacja wygasla i bedzie zamknieta!");
		break;

	//
	// ograniczenia czasowe nie sa wlaczone dla tej aplikacji
	// lub aplikacja zostala zarejestrowana
	//
	case myPELock.TrialCodes.PELOCK_TRIAL_ABSENT:
	default:

		writef("Brak ograniczen czasowych lub aplikacja zostala zarejestrowana.");
		break;
	}

	mixin(CRYPT_END);

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
