////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dane zarejestrowanego uzytkownika z klucza licencyjnego
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
    lblName: TLabel;
    Label1: TLabel;
    Button1: TButton;
    lblEmail: TLabel;
    lblAddress: TLabel;
    edtName: TEdit;
    edtEmail: TEdit;
    edtAddress: TEdit;
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
var
  RegistrationData: TStringList;
begin

  // kod odpowiedzialny za odczytywanie danych rejestracyjnych powinien
  // znajdowac sie pomiedzy markerami DEMO_START i DEMO_END
  // stanowi to dodatkowe zabezpieczenie
  {$I DEMO_START.INC}

  // odczytaj dane zarejestrowanego uzytkownika i rozbij
  // je na pojedyncze linie (elementy TStringList)
  RegistrationData := TStringList.Create;
  RegistrationData.Text := StringReplace(GetRegistrationName, '', #13#10, [rfReplaceAll] );

  if (RegistrationData.Count <> 0) then
  begin
    edtName.Text := RegistrationData.Strings[0];
    edtEmail.Text := RegistrationData.Strings[1];
    edtAddress.Text := RegistrationData.Strings[2];
  end;

  RegistrationData.Destroy;

  // zamykajacy marker
  {$I DEMO_END.INC}

  // sprawdzy czy cos zostalo skopiowane do bufora, czy
  // aplikacja jest nadal niezarejestrowana
  if edtName.Text = '' then edtName.Text := 'WERSJA NIEZAREJESTROWANA';

end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var bRegisteredCodeDone: Boolean;
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
    bRegisteredCodeDone := True;

  end;

  {$I DEMO_END.INC}

  // wyswietl informacje o niezarejestrowanym programie
  if bRegisteredCodeDone = False then
  begin
    MessageDlg('Wersja niezarejestrowana!', mtInformation, [mbOk], 0);
  end;

end;

end.
