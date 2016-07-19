////////////////////////////////////////////////////////////////////////////////
//
// Przyklad ustawiania klucza licencyjnego, ktory nie znajduje
// sie w glownym katalogu programu
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
  StdCtrls, PELock;

type
  TfrmMain = class(TForm)
    Button1: TButton;
    lblInfo: TLabel;
    Label1: TLabel;
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

  // jesli wczesniej nie byl wykryty poprawny klucz licencyjny
  // ustaw sciezke do klucza
  SetRegistrationKey('a:\key.lic');

  // jesli klucz byl poprawny, kod miedzy markerami szyfrujacymi
  // zostanie wykonany
  {$I DEMO_START.INC}

  // odczytaj dane zarejestrowanego uzytkownika z klucza licencyjnego
  lblInfo.Caption := GetRegistrationName;

  {$I DEMO_END.INC}

  // sprawdz, czy cokolwiek zostalo skopiowane jako nazwa uzytkownika
  // jesli nie, oznacza to, ze aplikacja nadal jest niezarejestrowana
  if lblInfo.Caption = '' then lblInfo.Caption := 'WERSJA NIEZAREJESTROWANA';

end;

end.
