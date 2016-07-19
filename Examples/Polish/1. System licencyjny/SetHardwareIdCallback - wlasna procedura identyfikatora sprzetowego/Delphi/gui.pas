////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak ustawic wlasna procedure callback identyfikatora sprzetowego
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
    btnExit: TButton;
    lblInfo: TLabel;
    Label1: TLabel;
    edtHardwareId: TEdit;
    Label2: TLabel;
    procedure btnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
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

//
// wlasna procedura callback identyfikatora sprzetowego
//
// zwracane wartosci:
//
// 1 - identyfikator sprzetowy poprawnie wygenerowany
// 0 - wystapil blad, przykladowo klucz sprzetowy nie
//     byl obecny), nalezy zauwazyc, ze w tej sytuacji
//     wszystkie wywolania do GetHardwareId() oraz
//     procedur ustawiajacych badz przeladowujacych klucz
//     zablokowany na sprzetowy identyfikator nie beda
//     funkcjonowaly (beda zwracane kody bledow)
//
function CustomHardwareId(var lpcHardwareId: THardwareId): Boolean; stdcall;
var
  i: integer;
begin

  //
  // kopiuj wlasny identyfikator sprzetowy do wyjsciowego bufora (8 bajtow)
  //
  // identyfikator sprzetowy moze byc utworzony z:
  //
  // - identyfikatora klucza sprzetowego (dongle)
  // - informacji z systemu operacyjnego
  // - etc.
  //
  for i := 0 to 7 do
  begin

    lpcHardwareId[i] := Chr(i + 1);

  end;

  // zwroc True (1), co oznacza sukces
  Result := True;

end;


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
  UserName: string;
begin

  // kod odpowiedzialny za odczyt danych z klucza licencyjnego
  // powinien byc umieszczony pomiedzy markerami DEMO_START i DEMO_END
  {$I DEMO_START.INC}

  // odczytaj dane zarejestrowanego uzytkownika
  UserName := GetRegistrationName;

  // wyswietl dane zarejestrowanego uzytkownika
  lblInfo.Caption := UserName;

  {$I DEMO_END.INC}

  // sprawdz czy dane uzytkownika zostaly skopiowane do UserName,
  // czy aplikacja nadal jest niezarejestrowana
  if Length(UserName) = 0 then
  begin

    lblInfo.Caption := 'WERSJA NIEZAREJESTROWANA';

    // wyswietl identyfikator sprzetowy
    edtHardwareId.Text := GetHardwareId;

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
    bRegisteredCodeDone := True;

  end;

  {$I DEMO_END.INC}

  // wyswietl informacje o niezarejestrowanym programie
  if bRegisteredCodeDone = False then
  begin
    MessageDlg('Wersja niezarejestrowana!', mtInformation, [mbOk], 0);
  end;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  // ustaw wlasna procedure callback dla identyfikatora sprzetowego
  // (nalezy wlaczyc odpowiednia opcje w zakladce SDK)
  SetHardwareIdCallback(@CustomHardwareId);

  // przeladuj klucz rejestracyjny (z domyslnych lokalizacji)
  ReloadRegistrationKey;

end;

end.
