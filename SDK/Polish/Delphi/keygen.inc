////////////////////////////////////////////////////////////////////////////////
//
// Plik naglowkowy biblioteki generatora kluczy licencyjnych
//
// Wersja         : PELock v2.0
// Jezyk          : Delphi
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

const

{$EXTERNALSYM PELOCK_MAX_USERNAME}
PELOCK_MAX_USERNAME             = 8193;                 // max. rozmiar nazwy uzytkownika zapisanej w kluczu, wlaczajac konczace zero

{$EXTERNALSYM PELOCK_MAX_HARDWARE_ID}
PELOCK_MAX_HARDWARE_ID          = 17;                   // max. liczba znakow identyfikatora sprzetowego, wlaczajac konczace zero

{$EXTERNALSYM PELOCK_SAFE_KEY_SIZE}
PELOCK_SAFE_KEY_SIZE            = (40*1024);            // bezpieczny rozmiar bufora na dane wyjsciowe klucza

// formaty wyjsciowe kluczy
{$EXTERNALSYM KEY_FORMAT_BIN}
KEY_FORMAT_BIN                  = 0;                    // klucz w formie binarnej

{$EXTERNALSYM KEY_FORMAT_REG}
KEY_FORMAT_REG                  = 1;                    // klucz w formie zrzutu rejestru Windows (.reg)

{$EXTERNALSYM KEY_FORMAT_TXT}
KEY_FORMAT_TXT                  = 2;                    // klucz tekstowy (w formacie MIME Base64)

//
// kody bledow dla Keygen()
//
{$EXTERNALSYM KEYGEN_SUCCESS}
KEYGEN_SUCCESS                  = 0;                    // dane licencyjne poprawnie wygenerowane

{$EXTERNALSYM KEYGEN_INVALID_PARAMS}
KEYGEN_INVALID_PARAMS           = 1;                    // nieprawidlowe parametry (lub brakujace)

{$EXTERNALSYM KEYGEN_INVALID_PROJECT}
KEYGEN_INVALID_PROJECT          = 2;                    // nieprawidlowy plik projektu (np. uszkodzony)

{$EXTERNALSYM KEYGEN_OUT_MEMORY}
KEYGEN_OUT_MEMORY               = 3;                    // brak pamieci

{$EXTERNALSYM KEYGEN_DATA_ERROR}
KEYGEN_DATA_ERROR               = 4;                    // wewnetrzny blad podczas generowania klucza

//
// kody bledow dla VerifyKey()
//
{$EXTERNALSYM KEYGEN_VERIFY_SUCCESS}
KEYGEN_VERIFY_SUCCESS           = 0;                    // dane licencyjne poprawnie zweryfikowane

{$EXTERNALSYM KEYGEN_VERIFY_INVALID_PARAMS}
KEYGEN_VERIFY_INVALID_PARAMS    = 1;                    // nieprawidlowe parametry (lub brakujace)

{$EXTERNALSYM KEYGEN_VERIFY_INVALID_PROJECT}
KEYGEN_VERIFY_INVALID_PROJECT   = 2;                    // nieprawidlowy plik projektu (np. uszkodzony)

{$EXTERNALSYM KEYGEN_VERIFY_OUT_MEMORY}
KEYGEN_VERIFY_OUT_MEMORY        = 3;                    // brak pamieci

{$EXTERNALSYM KEYGEN_VERIFY_DATA_ERROR}
KEYGEN_VERIFY_DATA_ERROR        = 4;                    // blad podczas weryfikowania poprawnosci klucza

{$EXTERNALSYM KEYGEN_VERIFY_FILE_ERROR}
KEYGEN_VERIFY_FILE_ERROR        = 5;                    // nie mozna otworzyc pliku klucza

type

//
// nazwa pliku projektu lub wskaznik do danych projektu w pamieci
//
TKeygenProjectPtr = packed record

        case Integer of
        0: (lpszProjectPath: PChar);                    // sciezka pliku projektu
        1: (lpszProjectBuffer : PChar);                 // bufor tekstowy z zawartoscia pliku projektu
end;

//
// nazwa uzytkownika lub dowolne inne dane np. w formie
// binarnej
//
TKeygenUsernamePtr = packed record

        case Integer of
        0: (lpszUsername: PChar);                       // wskaznik do nazwy uzytkownika
        1: (lpUsernameRawData : PByteArray);            // wskaznik do innych danych licencyjnych (dowolnych, np. binarnych)
end;

//
// rozmiar nazwy uzytkownika lub innych danych licencyjnych
//
TKeygenUsernameSize = packed record

        case Integer of
        0: (dwUsernameLength : DWORD);                  // rozmiar nazwy uzytkownika (max. 8192 znakow)
        1: (dwUsernameRawSize : DWORD);                 // rozmiar danych binarnych (max. 8192 bajtow)
end;

//
// dodatkowe opcje bitowe
//
TKeygenFeatures = packed record

        case Integer of
        0: (dwFeatureBits : DWORD);                     // dodatkowe opcje bitowe w formie DWORDa
        1: (dwKeyData1, dwKeyData2, dwKeyData3, dwKeyData4 : Byte);
end;

//
// plik klucza lub bufor pamieci z zawartoscia klucza
//
TKeygenKeyPtr = packed record

        case Integer of
        0: (lpszKeyPath: PChar);                        // sciezka pliku klucza (wejscie)
        1: (lpKeyBuffer : PByteArray);                  // bufor pamieci z zawartoscia klucza (wejscie)
end;

//
// struktura opisujaca parametry dla generowanego klucza
//
TKeygenParams = packed record

        lpOutputBuffer        : PByteArray;             // wskaznik bufora na dane wyjsciowe (musi byc odpowiednio duzy)
        lpdwOutputSize        : ^DWORD;                 // wskaznik na wartosc DWORD, gdzie zostanie zapisany rozmiar danych licencynych

        dwOutputFormat        : DWORD;                  // wyjsciowy format klucza (klucz w formie binarnej, w formie zrzutu rejestru Windows etc.)

        lpProjectPtr          : TKeygenProjectPtr;      // nazwa pliku projektu lub wskaznik do danych projektu w pamieci
        bProjectBuffer        : LongBool;               // czy lpszProjectBuffer wskazuje na bufor tekstowy zamiast na plik

        bUpdateProject        : LongBool;               // flaga okreslajaca czy ma byc uaktualniony plik projektu (czy dodac uzytkownika)
        lpbProjectUpdated     : ^LongBool;              // wskaznik do wartosci BOOL, gdzie zostanie zapisany status uaktualnienia projektu

        lpUsernamePtr         : TKeygenUsernamePtr;     // wskaznik do nazwy uzytkownika lub dowolnych innych danych licencyjnych
        dwUsernameSize        : TKeygenUsernameSize;    // rozmiar nazwy uzytkownika lub dowolnych innych danych licencyjnych (max. 8192 znakow/bajtow)

        bSetHardwareLock      : LongBool;               // czy uzyc blokowania licencji na identyfikator sprzetowy
        bSetHardwareEncryption: LongBool;               // czy zaszyfrowac nazwe uzytkownika i dodatkowe pola klucza wedlug identyfikatora sprzetowego
        lpszHardwareId        : PChar;                  // identyfikator sprzetowy

        bSetKeyIntegers       : LongBool;               // czy ustawic dodatkowe wartosci liczbowe klucza
        dwKeyIntegers         : array[0..15] of DWORD;  // dodatkowych 8 wartosci liczbowych klucza

        bSetKeyCreationDate   : LongBool;               // czy ustawic date utworzenia klucza
        stKeyCreation         : TSystemTime;            // data utworzenia klucza

        bSetKeyExpirationDate : LongBool;               // czy ustawic date wygasniecia klucza
        stKeyExpiration       : TSystemTime;            // data wygasniecia klucza

        bSetFeatureBits       : LongBool;               // czy ustawic dodatkowe opcje bitowe klucza (obsluga sekcji FEATURE_x_START)
        dwFeatures            : TKeygenFeatures;        // dodatkowe opcje bitowe
end;

//
// struktura opisujaca parametry dla weryfikacji klucza
//
TKeygenVerifyParams = packed record

        lpKeyPtr              : TKeygenKeyPtr;          // sciezka do pliku klcuza lub bufor pamieci z zawartoscia klucza (input)
        bKeyBuffer            : LongBool;               // czy lpKeyBuffer wskazuje na bufor z zawartoscia klucza (wejscie)
        dwKeyBufferSize       : DWORD;                  // rozmiar klucza w buforze lpKeyBuffer (wejscie)

        lpProjectPtr          : TKeygenProjectPtr;      // nazwa pliku projektu lub wskaznik do danych projektu w pamieci (wejscie)
        bProjectBuffer        : LongBool;               // czy lpszProjectBuffer wskazuje na bufor tekstowy zamiast na plik (wejscie)

        dwOutputFormat        : DWORD;                  // wyjsciowy format klucza (klucz w formie binarnej, w formie zrzutu rejestru Windows etc.)

        lpUsernamePtr         : TKeygenUsernamePtr;     // wskaznik do nazwy uzytkownika lub dowolnych innych danych licencyjnych
        dwUsernameSize        : TKeygenUsernameSize;    // rozmiar nazwy uzytkownika lub dowolnych innych danych licencyjnych (max. 8192 znakow/bajtow)

        bHardwareLock         : LongBool;               // czy uzyte jest blokowanie licencji na identyfikator sprzetowy
        bHardwareEncryption   : LongBool;               // czy nazwa uzytkownika i dodatkowe pola klucza sa zaszyfrowane wedlug identyfikatora sprzetowego

        bKeyIntegers          : LongBool;               // czy ustawione sa dodatkowe wartosci liczbowe klucza
        dwKeyIntegers         : array[0..15] of DWORD;  // dodatkowych 16 wartosci liczbowych klucza

        bKeyCreationDate      : LongBool;               // czy ustawiona jest data utworzenia klucza
        stKeyCreation         : TSystemTime;            // data utworzenia klucza

        bKeyExpirationDate    : LongBool;               // czy ustawiona jest data wygasniecia klucza
        stKeyExpiration       : TSystemTime;            // data wygasniecia klucza

        bFeatureBits          : LongBool;               // czy ustawione sa dodatkowe opcje bitowe klucza (obsluga sekcji FEATURE_x_START)
        dwFeatures            : TKeygenFeatures;        // dodatkowe opcje bitowe

        cKeyChecksum          : array[0..31] of Byte;   // suma kontrolna klucza (moze byc wykorzystana do umieszczenia go na liscie zablokowanych kluczy)
end;


// prototyp funkcji Keygen()
function Keygen(var lpKeygenParams: TKeygenParams): integer;stdcall;external 'keygen.dll';

// prototyp funkcji VerifyKey()
function VerifyKey(var lpKeygenVerifyParams: TKeygenVerifyParams): integer;stdcall;external 'keygen.dll';
