////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use CLEAR_START and CLEAR_END macros
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

unsigned int i = 0, j = 0;

void initialize_app(void)
{
	// code between CLEAR_START and CLEAR_END will be encrypted, and
	// once executed it will be erased from the memory
	CLEAR_START

	i = 1;
	j = 2;

	CLEAR_END
}

int main(int argc, char *argv[])
{
	// initialize application
	initialize_app();

	// code between CRYPT_START and CRYPT_END will be encrypted
	// in protected file
	CRYPT_START

	printf("Hello world!");

	CRYPT_END

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;
}
