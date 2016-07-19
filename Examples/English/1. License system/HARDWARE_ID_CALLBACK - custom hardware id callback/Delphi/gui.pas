////////////////////////////////////////////////////////////////////////////////
//
// Example of how to set custom hardware id callback routine
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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, PELock;

type
  TfrmMain = class(TForm)
    btnExit: TButton;
    lblInfo: TLabel;
    Label1: TLabel;
    edtHardwareId: TEdit;
    Label2: TLabel;
    procedure btnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

procedure SaveOptions;
begin

  {$I DEMO_START.INC}
  // DO1;
  // DO2;
  // DO3;
  {$I DEMO_END.INC}

end;

//
// custom hardware id callback
//
// return values:
//
// True  - hardware identifier successfully generated
// False - an error occured, for example when dongle key was
//         not present), please note that any further calls to
//         GetHardwareId() or functions to set/reload
//         registration key locked to hardware id will fail
//         in this case (error codes will be returned)
//
function CustomHardwareId(var lpcHardwareId: THardwareId): Boolean; stdcall;
var
  i: integer;
begin

  //
  // copy custom hardware identifier to output buffer (8 bytes)
  //
  // you can create custom hardware identifier from:
  //
  // - dongle (hardware key) hardware identifier
  // - operating system information
  // - etc.
  //
  for i := 0 to 7 do
  begin

    lpcHardwareId[i] := Chr(i + 1);

  end;

  // return True (1) to indicate success
  Result := True;

end;


procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  frmMain.Close;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  UserName: string;
begin

  // code responsible for getting name of registered user should be placed
  // between DEMO_START and DEMO_END markers
  {$I DEMO_START.INC}

  // get registered user name, to do that function WinApi GetWindowText
  // is called with parameter HWND set to -1
  UserName := GetRegistrationName;

  // display registered user name, or leave UNREGISTERED VERSION text
  lblInfo.Caption := UserName;

  {$I DEMO_END.INC}

  // check if anything was copied to the buffer
  // if not set to default
  if Length(UserName) = 0 then
  begin

    lblInfo.Caption := 'UNREGISTERED VERSION';

    // read hardware id value
    edtHardwareId.Text := GetHardwareId;

  end;

end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  bRegisteredCodeDone: Boolean;
begin

  bRegisteredCodeDone := False;

  {$I DEMO_START.INC}

  // do things that arent available without license key, eg. saving
  // configuration etc.
  if bRegisteredCodeDone = False then
  begin

    SaveOptions;
    // MakeBackup;
    // Do1;
    // Do2;
    // Do3;

    // set a flag, but keep in mind, that using registration
    // flag isnt safe, it can be easily cracked, you should put between
    // DEMO_START and DEMO_END markers as much code as you can, so it would
    // be impossible to recover it without valid license key
    bRegisteredCodeDone := True;

  end;

  {$I DEMO_END.INC}

  // display demo nagscreen
  if bRegisteredCodeDone = False then
  begin
    MessageDlg('Please register!', mtInformation, [mbOk], 0);
  end;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  // set our own hardware id callback routine (you need to enable
  // proper option in SDK tab)
  SetHardwareIdCallback(@CustomHardwareId);

  // reload registration key (from default locations)
  ReloadRegistrationKey;
  
end;

end.
