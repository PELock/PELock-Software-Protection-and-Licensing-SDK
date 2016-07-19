////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use PELock's protected constants
//
// Version        : PELock v2.0
// Language       : C/C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include "pelock.h"

int main(int argc, char *argv[])
{
	unsigned int i = 0, x = 0, y = 5;
	DWORD array[5];

	// you can use PELOCK_DWORD() wherever you want, it will
	// always return provided constant value
	for (i = 0; i < PELOCK_DWORD(3) ; i++ )
	{
		printf("%u\n", i);
	}

	// sizeof keyword redefinition #define sizeof(x) PELOCK_DWORD(sizeof(x))
	printf("sizeof(array) = %u\n", sizeof(array));

	// use it in calculations
	x = (1024 * y) + PELOCK_DWORD(-1);

	// use it in WinApi calls with other constant values
	MessageBox(NULL, "PELock's protected constants", "Hello world :)", PELOCK_DWORD( MB_ICONINFORMATION ) );

	// use it to initialize array items
	array[0] = PELOCK_DWORD(0);
	array[1] = PELOCK_DWORD(0xFF) + 100;

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;
}
