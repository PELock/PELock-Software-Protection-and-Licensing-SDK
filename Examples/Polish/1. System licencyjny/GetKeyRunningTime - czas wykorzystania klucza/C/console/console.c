////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac czas wykorzystania klucza
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

SYSTEMTIME stRunTime = { 0 };

int main(int argc, char *argv[])
{
	int i = 0;

	// aby moc odczytac czas wykorzystania klucza licencyjnego
	// wymagane jest umieszczenie w programie chociaz jednego makra
	// DEMO_START lub FEATURE_x_START, bez tego system licencyjny nie
	// bedzie w ogole dostepny
	DEMO_START

	printf("Czas wykorzystania klucza:\n\n");

	for (i = 0; i < 5; i++)
	{
		GetKeyRunningTime(&stRunTime);

		printf("%lu dni, %lu miesiecy, %lu lat (%lu godzin, %lu minut, %lu sekund)\n", stRunTime.wDay, stRunTime.wMonth, stRunTime.wYear, stRunTime.wHour, stRunTime.wMinute, stRunTime.wSecond);

		// delay
		Sleep(1000);
	}

	DEMO_END

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
