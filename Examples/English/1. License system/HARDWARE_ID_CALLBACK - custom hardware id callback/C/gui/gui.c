////////////////////////////////////////////////////////////////////////////////
//
// Example of how to set custom hardware id callback routine
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

// registered user
unsigned char szUser[256] = { 0 };

//
// custom hardware id callback
//
// return values:
//
// 1 - hardware identifier successfully generated
// 0 - an error occured, for example when dongle key was
//     not present), please note that any further calls to
//     GetHardwareId() or functions to set/reload
//     registration key locked to hardware id will fail
//     in this case (error codes will be returned)
//
int CustomHardwareId(unsigned char cOutput[8])
{
	int i = 0;

	//
	// copy custom hardware identifier to output buffer (8 bajtow)
	//
	// you can create custome hardware identifier from:
	//
	// - dongle (hardware key) hardware identifier
	// - operating system information
	// - etc.
	//
	for (i = 0; i < 8 ; i++)
	{
		cOutput[i] = i + 1;
	}

	// return 1 to indicate success
	return 1;
}

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// initialization of main window
		case WM_INITDIALOG:

			// set our own hardware id callback routine (you need to enable
			// proper option in SDK tab)
			SetHardwareIdCallback(&CustomHardwareId);

			// reload registration key (from default locations)
			ReloadRegistrationKey();

			// start marker, code between DEMO_START and DEMO_END
			// will be encrypted in protected file and unavailable
			// without valid license key

			// you *need* at least one DEMO_START/DEMO_END or/and
			// FEATURE_x_START/FEATURE_x_END marker in the code
			// to be able to read hardware id
			DEMO_START

			// get registered user name
			GetRegistrationName(szUser, sizeof(szUser));

			// display registered user name
			SetDlgItemText(hDlg, IDC_REG, szUser);

			// end marker
			DEMO_END

			// check if anything was copied to the buffer
			// if not set to default
			if (strlen(szUser) == 0)
			{
				SetDlgItemText(hDlg, IDC_REG, "Unregistered version!.\nPlease provide this id to receive full version:");

				// read hardware id
				GetHardwareId(szUser, sizeof(szUser));

				// display hardware ID in edit window
				SetDlgItemText(hDlg, IDC_HARDWARE_ID, szUser);
			}

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

	return 0;
}
