////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use CPELock class with CString types
//
// Version        : PELock v2.0
// Language       : C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "main.h"

CWinApp theApp;

// registration name
CString szRegisteredUsername;

// hardware id
CString szHardwareId;

// CPELock class declaration
CPELock myPELock;

using namespace std;

int _tmain(int argc, TCHAR* argv[], TCHAR* envp[])
{
	//
	// initialize MFC and print and error on failure
	//
	if (!AfxWinInit(::GetModuleHandle(NULL), NULL, ::GetCommandLine(), 0))
	{
		_tprintf(_T("Fatal Error: MFC initialization failed\n"));

		return 1;
	}

	//
	// read registered user name
	//
	DEMO_START

	szRegisteredUsername = myPELock.GetRegistrationName();

	_tprintf(_T("Application registered for %s\n"), szRegisteredUsername);

	DEMO_END

	//
	// for an unregistered application, display hardware id
	//
	if (szRegisteredUsername == "")
	{
		szHardwareId = myPELock.GetHardwareId();

		_tprintf(_T("Unregistered application, your hardware is is %s\n"), szHardwareId);

	}

	_tprintf(_T("\nPress any key to exit . . .\n"));

	_getch();

	return 0;
}
