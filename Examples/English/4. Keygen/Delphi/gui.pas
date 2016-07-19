////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use KEYGEN.dll to generate license keys
//
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
unit gui;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TfrmMain = class(TForm)
    edtUserName: TEdit;
    lblUserName: TLabel;
    edtHardwareId: TEdit;
    lblHardwareId: TLabel;
    edtAdditionalKeyData1: TEdit;
    lblAdditionalKeyData: TLabel;
    TimePicker: TDateTimePicker;
    edtAdditionalKeyData2: TEdit;
    edtAdditionalKeyData3: TEdit;
    edtAdditionalKeyData4: TEdit;
    lblKeyExpiration: TLabel;
    OpenProject: TOpenDialog;
    btnGenerate: TButton;
    SaveLicenseKey: TSaveDialog;
    chkKeyExpirationDate: TCheckBox;
    GroupBox1: TGroupBox;
    chkUpdateProject: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure chkKeyExpirationDateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

{ KEYGEN.dll prototypes }
{$I KEYGEN.INC}

implementation

{$R *.DFM}


procedure TfrmMain.FormShow(Sender: TObject);
begin

  // set title
  OpenProject.Title := 'Open Project File';
  OpenProject.InitialDir := ExtractFilePath(ParamStr(0));

  // read project file path
  if OpenProject.Execute <> true then frmMain.Close;

end;

procedure TfrmMain.btnGenerateClick(Sender: TObject);
var
    KeyData           : array[0..PELOCK_SAFE_KEY_SIZE] of byte;   // output buffer for key data
    KeyDataSize       : DWORD;                    // key data size
    KeyCreationDate   : TSystemTime;              // key creation date
    KeyExpirationDate : TSystemTime;              // key expiration date
    KeyFile           : file of byte;             // key file handle
    kpKeygenParams    : TKeygenParams;            // keygen params structure
    Status            : DWORD;                    // return value from Keygen()

begin

    //////////////////////////////////////////////////////////////////////
    // output buffer settings
    //////////////////////////////////////////////////////////////////////

    // buffer for the key data (array of bytes)
    kpKeygenParams.lpOutputBuffer := @KeyData[0];

    // pointer to the DWORD where key size will be stored
    kpKeygenParams.lpdwOutputSize := @KeyDataSize;

    //////////////////////////////////////////////////////////////////////
    // project path, flag to update project
    //////////////////////////////////////////////////////////////////////

    kpKeygenParams.lpProjectPtr.lpszProjectPath := PChar(OpenProject.FileName);

    // are we using text buffer with project file contents (instead of project file)?
    kpKeygenParams.bProjectBuffer := FALSE;

    kpKeygenParams.bUpdateProject := chkUpdateProject.Checked;
    kpKeygenParams.lpbProjectUpdated := nil;

    //////////////////////////////////////////////////////////////////////
    // output key format
    // KEY_FORMAT_BIN - binary key
    // KEY_FORMAT_REG - Windows registry key dump
    // KEY_FORMAT_TXT - text key (in MIME Base64 format)
    //////////////////////////////////////////////////////////////////////

    kpKeygenParams.dwOutputFormat := KEY_FORMAT_BIN;

    //////////////////////////////////////////////////////////////////////
    // username
    //////////////////////////////////////////////////////////////////////

    kpKeygenParams.lpUsernamePtr.lpszUsername := PChar(Trim(edtUserName.Text));
    kpKeygenParams.dwUsernameSize.dwUsernameLength := Length(Trim(edtUserName.Text));

    //////////////////////////////////////////////////////////////////////
    // hardware identifier
    //////////////////////////////////////////////////////////////////////

    if (Length(Trim(edtHardwareId.Text))) <> 0 then
    begin
      kpKeygenParams.bSetHardwareLock := True;
      kpKeygenParams.lpszHardwareId := PChar(Trim(edtHardwareId.Text));
    end
    else
    begin
      kpKeygenParams.bSetHardwareLock := False;
    end;

    // encrypt user name and custom key fields with hardware id
    kpKeygenParams.bSetHardwareEncryption := False;

    //////////////////////////////////////////////////////////////////////
    // custom key integers
    //////////////////////////////////////////////////////////////////////

    kpKeygenParams.bSetKeyIntegers := True;

    kpKeygenParams.dwKeyIntegers[0] := 1;
    kpKeygenParams.dwKeyIntegers[1] := 2;
    kpKeygenParams.dwKeyIntegers[2] := 3;
    kpKeygenParams.dwKeyIntegers[3] := 4;
    kpKeygenParams.dwKeyIntegers[4] := 5;
    kpKeygenParams.dwKeyIntegers[5] := 6;
    kpKeygenParams.dwKeyIntegers[6] := 7;
    kpKeygenParams.dwKeyIntegers[7] := 8;
    kpKeygenParams.dwKeyIntegers[8] := 9;
    kpKeygenParams.dwKeyIntegers[9] := 10;
    kpKeygenParams.dwKeyIntegers[10] := 11;
    kpKeygenParams.dwKeyIntegers[11] := 12;
    kpKeygenParams.dwKeyIntegers[12] := 13;
    kpKeygenParams.dwKeyIntegers[13] := 14;
    kpKeygenParams.dwKeyIntegers[14] := 15;
    kpKeygenParams.dwKeyIntegers[15] := 16;

    //////////////////////////////////////////////////////////////////////
    // store key creation date in the key
    //////////////////////////////////////////////////////////////////////

    GetSystemTime(KeyCreationDate);
    kpKeygenParams.bSetKeyCreationDate := True;
    kpKeygenParams.stKeyCreation := KeyCreationDate;

    //////////////////////////////////////////////////////////////////////
    // check if key expiration option is enabled
    //////////////////////////////////////////////////////////////////////

    if chkKeyExpirationDate.Checked then
    begin
      kpKeygenParams.bSetKeyExpirationDate := True;

      // read key expiration date
      DateTimeToSystemTime(TimePicker.DateTime, KeyExpirationDate);

      kpKeygenParams.stKeyExpiration := KeyExpirationDate;
    end
    else
    begin
      kpKeygenParams.bSetKeyExpirationDate := False;
    end;

    //////////////////////////////////////////////////////////////////////
    // additional key data (features)
    //////////////////////////////////////////////////////////////////////

    kpKeygenParams.bSetFeatureBits := True;

    kpKeygenParams.dwFeatures.dwKeyData1 := StrToInt(edtAdditionalKeyData1.Text);
    kpKeygenParams.dwFeatures.dwKeyData2 := StrToInt(edtAdditionalKeyData2.Text);
    kpKeygenParams.dwFeatures.dwKeyData3 := StrToInt(edtAdditionalKeyData3.Text);
    kpKeygenParams.dwFeatures.dwKeyData4 := StrToInt(edtAdditionalKeyData4.Text);


    SaveLicenseKey.InitialDir := ExtractFilePath(ParamStr(0));
    SaveLicenseKey.Title := 'Save license key as...';

    // set default name for key file
    SaveLicenseKey.FileName := 'key.lic';

    // show save dialog
    if SaveLicenseKey.Execute then
    begin

      // generate key data
      Status := Keygen(kpKeygenParams);

      // check returned value
      case Status of

      //
      // license data successfully generated
      //
      KEYGEN_SUCCESS:
      begin

        // create new license key file
        AssignFile(KeyFile, SaveLicenseKey.FileName);
        Rewrite(KeyFile);

        // write key data
        BlockWrite(KeyFile, KeyData, KeyDataSize);

        // close file
        CloseFile(KeyFile);

        MessageBox(frmMain.Handle, PChar('Key file successfully generated!'), PChar('OK'), MB_ICONINFORMATION);
      end;

      // invalid input params (or missing params)
      KEYGEN_INVALID_PARAMS:

        MessageBox(frmMain.Handle, PChar('Invalid input params (check TKeygenParams structure)!'), PChar('Error!'), MB_ICONEXCLAMATION);

      // invalid project file
      KEYGEN_INVALID_PROJECT:

        MessageBox(frmMain.Handle, PChar('Invalid project file, please check it, maybe its missing some data!'), PChar('Error!'), MB_ICONEXCLAMATION);

      // out of memory in Keygen() procedure
      KEYGEN_OUT_MEMORY:

        MessageBox(frmMain.Handle, PChar('Out of memory!'), PChar('Error!'), MB_ICONEXCLAMATION);

      // data generation error
      KEYGEN_DATA_ERROR:

        MessageBox(frmMain.Handle, PChar('Error while generating license key data, please contact with author!'), PChar('Error!'), MB_ICONEXCLAMATION);

      // unknown errors
      else

        MessageBox(frmMain.Handle, PChar('Unknown error, please contact with author!'), PChar('Error!'), MB_ICONEXCLAMATION);

      end; // case

    end;

end;

procedure TfrmMain.chkKeyExpirationDateClick(Sender: TObject);
begin
  TimePicker.Enabled := chkKeyExpirationDate.Checked;
end;

end.
