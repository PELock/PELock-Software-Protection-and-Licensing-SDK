////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read license key status information
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
  StdCtrls, PELock, ExtCtrls;

type
  TfrmMain = class(TForm)
    Button1: TButton;
    Panel1: TPanel;
    lblKeyInfo: TLabel;
    procedure Button1Click(Sender: TObject);
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

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  frmMain.Close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  // read license key status information
  case GetKeyStatus of

  //
  // key is valid (so the code between DEMO_START and DEMO_END should be executed)
  //
  PELOCK_KEY_OK:
  begin

    {$I DEMO_START.INC}

    lblKeyInfo.Caption := 'License key is valid.';

    {$I DEMO_END.INC}

  end;

  //
  // invalid format of the key (corrupted)
  //
  PELOCK_KEY_INVALID: lblKeyInfo.Caption := 'License key is invalid (corrupted)!';

  //
  // license key was on the blocked keys list (stolen)
  //
  PELOCK_KEY_STOLEN: lblKeyInfo.Caption := 'License key is blocked!';

  //
  // hardware identifier is different from the one used to encrypt license key
  //
  PELOCK_KEY_WRONG_HWID: lblKeyInfo.Caption := 'Hardware identifier doesn't match to the license key!';

  //
  // license key is expired (not active)
  //
  PELOCK_KEY_EXPIRED: lblKeyInfo.Caption := 'License key is expired!';

  //
  // license key not found
  //
  else
    lblKeyInfo.Caption := 'License key not found.';
  end;

end;

end.
