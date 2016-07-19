;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad uzycia biblioteki generatora kluczy licencyjnych
;//
;// Wersja         : PELock v2.0
;// Jezyk          : PureBasic
;// Autor          : Bartosz Wójcik (support@pelock.com)
;// Strona domowa  : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\Polish\PureBasic\"
XIncludeFile "keygen.pb"

; prototyp funkcji Keygen() z biblioteki KEYGEN.dll
Global *KeygenProc

;///////////////////////////////////////////////////////////////////////////////
;//
;// poczatek
;//
;///////////////////////////////////////////////////////////////////////////////

    hKeygen.l
    szProjectPath.s{#MAX_PATH}
    szUsername.s{100}

    hKey.l
    hKeyData.l
    *lpKeyData.b
    dwKeyDataSize.l

    kpKeygenParams.KEYGEN_PARAMS

    dwResult.l

    ;///////////////////////////////////////////////////////////////////////////////
    ;//
    ;// zaladuj biblioteke KEYGEN.dll
    ;//
    ;///////////////////////////////////////////////////////////////////////////////

    hKeygen = OpenLibrary(#PB_Any, "KEYGEN.dll")

    If (hKeygen = 0)
    
      MessageRequester("PELock Keygen", "Nie mozna zaladowac biblioteki KEYGEN.dll!")

      End 1
      
    EndIf
    
    ; pobierz adres procedury "Keygen" z biblioteki generatora kluczy
    *KeygenProc = GetFunction(hKeygen, "Keygen")

    If (*KeygenProc = 0)

        MessageRequester("PELock Keygen", "Nie mozna znalezc procedury Keygen() w bibliotece KEYGEN.dll!")

        End 1
        
    EndIf

    ;///////////////////////////////////////////////////////////////////////////////
    ;//
    ;// zbuduj sciezke do pliku projektu, w ktorym zapisane sa klucze szyfrujace
    ;//
    ;///////////////////////////////////////////////////////////////////////////////

    GetModuleFileName_(#Null, @szProjectPath, #MAX_PATH)

    szProjectPath = GetPathPart(szProjectPath) + "test.plk"


    ;///////////////////////////////////////////////////////////////////////////////
    ;//
    ;// zaalokuj pamiec potrzebna do utworzenia klucza licencyjnego
    ;//
    ;///////////////////////////////////////////////////////////////////////////////

    *lpKeyData = AllocateMemory(#PELOCK_SAFE_KEY_SIZE)

    If (*lpKeyData = #Null)

        MessageRequester("PELock Keygen", "Nie mozna zaalokowac pamieci!")

        End 1
        
    EndIf

    ;///////////////////////////////////////////////////////////////////////////////
    ;//
    ;// wypelnij strukture PELOCK_KEYGEN_PARAMS
    ;//
    ;///////////////////////////////////////////////////////////////////////////////

    ; wskaznik do bufora wyjsciowego na klucz licencyjny (musi byc odpowiednio duzy)
    kpKeygenParams\lpOutputBuffer = *lpKeyData

    ; wskaznik do wartosci DWORD, gdzie zostanie zapisany rozmiar wygenerowanego klucza
    kpKeygenParams\lpdwOutputSize = @dwKeyDataSize

    ; wyjsciowy format klucza
    ; KEY_FORMAT_BIN - binarny klucz
    ; KEY_FORMAT_REG - klucz w formie zrzutu rejestru Windows
    ; KEY_FORMAT_TXT - klucz tekstowy (w formacie MIME Base64)
    kpKeygenParams\dwOutputFormat = #KEY_FORMAT_BIN

    ; sciezka do odpowiedniego pliku projektu
    kpKeygenParams\lpszProjectPath = szProjectPath

    ; czy uzywamy tekstowego bufora z zawartoscia pliku projektu (zamiast samego pliku projektu)?
    kpKeygenParams\bProjectBuffer = #False

    ; czy automatycznie dodac uzytkownika, dla ktorego generowany jest klucz do pliku projektu?
    kpKeygenParams\bUpdateProject = #False

    ; wskaznik do wartosci BOOL, gdzie zostanie zapisany status czy udalo sie dodac uzytkownika do pliku projektu
    kpKeygenParams\lpbProjectUpdated = #Null

    ; wskaznik do nazwy uzytkownika (lub innych danych licencyjnych, moga to byc dane binarne etc.)
    szUsername = "Laura Palmer"

    kpKeygenParams\lpszUsername = szUsername

    ; rozmiar nazwy uzytkownika lub innych danych licencyjnych (max. 8192 znakow/bajtow)
    kpKeygenParams\dwUsernameLength = Len(szUsername)

    ; flaga czy korzystac z blokady na sprzetowy identyfikator?
    kpKeygenParams\bSetHardwareLock = #False

    ; czy zaszyfrowac nazwe uzytkownika i dodatkowe pola klucza wedlug identyfikatora sprzetowego
    kpKeygenParams\bSetHardwareEncryption = #False

    ; ciag znakow identyfikatora sprzetowego
    kpKeygenParams\lpszHardwareId = ""

    ; czy ustawic dodatkowe wartosci liczbowe w kluczu licencyjnym
    kpKeygenParams\bSetKeyIntegers = #True

    ; 16 dodatkowych wartosci liczbowych, ktore zostana zapisane w kluczu (jesli byla ustawiona flaga)
    kpKeygenParams\dwKeyIntegers[0] = 1
    kpKeygenParams\dwKeyIntegers[1] = 2
    kpKeygenParams\dwKeyIntegers[2] = 3
    kpKeygenParams\dwKeyIntegers[3] = 4
    kpKeygenParams\dwKeyIntegers[4] = 5
    kpKeygenParams\dwKeyIntegers[5] = 6
    kpKeygenParams\dwKeyIntegers[6] = 7
    kpKeygenParams\dwKeyIntegers[7] = 8
    kpKeygenParams\dwKeyIntegers[8] = 9
    kpKeygenParams\dwKeyIntegers[9] = 10
    kpKeygenParams\dwKeyIntegers[10] = 11
    kpKeygenParams\dwKeyIntegers[11] = 12
    kpKeygenParams\dwKeyIntegers[12] = 13
    kpKeygenParams\dwKeyIntegers[13] = 14
    kpKeygenParams\dwKeyIntegers[14] = 15
    kpKeygenParams\dwKeyIntegers[15] = 16

    ; flaga czy ustawic date utworzenia klucza
    kpKeygenParams\bSetKeyCreationDate = #True

    ; data utworzenia klucza (SYSTEMTIME)
    stLocalTime = Date()
    kpKeygenParams\stKeyCreation\wDay = Day(stLocalTime)
    kpKeygenParams\stKeyCreation\wMonth = Month(stLocalTime)
    kpKeygenParams\stKeyCreation\wYear = Year(stLocalTime)

    ; flaga czy ustawic date wygasniecia klucza
    kpKeygenParams\bSetKeyExpirationDate = #False

    ; data wygasniecia klucza
    ;kpKeygenParams\stKeyExpiration\wDay = 01
    ;kpKeygenParams\stKeyExpiration\wMonth = 01
    ;kpKeygenParams\stKeyExpiration\wYear = 2012

    ; flaga czy ustawic dodatkowe znaczniki bitowe (obsluga m.in. sekcji FEATURE_x_START)
    kpKeygenParams\bSetFeatureBits = #True

    ; znaczniki bitowe jako DWORD (1) lub (4) lub BITS (32)
    ;kpKeygenParams\dwFeatureBits = $FFFFFFFF
    ;kpKeygenParams\dwKeyData[0] = 255
    kpKeygenParams\dwFeatureBits = SET_FEATURE_BIT(1) | SET_FEATURE_BIT(32)


    ;///////////////////////////////////////////////////////////////////////////////
    ;//
    ;// utworz klucz licencyjny
    ;//
    ;///////////////////////////////////////////////////////////////////////////////

    dwResult = CallFunctionFast(*KeygenProc, @kpKeygenParams)

    Select dwResult

    ; klucz licencyjny poprawnie wygenerowany
    Case #KEYGEN_SUCCESS

        ; zapisz dane klucza licencyjnego do pliku key.lic
        hKey = CreateFile(#PB_Any, "key.lic")

        If (hKey <> 0)

            ; zapisz plik
            WriteData(hKey, *lpKeyData, dwKeyDataSize)
            
            ; zamknij uchwyt pliku
            CloseFile(hKey)

            MessageRequester("PELock Keygen", "Klucz licencyjny zostal poprawnie wygenerowany!")

        Else

            MessageRequester("PELock Keygen", "Nie mozna utworzyc pliku klucza licencyjnego!")

        EndIf


    ; nieprawidlowe parametry wejsciowe (lub brakujace parametry)
    Case #KEYGEN_INVALID_PARAMS

        MessageRequester("PELock Keygen", "Niepoprawne parametry wejsciowe (sprawdz strukture PELOCK_KEY_PARAMS)!")

    ; nieprawidlowy plik projektu
    Case #KEYGEN_INVALID_PROJECT

        MessageRequester("PELock Keygen", "Nieprawidlowy plik projektu, byc moze jest on uszkodzony!")

    ; blad alokacji pamieci w procedurze Keygen()
    Case #KEYGEN_OUT_MEMORY

        MessageRequester("PELock Keygen", "Zabraklo pamieci do wygenerowania klucza!")

    ; blad generacji danych klucza licencyjnego
    Case #KEYGEN_DATA_ERROR

        MessageRequester("PELock Keygen", "Wystapil blad podczas generowania danych licencyjnych, prosze skontaktowac sie z autorem!")

    ; nieznane bledy
    Default

        MessageRequester("PELock Keygen", "Nieznany blad, prosze skontaktowac sie z autorem!")

    EndSelect

    ; zwolnij pamiec
    FreeMemory(*lpKeyData)

    End 0
