////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dane o ograniczeniu czasowym (okres testowy)
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
	SYSTEMTIME stPeriodBegin = { 0 }, stPeriodEnd = { 0 };
	int dwTrialStatus = PELOCK_TRIAL_ABSENT;

	CRYPT_START

	// odczytaj status systemu ograniczenia czasowego
	dwTrialStatus = GetTrialPeriod(&stPeriodBegin, &stPeriodEnd);

	switch (dwTrialStatus)
	{

	//
	// system ograniczenia czasowego jest aktywny
	//
	case PELOCK_TRIAL_ACTIVE:

		printf("Okres dzialania dla tej aplikacji:\n");
		printf("Poczatek okresu %u/%u/%u\n", stPeriodBegin.wDay, stPeriodBegin.wMonth, stPeriodBegin.wYear);
		printf("Koniec okresu   %u/%u/%u\n", stPeriodEnd.wDay, stPeriodEnd.wMonth, stPeriodEnd.wYear);
		break;

	//
	// ograniczenia czasowe nie sa wlaczone dla tej aplikacji
	// lub aplikacja zostala zarejestrowana
	//
	case PELOCK_TRIAL_ABSENT:
	default:

		printf("Brak ograniczen czasowych lub aplikacja zostala zarejestrowana.");
		break;
	}

	CRYPT_END

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
