////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use FEATURE_x_START macros
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

int ExtraFunctionality(void)
{
	int dwResult = 0;

	// at least one DEMO_START / DEMO_END or FEATURE_x_START / FEATURE_x_END
	// marker is required, so that the license system will be active for
	// the protected application

	// with FEATURE_x markers you can enable some parts of your software
	// depending on the additional key settings

	// it's recommended to enclose encrypted code chunks within
	// some conditional code
	if (IsFeatureEnabled(1) == TRUE)
	{
		// code between those two markers will be encrypted, it won't
		// be available without proper feature settings stored in the key file
		FEATURE_1_START

		printf("Feature 1 -> enabled\n");

		dwResult = 1;

		FEATURE_1_END
	}

	return dwResult;
}

int main(int argc, char *argv[])
{
	ExtraFunctionality();

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;
}
