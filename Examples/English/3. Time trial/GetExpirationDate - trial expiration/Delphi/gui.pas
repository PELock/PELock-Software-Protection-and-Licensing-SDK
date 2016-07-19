////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read trial info (expiration date)
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
    lblTrialInfo: TLabel;
    edtDate: TEdit;
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
var
  lpExpirationDate: TSystemTime;
begin

  // check time trial status
  case GetExpirationDate(lpExpirationDate) of

  //
  // time trial active
  //
  PELOCK_TRIAL_ACTIVE :
  begin
    lblTrialInfo.Caption := 'This application will expire on';
    edtDate.Text := Format('%d/%d/%d', [lpExpirationDate.wDay, lpExpirationDate.wMonth, lpExpirationDate.wYear]);
  end;

  //
  // time trial expired, this error code is returned only when
  // "Allow application to expire" option is enabled, so you can
  // handle application expiration your own way
  //
  PELOCK_TRIAL_EXPIRED: lblTrialInfo.Caption := 'Application expired, please order full version!';

  //
  // all other error codes (including PELOCK_TRIAL_ABSENT)
  //
  else
    lblTrialInfo.Caption := 'No time trial limits';
  end;

end;

end.
