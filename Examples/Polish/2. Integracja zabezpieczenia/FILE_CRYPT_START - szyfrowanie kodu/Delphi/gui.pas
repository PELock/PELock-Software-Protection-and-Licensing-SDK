////////////////////////////////////////////////////////////////////////////////
//
// Przyklad wykorzystania makr szyfrujacych FILE_CRYPT_START i FILE_CRYPT_END
//
// Wersja         : PELock v2.0
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
  StdCtrls;

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

procedure TfrmMain.Button1Click(Sender: TObject);
begin

  frmMain.Close;

end;

procedure TfrmMain.FormShow(Sender: TObject);
begin

  // kod pomiedzy makrami FILE_CRYPT_START i FILE_CRYPT_END bedzie zaszyfrowany
  // w zabezpieczonym pliku (jako klucz szyfrujacy uzyty jest dowolny plik)
  {$I FILE_CRYPT_START.INC}

  lblInfo.Caption := 'Witaj z zaszyfrowanego kodu';

  {$I FILE_CRYPT_END.INC}

end;

end.
