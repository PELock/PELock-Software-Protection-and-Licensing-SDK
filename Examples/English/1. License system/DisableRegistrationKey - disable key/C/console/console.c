////////////////////////////////////////////////////////////////////////////////
//
// Example of how to disable registration key at runtime
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
	DEMO_START

	// read registered user name
	GetRegistrationName(name, sizeof(name));

	printf("Program registered to %s\n", name);

	DEMO_END

	// something went wrong, disable registration key
	DisableRegistrationKey(FALSE);

	// reset name
	name[0] = 0;

	// following code won't be executed after disabling
	// license key!
	DEMO_START

	// read registered user name
	GetRegistrationName(name, sizeof(name));

	printf("Program registered to %s\n", name);

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
