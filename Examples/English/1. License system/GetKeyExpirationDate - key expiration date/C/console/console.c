////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read key expiration date
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

SYSTEMTIME stSysTime = { 0 };

int main(int argc, char *argv[])
{
	// to be able to read key expiration date, program should
	// contain at least one DEMO_START & DEMO_END marker
	DEMO_START

	// read key expiration date (if it was set)
	// expiration date is read into a SYSTEMTIME structure
	// and only day/month/years fields are set
	if (GetKeyExpirationDate(&stSysTime) == 1)
	{
		printf("Key expiration date %lu-%lu-%lu", stSysTime.wDay, stSysTime.wMonth, stSysTime.wYear);
	}
	else
	{
		printf("This is a full version without time limits.");
	}

	DEMO_END

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;
}
