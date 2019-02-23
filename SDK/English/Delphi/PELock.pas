////////////////////////////////////////////////////////////////////////////////
//
// PELock Unit
//
// Version        : PELock v2.09
// Language       : Delphi/Pascal
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

//
// in order to use PELock unit and PELock macros you need to copy its files to
// the application directory or you can add unit and macro's path to the:
//
// Menu -> Tools -> Environment Options -> Library -> Library path
//
unit PELock;

//
// define which protection procedures will be available
// if you don't want to include some of the procedures
// comment selected $DEFINE declaration
//
{$DEFINE PELOCK_LICENSE_APIS}
{$DEFINE PELOCK_TIMETRIAL_APIS}
{$DEFINE PELOCK_CRYPTO_APIS}
{$DEFINE PELOCK_PRESENT_CHECKS}
{$DEFINE PELOCK_PROTECTED_CONST}

interface
uses Windows, SysUtils;

const

//
// max size of registered user name stored in the keyfile
//
PELOCK_MAX_USERNAME = 8193;

//
// max. number of hardware id characters, including terminating null at the end
//
PELOCK_MAX_HARDWARE_ID = 17;

//
// license system apis
//
{$IFDEF PELOCK_LICENSE_APIS}

// return codes for GetKeyStatus()
type TPELockKeyStatusError = (PELOCK_KEY_NOT_FOUND = 0, PELOCK_KEY_OK = 1, PELOCK_KEY_INVALID = 2, PELOCK_KEY_STOLEN = 3, PELOCK_KEY_WRONG_HWID = 4, PELOCK_KEY_EXPIRED = 5);

function GetKeyStatus: TPELockKeyStatusError;
function IsKeyHardwareIdLocked: Boolean;
function GetRegistrationName: string;
function GetRawRegistrationName(lpRegistrationRawName: PByteArray; nMaxCount: integer): integer;
function SetRegistrationKey(szRegistrationKeyPath: string): Boolean;
function SetRegistrationData(lpBuffer: PByteArray; dwSize: integer): Boolean;
function SetRegistrationText(szRegistrationKey: string): Boolean;
procedure DisableRegistrationKey(bPermamentLock: Boolean);
function ReloadRegistrationKey: Boolean;
function GetKeyData(iValue: integer): Integer;
function IsFeatureEnabled(iIndex: integer): Boolean;
function GetKeyInteger(iIndex: integer): Integer;
function GetHardwareId: string;
function GetKeyExpirationDate(var lpSystemTime: TSystemTime): Boolean;
function GetKeyCreationDate(var lpSystemTime: TSystemTime): Boolean;
function GetKeyRunningTime(var lpRunningTime: TSystemTime): Boolean;

// hardware identifier structure for custom callback routine
type THardwareId = array[0..7] of Char;
function SetHardwareIdCallback(lpHardwareIdFunc: TFarProc): Boolean;
{$ENDIF}

//
// time trial apis
//
{$IFDEF PELOCK_TIMETRIAL_APIS}

// error codes retured by time trial apis
type TPELockTrialError = (PELOCK_TRIAL_ABSENT = 0, PELOCK_TRIAL_ACTIVE = 1, PELOCK_TRIAL_EXPIRED = 2);

function GetTrialDays(var dwTotalDays, dwLeftDays: integer): TPELockTrialError;
function GetTrialExecutions(var dwTotalExecutions, dwLeftExecutions: integer): TPELockTrialError;
function GetExpirationDate(var lpExpirationDate: TSystemTime): TPELockTrialError;
function GetTrialPeriod(var lpPeriodBegin, lpPeriodEnd: TSystemTime): TPELockTrialError;
{$ENDIF}

//
// built-in encryption functions
//
{$IFDEF PELOCK_CRYPTO_APIS}

// encryption functions (stream cipher)
function EncryptData(lpKey: PByteArray; dwKeyLen: integer; lpBuffer: PByteArray; dwSize: integer): Integer;
function DecryptData(lpKey: PByteArray; dwKeyLen: integer; lpBuffer: PByteArray; dwSize: integer): Integer;

// encrypt memory with current session keys
function EncryptMemory(lpBuffer: PByteArray; dwSize: integer): Integer;
function DecryptMemory(lpBuffer: PByteArray; dwSize: integer): Integer;
{$ENDIF}

//
// protections checks
//
{$IFDEF PELOCK_PRESENT_CHECKS}
function IsPELockPresent1: Boolean;
function IsPELockPresent2: Boolean;
function IsPELockPresent3: Boolean;
function IsPELockPresent4: Boolean;
function IsPELockPresent5: Boolean;
function IsPELockPresent6: Boolean;
function IsPELockPresent7: Boolean;
function IsPELockPresent8: Boolean;
{$ENDIF}

//
// protected constants
//
{$IFDEF PELOCK_PROTECTED_CONST}
function PELOCK_DWORD(const dwValue:DWORD; const dwRandomizer:DWORD = $0; const dwMagic1:DWORD = $11223344; const dwMagic2:DWORD = $44332211): DWORD; stdcall;
{$ENDIF}

implementation

//
// function GetKeyStatus: TPELockKeyStatusError;
//
// returns information about license key status code
//
// [in]
// no params
//
// [out]
// one of the following values:
// PELOCK_KEY_NOT_FOUND  - key not found
// PELOCK_KEY_OK         - key is valid
// PELOCK_KEY_INVALID    - invalid key format
// PELOCK_KEY_STOLEN     - key is stolen
// PELOCK_KEY_WRONG_HWID - hardware id doesn't match
// PELOCK_KEY_EXPIRED    - key is expired
//
{$IFDEF PELOCK_LICENSE_APIS}
function GetKeyStatus: TPELockKeyStatusError;
begin
  Result := TPELockKeyStatusError( GetWindowText( HWND(-17), nil, 256 ) );
end;

//
// function IsKeyHardwareIdLocked: Boolean;
//
// is the key locked to the hardware identifier
//
// [in]
// no params
//
// [out]
// True  - hardware id is set for the current key
// False - hardware id is not set for the current key
//
function IsKeyHardwareIdLocked: Boolean;
begin
  if GetWindowText( HWND(-24), nil, 128) = 0 then
    Result := False
  else
    Result := True;
end;

//
// function GetRegistrationName: string;
//
// returns registered user name or '' if there's no key or
// license key is invalid/expired/hardware id is invalid
//
// [in]
// no params
//
// [out]
// registered user name or '' if there's no valid key
//
function GetRegistrationName: string;
var
  szRegistrationName:array[0..PELOCK_MAX_USERNAME] of Char;
begin
  if GetWindowText( HWND(-1), szRegistrationName, PELOCK_MAX_USERNAME) = 0 then
    Result := ''
  else
    Result := szRegistrationName;
end;

//
// function GetRawRegistrationName(var lpRegistrationRawName: PByteArray; nMaxCount: integer): integer;
//
// get raw registration data (read username as a raw byte array)
//
// [in]
// lpRegistrationRawName - buffer for the registration data
// nMaxCount - size of lpRegistrationRawName array in bytes
//
// [out]
// length of registration data bytes or 0 if there's no valid key
//
function GetRawRegistrationName(lpRegistrationRawName: PByteArray; nMaxCount: integer): integer;
begin
  Result := GetWindowText( HWND(-22), PChar(lpRegistrationRawName), nMaxCount);
end;

//
// function SetRegistrationKey(szRegistrationKeyPath: string): Boolean;
//
// set license key path (other than application's directory)
//
// [in]
// szRegistrationKeyPath - full path to the keyfile
//
// [out]
// True  - key has been successfully verified and it will be used
// False - function failed / invalid file / license key expired
//         invalid hardware id / unexpected error
//
function SetRegistrationKey(szRegistrationKeyPath: string): Boolean;
begin
  if GetWindowText( HWND(-2), PChar(szRegistrationKeyPath), 0) = 0 then
    Result := False
  else
    Result := True;
end;

//
// function SetRegistrationData(lpBuffer: PByteArray; dwSize: integer): Boolean;
//
// set license key from the memory buffer
//
// [in]
// lpBuffer - byte array containing license key data
// dwSize   - buffer size
//
// [out]
// True  - license key successfully verified and set
// False - invalid license key / license key expired /
//         invalid hardware id / unexpected error
//
function SetRegistrationData(lpBuffer: PByteArray; dwSize: integer): Boolean;
begin
  if GetWindowText(HWND(-7), PChar(lpBuffer), dwSize) = 0 then
    Result := False
  else
    Result := True;
end;

//
// function SetRegistrationText(szRegistrationKey: string): Boolean;
//
// set license data from the text buffer (in MIME Base64 format)
//
// [in]
// szRegistrationKey - registration key string in MIME Base64 format
//
// [out]
// True  - key has been successfully verified and it will be used
// False - function failed / invalid file / license key expired
//         invalid hardware id / unexpected error
//
function SetRegistrationText(szRegistrationKey: string): Boolean;
begin
  if GetWindowText( HWND(-22), PChar(szRegistrationKey), 0) = 0 then
    Result := False
  else
    Result := True;
end;

//
// procedure DisableRegistrationKey(bPermamentLock: Boolean);
//
// disable current registration key, do not allow to set a new key again
//
// [in]
// bPermamentLock - do now allow to set any new key
//
// [out]
// (nothing)
//
procedure DisableRegistrationKey(bPermamentLock: Boolean);
begin
  GetWindowText(HWND(-14), nil, Integer(bPermamentLock));
end;

//
// function ReloadRegistrationKey: Boolean;
//
// reload registration key from the default search locations
//
// [in]
// (nothing)
//
// [out]
// True  - key has been successfully verified and it will be used
// False - function failed / invalid file / license key expired
//         invalid hardware id / unexpected error
//
function ReloadRegistrationKey: Boolean;
begin
  if GetWindowText( HWND(-16), nil, 256) = 0 then
    Result := False
  else
    Result := True;
end;

//
// function GetKeyData(iValue: integer): Integer;
//
// get user 8bit integer stored in the keyfile
//
// [in]
// iValue - value index (withing range 1 - 4)
//
// [out]
// user integer stored in the keyfile
//
function GetKeyData(iValue: integer): Integer;
begin
  Result := GetWindowText( HWND(-3), nil, iValue);
end;

//
// function IsFeatureEnabled(iIndex: integer): Boolean;
//
// check key's binary feature state
//
// [in]
// iIndex - feature index (within range 1 - 32)
//
// [out]
// True  - feature enabled
// False - feature disabled
//
function IsFeatureEnabled(iIndex: integer): Boolean;
begin
  if GetWindowText( HWND(-6), nil, iIndex) = 0 then
    Result := False
  else
    Result := True;
end;

//
// function GetKeyInteger(iIndex: integer): Integer;
//
// get user integer stored in the keyfile
//
// [in]
// iIndex - value index (withing range 1 - 16)
//
// [out]
// user integer stored in the keyfile
//
function GetKeyInteger(iIndex: integer): Integer;
begin
  Result := GetWindowText( HWND(-8), nil, iIndex);
end;

//
// function GetHardwareId: string;
//
// get hardware id identifier for the current machine
//
// [in]
// no params
//
// [out]
// hardware id identifier or '' on error ('' is returned also
// when you call this function from the unprotected application)
//
function GetHardwareId: string;
var
  szHardwareId: array[0..128] of Char;
begin
  if GetWindowText( HWND(-4), szHardwareId, 128) = 0 then
    Result := ''
  else
    Result := szHardwareId;
end;

//
// function SetHardwareIdCallback(lpHardwareIdFunc: TFarProc): Boolean;
//
// set hardware id callback routine
//
// [in]
// lpHardwareIdFunc - custom routine to read hardware identifier
//
// function CustomHardwareId(var lpcHardwareId: THardwareId): Boolean; stdcall;
// begin
// ...
// end;
//
// [out]
// True  - callback routine sucessfully set
// False - couldn't set callback routine
//
function SetHardwareIdCallback(lpHardwareIdFunc: TFarProc): Boolean;
begin
  if GetWindowText( HWND(-20), PChar(lpHardwareIdFunc), 256) = 0 then
    Result := False
  else
    Result := True;
end;

//
// function GetKeyExpirationDate(var lpSystemTime: TSystemTime): Boolean;
//
// get key expiration date
//
// [in]
// lpSystemTime - pointer to the TSystemTime structure
//
// [out]
// True  - key expiration date was set, and so the TSystemTime structure
//         is filled with the expiration date details (day/month/year)
// False - invalid key or key doesn't have expiration date set
//
function GetKeyExpirationDate(var lpSystemTime: TSystemTime): Boolean;
begin
  if GetWindowText( HWND(-5), PChar(@lpSystemTime), 256) = 1 then
    Result := True
  else
    Result := False;
end;

//
// function GetKeyCreationDate(var lpSystemTime: TSystemTime): Boolean;
//
// get key creation date (if it was set)
//
// [in]
// lpSystemTime - pointer to the TSystemTime structure
//
// [out]
// True  - key creation date was set, and so the TSystemTime structure
//         is filled with the creation date details (day/month/year)
// False - invalid key or key doesn't have creation date set
//
function GetKeyCreationDate(var lpSystemTime: TSystemTime): Boolean;
begin
  if GetWindowText( HWND(-15), PChar(@lpSystemTime), 256) = 1 then
    Result := True
  else
    Result := False;
end;

//
// function GetKeyRunningTime(var lpRunningTime: TSystemTime): Boolean;
//
// get key running time (since it was set)
//
// [in]
// lpRunningTime - pointer to the TSystemTime structure
//
// [out]
// True  - key running time was set in the TSystemTime structure
// False - key doesn't exist or invalid key
//
function GetKeyRunningTime(var lpRunningTime: TSystemTime): Boolean;
begin
  if GetWindowText( HWND(-23), PChar(@lpRunningTime), 256) = 1 then
    Result := True
  else
    Result := False;
end;

{$ENDIF} // PELOCK_LICENSE_APIS

//
// function GetTrialDays(var dwTotalDays, dwLeftDays: integer): TPELockTrialError;
//
// get trial days, number of total trial days and days left
//
// [in]
// dwTotalDays - pointer to the integer value that will receive
//               number of total trial days (it can be set to nil)
// dwLeftDays  - pointer to the integer value that will receive
//               number of days left in the trial period
//               (it can be set to nil)
// [out]
// one of the following values:
// PELOCK_TRIAL_ABSENT  - time trial options were not enabled for this application
// PELOCK_TRIAL_ACTIVE  - time trial is active
// PELOCK_TRIAL_EXPIRED - time trial expired (TSystemTime structure is filled)
//
{$IFDEF PELOCK_TIMETRIAL_APIS}
function GetTrialDays(var dwTotalDays, dwLeftDays: integer): TPELockTrialError;
begin
  Result := TPELockTrialError( GetWindowText( HWND(-10), PChar(@dwTotalDays), Integer(@dwLeftDays) ) );
end;

//
// function GetTrialExecutions(var dwTotalExecutions, dwLeftExecutions: integer): TPELockTrialError;
//
// get trial executions
//
// [in]
// dwTotalExecutions - pointer to the integer value that will receive
//                     number of total trial executions (it can be set to nil)
// dwLeftExecutions  - pointer to the integer value that will receive
//                     number of executions left in the trial period
//                     (it can be set to nil)
// [out]
// one of the following values:
// PELOCK_TRIAL_ABSENT  - time trial options were not enabled for this application
// PELOCK_TRIAL_ACTIVE  - time trial is active
// PELOCK_TRIAL_EXPIRED - time trial expired
//
function GetTrialExecutions(var dwTotalExecutions, dwLeftExecutions: integer): TPELockTrialError;
begin
  Result := TPELockTrialError( GetWindowText( HWND(-11), PChar(@dwTotalExecutions), Integer(@dwLeftExecutions) ) );
end;

//
// function GetExpirationDate(var lpExpirationDate: TSystemTime): TPELockTrialError;
//
// get expiration date
//
// [in]
// lpSystemTime - pointer to the TSystemTime structure
//
// [out]
// one of the following values:
// PELOCK_TRIAL_ABSENT  - time trial options were not enabled for this application
// PELOCK_TRIAL_ACTIVE  - time trial is active, and TSystemTime structre is
//                        filled with the expiration date, only day, month and year are used
// PELOCK_TRIAL_EXPIRED - time trial expired (TSystemTime structure is filled)
//
function GetExpirationDate(var lpExpirationDate: TSystemTime): TPELockTrialError;
begin
  Result := TPELockTrialError( GetWindowText( HWND(-12), PChar(@lpExpirationDate), 512 ) );
end;

//
// function GetTrialPeriod(var lpPeriodBegin, lpPeriodEnd: TSystemTime): TPELockTrialError;
//
// get trial period
//
// [in]
// lpPeriodBegin - pointer to the TSystemTime structure (it can be set to TSystemTime(nil^) )
// lpPeriodEnd   - pointer to the TSystemTime structure (it can be set to TSystemTime(nil^) )
//
// [out]
// one of the following values:
// PELOCK_TRIAL_ABSENT  - time trial options were not enabled for this application
// PELOCK_TRIAL_ACTIVE  - time trial is active, and TSystemTime structre is
//                        filled with the expiration date, only day, month and year are used
//
function GetTrialPeriod(var lpPeriodBegin, lpPeriodEnd: TSystemTime): TPELockTrialError;
begin
  Result := TPELockTrialError( GetWindowText( HWND(-13), PChar(@lpPeriodBegin), Integer(@lpPeriodEnd) ) );
end;
{$ENDIF} // PELOCK_TIMETRIAL_APIS

//
// function EncryptData(lpKey: PByteArray; dwKeyLen: integer; lpBuffer: PByteArray; dwSize: integer): Integer;
//
// encrypts data buffer with the provided key
//
// [in]
// lpKey    - byte array containing encryption key
// dwKeyLen - encryption key size in bytes
// lpBuffer - byte array containing data to encrypt
// dwSize   - size in bytes
//
// [out]
// number of encrypted bytes or 0 if the application is not protected
//
{$IFDEF PELOCK_CRYPTO_APIS}
function EncryptData(lpKey: PByteArray; dwKeyLen: integer; lpBuffer: PByteArray; dwSize: integer): Integer;
begin
  Result := Integer( DeferWindowPos(HDWP(lpKey), HWND(-1), HWND(dwKeyLen), Integer(lpBuffer), Integer(dwSize), 1, 0, 0 ) );
end;

//
// function DecryptData(lpKey: PByteArray; dwKeyLen: integer; lpBuffer: PByteArray; dwSize: integer): Integer;
//
// decrypts data buffer with the provided key
//
// [in]
// lpKey    - byte array containing decryption key
// dwKeyLen - decryption key size in bytes
// lpBuffer - byte array containing data to decrypt
// dwSize   - size in bytes
//
// [out]
// number of decrypted bytes or 0 if the application is not protected
//
function DecryptData(lpKey: PByteArray; dwKeyLen: integer; lpBuffer: PByteArray; dwSize: integer): Integer;
begin
  Result := Integer( DeferWindowPos(HDWP(lpKey), HWND(-1), HWND(dwKeyLen), Integer(lpBuffer), Integer(dwSize), 0, 0, 0 ) );
end;

//
// function EncryptMemory(lpBuffer: PByteArray; dwSize: integer): Integer;
//
// encrypts data buffer with the current process session key
//
// [in]
// lpBuffer - byte array containing data to encrypt
// dwSize   - size in bytes
//
// [out]
// number of encrypted bytes or 0 if the application is not protected
//
function EncryptMemory(lpBuffer: PByteArray; dwSize: integer): Integer;
begin
  Result := Integer( DeferWindowPos(0, HWND(-1), 0, Integer(lpBuffer), Integer(dwSize), 1, 0, 0 ) );
end;

//
// function DecryptMemory(lpBuffer: PByteArray; dwSize: integer): Integer;
//
// decrypts data buffer with the current process session key
//
// [in]
// lpBuffer - byte array containing data to decrypt
// dwSize   - size in bytes
//
// [out]
// number of decrypted bytes or 0 if the application is not protected
//
function DecryptMemory(lpBuffer: PByteArray; dwSize: integer): Integer;
begin
  Result := Integer( DeferWindowPos(0, HWND(-1), 0, Integer(lpBuffer), Integer(dwSize), 0, 0, 0 ) );
end;
{$ENDIF} // PELOCK_CRYPTO_APIS

//
// function IsPELockPresent1: Boolean;
// ...
// function IsPELockPresent8: Boolean;
//
// check PELock's protection presence
//
// [in]
// no params
//
// [out]
// True  - PELock protection is present
// False - protection removed or file hasn't been protected yet
//
// [notes]
// don't change the params for a WinApi procedures
//
{$IFDEF PELOCK_PRESENT_CHECKS}
function IsPELockPresent1: Boolean;
begin
  if GetAtomName(0, nil, 256) <> 0 then
    Result := True
  else
    Result := False;
end;

function IsPELockPresent2: Boolean;
begin
  if LockFile(0, 128, 0, 512, 0) <> False then
    Result := True
  else
    Result := False;
end;

function IsPELockPresent3: Boolean;
begin
  if MapViewOfFile(0, FILE_MAP_COPY, 0, 0, 1024) <> nil then
    Result := True
  else
    Result := False;
end;

function IsPELockPresent4: Boolean;
begin
  if SetWindowRgn(0, 0, False) <> 0 then
    Result := True
  else
    Result := False;
end;

function IsPELockPresent5: Boolean;
begin
  if GetWindowRect(0, TRect(nil^)) <> False then
    Result := True
  else
    Result := False;
end;

function IsPELockPresent6: Boolean;
begin
  if GetFileAttributes(nil) <> $FFFFFFFF then
    Result := True
  else
    Result := False;
end;

function IsPELockPresent7: Boolean;
begin
  if GetFileTime(0, nil, nil, nil) <> False then
    Result := True
  else
    Result := False;
end;

function IsPELockPresent8: Boolean;
begin
  if SetEndOfFile(0) <> False then
    Result := True
  else
    Result := False;
end;
{$ENDIF} // PELOCK_PRESENT_CHECKS

//
// PELOCK_DWORD(const dwValue:DWORD):DWORD
//
// returns provided constant value, when the application is protected,
// dwValue is hidden to the cracker/hacker/reverser
//
// [in]
// dwValue - constant integer value
//
// [out]
// the same as the input dwValue
//
// [notes]
// don't change the dwMagic1, dwMagic2 params nor the stdcall
// calling convention!
//
{$IFDEF PELOCK_PROTECTED_CONST}
function PELOCK_DWORD(const dwValue:DWORD; const dwRandomizer:DWORD = $0; const dwMagic1:DWORD = $11223344; const dwMagic2:DWORD = $44332211): DWORD; stdcall;
var
  dwReturnValue: DWORD;
  dwParams: array[0..2] of DWORD;
  dwDecodedValue: DWORD;
begin
    dwDecodedValue := dwValue - dwRandomizer;

    dwParams[0] := dwDecodedValue;
    dwParams[1] := dwMagic1;
    dwParams[2] := dwMagic2;

    if GetWindowText( HWND(-9), @dwReturnValue, Integer(@dwParams) ) <> 0 then
    begin
      Result := dwReturnValue;
    end
    else
    begin
      Result := dwDecodedValue;
    end;
end;
{$ENDIF} // PELOCK_PROTECTED_CONST

end.
