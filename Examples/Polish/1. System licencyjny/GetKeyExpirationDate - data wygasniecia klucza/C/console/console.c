////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac date wygasniecia klucza (o ile byla ustawiona)
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

SYSTEMTIME stSysTime = { 0 };

int main(int argc, char *argv[])
{
	// aby moc odczytac date wygasniecia klucza licencyjnego potrzebny
	// wymagane jest umieszczenie w programie chociaz jednego makra
	// DEMO_START lub FEATURE_x_START, bez tego system licencyjny nie
	// bedzie w ogole dostepny
	DEMO_START

	// odczytaj date wygasniecia klucza (jesli byla w ogole ustawiona)
	// dane sa odczytywane do struktury SYSTEMTIME i wykorzystane sa
	// tylko pola dzien/miesiac/rok
	if (GetKeyExpirationDate(&stSysTime) == 1)
	{
		printf("Data wygasniecia klucza %lu-%lu-%lu", stSysTime.wDay, stSysTime.wMonth, stSysTime.wYear);
	}
	else
	{
		printf("To jest pelna wersja programu bez ograniczen czasowych.");
	}

	DEMO_END

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
