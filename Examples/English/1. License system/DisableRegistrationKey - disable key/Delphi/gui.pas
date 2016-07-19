////////////////////////////////////////////////////////////////////////////////
//
// Example of how to disable registration key at runtime
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
    Button1: TButton;
    lblInfo: TLabel;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
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


procedure TfrmMain.Button1Click(Sender: TObject);
begin

  frmMain.Close;

end;

procedure TfrmMain.FormShow(Sender: TObject);
begin

  // disable registration key (and do not allow to set a new key)
  DisableRegistrationKey(True);

  // code responsible for getting registered username should be placed
  // between DEMO_START and DEMO_END markers
  {$I DEMO_START.INC}

  // get registered user name
  lblInfo.Caption := GetRegistrationName;

  // closing marker
  {$I DEMO_END.INC}

  // check if anything was copied to the buffer
  // if not set to default
  if lblInfo.Caption = '' then lblInfo.Caption := 'UNREGISTERED VERSION';

end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var bRegisteredCodeDone: Boolean;
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
    // flags isn't safe, it can be easily cracked, you should put between
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

end.
