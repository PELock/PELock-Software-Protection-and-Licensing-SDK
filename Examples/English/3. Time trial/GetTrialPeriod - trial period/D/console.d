////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read trial info (trial period)
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

	SYSTEMTIME stPeriodBegin = { 0 }, stPeriodEnd = { 0 };
	int dwTrialStatus = myPELock.TrialCodes.PELOCK_TRIAL_ABSENT;

	mixin(CRYPT_START);

	// read time trial information
	dwTrialStatus = myPELock.GetTrialPeriod(&stPeriodBegin, &stPeriodEnd);

	switch (dwTrialStatus)
	{

	//
	// time trial is active
	//
	case myPELock.TrialCodes.PELOCK_TRIAL_ACTIVE:

		writef("Trial period for this application:\n");
		writef("Period begin %u/%u/%u\n", stPeriodBegin.wDay, stPeriodBegin.wMonth, stPeriodBegin.wYear);
		writef("Period end   %u/%u/%u\n", stPeriodEnd.wDay, stPeriodEnd.wMonth, stPeriodEnd.wYear);
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
