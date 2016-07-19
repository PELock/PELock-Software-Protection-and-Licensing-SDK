////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read license key status information
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
	int dwKeyStatus = PELOCK_KEY_NOT_FOUND;

	// read license key status information
	dwKeyStatus = GetKeyStatus();

	switch (dwKeyStatus)
	{

	//
	// key is valid (so the code between DEMO_START and DEMO_END should be executed)
	//
	case PELOCK_KEY_OK:

		DEMO_START

		printf("License key is valid.");

		DEMO_END

		break;

	//
	// invalid format of the key (corrupted)
	//
	case PELOCK_KEY_INVALID:

		printf("License key is invalid (corrupted)!");
		break;

	//
	// license key was on the blocked keys list (stolen)
	//
	case PELOCK_KEY_STOLEN:

		printf("License key is blocked!");
		break;

	//
	// hardware identifier is different from the one used to encrypt license key
	//
	case PELOCK_KEY_WRONG_HWID:

		printf("Hardware identifier doesn't match to the license key!");
		break;

	//
	// license key is expired (not active)
	//
	case PELOCK_KEY_EXPIRED:

		printf("License key is expired!");
		break;

	//
	// license key not found
	//
	case PELOCK_KEY_NOT_FOUND:
	default:

		printf("License key not found.");
		break;
	}

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;
}
