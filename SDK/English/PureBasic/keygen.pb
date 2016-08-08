;///////////////////////////////////////////////////////////////////////////////
;//
;// Keygen library header
;//
;// Version        : PELock v2.0
;// Language       : PowerBASIC
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

#PELOCK_MAX_USERNAME            = 8193       ; max size of registered user name stored in the keyfile, including terminating null at the end
#PELOCK_MAX_HARDWARE_ID         = 17         ; max. number of hardware id characters, including terminating null at the end
#PELOCK_SAFE_KEY_SIZE           = (40*1024)  ; safe buffer size for key data

; output key formats
#KEY_FORMAT_BIN                 = 0          ; binary key (raw bytes)
#KEY_FORMAT_REG                 = 1          ; Windows registry key dump (.reg)
#KEY_FORMAT_TXT                 = 2          ; text key (in MIME Base64 format)

; Keygen() return values
#KEYGEN_SUCCESS                 = 0          ; key successfully generated
#KEYGEN_INVALID_PARAMS          = 1          ; invalid params
#KEYGEN_INVALID_PROJECT         = 2          ; invalid project file
#KEYGEN_OUT_MEMORY              = 3          ; out of memory
#KEYGEN_DATA_ERROR              = 4          ; error while generating key data

; VerifyKey() return values
#KEYGEN_VERIFY_SUCCESS          = 0          ; key successfully verified
#KEYGEN_VERIFY_INVALID_PARAMS   = 1          ; invalid params
#KEYGEN_VERIFY_INVALID_PROJECT  = 2          ; invalid project file
#KEYGEN_VERIFY_OUT_MEMORY       = 3          ; out of memory
#KEYGEN_VERIFY_DATA_ERROR       = 4          ; error while verifying key data
#KEYGEN_VERIFY_FILE_ERROR       = 5          ; cannot open key file

;
; helper procedure to enable selected feature bits
;
Procedure SET_FEATURE_BIT(FEATURE_INDEX)

    dwFeatureBit.l = 0

    If (FEATURE_INDEX > 0) And (FEATURE_INDEX < 33)

        dwFeatureBit = (1 << (FEATURE_INDEX - 1))

    Else

        MessageRequester("PELock Keygen", "ERROR: SET_FEATURE_BIT accepts values only from 1-32 range!")

    EndIf

    ProcedureReturn dwFeatureBit

EndProcedure

;
; keygen params
;
Structure KEYGEN_PARAMS

    *lpOutputBuffer.b                   ; output buffer pointer (it must be large engough)
    *lpdwOutputSize.l                   ; pointer to the DWORD where key size will be stored

    dwOutputFormat.l                    ; output key format (binary key, Windows registry key dump etc.)

    StructureUnion

        *lpszProjectPath.s              ; project file path
        *lpszProjectBuffer.s            ; project file text buffer

    EndStructureUnion

    bProjectBuffer.l                    ; is lpszProjectBuffer valid text buffer instead of file path

    bUpdateProject.l                    ; add user to the project file
    *lpbProjectUpdated.l                ; pointer to the BOOL that will receive update status

    StructureUnion

        *lpszUsername.s                 ; user name pointer
        *lpUsernameRawData.b            ; raw data pointer

    EndStructureUnion

    StructureUnion

        dwUsernameLength.l              ; username length (max. 8192 chars)
        dwUsernameRawSize.l             ; raw data size (max. 8192 bytes)

    EndStructureUnion

    bSetHardwareLock.l                  ; use hardware id locking
    bSetHardwareEncryption.l            ; encrypt user name and custom key fields with hardware id
    *lpszHardwareId.s                   ; hardware id string

    bSetKeyIntegers.l                   ; set key integers
    dwKeyIntegers.l[16]                 ; custom key values

    bSetKeyCreationDate.l               ; set key creation date
    stKeyCreation.SYSTEMTIME            ; key creation date

    bSetKeyExpirationDate.l             ; set key expiration date
    stKeyExpiration.SYSTEMTIME          ; key expiration date

    bSetFeatureBits.l                   ; set feature bits

    StructureUnion

        dwFeatureBits.l                 ; features bits as a DWORD
        dwKeyData.b[4]                  ; feature bits as a BYTES

    EndStructureUnion

EndStructure

;
; verify key params
;
Structure KEYGEN_VERIFY_PARAMS

    StructureUnion

        *lpszKeyPath.s                  ; key file path (input)
        *lpKeyBuffer.b                  ; key file buffer (input)

    EndStructureUnion

    bKeyBuffer.l                        ; is lpKeyBuffer valid memory buffer with key contents (input)
    dwKeyBufferSize.l                   ; lpKeyBuffer memory size (input)

    StructureUnion

        *lpszProjectPath.s              ; project file path (input)
        *lpszProjectBuffer.s            ; project file text buffer (input)

    EndStructureUnion

    bProjectBuffer.l                    ; is lpszProjectBuffer valid text buffer instead of file path (input)

    dwOutputFormat.l                    ; output format (binary file, registry dump etc.)

    StructureUnion
    
        *lpszUsername.s                 ; user name pointer
        *lpUsernameRawData.b            ; raw data

    EndStructureUnion


    StructureUnion

        dwUsernameLength.l              ; username length (max. 8192 chars)
        dwUsernameRawSize.l             ; raw data size (max. 8192 bytes)

    EndStructureUnion

    bHardwareLock.l                     ; is hardware id locking used
    bHardwareEncryption.l               ; is user name and custom key fields encrypted with a hardware id

    bKeyIntegers.l                      ; are key integers set
    dwKeyIntegers.l[16]                 ; custom key values

    bKeyCreationDate.l                  ; is key creation date set
    stKeyCreation.SYSTEMTIME            ; key creation date

    bKeyExpirationDate.l                ; is key expiration date set
    stKeyExpiration.SYSTEMTIME          ; key expiration date

    bFeatureBits.l                      ; are feature bits set

    StructureUnion

        dwFeatureBits.l                 ; features bits as a DWORD
        dwKeyData.b[4]                  ; feature bits as a BYTES

    EndStructureUnion

    cKeyChecksum.b[32]                  ; key checksum (it can be used to put a key on the blacklist)

EndStructure
