////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read license key status information
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

int main(string args[])
{
	// initialize PELock class
	PELock myPELock = new PELock;

	int dwKeyStatus = myPELock.KeyStatusCodes.PELOCK_KEY_NOT_FOUND;

	// read license key status information
	dwKeyStatus = myPELock.GetKeyStatus();

	switch (dwKeyStatus)
	{

	//
	// key is valid (so the code between DEMO_START and DEMO_END should be executed)
	//
	case myPELock.KeyStatusCodes.PELOCK_KEY_OK:

		mixin(DEMO_START);

		writef("License key is valid.");

		mixin(DEMO_END);

		break;

	//
	// invalid format of the key (corrupted)
	//
	case myPELock.KeyStatusCodes.PELOCK_KEY_INVALID:

		writef("License key is invalid (corrupted)!");
		break;

	//
	// license key was on the blocked keys list (stolen)
	//
	case myPELock.KeyStatusCodes.PELOCK_KEY_STOLEN:

		writef("License key is blocked!");
		break;

	//
	// hardware identifier is different from the one used to encrypt license key
	//
	case myPELock.KeyStatusCodes.PELOCK_KEY_WRONG_HWID:

		writef("Hardware identifier doesn't match to the license key!");
		break;

	//
	// license key is expired (not active)
	//
	case myPELock.KeyStatusCodes.PELOCK_KEY_EXPIRED:

		writef("License key is expired!");
		break;

	//
	// license key not found
	//
	case myPELock.KeyStatusCodes.PELOCK_KEY_NOT_FOUND:
	default:

		writef("License key not found.");
		break;
	}

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
