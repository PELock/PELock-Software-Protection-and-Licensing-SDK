////////////////////////////////////////////////////////////////////////////////
//
// Plugin example
//
// Version        : PELock v2.0
// Language       : C/C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include <windows.h>
#include "pelock_plugin.h"

// helper macro to define exported functions
#define EXPORT __declspec(dllexport) __stdcall

// global pointer to the PLUGIN_INTERFACE structure
PLUGIN_INTERFACE *g_lpPluginInterface = NULL;

// beeping thread handle
HANDLE g_hBeepThread = NULL;

////////////////////////////////////////////////////////////////////////////////
//
// beep procedure
//
////////////////////////////////////////////////////////////////////////////////

DWORD WINAPI BeepProc(LPVOID lpParameter)
{
	while(1)
	{
		MessageBeep(-1);
		Sleep(1000);
	}

	return 0;
}

////////////////////////////////////////////////////////////////////////////////
//
// plugin procedure
//
// quick tip!
//
// you can use either original WinApi/RTL functions in your plugin eg.
//
// ExitProcess(0);
// strlen(lpszString);
//
// or you can use procedures available via PLUGIN_INTERFACE structure
//
// lpPluginInterface->pe_ExitProcess(0);
// lpPluginInterface->pe_strlen(lpszString);
//
// warning!
//
// all procedures inside PLUGIN_INTERFACE are ANSI (compatible with all
// Windows versions), so you CAN'T use UNICODE with it (wchar types etc.)!
// If you want to use unicode functions, use original WinApi/RTL functions,
// and not those available via PLUGIN_INTERFACE.
//
////////////////////////////////////////////////////////////////////////////////

EXPORT void Plugin(PLUGIN_INTERFACE * lpPluginInterface)
{
	DWORD dwThreadId = 0;

	// verify input parameter
	if (lpPluginInterface == NULL)
	{
		return;
	}

	// store interface pointer in global variable
	g_lpPluginInterface = lpPluginInterface;

	// let the beeping begins :)
	g_hBeepThread = lpPluginInterface->pe_CreateThread(NULL, 0, &BeepProc, NULL, 0, &dwThreadId);

	// display message box
	MessageBox(NULL, "Hello World! Can you hear the beeping? :)", "PELock Plugin", MB_ICONINFORMATION);

	//DebugBreak();
}

////////////////////////////////////////////////////////////////////////////////
//
// entrypoint (LibMain for LCC, DllMain for the others)
//
////////////////////////////////////////////////////////////////////////////////

BOOL WINAPI LibMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
	switch (fdwReason)
	{
	case DLL_PROCESS_ATTACH:

		break;

	case DLL_THREAD_ATTACH:

		break;

	case DLL_THREAD_DETACH:

		break;

	case DLL_PROCESS_DETACH:

		// display message at the exit, DLL plugins are detached at
		// the end of application
		MessageBox(NULL, "Terminating plugin.", "PELock Plugin", MB_ICONINFORMATION);

		// terminate beeping thread
		if (g_hBeepThread != NULL)
		{
			TerminateThread(g_hBeepThread, 1);
		}

		break;
	}

	return TRUE;
}
