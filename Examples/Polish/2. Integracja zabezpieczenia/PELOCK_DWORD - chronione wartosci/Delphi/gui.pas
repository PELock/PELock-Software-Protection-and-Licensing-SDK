////////////////////////////////////////////////////////////////////////////////
//
// Przyklad uzycia chronionych wartosci PELOCK_DWORD
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
  // makra PELOCK_DWORD mozesz uzywac w dowolnych miejsach programu,
  // mozesz ich uzywac do inicjalizacji zmiennych, do przekazywania
  // stalych parametrow funkcji WinApi, jako liczniki petli,
  // w obliczeniach etc.
  //
  frmMain.Height := PELOCK_DWORD(200);
  frmMain.Width := PELOCK_DWORD(300);

  x := -5 + PELOCK_DWORD(105) xor PELOCK_DWORD(100);

  lblInfo.Caption := 'Chroniona wartosc 5 = ' + IntToStr( PELOCK_DWORD(5) + x );

end;

end.
