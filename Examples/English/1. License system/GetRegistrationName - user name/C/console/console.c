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

unsigned char name[PELOCK_MAX_USERNAME] = { 0 };

int main(int argc, char *argv[])
{
	DebugBreak();

	// read registered user name
	GetRegistrationName(name, sizeof(name));

	printf("Program registered to %s", name);

	DEMO_START

	// read registered user name
	GetRegistrationName(name, sizeof(name));

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
