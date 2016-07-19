////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dane o ograniczeniu czasowym (okres testowy)
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

	SYSTEMTIME stPeriodBegin = { 0 }, stPeriodEnd = { 0 };
	int dwTrialStatus = myPELock.TrialCodes.PELOCK_TRIAL_ABSENT;

	mixin(CRYPT_START);

	// odczytaj status systemu ograniczenia czasowego
	dwTrialStatus = myPELock.GetTrialPeriod(&stPeriodBegin, &stPeriodEnd);

	switch (dwTrialStatus)
	{

	//
	// system ograniczenia czasowego jest aktywny
	//
	case myPELock.TrialCodes.PELOCK_TRIAL_ACTIVE:

		writef("Okres dzialania dla tej aplikacji:\n");
		writef("Poczatek okresu %d/%d/%d\n", stPeriodBegin.wDay, stPeriodBegin.wMonth, stPeriodBegin.wYear);
		writef("Koniec okresu   %d/%d/%d\n", stPeriodEnd.wDay, stPeriodEnd.wMonth, stPeriodEnd.wYear);
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
