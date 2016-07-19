////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dane o ograniczeniu czasowym (ilosc dni)
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
    lblTrialInfo: TLabel;
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
var dwDaysLeft: integer;
begin

  // check time trial status 
  case GetTrialDays(Integer(nil^), dwDaysLeft) of

  //
  // system ograniczenia czasowego jest aktywny
  //
  PELOCK_TRIAL_ACTIVE : lblTrialInfo.Caption := 'Pozostalo ' + IntToStr(dwDaysLeft) + ' dni w okresie testowym';

  //
  // okres testowy wygasl, kod zwracany jest tylko wtedy, gdy wlaczona
  // jest opcja "Pozwol aplikacji na dzialanie po wygasnieciu", tak
  // zeby mozna bylo samemu obsluzyc wygasniecie aplikacji
  //
  PELOCK_TRIAL_EXPIRED: lblTrialInfo.Caption := 'Okres testowy dobiegl konca, prosze zakupic program!';

  //
  // wszystkie inne kody bledow (w tym PELOCK_TRIAL_ABSENT)
  //
  else
    lblTrialInfo.Caption := 'Brak ograniczen czasowych';
  end;

end;

end.
