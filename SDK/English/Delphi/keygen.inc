////////////////////////////////////////////////////////////////////////////////
//
// Keygen library header
//
// Version        : PELock v2.0
// Language       : Delphi
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

const

{$EXTERNALSYM PELOCK_MAX_USERNAME}
PELOCK_MAX_USERNAME             = 8193;                 // max size of registered user name stored in the keyfile

{$EXTERNALSYM PELOCK_SAFE_KEY_SIZE}
PELOCK_SAFE_KEY_SIZE            = (40*1024);            // safe buffer size for key data

// output key formats
{$EXTERNALSYM KEY_FORMAT_BIN}
KEY_FORMAT_BIN                  = 0;                    // binary key (raw bytes)

{$EXTERNALSYM KEY_FORMAT_REG}
KEY_FORMAT_REG                  = 1;                    // Windows registry key dump (.reg)

{$EXTERNALSYM KEY_FORMAT_TXT}
KEY_FORMAT_TXT                  = 2;                    // text key (in MIME Base64 format)

//
// Keygen() return values
//
{$EXTERNALSYM KEYGEN_SUCCESS}
KEYGEN_SUCCESS                  = 0;                    // key successfully generated

{$EXTERNALSYM KEYGEN_INVALID_PARAMS}
KEYGEN_INVALID_PARAMS           = 1;                    // invalid params

{$EXTERNALSYM KEYGEN_INVALID_PROJECT}
KEYGEN_INVALID_PROJECT          = 2;                    // invalid project file

{$EXTERNALSYM KEYGEN_OUT_MEMORY}
KEYGEN_OUT_MEMORY               = 3;                    // out of memory

{$EXTERNALSYM KEYGEN_DATA_ERROR}
KEYGEN_DATA_ERROR               = 4;                    // error while generating key data

//
// VerifyKey() return values
//
{$EXTERNALSYM KEYGEN_VERIFY_SUCCESS}
KEYGEN_VERIFY_SUCCESS           = 0;                    // key successfully verified

{$EXTERNALSYM KEYGEN_VERIFY_INVALID_PARAMS}
KEYGEN_VERIFY_INVALID_PARAMS    = 1;                    // invalid params

{$EXTERNALSYM KEYGEN_VERIFY_INVALID_PROJECT}
KEYGEN_VERIFY_INVALID_PROJECT   = 2;                    // invalid project file

{$EXTERNALSYM KEYGEN_VERIFY_OUT_MEMORY}
KEYGEN_VERIFY_OUT_MEMORY        = 3;                    // out of memory

{$EXTERNALSYM KEYGEN_VERIFY_DATA_ERROR}
KEYGEN_VERIFY_DATA_ERROR        = 4;                    // error while verifying key data

{$EXTERNALSYM KEYGEN_VERIFY_FILE_ERROR}
KEYGEN_VERIFY_FILE_ERROR        = 5;                    // cannot open key file


type

//
// project file path or project file contents as a text buffer
//
TKeygenProjectPtr = packed record

        case Integer of
        0: (lpszProjectPath: PChar);                    // project file path
        1: (lpszProjectBuffer : PChar);                 // project file text buffer
end;

//
// you can store either username in the key or a raw
// data bytes
//
TKeygenUsernamePtr = packed record

        case Integer of
        0: (lpszUsername: PChar);                       // user name pointer
        1: (lpUsernameRawData : PByteArray);            // raw data pointer
end;

//
// size of username string or size of raw data bytes
//
TKeygenUsernameSize = packed record

        case Integer of
        0: (dwUsernameLength : DWORD);                  // username length (max. 8192 chars)
        1: (dwUsernameRawSize : DWORD);                 // raw data size (max. 8192 bytes)
end;

//
// feature bits as a DWORD and as a 4 bytes
//
TKeygenFeatures = packed record

        case Integer of
        0: (dwFeatureBits : DWORD);                     // features bits as a DWORD
        1: (dwKeyData1, dwKeyData2, dwKeyData3, dwKeyData4 : Byte);
end;

//
// key file or memory buffer with key file contents
//
TKeygenKeyPtr = packed record

        case Integer of
        0: (lpszKeyPath: PChar);                        // key file path (input)
        1: (lpKeyBuffer : PByteArray);                  // key file buffer (input)
end;

//
// keygen params
//
TKeygenParams = packed record

        lpOutputBuffer        : PByteArray;             // output buffer pointer (it must be large engough)
        lpdwOutputSize        : ^DWORD;                 // pointer to the DWORD where key size will be stored

        dwOutputFormat        : DWORD;                  // output key format (binary key, Windows registry key dump etc.)

        lpProjectPtr          : TKeygenProjectPtr;      // project file path or text buffer with project file contents
        bProjectBuffer        : LongBool;               // is lpszProjectBuffer valid text buffer instead of file path

        bUpdateProject        : LongBool;               // add user to the project file
        lpbProjectUpdated     : ^LongBool;              // pointer to the BOOL that will receive update status

        lpUsernamePtr         : TKeygenUsernamePtr;     // username or raw data pointer
        dwUsernameSize        : TKeygenUsernameSize;    // username of raw data size

        bSetHardwareLock      : LongBool;               // use hardware id locking
        bSetHardwareEncryption: LongBool;               // encrypt user name and custom key fields with hardware id
        lpszHardwareId        : PChar;                  // hardware id string

        bSetKeyIntegers       : LongBool;               // set key integers
        dwKeyIntegers         : array[0..15] of DWORD;  // custom key values

        bSetKeyCreationDate   : LongBool;               // set key creation date
        stKeyCreation         : TSystemTime;            // key creation date

        bSetKeyExpirationDate : LongBool;               // set key expiration date
        stKeyExpiration       : TSystemTime;            // key expiration date

        bSetFeatureBits       : LongBool;               // set feature bits
        dwFeatures            : TKeygenFeatures;        // features (additional key data)
end;

//
// verify key params
//
TKeygenVerifyParams = packed record

        lpKeyPtr              : TKeygenKeyPtr;          // file file path/memory buffer (input)
        bKeyBuffer            : LongBool;               // is lpKeyBuffer valid memory buffer with key contents (input)
        dwKeyBufferSize       : DWORD;                  // lpKeyBuffer memory size (input)

        lpProjectPtr          : TKeygenProjectPtr;      // project file path or text buffer with project file contents (input)
        bProjectBuffer        : LongBool;               // is lpszProjectBuffer valid text buffer instead of file path (input)

        dwOutputFormat        : DWORD;                  // output format (binary file, registry dump etc.)

        lpUsernamePtr         : TKeygenUsernamePtr;     // username or raw data pointer
        dwUsernameSize        : TKeygenUsernameSize;    // username length or raw data size

        bHardwareLock         : LongBool;               // is hardware id locking used
        bHardwareEncryption   : LongBool;               // is user name and custom key fields encrypted with a hardware id

        bKeyIntegers          : LongBool;               // are key integers set
        dwKeyIntegers         : array[0..15] of DWORD;  // custom key values

        bKeyCreationDate      : LongBool;               // is key creation date set
        stKeyCreation         : TSystemTime;            // key creation date

        bKeyExpirationDate    : LongBool;               // is key expiration date set
        stKeyExpiration       : TSystemTime;            // key expiration date

        bFeatureBits          : LongBool;               // are feature bits set
        dwFeatures            : TKeygenFeatures;        // features (additional key data)

        cKeyChecksum          : array[0..31] of Byte;   // key checksum (it can be used to put a key on the blacklist)
end;


// Keygen() function prototype
function Keygen(var lpKeygenParams: TKeygenParams): integer;stdcall;external 'keygen.dll';

// VerifyKey() function prototype
function VerifyKey(var lpKeygenVerifyParams: TKeygenVerifyParams): integer;stdcall;external 'keygen.dll';
