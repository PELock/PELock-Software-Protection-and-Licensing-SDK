////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use FILE_CRYPT_START and FILE_CRYPT_END macros
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
	// code between FILE_CRYPT_START and FILE_CRYPT_END will be encrypted
	// in protected file (external file is used as an encryption key)
	FILE_CRYPT_START

	printf("Hello world!");

	FILE_CRYPT_END

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;
}
