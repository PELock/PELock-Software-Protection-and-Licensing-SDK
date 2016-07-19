////////////////////////////////////////////////////////////////////////////////
//
// Example of how to check PELock protection presence
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
    GroupBox1: TGroupBox;
    chkPELockPresent1: TCheckBox;
    chkPELockPresent2: TCheckBox;
    chkPELockPresent3: TCheckBox;
    chkPELockPresent4: TCheckBox;
    chkPELockPresent5: TCheckBox;
    chkPELockPresent6: TCheckBox;
    chkPELockPresent7: TCheckBox;
    chkPELockPresent8: TCheckBox;
    HiddenTimer: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HiddenTimerTimer(Sender: TObject);
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

  //
  // mark checkboxes when pelock is detected
  //
  // if you protect your application, these procedures
  // ALWAYS returns True, otherwise it would mean that
  // the executable has been unpacked/cracked
  // and you you can (should :) do one of the following
  // things:
  //
  // - close your application (when it's not expected,
  //   use timer procedure)
  // - damage some memory area
  // - initialize variables with wrong values
  // - invoke exception (RaiseException())
  // - make an error in calculations (that's really hard to
  //   trace for an avarage cracker/reverser, and so it's
  //   harder to fully crack/rebuild your application)
  //
  // use your imagination :)
  //
  chkPELockPresent1.Checked := IsPELockPresent1;
  chkPELockPresent2.Checked := IsPELockPresent2;
  chkPELockPresent3.Checked := IsPELockPresent3;
  chkPELockPresent4.Checked := IsPELockPresent4;
  chkPELockPresent5.Checked := IsPELockPresent5;
  chkPELockPresent6.Checked := IsPELockPresent6;
  chkPELockPresent7.Checked := IsPELockPresent7;
  chkPELockPresent8.Checked := IsPELockPresent8;

  //
  // pelock protection not detected, something's
  // wrong, close application
  //

  //{$DEFINE FINAL_RELEASE}
  {$IFDEF FINAL_RELEASE}
  if IsPELockPresent1 = False then Halt;
  {$ENDIF}

  //
  // pelock protection not detected, start hidden
  // timer that will close an application after
  // 15 seconds
  //
  {$IFDEF FINAL_RELEASE}
  if IsPELockPresent4 = False then HiddenTimer.Enabled := True;
  {$ENDIF}

end;

procedure TfrmMain.HiddenTimerTimer(Sender: TObject);
begin

  //
  // pelock not detected, quit, but for example you can
  // disable some control on the main form (eg. menu items)
  //
  frmMain.Enabled := False;
  frmMain.Close;
end;

end.
