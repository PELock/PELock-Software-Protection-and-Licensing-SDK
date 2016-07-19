////////////////////////////////////////////////////////////////////////////////
//
// Generator kluczy dla systemu ShareIt
//
// ShareIt SDK    : SDK 3 File Revision 3
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
unit KeyUser;

interface

uses
  Windows, SysUtils, KeyIntf;

// plik naglowkowy dla KEYGEN.dll
{$I KEYGEN.INC}

// czy zapisywac date utworzenia klucza (date zakupu)
{$DEFINE CREATION_DATE}

// czy ustawiac blokade na sprzetowy identyfikator (identyfikator przekazywany jako wpis ADDITIONAL1)
//{$DEFINE HARDWARE_ID}

type
  TMyKeyGen = class(TAbstractKeyGen)
  protected
    function GetTitle: string; override;
    function GenerateKey: integer; override;
  end;

implementation

{ TMyKeyGen }
function TMyKeyGen.GetTitle: string;
begin
  Result := 'PELock v2.0 Generator Kluczy';
end;


function TMyKeyGen.GenerateKey: integer;
var
    KeyDataArray      : array[0..PELOCK_SAFE_KEY_SIZE] of byte;   // bufor wyjsciowy na dane klucza
    KeyDataSize       : DWORD;                    // rozmiar danych klucza licencyjnego
    KeyCreationDate   : TSystemTime;              // data utworzenia klucza licencyjnego
    KeyExpirationDate : TSystemTime;              // data wygasniecia klucza licencyjnego
    kpKeygenParams    : TKeygenParams;            // struktura opisujaca parametry generatora kluczy
    Status            : DWORD;                    // kod bledu zwrocony z procedury Keygen()

    szRegNameFormat   : String;
    REG_NAME, EMAIL   : String;                   // parametry wejsciowe
    PURCHASE_ID       : String;
    PRODUCT_ID        : String;
    QUANTITY          : String;
    HARDWARE_ID       : String;
    PURCHASE_DATE     : String;

begin

    //////////////////////////////////////////////////////////////////////
    // przykladowe parametry wejsciowe (dostepne elementy)
    //
    // ENCODING=UTF8
    // PURCHASE_ID=0
    // RUNNING_NO=1
    // PURCHASE_DATE=23/07/2004
    // PRODUCT_ID=100000
    // LANGUAGE_ID=2
    // QUANTITY=1
    // REG_NAME=Peter "Test" Müller
    // ADDITIONAL1=
    // ADDITIONAL2=
    // RESELLER=
    // LASTNAME=Müller
    // FIRSTNAME=Peter
    // COMPANY=
    // EMAIL=mueller@test.net
    // PHONE=
    // FAX=
    // STREET=
    // ZIP=
    // CITY=
    // STATE=
    // COUNTRY=
    //
    //////////////////////////////////////////////////////////////////////
    // odczytaj parametry wejsciowe (podane przy zakupie)
    // skorzystaj z Value() lub WideValue() (dla kodowania UTF8)
    //////////////////////////////////////////////////////////////////////

    REG_NAME      := Value('REG_NAME');
    EMAIL         := Value('EMAIL');
    PURCHASE_ID   := Value('PURCHASE_ID');
    QUANTITY      := Value('QUANTITY');
    HARDWARE_ID   := Value('ADDITIONAL1');
    PRODUCT_ID    := Value('PRODUCT_ID');

    PURCHASE_DATE := Value('PURCHASE_DATE');

    //////////////////////////////////////////////////////////////////////
    // weryfikuj parametry wejsciowe
    //////////////////////////////////////////////////////////////////////

    if (Length(REG_NAME) <= 0) then
    raise EKeyException.Create('Parametr REG_NAME jest nieprawidlowy (pusty)', ERC_BAD_INPUT);

    if (Length(EMAIL) <= 0) then
    raise EKeyException.Create('Parametr EMAIL jest nieprawidlowy', ERC_BAD_INPUT);

    // jesli wymagany jest identyfikator sprzetowy, wymus jego podanie
    {$IFDEF HARDWARE_ID}
    if (Length(HARDWARE_ID) <> 16) then
    raise EKeyException.Create('Parametr ADDITIONAL1 (HARDWARE_ID) jest nieprawidlowy / w zlym formacie', ERC_BAD_INPUT);
    {$ENDIF}

    //////////////////////////////////////////////////////////////////////
    // ustawienie bufora wyjsciowego
    //////////////////////////////////////////////////////////////////////

    // bufor wyjsciowy na dane klucza licencyjnego (tablica bajtow)
    kpKeygenParams.lpOutputBuffer := @KeyDataArray[0];

    // wskaznik do wartosci DWORD, gdzie zostanie zapisany rozmiar wygenerowanego klucza
    kpKeygenParams.lpdwOutputSize := @KeyDataSize;

    //////////////////////////////////////////////////////////////////////
    // sciezka pliku projektu i flaga aktualizacji pliku projektu
    //////////////////////////////////////////////////////////////////////

    kpKeygenParams.lpProjectPtr.lpszProjectPath := PChar(ExtractFilePath(ParamStr(0))+'test.plk');

    // czy uzywamy tekstowego bufora z zawartoscia pliku projektu (zamiast samego pliku projektu)?
    kpKeygenParams.bProjectBuffer := False;

    kpKeygenParams.bUpdateProject := FALSE;
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

    // formatuj nazwe uzytkownika zapisana w kluczu (dodaj podany adres e-mail)
    szRegNameFormat := Trim(REG_NAME) + #13#10 + Trim(EMAIL);

    kpKeygenParams.lpUsernamePtr.lpszUsername := PChar(szRegNameFormat);
    kpKeygenParams.dwUsernameSize.dwUsernameLength := Length(szRegNameFormat);

    //////////////////////////////////////////////////////////////////////
    // blokada klucza na sprzetowy identyfikator
    //////////////////////////////////////////////////////////////////////

    {$IFDEF HARDWARE_ID}
    kpKeygenParams.bSetHardwareLock := True;
    kpKeygenParams.lpszHardwareId := PChar(HARDWARE_ID);
    {$ELSE}
    kpKeygenParams.bSetHardwareLock := False;
    {$ENDIF}

    // czy zaszyfrowac nazwe uzytkownika i dodatkowe pola klucza wedlug identyfikatora sprzetowego
    kpKeygenParams.bSetHardwareEncryption := False;

    //////////////////////////////////////////////////////////////////////
    // dodatkowe wartosci liczbowe (np. identyfikator zakupu etc.)
    //////////////////////////////////////////////////////////////////////

    kpKeygenParams.bSetKeyIntegers := True;

    kpKeygenParams.dwKeyIntegers[0] := StrToInt(QUANTITY);
    kpKeygenParams.dwKeyIntegers[1] := StrToInt(PURCHASE_ID);
    kpKeygenParams.dwKeyIntegers[2] := 0;
    kpKeygenParams.dwKeyIntegers[3] := 0;
    kpKeygenParams.dwKeyIntegers[4] := 0;
    kpKeygenParams.dwKeyIntegers[5] := 0;
    kpKeygenParams.dwKeyIntegers[6] := 0;
    kpKeygenParams.dwKeyIntegers[7] := 0;
    kpKeygenParams.dwKeyIntegers[8] := 0
    kpKeygenParams.dwKeyIntegers[9] := 0
    kpKeygenParams.dwKeyIntegers[10] := 0;
    kpKeygenParams.dwKeyIntegers[11] := 0;
    kpKeygenParams.dwKeyIntegers[12] := 0;
    kpKeygenParams.dwKeyIntegers[13] := 0;
    kpKeygenParams.dwKeyIntegers[14] := 0;
    kpKeygenParams.dwKeyIntegers[15] := 0;

    //////////////////////////////////////////////////////////////////////
    // zapisz date utworzenia klucza (data zakupu naszego oprogramowania)
    //////////////////////////////////////////////////////////////////////

    {$IFDEF CREATION_DATE}
    // pobierz czas z serwera
    // GetSystemTime(KeyCreationDate);

    KeyCreationDate.wDay := StrToInt(Copy(PURCHASE_DATE, 1, 2));
    KeyCreationDate.wMonth := StrToInt(Copy(PURCHASE_DATE, 4, 2));
    KeyCreationDate.wYear := StrToInt(Copy(PURCHASE_DATE, 7, 4));

    kpKeygenParams.bSetKeyCreationDate := True;
    kpKeygenParams.stKeyCreation := KeyCreationDate;
    {$ELSE}
    kpKeygenParams.bSetKeyCreationDate := False;
    {$ENDIF}

    //////////////////////////////////////////////////////////////////////
    // ustaw date wygasniecia klucza licencyjnego
    //////////////////////////////////////////////////////////////////////

    kpKeygenParams.bSetKeyExpirationDate := False;
    kpKeygenParams.stKeyExpiration := KeyExpirationDate;

    //////////////////////////////////////////////////////////////////////
    // dodatkowe opcje binarne klucza (obsluga sekcji FEATURE_x_START)
    //////////////////////////////////////////////////////////////////////

    kpKeygenParams.bSetFeatureBits := False;

    // np. mozna uzyc ich dla wersji home/company oprogramowania
    // odpowiednio odblokowujac zaszyfrowane sekcje
    // if (StrToInt(PRODUCT_ID)) = 12345 then
    // begin
    //   kpKeygenParams.bSetFeatureBits := True;
    //   kpKeygenParams.dwFeatures.dwKeyData1 := $FF;
    // end;
    kpKeygenParams.dwFeatures.dwKeyData1 := 0;
    kpKeygenParams.dwFeatures.dwKeyData2 := 0;
    kpKeygenParams.dwFeatures.dwKeyData3 := 0;
    kpKeygenParams.dwFeatures.dwKeyData4 := 0;

    //////////////////////////////////////////////////////////////////////
    // generuj dane klucza licencyjnego
    //////////////////////////////////////////////////////////////////////

    Status := Keygen(kpKeygenParams);

    // sprawdz zwrocony kod bledu
    case Status of

      // klucz licencyjny poprawnie wygenerowany
      KEYGEN_SUCCESS:
      begin

        SetLength(KeyData, KeyDataSize);
        CopyMemory(PChar(KeyData), @KeyDataArray[0], KeyDataSize);

        KeyMIMEType := 'application/octet-stream';

        // nazwa pliku licencyjnego jaki zostanie przeslany kupujacemu (w zaleznosci od formatu)
        {$IFDEF REG_DUMP_FORMAT}
        KeyDisplayFileName := 'key.reg';
        {$ELSE}
        KeyDisplayFileName := 'key.lic';
        {$ENDIF}

        Result := ERC_SUCCESS_BIN;

      end;

      // nieprawidlowe parametry wejsciowe (lub brakujace parametry)
      KEYGEN_INVALID_PARAMS: Result := ERC_BAD_INPUT;

      // nieprawidlowy plik projektu
      KEYGEN_INVALID_PROJECT: Result := ERC_INTERNAL;

      // blad alokacji pamieci w procedurze Keygen()
      KEYGEN_OUT_MEMORY: Result := ERC_MEMORY;

      // blad generacji danych klucza licencyjnego
      KEYGEN_DATA_ERROR: Result := ERC_INTERNAL;

      // nieznane bledy
      else

      Result := ERC_ERROR;

      end; // case

end;

end.
