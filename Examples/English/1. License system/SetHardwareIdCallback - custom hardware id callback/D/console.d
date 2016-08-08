////////////////////////////////////////////////////////////////////////////////
//
// Example of how to set custom hardware id callback routine
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

//
// custom hardware id callback
//
// return values:
//
// 1 - hardware identifier successfully generated
// 0 - an error occured, for example when dongle key was
//     not present), please note that any further calls to
//     GetHardwareId() or functions to set/reload
//     registration key locked to hardware id will fail
//     in this case (error codes will be returned)
//
extern (Windows) DWORD custom_hardware_id(LPBYTE output) nothrow
{
	int i = 0;

	//
	// copy custom hardware identifier to output buffer (8 bytes)
	//
	// you can create custom hardware identifier from:
	//
	// - dongle (hardware key) hardware identifier
	// - operating system information
	// - etc.
	//
	for (i = 0; i < 8 ; i++)
	{
		output[i] = cast(BYTE)(i + 1);
	}

	// return 1 to indicate success
	return 1;
}

int main(string args[])
{
	// initialize PELock class
	PELock myPELock = new PELock;

	// registered user name length
	int name_len = 0;

	// set our own hardware id callback routine (you need to enable
	// proper option in SDK tab)
	myPELock.SetHardwareIdCallback(&custom_hardware_id);

	// reload registration key (from default locations)
	myPELock.ReloadRegistrationKey();

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
