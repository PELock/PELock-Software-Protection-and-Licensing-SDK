'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad uzycia biblioteki generatora kluczy licencyjnych
'//
'// Wersja         : PELock v2.0
'// Jezyk          : C/C++
'// Autor          : Bartosz Wójcik (support@pelock.com)
'// Strona domowa  : https://www.pelock.com
'//
'///////////////////////////////////////////////////////////////////////////////

#COMPILE EXE
%USEMACROS = 1

#INCLUDE "win32api.inc"

' linkuj biblioteke KEYGEN.dll dynamicznie (domyslnie jest linkowana statycznie)
%PELOCK_KEYGEN_DYNAMIC = 1
#INCLUDE "keygen.inc"

' prototyp funkcji Keygen() z biblioteki KEYGEN.dll
GLOBAL KeygenProc AS DWORD

'///////////////////////////////////////////////////////////////////////////////
'//
'// poczatek
'//
'///////////////////////////////////////////////////////////////////////////////

FUNCTION PBMAIN () AS LONG

    DIM hKeygen AS DWORD
    DIM szProjectPath AS ASCIIZ * %MAX_PATH
    DIM szUsername AS ASCIIZ * 100

    DIM hKey AS LONG
    DIM hKeyData AS DWORD
    DIM lpKeyData AS BYTE PTR
    DIM dwKeyDataSize AS DWORD

    DIM kpKeygenParams AS KEYGEN_PARAMS

    DIM dwResult AS DWORD

    '///////////////////////////////////////////////////////////////////////////////
    '//
    '// zaladuj biblioteke KEYGEN.dll
    '//
    '///////////////////////////////////////////////////////////////////////////////

    #IF %DEF(%PELOCK_KEYGEN_DYNAMIC)

    hKeygen = LoadLibrary("KEYGEN.dll")

    ' sprawdz uchwyt biblioteki
    IF (hKeygen = %NULL) THEN

        MSGBOX "Nie mozna zaladowac biblioteki KEYGEN.dll!"

        FUNCTION = 1
        EXIT FUNCTION

    END IF

    ' pobierz adres procedury "Keygen" z biblioteki generatora kluczy
    KeygenProc = GetProcAddress(hKeygen, "Keygen")

    IF (KeygenProc = %NULL) THEN

        MSGBOX "Nie mozna znalezc procedury Keygen() w bibliotece KEYGEN.dll!"

        FUNCTION = 1
        EXIT FUNCTION

    END IF

    #ENDIF

    '///////////////////////////////////////////////////////////////////////////////
    '//
    '// zbuduj sciezke do pliku projektu, w ktorym zapisane sa klucze szyfrujace
    '//
    '///////////////////////////////////////////////////////////////////////////////

    GetModuleFileName(%NULL, szProjectPath, %MAX_PATH)

    szProjectPath = LEFT$(szProjectPath, INSTR(-1, szProjectPath, "\") - 1) & "\test.plk"


    '///////////////////////////////////////////////////////////////////////////////
    '//
    '// zaalokuj pamiec potrzebna do utworzenia klucza licencyjnego
    '//
    '///////////////////////////////////////////////////////////////////////////////

    lpKeyData = VirtualAlloc(BYVAL %NULL, %PELOCK_SAFE_KEY_SIZE, %MEM_RESERVE OR %MEM_COMMIT, %PAGE_READWRITE)

    IF (lpKeyData = %NULL) THEN

        MSGBOX "Nie mozna zaalokowac pamieci!"

        FUNCTION  = 1
        EXIT FUNCTION

    END IF

    '///////////////////////////////////////////////////////////////////////////////
    '//
    '// wypelnij strukture PELOCK_KEYGEN_PARAMS
    '//
    '///////////////////////////////////////////////////////////////////////////////

    ' wskaznik do bufora wyjsciowego na klucz licencyjny (musi byc odpowiednio duzy)
    kpKeygenParams.lpOutputBuffer = lpKeyData

    ' wskaznik do wartosci DWORD, gdzie zostanie zapisany rozmiar wygenerowanego klucza
    kpKeygenParams.lpdwOutputSize = VARPTR(dwKeyDataSize)

    ' wyjsciowy format klucza
    ' KEY_FORMAT_BIN - binarny klucz
    ' KEY_FORMAT_REG - klucz w formie zrzutu rejestru Windows
    ' KEY_FORMAT_TXT - klucz tekstowy (w formacie MIME Base64)
    kpKeygenParams.dwOutputFormat = %KEY_FORMAT_BIN

    ' sciezka do odpowiedniego pliku projektu
    kpKeygenParams.lpProjectPtr.lpszProjectPath = VARPTR(szProjectPath)

    ' czy uzywamy tekstowego bufora z zawartoscia pliku projektu (zamiast samego pliku projektu)?
    kpKeygenParams.bProjectBuffer = %FALSE

    ' czy automatycznie dodac uzytkownika, dla ktorego generowany jest klucz do pliku projektu?
    kpKeygenParams.bUpdateProject = %FALSE

    ' wskaznik do wartosci BOOL, gdzie zostanie zapisany status czy udalo sie dodac uzytkownika do pliku projektu
    kpKeygenParams.lpbProjectUpdated = %NULL

    ' wskaznik do nazwy uzytkownika (lub innych danych licencyjnych, moga to byc dane binarne etc.)
    szUsername = "Laura Palmer"

    kpKeygenParams.lpUsernamePtr.lpszUsername = VARPTR(szUsername)

    ' rozmiar nazwy uzytkownika lub innych danych licencyjnych (max. 8192 znakow/bajtow)
    kpKeygenParams.dwUsernameSize.dwUsernameLength = LEN(szUsername)

    ' flaga czy korzystac z blokady na sprzetowy identyfikator?
    kpKeygenParams.bSetHardwareLock = %FALSE

    ' czy zaszyfrowac nazwe uzytkownika i dodatkowe pola klucza wedlug identyfikatora sprzetowego
    kpKeygenParams.bSetHardwareEncryption = %FALSE

    ' ciag znakow identyfikatora sprzetowego
    kpKeygenParams.lpszHardwareId = %NULL

    ' czy ustawic dodatkowe wartosci liczbowe w kluczu licencyjnym
    kpKeygenParams.bSetKeyIntegers = %FALSE

    ' 16 dodatkowych wartosci liczbowych, ktore zostana zapisane w kluczu (jesli byla ustawiona flaga)
    kpKeygenParams.dwKeyIntegers(0) = 1
    kpKeygenParams.dwKeyIntegers(1) = 2
    kpKeygenParams.dwKeyIntegers(2) = 3
    kpKeygenParams.dwKeyIntegers(3) = 4
    kpKeygenParams.dwKeyIntegers(4) = 5
    kpKeygenParams.dwKeyIntegers(5) = 6
    kpKeygenParams.dwKeyIntegers(6) = 7
    kpKeygenParams.dwKeyIntegers(7) = 8
    kpKeygenParams.dwKeyIntegers(8) = 9
    kpKeygenParams.dwKeyIntegers(9) = 10
    kpKeygenParams.dwKeyIntegers(10) = 11
    kpKeygenParams.dwKeyIntegers(11) = 12
    kpKeygenParams.dwKeyIntegers(12) = 13
    kpKeygenParams.dwKeyIntegers(13) = 14
    kpKeygenParams.dwKeyIntegers(14) = 15
    kpKeygenParams.dwKeyIntegers(15) = 16

    ' flaga czy ustawic date utworzenia klucza
    kpKeygenParams.bSetKeyCreationDate = %FALSE

    ' data utworzenia klucza (SYSTEMTIME)
    GetLocalTime(kpKeygenParams.stKeyCreation)

    ' flaga czy ustawic date wygasniecia klucza
    kpKeygenParams.bSetKeyExpirationDate = %FALSE

    ' data wygasniecia klucza
    'kpKeygenParams.stKeyExpiration.wDay = 01
    'kpKeygenParams.stKeyExpiration.wMonth = 01
    'kpKeygenParams.stKeyExpiration.wYear = 01

    ' flaga czy ustawic dodatkowe znaczniki bitowe (obsluga m.in. sekcji FEATURE_x_START)
    kpKeygenParams.bSetFeatureBits = %TRUE

    ' znaczniki bitowe jako DWORD (1) lub (4) lub BITS (32)
    'kpKeygenParams.dwFeatures.dwFeatureBits = &HFFFFFFFF
    'kpKeygenParams.dwFeatures.dwKeyData.dwKeyData1 = 255
    kpKeygenParams.dwFeatures.dwFeatureBits = SET_FEATURE_BIT(1) OR SET_FEATURE_BIT(32)


    '///////////////////////////////////////////////////////////////////////////////
    '//
    '// utworz klucz licencyjny
    '//
    '///////////////////////////////////////////////////////////////////////////////

    #IF %DEF(%PELOCK_KEYGEN_DYNAMIC)

    CALL DWORD KeygenProc USING Keygen(kpKeygenParams) TO dwResult

    #ELSE

    dwResult = Keygen(kpKeygenParams)

    #ENDIF

    SELECT CASE dwResult

    ' klucz licencyjny poprawnie wygenerowany
    CASE %KEYGEN_SUCCESS

        ' zapisz dane klucza licencyjnego do pliku key.lic
        hKey = lcreat("key.lic", 0)

        IF (hKey <> %NULL) THEN

            ' zapisz plik
            lwrite(hKey, BYVAL lpKeyData, dwKeyDataSize)

            ' zamknij uchwyt pliku
            lclose(hKey)

            MSGBOX "Klucz licencyjny zostal poprawnie wygenerowany!"

        ELSE

            MSGBOX "Nie mozna utworzyc pliku klucza licencyjnego!"

        END IF


    ' nieprawidlowe parametry wejsciowe (lub brakujace parametry)
    CASE %KEYGEN_INVALID_PARAMS

        MSGBOX "Niepoprawne parametry wejsciowe (sprawdz strukture PELOCK_KEY_PARAMS)!"

    ' nieprawidlowy plik projektu
    CASE %KEYGEN_INVALID_PROJECT

        MSGBOX "Nieprawidlowy plik projektu, byc moze jest on uszkodzony!"

    ' blad alokacji pamieci w procedurze Keygen()
    CASE %KEYGEN_OUT_MEMORY

        MSGBOX "Zabraklo pamieci do wygenerowania klucza!"

    ' blad generacji danych klucza licencyjnego
    CASE %KEYGEN_DATA_ERROR

        MSGBOX "Wystapil blad podczas generowania danych licencyjnych, prosze skontaktowac sie z autorem!"

    ' nieznane bledy
    CASE ELSE

        MSGBOX "Nieznany blad, prosze skontaktowac sie z autorem!"

    END SELECT

    ' zwolnij pamiec
    VirtualFree(lpKeyData, 0, %MEM_RELEASE)

    FUNCTION = 0

END FUNCTION
