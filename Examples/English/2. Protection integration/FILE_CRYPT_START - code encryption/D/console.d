////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use FILE_CRYPT_START and FILE_CRYPT_END macros
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
	// code between FILE_CRYPT_START and FILE_CRYPT_END will be encrypted
	// in protected file (external file is used as an encryption key)
	mixin(FILE_CRYPT_START);

	writef("Hello world!");

	mixin(FILE_CRYPT_END);

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
