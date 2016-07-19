////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use CLEAR_START and CLEAR_END macros
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

uint i = 0, j = 0;

void initialize_app()
{
	// code between CLEAR_START and CLEAR_END will be encrypted, and
	// once executed it will be erased from the memory
	mixin(CLEAR_START);

	i = 1;
	j = 2;

	mixin(CLEAR_END);
}

int main(string args[])
{
	// inicjalizuj aplikacje
	initialize_app();

	// code between CRYPT_START and CRYPT_END will be encrypted
	// in protected file
	mixin(CRYPT_START);

	writef("Hello world!");

	mixin(CRYPT_END);

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
