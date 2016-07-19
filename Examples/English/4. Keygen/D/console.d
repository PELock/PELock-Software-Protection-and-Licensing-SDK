////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use keygen library to generate license keys
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
import std.file: getcwd;
import std.path;
import std.conv;
import core.stdc.stdio;
import core.memory : GC;
import PELockKeygen;

// Keygen() function prototype
PELOCK_KEYGEN KeygenProc;

// VerifyKey() function prototype
PELOCK_VERIFY_KEY VerifyKeyProc;

string[] lpszKeyFormats = [ "KEY_FORMAT_BIN", "KEY_FORMAT_REG", "KEY_FORMAT_TXT" ];

///////////////////////////////////////////////////////////////////////////////
//
// print error message and wait for user input
//
///////////////////////////////////////////////////////////////////////////////

void print_error(const char[] lpszErrorMessage)
{
	if (lpszErrorMessage != null)
	{
		writef(lpszErrorMessage);
	}

	writef("\n\nPress any key to exit . . .");

	getchar();
}

///////////////////////////////////////////////////////////////////////////////
//
// entrypoint
//
///////////////////////////////////////////////////////////////////////////////

int main(string args[])
{
	HMODULE hKeygen = null;
	string szProjectPath;

	File hKey;
	BYTE[] lpKeyData;
	DWORD dwKeyDataSize = 0;

	KEYGEN_PARAMS kpKeygenParams;
	KEYGEN_VERIFY_PARAMS kvpKeygenVerifyParams;

	DWORD dwResult = 0;
	DWORD dwVerifyResult = 0;

	char[] szUsername = new char[PELOCK_MAX_USERNAME];

	///////////////////////////////////////////////////////////////////////////////
	//
	// load keygen library
	//
	///////////////////////////////////////////////////////////////////////////////

	hKeygen = LoadLibraryA("KEYGEN.dll");

	// check library handle
	if (hKeygen == null)
	{
		print_error("Cannot load library KEYGEN.dll!");
		return 1;
	}

	// get "Keygen" procedure address
	KeygenProc = cast(PELOCK_KEYGEN)GetProcAddress(hKeygen, "Keygen");

	if (KeygenProc == null)
	{
		print_error("Cannot find Keygen() procedure in KEYGEN.dll library!");
		return 1;
	}

	// get "VerifyKey" procedure address
	VerifyKeyProc = cast(PELOCK_VERIFY_KEY)GetProcAddress(hKeygen, "VerifyKey");

	if (VerifyKeyProc == null)
	{
		print_error("Cannot find VerifyKey() procedure in KEYGEN.dll library!");
		return 1;
	}

	///////////////////////////////////////////////////////////////////////////////
	//
	// build project path name
	//
	///////////////////////////////////////////////////////////////////////////////

	szProjectPath = buildPath(getcwd(), "test.plk");

	///////////////////////////////////////////////////////////////////////////////
	//
	// allocate memory for key data
	//
	///////////////////////////////////////////////////////////////////////////////

	lpKeyData = new BYTE[PELOCK_SAFE_KEY_SIZE];

	if (lpKeyData == null)
	{
		print_error("Nie mozna zaalokowac pamieci!");
		return 1;
	}

	///////////////////////////////////////////////////////////////////////////////
	//
	// fill PELOCK_KEYGEN_PARAMS structure
	//
	///////////////////////////////////////////////////////////////////////////////

	// output buffer pointer (it must be large engough)
	kpKeygenParams.lpOutputBuffer = lpKeyData.ptr;

	// pointer to the DWORD where key size will be stored
	kpKeygenParams.lpdwOutputSize = &dwKeyDataSize;

	// output key format
	// KEY_FORMAT_BIN - binary key
	// KEY_FORMAT_REG - Windows registry key dump
	// KEY_FORMAT_TXT - text key (in MIME Base64 format)
	kpKeygenParams.dwOutputFormat = KEY_FORMAT_REG;

	// project file path
	kpKeygenParams.lpszProjectPath = cast(char*)toStringz(szProjectPath);

	// are we using text buffer with project file contents (instead of project file)?
	kpKeygenParams.bProjectBuffer = FALSE;

	// add user to the project file
	kpKeygenParams.bUpdateProject = FALSE;

	// pointer to the BOOL that will receive update status
	kpKeygenParams.lpbProjectUpdated = null;

	// user name pointer
	kpKeygenParams.lpszUsername = "Laura Palmer".dup.ptr;

	// username length (max. 8192 chars)
	kpKeygenParams.dwUsernameLength = "Laura Palmer".length;

	// use hardware id locking
	kpKeygenParams.bSetHardwareLock = FALSE;

	// encrypt user name and custom key fields with hardware id
	kpKeygenParams.bSetHardwareEncryption = FALSE;

	// hardware id string
	kpKeygenParams.lpszHardwareId = null;

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
	// or:
	// dwResult = Keygen(&kpKeygenParams);

	switch (dwResult)
	{
	// key successfully generated
	case KEYGEN_SUCCESS:

		try
		{
			// save license key data to file
			switch (kpKeygenParams.dwOutputFormat)
			{
			default:
			case KEY_FORMAT_BIN: hKey = File("key.lic", "wb+"); break;
			case KEY_FORMAT_REG: hKey = File("key.reg", "wb+"); break;
			case KEY_FORMAT_TXT: hKey = File("key.txt", "wb+"); break;
			}

			// set buffer size
			lpKeyData.length = dwKeyDataSize;

			// write file
			hKey.rawWrite(lpKeyData);

			// close file handle
			hKey.close();

			writef("Key file successfully generated!");

			//
			// verify the key
			//
			writef("\nVerifying the key...\n");

			// project file path
			kvpKeygenVerifyParams.lpszProjectPath = cast(char*)toStringz(szProjectPath);

			// are we using text buffer with project file contents (instead of project file)?
			kvpKeygenVerifyParams.bProjectBuffer = FALSE;

			// memory buffer with the key contents
			kvpKeygenVerifyParams.lpKeyBuffer = lpKeyData.ptr;

			// are we providing memory buffer with the key contents or the key file path
			kvpKeygenVerifyParams.bKeyBuffer = TRUE;

			// key buffer size
			kvpKeygenVerifyParams.dwKeyBufferSize = dwKeyDataSize;

			// memory buffer that will receive the registered user name
			kvpKeygenVerifyParams.lpszUsername = szUsername.ptr;

			// verify the key
			dwVerifyResult = VerifyKeyProc(&kvpKeygenVerifyParams);
			// or:
			// dwVerifyResult = VerifyKey(&kvpKeygenVerifyParams);

			switch (dwVerifyResult)
			{
			// key successfully verified
			case KEYGEN_VERIFY_SUCCESS:

				szUsername.length = kvpKeygenVerifyParams.dwUsernameLength;

				writef("Key successfully verified, details:\n\n");

				writef("Username: %s (length %d)\n", szUsername, kvpKeygenVerifyParams.dwUsernameLength);
				writef("Feature bits: %08X\n", kvpKeygenVerifyParams.dwFeatureBits);
				writef("Detected key format: %s", lpszKeyFormats[kvpKeygenVerifyParams.dwOutputFormat]);

				break;

			// invalid params
			case KEYGEN_VERIFY_INVALID_PARAMS:

				writef("Invalid input params (check KEYGEN_VERIFY_PARAMS structure)!");
				break;

			// invalid project file
			case KEYGEN_VERIFY_INVALID_PROJECT:

				writef("Invalid project file, please check it, maybe it's missing some data!");
				break;

			// out of memory
			case KEYGEN_VERIFY_OUT_MEMORY:

				writef("Out of memory!");
				break;

			// error while verifying the key
			case KEYGEN_VERIFY_DATA_ERROR:

				writef("Error while verifying license key data, please contact with author!");
				break;

			// cannot open key file (if provided)
			case KEYGEN_VERIFY_FILE_ERROR:

				writef("Cannot open/read license key file!");
				break;

			// unknown errors
			default:

				writef("Unknown error, please contact with author!");
				break;
			}
		}
		catch(Exception e)
		{
			writef("Couldn't create key file!");
		}

		break;

	// invalid input params (or missing params)
	case KEYGEN_INVALID_PARAMS:

		writef("Invalid input params (check KEYGEN_PARAMS structure)!");
		break;

	// invalid project file
	case KEYGEN_INVALID_PROJECT:

		writef("Invalid project file, please check it, maybe it's missing some data!");
		break;

	// out of memory in Keygen() procedure
	case KEYGEN_OUT_MEMORY:

		writef("Out of memory!");
		break;

	// data generation error
	case KEYGEN_DATA_ERROR:

		writef("Error while generating license key data, please contact with author!");
		break;

	// unknown errors
	default:

		writef("Unknown error, please contact with author!");
		break;
	}

	print_error(null);

	return 0;
}
