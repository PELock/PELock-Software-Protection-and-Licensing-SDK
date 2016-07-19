////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use PELock's protected constants
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

	uint i = 0, x = 0, y = 5;
	DWORD[5] array;

	// you can use PELOCK_DWORD() wherever you want, it will
	// always return provided constant value
	for (i = 0; i < myPELock.PELOCK_DWORD(3) ; i++ )
	{
		printf("%d\n", i);
	}

	// use it in calculations
	x = x + (1024 * y) + myPELock.PELOCK_DWORD(-1);

	// use it in WinApi calls with other constant values
	MessageBoxA(null, "PELock's protected constants", "Hello world :)", myPELock.PELOCK_DWORD( MB_ICONINFORMATION ) );

	// use it to initialize array items
	array[0] = myPELock.PELOCK_DWORD(0);
	array[1] = myPELock.PELOCK_DWORD(0xFF) + 100;

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
