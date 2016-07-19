////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak uzywac makra szyfrujace DEMO_START i DEMO_END
//
// Wersja         : PELock v2.0
// Jezyk          : Lazarus/Freepascal
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

// wlacz skladnie Intel assembler
{$ASMMODE INTEL}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, PELock;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnClose: TButton;
    edtHardwareId: TEdit;
    grpAbout: TGroupBox;
    grpRegisteredTo: TGroupBox;
    grpHardwareId: TGroupBox;
    lblApplication: TLabel;
    lblRegisteredName: TLabel;
    tmrSpecialEffect: TTimer;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrSpecialEffectTimer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmMain: TfrmMain;

  dwMinColor, dwMaxColor: integer;
  bMakeBrighter: boolean;

implementation

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  //
  // ustawienie poczatkowe dla manipulacji fontami labela (zmiana kolorow)
  //
  {$I CRYPT_START.INC}

  bMakeBrighter := True;
  dwMinColor := lblApplication.Font.Color;
  dwMaxColor := dwMinColor + $00505050;

  {$I CRYPT_END.INC}

  //
  // odczytaj dane zarejestrowanego uzytkownika (kod pomiedzy markerami
  // szyfrujacymi zostanie wykonany TYLKO jesli bedzie dostepny klucz licencyjny)
  //
  if IsPELockPresent1 = True then
  begin

    {$I DEMO_START.INC}

    lblRegisteredName.Caption := GetRegistrationName;

    {$I DEMO_END.INC}

  end;

  //
  // sprawdz poprawnosc klucza
  //
  if GetKeyStatus <> PELOCK_KEY_OK then
  begin

    {$I UNREGISTERED_START.INC}

    lblRegisteredName.Caption := 'Wersja niezarejestrowana!';

    {$I UNREGISTERED_END.INC}

  end;

  //
  // wyswietl identyfikator sprzetowy
  //
  edtHardwareId.Text := GetHardwareId;


end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin

  // zamknij glowna forme
  frmMain.Close;

end;

procedure TfrmMain.tmrSpecialEffectTimer(Sender: TObject);
begin

  //
  // makra punktow kontrolnych w zaden sposob nie zaklocaja
  // pracy aplikacji, jesli jednak ktos bedzie chcial uruchomic
  // zlamana lub rozpakowana aplikacje, kod makra PELOCK_CHECKPOINT
  // wywola wyjatek, tak ze zlamana/rozpakowana aplikacja nie
  // bedzie w efekcie dzialac poprawnie (nie bedzie funkcjonalna)
  //
  try
    {$I PELOCK_CHECKPOINT.INC}
  except

    //
    // mozesz wylapac wyjatki spowodowane przez PELOCK_CHECKPOINT
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
      btnClose.Visible := False;
    end;
  end;


  if (bMakeBrighter = True) then
  begin

    lblApplication.Font.Color := lblApplication.Font.Color + $00010101;

    if lblApplication.Font.Color = dwMaxColor then bMakeBrighter := False;

  end
  else
  begin

    lblApplication.Font.Color := lblApplication.Font.Color - $00010101;

    if lblApplication.Font.Color = dwMinColor then bMakeBrighter := True;

  end;

end;

initialization
  {$I gui.lrs}

end.

