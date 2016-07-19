////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak uzyc makr szyfrujacych systemu licencyjnego FEATURE_x_START
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

procedure ExtraFunctionality;
begin

  // przynajmniej jedno makro DEMO_START / DEMO_END i/lub FEATURE_x_START / FEATURE_x_END
  // jest wymagane, aby system licencyjny byl w ogole aktywny

  // markery szyfrujace FEATURE_x moga byc uzyte, aby umozliwic dostep tylko do niektorych
  // opcji programu w zaleznosci od ustawien klucza licencyjnego

  // zalecane jest umieszczanie markerow szyfrujacych bezposrednio pomiedzy klamrami
  // warunkowymi, tutaj idealnie nadaje sie procedura IsFeaturePresent(), ktora
  // sprawdzi, czy odpowiedni bit opcji byl ustawiony

  if IsFeatureEnabled(1) = True then
  begin

    {$I FEATURE_1_START.INC}

    frmMain.lblInfo.Caption := 'Opcja 1 -> wlaczona';

    // koncowy marker to albo FEATURE_END.INC, albo
    // FEATURE_1_END, w zaleznosci jak preferujesz (sa takie same)
    //{$I FEATURE_1_END.INC}
    {$I FEATURE_END.INC}

  end;

end;


procedure TfrmMain.Button1Click(Sender: TObject);
begin
  frmMain.Close;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin

  lblInfo.Caption := 'Opcja 1 -> wylaczona';

  ExtraFunctionality;

end;

end.
