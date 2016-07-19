////////////////////////////////////////////////////////////////////////////////
//
// Example of how to check PELock protection presence
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

	// protection checks will always return TRUE for the
	// protected application, otherwise (unprotected application
	// or cracked) it will return FALSE and you can (or should)
	// do one of the following things:
	//
	// - close the application (when it's not expected, use
	//   timers or background threads to perform the checks)
	// - corrupt memory buffers
	// - initialize important variables with wrong values
	// - invoke exceptions (RaiseException())
	// - perform incorrect calculations (it it very hard to detect
	//   for the person who is trying to crack the application,
	//   if he doesn't remove all the checks and the application
	//   will be released, it won't work correctly)
	//
	// - DO NOT DISPLAY ANY WARNINGS THAT THE PROTECTION WAS
	//   REMOVED, THIS IS THE WORSE THING YOU CAN DO, BECAUSE
	//   IT CAN BE EASILY TRACED AND USED TO REMOVE THE
	//   PROTECTION CHECKS
	//
	// use your imagination :)

	writef("Detect PELock protection presence:\n\n");

	if (myPELock.IsPELockPresent1() == TRUE)
	{
		writef("1st method - PELock detected\n");
	}
	else
	{
		writef("1st method - PELock protection not found!\n");
	}

	if (myPELock.IsPELockPresent2() == TRUE)
	{
		writef("2nd method - PELock detected\n");
	}
	else
	{
		writef("2nd method - PELock protection not found!\n");
	}

	if (myPELock.IsPELockPresent3() == TRUE)
	{
		writef("3rd method - PELock detected\n");
	}
	else
	{
		writef("3rd method - PELock protection not found!\n");
	}

	if (myPELock.IsPELockPresent4() == TRUE)
	{
		writef("4th method - PELock detected\n");
	}
	else
	{
		writef("4th method - PELock protection not found!\n");
	}

	if (myPELock.IsPELockPresent5() == TRUE)
	{
		writef("5th method - PELock detected\n");
	}
	else
	{
		writef("5th method - PELock protection not found!\n");
	}

	if (myPELock.IsPELockPresent6() == TRUE)
	{
		writef("6th method - PELock detected\n");
	}
	else
	{
		writef("6th method - PELock protection not found!\n");
	}

	if (myPELock.IsPELockPresent7() == TRUE)
	{
		writef("7th method - PELock detected\n");
	}
	else
	{
		writef("7th method - PELock protection not found!\n");
	}

	if (myPELock.IsPELockPresent8() == TRUE)
	{
		writef("8th method - PELock detected\n");
	}
	else
	{
		writef("8th method - PELock protection not found!\n");
	}

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
