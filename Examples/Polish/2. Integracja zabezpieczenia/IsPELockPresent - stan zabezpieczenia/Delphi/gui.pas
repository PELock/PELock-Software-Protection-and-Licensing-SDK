////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak sprawdzic obecnosc zabezpieczenia PELock'a
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
    GroupBox1: TGroupBox;
    chkPELockPresent1: TCheckBox;
    chkPELockPresent2: TCheckBox;
    chkPELockPresent3: TCheckBox;
    chkPELockPresent4: TCheckBox;
    chkPELockPresent5: TCheckBox;
    chkPELockPresent6: TCheckBox;
    chkPELockPresent7: TCheckBox;
    chkPELockPresent8: TCheckBox;
    HiddenTimer: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HiddenTimerTimer(Sender: TObject);
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

  //
  // zaznacz checkboxy jesli zabezpieczenie PELock'a
  // jest aktywne, normalnie nie wyswietlaj zadnych
  // informacji
  //
  // jesli zabezpieczysz aplikacje, procedury sprawdzajace
  // obecnosc zabezpieczenia ZAWSZE beda zwracaly wartosc True,
  // w przeciwym wypadku oznaczaloby to, ze zabezpieczenie
  // zostalo usuniete z pliku przez jego zlamanie/rozpakowanie
  // i mozesz (powinienes), zrobic jedna z ponizszych rzeczy:
  //
  // - zamknij aplikacje (kiedy nie jest to spodziewane,
  //   skorzystaj z procedur timera)
  // - uszkodz jakis obszar pamieci
  // - zainicjalizuj jakies zmienne blednymi wartosciami
  // - wywolaj wyjatki (RaiseException())
  // - spowoduj blad w obliczeniach (jest to bardzo trudne
  //   do wysledzenia dla osoby, ktora probuje zlamac aplikacje,
  //   jesli taka nie do konca zlamana aplikacja zostanie
  //   opublikowana i tak nie bedzie dzialac poprawnie)
  //
  // - NIE WYSWIETLAJ ZADNYCH INFORMACJI, ZE ZABEZPIECZENIE
  //   ZOSTALO USUNIETE, JEST TO NAJGORSZA RZECZ, KTORA
  //   MOZNA ZROBIC, GDYZ POZWALA TO ZNALEZC ODWOLANIA
  //   DO FUNKCJI SPRAWDZAJACYCH I TYM SAMYM ICH USUNIECIE
  //
  // uzyj wyobrazni :)
  //
  chkPELockPresent1.Checked := IsPELockPresent1;
  chkPELockPresent2.Checked := IsPELockPresent2;
  chkPELockPresent3.Checked := IsPELockPresent3;
  chkPELockPresent4.Checked := IsPELockPresent4;
  chkPELockPresent5.Checked := IsPELockPresent5;
  chkPELockPresent6.Checked := IsPELockPresent6;
  chkPELockPresent7.Checked := IsPELockPresent7;
  chkPELockPresent8.Checked := IsPELockPresent8;

  //
  // zabezpieczenie PELock'a jest nieobecne, cos jest nie tak
  // zamknij aplikacje
  //

  //{$DEFINE FINAL_RELEASE}
  {$IFDEF FINAL_RELEASE}
  if IsPELockPresent1 = False then Halt;
  {$ENDIF}

  //
  // zabezpieczenie PELock'a nie zostalo wykryte, uruchom ukryty
  // timer, ktory spowoduje zamkniecie aplikacji po 15 sekundach
  //
  {$IFDEF FINAL_RELEASE}
  if IsPELockPresent4 = False then HiddenTimer.Enabled := True;
  {$ENDIF}

end;

procedure TfrmMain.HiddenTimerTimer(Sender: TObject);
begin

  //
  // zabezpieczenie PELock'a nie zostalo wykryte, zakoncz program, ale
  // dla przykladu mozesz tylko wylaczyc jakies kontrolki (np. elementy menu)
  //
  frmMain.Enabled := False;
  frmMain.Close;
end;

end.
