////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read registered user name from the license key
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

TCHAR[PELOCK_MAX_USERNAME] name = 0;

int main(string args[])
{
	// initialize PELock class
	PELock myPELock = new PELock;

	int name_len = 0;

	mixin(DEMO_START);

	// read registered user name
	name_len = myPELock.GetRegistrationName(name.ptr, name.length);

	writef("Program registered to %s", name);

	mixin(DEMO_END);

	// check registered user name length (0 - key not present)
	if (name_len == 0)
	{
		writef("Evaluation version");
	}

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
