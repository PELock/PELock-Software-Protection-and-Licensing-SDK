////////////////////////////////////////////////////////////////////////////////
//
// Przyklad wykorzystania makr zamazujacych kod CLEAR_START i CLEAR_END
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

unsigned int i = 0, j = 0;

void initialize_app(void)
{
	// kod pomiedzy makrami CLEAR_START i CLEAR_END bedzie zaszyfrowany
	// w zabezpieczonym pliku, po wykonaniu tego kodu, zostanie on
	// zamazany w pamieci, ponowna proba wykonania kodu, spowoduje
	// ze zostanie on ominiety (tak jakby go tam nie bylo)
	CLEAR_START

	i = 1;
	j = 2;

	CLEAR_END
}

int main(int argc, char *argv[])
{
	// inicjalizuj aplikacje
	initialize_app();

	// kod pomiedzy markerami CRYPT_START i CRYPT_END bedzie zaszyfrowany
	// w zabezpieczonym pliku
	CRYPT_START

	printf("Witaj swiecie!");

	CRYPT_END

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
