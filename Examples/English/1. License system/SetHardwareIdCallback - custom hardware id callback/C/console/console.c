////////////////////////////////////////////////////////////////////////////////
//
// Example of how to set custom hardware id callback routine
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

//
// custom hardware id callback
//
// return values:
//
// 1 - hardware identifier successfully generated
// 0 - an error occured, for example when dongle key was
//     not present), please note that any further calls to
//     GetHardwareId() or functions to set/reload
//     registration key locked to hardware id will fail
//     in this case (error codes will be returned)
//
int custom_hardware_id(unsigned char output[8])
{
	int i = 0;

	//
	// copy custom hardware identifier to output buffer (8 bytes)
	//
	// you can create custom hardware identifier from:
	//
	// - dongle (hardware key) hardware identifier
	// - operating system information
	// - etc.
	//
	for (i = 0; i < 8 ; i++)
	{
		output[i] = i + 1;
	}

	// return 1 to indicate success
	return 1;
}

int main(int argc, char *argv[])
{
	// set our own hardware id callback routine (you need to enable
	// proper option in SDK tab)
	SetHardwareIdCallback(&custom_hardware_id);

	// reload registration key (from default locations)
	ReloadRegistrationKey();
	
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
