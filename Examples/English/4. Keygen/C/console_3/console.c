////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use keygen library to generate license keys
//
// Version        : PELock v2.0
// Language       : C/C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include "keygen.h"

// Keygen() function prototype
PELOCK_KEYGEN KeygenProc;

///////////////////////////////////////////////////////////////////////////////
//
// print error message and wait for user input
//
///////////////////////////////////////////////////////////////////////////////

void print_error(const char *lpszErrorMessage)
{
	if (lpszErrorMessage)
	{
		printf(lpszErrorMessage);
	}

	printf("\n\nPress any key to exit . . .");

	getch();
}

///////////////////////////////////////////////////////////////////////////////
//
// read text file contents
//
///////////////////////////////////////////////////////////////////////////////

char *read_text_file(const char *lpszFilePath)
{
	FILE *hFile = NULL;
	char *lpszMemoryBuffer = NULL;
	DWORD dwFileSize = 0;

	hFile = fopen(lpszFilePath, "rb");

	if (hFile != NULL)
	{
		fseek(hFile, 0, SEEK_END);

		dwFileSize = ftell(hFile);

		if (dwFileSize != 0)
		{
			lpszMemoryBuffer = calloc(dwFileSize + 1, 1);

			if (lpszMemoryBuffer != NULL)
			{
				fseek(hFile, 0, SEEK_SET);

				if (fread(lpszMemoryBuffer, 1, dwFileSize, hFile) != dwFileSize)
				{
					free(lpszMemoryBuffer);
					lpszMemoryBuffer = NULL;
				}
			}
		}

		fclose(hFile);
	}

	return lpszMemoryBuffer;
}

///////////////////////////////////////////////////////////////////////////////
//
// entrypoint
//
///////////////////////////////////////////////////////////////////////////////

int main(int argc, char *argv[])
{
	HMODULE hKeygen = NULL;
	char szProjectPath[512] = { 0 };
	char *lpszProjectBuffer = NULL;

	FILE *hKey = NULL;
	char *lpKeyData = NULL;
	DWORD dwKeyDataSize = 0;

	KEYGEN_PARAMS kpKeygenParams = { 0 };

	DWORD dwResult = 0;

	///////////////////////////////////////////////////////////////////////////////
	//
	// load keygen library
	//
	///////////////////////////////////////////////////////////////////////////////

	hKeygen = LoadLibrary("KEYGEN.dll");

	// check library handle
	if (hKeygen == NULL)
	{
		print_error("Cannot load library KEYGEN.dll!");
		return 1;
	}

	// get "Keygen" procedure address
	KeygenProc = (PELOCK_KEYGEN)GetProcAddress(hKeygen, "Keygen");

	if (KeygenProc == NULL)
	{
		print_error("Cannot find Keygen() procedure in KEYGEN.dll library!");
		return 1;
	}

	///////////////////////////////////////////////////////////////////////////////
	//
	// build project path name
	//
	///////////////////////////////////////////////////////////////////////////////

	GetModuleFileName(NULL, szProjectPath, sizeof(szProjectPath));

	*(strrchr(szProjectPath, '\\') + 1) = '\0';

	strcat(szProjectPath, "test.plk");

	///////////////////////////////////////////////////////////////////////////////
	//
	// load project file to the memory buffer
	//
	///////////////////////////////////////////////////////////////////////////////

	lpszProjectBuffer = read_text_file(szProjectPath);

	if (lpszProjectBuffer == NULL)
	{
		print_error("Cannot read project file!");
		return 1;
	}

	///////////////////////////////////////////////////////////////////////////////
	//
	// allocate memory for key data
	//
	///////////////////////////////////////////////////////////////////////////////

	lpKeyData = malloc(PELOCK_SAFE_KEY_SIZE);

	if (lpKeyData == NULL)
	{
		free(lpszProjectBuffer);

		print_error("Cannot allocate memory!");
		return 1;
	}

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
	//kpKeygenParams.lpszProjectPath = szProjectPath;

	// project file text buffer
	kpKeygenParams.lpszProjectBuffer = lpszProjectBuffer;

	// are we using text buffer with project file contents (instead of project file)?
	kpKeygenParams.bProjectBuffer = TRUE;

	// add user to the project file
	kpKeygenParams.bUpdateProject = FALSE;

	// pointer to the BOOL that will receive update status
	kpKeygenParams.lpbProjectUpdated = NULL;

	// user name pointer
	kpKeygenParams.lpszUsername = "Laura Palmer";

	// username length (max. 8192 chars)
	kpKeygenParams.dwUsernameLength = strlen("Laura Palmer");

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
	kpKeygenParams.bSetFeatureBits = TRUE;

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

		// save license key data to file
		switch (kpKeygenParams.dwOutputFormat)
		{
		case KEY_FORMAT_BIN: hKey = fopen("key.lic", "wb+"); break;
		case KEY_FORMAT_REG: hKey = fopen("key.reg", "wb+"); break;
		case KEY_FORMAT_TXT: hKey = fopen("key.txt", "wb+"); break;
		}

		if (hKey != NULL)
		{
			// write file
			fwrite(lpKeyData, dwKeyDataSize, 1, hKey);

			// close file handle
			fclose(hKey);

			printf("Key file successfully generated!");
		}
		else
		{
			printf("Couldn't create key file!");
		}

		break;

	// invalid input params (or missing params)
	case KEYGEN_INVALID_PARAMS:

		printf("Invalid input params (check PELOCK_KEY_PARAMS structure)!");
		break;

	// invalid project file
	case KEYGEN_INVALID_PROJECT:

		printf("Invalid project file, please check it, maybe it's missing some data!");
		break;

	// out of memory in Keygen() procedure
	case KEYGEN_OUT_MEMORY:

		printf("Out of memory!");
		break;

	// data generation error
	case KEYGEN_DATA_ERROR:

		printf("Error while generating license key data, please contact with author!");
		break;

	// unknown errors
	default:

		printf("Unknown error, please contact with author!");
		break;
	}

	// release memory
	free(lpszProjectBuffer);
	free(lpKeyData);

	print_error(NULL);

	return 0;
}
