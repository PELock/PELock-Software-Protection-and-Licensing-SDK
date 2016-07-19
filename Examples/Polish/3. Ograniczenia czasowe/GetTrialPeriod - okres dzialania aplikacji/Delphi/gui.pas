////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dane o ograniczeniu czasowym (okres testowy)
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
    lblTrialInfo: TLabel;
    edtStart: TEdit;
    edtEnd: TEdit;
    Label1: TLabel;
    Label2: TLabel;
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
  lpStartDate: TSystemTime;
  lpEndDate  : TSystemTime;
begin

  // sprawdz status ograniczenia czasowego
  case GetTrialPeriod(lpStartDate, lpEndDate) of

  //
  // system ograniczenia czasowego jest aktywny
  //
  PELOCK_TRIAL_ACTIVE :
  begin
    lblTrialInfo.Caption := 'Okres testowy dla tej aplikacji';
    edtStart.Text := Format('%d/%d/%d', [lpStartDate.wDay, lpStartDate.wMonth, lpStartDate.wYear]);
    edtEnd.Text := Format('%d/%d/%d', [lpEndDate.wDay, lpEndDate.wMonth, lpEndDate.wYear]);
  end;

  //
  // wszystkie inne kodu bledow (w tym PELOCK_TRIAL_ABSENT)
  //
  else
    lblTrialInfo.Caption := 'Brak ograniczen czasowych';
  end;

end;

end.
