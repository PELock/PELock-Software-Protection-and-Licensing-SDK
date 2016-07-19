////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use PELOCK_CPUID macros
//
// Version        : PELock v2.0
// Language       : D
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

import std.stdio;
import std.string;
import core.stdc.stdio;
import core.sys.windows.windows;
import PELock;

//
// put PELOCK_CPUID macros in rarely used procedures
// so it would be harder to trace it's presence for someone
// trying to fully rebuild your protected application
//
void rarely_used_procedure()
{
	// hidden marker
	mixin(PELOCK_CPUID);
}

int main(string args[])
{
	int[4] dwImportantArray = [ 100, 200, 300, 400 ];

	//
	// these protection checks doesn't affect your application
	// in any way, but when someone will try to run cracked or
	// unpacked application, PELOCK_CPUID code will cause an
	// exception, so the cracked/unpacked application won't
	// work correctly
	//
	mixin(PELOCK_CPUID);

	//
	// you can catch exceptions caused by PELOCK_CPUID and
	// handle protection removal your own way
	//
	try
	{
		mixin(PELOCK_CPUID);
	}
	catch(Exception e)
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

	writef("Calculation result 100 + 100 = %d\n", dwImportantArray[0] + dwImportantArray[0] );

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
