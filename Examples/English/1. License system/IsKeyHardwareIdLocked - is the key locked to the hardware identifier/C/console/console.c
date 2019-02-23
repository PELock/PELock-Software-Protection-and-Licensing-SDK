////////////////////////////////////////////////////////////////////////////////
//
// Example of how to check if the key is locked to the hardware identifier
//
// Version        : PELock v2.09
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
	DEMO_START

	// is the key locked to the hardware identifier
	BOOL bIsKeyHardwareIdLocked = IsKeyHardwareIdLocked();

	if (bIsKeyHardwareIdLocked == TRUE)
	{
		printf("This key is locked to the hardware identifier!");
	}
	else
	{
		printf("This key is NOT locked to the hardware identifier!");
	}

	DEMO_END

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;
}
