////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use time trial callback procedure
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
  Dialogs, ExtCtrls;

type
  TfrmMain = class(TForm)
    lblInfo: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure lblInfoUnDock(Sender: TObject; Client: TControl;
      NewTarget: TWinControl; var Allow: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

//
// this procedure will be called after time trial expiration
//
// WARNING! This procedure need to be called from some bogus code
// otherwise Delphi will remove it from the code (code optimization)
//
function Expired():integer;
begin
{$I TRIAL_EXPIRED.INC}

  frmMain.lblInfo.Caption := 'Expired! Please buy full version';

  MessageDlg('Please buy full version!', mtInformation, [mbOk], 0);

  // if the callback function is called, Close procedure doesn't work!
  // frmMain.Close;

  // return 1 to close application, 0 to let it run
  result := 1;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin

// code between encryption markers is encrypted during process
// of file protection and when protected file is executed,
// code is being decrypted. When decrypted code is finally executed
// it is erased from the memory
// put CLEAR_START and CLEAR_END markers in code fragments that are
// executed only once during program session (eg. FormCreate for Delphi)
{$I CLEAR_START.INC}

lblInfo.Caption := 'This application is time limited!';

{$I CLEAR_END.INC}

end;

procedure TfrmMain.lblInfoUnDock(Sender: TObject; Client: TControl;
  NewTarget: TWinControl; var Allow: Boolean);
begin
// bogus call
Expired;
end;

end.
