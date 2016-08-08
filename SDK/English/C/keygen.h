////////////////////////////////////////////////////////////////////////////////
//
// Keygen library header
//
// Version        : PELock v2.0
// Language       : C/C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#ifndef __PELOCK_KEYGEN__
#define __PELOCK_KEYGEN__

#define PELOCK_MAX_USERNAME		8193		// max size of registered user name stored in the keyfile, including terminating null at the end
#define PELOCK_MAX_HARDWARE_ID		17		// max. number of hardware id characters, including terminating null at the end
#define PELOCK_SAFE_KEY_SIZE		(40*1024)	// safe buffer size for key data

// output key formats
#define KEY_FORMAT_BIN			0		// binary key (raw bytes)
#define KEY_FORMAT_REG			1		// Windows registry key dump (.reg)
#define KEY_FORMAT_TXT			2		// text key (in MIME Base64 format)

// Keygen() return values
#define KEYGEN_SUCCESS			0		// key successfully generated
#define KEYGEN_INVALID_PARAMS		1		// invalid params
#define KEYGEN_INVALID_PROJECT		2		// invalid project file
#define KEYGEN_OUT_MEMORY		3		// out of memory
#define KEYGEN_DATA_ERROR		4		// error while generating key data

// VerifyKey() return values
#define KEYGEN_VERIFY_SUCCESS		0		// key successfully verified
#define KEYGEN_VERIFY_INVALID_PARAMS	1		// invalid params
#define KEYGEN_VERIFY_INVALID_PROJECT	2		// invalid project file
#define KEYGEN_VERIFY_OUT_MEMORY	3		// out of memory
#define KEYGEN_VERIFY_DATA_ERROR	4		// error while verifying key data
#define KEYGEN_VERIFY_FILE_ERROR	5		// cannot open key file

//
// keygen params
//
typedef struct _KEYGEN_PARAMS {

	PBYTE lpOutputBuffer;				// output buffer pointer (it must be large engough)
	PDWORD lpdwOutputSize;				// pointer to the DWORD where key size will be stored

	DWORD dwOutputFormat;				// output key format (binary key, Windows registry key dump etc.)

	union
	{
		const char *lpszProjectPath;		// project file path
		const char *lpszProjectBuffer;		// project file text buffer
	};

	BOOL bProjectBuffer;				// is lpszProjectBuffer valid text buffer instead of file path

	BOOL bUpdateProject;				// add user to the project file
	PBOOL lpbProjectUpdated;			// pointer to the BOOL that will receive update status

	union
	{
		const char *lpszUsername;		// user name pointer
		PVOID lpUsernameRawData;		// raw data pointer
	};

	union
	{
		DWORD dwUsernameLength;			// username length (max. 8192 chars)
		DWORD dwUsernameRawSize;		// raw data size (max. 8192 bytes)
	};

	BOOL bSetHardwareLock;				// use hardware id locking
	BOOL bSetHardwareEncryption;			// encrypt user name and custom key fields with hardware id
	const char *lpszHardwareId;			// hardware id string

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

		struct					// feature bits
		{
			unsigned bFeature1 : 1;
			unsigned bFeature2 : 1;
			unsigned bFeature3 : 1;
			unsigned bFeature4 : 1;
			unsigned bFeature5 : 1;
			unsigned bFeature6 : 1;
			unsigned bFeature7 : 1;
			unsigned bFeature8 : 1;
			unsigned bFeature9 : 1;
			unsigned bFeature10: 1;
			unsigned bFeature11: 1;
			unsigned bFeature12: 1;
			unsigned bFeature13: 1;
			unsigned bFeature14: 1;
			unsigned bFeature15: 1;
			unsigned bFeature16: 1;
			unsigned bFeature17: 1;
			unsigned bFeature18: 1;
			unsigned bFeature19: 1;
			unsigned bFeature20: 1;
			unsigned bFeature21: 1;
			unsigned bFeature22: 1;
			unsigned bFeature23: 1;
			unsigned bFeature24: 1;
			unsigned bFeature25: 1;
			unsigned bFeature26: 1;
			unsigned bFeature27: 1;
			unsigned bFeature28: 1;
			unsigned bFeature29: 1;
			unsigned bFeature30: 1;
			unsigned bFeature31: 1;
			unsigned bFeature32: 1;
		};
	};


} KEYGEN_PARAMS, *PKEYGEN_PARAMS;

//
// verify key params
//
typedef struct _KEYGEN_VERIFY_PARAMS {

	union
	{
		const char *lpszKeyPath;		// key file path (input)
		PBYTE lpKeyBuffer;			// key file buffer (input)
	};

	BOOL bKeyBuffer;				// is lpKeyBuffer valid memory buffer with key contents (input)
	DWORD dwKeyBufferSize;				// lpKeyBuffer memory size (input)

	union
	{
		const char *lpszProjectPath;		// project file path (input)
		const char *lpszProjectBuffer;		// project file text buffer (input)
	};

	BOOL bProjectBuffer;				// is lpszProjectBuffer valid text buffer instead of file path (input)

	DWORD dwOutputFormat;				// output format (binary file, registry dump etc.)

	union
	{
		const char *lpszUsername;		// user name pointer
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

		struct					// feature bits
		{
			unsigned bFeature1 : 1;
			unsigned bFeature2 : 1;
			unsigned bFeature3 : 1;
			unsigned bFeature4 : 1;
			unsigned bFeature5 : 1;
			unsigned bFeature6 : 1;
			unsigned bFeature7 : 1;
			unsigned bFeature8 : 1;
			unsigned bFeature9 : 1;
			unsigned bFeature10: 1;
			unsigned bFeature11: 1;
			unsigned bFeature12: 1;
			unsigned bFeature13: 1;
			unsigned bFeature14: 1;
			unsigned bFeature15: 1;
			unsigned bFeature16: 1;
			unsigned bFeature17: 1;
			unsigned bFeature18: 1;
			unsigned bFeature19: 1;
			unsigned bFeature20: 1;
			unsigned bFeature21: 1;
			unsigned bFeature22: 1;
			unsigned bFeature23: 1;
			unsigned bFeature24: 1;
			unsigned bFeature25: 1;
			unsigned bFeature26: 1;
			unsigned bFeature27: 1;
			unsigned bFeature28: 1;
			unsigned bFeature29: 1;
			unsigned bFeature30: 1;
			unsigned bFeature31: 1;
			unsigned bFeature32: 1;
		};
	};

	BYTE cKeyChecksum[32];				// key checksum (it can be used to put a key on the blacklist)

} KEYGEN_VERIFY_PARAMS, *PKEYGEN_VERIFY_PARAMS;


// Keygen() function prototype
typedef DWORD (__stdcall * PELOCK_KEYGEN)(PKEYGEN_PARAMS lpKeygenParams);

// VerifyKey() function prototype
typedef DWORD (__stdcall * PELOCK_VERIFY_KEY)(PKEYGEN_VERIFY_PARAMS lpKeygenVerifyParams);

#ifdef __cplusplus
extern "C" {
#endif

DWORD __stdcall Keygen(PKEYGEN_PARAMS lpKeygenParams);
DWORD __stdcall VerifyKey(PKEYGEN_VERIFY_PARAMS lpKeygenVerifyParams);

#ifdef __cplusplus
} // extern "C"
#endif

#endif // __PELOCK_KEYGEN__
