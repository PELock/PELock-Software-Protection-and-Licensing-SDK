////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use DEMO_START and DEMO_END macros
//
// Version        : PELock v2.0
// Language       : Lazarus/Freepascal
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

// enable Intel assembler syntax
{$ASMMODE INTEL}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, PELock;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnClose: TButton;
    edtHardwareId: TEdit;
    grpAbout: TGroupBox;
    grpRegisteredTo: TGroupBox;
    grpHardwareId: TGroupBox;
    lblApplication: TLabel;
    lblRegisteredName: TLabel;
    tmrSpecialEffect: TTimer;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrSpecialEffectTimer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmMain: TfrmMain;

  dwMinColor, dwMaxColor: integer;
  bMakeBrighter: boolean;

implementation

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  //
  // font manipulation setup
  //
  {$I CRYPT_START.INC}

  bMakeBrighter := True;
  dwMinColor := lblApplication.Font.Color;
  dwMaxColor := dwMinColor + $00505050;

  {$I CRYPT_END.INC}

  //
  // read registration name (code between encryption markers
  // will be executed ONLY with a valid license key)
  //
  if IsPELockPresent1 = True then
  begin

    {$I DEMO_START.INC}

    lblRegisteredName.Caption := GetRegistrationName;

    {$I DEMO_END.INC}

  end;

  //
  // check key validity
  //
  if GetKeyStatus <> PELOCK_KEY_OK then
  begin

    {$I UNREGISTERED_START.INC}

    lblRegisteredName.Caption := 'Unregistered version!';

    {$I UNREGISTERED_END.INC}

  end;

  //
  // display hardware identifier
  //
  edtHardwareId.Text := GetHardwareId;


end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin

  // close main form
  frmMain.Close;

end;

procedure TfrmMain.tmrSpecialEffectTimer(Sender: TObject);
begin

  //
  // PELOCK_CHECKPOINT usage notes:
  //
  // these protection checks doesn't affect your application
  // in any way, but when someone will try to run cracked or
  // unpacked application, PELOCK_CHECKPOINT code will cause an
  // exception, so the cracked/unpacked application won't
  // work correctly
  //
  // example of how to catch an exception caused by
  // cracked/unpacked application
  //
  try
    {$I PELOCK_CHECKPOINT.INC}
  except

    //
    // exception occurred, protection removed!!!
    // don't just stand up, do something evil :)
    //
    on Exception do
    begin

      //
      // for example you can:
      // - silently corrupt values used in calculations
      // - disable some controls, menu items
      // - fill some important arrays with random bytes
      // - delete important application file(s)
      //
      // IMPORTANT !!!
      // DON'T DISPLAY ANY WARNING MESSAGES, BECAUSE IT
      // WILL HELP CRACKERS TO LOCATE AND REMOVE
      // THESE CHECKS
      //
      btnClose.Visible := False;
    end;
  end;

  if (bMakeBrighter = True) then
  begin

    lblApplication.Font.Color := lblApplication.Font.Color + $00010101;

    if lblApplication.Font.Color = dwMaxColor then bMakeBrighter := False;

  end
  else
  begin

    lblApplication.Font.Color := lblApplication.Font.Color - $00010101;

    if lblApplication.Font.Color = dwMinColor then bMakeBrighter := True;

  end;

end;

initialization
  {$I gui.lrs}

end.

