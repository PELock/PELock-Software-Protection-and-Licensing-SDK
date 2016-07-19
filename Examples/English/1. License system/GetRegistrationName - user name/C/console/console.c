////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read registered user name from the license key
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

unsigned char name[64] = { 0 };

int main(int argc, char *argv[])
{
	DEMO_START

	// read registered user name
	GetRegistrationName(name, 64);

	printf("Program registered to %s", name);

	DEMO_END

	// check registered user name length (0 - key not present)
	if (strlen(name) == 0)
	{
		printf("Evaluation version");
	}

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;
}
