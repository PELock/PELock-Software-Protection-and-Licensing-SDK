////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read trial info (trial period)
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
	SYSTEMTIME stPeriodBegin = { 0 }, stPeriodEnd = { 0 };
	int dwTrialStatus = PELOCK_TRIAL_ABSENT;

	CRYPT_START

	// read time trial information
	dwTrialStatus = GetTrialPeriod(&stPeriodBegin, &stPeriodEnd);

	switch (dwTrialStatus)
	{

	//
	// time trial is active
	//
	case PELOCK_TRIAL_ACTIVE:

		printf("Trial period for this application:\n");
		printf("Period begin %u/%u/%u\n", stPeriodBegin.wDay, stPeriodBegin.wMonth, stPeriodBegin.wYear);
		printf("Period end   %u/%u/%u\n", stPeriodEnd.wDay, stPeriodEnd.wMonth, stPeriodEnd.wYear);
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
