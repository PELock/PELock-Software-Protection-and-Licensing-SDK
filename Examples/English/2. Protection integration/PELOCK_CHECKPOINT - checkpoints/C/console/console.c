////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use PELOCK_CHECKPOINT macros
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

//
// put PELOCK_CHECKPOINT macros in rarely used procedures
// so it would be harder to trace it's presence for someone
// trying to fully rebuild your protected application
//
void rarely_used_procedure()
{
	// hidden marker
	PELOCK_CHECKPOINT
}

int main(int argc, char *argv[])
{
	int dwImportantArray[] = { 100, 200, 300, 400 };

	//
	// these protection checks doesn't affect your application
	// in any way, but when someone will try to run cracked or
	// unpacked application, PELOCK_CHECKPOINT code will cause an
	// exception, so the cracked/unpacked application won't
	// work correctly
	//
	PELOCK_CHECKPOINT

	//
	// you can catch exceptions caused by PELOCK_CHECKPOINT and
	// handle protection removal your own way
	//
	__try
	{
		PELOCK_CHECKPOINT
	}
	__except(EXCEPTION_EXECUTE_HANDLER)
	{
		//
		// - close application
		// - damage memory area
		// - disable some controls
		// - change some important variables
		//
		// DON'T DISPLAY ANY WARNING MESSAGES!!!
		//
		dwImportantArray[0] += 4;
	}

	printf("Calculation result 100 + 100 = %lu\n", dwImportantArray[0] + dwImportantArray[0] );

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;
}
