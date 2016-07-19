////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use DEMO_START and DEMO_END macros
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
	// code between DEMO_START and DEMO_END will be encrypted
	// in protected file and will not be available without license key
	mixin(DEMO_START);

	writef("Hello world from the full version of my software!");

	mixin(DEMO_END);

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
