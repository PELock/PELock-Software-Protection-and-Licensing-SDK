////////////////////////////////////////////////////////////////////////////////
//
// Przyklad uzycia makr dla funkcji inicjalizujacych PELOCK_INIT_CALLBACK
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
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

  dwSecretValue1, dwSecretValue2: integer;

implementation

{$R *.dfm}

//
// funkcje inicjalizujace sa wywolywane tylko raz po uruchomieniu
// aplikacji, moga byc uzywane do inicjalizacji waznych wartosci,
// sa one wywolywane tylko w przypadku zabezpieczonych aplikacji,
// wiec jesli zabezpiecznie zostanie usuniete, te funkcje nie
// zostana wywolane (dodatkowa ochrona przed rozpakowaniem kodu)
//
// funkcje inicjalizujace musza byc gdzies uzywane w kodzie, aby
// kompilator w trakcie optymalizacji ich nie usunal (co zdarza
// sie w wiekszosci przypadkow, gdy kompilator napotka nieuzywane
// funkcje), mozna w takim przypadku skorzystac z prostej sztuczki
// sprawdzajac w dowolnym miejscu aplikacji wskaznik do funkcji
// inicjalizujacej np.:
//
// if ((&pelock_initalization_callback_1 == NULL) return 0;
//
// nalezy rowniez pamietac, ze te funkcje sa wywolywane przed
// kodem inicjalizujacym aplikacje, wiec jesli twoja aplikacja
// polega na dodatkowych bibliotekach (statycznych lub
// dynamicznych), ktore same wymagaja inicjalizacji, upewnij
// sie, zeby funkcje oznaczone PELOCK_INIT_CALLBACK byly proste
// i nie wykorzystywaly dodatkowych bibliotek i ich funkcji
//
procedure pelock_initalization_callback_1(hInstance: HINST; dwReserved: DWORD);
begin

  // znacznik funkcji inicjalizujacej
  {$I PELOCK_INIT_CALLBACK.INC}

  // funkcje inicjalizujace sa wywolywane tylko jeden raz,
  // wiec mozna dodatkowo wymazac ich kod po wykonaniu,
  // korzystajac z makr CLEAR_START i CLEAR_END
  {$I CLEAR_START.INC}

  dwSecretValue1 := 2;

  {$I CLEAR_END.INC}

end;

//
// second callback, you can place as many callbacks as you want
//
procedure pelock_initalization_callback_2(hInstance: HINST; dwReserved: DWORD);
begin

  // znacznik funkcji inicjalizujacej
  {$I PELOCK_INIT_CALLBACK.INC}

  // funkcje inicjalizujace sa wywolywane tylko jeden raz,
  // wiec mozna dodatkowo wymazac ich kod po wykonaniu,
  // korzystajac z makr CLEAR_START i CLEAR_END
  {$I CLEAR_START.INC}

  dwSecretValue2 := 2;

  {$I CLEAR_END.INC}

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  // skorzystaj z wartosci liczbowych dwSecretValue1 oraz dwSecretValue2
  // obie wartosci zostaly zainicjalizowane w funkcjach oznaczonych
  // markerem PELOCK_INIT_CALLBACK
  lblInfo.Caption := '2 + 2 rowna sie ' + IntToStr(dwSecretValue1 + dwSecretValue2);

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin

  // ochrona przed optymalizacjami kompilatora
  if ( (@pelock_initalization_callback_1 = nil) or (@pelock_initalization_callback_2 = nil) ) then
  begin
    Exit;
  end;

end;


end.
