////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read key running time (since it was set)
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

SYSTEMTIME stRunTime = { 0 };

int main(string args[])
{
	int i = 0;

	// initialize PELock class
	PELock myPELock = new PELock;

	// to be able to read key running time, program should
	// contain at least one DEMO_START & DEMO_END marker
	mixin(DEMO_START);

	writef("Key running time:\n\n");

	for (i = 0; i < 5; i++)
	{
		myPELock.GetKeyRunningTime(&stRunTime);

		writef("%d days, %d months, %d years (%d hours, %d minutes, %d seconds)\n", stRunTime.wDay, stRunTime.wMonth, stRunTime.wYear, stRunTime.wHour, stRunTime.wMinute, stRunTime.wSecond);

		// delay
		Sleep(1000);
	}

	mixin(DEMO_END);

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
