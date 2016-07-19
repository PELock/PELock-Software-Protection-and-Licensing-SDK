////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read registered user name from the license key
//
// Version        : PELock v2.0
// Language       : C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"

#define _countof(array) (sizeof(array) / sizeof(array[0]))

TCHAR name[64] = { 0 };
TCHAR hardwareid[64] = { 0 };

// CPELock class declaration
CPELock myPELock;


#pragma optimize("", off) // disable optimizations (encryption macro is used inside this procedure)

int _tmain(int argc, _TCHAR* argv[])
{
	// read hardware id
	if (myPELock.GetHardwareId(hardwareid, _countof(hardwareid)) != 0)
	{
		_tprintf(_T("Your hardware id is %s\n"), hardwareid);
	}

	DEMO_START

	// read registered user name
	myPELock.GetRegistrationName(name, _countof(name));

	_tprintf(_T("Program registered to %s"), name);

	DEMO_END

	// check registered user name length (0 - key not present)
	if (_tcsclen(name) == 0)
	{
		_tprintf(_T("Evaluation version"));
	}

	_tprintf(_T("\n\nPress any key to exit . . ."));

	_getch();

	return 0;
}

#pragma optimize("", on) // enable optimizations again
