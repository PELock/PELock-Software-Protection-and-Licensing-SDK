////////////////////////////////////////////////////////////////////////////////
//
// Setting license key from the memory buffer
//
// Version        : PELock v2.0
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
unit gui;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, PELock;

type
  TfrmMain = class(TForm)
    lblInfo: TLabel;
    btnExit: TBitBtn;
    edtUsername: TMemo;
    procedure btnExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnExitClick(Sender: TObject);
begin

  // exit application
  frmMain.Close;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  KeyFile: TFileStream;
  KeyBuffer: PByteArray;
  UserName: string;
begin

  try

  // open file
  KeyFile := TFileStream.Create('c:\key.lic', fmOpenRead);

  // check file size
  if KeyFile.Size <> 0 then
  begin

    // allocate memory for key data
    GetMem(KeyBuffer, KeyFile.Size);

    // read data buffer
    KeyFile.Read(KeyBuffer^, KeyFile.Size);

    // set registration data from the keyfile
    SetRegistrationData(KeyBuffer, KeyFile.Size);

    // release memory
    FreeMem(KeyBuffer);

  end;

  // close file
  KeyFile.Free;

  except;
  end;

  // if there's a valid key stored in the windows registry, or
  // that one from the C:\key.lic path is valid too, code between
  // demo markers will be executed, and so registered user name
  // will be read into username buffer
  {$I DEMO_START.INC}

  // read registration name
  UserName := GetRegistrationName;

  // set new registration name
  edtUsername.Text := UserName;

  {$I DEMO_END.INC}

end;

end.
