;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to use keygen library to generate license keys
;//
;// Version        : PELock v2.0
;// Language       : PowerBASIC
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\SDK\English\PureBasic\"
XIncludeFile "keygen.pb"

; Keygen() function prototype
Global *KeygenProc

;///////////////////////////////////////////////////////////////////////////////
;//
;// entrypoint
;//
;///////////////////////////////////////////////////////////////////////////////

    hKeygen.l
    szProjectPath.s{#MAX_PATH}
    szUsername.s{100}

    hKey.l
    hKeyData.l
    *lpKeyData.b
    dwKeyDataSize.l

    kpKeygenParams.KEYGEN_PARAMS

    dwResult.l

    ;///////////////////////////////////////////////////////////////////////////////
    ;//
    ;// load keygen library
    ;//
    ;///////////////////////////////////////////////////////////////////////////////

    hKeygen = OpenLibrary(#PB_Any, "KEYGEN.dll")

    If (hKeygen = 0)

      MessageRequester("PELock Keygen", "Cannot load library KEYGEN.dll!")

      End 1
      
    EndIf
    
    ; get "Keygen" procedure address
    *KeygenProc = GetFunction(hKeygen, "Keygen")

    If (*KeygenProc = 0)

        MessageRequester("PELock Keygen", "Cannot find Keygen() procedure in KEYGEN.dll library!")

        End 1
        
    EndIf

    ;///////////////////////////////////////////////////////////////////////////////
    ;//
    ;// build project path name
    ;//
    ;///////////////////////////////////////////////////////////////////////////////

    GetModuleFileName_(#Null, @szProjectPath, #MAX_PATH)

    szProjectPath = GetPathPart(szProjectPath) + "test.plk"


    ;///////////////////////////////////////////////////////////////////////////////
    ;//
    ;// allocate memory for key data
    ;//
    ;///////////////////////////////////////////////////////////////////////////////

    *lpKeyData = AllocateMemory(#PELOCK_SAFE_KEY_SIZE)

    If (*lpKeyData = #Null)

        MessageRequester("PELock Keygen", "Cannot allocate memory!")

        End 1
        
    EndIf

    ;///////////////////////////////////////////////////////////////////////////////
    ;//
    ;// fill PELOCK_KEYGEN_PARAMS structure
    ;//
    ;///////////////////////////////////////////////////////////////////////////////

    ; output buffer pointer (it must be large engough)
    kpKeygenParams\lpOutputBuffer = *lpKeyData

    ; pointer to the DWORD where key size will be stored
    kpKeygenParams\lpdwOutputSize = @dwKeyDataSize

    ; output key format
    ; KEY_FORMAT_BIN - binary key
    ; KEY_FORMAT_REG - Windows registry key dump
    ; KEY_FORMAT_TXT - text key (in MIME Base64 format)
    kpKeygenParams\dwOutputFormat = #KEY_FORMAT_BIN

    ; project file path
    kpKeygenParams\lpszProjectPath = szProjectPath

    ; are we using text buffer with project file contents (instead of project file)?
    kpKeygenParams\bProjectBuffer = #False

    ; add user to the project file
    kpKeygenParams\bUpdateProject = #False

    ; pointer to the BOOL that will receive update status
    kpKeygenParams\lpbProjectUpdated = #Null

    ; user name pointer
    szUsername = "Laura Palmer"

    kpKeygenParams\lpszUsername = szUsername

    ; username length (max. 8192 chars)
    kpKeygenParams\dwUsernameLength = Len(szUsername)

    ; use hardware id locking
    kpKeygenParams\bSetHardwareLock = #False

    ; encrypt user name and custom key fields with hardware id
    kpKeygenParams\bSetHardwareEncryption = #False

    ; hardware id string
    kpKeygenParams\lpszHardwareId = ""

    ; set key integers
    kpKeygenParams\bSetKeyIntegers = #True

    ; 16 custom key values
    kpKeygenParams\dwKeyIntegers[0] = 1
    kpKeygenParams\dwKeyIntegers[1] = 2
    kpKeygenParams\dwKeyIntegers[2] = 3
    kpKeygenParams\dwKeyIntegers[3] = 4
    kpKeygenParams\dwKeyIntegers[4] = 5
    kpKeygenParams\dwKeyIntegers[5] = 6
    kpKeygenParams\dwKeyIntegers[6] = 7
    kpKeygenParams\dwKeyIntegers[7] = 8
    kpKeygenParams\dwKeyIntegers[8] = 9
    kpKeygenParams\dwKeyIntegers[9] = 10
    kpKeygenParams\dwKeyIntegers[10] = 11
    kpKeygenParams\dwKeyIntegers[11] = 12
    kpKeygenParams\dwKeyIntegers[12] = 13
    kpKeygenParams\dwKeyIntegers[13] = 14
    kpKeygenParams\dwKeyIntegers[14] = 15
    kpKeygenParams\dwKeyIntegers[15] = 16

    ; set key creation date
    kpKeygenParams\bSetKeyCreationDate = #True

    ; key creation date
    stLocalTime = Date()
    kpKeygenParams\stKeyCreation\wDay = Day(stLocalTime)
    kpKeygenParams\stKeyCreation\wMonth = Month(stLocalTime)
    kpKeygenParams\stKeyCreation\wYear = Year(stLocalTime)

    ; set key expiration date
    kpKeygenParams\bSetKeyExpirationDate = #False

    ; key expiration date
    ;kpKeygenParams\stKeyExpiration\wDay = 01
    ;kpKeygenParams\stKeyExpiration\wMonth = 01
    ;kpKeygenParams\stKeyExpiration\wYear = 2012

    ; set feature bits (unlock FEATURE_x_START / FEATURE_x_END sections)
    kpKeygenParams\bSetFeatureBits = #True

    ; features bits as a DWORD (1), BYTE (4) or BITS (32)
    ;kpKeygenParams\dwFeatureBits = $FFFFFFFF
    ;kpKeygenParams\dwKeyData[0] = 255
    kpKeygenParams\dwFeatureBits = SET_FEATURE_BIT(1) | SET_FEATURE_BIT(32)


    ;///////////////////////////////////////////////////////////////////////////////
    ;//
    ;// generate key data
    ;//
    ;///////////////////////////////////////////////////////////////////////////////

    dwResult = CallFunctionFast(*KeygenProc, @kpKeygenParams)

    Select dwResult

    ; key successfully generated
    Case #KEYGEN_SUCCESS

        ; save license key data to file
        hKey = CreateFile(#PB_Any, "key.lic")

        If (hKey <> #Null)

            ; write file
            WriteData(hKey, *lpKeyData, dwKeyDataSize)

            ; close file handle
            CloseFile(hKey)

            MessageRequester("PELock Keygen", "Key file successfully generated!")

        Else

            MessageRequester("PELock Keygen", "Couldn't create key file!")

        EndIf


    ; invalid input params (or missing params)
    Case #KEYGEN_INVALID_PARAMS

        MessageRequester("PELock Keygen", "Invalid input params (check PELOCK_KEY_PARAMS structure)!")

    ; invalid project file
    Case #KEYGEN_INVALID_PROJECT

        MessageRequester("PELock Keygen", "Invalid project file, please check it, maybe its missing some data!")

    ; out of memory in Keygen() procedure
    Case #KEYGEN_OUT_MEMORY

        MessageRequester("PELock Keygen", "Out of memory!")

    ; data generation error
    Case #KEYGEN_DATA_ERROR

        MessageRequester("PELock Keygen", "Error while generating license key data, please contact with author!")

    ; unknown errors
    Default

        MessageRequester("PELock Keygen", "Unknown error, please contact with author!")

    EndSelect

    ; release memory
    FreeMemory(*lpKeyData)

    FUNCTION = 0

End FUNCTION

; IDE Options = PureBasic 4.10 (Windows - x86)