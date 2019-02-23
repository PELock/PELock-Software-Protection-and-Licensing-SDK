////////////////////////////////////////////////////////////////////////////////
//
// Example of how to check if the key is locked to the hardware identifier
//
// Version        : PELock v2.09
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

  {$I DEMO_START.INC}

  // is the key locked to the hardware identifier
  if IsKeyHardwareIdLocked == True then
    lblKeyInfo.Caption := 'This key is locked to the hardware identifier!'
  else
    lblKeyInfo.Caption := 'This key is NOT locked to the hardware identifier!';

  {$I DEMO_END.INC}

end;

end.
