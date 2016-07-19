////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use PELOCK_INIT_CALLBACK macros
//
// Version        : PELock v2.0
// Language       : C/C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include <windows.h>
#include <commctrl.h>
#include <stdio.h>
#include <math.h>
#include "gui.h"
#include "pelock.h"

static int dwSecretValue1 = 0;
static int dwSecretValue2 = 0;
static char cTemp[128] = { 0 };

//
// initialization callbacks are called only once before application
// start, it can be used to initialize sensitive variables, it is
// called only for the protected applications, so if the protection
// gets removed those functions won't be called (extra protection
// against code unpacking)
//
// those function has to be used somewhere in the code, so it won't
// be removed by the compiler optimizations (which in most cases
// removes unused and unreferenced functions), you can use a simple
// trick to protect against it, check the function pointer anywhere
// in the code eg.:
//
// if ((&pelock_initalization_callback_1 == NULL) return 0;
//
// also keep in mind that those functions are called before
// application initialization code, so if your application
// depends on some libraries (either static or dynamic), make
// sure to keep this code simple without any references to those
// libraries and their functions
//
void pelock_initalization_callback_1(HINSTANCE hInstance, DWORD dwReserved)
{
	// initialization callback marker
	PELOCK_INIT_CALLBACK

	// initialization callbacks are called only once, so
	// it's safe to erase its code after execution
	CLEAR_START

	dwSecretValue1 = 2;

	CLEAR_END
}

//
// second callback, you can place as many callbacks as you want
//
void pelock_initalization_callback_2(HINSTANCE hInstance, DWORD dwReserved)
{
	// initialization callback marker
	PELOCK_INIT_CALLBACK

	// initialization callbacks are called only once, so
	// it's safe to erase its code after execution
	CLEAR_START

	dwSecretValue2 = 2;

	CLEAR_END
}

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// initialization of main window
		case WM_INITDIALOG:

			wsprintf(cTemp, "Calculation result 2 + 2 = %lu\n", dwSecretValue1 + dwSecretValue2);

			SetDlgItemText(hDlg, IDC_INFO, cTemp);

			SetWindowText(hDlg, "PELock Test");

			return TRUE;

		case WM_COMMAND:

			switch (LOWORD (wParam))
			{
				case IDCANCEL:

					EndDialog(hDlg, 0);
					break;
			}

			break;
	}

	return FALSE;
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	INITCOMMONCONTROLSEX iccControls = { sizeof(INITCOMMONCONTROLSEX), ICC_WIN95_CLASSES | ICC_DATE_CLASSES };

	// initialize common controls
	InitCommonControlsEx(&iccControls);

	DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);

	// protection against compiler optimizations
	if ( (&pelock_initalization_callback_1 == NULL) || (&pelock_initalization_callback_2 == NULL) )
	{
		return 0;
	}

	return 0;
}
