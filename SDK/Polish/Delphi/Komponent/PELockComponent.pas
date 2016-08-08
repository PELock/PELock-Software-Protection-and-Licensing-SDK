////////////////////////////////////////////////////////////////////////////////
//
// PELock Unit (komponent)
//
// Wersja         : PELock v2.0
// Jezyk          : Delphi/Pascal
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

//
// aby aplikacje mogly korzystac z komponentu PELock oraz makr szyfrujacych nalezy
// je skopiowac do katalogu aplikacji lub sciezke, gdzie znajduja sie pliki
// dopisac do:
//
// Menu -> Tools -> Environment Options -> Library -> Library path
//
unit PELockComponent;

//
// zdefiniuj, ktore procedury beda dostepne
// jesli nie chcesz, aby jakies znalazly sie w kodzie
// wstaw znak komentarza przed deklaracja $DEFINE
//
{$DEFINE PELOCK_LICENSE_APIS}
{$DEFINE PELOCK_TIMETRIAL_APIS}
{$DEFINE PELOCK_CRYPTO_APIS}
{$DEFINE PELOCK_PRESENT_CHECKS}
{$DEFINE PELOCK_PROTECTED_CONST}

interface
uses Windows, SysUtils, Classes;

const

//
// max. rozmiar nazwy uzytkownika zapisanej w kluczu, wlaczajac konczace zero
//
PELOCK_MAX_USERNAME = 8193;

//
// max. liczba znakow identyfikatora sprzetowego, wlaczajac konczace zero */
//
PELOCK_MAX_HARDWARE_ID = 17;

//
// TPELock class declaration
//
type

  // kody bledow z procedur systemu ograniczenia czasowego
  TPELockTrialError = (PELOCK_TRIAL_ABSENT = 0, PELOCK_TRIAL_ACTIVE = 1, PELOCK_TRIAL_EXPIRED = 2);

  // kody bledow z GetKeyStatus()
  TPELockKeyStatusError = (PELOCK_KEY_NOT_FOUND = 0, PELOCK_KEY_OK = 1, PELOCK_KEY_INVALID = 2, PELOCK_KEY_STOLEN = 3, PELOCK_KEY_WRONG_HWID = 4, PELOCK_KEY_EXPIRED = 5);

  // struktura identyfikatora sprzetowego dla procedury callback uzytkownika
  type THardwareId = array[0..7] of Char;

  TPELock = class(TComponent)
  public

    Constructor Create;

    //
    // funkcje API systemu licencyjnego
    //
    {$IFDEF PELOCK_LICENSE_APIS}
    function GetKeyStatus: TPELockKeyStatusError;
    function GetRegistrationName: string;
    function GetRawRegistrationName(lpRegistrationRawName: PByteArray; nMaxCount: integer): integer;
    function SetRegistrationKey(szRegistrationKeyPath: string): Boolean;
    function SetRegistrationData(lpBuffer: PByteArray; dwSize: integer): Boolean;
    function SetRegistrationText(szRegistrationKey: string): Boolean;
    procedure DisableRegistrationKey(bPermamentLock: Boolean);
    function ReloadRegistrationKey: Boolean;
    function GetKeyData(iValue: integer): Integer;
    function IsFeatureEnabled(iIndex: integer): Boolean;
    function GetKeyInteger(iIndex: integer): Integer;
    function GetHardwareId: string;
    function GetKeyExpirationDate(var lpSystemTime: TSystemTime): Boolean;
    function GetKeyCreationDate(var lpSystemTime: TSystemTime): Boolean;
    function GetKeyRunningTime(var lpRunningTime: TSystemTime): Boolean;
    function SetHardwareIdCallback(lpHardwareIdFunc: TFarProc): Boolean;
    {$ENDIF}

    //
    // funkcje API systemu ograniczenia czasowego
    //
    {$IFDEF PELOCK_TIMETRIAL_APIS}

    function GetTrialDays(var dwTotalDays, dwLeftDays: integer): TPELockTrialError;
    function GetTrialExecutions(var dwTotalExecutions, dwLeftExecutions: integer): TPELockTrialError;
    function GetExpirationDate(var lpExpirationDate: TSystemTime): TPELockTrialError;
    function GetTrialPeriod(var lpPeriodBegin, lpPeriodEnd: TSystemTime): TPELockTrialError;
    {$ENDIF}

    //
    // wbudowane funkcje szyfrujace
    //
    {$IFDEF PELOCK_CRYPTO_APIS}

    // funkcje szyfrujace (szyfr strumieniowy)
    function EncryptData(lpKey: PByteArray; dwKeyLen: integer; lpBuffer: PByteArray; dwSize: integer): Integer;
    function DecryptData(lpKey: PByteArray; dwKeyLen: integer; lpBuffer: PByteArray; dwSize: integer): Integer;

    // szyfrowanie danych kluczami dla biezacej sesji procesu
    function EncryptMemory(lpBuffer: PByteArray; dwSize: integer): Integer;
    function DecryptMemory(lpBuffer: PByteArray; dwSize: integer): Integer;
    {$ENDIF}

    //
    // procedury sprawdzania obecnosci zabezpieczenia
    //
    {$IFDEF PELOCK_PRESENT_CHECKS}
    function IsPELockPresent1: Boolean;
    function IsPELockPresent2: Boolean;
    function IsPELockPresent3: Boolean;
    function IsPELockPresent4: Boolean;
    function IsPELockPresent5: Boolean;
    function IsPELockPresent6: Boolean;
    function IsPELockPresent7: Boolean;
    function IsPELockPresent8: Boolean;
    {$ENDIF}

    //
    // chronione wartosci PELock'a, nie zmieniaj parametrow, oprocz dwValue
    //
    {$IFDEF PELOCK_PROTECTED_CONST}
    function PELOCK_DWORD(const dwValue:DWORD; dwRandomizer:DWORD = $0; const dwMagic1:DWORD = $11223344; const dwMagic2:DWORD = $44332211): DWORD; stdcall;
    {$ENDIF}

  end;

procedure Register;

implementation

//
// rejestracja komponentu
//
procedure Register;
begin
  RegisterComponents('Samples', [TPELock]);
end;

//
// pusty konstruktor
//
Constructor TPELock.Create;
begin
end;

//
// function TPELock.GetKeyStatus: TPELockKeyStatusError;
//
// zwraca informacje o statusie biezacego klucza licencyjnego
//
// [wej]
// brak
//
// [wyj]
// jeden z ponizszych kodow:
// PELOCK_KEY_NOT_FOUND  - nie znaleziono klucza
// PELOCK_KEY_OK         - klucz jest poprawny
// PELOCK_KEY_INVALID    - niepoprawny format klucza
// PELOCK_KEY_STOLEN     - klucz jest kradziony
// PELOCK_KEY_WRONG_HWID - sprzetowy identyfikator nie pasuje
// PELOCK_KEY_EXPIRED    - klucz jest wygasniety
//
{$IFDEF PELOCK_LICENSE_APIS}
function TPELock.GetKeyStatus: TPELockKeyStatusError;
begin
  Result := TPELockKeyStatusError( GetWindowText( HWND(-17), nil, 256 ) );
end;

//
// function TPELock.GetRegistrationName: string;
//
// zwraca nazwe zarejestrowanego uzytkownika lub '' jesli brak klucza
// licencyjnego lub klucz jest nieprawidlowy/wygasly/identyfikator sprzetowy
// jest nieprawidlowy
//
// [wej]
// brak
//
// [wyj]
// nazwa zarejestrowanego uzytkownika lub '' jesli niepoprawny klucz
//
function TPELock.GetRegistrationName: string;
var
  szRegistrationName:array[0..PELOCK_MAX_USERNAME] of Char;
begin
  if GetWindowText( HWND(-1), szRegistrationName, PELOCK_MAX_USERNAME) = 0 then
    Result := ''
  else
    Result := szRegistrationName;
end;

//
// function TPELock.GetRawRegistrationName(var lpRegistrationRawName: PByteArray; nMaxCount: integer): integer;
//
// odczytaj dane rejestracyjne jako tablice bajtow
//
// [wej]
// lpRegistrationRawName - bufor dla danych rejestracyjnych
// nMaxCount - rozmiar bufora lpRegistrationRawName w bajtach
//
// [wyj]
// dlugosc danych rejestracyjnych lub 0 jesli brak klucza
//
function TPELock.GetRawRegistrationName(lpRegistrationRawName: PByteArray; nMaxCount: integer): integer;
begin
  Result := GetWindowText( HWND(-22), PChar(lpRegistrationRawName), nMaxCount);
end;

//
// function TPELock.SetRegistrationKey(szRegistrationKeyPath: string): Boolean;
//
// ustawia sciezke do pliku klucza licencyjnego (inna niz katalog
// domowy zabezpieczonej aplikacji)
//
// [wej]
// szRegistrationKeyPath - pelna sciezka do pliku licencyjnego
//
// [wyj]
// True  - klucz zostal poprawnie zweryfikowany i bedzie uzyty
// False - blad funkcji / nieprawidlowy klucz / klucz stracil waznosc
//         nieprawidlowy identyfikator sprzetowy / nieznany blad
//
function TPELock.SetRegistrationKey(szRegistrationKeyPath: string): Boolean;
begin
  if GetWindowText( HWND(-2), PChar(szRegistrationKeyPath), 0) = 0 then
    Result := False
  else
    Result := True;
end;

//
// function TPELock.SetRegistrationData(lpBuffer: PByteArray; dwSize: integer): Boolean;
//
// ustawia dane licencyne z bufora pamieci
//
// [wej]
// lpBuffer - tablica bajtow, zawierajaca dane licencyjne
// dwSize   - rozmiar tablicy bajtow
//
// [wyj]
// True  - klucz poprawnie zweryfikowany i ustawiony
// False - blad funkcji / nieprawidlowy klucz / klucz stracil waznosc
//         nieprawidlowy identyfikator sprzetowy / nieznany blad
//
function TPELock.SetRegistrationData(lpBuffer: PByteArray; dwSize: integer): Boolean;
begin
  if GetWindowText(HWND(-7), PChar(lpBuffer), dwSize) = 0 then
    Result := False
  else
    Result := True;
end;

//
// function TPELock.SetRegistrationText(szRegistrationKey: string): Boolean;
//
// ustawia dane licencyjne z bufora tekstowego (w formacie MIME Base64)
//
// [wej]
// szRegistrationKey - registration key string in MIME Base64 format
//
// [wyj]
// True  - klucz poprawnie zweryfikowany i ustawiony
// False - blad funkcji / nieprawidlowy klucz / klucz stracil waznosc
//         nieprawidlowy identyfikator sprzetowy / nieznany blad
//
function TPELock.SetRegistrationText(szRegistrationKeyPath: string): Boolean;
begin
  if GetWindowText( HWND(-22), PChar(szRegistrationKey), 0) = 0 then
    Result := False
  else
    Result := True;
end;

//
// procedure TPELock.DisableRegistrationKey(bPermamentLock: Boolean);
//
// deaktywuj biezacy klucz licencyjny, blokuj mozliwosc ustawienia nowego klucza
//
// [wej]
// bPermamentLock - nie zezwalaj na ponowne ustawienie klucza
//
// [wyj]
// (brak)
//
procedure TPELock.DisableRegistrationKey(bPermamentLock: Boolean);
begin
  GetWindowText(HWND(-14), nil, Integer(bPermamentLock));
end;

//
// function TPELock.ReloadRegistrationKey: Boolean;
//
// przeladuj klucz rejestracyjny z domyslnych lokalizacji
//
// [wej]
// (brak)
//
// [wyj]
// True  - klucz poprawnie zweryfikowany i ustawiony
// False - blad funkcji / nieprawidlowy klucz / klucz stracil waznosc
//         nieprawidlowy identyfikator sprzetowy / nieznany blad
//
function TPELock.ReloadRegistrationKey: Boolean;
begin
  if GetWindowText( HWND(-16), nil, 256) = 0 then
    Result := False
  else
    Result := True;
end;

//
// function TPELock.GetKeyData(iValue: integer): Integer;
//
// zwraca 8bitowa wartosc zapisana w kluczu
//
// [wej]
// iValue - indeks pobieranej wartosci (od 1 - 4)
//
// [wyj]
// wartosc zapisana w kluczu lub 0 jesli blad
//
function TPELock.GetKeyData(iValue: integer): Integer;
begin
  Result := GetWindowText( HWND(-3), nil, iValue);
end;

//
// function TPELock.IsFeatureEnabled(iIndex: integer): Boolean;
//
// zwraca stan binarny opcji klucza
//
// [wej]
// iIndex - indeks opcji (od 1 - 32)
//
// [wyj]
// True  - opcja zalaczona
// False - opcja wylaczona
//
function TPELock.IsFeatureEnabled(iIndex: integer): Boolean;
begin
  if GetWindowText( HWND(-6), nil, iIndex) = 0 then
    Result := False
  else
    Result := True;
end;

//
// function TPELock.GetKeyInteger(iIndex: integer): Integer;
//
// odczytuje wartosc liczbowa zapisana w kluczu licencyjnym
//
// [wej]
// iIndex - indeks wartosci (od 1 - 16)
//
// [wyj]
// wartosc liczbowa zapisana w kluczu lub 0 jesli
// wartosc nie byla ustawiona, albo wystapil blad
//
function TPELock.GetKeyInteger(iIndex: integer): Integer;
begin
  Result := GetWindowText( HWND(-8), nil, iIndex);
end;

//
// function TPELock.GetHardwareId: string;
//
// zwraca sprzetowy identyfikator dla biezacego komputera
//
// [wej]
// brak
//
// [wyj]
// sprzetowy identyfikator lub '' w razie bledu (pusty ciag jest
// zwracany takze, jesli funkcja zostanie wywolana z niezabezpieczonej
// aplikacji)
//
function TPELock.GetHardwareId: string;
var
  szHardwareId: array[0..128] of Char;
begin
  if GetWindowText( HWND(-4), szHardwareId, 128) = 0 then
    Result := ''
  else
    Result := szHardwareId;
end;

//
// function TPELock.SetHardwareIdCallback(lpHardwareIdFunc: TFarProc): Boolean;
//
// ustaw procedure callback do czytania wlasnego identyfikatora sprzetowego
//
// [wej]
// lpHardwareIdFunc - wlasna procedura do czytania identyfikatora sprzetowego
//
// function CustomHardwareId(var lpcHardwareId: THardwareId): Boolean; stdcall;
// begin
// ...
// end;
//
// [wyj]
// True  - udalo sie ustawic procedure callback
// False - nie powiodlo sie ustawienie procedury callback
//
function TPELock.SetHardwareIdCallback(lpHardwareIdFunc: TFarProc): Boolean;
begin
  if GetWindowText( HWND(-20), PChar(lpHardwareIdFunc), 256) = 0 then
    Result := False
  else
    Result := True;
end;

//
// function TPELock.GetKeyExpirationDate(var lpSystemTime: TSystemTime): Boolean;
//
// pobiera date wygasniecia klucza
//
// [wej]
// lpSystemTime - wskaznik na strukture TSystemTime
//
// [wyj]
// True  - data wygasniecia klucza zostala ustawiona w strukturze TSystemTime
//         (dzien/miesiac/rok)
// False - bledny klucz / klucz nie posiada ograniczenia czasowego
//
function TPELock.GetKeyExpirationDate(var lpSystemTime: TSystemTime): Boolean;
begin
  if GetWindowText( HWND(-5), PChar(@lpSystemTime), 256) = 1 then
    Result := True
  else
    Result := False;
end;


//
// function TPELock.GetKeyCreationDate(var lpSystemTime: TSystemTime): Boolean;
//
// pobiera date utworzenia klucza (jesli byla ustawiona)
//
// [wej]
// lpSystemTime - wskaznik na strukture TSystemTime
//
// [wyj]
// True  - data utworzenia klucza zostala ustawiona w strukturze TSystemTime
//         (dzien/miesiac/rok)
// False - bledny klucz / klucz nie zawiera daty jego utworzenia
//
function TPELock.GetKeyCreationDate(var lpSystemTime: TSystemTime): Boolean;
begin
  if GetWindowText( HWND(-15), PChar(@lpSystemTime), 256) = 1 then
    Result := True
  else
    Result := False;
end;

//
// function TPELock.GetKeyRunningTime(var lpRunningTime: TSystemTime): Boolean;
//
// odczytuje czas wykorzystania klucza (od jego ustawienia)
//
// [wej]
// lpRunningTime - wskaznik na strukture TSystemTime
//
// [wyj]
// True  - okres czasowy uzywania klucza zostal ustawiony w strukturze TSystemTime
// False - brak klucza lub bledny klucz
//
function TPELock.GetKeyRunningTime(var lpRunningTime: TSystemTime): Boolean;
begin
  if GetWindowText( HWND(-23), PChar(@lpRunningTime), 256) = 1 then
    Result := True
  else
    Result := False;
end;

{$ENDIF} // PELOCK_LICENSE_APIS

//
// function TPELock.GetTrialDays(var dwTotalDays, dwLeftDays: integer): TPELockTrialError;
//
// odczytuje ile dni pozostalo w okresie testowym i calkowita liczbe dni
//
// [wej]
// dwTotalDays - wskaznik na wartosc liczbowa, w ktorej zostanie umieszczona
//               liczba wszystkich dni okresu testowego (ten parametr moze byc pusty)
// dwLeftDays  - wskaznik na wartosc liczbowa, w ktorej zostanie umieszczona
//               liczba pozostalych dni okresu testowego (ten parametr moze byc pusty)
//
// [wyj]
// jeden z ponizszych kodow:
// PELOCK_TRIAL_ABSENT  - system ograniczenia czasowego nie byl uzyty, lub program zarejestrowany
// PELOCK_TRIAL_ACTIVE  - system ograniczenia czasowego jest aktywny
// PELOCK_TRIAL_EXPIRED - system ograniczenia czasowego wygasl (zwracane gdy wlaczona jest opcja
//                        "Pozwol aplikacji na dzialanie po wygasnieciu")
//
{$IFDEF PELOCK_TIMETRIAL_APIS}
function TPELock.GetTrialDays(var dwTotalDays, dwLeftDays: integer): TPELockTrialError;
begin
  Result := TPELockTrialError( GetWindowText( HWND(-10), PAnsiChar(@dwTotalDays), Integer(@dwLeftDays) ) );
end;

//
// function TPELock.GetTrialExecutions(var dwTotalExecutions, dwLeftExecutions: integer): TPELockTrialError;
//
// odczytuje ile uruchomien pozostalo w okresie testowym i calkowita liczbe uruchomien
//
// [wej]
// dwTotalExecutions - wskaznik na wartosc liczbowa, w ktorej zostanie umieszczona
//                     liczba wszystkich uruchomien (ten parametr moze byc pusty)
// dwLeftExecutions  - wskaznik na wartosc liczbowa, w ktorej zostanie umieszczona
//                     liczba pozostalych uruchomien (ten parametr moze byc pusty)
// [wyj]
// jeden z ponizszych kodow:
// PELOCK_TRIAL_ABSENT  - system ograniczenia czasowego nie byl uzyty, lub program zarejestrowany
// PELOCK_TRIAL_ACTIVE  - system ograniczenia czasowego jest aktywny
// PELOCK_TRIAL_EXPIRED - system ograniczenia czasowego wygasl (zwracane gdy wlaczona jest opcja
//                        "Pozwol aplikacji na dzialanie po wygasnieciu")
//
function TPELock.GetTrialExecutions(var dwTotalExecutions, dwLeftExecutions: integer): TPELockTrialError;
begin
  Result := TPELockTrialError( GetWindowText( HWND(-11), PAnsiChar(@dwTotalExecutions), Integer(@dwLeftExecutions) ) );
end;

//
// function TPELock.GetExpirationDate(var lpExpirationDate: TSystemTime): TPELockTrialError;
//
// odczytuje date wygasniecia aplikacji
//
// [wej]
// lpSystemTime - wskaznik na strukture TSystemTime
//
// [wyj]
// jeden z ponizszych kodow:
// PELOCK_TRIAL_ABSENT  - system ograniczenia czasowego nie byl uzyty, lub program zarejestrowany
// PELOCK_TRIAL_ACTIVE  - system ograniczenia czasowego jest aktywny
// PELOCK_TRIAL_EXPIRED - system ograniczenia czasowego wygasl (zwracane gdy wlaczona jest opcja
//                        "Pozwol aplikacji na dzialanie po wygasnieciu", struktura TSystemTime
//                        zostanie takze wypelniona
//
function TPELock.GetExpirationDate(var lpExpirationDate: TSystemTime): TPELockTrialError;
begin
  Result := TPELockTrialError( GetWindowText( HWND(-12), PAnsiChar(@lpExpirationDate), 512 ) );
end;

//
// function TPELock.GetTrialPeriod(var lpPeriodBegin, lpPeriodEnd: TSystemTime): TPELockTrialError;
//
// odczytuje informacje o okresie testowym
//
// [wej]
// lpPeriodBegin - wskaznik na strukture TSystemTime (moze byc ustawiony na TSystemTime(nil^) )
// lpPeriodEnd   - wskaznik na strukture TSystemTime (moze byc ustawiony na TSystemTime(nil^) )
//
// [wyj]
// jeden z ponizszych kodow:
// PELOCK_TRIAL_ABSENT  - system ograniczenia czasowego nie byl uzyty, lub program zarejestrowany
// PELOCK_TRIAL_ACTIVE  - system ograniczenia czasowego jest aktywny
//
function TPELock.GetTrialPeriod(var lpPeriodBegin, lpPeriodEnd: TSystemTime): TPELockTrialError;
begin
  Result := TPELockTrialError( GetWindowText( HWND(-13), PAnsiChar(@lpPeriodBegin), Integer(@lpPeriodEnd) ) );
end;
{$ENDIF} // PELOCK_TIMETRIAL_APIS

//
// function TPELock.EncryptData(lpKey: PByteArray; dwKeyLen: integer; lpBuffer: PByteArray; dwSize: integer): Integer;
//
// szyfruje bufor danych wedlug podanego klucza
//
// [wej]
// lpKey    - tablica bajtow, zawierajaca klucz szyfrujacy
// dwKeyLen - dlugosc klucza szyfrujacego w bajtach (dowolna)
// lpBuffer - tablica bajtow, zawierajaca dane do zaszyfrowania
// dwSize   - rozmiar tablicy bajtow do zaszyfrowania
//
// [wyj]
// ilosc zaszyfrowanych bajtow lub 0 jesli blad lub aplikacja nie jest zabezpieczona
//
{$IFDEF PELOCK_CRYPTO_APIS}
function TPELock.EncryptData(lpKey: PByteArray; dwKeyLen: integer; lpBuffer: PByteArray; dwSize: integer): Integer;
begin
  Result := Integer( DeferWindowPos(HDWP(lpKey), HWND(-1), HWND(dwKeyLen), Integer(lpBuffer), Integer(dwSize), 1, 0, 0 ) );
end;

//
// function TPELock.DecryptData(lpKey: PByteArray; dwKeyLen; lpBuffer: PByteArray; dwSize: integer): Integer;
//
// deszyfruje bufor danych wedlug podanego klucza
//
// [wej]
// lpKey    - tablica bajtow, zawierajaca klucz deszyfrujacy
// dwKeyLen - dlugosc klucza deszyfrujacego w bajtach
// lpBuffer - tablica bajtow, zawierajaca dane do odszyfrowania
// dwSize   - rozmiar tablicy bajtow do odszyfrowania
//
// [wyj]
// ilosc odszyfrowanych bajtow lub 0 jesli blad lub aplikacja nie jest zabezpieczona
//
function TPELock.DecryptData(lpKey: PByteArray; dwKeyLen: integer; lpBuffer: PByteArray; dwSize: integer): Integer;
begin
  Result := Integer( DeferWindowPos(HDWP(lpKey), HWND(-1), HWND(dwKeyLen), Integer(lpBuffer), Integer(dwSize), 0, 0, 0 ) );
end;

//
// function TPELock.EncryptMemory(lpBuffer: PByteArray; dwSize: integer): Integer;
//
// szyfruje bufor danych wedlug klucza szyfrujacego wygenerowanego dla
// biezacej sesji uruchomionej aplikacji
//
// [wej]
// lpBuffer - tablica bajtow, zawierajaca dane do zaszyfrowania
// dwSize   - rozmiar tablicy bajtow do zaszyfrowania
//
// [wyj]
// ilosc zaszyfrowanych bajtow lub 0 jesli blad lub aplikacja nie jest zabezpieczona
//
function TPELock.EncryptMemory(lpBuffer: PByteArray; dwSize: integer): Integer;
begin
  Result := Integer( DeferWindowPos(0, HWND(-1), 0, Integer(lpBuffer), Integer(dwSize), 1, 0, 0 ) );
end;

//
// function TPELock.DecryptMemory(lpBuffer: PByteArray; dwSize: integer): Integer;
//
// deszyfruje bufor danych wedlug klucza deszyfrujacego wygenerowanego dla
// biezacej sesji uruchomionej aplikacji
//
// [wej]
// lpBuffer - tablica bajtow, zawierajaca dane do odszyfrowania
// dwSize   - rozmiar tablicy bajtow do odszyfrowania
//
// [wyj]
// ilosc odszyfrowanych bajtow lub 0 jesli blad lub aplikacja nie jest zabezpieczona
//
function TPELock.DecryptMemory(lpBuffer: PByteArray; dwSize: integer): Integer;
begin
  Result := Integer( DeferWindowPos(0, HWND(-1), 0, Integer(lpBuffer), Integer(dwSize), 0, 0, 0 ) );
end;
{$ENDIF} // PELOCK_CRYPTO_APIS

//
// function TPELock.IsPELockPresent1: Boolean;
// ...
// function TPELock.IsPELockPresent8: Boolean;
//
// funkcja sluza do sprawdzania obecnosci zabezpieczenia PELock'a
//
// [wej]
// brak
//
// [wyj]
// True  - zabezpieczenie PELock'a jest obecne w pliku
// False - plik nie jest zabezpieczony, lub zabezpieczenie usuniete
//
// [notes]
// nie zmieniaj parametrow ponizszych funkcji WinApi
//
{$IFDEF PELOCK_PRESENT_CHECKS}
function TPELock.IsPELockPresent1: Boolean;
begin
  if GetAtomName(0, nil, 256) <> 0 then
    Result := True
  else
    Result := False;
end;

function TPELock.IsPELockPresent2: Boolean;
begin
  if LockFile(0, 128, 0, 512, 0) <> False then
    Result := True
  else
    Result := False;
end;

function TPELock.IsPELockPresent3: Boolean;
begin
  if MapViewOfFile(0, FILE_MAP_COPY, 0, 0, 1024) <> nil then
    Result := True
  else
    Result := False;
end;

function TPELock.IsPELockPresent4: Boolean;
begin
  if SetWindowRgn(0, 0, False) <> 0 then
    Result := True
  else
    Result := False;
end;

function TPELock.IsPELockPresent5: Boolean;
begin
  if GetWindowRect(0, TRect(nil^)) <> False then
    Result := True
  else
    Result := False;
end;

function TPELock.IsPELockPresent6: Boolean;
begin
  if GetFileAttributes(nil) <> $FFFFFFFF then
    Result := True
  else
    Result := False;
end;

function TPELock.IsPELockPresent7: Boolean;
begin
  if GetFileTime(0, nil, nil, nil) <> False then
    Result := True
  else
    Result := False;
end;

function TPELock.IsPELockPresent8: Boolean;
begin
  if SetEndOfFile(0) <> False then
    Result := True
  else
    Result := False;
end;
{$ENDIF} // PELOCK_PRESENT_CHECKS

//
// TPELock.PELOCK_DWORD(const dwValue:DWORD):DWORD
//
// zwraca stale wartosci liczbowe, po zabezpieczeniu aplikacji, wartosc
// dwValue jest ukryta dla crackera/hackera/reversera
//
// [wej]
// dwValue - stala wartosc liczbowa (32 bitowa, staloprzecinkowa)
//
// [wyj]
// liczba dwValue
//
// [notes]
// nie zmieniaj parametrow procedury dwMagic1, dwMagic2, ani konwencji
// wywolywania stdcall!
//
{$IFDEF PELOCK_PROTECTED_CONST}
function TPELock.PELOCK_DWORD(const dwValue:DWORD; const dwRandomizer:DWORD = $0; const dwMagic1:DWORD = $11223344; const dwMagic2:DWORD = $44332211): DWORD; stdcall;
var
  dwReturnValue: DWORD;
  dwParams: array[0..2] of DWORD;
  dwDecodedValue: DWORD;
begin
    dwDecodedValue := dwValue - dwRandomizer;

    dwParams[0] := dwDecodedValue;
    dwParams[1] := dwMagic1;
    dwParams[2] := dwMagic2;

    if GetWindowText( HWND(-9), @dwReturnValue, Integer(@dwParams) ) <> 0 then
    begin
      Result := dwReturnValue;
    end
    else
    begin
      Result := dwDecodedValue;
    end;
end;
{$ENDIF} // PELOCK_PROTECTED_CONST

end.
