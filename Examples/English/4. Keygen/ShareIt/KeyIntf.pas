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

unit KeyIntf;

// save ShareIt binary key
{$DEFINE BINARY_GEN}

interface

uses
  Windows, SysUtils, Classes;

const // error result codes supported by element 5
  ERC_SUCCESS   = 0;
  ERC_SUCCESS_BIN = 1;
  ERC_ERROR     = 10;
  ERC_MEMORY    = 11;
  ERC_FILE_IO   = 12;
  ERC_BAD_ARGS  = 13;
  ERC_BAD_INPUT = 14;
  ERC_EXPIRED   = 15;
  ERC_INTERNAL  = 16;

type
  EKeyException = class(Exception)
    fERC: integer;
  public
    constructor Create(const Msg: string; erc: integer);
    property ERC: integer Read fERC;
  end;

  TAbstractKeyGen = class(TObject)
  private
    fInputList: TStrings; // holds input parameters
    fUtf8: boolean;       // input is UTF8 encoded

  protected
{$IFDEF BINARY_GEN}
    KeyMIMEType: AnsiString; // the MIME type
    KeyDisplayFileName: AnsiString; // the displayed filename
    KeyData: AnsiString; // the actual key data
{$ELSE}
    UserKey, CCKey: WideString;
{$ENDIF}

    function Value(key: string): string;
    function WideValue(const key: string): WideString;
    procedure WriteFile(filename, Value: string);
    procedure Execute;
    procedure Main;

    // override these to implement your key generator
    function GetTitle: string; virtual; abstract;
    function GenerateKey: integer; virtual; abstract;
  public
    constructor Create;
    destructor Destroy; override;

    class procedure Run;
  end;

implementation


{ EKeyException }

constructor EKeyException.Create(const Msg: string; erc: integer);
begin
  inherited Create(Msg);

  fERC := erc;
end;

{ TAbstractKeyGen }


constructor TAbstractKeyGen.Create;
begin
  fInputList := TStringList.Create;
end;

destructor TAbstractKeyGen.Destroy;
begin
  fInputList.Free;

  inherited;
end;

// use this function to get the value of input parameters
function TAbstractKeyGen.Value(key: string): string;
begin
  try
    Result := Trim(fInputList.Values[key]);
  except
    Result := '';
  end;
end;

// use this function to get the value of input parameters as widestring
function TAbstractKeyGen.WideValue(const key: string): WideString;
begin
  if fUTF8 then
    Result := UTF8Decode(Value(Key))
  else
    Result := Value(Key);
end;

// write a string to a file
procedure TAbstractKeyGen.WriteFile(filename, Value: string);
var
  fout: TextFile;
begin
  if (filename = '') or (Value = '') then
    exit; // happens only when writing exception file

  // write output data
  AssignFile(fout, filename);
{$I-}
  Rewrite(fout);
  Write(fout, Value);
  CloseFile(fout);
{$I+}
  if IOResult <> 0 then
    raise EKeyException.Create('i/o error on write', ERC_FILE_IO);
end;

// execute function ** DO NOT CHANGE **
procedure TAbstractKeyGen.Execute;
begin
  // check parameter count
  if (ParamCount <> 3) then
    raise EKeyException.Create('bad args: ' + IntToStr(ParamCount), ERC_BAD_INPUT);

  // see if input file supplied
  if not FileExists(ParamStr(1)) then
    raise EKeyException.Create('file not found: ' + ParamStr(1), ERC_FILE_IO);

  // load input values
  fInputList.LoadFromFile(ParamStr(1));

  // detect UTF8 input encoding
  fUTF8 := (Value('ENCODING') = 'UTF8');

  ExitCode := GenerateKey; // call key generator implementation

  // write output if successful
{$IFDEF BINARY_GEN}
  if ExitCode <> ERC_SUCCESS_BIN then
    raise EKeyException.Create('generation failed', ERC_INTERNAL);

  WriteFile(ParamStr(2), KeyMIMEType + ':' + KeyDisplayFileName);
  WriteFile(ParamStr(3), KeyData);
{$ELSE}
  if ExitCode <> ERC_SUCCESS then
    raise EKeyException.Create('generation failed', ERC_INTERNAL);

  if fUTF8 then
  begin
    WriteFile(ParamStr(2), UTF8Encode(UserKey));
    WriteFile(ParamStr(3), UTF8Encode(CCKey));
  end
  else
  begin
    WriteFile(ParamStr(2), UserKey);
    WriteFile(ParamStr(3), CCKey);
  end;
{$ENDIF}
end;

// main function ** DO NOT CHANGE **
procedure TAbstractKeyGen.Main;
begin
  try
    Execute;

  except
    on E: Exception do
    begin
      if E is EKeyException then
        ExitCode := EKeyException(E).ERC // set ERC fro Exception object
      else if ExitCode < ERC_ERROR then
        ExitCode := ERC_INTERNAL; // don't return SUCCESS on Exceptions

      WriteLn(E.Message);

      try // to write error to first output file
        WriteFile(ParamStr(2), 'ERROR: ' + E.Message);
      except // print to console
        on E: Exception do
          WriteLn(E.Message);
      end;
    end;
  end;
end;

class procedure TAbstractKeyGen.Run;
begin
  with self.Create do
    try
      Main;
    finally
      Free;
    end;
end;


end.

