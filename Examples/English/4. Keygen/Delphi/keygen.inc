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

{$EXTERNALSYM PELOCK_SAFE_KEY_SIZE}
PELOCK_SAFE_KEY_SIZE            = (40*1024);            // safe buffer size for key data

// output key formats
{$EXTERNALSYM KEY_FORMAT_BIN}
KEY_FORMAT_BIN                  = 0;                    // binary key (raw bytes)

{$EXTERNALSYM KEY_FORMAT_REG}
KEY_FORMAT_REG                  = 1;                    // Windows registry key dump (.reg)

{$EXTERNALSYM KEY_FORMAT_TXT}
KEY_FORMAT_TXT                  = 2;                    // text key (in MIME Base64 format)

// return values
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

        dwFeatures            : TKeygenFeatures;        // feature (additional key data)
end;


// Keygen() function prototype
function Keygen(var lpKeygenParams: TKeygenParams): integer;stdcall;external 'keygen.dll';
