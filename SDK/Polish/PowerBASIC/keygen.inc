'///////////////////////////////////////////////////////////////////////////////
'//
'// Plik naglowkowy biblioteki generatora kluczy licencyjnych
'//
'// Wersja         : PELock v2.0
'// Jezyk          : C/C++
'// Autor          : Bartosz Wójcik (support@pelock.com)
'// Strona domowa  : https://www.pelock.com
'//
'///////////////////////////////////////////////////////////////////////////////

#IF NOT %DEF(%PELOCK_KEYGEN_INC)
%PELOCK_KEYGEN_INC = 1

%PELOCK_MAX_USERNAME            = 8193              ' max. rozmiar nazwy uzytkownika zapisanej w kluczu, wlaczajac konczace zero
%PELOCK_MAX_HARDWARE_ID         = 17                ' max. liczba znakow identyfikatora sprzetowego, wlaczajac konczace zero
%PELOCK_SAFE_KEY_SIZE           = (40*1024)         ' bezpieczny rozmiar bufora na dane wyjsciowe klucza

' formaty wyjsciowe kluczy
%KEY_FORMAT_BIN                 = 0                 ' klucz w formie binarnej
%KEY_FORMAT_REG                 = 1                 ' klucz w formie zrzutu rejestru Windows (.reg)
%KEY_FORMAT_TXT                 = 2                 ' klucz tekstowy (w formacie MIME Base64)

' kody bledow dla funkcji Keygen()
%KEYGEN_SUCCESS                 = 0                 ' dane licencyjne poprawnie wygenerowane
%KEYGEN_INVALID_PARAMS          = 1                 ' nieprawidlowe parametry (lub brakujace)
%KEYGEN_INVALID_PROJECT         = 2                 ' nieprawidlowy plik projektu (np. uszkodzony)
%KEYGEN_OUT_MEMORY              = 3                 ' brak pamieci
%KEYGEN_DATA_ERROR              = 4                 ' wewnetrzny blad podczas generowania klucza

' kody bledow dla funkcji VerifyKey()
%KEYGEN_VERIFY_SUCCESS          = 0                 ' dane licencyjne poprawnie zweryfikowane
%KEYGEN_VERIFY_INVALID_PARAMS   = 1                 ' nieprawidlowe parametry (lub brakujace)
%KEYGEN_VERIFY_INVALID_PROJECT  = 2                 ' nieprawidlowy plik projektu (np. uszkodzony)
%KEYGEN_VERIFY_OUT_MEMORY       = 3                 ' brak pamieci
%KEYGEN_VERIFY_DATA_ERROR       = 4                 ' blad podczas weryfikowania poprawnosci klucza
%KEYGEN_VERIFY_FILE_ERROR       = 5                 ' nie mozna otworzyc pliku klucza

'
' nazwa pliku projektu lub wskaznik do danych projektu w pamieci
'
UNION KEYGEN_PROJECT_PTR

    lpszProjectPath       AS ASCIIZ PTR             ' sciezka pliku projektu
    lpszProjectBuffer     AS ASCIIZ PTR             ' bufor tekstowy z zawartoscia pliku projektu

END UNION

'
' nazwa uzytkownika lub dowolne inne dane np. w formie
' binarnej
'
UNION KEYGEN_USERNAME_PTR

    lpszUsername          AS ASCIIZ PTR             ' wskaznik do nazwy uzytkownika
    lpUsernameRawData     AS BYTE PTR               ' wskaznik do innych danych licencyjnych (dowolnych, np. binarnych)

END UNION

'
' rozmiar nazwy uzytkownika lub innych danych licencyjnych
'
UNION KEYGEN_USERNAME_SIZE

    dwUsernameLength      AS DWORD                  ' rozmiar nazwy uzytkownika (max. 8192 znakow)
    dwUsernameRawSize     AS DWORD                  ' rozmiar danych binarnych (max. 8192 bajtow)

END UNION

'
' pomocnicze makro do ustawiania pojedynczych opcji bitowych (features)
'
MACRO FUNCTION SET_FEATURE_BIT(FEATURE_INDEX)

    MACROTEMP dwFeatureBit
    DIM dwFeatureBit AS DWORD

    IF (FEATURE_INDEX > 0) AND (FEATURE_INDEX < 33) THEN

        dwFeatureBit = 1

        SHIFT LEFT dwFeatureBit, (FEATURE_INDEX - 1)

    ELSE

        MSGBOX "BLAD: SET_FEATURE_BIT przyjmuje wartosci indeksu tylko od 1-32!"

        dwFeatureBit = 0

    END IF

END MACRO = dwFeatureBit

'
' dodatkowe opcje bitowe jako DWORD lub BYTE
'
TYPE KEYGEN_FEATURES_BYTES

    dwKeyData1            AS BYTE
    dwKeyData2            AS BYTE
    dwKeyData3            AS BYTE
    dwKeyData4            AS BYTE

END TYPE

UNION KEYGEN_FEATURES

    dwFeatureBits         AS DWORD                  ' dodatkowe opcje bitowe w formie DWORDa
    dwKeyData             AS KEYGEN_FEATURES_BYTES  ' dodatkowe opcje bitowe w formie 4 bajtow

END UNION

'
' plik klucza lub bufor pamieci z zawartoscia klucza
'
UNION KEYGEN_KEY_PTR

    lpszUsername          AS ASCIIZ PTR             ' sciezka pliku klucza (wejscie)
    lpKeyBuffer           AS ASCIIZ PTR             ' bufor pamieci z zawartoscia klucza (wejscie)

END UNION

'
' struktura opisujaca parametry dla generowanego klucza
'
TYPE KEYGEN_PARAMS

    lpOutputBuffer        AS BYTE PTR               ' wskaznik bufora na dane wyjsciowe (musi byc odpowiednio duzy)
    lpdwOutputSize        AS DWORD PTR              ' wskaznik na wartosc DWORD, gdzie zostanie zapisany rozmiar danych licencynych

    dwOutputFormat        AS DWORD                  ' wyjsciowy format klucza (klucz w formie binarnej, w formie zrzutu rejestru Windows etc.)

    lpProjectPtr          AS KEYGEN_PROJECT_PTR     ' nazwa pliku projektu lub wskaznik do danych projektu w pamieci
    bProjectBuffer        AS DWORD                  ' czy lpszProjectBuffer wskazuje na bufor tekstowy zamiast na plik

    bUpdateProject        AS DWORD                  ' flaga okreslajaca czy ma byc uaktualniony plik projektu (czy dodac uzytkownika)
    lpbProjectUpdated     AS DWORD PTR              ' wskaznik do wartosci BOOL, gdzie zostanie zapisany status uaktualnienia projektu

    lpUsernamePtr         AS KEYGEN_USERNAME_PTR    ' wskaznik do nazwy uzytkownika lub dowolnych innych danych licencyjnych
    dwUsernameSize        AS KEYGEN_USERNAME_SIZE   ' rozmiar nazwy uzytkownika lub dowolnych innych danych licencyjnych (max. 8192 znakow/bajtow)

    bSetHardwareLock      AS DWORD                  ' czy uzyc blokowania licencji na identyfikator sprzetowy
    bSetHardwareEncryption AS DWORD                 ' czy zaszyfrowac nazwe uzytkownika i dodatkowe pola klucza wedlug identyfikatora sprzetowego
    lpszHardwareId        AS ASCIIZ PTR             ' identyfikator sprzetowy

    bSetKeyIntegers       AS DWORD                  ' czy ustawic dodatkowe wartosci liczbowe klucza
    dwKeyIntegers(0 TO 15) AS DWORD                 ' dodatkowych 8 wartosci liczbowych klucza

    bSetKeyCreationDate   AS DWORD                  ' czy ustawic date utworzenia klucza
    stKeyCreation         AS SYSTEMTIME             ' data utworzenia klucza

    bSetKeyExpirationDate AS DWORD                  ' czy ustawic date wygasniecia klucza
    stKeyExpiration       AS SYSTEMTIME             ' data wygasniecia klucza

    bSetFeatureBits       AS DWORD                  ' czy ustawic dodatkowe opcje bitowe klucza (obsluga sekcji FEATURE_x_START)

    dwFeatures            AS KEYGEN_FEATURES        ' dodatkowe opcje bitowe

END TYPE

'
' struktura opisujaca parametry dla weryfikacji klucza
'
TYPE KEYGEN_VERIFY_PARAMS

    lpKeyPtr             AS KEYGEN_KEY_PTR          ' sciezka do pliku klcuza lub bufor pamieci z zawartoscia klucza (input)
    bKeyBuffer           AS DWORD                   ' czy lpKeyBuffer wskazuje na bufor z zawartoscia klucza (wejscie)
    dwKeyBufferSize      AS DWORD                   ' rozmiar klucza w buforze lpKeyBuffer (wejscie)

    lpProjectPtr         AS KEYGEN_PROJECT_PTR      ' nazwa pliku projektu lub wskaznik do danych projektu w pamieci (wejscie)
    bProjectBuffer       AS DWORD                   ' czy lpszProjectBuffer wskazuje na bufor tekstowy zamiast na plik (wejscie)

    dwOutputFormat       AS DWORD                   ' wyjsciowy format klucza (klucz w formie binarnej, w formie zrzutu rejestru Windows etc.)

    lpUsernamePtr        AS KEYGEN_USERNAME_PTR     ' wskaznik do nazwy uzytkownika lub dowolnych innych danych licencyjnych
    dwUsernameSize       AS KEYGEN_USERNAME_SIZE    ' rozmiar nazwy uzytkownika lub dowolnych innych danych licencyjnych (max. 8192 znakow/bajtow)

    bHardwareLock        AS DWORD                   ' czy uzyte jest blokowanie licencji na identyfikator sprzetowy
    bHardwareEncryption  AS DWORD                   ' czy nazwa uzytkownika i dodatkowe pola klucza sa zaszyfrowane wedlug identyfikatora sprzetowego

    bKeyIntegers         AS DWORD                   ' czy ustawione sa dodatkowe wartosci liczbowe klucza
    dwKeyIntegers(0 TO 15) AS DWORD                 ' dodatkowych 8 wartosci liczbowych klucza

    bKeyCreationDate     AS DWORD                   ' czy ustawiona jest data utworzenia klucza
    stKeyCreation        AS SYSTEMTIME              ' data utworzenia klucza

    bKeyExpirationDate   AS DWORD                   ' czy ustawiona jest data wygasniecia klucza
    stKeyExpiration      AS SYSTEMTIME              ' data wygasniecia klucza

    bFeatureBits         AS DWORD                   ' czy ustawione sa dodatkowe opcje bitowe klucza (obsluga sekcji FEATURE_x_START)
    dwFeatures           AS KEYGEN_FEATURES         ' dodatkowe opcje bitowe

    cKeyChecksum(0 TO 31) AS BYTE                   ' suma kontrolna klucza (moze byc wykorzystana do umieszczenia go na liscie zablokowanych kluczy)

END TYPE


' prototypy funkcji Keygen() i VerifyKey() (dla statycznego lub dynamicznego linkowania biblioteki KEYGEN.dll)
#IF NOT %DEF(%PELOCK_KEYGEN_DYNAMIC)
    DECLARE FUNCTION Keygen LIB "KEYGEN.DLL" ALIAS "Keygen" (lpKeygenParams AS KEYGEN_PARAMS) AS DWORD
    DECLARE FUNCTION VerifyKey LIB "KEYGEN.DLL" ALIAS "VerifyKey" (lpKeygenVerifyParams AS KEYGEN_VERIFY_PARAMS) AS DWORD
#ELSE
    DECLARE FUNCTION Keygen(lpKeygenParams AS KEYGEN_PARAMS) AS DWORD
    DECLARE FUNCTION VerifyKey(lpKeygenVerifyParams AS KEYGEN_VERIFY_PARAMS) AS DWORD
#ENDIF

#ENDIF ' #IF NOT %DEF(%PELOCK_KEYGEN_INC)