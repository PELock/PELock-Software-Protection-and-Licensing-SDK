////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac identyfikator sprzetowy
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

unsigned char hardware_id[64] = { 0 }, name[64] = { 0 };

int main(int argc, char *argv[])
{
	// odczytaj identyfikator sprzetowy do bufora hardware_id
	GetHardwareId(hardware_id, 64);

	// aby w ogole mozna bylo skorzystac z funkcji GetHardwareId()
	// wymagane jest, zeby program zawieral chociaz jedno makro DEMO_START
	// lub FEATURE_x_START, bez tego caly system licencyjny bedzie nieaktywny
	DEMO_START

	// odczytaj dane zarejestrowanego uzytkownika
	GetRegistrationName(name, 64);

	// wyswietl dane zarejestrowanego uzytkownika
	printf("Program zarejestrowany dla %s", name);

	DEMO_END

	// wyswietl sprzetowy identyfikator w przypadku, gdy aplikacja
	// nie jest jeszcze zarejestrowana
	if (strlen(name) == 0)
	{
		printf("Aplikacja niezarejestrowana, przy rejestracji prosze podac ten ID %s", hardware_id);
	}

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
