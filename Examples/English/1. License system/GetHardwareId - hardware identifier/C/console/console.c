////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read hardware identifier
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

unsigned char hardware_id[PELOCK_MAX_HARDWARE_ID] = { 0 }, name[PELOCK_MAX_USERNAME] = { 0 };

int main(int argc, char *argv[])
{
	// read hardware id
	GetHardwareId(hardware_id, sizeof(hardware_id));

	// to be able to read hardware id, application should contain at least one
	// DEMO_START or FEATURE_x_START marker
	DEMO_START

	// get name of registered user
	GetRegistrationName(name, sizeof(name));

	// print registered user name
	printf("Program registered to %s", name);

	DEMO_END

	// display hardware ID in case of unregistered version
	if (strlen(name) == 0)
	{
		printf("Evaluation version, please provide this ID %s", hardware_id);
	}

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;
}
