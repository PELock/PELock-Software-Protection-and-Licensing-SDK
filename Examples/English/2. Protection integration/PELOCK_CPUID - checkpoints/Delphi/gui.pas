////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use PELOCK_CPUID macros
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

  dwIntegerValue: integer;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  dwIntegerValue := 2;

  //
  // PELOCK_CPUID usage notes:
  //
  // these protection checks doesn't affect your application
  // in any way, but when someone will try to run cracked or
  // unpacked application, PELOCK_CPUID code will cause an
  // exception, so the cracked/unpacked application won't
  // work correctly
  //
  // example of how to catch an exception caused by
  // cracked/unpacked application
  //
  try
    {$I PELOCK_CPUID.INC}
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
      dwIntegerValue := 100;
    end;
  end;

  // make use of the dwIntegerValue
  lblInfo.Caption := '1 + 1 equals ' + IntToStr(dwIntegerValue);

end;

end.
