////////////////////////////////////////////////////////////////////////////////
//
// Setting license key from external file (placed, somewhere else than
// protected application directory)
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

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  frmMain.Close;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin

  // if the license key was not set automatically
  // SetRegistrationKey will set a key using custom path
  SetRegistrationKey('a:\key.lic');

  // code responsible for getting name of registered user should be placed
  // between DEMO_START and DEMO_END markers
  {$I DEMO_START.INC}

  // get registered user name
  lblInfo.Caption := GetRegistrationName;

  {$I DEMO_END.INC}

  // check if anything was copied to the buffer
  // if not set to default
  if lblInfo.Caption = '' then lblInfo.Caption := 'UNREGISTERED VERSION';

end;

end.
