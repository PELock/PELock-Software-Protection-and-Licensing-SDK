////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak sprawdzic czy klucz jest zablokowany na sprzetowy identyfikator
//
// Wersja         : PELock v2.09
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
	DEMO_START

	// czy klucz jest zablokowany na sprzetowy identyfikator
	BOOL bIsKeyHardwareIdLocked = IsKeyHardwareIdLocked();

	if (bIsKeyHardwareIdLocked == TRUE)
	{
		printf("Ten klucz jest zablokowany na sprzetowy identyfikator!");
	}
	else
	{
		printf("Ten klucz NIE jest zablokowany na sprzetowy identyfikator!");
	}

	DEMO_END
	
	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
