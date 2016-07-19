////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use FEATURE_x_START macros
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
    lblInfo: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
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

procedure ExtraFunctionality;
begin

  // you can limit your application functionality
  // by using 32 FEATURE_x_START / FEATURE_x_END markers
  // code between those markers will be decrypted only
  // in case of a valid keyfile presence (it must have
  // set proper feature options to unlock these encrypted
  // fragments of code)

  if IsFeatureEnabled(1) = True then
  begin

    {$I FEATURE_1_START.INC}

    frmMain.lblInfo.Caption := 'Feature 1 -> enabled';

    // you can use either generic FEATURE_END.INC macro
    // definition or FEATURE_1_END
    //{$I FEATURE_1_END.INC}
    {$I FEATURE_END.INC}

  end;

end;


procedure TfrmMain.Button1Click(Sender: TObject);
begin
  frmMain.Close;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin

  lblInfo.Caption := 'Feature 1 -> disabled';

  ExtraFunctionality;

end;

end.
