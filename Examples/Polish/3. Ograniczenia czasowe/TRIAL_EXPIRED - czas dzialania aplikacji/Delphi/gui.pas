////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak wykorzystac procedure callback systemu ograniczenia czasowego
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
  Dialogs, ExtCtrls;

type
  TfrmMain = class(TForm)
    lblInfo: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure lblInfoUnDock(Sender: TObject; Client: TControl;
      NewTarget: TWinControl; var Allow: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

//
// ta procedura bedzie wywolana, gdy skonczy sie czas testowy
//
// UWAGA! Procedure nalezy wywolac z jakiegos dowolnego punktu programu
// inaczej Delphi usunie ja z kodu (ze wzgledu na optymalizacje)
//
function Expired():integer;
begin

  {$I TRIAL_EXPIRED.INC}

  frmMain.lblInfo.Caption := 'Aplikacja wygasla! Prosze kupic pelna wersje';

  MessageDlg('Prosze kupic pelna wersje!', mtInformation, [mbOk], 0);

  // jesli procedura callback bedzie wywolana, nie bedzie mozna skorzystac
  // z procedury Close, do zamkniecia aplikacji mozna uzyc Halt lub
  // zwrocic wartosc 1 w procedurze callback
  // frmMain.Close;

  // zwroc 1, aby zamknac aplikacje, 0 - aplikacja bedzie dzialala nadal
  result := 1;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  // kod pomiedzy markerami jest zaszyfrowany w trakcie zabezpieczenia
  // pliku i deszyfrowany, gdy aplikacja jest uruchomiona
  //
  // jesli kod pomiedzy markerami zostanie wykonany, jest on nastepnie
  // wymazywany z pamieci
  //
  // wstaw markery CLEAR_START i CLEAR_END we fragmentach kodu, ktory jest
  // wywolywany tylko 1 raz podczas dzialania aplikacji (np. FormCreate dla Delphi)
  {$I CLEAR_START.INC}

  lblInfo.Caption := 'Ta aplikacja posiada ograniczenie czasowe!';

  {$I CLEAR_END.INC}

end;

procedure TfrmMain.lblInfoUnDock(Sender: TObject; Client: TControl;
  NewTarget: TWinControl; var Allow: Boolean);
begin

  // wywolanie procedury callback, tak, zeby w ogole byla
  // wkompilowana w program
  Expired;

end;

end.
