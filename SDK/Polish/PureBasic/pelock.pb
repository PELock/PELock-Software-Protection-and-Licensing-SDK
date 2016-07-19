;///////////////////////////////////////////////////////////////////////////////
;//
;// PELock plik naglowkowy
;//
;// Wersja         : PELock v2.0
;// Jezyk          : PureBasic
;// Autor          : Bartosz Wójcik (support@pelock.com)
;// Strona domowa  : https://www.pelock.com
;//
;////////////////////////////////////////////////////////////////////////////////

; nie mozna zdefiniowac operatora SIZEOF() w jezyku PureBasic dlatego zostalo
; wprowadzone dodatkowe makro PELOCK_SIZEOF, ktore mozna uzywac zamiast operatora
; SIZEOF()
#PELOCK_SIZEOF = 1
CompilerIf #PELOCK_SIZEOF = 1
Macro PELOCK_SIZEOF(x)
  PELOCK_DWORD(SizeOf(x))
EndMacro
CompilerEndIf

; max. rozmiar nazwy uzytkownika zapisanej w kluczu, wlaczajac konczace zero
#PELOCK_MAX_USERNAME = 8193

; funkcje API systemu licencyjnego

; odczytaj informacje o statusie klucza licencyjnego
Macro GetKeyStatus()
  GetWindowText_(-16, #Null, 256)
EndMacro

; kody bledow z GetKeyStatus()
#PELOCK_KEY_NOT_FOUND  = 0 ; nie znaleziono klucza
#PELOCK_KEY_OK         = 1 ; klucz jest poprawny
#PELOCK_KEY_INVALID    = 2 ; niepoprawny format klucza
#PELOCK_KEY_STOLEN     = 3 ; klucz jest kradziony
#PELOCK_KEY_WRONG_HWID = 4 ; sprzetowy identyfikator nie pasuje
#PELOCK_KEY_EXPIRED    = 5 ; klucz jest wygasniety

; odczytaj nazwe zarejestrowanego uzytkownika z klucza licencyjnego
Macro GetRegistrationName(szRegistrationName, nMaxCount)
  GetWindowText_(-1, @szRegistrationName, nMaxCount)
EndMacro

; odczytaj dane rejestracyjne jako tablice bajtow
Macro GetRawRegistrationName(lpRegistrationRawName, nMaxCount)
  GetWindowText_(-21, @lpRegistrationRawName, nMaxCount)
EndMacro

; ustaw sciezke klucza licencyjnego (inna niz katalog programu)
Macro SetRegistrationKey(szRegistrationKeyPath)
  GetWindowText_(-2, szRegistrationKeyPath, 0)
EndMacro

; ustaw dane licencyjne z bufora pamieci
Macro SetRegistrationData(lpBuffer, nSize)
  GetWindowText_(-7, lpBuffer, nSize)
EndMacro

; ustaw dane licencyjne z bufora tekstowego (w formacie MIME Base64)
Macro SetRegistrationText(szRegistrationKey)
  GetWindowText_(-22, szRegistrationKey, 0)
EndMacro

; deaktywuj biezacy klucz licencyjny, blokuj mozliwosc ustawienia nowego klucza
Macro DisableRegistrationKey(bPermamentLock)
  GetWindowText_(-14, #Null, bPermamentLock)
EndMacro

; przeladuj klucz rejestracyjny z domyslnych lokalizacji
Macro ReloadRegistrationKey()
  GetWindowText_(-16, #Null, 256)
EndMacro

; odczytaj wartosci zapisane w kluczu licencyjnym
Macro GetKeyData(iValue)
  GetWindowText_(-3, #Null, iValue)
EndMacro

; odczytaj wartosci zapisane w kluczu jako bity
Macro IsFeatureEnabled(iIndex)
  GetWindowText_(-6, #Null, iIndex)
EndMacro

; odczytaj sprzetowy identyfikator dla biezacego komputera
Macro GetHardwareId(szHardwareId, nMaxCount)
  GetWindowText_(-4, @szHardwareId, nMaxCount)
EndMacro

; ustaw procedure callback do czytania wlasnego identyfikatora sprzetowego
Macro SetHardwareIdCallback(lpHardwareIdFunc)
  GetWindowText_(-20, @lpHardwareIdFunc(), 256)
EndMacro

; odczytaj date wygasniecia klucza licencyjnego
Macro GetKeyExpirationDate(lpSystemTime)
  GetWindowText_(-5, @lpSystemTime, 256)
EndMacro

; odczytaj date utworzenia klucza licencyjnego
Macro GetKeyCreationDate(lpSystemTime)
  GetWindowText_(-15, @lpSystemTime, 256)
EndMacro

; odczytaj czas wykorzystania klucza (od jego ustawienia)
Macro GetKeyRunningTime(lpRunningTime)
  GetWindowText_(-23, @lpRunningTime, 256)
EndMacro

; odczytaj wartosci liczbowe zapisane w kluczu (od 1-16)
Macro GetKeyInteger(iIndex)
  GetWindowText_(-8, #Null, iIndex)
EndMacro

; kody bledow z procedur systemu ograniczenia czasowego
#PELOCK_TRIAL_ABSENT  = 0 ; system ograniczenia czasowego nie byl uzyty lub program zarejestrowany
#PELOCK_TRIAL_ACTIVE  = 1 ; system ograniczenia czasowego jest aktywny
#PELOCK_TRIAL_EXPIRED = 2 ; system ograniczenia czasowego wygasl (zwracane gdy wlaczona jest opcja "Pozwol aplikacji na dzialanie po wygasnieciu"

; odczytaj liczbe dni w okresie testowym
Macro GetTrialDays(dwTotalDays, dwLeftDays)
  GetWindowText_(-10, @dwTotalDays, @dwLeftDays)
EndMacro

; odczytaj liczbe uruchomien w okresie testowym
Macro GetTrialExecutions(dwTotalExecutions, dwLeftExecutions)
  GetWindowText_(-11, @dwTotalExecutions, @dwLeftExecutions)
EndMacro

; pobierz date wygasniecia aplikacji
Macro GetExpirationDate(lpExpirationDate)
  GetWindowText_(-12, @lpExpirationDate, 512 )
EndMacro

; pobierz dane o okresie testowym
Macro GetTrialPeriod(lpPeriodBegin, lpPeriodEnd)
  GetWindowText_(-13, @lpPeriodBegin, @lpPeriodEnd )
EndMacro

; funkcje szyfrujace (szyfr strumieniowy)
Macro EncryptData(lpKey, dwKeyLen, lpBuffer, nSize)
  DeferWindowPos_(lpKey, -1, dwKeyLen, lpBuffer, nSize, 1, 0, 0)
EndMacro

Macro DecryptData(lpKey, dwKeyLen, lpBuffer, nSize)
  DeferWindowPos_(lpKey, -1, dwKeyLen, lpBuffer, nSize, 0, 0, 0)
EndMacro

; szyfrowanie danych kluczami dla biezacej sesji procesu
Macro EncryptMemory(lpBuffer, nSize)
  DeferWindowPos_(#Null, -1, #Null, lpBuffer, nSize, 1, 0, 0)
EndMacro

Macro DecryptMemory(lpBuffer, nSize)
  DeferWindowPos_(#Null, -1, #Null, lpBuffer, nSize, 0, 0, 0)
EndMacro

Procedure IsPELockPresent1()
  If ( GetAtomName_(0, #Null, 256) <> 0 ) : ProcedureReturn #True : Else : ProcedureReturn #False : EndIf
EndProcedure

Procedure IsPELockPresent2()
  If ( LockFile_(#Null, 128, 0, 512, 0) <> 0 ) : ProcedureReturn #True : Else : ProcedureReturn #False : EndIf
EndProcedure

Procedure IsPELockPresent3()
  If ( MapViewOfFile_(#Null, #FILE_MAP_COPY, 0, 0, 1024) <> #Null ) : ProcedureReturn #True : Else : ProcedureReturn #False : EndIf
EndProcedure

Procedure IsPELockPresent4()
  If ( SetWindowRgn_(#Null, #Null, #False) ) <> 0 : ProcedureReturn #True : Else : ProcedureReturn #False : EndIf
EndProcedure

Procedure IsPELockPresent5()
  If ( GetWindowRect_(#Null, #Null) ) <> 0 : ProcedureReturn #True : Else : ProcedureReturn #False : EndIf
EndProcedure

Procedure IsPELockPresent6()
  If ( GetFileAttributes_(#Null) ) <> $FFFFFFFF : ProcedureReturn #True : Else : ProcedureReturn #False : EndIf
EndProcedure

Procedure IsPELockPresent7()
  If ( GetFileTime_(#Null, #Null, #Null, #Null) <> 0 ) : ProcedureReturn #True : Else : ProcedureReturn #False : EndIf
EndProcedure

Procedure IsPELockPresent8()
  If ( SetEndOfFile_(#Null) <> 0 ) : ProcedureReturn #True : Else : ProcedureReturn #False : EndIf
EndProcedure

; nie zmieniaj tego kodu (parametrow)!
Procedure GetPELockDWORD (dwValue.l, dwRandomizer.l, dwMagic1.l, dwMagic2.l)

    Dim dwParams.l(3)

    dwDecodedValue.l = dwValue - dwRandomizer
    dwReturnValue.l = 0

    dwParams(0) = dwDecodedValue
    dwParams(1) = dwMagic1
    dwParams(2) = dwMagic2

    If (GetWindowText_(-9, @dwReturnValue, @dwParams(0)) = 0)

        dwReturnValue = dwDecodedValue

    EndIf

    ProcedureReturn dwReturnValue

EndProcedure

; chronione wartosci PELock'a (nie zmieniaj parametrow)
Macro PELOCK_DWORD(dwValue)
  GetPELockDWORD(dwValue + #PB_Compiler_Line, #PB_Compiler_Line, $11223344, $44332211)
EndMacro

; markery szyfrujace i inne makra

Macro SKIP_START
! DB 0EBh,006h,08Bh,0E4h,08Bh,0C0h,0EBh,0FCh
EndMacro

Macro SKIP_END
! DB 0EBh,006h,08Bh,0C0h,08Bh,0E4h,0EBh,0FAh
EndMacro

Macro DEMO_START
! DB 0EBh,007h,0EBh,0FCh,0EBh,0FAh,0EBh,0FAh,0C7h
EndMacro

Macro DEMO_END
! DB 0EBh,006h,0EBh,0FBh,0EBh,0FAh,0EBh,0FCh,0EBh
! DB 006h,0CDh,020h,0EBh,0FDh,0CDh,020h,0EBh,007h
! DB 0EBh,0FBh,0EBh,0FAh,0EBh,0FCh,0C8h
EndMacro

Macro DEMO_START_MT
! DB 0EBh,007h,0EBh,0FCh,0EBh,0FAh,0EBh,0FAh,0D7h
EndMacro

Macro DEMO_END_MT
! DB 0EBh,006h,0EBh,0FBh,0EBh,0FAh,0EBh,0FCh,0EBh
! DB 006h,0CDh,020h,0EBh,0FDh,0CDh,020h,0EBh,007h
! DB 0EBh,0FBh,0EBh,0FAh,0EBh,0FCh,0D8h
EndMacro

Macro FEATURE_1_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,000h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_2_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,001h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_3_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,002h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_4_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,003h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_5_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,004h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_6_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,005h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_7_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,006h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_8_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,007h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_9_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,008h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_10_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,009h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_11_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,00Ah,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_12_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,00Bh,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_13_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,00Ch,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_14_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,00Dh,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_15_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,00Eh,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_16_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,00Fh,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_17_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,010h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_18_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,011h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_19_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,012h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_20_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,013h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_21_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,014h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_22_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,015h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_23_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,016h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_24_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,017h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_25_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,018h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_26_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,019h,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_27_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,01Ah,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_28_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,01Bh,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_29_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,01Ch,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_30_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,01Dh,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_31_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,01Eh,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_32_START
! DB 0EBh,008h,0EBh,0FCh,0EBh,01Fh,0FAh,0EBh,0FAh,0CAh
EndMacro

Macro FEATURE_END
! DB 0EBh,006h,0EBh,0F1h,0EBh,0F2h,0EBh,0F3h,0EBh
! DB 006h,0CDh,020h,0EBh,0FDh,0CDh,020h,0EBh,007h
! DB 0EBh,0FBh,0EBh,0FAh,0EBh,0FCh,0CAh
EndMacro

Macro FEATURE_1_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,000h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_2_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,001h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_3_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,002h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_4_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,003h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_5_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,004h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_6_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,005h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_7_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,006h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_8_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,007h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_9_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,008h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_10_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,009h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_11_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,00Ah,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_12_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,00Bh,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_13_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,00Ch,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_14_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,00Dh,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_15_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,00Eh,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_16_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,00Fh,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_17_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,010h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_18_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,011h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_19_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,012h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_20_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,013h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_21_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,014h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_22_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,015h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_23_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,016h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_24_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,017h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_25_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,018h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_26_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,019h,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_27_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,01Ah,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_28_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,01Bh,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_29_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,01Ch,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_30_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,01Dh,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_31_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,01Eh,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_32_START_MT
! DB 0EBh,008h,0EBh,0FCh,0EBh,01Fh,0FAh,0EBh,0FAh,0DAh
EndMacro

Macro FEATURE_END_MT
! DB 0EBh,006h,0EBh,0F1h,0EBh,0F2h,0EBh,0F3h,0EBh
! DB 006h,0CDh,020h,0EBh,0FDh,0CDh,020h,0EBh,007h
! DB 0EBh,0FBh,0EBh,0FAh,0EBh,0FCh,0DAh
EndMacro

Macro UNREGISTERED_START
! DB 0EBh,007h,0EBh,002h,0EBh,0FAh,0EBh,001h,0CBh
EndMacro

Macro UNREGISTERED_END
! DB 0EBh,006h,0EBh,004h,0EBh,002h,0EBh,000h,0EBh
! DB 006h,0CDh,022h,0EBh,0FCh,0CDh,022h,0EBh,007h
! DB 0EBh,0FCh,0EBh,0FCh,0EBh,001h,0CBh
EndMacro

Macro UNREGISTERED_START_MT
! DB 0EBh,007h,0EBh,002h,0EBh,0FAh,0EBh,001h,0DBh
EndMacro

Macro UNREGISTERED_END_MT
! DB 0EBh,006h,0EBh,004h,0EBh,002h,0EBh,000h,0EBh
! DB 006h,0CDh,022h,0EBh,0FCh,0CDh,022h,0EBh,007h
! DB 0EBh,0FCh,0EBh,0FCh,0EBh,001h,0DBh
EndMacro

Macro CRYPT_START
! DB 0EBh,007h,0EBh,005h,0EBh,003h,0EBh,001h,0C7h
EndMacro

Macro CRYPT_END
! DB 0EBh,006h,0EBh,000h,0EBh,000h,0EBh,000h,0EBh
! DB 006h,0CDh,020h,0EBh,0FDh,0CDh,020h,0EBh,007h
! DB 0EBh,005h,0EBh,003h,0EBh,001h,0C8h
EndMacro

Macro CRYPT_START_MT
! DB 0EBh,007h,0EBh,005h,0EBh,003h,0EBh,001h,0D7h
EndMacro

Macro CRYPT_END_MT
! DB 0EBh,006h,0EBh,000h,0EBh,000h,0EBh,000h,0EBh
! DB 006h,0CDh,020h,0EBh,0FDh,0CDh,020h,0EBh,007h
! DB 0EBh,005h,0EBh,003h,0EBh,001h,0D8h
EndMacro

Macro CLEAR_START
! DB 0EBh,007h,0EBh,0FCh,0EBh,000h,0EBh,001h,0C9h
EndMacro

Macro CLEAR_END
! DB 0EBh,006h,0EBh,002h,0EBh,0FCh,0EBh,000h,0EBh
! DB 006h,0CDh,021h,0EBh,0FAh,0CDh,021h,0EBh,007h
! DB 0EBh,0FCh,0EBh,0FCh,0EBh,001h,0C9h
EndMacro

Macro CLEAR_START_MT
! DB 0EBh,007h,0EBh,0FCh,0EBh,000h,0EBh,001h,0D9h
EndMacro

Macro CLEAR_END_MT
! DB 0EBh,006h,0EBh,002h,0EBh,0FCh,0EBh,000h,0EBh
! DB 006h,0CDh,021h,0EBh,0FAh,0CDh,021h,0EBh,007h
! DB 0EBh,0FCh,0EBh,0FCh,0EBh,001h,0D9h
EndMacro

Macro FILE_CRYPT_START
! DB 0EBh,007h,0EBh,002h,0EBh,0FCh,0EBh,001h,0CAh
EndMacro

Macro FILE_CRYPT_END
! DB 0EBh,006h,0EBh,0FCh,0EBh,0FCh,0EBh,000h,0EBh
! DB 006h,0CDh,020h,0EBh,0FDh,0CDh,020h,0EBh,007h
! DB 0EBh,0FCh,0EBh,003h,0EBh,0FCh,0CAh
EndMacro

Macro FILE_CRYPT_START_MT
! DB 0EBh,007h,0EBh,002h,0EBh,0FCh,0EBh,001h,0DAh
EndMacro

Macro FILE_CRYPT_END_MT
! DB 0EBh,006h,0EBh,0FCh,0EBh,0FCh,0EBh,000h,0EBh
! DB 006h,0CDh,020h,0EBh,0FDh,0CDh,020h,0EBh,007h
! DB 0EBh,0FCh,0EBh,003h,0EBh,0FCh,0DAh
EndMacro


Macro UNPROTECTED_START
! DB 0EBh,006h,08Bh,0E4h,089h,0EDh,0EBh,0FCh
EndMacro

Macro UNPROTECTED_END
! DB 0EBh,006h,089h,0EDh,08Bh,0E4h,0EBh,0FAh
EndMacro

Macro TRIAL_EXPIRED
! DB 0EBh,008h,000h,011h,022h,033h,033h,022h,011h,000h
EndMacro

Macro TRIAL_TOTAL_EXPIRED
! DB 0EBh,008h,001h,011h,022h,033h,033h,022h,011h,000h
EndMacro

Macro PELOCK_CHECKPOINT
! DB 0EBh,07Eh,00Dh,00Ah,054h,068h,072h,06Fh,075h,067h,068h,020h,074h,068h,065h,020h
! DB 064h,061h,072h,06Bh,020h,06Fh,066h,020h,066h,075h,074h,075h,072h,065h,073h,020h
! DB 070h,061h,073h,074h,021h,00Dh,00Ah,054h,068h,065h,020h,06Dh,061h,067h,069h,063h
! DB 069h,061h,06Eh,020h,06Ch,06Fh,06Eh,067h,073h,020h,074h,06Fh,020h,073h,065h,065h
! DB 021h,00Dh,00Ah,04Fh,06Eh,065h,020h,063h,068h,061h,06Eh,074h,073h,020h,06Fh,075h
! DB 074h,020h,062h,065h,074h,077h,065h,065h,06Eh,020h,074h,077h,06Fh,020h,077h,06Fh
! DB 072h,06Ch,064h,073h,021h,00Dh,00Ah,046h,049h,052h,045h,020h,057h,041h,04Ch,04Bh
! DB 020h,057h,049h,054h,048h,020h,04Dh,045h,021h,00Dh,00Ah,042h,04Fh,042h,00Dh,00Ah
EndMacro

Macro PELOCK_MEMORY_GAP_HELPER
! DD 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
! DD 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
! DD 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
! DD 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
! DD 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
! DD 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
! DD 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
! DD 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
! DD 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
! DD 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
! DD 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
! DD 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
! DD 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
! DD 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
! DD 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
! DD 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
EndMacro

Macro PELOCK_MEMORY_GAP
! DB 0E9h,004h,020h,000h,000h,08Fh,0F1h,012h,034h
PELOCK_MEMORY_GAP_HELPER
PELOCK_MEMORY_GAP_HELPER
PELOCK_MEMORY_GAP_HELPER
PELOCK_MEMORY_GAP_HELPER
EndMacro

Macro PELOCK_WATERMARK
! DB 0EBh,07Eh,044h,06Fh,077h,06Eh,020h,069h,06Eh,020h,074h,068h,065h,020h,070h,061h
! DB 072h,06Bh,00Dh,00Ah,057h,068h,065h,072h,065h,020h,074h,068h,065h,020h,063h,068h
! DB 061h,06Eh,074h,020h,069h,073h,020h,064h,065h,061h,074h,068h,02Ch,020h,064h,065h
! DB 061h,074h,068h,02Ch,020h,064h,065h,061h,074h,068h,00Dh,00Ah,055h,06Eh,074h,069h
! DB 06Ch,020h,074h,068h,065h,020h,073h,075h,06Eh,020h,063h,072h,069h,065h,073h,020h
! DB 06Dh,06Fh,072h,06Eh,069h,06Eh,067h,00Dh,00Ah,044h,06Fh,077h,06Eh,020h,069h,06Eh
! DB 020h,074h,068h,065h,020h,070h,061h,072h,06Bh,020h,077h,069h,074h,068h,020h,066h
! DB 072h,069h,065h,06Eh,064h,073h,020h,06Fh,066h,020h,06Dh,069h,06Eh,065h,00Dh,00Ah
EndMacro

Macro PELOCK_CPUID
! DB 0EBh,07Eh,00Dh,00Ah,00Dh,00Ah,043h,06Fh,06Dh,065h,020h,061h,073h,020h,079h,06Fh
! DB 075h,020h,061h,072h,065h,02Ch,020h,061h,073h,020h,079h,06Fh,075h,020h,077h,065h
! DB 072h,065h,00Dh,00Ah,041h,073h,020h,049h,020h,077h,061h,06Eh,074h,020h,079h,06Fh
! DB 075h,020h,074h,06Fh,020h,062h,065h,00Dh,00Ah,041h,073h,020h,061h,020h,066h,072h
! DB 069h,065h,06Eh,064h,02Ch,020h,061h,073h,020h,061h,020h,066h,072h,069h,065h,06Eh
! DB 064h,00Dh,00Ah,041h,073h,020h,061h,06Eh,020h,06Fh,06Ch,064h,020h,065h,06Eh,065h
! DB 06Dh,079h,00Dh,00Ah,054h,061h,06Bh,065h,020h,079h,06Fh,075h,072h,020h,074h,069h
! DB 06Dh,065h,02Ch,020h,068h,075h,072h,072h,079h,020h,075h,070h,00Dh,00Ah,00Dh,00Ah
EndMacro

Macro PELOCK_INIT_CALLBACK
! DB 0EBh,008h,010h,011h,022h,033h,033h,022h,011h,000h
EndMacro

Macro HARDWARE_ID_CALLBACK
! DB 0EBh,008h,04Fh,05Ah,0F7h,038h,031h,0CDh,0E0h,053h
EndMacro

Macro FEATURE_1_END
  FEATURE_END
EndMacro

Macro FEATURE_2_END
  FEATURE_END
EndMacro

Macro FEATURE_3_END
  FEATURE_END
EndMacro

Macro FEATURE_4_END
  FEATURE_END
EndMacro

Macro FEATURE_5_END
  FEATURE_END
EndMacro

Macro FEATURE_6_END
  FEATURE_END
EndMacro

Macro FEATURE_7_END
  FEATURE_END
EndMacro

Macro FEATURE_8_END
  FEATURE_END
EndMacro

Macro FEATURE_9_END
  FEATURE_END
EndMacro

Macro FEATURE_10_END
  FEATURE_END
EndMacro

Macro FEATURE_11_END
  FEATURE_END
EndMacro

Macro FEATURE_12_END
  FEATURE_END
EndMacro

Macro FEATURE_13_END
  FEATURE_END
EndMacro

Macro FEATURE_14_END
  FEATURE_END
EndMacro

Macro FEATURE_15_END
  FEATURE_END
EndMacro

Macro FEATURE_16_END
  FEATURE_END
EndMacro

Macro FEATURE_17_END
  FEATURE_END
EndMacro

Macro FEATURE_18_END
  FEATURE_END
EndMacro

Macro FEATURE_19_END
  FEATURE_END
EndMacro

Macro FEATURE_20_END
  FEATURE_END
EndMacro

Macro FEATURE_21_END
  FEATURE_END
EndMacro

Macro FEATURE_22_END
  FEATURE_END
EndMacro

Macro FEATURE_23_END
  FEATURE_END
EndMacro

Macro FEATURE_24_END
  FEATURE_END
EndMacro

Macro FEATURE_25_END
  FEATURE_END
EndMacro

Macro FEATURE_26_END
  FEATURE_END
EndMacro

Macro FEATURE_27_END
  FEATURE_END
EndMacro

Macro FEATURE_28_END
  FEATURE_END
EndMacro

Macro FEATURE_29_END
  FEATURE_END
EndMacro

Macro FEATURE_30_END
  FEATURE_END
EndMacro

Macro FEATURE_31_END
  FEATURE_END
EndMacro

Macro FEATURE_32_END
  FEATURE_END
EndMacro

Macro FEATURE_1_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_2_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_3_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_4_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_5_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_6_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_7_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_8_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_9_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_10_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_11_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_12_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_13_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_14_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_15_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_16_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_17_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_18_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_19_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_20_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_21_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_22_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_23_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_24_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_25_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_26_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_27_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_28_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_29_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_30_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_31_END_MT
  FEATURE_END_MT
EndMacro

Macro FEATURE_32_END_MT
  FEATURE_END_MT
EndMacro

; IDE Options = PureBasic 4.10 (Windows - x86)