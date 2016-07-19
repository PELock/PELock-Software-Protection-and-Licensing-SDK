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
		KeygenProc = (PELOCK_KEYGEN)GetProcAddress(hKeygen, "Keygen");
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
	unsigned char szUserName[256] = { 0 }, szLicensePath[512] = { 0 };
	unsigned int dwUserNameSize = 0;
	
	DWORD dwResult = 0, dwKeyDataSize = 0;
	PBYTE lpKeyData = NULL;
	HANDLE hFile = 0;
	DWORD dwWritten = 0;

	KEYGEN_PARAMS kpKeygenParams = { 0 };

	// read user name
	dwUserNameSize = GetDlgItemText(hMain, IDC_USER_NAME, szUserName, sizeof(szUserName));

	if (dwUserNameSize != 0)
	{
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
		kpKeygenParams.dwOutputFormat = KEY_FORMAT_REG;

		// project file path
		kpKeygenParams.lpszProjectPath = szProjectPath;

		// are we using text buffer with project file contents (instead of project file)?
		kpKeygenParams.bProjectBuffer = FALSE;

		// add user to the project file
		kpKeygenParams.bUpdateProject = FALSE;

		// pointer to the BOOL that will receive update status
		kpKeygenParams.lpbProjectUpdated = NULL;

		// user name pointer
		kpKeygenParams.lpszUsername = szUserName;

		// username length (max. 8192 chars)
		kpKeygenParams.dwUsernameLength = dwUserNameSize;

		// use hardware id locking
		kpKeygenParams.bSetHardwareLock = FALSE;

		// encrypt user name and custom key fields with hardware id
		kpKeygenParams.bSetHardwareEncryption = FALSE;

		// hardware id string
		kpKeygenParams.lpszHardwareId = NULL;

		// set key integers
		kpKeygenParams.bSetKeyIntegers = FALSE;

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

		// set key expiration date
		kpKeygenParams.bSetKeyExpirationDate = FALSE;

		// key expiration date
		//kpKeygenParams.stKeyExpiration.wDay = 01;
		//kpKeygenParams.stKeyExpiration.wMonth = 01;
		//kpKeygenParams.stKeyExpiration.wYear = 2012;

		// set feature bits
		kpKeygenParams.bSetFeatureBits = FALSE;

		// features bits as a DWORD
		kpKeygenParams.dwFeatureBits = 0xFFFFFFFF;

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

			// build license key path
			GetModuleFileName(NULL, szLicensePath, sizeof(szLicensePath));
			*(strrchr(szLicensePath, '\\') + 1) = '\0';

			// append new directory name
			strcat(szLicensePath, szUserName);

			// create new directory for key file
			CreateDirectory(szLicensePath, NULL);

			// set current directory path
			SetCurrentDirectory(szLicensePath);

			// copy default license key name
			switch (kpKeygenParams.dwOutputFormat)
			{
			case KEY_FORMAT_BIN: strcpy(szLicensePath, "key.lic"); break;
			case KEY_FORMAT_REG: strcpy(szLicensePath, "key.reg"); break;
			case KEY_FORMAT_TXT: strcpy(szLicensePath, "key.txt"); break;
			}

			// create license key file (overwrite existing file)
			hFile = CreateFile(szLicensePath, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_ARCHIVE, NULL);

			if (hFile != INVALID_HANDLE_VALUE)
			{
				// write license key data to the file
				WriteFile(hFile, lpKeyData, dwKeyDataSize, &dwWritten, NULL);

				// close file handle
				CloseHandle(hFile);

				MessageBox(hMain, "License file successfully generated!", "Info", MB_ICONINFORMATION);
			}
			else
			{
				MessageBox(hMain, "Cannot create license key file!", "Error!", MB_ICONEXCLAMATION);
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

		// release memory
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

	memset(&lpFn, 0, sizeof(OPENFILENAME));

	lpFn.lStructSize = sizeof(OPENFILENAME);

	lpFn.nMaxFile = sizeof(szProjectPath);

	lpFn.lpstrFile = szProjectPath;

	lpFn.Flags = OFN_HIDEREADONLY;

	lpFn.lpstrFilter = "PELock Project Files (*.plk)\0*.plk\0";

	// select project file
	if (GetOpenFileName(&lpFn) != 0)
	{
		// display dialog box
		DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);
	}

	return 0;
}
