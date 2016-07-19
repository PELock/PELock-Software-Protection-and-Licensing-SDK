////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read key creation date
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
	// to be able to read key creation date, program should
	// contain at least one DEMO_START & DEMO_END marker
	DEMO_START

	// read key createion date (if it was set)
	// key creation date is read into a SYSTEMTIME structure
	// and only day/month/years fields are set
	if (GetKeyCreationDate(&stSysTime) == 1)
	{
		printf("Key creation date %lu-%lu-%lu", stSysTime.wDay, stSysTime.wMonth, stSysTime.wYear);
	}
	else
	{
		printf("This key doesn't have creation date set.");
	}

	DEMO_END

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;
}
