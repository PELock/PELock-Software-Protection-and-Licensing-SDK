;///////////////////////////////////////////////////////////////////////////////
;//
;// Plik naglowkowy biblioteki generatora kluczy licencyjnych
;//
;// Wersja         : PELock v2.0
;// Jezyk          : PureBasic
;// Autor          : Bartosz Wójcik (support@pelock.com)
;// Strona domowa  : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

#PELOCK_MAX_USERNAME            = 8193       ; max. rozmiar nazwy uzytkownika zapisanej w kluczu, wlaczajac konczace zero
#PELOCK_SAFE_KEY_SIZE           = (40*1024)  ; bezpieczny rozmiar bufora na dane wyjsciowe klucza

; formaty wyjsciowe kluczy
#KEY_FORMAT_BIN                 = 0          ; klucz w formie binarnej
#KEY_FORMAT_REG                 = 1          ; klucz w formie zrzutu rejestru Windows (.reg)
#KEY_FORMAT_TXT                 = 2          ; klucz tekstowy (w formacie MIME Base64)

; kody bledow dla funkcji Keygen()
#KEYGEN_SUCCESS                 = 0          ; dane licencyjne poprawnie wygenerowane
#KEYGEN_INVALID_PARAMS          = 1          ; nieprawidlowe parametry (lub brakujace)
#KEYGEN_INVALID_PROJECT         = 2          ; nieprawidlowy plik projektu (np. uszkodzony)
#KEYGEN_OUT_MEMORY              = 3          ; brak pamieci
#KEYGEN_DATA_ERROR              = 4          ; wewnetrzny blad podczas generowania klucza

// kody bledow dla funkcji VerifyKey()
#KEYGEN_VERIFY_SUCCESS          = 0          ; key successfully verified
#KEYGEN_VERIFY_INVALID_PARAMS   = 1          ; invalid params
#KEYGEN_VERIFY_INVALID_PROJECT  = 2          ; invalid project file
#KEYGEN_VERIFY_OUT_MEMORY       = 3          ; out of memory
#KEYGEN_VERIFY_DATA_ERROR       = 4          ; error while verifying key data
#KEYGEN_VERIFY_FILE_ERROR       = 5          ; cannot open key file

;
; pomocnicza procedura do ustawiania pojedynczych opcji bitowych (features)
;
Procedure SET_FEATURE_BIT(FEATURE_INDEX)

    dwFeatureBit.l = 0

    If (FEATURE_INDEX > 0) And (FEATURE_INDEX < 33)

        dwFeatureBit = (1 << (FEATURE_INDEX - 1))

    Else

        MessageRequester("PELock Keygen", "BLAD: SET_FEATURE_BIT przyjmuje wartosci indeksu tylko od 1-32!")

    EndIf

    ProcedureReturn dwFeatureBit

EndProcedure

;
; struktura opisujaca parametry dla generowanego klucza
;
Structure KEYGEN_PARAMS

    *lpOutputBuffer.b                   ; wskaznik bufora na dane wyjsciowe (musi byc odpowiednio duzy)
    *lpdwOutputSize.l                   ; wskaznik na wartosc DWORD, gdzie zostanie zapisany rozmiar danych licencynych

    dwOutputFormat.l                    ; wyjsciowy format klucza (klucz w formie binarnej, w formie zrzutu rejestru Windows etc.)

    *lpszProjectPath.s                  ; sciezka pliku projektu

    StructureUnion

        *lpszProjectPath.s              ; sciezka pliku projektu
        *lpszProjectBuffer.s            ; bufor tekstowy z zawartoscia pliku projektu

    EndStructureUnion

    bProjectBuffer.l                    ; czy lpszProjectBuffer wskazuje na bufor tekstowy zamiast na plik

    bUpdateProject.l                    ; flaga okreslajaca czy ma byc uaktualniony plik projektu (czy dodac uzytkownika)
    *lpbProjectUpdated.l                ; wskaznik do wartosci BOOL, gdzie zostanie zapisany status uaktualnienia projektu

    StructureUnion

        *lpszUsername.s                 ; wskaznik do nazwy uzytkownika
        *lpUsernameRawData.b            ; wskaznik do innych danych licencyjnych (dowolnych, np. binarnych)

    EndStructureUnion

    StructureUnion

        dwUsernameLength.l              ; rozmiar nazwy uzytkownika (max. 8192 znakow)
        dwUsernameRawSize.l             ; rozmiar danych binarnych (max. 8192 bajtow)

    EndStructureUnion

    bSetHardwareLock.l                  ; czy uzyc blokowania licencji na identyfikator sprzetowy
    bSetHardwareEncryption.l            ; czy zaszyfrowac nazwe uzytkownika i dodatkowe pola klucza wedlug identyfikatora sprzetowego
    *lpszHardwareId.s                   ; identyfikator sprzetowy

    bSetKeyIntegers.l                   ; czy ustawic dodatkowe wartosci liczbowe klucza
    dwKeyIntegers.l[16]                 ; dodatkowych 8 wartosci liczbowych klucza

    bSetKeyCreationDate.l               ; czy ustawic date utworzenia klucza
    stKeyCreation.SYSTEMTIME            ; data utworzenia klucza

    bSetKeyExpirationDate.l             ; czy ustawic date wygasniecia klucza
    stKeyExpiration.SYSTEMTIME          ; data wygasniecia klucza

    bSetFeatureBits.l                   ; czy ustawic dodatkowe opcje bitowe klucza (obsluga sekcji FEATURE_x_START)

    StructureUnion

        dwFeatureBits.l                 ; dodatkowe opcje bitowe w formie DWORDa
        dwKeyData.b[4]                  ; dodatkowe opcje bitowe w formie 4 bajtow

    EndStructureUnion

EndStructure

;
; struktura opisujaca parametry dla weryfikacji klucza
;
Structure KEYGEN_VERIFY_PARAMS

    StructureUnion

        *lpszKeyPath.s                  ; sciezka pliku klucza (wejscie)
        *lpKeyBuffer.b                  ; bufor pamieci z zawartoscia klucza (wejscie)

    EndStructureUnion

    bKeyBuffer.l                        ; czy lpKeyBuffer wskazuje na bufor z zawartoscia klucza (wejscie)
    dwKeyBufferSize.l                   ; rozmiar klucza w buforze lpKeyBuffer (wejscie)

    StructureUnion

        *lpszProjectPath.s              ; sciezka pliku projektu (wejscie)
        *lpszProjectBuffer.s            ; bufor tekstowy z zawartoscia pliku projektu (wejscie)

    EndStructureUnion

    bProjectBuffer.l                    ; czy lpszProjectBuffer wskazuje na bufor tekstowy zamiast na plik

    dwOutputFormat.l                    ; wyjsciowy format klucza (klucz w formie binarnej, w formie zrzutu rejestru Windows etc.)

    StructureUnion

        *lpszUsername.s                 ; wskaznik do nazwy uzytkownika
        *lpUsernameRawData.b            ; wskaznik do innych danych licencyjnych (dowolnych, np. binarnych)

    EndStructureUnion


    StructureUnion

        dwUsernameLength.l              ; rozmiar nazwy uzytkownika (max. 8192 znakow)
        dwUsernameRawSize.l             ; rozmiar danych binarnych (max. 8192 bajtow)

    EndStructureUnion

    bHardwareLock.l                     ; czy uzyte jest blokowanie licencji na identyfikator sprzetowy
    bHardwareEncryption.l               ; czy nazwa uzytkownika i dodatkowe pola klucza sa zaszyfrowane wedlug identyfikatora sprzetowego

    bKeyIntegers.l                      ; czy ustawione sa dodatkowe wartosci liczbowe klucza
    dwKeyIntegers.l[16]                 ; dodatkowych 16 wartosci liczbowych klucza

    bKeyCreationDate.l                  ; czy ustawiona jest data utworzenia klucza
    stKeyCreation.SYSTEMTIME            ; data utworzenia klucza

    bKeyExpirationDate.l                ; czy ustawiona jest data wygasniecia klucza
    stKeyExpiration.SYSTEMTIME          ; data wygasniecia klucza

    bFeatureBits.l                      ; czy ustawione sa dodatkowe opcje bitowe klucza (obsluga sekcji FEATURE_x_START)

    StructureUnion

        dwFeatureBits.l                 ; dodatkowe opcje bitowe w formie DWORDa
        dwKeyData.b[4]                  ; dodatkowe opcje bitowe w formie 4 bajtow

    EndStructureUnion

    cKeyChecksum.b[32]                  ; suma kontrolna klucza (moze byc wykorzystana do umieszczenia go na liscie zablokowanych kluczy)

EndStructure