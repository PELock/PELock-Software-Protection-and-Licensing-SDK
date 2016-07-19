////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use FEATURE_x_START macros
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

int ExtraFunctionality()
{
	// initialize PELock class
	PELock myPELock = new PELock;

	int dwResult = 0;

	// at least one DEMO_START / DEMO_END or FEATURE_x_START / FEATURE_x_END
	// marker is required, so that the license system will be active for
	// the protected application

	// with FEATURE_x markers you can enable some parts of your software
	// depending on the additional key settings

	// it's recommended to enclose encrypted code chunks within
	// some conditional code
	if (myPELock.IsFeatureEnabled(1) == TRUE)
	{
		// code between those two markers will be encrypted, it won't
		// be available without proper feature settings stored in the key file
		mixin(FEATURE_1_START);

		writef("Feature 1 -> enabled\n");

		dwResult = 1;

		mixin(FEATURE_1_END);
	}

	return dwResult;
}

int main(string args[])
{
	ExtraFunctionality();

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
