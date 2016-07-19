////////////////////////////////////////////////////////////////////////////////
//
// Przyklad uzycia makr punktow kontrolnych PELOCK_CPUID
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

  dwIntegerValue: integer;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  dwIntegerValue := 2;

  //
  // makra punktow kontrolnych w zaden sposob nie zaklocaja
  // pracy aplikacji, jesli jednak ktos bedzie chcial uruchomic
  // zlamana lub rozpakowana aplikacje, kod makra PELOCK_CPUID
  // wywola wyjatek, tak ze zlamana/rozpakowana aplikacja nie
  // bedzie w efekcie dzialac poprawnie (nie bedzie funkcjonalna)
  //
  try
    {$I PELOCK_CPUID.INC}
  except

    //
    // mozesz wylapac wyjatki spowodowane przez PELOCK_CPUID
    // po usunieciu zabezpieczenia i obsluzyc ta sytuacje wedle
    // wlasnego uznania
    //
    on Exception do
    begin

      //
      // - zamknij aplikacje
      // - uszkodz pamiec aplikacji
      // - wylacz jakies kontrolki
      // - zmien jakies wazne zmienne
      //
      // NIE WYSWIETLAJ ZADNYCH INFORMACJI OSTRZEGAWCZYCH!!!
      //
      dwIntegerValue := 100;
    end;
  end;

  // obliczenia, jesli zostal wywolany wyjatek spowodowany
  // usunieciem zabezpieczenia, zmienna dwIntegerValue zostala
  // zmieniona, tak ze obliczenia beda bledne
  lblInfo.Caption := '1 + 1 rowna sie ' + IntToStr(dwIntegerValue);

end;

end.
