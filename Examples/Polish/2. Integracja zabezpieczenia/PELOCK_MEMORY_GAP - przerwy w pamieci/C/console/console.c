////////////////////////////////////////////////////////////////////////////////
//
// Przyklad wykorzystania makra ochrony pamieci PELOCK_MEMORY_GAP
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
	// makro spowoduje, ze po uruchomieniu aplikacji w pamieci aplikacji
	// zostanie umieszczony obszar niedostepny dla samej aplikacji (jedynie
	// w obszarze makra), stanowi to dodatkowe zabezpieczenie przed zrzucaniem
	// pamieci aplikacji (dumping), makro to nie ma zadnego wplywu na dzialanie
	// aplikacji i moze byc umieszczane w dowolnych punktach programu
	PELOCK_MEMORY_GAP

	printf("Witaj swiecie!");

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
