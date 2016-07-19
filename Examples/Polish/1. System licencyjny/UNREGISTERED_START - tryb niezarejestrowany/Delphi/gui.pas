////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak uzywac makra szyfrujace UNREGISTERED_START i UNREGISTERED_END
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

  lblInfo.Caption := 'Ta aplikacja jest zarejestrowana';

  {$I DEMO_END.INC}

end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  bRegisteredCodeDone: boolean;
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

  end;
  {$I DEMO_END.INC}


  // wyswietl komunikat w niezarejestrowanej wersji programu
  //
  // nalezy umiescic przynajmniej jedno makro DEMO_START lub FEATURE_x_START,
  // aby mozna bylo skorzystac z makr UNREGISTERED_START
  {$I UNREGISTERED_START.INC}

  MessageDlg('To jest wersja niezarejestrowana, prosze zakupic pelna wersje!', mtInformation, [mbOk], 0);

  {$I UNREGISTERED_END.INC}

end;

end.
