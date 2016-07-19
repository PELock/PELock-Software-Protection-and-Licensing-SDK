////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use PELOCK_CHECKPOINT macros
//
// Version        : PELock v2.0
// Language       : C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"

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
	//
	// these protection checks doesn't affect your application
	// in any way, but when someone will try to run cracked or
	// unpacked application, PELOCK_CHECKPOINT code will cause an
	// exception, so the cracked/unpacked application won't
	// work correctly
	//
	PELOCK_CHECKPOINT

	printf("Hello world, this app is protected, but shhh it's a secret :)\n");

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;
}
