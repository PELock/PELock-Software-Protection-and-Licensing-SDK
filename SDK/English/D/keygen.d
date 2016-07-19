////////////////////////////////////////////////////////////////////////////////
//
// Keygen library header
//
// Version        : PELock v2.0
// Language       : D
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

module PELockKeygen;

pragma(lib, "keygen.lib");

import std.string;
import core.runtime;
import core.memory;
import core.sys.windows.windows;
import std.bitmanip;

const int PELOCK_MAX_USERNAME			= 8193;		// max size of registered user name stored in the keyfile
const int PELOCK_SAFE_KEY_SIZE			= 40*1024;	// safe buffer size for key data

// formaty wyjsciowe kluczy
const DWORD KEY_FORMAT_BIN			= 0;		// binary key (raw bytes)
const DWORD KEY_FORMAT_REG			= 1;		// Windows registry key dump (.reg)
const DWORD KEY_FORMAT_TXT			= 2;		// text key (in MIME Base64 format)

// kody bledow dla funkcji Keygen()
const DWORD KEYGEN_SUCCESS			= 0;		// key successfully generated
const DWORD KEYGEN_INVALID_PARAMS		= 1;		// invalid params
const DWORD KEYGEN_INVALID_PROJECT		= 2;		// invalid project file
const DWORD KEYGEN_OUT_MEMORY			= 3;		// out of memory
const DWORD KEYGEN_DATA_ERROR			= 4;		// error while generating key data

// kody bledow dla funkcji VerifyKey()
const DWORD KEYGEN_VERIFY_SUCCESS		= 0;		// key successfully verified
const DWORD KEYGEN_VERIFY_INVALID_PARAMS	= 1;		// invalid params
const DWORD KEYGEN_VERIFY_INVALID_PROJECT	= 2;		// invalid project file
const DWORD KEYGEN_VERIFY_OUT_MEMORY		= 3;		// out of memory
const DWORD KEYGEN_VERIFY_DATA_ERROR		= 4;		// error while verifying key data
const DWORD KEYGEN_VERIFY_FILE_ERROR		= 5;		// cannot open key file

//
// keygen params
//
struct KEYGEN_PARAMS {

	PBYTE lpOutputBuffer;				// output buffer pointer (it must be large engough)
	PDWORD lpdwOutputSize;				// pointer to the DWORD where key size will be stored

	DWORD dwOutputFormat;				// output key format (binary key, Windows registry key dump etc.)

	union
	{
		char *lpszProjectPath;			// project file path
		char *lpszProjectBuffer;		// project file text buffer
	};

	BOOL bProjectBuffer;				// is lpszProjectBuffer valid text buffer instead of file path

	BOOL bUpdateProject;				// add user to the project file
	PBOOL lpbProjectUpdated;			// pointer to the BOOL that will receive update status

	union
	{
		char *lpszUsername;			// user name pointer
		PVOID lpUsernameRawData;		// raw data pointer
	};

	union
	{
		DWORD dwUsernameLength;			// username length (max. 8192 chars)
		DWORD dwUsernameRawSize;		// raw data size (max. 8192 bytes)
	};

	BOOL bSetHardwareLock;				// use hardware id locking
	BOOL bSetHardwareEncryption;			// encrypt user name and custom key fields with hardware id
	char *lpszHardwareId;				// hardware id string

	BOOL bSetKeyIntegers;				// set key integers
	DWORD dwKeyIntegers[16];			// custom key values

	BOOL bSetKeyCreationDate;			// set key creation date
	SYSTEMTIME stKeyCreation;			// key creation date

	BOOL bSetKeyExpirationDate;			// set key expiration date
	SYSTEMTIME stKeyExpiration;			// key expiration date

	BOOL bSetFeatureBits;				// set feature bits

	union
	{
		DWORD dwFeatureBits;			// features bits as a DWORD

		struct					// feature bits as a BYTES
		{
			BYTE dwKeyData1;
			BYTE dwKeyData2;
			BYTE dwKeyData3;
			BYTE dwKeyData4;
		};

		mixin(bitfields!(			// feature bits
			bool, "bFeature1", 1,
			bool, "bFeature2", 1,
			bool, "bFeature3", 1,
			bool, "bFeature4", 1,
			bool, "bFeature5", 1,
			bool, "bFeature6", 1,
			bool, "bFeature7", 1,
			bool, "bFeature8", 1,
			bool, "bFeature9", 1,
			bool, "bFeature10", 1,
			bool, "bFeature11", 1,
			bool, "bFeature12", 1,
			bool, "bFeature13", 1,
			bool, "bFeature14", 1,
			bool, "bFeature15", 1,
			bool, "bFeature16", 1,
			bool, "bFeature17", 1,
			bool, "bFeature18", 1,
			bool, "bFeature19", 1,
			bool, "bFeature20", 1,
			bool, "bFeature21", 1,
			bool, "bFeature22", 1,
			bool, "bFeature23", 1,
			bool, "bFeature24", 1,
			bool, "bFeature25", 1,
			bool, "bFeature26", 1,
			bool, "bFeature27", 1,
			bool, "bFeature28", 1,
			bool, "bFeature29", 1,
			bool, "bFeature30", 1,
			bool, "bFeature31", 1,
			bool, "bFeature32", 1,
		));
	};


}
alias KEYGEN_PARAMS* PKEYGEN_PARAMS;


//
// verify key params
//
struct KEYGEN_VERIFY_PARAMS {

	union
	{
		char *lpszKeyPath;			// key file path (input)
		PBYTE lpKeyBuffer;			// key file buffer (input)
	};

	BOOL bKeyBuffer;				// is lpKeyBuffer valid memory buffer with key contents (input)
	DWORD dwKeyBufferSize;				// lpKeyBuffer memory size (input)

	union
	{
		char *lpszProjectPath;			// project file path (input)
		char *lpszProjectBuffer;		// project file text buffer (input)
	};

	BOOL bProjectBuffer;				// is lpszProjectBuffer valid text buffer instead of file path (input)

	DWORD dwOutputFormat;				// output format (binary file, registry dump etc.)

	union
	{
		char *lpszUsername;			// user name pointer
		PVOID lpUsernameRawData;		// raw data
	};

	union
	{
		DWORD dwUsernameLength;			// username length (max. 8192 chars)
		DWORD dwUsernameRawSize;		// raw data size (max. 8192 bytes)
	};

	BOOL bHardwareLock;				// is hardware id locking used
	BOOL bHardwareEncryption;			// is user name and custom key fields encrypted with a hardware id

	BOOL bKeyIntegers;				// are key integers set
	DWORD dwKeyIntegers[16];			// custom key values

	BOOL bKeyCreationDate;				// is key creation date set
	SYSTEMTIME stKeyCreation;			// key creation date

	BOOL bKeyExpirationDate;			// is key expiration date set
	SYSTEMTIME stKeyExpiration;			// key expiration date

	BOOL bFeatureBits;				// are feature bits set

	union
	{
		DWORD dwFeatureBits;			// features bits as a DWORD

		struct					// feature bits as a BYTES
		{
			BYTE dwKeyData1;
			BYTE dwKeyData2;
			BYTE dwKeyData3;
			BYTE dwKeyData4;
		};

		mixin(bitfields!(			// feature bits
			bool, "bFeature1", 1,
			bool, "bFeature2", 1,
			bool, "bFeature3", 1,
			bool, "bFeature4", 1,
			bool, "bFeature5", 1,
			bool, "bFeature6", 1,
			bool, "bFeature7", 1,
			bool, "bFeature8", 1,
			bool, "bFeature9", 1,
			bool, "bFeature10", 1,
			bool, "bFeature11", 1,
			bool, "bFeature12", 1,
			bool, "bFeature13", 1,
			bool, "bFeature14", 1,
			bool, "bFeature15", 1,
			bool, "bFeature16", 1,
			bool, "bFeature17", 1,
			bool, "bFeature18", 1,
			bool, "bFeature19", 1,
			bool, "bFeature20", 1,
			bool, "bFeature21", 1,
			bool, "bFeature22", 1,
			bool, "bFeature23", 1,
			bool, "bFeature24", 1,
			bool, "bFeature25", 1,
			bool, "bFeature26", 1,
			bool, "bFeature27", 1,
			bool, "bFeature28", 1,
			bool, "bFeature29", 1,
			bool, "bFeature30", 1,
			bool, "bFeature31", 1,
			bool, "bFeature32", 1,
		));
	};

	BYTE cKeyChecksum[32];				// key checksum (it can be used to put a key on the blacklist)

}
alias KEYGEN_VERIFY_PARAMS* PKEYGEN_VERIFY_PARAMS;

version (Windows)
{
	// Keygen() function prototype
	extern (Windows) alias DWORD function(PKEYGEN_PARAMS) PELOCK_KEYGEN;

	// VerifyKey() function prototype
	extern (Windows) alias DWORD function(PKEYGEN_VERIFY_PARAMS) PELOCK_VERIFY_KEY;

}

version (Windows):
extern (Windows):
nothrow:
export
{
	DWORD Keygen(PKEYGEN_PARAMS lpKeygenParams);
	DWORD VerifyKey(PKEYGEN_VERIFY_PARAMS lpKeygenVerifyParams);
}
