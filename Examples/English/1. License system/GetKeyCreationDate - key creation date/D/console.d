////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read key creation date
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

SYSTEMTIME stSysTime = { 0 };

int main(string args[])
{
	// initialize PELock class
	PELock myPELock = new PELock;

	// to be able to read key creation date, program should
	// contain at least one DEMO_START & DEMO_END marker
	mixin(DEMO_START);

	// read key createion date (if it was set)
	// key creation date is read into a SYSTEMTIME structure
	// and only day/month/years fields are set
	if (myPELock.GetKeyCreationDate(&stSysTime) == 1)
	{
		writef("Key creation date %d-%d-%d", stSysTime.wDay, stSysTime.wMonth, stSysTime.wYear);
	}
	else
	{
		writef("This key doesn't have creation date set.");
	}

	mixin(DEMO_END);

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
