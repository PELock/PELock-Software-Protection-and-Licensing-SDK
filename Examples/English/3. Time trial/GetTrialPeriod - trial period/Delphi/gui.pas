////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read trial info (trial period)
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
    edtStart: TEdit;
    edtEnd: TEdit;
    Label1: TLabel;
    Label2: TLabel;
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
  lpStartDate: TSystemTime;
  lpEndDate  : TSystemTime;
begin

  // check time trial status
  case GetTrialPeriod(lpStartDate, lpEndDate) of

  //
  // time trial active
  //
  PELOCK_TRIAL_ACTIVE :
  begin
    lblTrialInfo.Caption := 'Trial period for this application';
    edtStart.Text := Format('%d/%d/%d', [lpStartDate.wDay, lpStartDate.wMonth, lpStartDate.wYear]);
    edtEnd.Text := Format('%d/%d/%d', [lpEndDate.wDay, lpEndDate.wMonth, lpEndDate.wYear]);
  end;

  //
  // all other error codes (including PELOCK_TRIAL_ABSENT)
  //
  else
    lblTrialInfo.Caption := 'No time trial limits';
  end;

end;

end.
