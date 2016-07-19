////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use CRYPT_START and CRYPT_END macros
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
	// code between CRYPT_START and CRYPT_END will be encrypted
	// in protected file
	CRYPT_START

	printf("Hello world!");

	CRYPT_END

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;
}
