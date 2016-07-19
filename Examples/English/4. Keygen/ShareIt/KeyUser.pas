////////////////////////////////////////////////////////////////////////////////
//
// ShareIt keygen example
//
// ShareIt SDK    : SDK 3 File Revision 3
// Version        : PELock v2.0
// Language       : Delphi/Pascal
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

//
// in order to use KEYGEN.INC you need to copy it to the application
// directory or you can add its path to the:
//
// Menu -> Tools -> Environment Options -> Library -> Library path
//
unit KeyUser;

interface

uses
  Windows, SysUtils, KeyIntf;

// KEYGEN.dll prototypes
{$I KEYGEN.INC}

// store creation date (purchase date)
{$DEFINE CREATION_DATE}

// use hardware locking (hardware id passed as ADDITIONAL1 entry)
//{$DEFINE HARDWARE_ID}

type
  TMyKeyGen = class(TAbstractKeyGen)
  protected
    function GetTitle: string; override;
    function GenerateKey: integer; override;
  end;

implementation

{ TMyKeyGen }
function TMyKeyGen.GetTitle: string;
begin
  Result := 'PELock v2.0 Key Generator';
end;


function TMyKeyGen.GenerateKey: integer;
var
    KeyDataArray      : array[0..PELOCK_SAFE_KEY_SIZE] of byte;   // output buffer for key data
    KeyDataSize       : DWORD;                    // key data size
    KeyCreationDate   : TSystemTime;              // key creation date
    KeyExpirationDate : TSystemTime;              // key expiration date
    kpKeygenParams    : TKeygenParams;            // keygen params structure
    Status            : DWORD;                    // return value from Keygen()

    szRegNameFormat   : String;
    REG_NAME, EMAIL   : String;                   // input params
    PURCHASE_ID       : String;
    PRODUCT_ID        : String;
    QUANTITY          : String;
    HARDWARE_ID       : String;
    PURCHASE_DATE     : String;

begin

    //////////////////////////////////////////////////////////////////////
    // sample input values (available fields):
    //
    // ENCODING=UTF8
    // PURCHASE_ID=0
    // RUNNING_NO=1
    // PURCHASE_DATE=23/07/2004
    // PRODUCT_ID=100000
    // LANGUAGE_ID=2
    // QUANTITY=1
    // REG_NAME=Peter "Test" Müller
    // ADDITIONAL1=
    // ADDITIONAL2=
    // RESELLER=
    // LASTNAME=Müller
    // FIRSTNAME=Peter
    // COMPANY=
    // EMAIL=mueller@test.net
    // PHONE=
    // FAX=
    // STREET=
    // ZIP=
    // CITY=
    // STATE=
    // COUNTRY=
    //
    //////////////////////////////////////////////////////////////////////
    // read input values
    // user either Value() or WideValue() (for UTF8 encoding)
    //////////////////////////////////////////////////////////////////////

    REG_NAME      := Value('REG_NAME');
    EMAIL         := Value('EMAIL');
    PURCHASE_ID   := Value('PURCHASE_ID');
    QUANTITY      := Value('QUANTITY');
    HARDWARE_ID   := Value('ADDITIONAL1');
    PRODUCT_ID    := Value('PRODUCT_ID');

    PURCHASE_DATE := Value('PURCHASE_DATE');

    //////////////////////////////////////////////////////////////////////
    // validate input values
    //////////////////////////////////////////////////////////////////////

    if (Length(REG_NAME) <= 0) then
    raise EKeyException.Create('REG_NAME is empty', ERC_BAD_INPUT);

    if (Length(EMAIL) <= 0) then
    raise EKeyException.Create('EMAIL is empty', ERC_BAD_INPUT);

    // hardware id required!
    {$IFDEF HARDWARE_ID}
    if (Length(HARDWARE_ID) <> 16) then
    raise EKeyException.Create('ADDITIONAL1 (HARDWARE_ID) is in wrong format', ERC_BAD_INPUT);
    {$ENDIF}

    //////////////////////////////////////////////////////////////////////
    // output buffer settings
    //////////////////////////////////////////////////////////////////////

    // buffer for the key data (array of bytes)
    kpKeygenParams.lpOutputBuffer := @KeyDataArray[0];

    // pointer to the DWORD where key size will be stored
    kpKeygenParams.lpdwOutputSize := @KeyDataSize;

    //////////////////////////////////////////////////////////////////////
    // project path, flag to update project
    //////////////////////////////////////////////////////////////////////

    kpKeygenParams.lpProjectPtr.lpszProjectPath := PChar(ExtractFilePath(ParamStr(0))+'test.plk');

    // are we using text buffer with project file contents (instead of project file)?
    kpKeygenParams.bProjectBuffer := FALSE;

    kpKeygenParams.bUpdateProject := FALSE;
    kpKeygenParams.lpbProjectUpdated := nil;

    //////////////////////////////////////////////////////////////////////
    // output key format
    // KEY_FORMAT_BIN - binary key
    // KEY_FORMAT_REG - Windows registry key dump
    // KEY_FORMAT_TXT - text key (in MIME Base64 format)
    //////////////////////////////////////////////////////////////////////

    kpKeygenParams.dwOutputFormat := KEY_FORMAT_REG;

    //////////////////////////////////////////////////////////////////////
    // username
    //////////////////////////////////////////////////////////////////////

    // format registration name string (include e-mail address)
    szRegNameFormat := Trim(REG_NAME) + #13#10 + Trim(EMAIL);

    kpKeygenParams.lpUsernamePtr.lpszUsername := PChar(szRegNameFormat);
    kpKeygenParams.dwUsernameSize.dwUsernameLength := Length(szRegNameFormat);

    //////////////////////////////////////////////////////////////////////
    // hardware identifier
    //////////////////////////////////////////////////////////////////////

    {$IFDEF HARDWARE_ID}
    kpKeygenParams.bSetHardwareLock := True;
    kpKeygenParams.lpszHardwareId := PChar(HARDWARE_ID);
    {$ELSE}
    kpKeygenParams.bSetHardwareLock := False;
    {$ENDIF}

    // encrypt user name and custom key fields with hardware id
    kpKeygenParams.bSetHardwareEncryption := False;

    //////////////////////////////////////////////////////////////////////
    // custom key integers (eg. you can store purchase id etc.)
    //////////////////////////////////////////////////////////////////////

    kpKeygenParams.bSetKeyIntegers := True;

    kpKeygenParams.dwKeyIntegers[0] := StrToInt(QUANTITY);
    kpKeygenParams.dwKeyIntegers[1] := StrToInt(PURCHASE_ID);
    kpKeygenParams.dwKeyIntegers[2] := 0;
    kpKeygenParams.dwKeyIntegers[3] := 0;
    kpKeygenParams.dwKeyIntegers[4] := 0;
    kpKeygenParams.dwKeyIntegers[5] := 0;
    kpKeygenParams.dwKeyIntegers[6] := 0;
    kpKeygenParams.dwKeyIntegers[7] := 0;
    kpKeygenParams.dwKeyIntegers[8] := 0
    kpKeygenParams.dwKeyIntegers[9] := 0
    kpKeygenParams.dwKeyIntegers[10] := 0;
    kpKeygenParams.dwKeyIntegers[11] := 0;
    kpKeygenParams.dwKeyIntegers[12] := 0;
    kpKeygenParams.dwKeyIntegers[13] := 0;
    kpKeygenParams.dwKeyIntegers[14] := 0;
    kpKeygenParams.dwKeyIntegers[15] := 0;


    //////////////////////////////////////////////////////////////////////
    // store key creation date in the key (purchase date or current date)
    //////////////////////////////////////////////////////////////////////

    {$IFDEF CREATION_DATE}
    // system time from server
    // GetSystemTime(KeyCreationDate);

    KeyCreationDate.wDay := StrToInt(Copy(PURCHASE_DATE, 1, 2));
    KeyCreationDate.wMonth := StrToInt(Copy(PURCHASE_DATE, 4, 2));
    KeyCreationDate.wYear := StrToInt(Copy(PURCHASE_DATE, 7, 4));

    kpKeygenParams.bSetKeyCreationDate := True;
    kpKeygenParams.stKeyCreation := KeyCreationDate;
    {$ELSE}
    kpKeygenParams.bSetKeyCreationDate := False;
    {$ENDIF}

    //////////////////////////////////////////////////////////////////////
    // set key expiration date
    //////////////////////////////////////////////////////////////////////

    kpKeygenParams.bSetKeyExpirationDate := False;
    kpKeygenParams.stKeyExpiration := KeyExpirationDate;

    //////////////////////////////////////////////////////////////////////
    // additional key data (features/encrypted sections)
    //////////////////////////////////////////////////////////////////////

    kpKeygenParams.bSetFeatureBits := False;

    // eg. enable encrypted sections for Company License
    // if (StrToInt(PRODUCT_ID)) = 12345 then
    // begin
    //   kpKeygenParams.bSetFeatureBits := True;
    //   kpKeygenParams.dwFeatures.dwKeyData1 := $FF;
    // end;
    kpKeygenParams.dwFeatures.dwKeyData1 := 0;
    kpKeygenParams.dwFeatures.dwKeyData2 := 0;
    kpKeygenParams.dwFeatures.dwKeyData3 := 0;
    kpKeygenParams.dwFeatures.dwKeyData4 := 0;

    //////////////////////////////////////////////////////////////////////
    // generate key data
    //////////////////////////////////////////////////////////////////////

    Status := Keygen(kpKeygenParams);

    // check returned value
    case Status of

      // license data successfully generated
      KEYGEN_SUCCESS:
      begin

        SetLength(KeyData, KeyDataSize);
        CopyMemory(PChar(KeyData), @KeyDataArray[0], KeyDataSize);

        KeyMIMEType := 'application/octet-stream';

        // file name
        {$IFDEF REG_DUMP_FORMAT}
        KeyDisplayFileName := 'key.reg';
        {$ELSE}
        KeyDisplayFileName := 'key.lic';
        {$ENDIF}

        Result := ERC_SUCCESS_BIN;

      end;

      // invalid input params (or missing params)
      KEYGEN_INVALID_PARAMS: Result := ERC_BAD_INPUT;

      // invalid project file
      KEYGEN_INVALID_PROJECT: Result := ERC_INTERNAL;

      // out of memory in Keygen() procedure
      KEYGEN_OUT_MEMORY: Result := ERC_MEMORY;

      // data generation error
      KEYGEN_DATA_ERROR: Result := ERC_INTERNAL;

      // unknown errors
      else

      Result := ERC_ERROR;

      end; // case

end;

end.
