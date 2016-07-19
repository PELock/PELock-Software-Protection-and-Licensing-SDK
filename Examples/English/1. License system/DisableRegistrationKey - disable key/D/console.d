////////////////////////////////////////////////////////////////////////////////
//
// Example of how to disable registration key at runtime
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

TCHAR[64] name = 0;

int main(string args[])
{
	// initialize PELock class
	PELock myPELock = new PELock;

	mixin(DEMO_START);

	// read registered user name
	myPELock.GetRegistrationName(name.ptr, 64);

	writef("Program registered to %s\n", name);

	mixin(DEMO_END);

	// something went wrong, disable registration key
	myPELock.DisableRegistrationKey(FALSE);

	// reset name
	name[0] = 0;

	// following code won't be executed after disabling
	// license key!
	mixin(DEMO_START);

	// read registered user name
	myPELock.GetRegistrationName(name.ptr, 64);

	writef("Program registered to %s\n", name);

	mixin(DEMO_END);

	// check registered user name length (0 - key not present)
	if (name[0] == 0)
	{
		writef("Evaluation version");
	}

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
