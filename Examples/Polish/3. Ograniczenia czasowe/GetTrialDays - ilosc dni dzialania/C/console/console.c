////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dane o ograniczeniu czasowym (ilosc dni)
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
	int dwDaysTotal = 0, dwDaysLeft = 0;
	int dwTrialStatus = PELOCK_TRIAL_ABSENT;

	CRYPT_START

	// odczytaj status systemu ograniczenia czasowego
	dwTrialStatus = GetTrialDays(&dwDaysTotal, &dwDaysLeft);

	switch (dwTrialStatus)
	{

	//
	// system ograniczenia czasowego jest aktywny
	//
	case PELOCK_TRIAL_ACTIVE:

		printf("Wersja ograniczona, pozostalo %u dni z %u.", dwDaysLeft, dwDaysTotal);
		break;

	//
	// okres testowy wygasl, wyswietl wlasna informacje i zamknij aplikacje
	// kod zwracany tylko jesli bedzie wlaczona byla opcja
	// "Pozwol aplikacji na dzialanie po wygasnieciu" w przeciwnym wypadku
	// aplikacja jest automatycznie zamykana
	//
	case PELOCK_TRIAL_EXPIRED:

		printf("Ta aplikacja wygasla i bedzie zamknieta!");
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
