////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dane o ograniczeniu czasowym (ilosc dni)
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

	int dwDaysTotal = 0, dwDaysLeft = 0;
	int dwTrialStatus = myPELock.TrialCodes.PELOCK_TRIAL_ABSENT;

	mixin(CRYPT_START);

	// read time trial information
	dwTrialStatus = myPELock.GetTrialDays(&dwDaysTotal, &dwDaysLeft);

	switch (dwTrialStatus)
	{

	//
	// time trial is active
	//
	case myPELock.TrialCodes.PELOCK_TRIAL_ACTIVE:

		writef("Trial version, %d days out of %d left.", dwDaysLeft, dwDaysTotal);
		break;

	//
	// trial expired, display custom nagscreen and close application
	// returned only when "Allow application to expire" option is enabled
	//
	case myPELock.TrialCodes.PELOCK_TRIAL_EXPIRED:

		writef("This version has expired and it will be closed!");
		break;

	//
	// trial options are not enabled for this file
	//
	case myPELock.TrialCodes.PELOCK_TRIAL_ABSENT:
	default:

		writef("No time trial limits or application is registered.");
		break;
	}

	mixin(CRYPT_END);

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
