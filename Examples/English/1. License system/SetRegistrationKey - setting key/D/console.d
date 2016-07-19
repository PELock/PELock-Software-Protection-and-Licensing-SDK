////////////////////////////////////////////////////////////////////////////////
//
// Setting license key from external file (placed, somewhere else than
// protected application directory)
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

	int name_len = 0;

	// set license key path, this function will
	// work only if no other key was previously
	// set (either from file or registry)
	myPELock.SetRegistrationKey(cast(TCHAR *)("c:\\key.lic"));

	// to be able to read registered user name, application
	// should contain at least one DEMO_START or
	// FEATURE_x_START marker
	mixin(DEMO_START);

	// get name of registered user
	name_len = myPELock.GetRegistrationName(name.ptr, 64);

	writef("Program registered to %s", name);

	mixin(DEMO_END);

	if (name_len == 0)
	{
		writef("Evaluation version");
	}

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
