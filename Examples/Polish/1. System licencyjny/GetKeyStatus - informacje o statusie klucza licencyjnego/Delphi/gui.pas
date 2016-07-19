////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac informacje o statusie klucza licencyjnego
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
    Panel1: TPanel;
    lblKeyInfo: TLabel;
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
begin

  // odczytaj informacje o statusie klucza licencyjnego
  case GetKeyStatus of

  //
  // klucz jest poprawny (wiec kod pomiedzy DEMO_START i DEMO_END powinien sie wykonac)
  //
  PELOCK_KEY_OK:
  begin

    {$I DEMO_START.INC}

    lblKeyInfo.Caption := 'Klucz licencyjny jest poprawny.';

    {$I DEMO_END.INC}

  end;

  //
  // niepoprawny format klucza licencyjnego (uszkodzony)
  //
  PELOCK_KEY_INVALID: lblKeyInfo.Caption := 'Klucz licencyjny jest niepoprawny (uszkodzony)!';

  //
  // klucz znajduje sie na liscie kluczy zablokowanych (kradzionych)
  //
  PELOCK_KEY_STOLEN: lblKeyInfo.Caption := 'Klucz jest zablokowany!';

  //
  // komputer posiada inny identyfikator sprzetowy niz ten uzyty do zabezpieczenia klucza
  //
  PELOCK_KEY_WRONG_HWID: lblKeyInfo.Caption := 'Identyfikator sprzetowy tego komputera nie pasuje do klucza licencyjnego!';

  //
  // klucz licencyjny jest wygasniety (nieaktywny)
  //
  PELOCK_KEY_EXPIRED: lblKeyInfo.Caption := 'Klucz licencyjny jest wygasniety!';

  //
  // nie znaleziono klucza licencyjnego
  //
  else
    lblKeyInfo.Caption := 'Nie znaleziono klucza licencyjnego.';
  end;

end;

end.
