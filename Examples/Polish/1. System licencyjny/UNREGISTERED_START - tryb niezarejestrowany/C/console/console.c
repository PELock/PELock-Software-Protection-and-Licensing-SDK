////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak uzywac makra szyfrujace UNREGISTERED_START i UNREGISTERED_END
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
	// wyswietl komunikat w niezarejestrowanej wersji programu
	//
	// nalezy umiescic przynajmniej jedno makro DEMO_START lub FEATURE_x_START,
	// aby mozna bylo skorzystac z makr UNREGISTERED_START
	UNREGISTERED_START

	printf("To jest wersja niezarejestrowana, prosze zakupic pelna wersje!\n");

	UNREGISTERED_END

	// kod pomiedzy makrami DEMO_START i DEMO_END bedzie zaszyfrowany
	// w zabezpieczonym pliku i nie bedzie dostepny (wykonany) bez
	// poprawnego klucza licencyjnego
	DEMO_START

	printf("Witaj w pelnej wersji mojej aplikacji!");

	DEMO_END

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
