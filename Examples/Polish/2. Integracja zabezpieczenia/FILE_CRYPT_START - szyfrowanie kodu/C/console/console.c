////////////////////////////////////////////////////////////////////////////////
//
// Przyklad wykorzystania makr szyfrujacych FILE_CRYPT_START i FILE_CRYPT_END
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
	// kod pomiedzy makrami FILE_CRYPT_START i FILE_CRYPT_END bedzie zaszyfrowany
	// w zabezpieczonym pliku (jako klucz szyfrujacy uzyty jest dowolny plik)
	FILE_CRYPT_START

	printf("Witaj swiecie!");

	FILE_CRYPT_END

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
