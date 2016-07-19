////////////////////////////////////////////////////////////////////////////////
//
// Setting license key from external file (placed, somewhere else than
// protected application directory)
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
	// set license key path, this function will
	// work only if no other key was previously
	// set (either from file or registry)
	SetRegistrationKey("c:\\key.lic");

	// to be able to read registered user name, application
	// should contain at least one DEMO_START or
	// FEATURE_x_START marker
	DEMO_START

	// get name of registered user
	GetRegistrationName(name,64);

	printf("Program registered to %s", name);

	DEMO_END

	if (strlen(name) == 0)
	{
		printf("Evaluation version");
	}

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;
}
