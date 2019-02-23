////////////////////////////////////////////////////////////////////////////////
//
// Example of how to check if the key is locked to the hardware identifier
//
// Version        : PELock v2.09
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

	mixin(DEMO_START);

	// is the key locked to the hardware identifier
	BOOL bIsKeyHardwareIdLocked = myPELock.IsKeyHardwareIdLocked();

	if (bIsKeyHardwareIdLocked == TRUE)
	{
		writef("This key is locked to the hardware identifier!");
	}
	else
	{
		writef("This key is NOT locked to the hardware identifier!");
	}

	mixin(DEMO_END);

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
