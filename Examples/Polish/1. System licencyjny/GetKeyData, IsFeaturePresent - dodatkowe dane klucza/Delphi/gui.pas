////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak skorzystac z funkcji IsFeatureEnabled()
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
    lblInfo: TLabel;
    Button1: TButton;
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
begin

  {$I DEMO_START.INC}

  // sprawdz bity opcji zapisane w kluczu, moga posluzyc np.
  // do okreslenia wersji aplikacji
  if IsFeatureEnabled(1) = True
  then
    lblInfo.Caption := 'Professional Edition'
  else
    lblInfo.Caption := 'Standard Edition';

  {$I DEMO_END.INC}

end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  bRegisteredCodeDone: Boolean;
begin

  bRegisteredCodeDone := False;

  {$I DEMO_START.INC}

  // wykonaj rzeczy, ktore sa dostepne tylko po zarejestrowaniu
  // configuration etc.
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
