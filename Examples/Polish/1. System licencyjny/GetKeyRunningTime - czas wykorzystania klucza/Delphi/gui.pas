////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac date wygasniecia klucza (o ile byla ustawiona)
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
  StdCtrls, ExtCtrls, PELock;

type
  TfrmMain = class(TForm)
    btnExit: TButton;
    Panel1: TPanel;
    lblInfo: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    lblKeyRun: TLabel;
    procedure btnExitClick(Sender: TObject);
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


procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  frmMain.Close;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  KeyExpirationDate: TSystemTime;
begin

  // kod odpowiedzialny za odczyt danych z klucza licencyjnego
  // powinien znajdowac sie pomiedzy markerami DEMO_START i DEMO_END
  {$I DEMO_START.INC}

  // wyswietl dane zarejestrowanego uzytkownika
  lblInfo.Caption := GetRegistrationName;

  // odczytaj czas wykorzystania klucza licencyjnego
  if GetKeyRunningTime(KeyRunningTime) = True then
  begin

    lblKeyRun.Caption := Format('%d godzin %d minut %d sekund', [KeyRunningTime.wHour, KeyRunningTime.wMinute, KeyRunningTime.wSecond]);

  end
  else
  begin
    lblKeyRun.Caption := '---';
  end;

  {$I DEMO_END.INC}

  // sprawdz czy cokolwiek zostalo odczytane z klucza, czy
  // aplikacja nadal jest niezarejestrowana
  if Length(GetRegistrationName) = 0 then
  begin
    lblInfo.Caption := 'WERSJA NIEZAREJESTROWANA';
    lblKeyRun.Caption := 'n/a';
  end;

end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  bRegisteredCodeDone: Boolean;
begin

  bRegisteredCodeDone := False;

  {$I DEMO_START.INC}

  // wykonaj rzeczy, ktore sa dostepne tylko po zarejestrowaniu
  if bRegisteredCodeDone = False then
  begin
    SaveOptions;
    // MakeBackup;
    // Do1;
    // Do2;
    // Do3;

    // ustaw flage wykonania kodu, nie ustawiaj jednak flag rejestracyjnych,
    // mowiacych, ze program jest zarejestrowany, takie flagi sa latwe do
    // znaleznienia w programie i tym samym umozliwiaja zlamanie aplikacj,
    // jesli dzialanie kodu pelnej wersji uzaleznione bedzie tylko od flag
    // pomiedzy markerami DEMO_START i DEMO_END wstaw jak najwiecej kodu, tak
    // zeby jego odtworzenie dla osoby bez klucza bylo niemozliwe
    bRegisteredCodeDone := True
  end;

  {$I DEMO_END.INC}

  // wyswietl informacje o niezarejestrowanym programie
  if bRegisteredCodeDone = False then
  begin
    MessageDlg('Wersja niezarejestrowana!', mtInformation, [mbOk], 0);
  end;

end;

end.
