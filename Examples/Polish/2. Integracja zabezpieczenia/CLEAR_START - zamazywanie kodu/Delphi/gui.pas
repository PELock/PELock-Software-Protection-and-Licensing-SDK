////////////////////////////////////////////////////////////////////////////////
//
// Przyklad wykorzystania makr zamazujacych kod CLEAR_START i CLEAR_END
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

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

  lblInfo.Caption := 'Witaj swiecie';

  {$I CLEAR_END.INC}

end;

end.
