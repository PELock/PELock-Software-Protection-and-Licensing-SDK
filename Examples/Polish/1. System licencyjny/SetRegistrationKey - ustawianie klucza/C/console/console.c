////////////////////////////////////////////////////////////////////////////////
//
// Przyklad ustawiania klucza licencyjnego, ktory nie znajduje
// sie w glownym katalogu programu
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

unsigned char name[PELOCK_MAX_USERNAME] = { 0 };

int main(int argc, char *argv[])
{
	// ustaw sciezke do klucza licencyjnego, funkcja zadziala
	// tylko wtedy, gdy wczesniej nie zostal wykryty klucz
	// licencyjny w katalogu z programem lub w rejestrze systemowym
	//
	// aby mozna bylo w ogole skorzystac z tej funkcji, wymagane jest,
	// aby w programie byl umieszczony chociaz 1 marker DEMO_START
	// lub FEATURE_x_START, bez tego caly system licencyjny
	// bedzie nieaktywny
	SetRegistrationKey("c:\\key.lic");

	// jesli klucz licencyjny byl poprawny, bedzie mozliwe
	// wykonanie kodu znajdujacego sie pomiedzy makrami
	DEMO_START

	// odczytaj dane zarejestrowanego uzytkownika
	GetRegistrationName(name, sizeof(name));

	printf("Program zarejestrowany dla %s", name);

	DEMO_END

	if (strlen(name) == 0)
	{
		printf("Ta aplikacja nie jest zarejestrowana");
	}

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
