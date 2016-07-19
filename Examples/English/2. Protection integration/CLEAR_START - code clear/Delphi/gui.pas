////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use CLEAR_START and CLEAR_END macros
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

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  // code between encryption markers is encrypted during process
  // of file protection and when protected file is executed,
  // code is being decrypted.
  //
  // when decrypted code is finally executed, then it's erased
  // from the memory.
  //
  // put CLEAR_START and CLEAR_END markers in code fragments that are
  // executed only once during program session (eg. FormCreate for Delphi)
  {$I CLEAR_START.INC}

  lblInfo.Caption := 'Hello world';

  {$I CLEAR_END.INC}

end;

end.
