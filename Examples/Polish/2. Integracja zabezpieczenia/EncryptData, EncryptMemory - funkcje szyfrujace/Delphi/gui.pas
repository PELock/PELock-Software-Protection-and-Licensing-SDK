////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak uzyc wbudowanych funkcji szyfrujacych (szyfr strumieniowy)
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
  StdCtrls, PELock, ExtCtrls;

type
  TfrmMain = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    btnEncryptData: TButton;
    btnEncryptMemory: TButton;
    procedure Button1Click(Sender: TObject);
    procedure btnEncryptDataClick(Sender: TObject);
    procedure btnEncryptMemoryClick(Sender: TObject);
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

procedure TfrmMain.btnEncryptDataClick(Sender: TObject);
var
  test: string;
  test_len: integer;

  key: string;
  key_len: integer;

  output_size: integer;

begin

  test := 'Przykladowy tekst';
  test_len := Length(test);

  key := '9876543210';
  key_len := Length(key);

  //
  // Algorytm szyfrujacy jest staly i nie bedzie zmieniany
  // w przyszlosci, wiec mozna bez obaw szyfrowac wszelkiego
  // rodzaju dane aplikacji jak pliki konfiguracyjne, bazy danych etc.
  //
  Application.MessageBox(PChar(test), 'Niezaszyfrowany string', MB_OK);

  output_size := EncryptData(PByteArray(key), key_len, PByteArray(test), test_len);

  Application.MessageBox(PChar(test), 'Zaszyfrowany string', MB_OK);

  output_size := DecryptData(PByteArray(key), key_len, PByteArray(test), test_len);

  Application.MessageBox(PChar(test), 'Odszyfrowany string', MB_OK);

end;

procedure TfrmMain.btnEncryptMemoryClick(Sender: TObject);
var
  test: string;
  test_len: integer;

  output_size: integer;

begin

  test := 'Przykladowy tekst';
  test_len := Length(test);

  //
  // Szyfruj i deszyfruj pamiec w tym samym procesie. Aplikacja
  // uruchomiona w innym procesie nie bedzie w stanie odszyfrowac
  // danych.
  //
  Application.MessageBox(PChar(test), 'Niezaszyfrowany string (szyfrowanie bez klucza)', MB_OK);

  output_size := EncryptMemory(PByteArray(test), test_len);

  Application.MessageBox(PChar(test), 'Zaszyfrowany string (szyfrowanie bez klucza)', MB_OK);

  output_size := DecryptMemory(PByteArray(test), test_len);

  Application.MessageBox(PChar(test), 'Odszyfrowany string (szyfrowanie bez klucza)', MB_OK);

end;

end.
