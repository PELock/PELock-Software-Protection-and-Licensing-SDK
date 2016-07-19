////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read custom integer values stored in the keyfile
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

	uint nNumberOfItems = 0;

	// code between DEMO_START and DEMO_END will be encrypted
	// in protected file and will not be available without license key
	mixin(DEMO_START);

	writef("Hello world from the full version of my software!\n");

	// read key integer value, you can use it however you want
	nNumberOfItems = myPELock.GetKeyInteger(5);

	writef("You can store up to %d items in the database\n", nNumberOfItems);

	mixin(DEMO_END);

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
