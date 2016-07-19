////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use PELOCK_INIT_CALLBACK macros
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
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

  dwSecretValue1, dwSecretValue2: integer;

implementation

{$R *.dfm}

//
// initialization callbacks are called only once before application
// start, it can be used to initialize sensitive variables, it is
// called only for the protected applications, so if the protection
// gets removed those functions won't be called (extra protection
// against code unpacking)
//
// those function has to be used somewhere in the code, so it won't
// be removed by the compiler optimizations (which in most cases
// removes unused and unreferenced functions), you can use a simple
// trick to protect against it, check the function pointer anywhere
// in the code eg.:
//
// if ((&pelock_initalization_callback_1 == NULL) return 0;
//
// also keep in mind that those functions are called before
// application initialization code, so if your application
// depends on some libraries (either static or dynamic), make
// sure to keep this code simple without any references to those
// libraries and their functions
//
procedure pelock_initalization_callback_1(hInstance: HINST; dwReserved: DWORD);
begin

  // initialization callback marker
  {$I PELOCK_INIT_CALLBACK.INC}

  // initialization callbacks are called only once, so
  // it's safe to erase its code after execution
  {$I CLEAR_START.INC}

  dwSecretValue1 := 2;

  {$I CLEAR_END.INC}

end;

//
// second callback, you can place as many callbacks as you want
//
procedure pelock_initalization_callback_2(hInstance: HINST; dwReserved: DWORD);
begin

  // initialization callback marker
  {$I PELOCK_INIT_CALLBACK.INC}

  // initialization callbacks are called only once, so
  // it's safe to erase its code after execution
  {$I CLEAR_START.INC}

  dwSecretValue2 := 2;

  {$I CLEAR_END.INC}

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  // make use of the dwSecretValue1 and dwSecretValue2
  // both values were initialized in PELOCK_INIT_CALLBACK
  // marked procedures
  lblInfo.Caption := '2 + 2 equals ' + IntToStr(dwSecretValue1 + dwSecretValue2);

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin

  // protection against compiler optimizations
  if ( (@pelock_initalization_callback_1 = nil) or (@pelock_initalization_callback_2 = nil) ) then
  begin
    Exit;
  end;

end;

end.
