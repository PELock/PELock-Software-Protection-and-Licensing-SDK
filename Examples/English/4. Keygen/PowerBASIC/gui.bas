'///////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to use keygen library to generate license keys
'//
'// Version        : PELock v2.0
'// Language       : PowerBASIC
'// Author         : Bartosz Wójcik (support@pelock.com)
'// Web page       : https://www.pelock.com
'//
'///////////////////////////////////////////////////////////////////////////////

#COMPILE EXE
%USEMACROS = 1

#INCLUDE "win32api.inc"

' link KEYGEN.dll dynamically (by default its linked statically)
%PELOCK_KEYGEN_DYNAMIC = 1
#INCLUDE "keygen.inc"

' Keygen() function prototype
GLOBAL KeygenProc AS DWORD

'///////////////////////////////////////////////////////////////////////////////
'//
'// entrypoint
'//
'///////////////////////////////////////////////////////////////////////////////

FUNCTION PBMAIN () AS LONG

    DIM hKeygen AS DWORD
    DIM szProjectPath AS ASCIIZ * %MAX_PATH
    DIM szUsername AS ASCIIZ * 100

    DIM hKey AS LONG
    DIM hKeyData AS DWORD
    DIM lpKeyData AS BYTE PTR
    DIM dwKeyDataSize AS DWORD

    DIM kpKeygenParams AS KEYGEN_PARAMS

    DIM dwResult AS DWORD

    '///////////////////////////////////////////////////////////////////////////////
    '//
    '// load keygen library
    '//
    '///////////////////////////////////////////////////////////////////////////////

    #IF %DEF(%PELOCK_KEYGEN_DYNAMIC)

    hKeygen = LoadLibrary("KEYGEN.dll")

    ' check library handle
    IF (hKeygen = %NULL) THEN

        MSGBOX "Cannot load library KEYGEN.dll!"

        FUNCTION = 1
        EXIT FUNCTION

    END IF

    ' get "Keygen" procedure address
    KeygenProc = GetProcAddress(hKeygen, "Keygen")

    IF (KeygenProc = %NULL) THEN

        MSGBOX "Cannot find Keygen() procedure in KEYGEN.dll library!"

        FUNCTION = 1
        EXIT FUNCTION

    END IF

    #ENDIF

    '///////////////////////////////////////////////////////////////////////////////
    '//
    '// build project path name
    '//
    '///////////////////////////////////////////////////////////////////////////////

    GetModuleFileName(%NULL, szProjectPath, %MAX_PATH)

    szProjectPath = LEFT$(szProjectPath, INSTR(-1, szProjectPath, "\") - 1) & "\test.plk"


    '///////////////////////////////////////////////////////////////////////////////
    '//
    '// allocate memory for key data
    '//
    '///////////////////////////////////////////////////////////////////////////////

    lpKeyData = VirtualAlloc(BYVAL %NULL, %PELOCK_SAFE_KEY_SIZE, %MEM_RESERVE OR %MEM_COMMIT, %PAGE_READWRITE)

    IF (lpKeyData = %NULL) THEN

        MSGBOX "Cannot allocate memory!"

        FUNCTION  = 1
        EXIT FUNCTION

    END IF

    '///////////////////////////////////////////////////////////////////////////////
    '//
    '// fill PELOCK_KEYGEN_PARAMS structure
    '//
    '///////////////////////////////////////////////////////////////////////////////

    ' output buffer pointer (it must be large engough)
    kpKeygenParams.lpOutputBuffer = lpKeyData

    ' pointer to the DWORD where key size will be stored
    kpKeygenParams.lpdwOutputSize = VARPTR(dwKeyDataSize)

    ' output key format
    ' KEY_FORMAT_BIN - binary key
    ' KEY_FORMAT_REG - Windows registry key dump
    ' KEY_FORMAT_TXT - text key (in MIME Base64 format)
    kpKeygenParams.dwOutputFormat = %KEY_FORMAT_BIN

    ' project file path
    kpKeygenParams.lpProjectPtr.lpszProjectPath = VARPTR(szProjectPath)

    ' are we using text buffer with project file contents (instead of project file)?
    kpKeygenParams.bProjectBuffer = %FALSE

    ' add user to the project file
    kpKeygenParams.bUpdateProject = %FALSE

    ' pointer to the BOOL that will receive update status
    kpKeygenParams.lpbProjectUpdated = %NULL

    ' user name pointer
    szUsername = "Laura Palmer"

    kpKeygenParams.lpUsernamePtr.lpszUsername = VARPTR(szUsername)

    ' username length (max. 8192 chars)
    kpKeygenParams.dwUsernameSize.dwUsernameLength = LEN(szUsername)

    ' use hardware id locking
    kpKeygenParams.bSetHardwareLock = %FALSE

    ' encrypt user name and custom key fields with hardware id
    kpKeygenParams.bSetHardwareEncryption = %FALSE

    ' hardware id string
    kpKeygenParams.lpszHardwareId = %NULL

    ' set key integers
    kpKeygenParams.bSetKeyIntegers = %FALSE

    ' 16 custom key values
    kpKeygenParams.dwKeyIntegers(0) = 1
    kpKeygenParams.dwKeyIntegers(1) = 2
    kpKeygenParams.dwKeyIntegers(2) = 3
    kpKeygenParams.dwKeyIntegers(3) = 4
    kpKeygenParams.dwKeyIntegers(4) = 5
    kpKeygenParams.dwKeyIntegers(5) = 6
    kpKeygenParams.dwKeyIntegers(6) = 7
    kpKeygenParams.dwKeyIntegers(7) = 8
    kpKeygenParams.dwKeyIntegers(8) = 9
    kpKeygenParams.dwKeyIntegers(9) = 10
    kpKeygenParams.dwKeyIntegers(10) = 11
    kpKeygenParams.dwKeyIntegers(11) = 12
    kpKeygenParams.dwKeyIntegers(12) = 13
    kpKeygenParams.dwKeyIntegers(13) = 14
    kpKeygenParams.dwKeyIntegers(14) = 15
    kpKeygenParams.dwKeyIntegers(15) = 16

    ' set key creation date
    kpKeygenParams.bSetKeyCreationDate = %TRUE

    ' key creation date
    GetLocalTime(kpKeygenParams.stKeyCreation)

    ' set key expiration date
    kpKeygenParams.bSetKeyExpirationDate = %FALSE

    ' key expiration date
    'kpKeygenParams.stKeyExpiration.wDay = 01
    'kpKeygenParams.stKeyExpiration.wMonth = 01
    'kpKeygenParams.stKeyExpiration.wYear = 01

    ' set feature bits (unlock FEATURE_x_START / FEATURE_x_END sections)
    kpKeygenParams.bSetFeatureBits = %TRUE

    ' features bits as a DWORD (1), BYTE (4) or BITS (32)
    'kpKeygenParams.dwFeatures.dwFeatureBits = &HFFFFFFFF
    'kpKeygenParams.dwFeatures.dwKeyData.dwKeyData1 = 255
    kpKeygenParams.dwFeatures.dwFeatureBits = SET_FEATURE_BIT(1) OR SET_FEATURE_BIT(32)


    '///////////////////////////////////////////////////////////////////////////////
    '//
    '// generate key data
    '//
    '///////////////////////////////////////////////////////////////////////////////

    #IF %DEF(%PELOCK_KEYGEN_DYNAMIC)

    CALL DWORD KeygenProc USING Keygen(kpKeygenParams) TO dwResult

    #ELSE

    dwResult = Keygen(kpKeygenParams)

    #ENDIF

    SELECT CASE dwResult

    ' key successfully generated
    CASE %KEYGEN_SUCCESS

        ' save license key data to file
        hKey = lcreat("key.lic", 0)

        IF (hKey <> %NULL) THEN

            ' write file
            lwrite(hKey, BYVAL lpKeyData, dwKeyDataSize)

            ' close file handle
            lclose(hKey)

            MSGBOX "Key file successfully generated!"

        ELSE

            MSGBOX "Couldn't create key file!"

        END IF


    ' invalid input params (or missing params)
    CASE %KEYGEN_INVALID_PARAMS

        MSGBOX "Invalid input params (check PELOCK_KEY_PARAMS structure)!"

    ' invalid project file
    CASE %KEYGEN_INVALID_PROJECT

        MSGBOX "Invalid project file, please check it, maybe its missing some data!"

    ' out of memory in Keygen() procedure
    CASE %KEYGEN_OUT_MEMORY

        MSGBOX "Out of memory!"

    ' data generation error
    CASE %KEYGEN_DATA_ERROR

        MSGBOX "Error while generating license key data, please contact with author!"

    ' unknown errors
    CASE ELSE

        MSGBOX "Unknown error, please contact with author!"

    END SELECT

    ' release memory
    VirtualFree(lpKeyData, 0, %MEM_RELEASE)

    FUNCTION = 0

END FUNCTION
