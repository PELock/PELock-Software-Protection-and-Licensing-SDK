////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read trial info (number of trial executions)
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
	int dwExecsTotal = 0, dwExecsLeft = 0;
	int dwTrialStatus = PELOCK_TRIAL_ABSENT;

	CRYPT_START

	// read time trial information
	dwTrialStatus = GetTrialExecutions(&dwExecsTotal, &dwExecsLeft);

	switch (dwTrialStatus)
	{

	//
	// time trial is active
	//
	case PELOCK_TRIAL_ACTIVE:

		printf("Trial version, %u executions out of %u left.", dwExecsLeft, dwExecsTotal);
		break;

	//
	// trial expired, display custom nagscreen and close application
	// returned only when "Allow application to expire" option is enabled
	//
	case PELOCK_TRIAL_EXPIRED:

		printf("This version has expired and it will be closed!");
		break;

	//
	// trial options are not enabled for this file
	//
	case PELOCK_TRIAL_ABSENT:
	default:

		printf("No time trial limits.");
		break;
	}

	CRYPT_END

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;
}
