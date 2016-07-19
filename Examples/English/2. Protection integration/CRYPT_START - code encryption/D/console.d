////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use CRYPT_START and CRYPT_END macros
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
	// code between CRYPT_START and CRYPT_END will be encrypted
	// in protected file
	mixin(CRYPT_START);

	writef("Hello world!");

	mixin(CRYPT_END);

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
