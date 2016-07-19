////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read key running time (since it was set)
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

SYSTEMTIME stRunTime = { 0 };

int main(int argc, char *argv[])
{
	int i = 0;

	// to be able to read key running time, program should
	// contain at least one DEMO_START & DEMO_END marker
	DEMO_START

	printf("Key running time:\n\n");

	for (i = 0; i < 5; i++)
	{
		GetKeyRunningTime(&stRunTime);

		printf("%lu days, %lu months, %lu years (%lu hours, %lu minutes, %lu seconds)\n", stRunTime.wDay, stRunTime.wMonth, stRunTime.wYear, stRunTime.wHour, stRunTime.wMinute, stRunTime.wSecond);

		// delay
		Sleep(1000);
	}

	DEMO_END

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;
}
