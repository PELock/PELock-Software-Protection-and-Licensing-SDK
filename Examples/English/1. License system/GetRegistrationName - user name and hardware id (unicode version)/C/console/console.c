////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read registered user name from the license key
//
// Version        : PELock v2.0
// Language       : C/C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#define UNICODE
#define _UNICODE

#include <windows.h>
#include <tchar.h>
#include <stdio.h>
#include <conio.h>
#include "pelock.h"

#define _countof(array) (sizeof(array) / sizeof(array[0]))

TCHAR name[PELOCK_MAX_USERNAME] = { 0 };
TCHAR hardwareid[PELOCK_MAX_HARDWARE_ID] = { 0 };

int main(int argc, char *argv[])
{
	// read hardware id
	if (GetHardwareId(hardwareid, _countof(hardwareid)) != 0)
	{
		_tprintf(_T("Your hardware id is %s\n"), hardwareid);
	}

	// put this code in conditional braces, without it, some C compilers
	// might produce invalid code (for example LCC, PellesC), it's
	// caused by the way stack is organized when encryption markers are used
	if (IsPELockPresent1() == 1)
	{
		DEMO_START

		// read registered user name (convert from ANSI user name stored in the key)
		//GetRegistrationName(name, _countof(name));

		// read registered user name (as raw, UNICODE bytes)
		GetRawRegistrationName(name, sizeof(name));

		_tprintf(_T("Program registered to %s"), name);

		DEMO_END
	}

	// check registered user name length (0 - key not present)
	if (_tcsclen(name) == 0)
	{
		_tprintf(_T("Evaluation version"));
	}

	_tprintf(_T("\n\nPress any key to exit . . ."));

	_getch();

	return 0;
}
