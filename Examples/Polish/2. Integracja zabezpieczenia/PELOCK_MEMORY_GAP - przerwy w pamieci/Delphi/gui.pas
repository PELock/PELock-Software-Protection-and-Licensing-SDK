////////////////////////////////////////////////////////////////////////////////
//
// Przyklad wykorzystania makra ochrony pamieci PELOCK_MEMORY_GAP
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
  StdCtrls;

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

procedure TfrmMain.Button1Click(Sender: TObject);
begin

  frmMain.Close;

end;

procedure TfrmMain.FormShow(Sender: TObject);
begin

  // makro spowoduje, ze po uruchomieniu aplikacji w pamieci aplikacji
  // zostanie umieszczony obszar niedostepny dla samej aplikacji (jedynie
  // w obszarze makra), stanowi to dodatkowe zabezpieczenie przed zrzucaniem
  // pamieci aplikacji (dumping), makro to nie ma zadnego wplywu na dzialanie
  // aplikacji i moze byc umieszczane w dowolnych punktach programu
  {$I PELOCK_MEMORY_GAP.INC}

  lblInfo.Caption := 'Witaj';

end;

end.
