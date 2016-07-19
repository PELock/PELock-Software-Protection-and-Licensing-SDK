////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use PELock's protected constants
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
  x: integer;
begin

  //
  // you can use PELOCK_DWORD wherever you want, to initialize
  // integer variables, with a WinApi calls, as a loop counters,
  // in calculations etc.
  //
  frmMain.Height := PELOCK_DWORD(200);
  frmMain.Width := PELOCK_DWORD(300);

  x := -5 + PELOCK_DWORD(105) xor PELOCK_DWORD(100);

  lblInfo.Caption := 'Protected constant 5 = ' + IntToStr( PELOCK_DWORD(5) + x );
end;

end.
