////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak ustawic klucz licencyjny z danych bufora pamieci
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, PELock;

type
  TfrmMain = class(TForm)
    lblInfo: TLabel;
    btnExit: TBitBtn;
    edtUsername: TMemo;
    procedure btnExitClick(Sender: TObject);
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

procedure TfrmMain.btnExitClick(Sender: TObject);
begin

  // zakoncz aplikacje
  frmMain.Close;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  KeyFile: TFileStream;
  KeyBuffer: PByteArray;
  UserName: string;
begin

  try

  // otworz plik zawierajacy dane licencyjne
  KeyFile := TFileStream.Create('c:\key.lic', fmOpenRead);

  // sprawdz rozmiar pliku
  if KeyFile.Size <> 0 then
  begin

    // zaalokuj pamiec na dane pliku
    GetMem(KeyBuffer, KeyFile.Size);

    // odczytaj plik do zaalokowanego bufora pamieci
    KeyFile.Read(KeyBuffer^, KeyFile.Size);

    // ustaw klucz rejestracyjny z bufora pamieci
    SetRegistrationData(KeyBuffer, KeyFile.Size);

    // zwolnij pamiec
    FreeMem(KeyBuffer);

  end;

  // zamknij plik
  KeyFile.Free;

  except;
  end;

  // jesli klucz z pliku bedzie poprawny, kod pomiedzy markerami
  // zostanie zdeszyfrowany
  {$I DEMO_START.INC}

  // odczytaj dane zarejestrowanego uzytkownika
  UserName := GetRegistrationName;

  // wyswietl dane zarejestrowanego uzytkownika
  edtUsername.Text := UserName;

  {$I DEMO_END.INC}

end;

end.
