////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use antidump PELOCK_MEMORY_GAP macro
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
	// this macro will create a 'memory hole' within your application
	// process space, this hole will be unavailable to the application
	// itself and other tools, including tools used to dump the memory
	// of the application, you can place this macro wherever you want,
	// it doesn't change execution of your application in any way
	mixin(PELOCK_MEMORY_GAP);

	writef("Hello world!");

	mixin(CRYPT_END);

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
