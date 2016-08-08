////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read hardware identifier
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
TCHAR[PELOCK_MAX_HARDWARE_ID] hardware_id = 0;

int main(string args[])
{
	// initialize PELock class
	PELock myPELock = new PELock;

	// registered user name length
	int name_len = 0;

	// read hardware id
	myPELock.GetHardwareId(hardware_id.ptr, hardware_id.length);

	// to be able to read hardware id, application should contain at least one
	// DEMO_START or FEATURE_x_START marker
	mixin(DEMO_START);

	// get name of registered user
	name_len = myPELock.GetRegistrationName(name.ptr, name.length);

	// print registered user name
	writef("Program registered to %s", name);

	mixin(DEMO_END);

	// display hardware ID in case of unregistered version
	if (name_len == 0)
	{
		writef("Evaluation version, please provide this ID %s", hardware_id);
	}

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
