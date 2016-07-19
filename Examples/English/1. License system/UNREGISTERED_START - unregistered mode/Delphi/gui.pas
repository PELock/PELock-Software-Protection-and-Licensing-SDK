////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use UNREGISTERED_START and UNREGISTERED_END macros
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
  StdCtrls;

type
  TfrmMain = class(TForm)
    lblInfo: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

procedure SaveOptions;
begin

  {$I DEMO_START.INC}
  // DO1;
  // DO2;
  // DO3;
  {$I DEMO_END.INC}

end;


procedure TfrmMain.Button1Click(Sender: TObject);
begin
  frmMain.Close;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin

  {$I DEMO_START.INC}

  lblInfo.Caption := 'Hello world from registered version';

  {$I DEMO_END.INC}

end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  bRegisteredCodeDone: boolean;
begin

  bRegisteredCodeDone := False;

  {$I DEMO_START.INC}

  // do things that arent available without license key, eg. saving
  // configuration etc.
  if bRegisteredCodeDone = False then
  begin

    SaveOptions;
    // MakeBackup;
    // Do1;
    // Do2;
    // Do3;

  end;
  {$I DEMO_END.INC}

  // display a message in unregistered version
  //
  // you need to put at least one DEMO_START or FEATURE_x_START
  // encryption macro in order to use UNREGISTERED_START macros

  {$I UNREGISTERED_START.INC}

  MessageDlg('This is an unregistered version, please buy a full version!', mtWarning, [mbOk], 0);

  {$I UNREGISTERED_END.INC}


end;

end.
