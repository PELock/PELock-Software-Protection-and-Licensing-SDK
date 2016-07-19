////////////////////////////////////////////////////////////////////////////////
//
// Przyklad uzycia biblioteki generatora kluczy licencyjnych
//
// Wersja         : PELock v2.0
// Jezyk          : Delphi/Pascal
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

//
// aby aplikacje mogly korzystac z pliku naglowkowego KEYGEN.INC nalezy
// go skopiowac do katalogu aplikacji lub sciezke, gdzie znajduje sie plik
// dopisac do:
//
// Menu -> Tools -> Environment Options -> Library -> Library path
//
unit gui;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TfrmMain = class(TForm)
    edtUserName: TEdit;
    lblUserName: TLabel;
    edtHardwareId: TEdit;
    lblHardwareId: TLabel;
    edtAdditionalKeyData1: TEdit;
    lblAdditionalKeyData: TLabel;
    TimePicker: TDateTimePicker;
    edtAdditionalKeyData2: TEdit;
    edtAdditionalKeyData3: TEdit;
    edtAdditionalKeyData4: TEdit;
    lblKeyExpiration: TLabel;
    OpenProject: TOpenDialog;
    btnGenerate: TButton;
    SaveLicenseKey: TSaveDialog;
    chkKeyExpirationDate: TCheckBox;
    GroupBox1: TGroupBox;
    chkUpdateProject: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure chkKeyExpirationDateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

{ KEYGEN.dll prototypes }
{$I KEYGEN.INC}

implementation

{$R *.DFM}


procedure TfrmMain.FormShow(Sender: TObject);
begin

  // ustaw tytul okna z wyborem plikow
  OpenProject.Title := 'Otworz Plik Projektu';
  OpenProject.InitialDir := ExtractFilePath(ParamStr(0));

  // odczytaj sciezke wybranego pliku projektu
  if OpenProject.Execute <> true then frmMain.Close;

end;

procedure TfrmMain.btnGenerateClick(Sender: TObject);
var
    KeyData           : array[0..PELOCK_SAFE_KEY_SIZE] of byte;   // bufor wyjsciowy na dane klucza
    KeyDataSize       : DWORD;                    // rozmiar danych klucza licencyjnego
    KeyCreationDate   : TSystemTime;              // data utworzenia klucza licencyjnego
    KeyExpirationDate : TSystemTime;              // data wygasniecia klucza licencyjnego
    KeyFile           : file of byte;             // uchwyt pliku z danymi klucza
    kpKeygenParams    : TKeygenParams;            // struktura opisujaca parametry generatora kluczy
    Status            : DWORD;                    // kod bledu zwrocony z procedury Keygen()

begin

    //////////////////////////////////////////////////////////////////////
    // ustawienie bufora wyjsciowego
    //////////////////////////////////////////////////////////////////////

    // bufor wyjsciowy na dane klucza licencyjnego (tablica bajtow)
    kpKeygenParams.lpOutputBuffer := @KeyData[0];

    // wskaznik do wartosci DWORD, gdzie zostanie zapisany rozmiar wygenerowanego klucza
    kpKeygenParams.lpdwOutputSize := @KeyDataSize;

    //////////////////////////////////////////////////////////////////////
    // sciezka pliku projektu i flaga aktualizacji pliku projektu
    //////////////////////////////////////////////////////////////////////

    kpKeygenParams.lpProjectPtr.lpszProjectPath := PChar(OpenProject.FileName);

    // czy uzywamy tekstowego bufora z zawartoscia pliku projektu (zamiast samego pliku projektu)?
    kpKeygenParams.bProjectBuffer := False;

    kpKeygenParams.bUpdateProject := chkUpdateProject.Checked;
    kpKeygenParams.lpbProjectUpdated := nil;

    //////////////////////////////////////////////////////////////////////
    // wyjsciowy format klucza
    // KEY_FORMAT_BIN - binarny klucz
    // KEY_FORMAT_REG - klucz w formie zrzutu rejestru Windows
    // KEY_FORMAT_TXT - klucz tekstowy (w formacie MIME Base64)
    //////////////////////////////////////////////////////////////////////

    kpKeygenParams.dwOutputFormat := KEY_FORMAT_BIN;

    //////////////////////////////////////////////////////////////////////
    // nazwa uzytkownika i rozmiar nazwy uzytkownika
    //////////////////////////////////////////////////////////////////////

    kpKeygenParams.lpUsernamePtr.lpszUsername := PChar(Trim(edtUserName.Text));
    kpKeygenParams.dwUsernameSize.dwUsernameLength := Length(Trim(edtUserName.Text));

    //////////////////////////////////////////////////////////////////////
    // blokada klucza na sprzetowy identyfikator
    //////////////////////////////////////////////////////////////////////

    if (Length(Trim(edtHardwareId.Text))) <> 0 then
    begin
      kpKeygenParams.bSetHardwareLock := True;
      kpKeygenParams.lpszHardwareId := PChar(Trim(edtHardwareId.Text));
    end
    else
    begin
      kpKeygenParams.bSetHardwareLock := False;
    end;

    // czy zaszyfrowac nazwe uzytkownika i dodatkowe pola klucza wedlug identyfikatora sprzetowego
    kpKeygenParams.bSetHardwareEncryption := False;

    //////////////////////////////////////////////////////////////////////
    // dodatkowe wartosci liczbowe (8 integerow) klucza
    //////////////////////////////////////////////////////////////////////

    kpKeygenParams.bSetKeyIntegers := True;

    kpKeygenParams.dwKeyIntegers[0] := 1;
    kpKeygenParams.dwKeyIntegers[1] := 2;
    kpKeygenParams.dwKeyIntegers[2] := 3;
    kpKeygenParams.dwKeyIntegers[3] := 4;
    kpKeygenParams.dwKeyIntegers[4] := 5;
    kpKeygenParams.dwKeyIntegers[5] := 6;
    kpKeygenParams.dwKeyIntegers[6] := 7;
    kpKeygenParams.dwKeyIntegers[7] := 8;
    kpKeygenParams.dwKeyIntegers[8] := 9;
    kpKeygenParams.dwKeyIntegers[9] := 10;
    kpKeygenParams.dwKeyIntegers[10] := 11;
    kpKeygenParams.dwKeyIntegers[11] := 12;
    kpKeygenParams.dwKeyIntegers[12] := 13;
    kpKeygenParams.dwKeyIntegers[13] := 14;
    kpKeygenParams.dwKeyIntegers[14] := 15;
    kpKeygenParams.dwKeyIntegers[15] := 16;

    //////////////////////////////////////////////////////////////////////
    // data utworzenia klucza zapisana w samym kluczu
    //////////////////////////////////////////////////////////////////////

    GetSystemTime(KeyCreationDate);
    kpKeygenParams.bSetKeyCreationDate := True;
    kpKeygenParams.stKeyCreation := KeyCreationDate;

    //////////////////////////////////////////////////////////////////////
    // czy ustawic date wygasniecia klucza (zaleznie od opcji)
    //////////////////////////////////////////////////////////////////////

    if chkKeyExpirationDate.Checked then
    begin
      kpKeygenParams.bSetKeyExpirationDate := True;

      // odczytaj date wygasniecia klucza
      DateTimeToSystemTime(TimePicker.DateTime, KeyExpirationDate);

      kpKeygenParams.stKeyExpiration := KeyExpirationDate;
    end
    else
    begin
      kpKeygenParams.bSetKeyExpirationDate := False;
    end;

    //////////////////////////////////////////////////////////////////////
    // dodatkowe opcje bitowe klucza (obsluga sekcji FEATURE_x_START)
    //////////////////////////////////////////////////////////////////////

    kpKeygenParams.bSetFeatureBits := True;

    kpKeygenParams.dwFeatures.dwKeyData1 := StrToInt(edtAdditionalKeyData1.Text);
    kpKeygenParams.dwFeatures.dwKeyData2 := StrToInt(edtAdditionalKeyData2.Text);
    kpKeygenParams.dwFeatures.dwKeyData3 := StrToInt(edtAdditionalKeyData3.Text);
    kpKeygenParams.dwFeatures.dwKeyData4 := StrToInt(edtAdditionalKeyData4.Text);


    SaveLicenseKey.InitialDir := ExtractFilePath(ParamStr(0));
    SaveLicenseKey.Title := 'Zapisz klucz licencyjny jako...';

    // ustaw domyslna nazwe pliku klucza licencyjnego
    SaveLicenseKey.FileName := 'key.lic';

    // wyswietl okno dialogowe z wyborem, gdzie zapisac plik klucza licencyjnego
    if SaveLicenseKey.Execute then
    begin

      // utworz klucz licencyjny
      Status := Keygen(kpKeygenParams);

      // sprawdz zwrocony kod bledu z procedury Keygen()
      case Status of

      //
      // klucz licencyjny poprawnie wygenerowany
      //
      KEYGEN_SUCCESS:
      begin

        // utworz na dysku nowy plik, gdzie zostana zapisane dane klucza
        AssignFile(KeyFile, SaveLicenseKey.FileName);
        Rewrite(KeyFile);

        // zapisz dane klucza do pliku
        BlockWrite(KeyFile, KeyData, KeyDataSize);

        // zamknij uchwyt pliku
        CloseFile(KeyFile);

        MessageBox(frmMain.Handle, PChar('Klucz licencyjny zostal poprawnie wygenerowany!'), PChar('OK'), MB_ICONINFORMATION);
      end;

      // nieprawidlowe parametry wejsciowe (lub brakujace parametry)
      KEYGEN_INVALID_PARAMS:

        MessageBox(frmMain.Handle, PChar('Niepoprawne parametry wejsciowe (sprawdz strukture TKeygenParams)!'), PChar('Blad!'), MB_ICONEXCLAMATION);

      // nieprawidlowy plik projektu
      KEYGEN_INVALID_PROJECT:

        MessageBox(frmMain.Handle, PChar('Nieprawidlowy plik projektu, byc moze jest on uszkodzony!'), PChar('Blad!'), MB_ICONEXCLAMATION);

      // blad alokacji pamieci w procedurze Keygen()
      KEYGEN_OUT_MEMORY:

        MessageBox(frmMain.Handle, PChar('Zabraklo pamieci do wygenerowania klucza!'), PChar('Blad!'), MB_ICONEXCLAMATION);

      // blad generacji danych klucza licencyjnego
      KEYGEN_DATA_ERROR:

        MessageBox(frmMain.Handle, PChar('Wystapil blad podczas generowania danych licencyjnych, prosze skontaktowac sie z autorem!'), PChar('Blad!'), MB_ICONEXCLAMATION);

      // nieznane bledy
      else

        MessageBox(frmMain.Handle, PChar('Nieznany blad, prosze skontaktowac sie z autorem!'), PChar('Blad!'), MB_ICONEXCLAMATION);

      end; // case

    end;

end;

procedure TfrmMain.chkKeyExpirationDateClick(Sender: TObject);
begin
  TimePicker.Enabled := chkKeyExpirationDate.Checked;
end;

end.
