////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use KEYGEN.dll to generate license keys
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
#include "keygen.h"

// procedures declaration
PELOCK_KEYGEN KeygenProc;

HINSTANCE hInst = NULL;
OPENFILENAME lpFn = { 0 };
HWND hDatePicker = NULL;
char szProjectPath[512] = { 0 };

////////////////////////////////////////////////////////////////////////////////
//
// load & initialize keygen library
//
////////////////////////////////////////////////////////////////////////////////

void InitializeKeygen(void)
{
	HMODULE hKeygen = NULL;

	// load keygen library
	hKeygen = LoadLibrary("KEYGEN.dll");

	if (hKeygen != NULL)
	{
		// get "Keygen" procedure address
		KeygenProc = (PELOCK_KEYGEN)GetProcAddress(hKeygen,"Keygen");
	}
	else
	{
		// display error uMsg
		MessageBox(NULL, "Cannot load library KEYGEN.dll!", "Error!", MB_ICONEXCLAMATION);

		// exit application
		ExitProcess(-1);
	}
}

////////////////////////////////////////////////////////////////////////////////
//
// generate license key
//
////////////////////////////////////////////////////////////////////////////////

void GenerateKey(HWND hMain)
{
	unsigned char szUserName[256] = { 0 }, szHardwareId[256] = { 0 }, szLicenseKey[256] = { 0 };
	unsigned int dwUserNameSize = 0, dwHardwareId = 0;

	PBYTE lpKeyData = NULL;
	DWORD dwKeyDataSize = 0;
	HANDLE hFile = NULL;
	DWORD dwWritten = 0;

	DWORD dwResult = 0;
	BOOL bTrans = FALSE;

	KEYGEN_PARAMS kpKeygenParams = { 0 };

	// read user name
	dwUserNameSize = GetDlgItemText(hMain, IDC_USER_NAME, szUserName, sizeof(szUserName));

	if (dwUserNameSize != 0)
	{
		// read addtional key data, hardware id
		dwHardwareId = GetDlgItemText(hMain, IDC_HARDWARE_ID, szHardwareId, 16+1);

		// allocate memory for key data
		lpKeyData = malloc(PELOCK_SAFE_KEY_SIZE);

		///////////////////////////////////////////////////////////////////////////////
		//
		// fill PELOCK_KEYGEN_PARAMS structure
		//
		///////////////////////////////////////////////////////////////////////////////

		// output buffer pointer (it must be large engough)
		kpKeygenParams.lpOutputBuffer = lpKeyData;

		// pointer to the DWORD where key size will be stored
		kpKeygenParams.lpdwOutputSize = &dwKeyDataSize;

		// output key format
		// KEY_FORMAT_BIN - binary key
		// KEY_FORMAT_REG - Windows registry key dump
		// KEY_FORMAT_TXT - text key (in MIME Base64 format)
		kpKeygenParams.dwOutputFormat = KEY_FORMAT_BIN;

		// project file path
		kpKeygenParams.lpszProjectPath = szProjectPath;

		// are we using text buffer with project file contents (instead of project file)?
		kpKeygenParams.bProjectBuffer = FALSE;

		// check update flag, when this option is selected, add user name to
		// the current project file userlist
		kpKeygenParams.bUpdateProject = (BOOL)IsDlgButtonChecked(hMain, IDB_UPDATE_PROJECT);

		// we don't care about update status
		kpKeygenParams.lpbProjectUpdated = NULL;

		// user name pointer
		kpKeygenParams.lpszUsername = szUserName;

		// username length (max. 8192 chars)
		kpKeygenParams.dwUsernameLength = dwUserNameSize;

		// use hardware id locking
		if (dwHardwareId != 0)
		{
			kpKeygenParams.bSetHardwareLock = TRUE;

			// hardware id string
			kpKeygenParams.lpszHardwareId = szHardwareId;
		}
		else
		{
			kpKeygenParams.bSetHardwareLock = FALSE;
			kpKeygenParams.lpszHardwareId = NULL;
		}

		// encrypt user name and custom key fields with hardware id
		kpKeygenParams.bSetHardwareEncryption = FALSE;

		// set key integers
		kpKeygenParams.bSetKeyIntegers = TRUE;

		// 16 custom key values
		kpKeygenParams.dwKeyIntegers[0] = 1;
		kpKeygenParams.dwKeyIntegers[1] = 2;
		kpKeygenParams.dwKeyIntegers[2] = 3;
		kpKeygenParams.dwKeyIntegers[3] = 4;
		kpKeygenParams.dwKeyIntegers[4] = 5;
		kpKeygenParams.dwKeyIntegers[5] = 6;
		kpKeygenParams.dwKeyIntegers[6] = 7;
		kpKeygenParams.dwKeyIntegers[7] = 8;
		kpKeygenParams.dwKeyIntegers[8] = 9;
		kpKeygenParams.dwKeyIntegers[9] = 10;
		kpKeygenParams.dwKeyIntegers[10] = 11;
		kpKeygenParams.dwKeyIntegers[11] = 12;
		kpKeygenParams.dwKeyIntegers[12] = 13;
		kpKeygenParams.dwKeyIntegers[13] = 14;
		kpKeygenParams.dwKeyIntegers[14] = 15;
		kpKeygenParams.dwKeyIntegers[15] = 16;

		// set key creation date
		kpKeygenParams.bSetKeyCreationDate = TRUE;

		// key creation date
		GetLocalTime(&kpKeygenParams.stKeyCreation);
		//kpKeygenParams.stKeyCreation.wDay = 01;
		//kpKeygenParams.stKeyCreation.wMonth = 01;
		//kpKeygenParams.stKeyCreation.wYear = 2012;

		// read key expiration date
		if (SendMessage(hDatePicker, DTM_GETSYSTEMTIME, 0, (LPARAM)&kpKeygenParams.stKeyExpiration) == GDT_VALID)
		{
			// set key expiration date
			kpKeygenParams.bSetKeyExpirationDate = TRUE;
		}
		else
		{
			kpKeygenParams.bSetKeyExpirationDate = FALSE;
		}

		// set feature bits
		kpKeygenParams.bSetFeatureBits = TRUE;

		// features bits as a DWORD
		kpKeygenParams.dwKeyData1 = (BYTE)GetDlgItemInt(hMain, IDC_ADDITIONAL_1, &bTrans, FALSE);
		kpKeygenParams.dwKeyData2 = (BYTE)GetDlgItemInt(hMain, IDC_ADDITIONAL_2, &bTrans, FALSE);
		kpKeygenParams.dwKeyData3 = (BYTE)GetDlgItemInt(hMain, IDC_ADDITIONAL_3, &bTrans, FALSE);
		kpKeygenParams.dwKeyData4 = (BYTE)GetDlgItemInt(hMain, IDC_ADDITIONAL_4, &bTrans, FALSE);

		///////////////////////////////////////////////////////////////////////////////
		//
		// generate key data
		//
		///////////////////////////////////////////////////////////////////////////////

		dwResult = KeygenProc(&kpKeygenParams);

		switch (dwResult)
		{
		// key successfully generated
		case KEYGEN_SUCCESS:

			// save key file
			memset(&lpFn, 0, sizeof(OPENFILENAME));

			// copy default license key name
			strcpy(szLicenseKey, "key.lic");

			lpFn.lStructSize = sizeof(OPENFILENAME);
			lpFn.nMaxFile = 256;
			lpFn.lpstrFile = szLicenseKey;
			lpFn.Flags = OFN_HIDEREADONLY;
			lpFn.lpstrFilter = "PELock License File (key.lic)\0key.lic\0";

			if (GetSaveFileName(&lpFn) != 0)
			{
				// create new file
				hFile = CreateFile(szLicenseKey, GENERIC_READ | GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);

				if (hFile != INVALID_HANDLE_VALUE)
				{
					// save license key data in key.lic file
					if (WriteFile(hFile, lpKeyData, dwKeyDataSize, &dwWritten, NULL) != 0)
					{
						MessageBox(hMain, "License file successfully generated!", "Info", MB_ICONINFORMATION);
					}
					else
					{
						MessageBox(hMain, "Error while saving license key data!", "Error!", MB_ICONEXCLAMATION);
					}

					// close file handle
					CloseHandle(hFile);
				}
				else
				{
					MessageBox(hMain, "Cannot create license key file!", "Error!", MB_ICONEXCLAMATION);
				}
			}

			break;

		// invalid input params (or missing params)
		case KEYGEN_INVALID_PARAMS:

			MessageBox(hMain, "Invalid input params (check PELOCK_KEY_PARAMS structure)!", "Error!", MB_ICONEXCLAMATION);
			break;

		// invalid project file
		case KEYGEN_INVALID_PROJECT:

			MessageBox(hMain, "Invalid project file, please check it, maybe it's missing some data!", "Error!", MB_ICONEXCLAMATION);
			break;

		// out of memory in Keygen() procedure
		case KEYGEN_OUT_MEMORY:

			MessageBox(hMain, "Out of memory!", "Error!", MB_ICONEXCLAMATION);
			break;

		// data generation error
		case KEYGEN_DATA_ERROR:

			MessageBox(hMain, "Error while generating license key data, please contact with author!", "Error!", MB_ICONEXCLAMATION);
			break;

		// unknown errors
		default:

			MessageBox(hMain, "Unknown error, please contact with author!", "Error!", MB_ICONEXCLAMATION);
			break;
		}

		// release allocated memory
		free(lpKeyData);
	}
	else
	{
		MessageBox(hMain, "Please enter valid user name and try again.", "Invalid user name!", MB_ICONEXCLAMATION);
	}
}

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// initialization of main window
		case WM_INITDIALOG:

			// set main window caption
			SetWindowText(hDlg, "PELock Keygen Test");

			// create time date picker control
			hDatePicker = CreateWindowEx(	0,
							DATETIMEPICK_CLASS,
							"DateTime",
							WS_BORDER | WS_CHILD | WS_VISIBLE | DTS_SHOWNONE,
							5, 150, 200, 25,
							hDlg,
							NULL,
							hInst,
							NULL);

			// disable time picker control
			SendMessage(hDatePicker, DTM_SETSYSTEMTIME, GDT_NONE, 0);

			return TRUE;

		case WM_COMMAND:

			switch (LOWORD (wParam))
			{
				case IDCANCEL:
					EndDialog(hDlg, 0);
					break;

				case IDB_GEN :
					GenerateKey(hDlg);
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

	hInst = hInstance;

	// load keygen library
	InitializeKeygen();

	lpFn.lStructSize = sizeof(OPENFILENAME);
	lpFn.nMaxFile = sizeof(szProjectPath);
	lpFn.lpstrFile = szProjectPath;
	lpFn.Flags = OFN_HIDEREADONLY;
	lpFn.lpstrFilter = "PELock Project Files (*.plk)\0*.plk\0";

	// select project file
	if (GetOpenFileName(&lpFn) != 0)
	{
		DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);
	}

	return 0;
}
