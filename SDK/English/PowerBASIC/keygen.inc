'///////////////////////////////////////////////////////////////////////////////
'//
'// Keygen library header
'//
'// Version        : PELock v2.0
'// Language       : PowerBASIC
'// Author         : Bartosz Wójcik (support@pelock.com)
'// Web page       : https://www.pelock.com
'//
'///////////////////////////////////////////////////////////////////////////////

#IF NOT %DEF(%PELOCK_KEYGEN_INC)
%PELOCK_KEYGEN_INC = 1

%PELOCK_MAX_USERNAME            = 8193              ' max size of registered user name stored in the keyfile
%PELOCK_SAFE_KEY_SIZE           = (40*1024)         ' safe buffer size for key data

' output key formats
%KEY_FORMAT_BIN                 = 0                 ' binary key (raw bytes)
%KEY_FORMAT_REG                 = 1                 ' Windows registry key dump (.reg)
%KEY_FORMAT_TXT                 = 2                 ' text key (in MIME Base64 format)

' Keygen() return values
%KEYGEN_SUCCESS                 = 0                 ' key successfully generated
%KEYGEN_INVALID_PARAMS          = 1                 ' invalid params
%KEYGEN_INVALID_PROJECT         = 2                 ' invalid project file
%KEYGEN_OUT_MEMORY              = 3                 ' out of memory
%KEYGEN_DATA_ERROR              = 4                 ' error while generating key data

' VerifyKey() return values
%KEYGEN_VERIFY_SUCCESS          = 0                 ' key successfully verified
%KEYGEN_VERIFY_INVALID_PARAMS   = 1                 ' invalid params
%KEYGEN_VERIFY_INVALID_PROJECT  = 2                 ' invalid project file
%KEYGEN_VERIFY_OUT_MEMORY       = 3                 ' out of memory
%KEYGEN_VERIFY_DATA_ERROR       = 4                 ' error while verifying key data
%KEYGEN_VERIFY_FILE_ERROR       = 5                 ' cannot open key file

'
' project file path or project file contents as a text buffer
'
UNION KEYGEN_PROJECT_PTR

    lpszProjectPath       AS ASCIIZ PTR             ' project file path
    lpszProjectBuffer     AS ASCIIZ PTR             ' project file text buffer

END UNION

'
' you can store either username in the key or a raw
' data bytes
'
UNION KEYGEN_USERNAME_PTR

    lpszUsername          AS ASCIIZ PTR             ' user name pointer
    lpUsernameRawData     AS BYTE PTR               ' raw data pointer

END UNION

'
' size of username string or size of raw data bytes
'
UNION KEYGEN_USERNAME_SIZE

    dwUsernameLength      AS DWORD                  ' username length (max. 8192 chars)
    dwUsernameRawSize     AS DWORD                  ' raw data size (max. 8192 bytes)

END UNION

'
' helper macro to enable selected feature bits
'
MACRO FUNCTION SET_FEATURE_BIT(FEATURE_INDEX)

    MACROTEMP dwFeatureBit
    DIM dwFeatureBit AS DWORD

    IF (FEATURE_INDEX > 0) AND (FEATURE_INDEX < 33) THEN

        dwFeatureBit = 1

        SHIFT LEFT dwFeatureBit, (FEATURE_INDEX - 1)

    ELSE

        MSGBOX "ERROR: SET_FEATURE_BIT accepts values only from 1-32 range!"

        dwFeatureBit = 0

    END IF

END MACRO = dwFeatureBit

'
' feature bits as a DWORD and as a 4 bytes
'
TYPE KEYGEN_FEATURES_BYTES

    dwKeyData1            AS BYTE
    dwKeyData2            AS BYTE
    dwKeyData3            AS BYTE
    dwKeyData4            AS BYTE

END TYPE

UNION KEYGEN_FEATURES

    dwFeatureBits         AS DWORD                  ' features bits as a DWORD
    dwKeyData             AS KEYGEN_FEATURES_BYTES  ' features bits as BYTEs

END UNION

'
' key file or memory buffer with key file contents
'
UNION KEYGEN_KEY_PTR

    lpszUsername          AS ASCIIZ PTR             ' key file path (input)
    lpKeyBuffer           AS ASCIIZ PTR             ' key file buffer (input)

END UNION

'
' keygen params
'
TYPE KEYGEN_PARAMS

    lpOutputBuffer        AS BYTE PTR               ' output buffer pointer (it must be large engough)
    lpdwOutputSize        AS DWORD PTR              ' pointer to the DWORD where key size will be stored

    dwOutputFormat        AS DWORD                  ' output key format (binary key, Windows registry key dump etc.)

    lpProjectPtr          AS KEYGEN_PROJECT_PTR     ' project file path or text buffer with project file contents
    bProjectBuffer        AS DWORD                  ' is lpszProjectBuffer valid text buffer instead of file path

    bUpdateProject        AS DWORD                  ' add user to the project file
    lpbProjectUpdated     AS DWORD PTR              ' pointer to the BOOL that will receive update status

    lpUsernamePtr         AS KEYGEN_USERNAME_PTR    ' username or raw data pointer
    dwUsernameSize        AS KEYGEN_USERNAME_SIZE   ' username of raw data size

    bSetHardwareLock      AS DWORD                  ' use hardware id locking
    bSetHardwareEncryption AS DWORD                 ' encrypt user name and custom key fields with hardware id
    lpszHardwareId        AS ASCIIZ PTR             ' hardware id string

    bSetKeyIntegers       AS DWORD                  ' set key integers
    dwKeyIntegers(0 TO 15) AS DWORD                 ' custom key values

    bSetKeyCreationDate   AS DWORD                  ' set key creation date
    stKeyCreation         AS SYSTEMTIME             ' key creation date

    bSetKeyExpirationDate AS DWORD                  ' set key expiration date
    stKeyExpiration       AS SYSTEMTIME             ' key expiration date

    bSetFeatureBits       AS DWORD                  ' set feature bits

    dwFeatures            AS KEYGEN_FEATURES        ' feature (additional key data)

END TYPE

'
' verify key params
'
TYPE KEYGEN_VERIFY_PARAMS

    lpKeyPtr             AS KEYGEN_KEY_PTR          ' file file path/memory buffer (input)
    bKeyBuffer           AS DWORD                   ' is lpKeyBuffer valid memory buffer with key contents (input)
    dwKeyBufferSize      AS DWORD                   ' lpKeyBuffer memory size (input)

    lpProjectPtr         AS KEYGEN_PROJECT_PTR      ' project file path or text buffer with project file contents (input)
    bProjectBuffer       AS DWORD                   ' is lpszProjectBuffer valid text buffer instead of file path (input)

    dwOutputFormat       AS DWORD                   ' output format (binary file, registry dump etc.)

    lpUsernamePtr        AS KEYGEN_USERNAME_PTR     ' username or raw data pointer
    dwUsernameSize       AS KEYGEN_USERNAME_SIZE    ' username length or raw data size

    bHardwareLock        AS DWORD                   ' is hardware id locking used
    bHardwareEncryption  AS DWORD                   ' is user name and custom key fields encrypted with a hardware id

    bKeyIntegers         AS DWORD                   ' are key integers set
    dwKeyIntegers(0 TO 15) AS DWORD                 ' custom key values

    bKeyCreationDate     AS DWORD                   ' is key creation date set
    stKeyCreation        AS SYSTEMTIME              ' key creation date

    bKeyExpirationDate   AS DWORD                   ' is key expiration date set
    stKeyExpiration      AS SYSTEMTIME              ' key expiration date

    bFeatureBits         AS DWORD                   ' are feature bits set
    dwFeatures           AS KEYGEN_FEATURES         ' features (additional key data)

    cKeyChecksum(0 TO 31) AS BYTE                   ' key checksum (it can be used to put a key on the blacklist)

END TYPE


' Keygen() and VerifyKey() functions prototypes (for static and dynamic linking)
#IF NOT %DEF(%PELOCK_KEYGEN_DYNAMIC)
    DECLARE FUNCTION Keygen LIB "KEYGEN.DLL" ALIAS "Keygen" (lpKeygenParams AS KEYGEN_PARAMS) AS DWORD
    DECLARE FUNCTION VerifyKey LIB "KEYGEN.DLL" ALIAS "VerifyKey" (lpKeygenVerifyParams AS KEYGEN_VERIFY_PARAMS) AS DWORD
#ELSE
    DECLARE FUNCTION Keygen(lpKeygenParams AS KEYGEN_PARAMS) AS DWORD
    DECLARE FUNCTION VerifyKey(lpKeygenVerifyParams AS KEYGEN_VERIFY_PARAMS) AS DWORD
#ENDIF

#ENDIF ' #IF NOT %DEF(%PELOCK_KEYGEN_INC)