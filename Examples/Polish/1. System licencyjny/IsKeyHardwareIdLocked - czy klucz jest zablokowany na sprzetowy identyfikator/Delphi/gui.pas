////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak sprawdzic czy klucz jest zablokowany na sprzetowy identyfikator
//
// Wersja         : PELock v2.09
// Jezyk          : Delphi/Pascal
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

//
// aby aplikacje mogly korzystac z unita PELock oraz makr szyfrujacych nalezy
// je skopiowac do katalogu aplikacji lub sciezke, gdzie znajduja sie pliki
// dopisac do:
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

  // czy klucz jest zablokowany na sprzetowy identyfikator
  if IsKeyHardwareIdLocked == True then
    lblKeyInfo.Caption := 'Ten klucz jest zablokowany na sprzetowy identyfikator!'
  else
    lblKeyInfo.Caption := 'Ten klucz NIE jest zablokowany na sprzetowy identyfikator!';

  {$I DEMO_END.INC}

end;

end.
