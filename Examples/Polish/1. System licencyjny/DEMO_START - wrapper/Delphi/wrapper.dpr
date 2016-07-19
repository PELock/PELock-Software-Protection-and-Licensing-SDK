////////////////////////////////////////////////////////////////////////////////
//
// Wrapper
//
// Jezeli niemozliwe jest uzycie makr DEMO (lub innych mark szyfrujacych)
// w kodzie wlasnej aplikacji (np. w aplikacji .NET), mozna skorzystac z
// tego kodu do utworzenia programu ladujacego wlasna aplikacje.
//
// Zalecane jest, aby korzystac z tego typu rozwiazan tylko w szczegolnych
// wypadkach, gdy nie ma juz innej mozliwosci na umieszczenie makr
// szyfrujacych we wlasnym kodzie zrodlowym.
//
// Wersja         : PELock v2.0
// Jezyk          : Delphi/Pascal
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

program wrapper;

uses
  Windows, ShellAPI, SysUtils, Clipbrd;

// zalacz zasoby dla wrappera (np. ikona)
//{$R *.RES}

var
  dwFileSize : integer;
  lpFilePtr  : PByteArray;

  hFileHandle: DWORD;
  dwWritten  : DWORD;

  lpTempPath : array[0..512] of char;
  lpTempFile : array[0..512] of char;

  lpSi       : STARTUPINFO;
  lpPi       : PROCESS_INFORMATION;
  bOK        : LongBool;

  siShell    : TShellExecuteInfo;

procedure ShowHardwareInCaseOfInvalidLicense;
var
  szUser: array[0..63] of Char;
  szHardwareId: array[0..63] of Char;
  szInfo: string;

begin

  szUser[0] := Chr(0);
  szHardwareId[0] := Chr(0);
  szInfo := '';

  if GetWindowTextA(HWND(-1), szUser, 63) = 0 then
  begin

    // read hardware id value
    GetWindowTextA(HWND(-4), szHardwareId, 64);

    // copy to clipboard
    Clipboard.AsText := szHardwareId;

    szInfo := Format('%s' + #13#10#13#10 + '(skopiowano do schowka, u¿yj CTRL-V aby go wkleiæ)', [ szHardwareId ]);

    MessageBox(0, PChar(szInfo), 'Twój identyfikator sprzêtowy', MB_ICONINFORMATION);

    ExitProcess(1);

  end;

end;

begin

  // wyswietl identyfikator sprzetowy w przypadku braku klucza licencyjnego
  //ShowHardwareInCaseOfInvalidLicense

  dwFileSize := 0;

  // markery szyfrujace
  {$I DEMO_START.INC}
  asm

  call @get_size
  @org_pos:

  // dane pliku aplikacji (jako zrzut pamieci)
  {$I EXECUTABLE_FILE.INC}

  @get_size:
  pop eax
  mov lpFilePtr,eax
  mov edx,offset @get_size
  sub edx,eax
  mov dwFileSize,edx

  // omin makro DEMO_END, ktore ponownie by zaszyfrowalo nasz plik w pamieci
  jmp @skip_demo_end

  //{$I DEMO_END.INC}
  DB $EB,$06,$EB,$FB,$EB,$FA,$EB,$FC,$EB,$06,$CD,$20,$EB,$FD,$CD,$20,$EB,$07,$EB,$FB,$EB,$FA,$EB,$FC,$C8

  @skip_demo_end:
  end;

  // jesli byla dostepna licencja, dane pliku aplikacji zostana
  // odszyfrowane i rozmiar dwFileSize zostanie ustawiony na
  // rozmiar pliku aplikacji, jesli brak licencji, rozmiar bedzie
  // domyslnie ustawiony na 0
  if (dwFileSize <> 0) then
  begin

    // utworz tymczasowy plik w katalogu %TEMP%
    GetTempPath(512, lpTempPath);
    GetTempFileName(lpTempPath, 'wrp', GetTickCount(), lpTempFile);
    lstrcat(lpTempFile, '.exe');

    hFileHandle := CreateFile(lpTempFile, GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_HIDDEN, 0);

    // sprawdz uchwyt pliku
    if (hFileHandle <> INVALID_HANDLE_VALUE) then
    begin

      // zapisz zawartosc pliku
      WriteFile(hFileHandle, lpFilePtr^, dwFileSize, dwWritten, nil);

      // ustaw koniec pliku (rozmiar)
      SetEndOfFile(hFileHandle);

      // zamknij plik
      CloseHandle(hFileHandle);

      // przygotuj struktury dla utworzenia procesu
      FillChar(lpSi, sizeof(STARTUPINFO), 0);
      FillChar(lpPi, sizeof(PROCESS_INFORMATION), 0);
      lpSi.cb := sizeof(STARTUPINFO);

      // uruchom proces aplikacji
      bOK := CreateProcess(lpTempFile,                         // lpAppName
                           nil,                                // lpCommandLine
                           nil,                                // lpProcAttribs
                           nil,                                // lpThreadAttribs
                           False,                              // bInheritHandles
                           0,                                  // dwCreationFlags
                           nil,                                // lpEnv
                           lpTempPath,                         // lpCurrentDir
                           lpSi,                               // lpStartupInfo
                           lpPi);                              // lpProcessInfo

      // sprawdz stan uruchomienia
      if (bOK <> False) then
      begin

        // zaczekaj, az proces zakonczy dzialanie
        WaitForSingleObject(lpPi.hProcess, INFINITE);

        // zamknij uchwyty procesu
        CloseHandle(lpPi.hProcess);
        CloseHandle(lpPi.hThread);

      end
      else if (GetLastError = 740) then // ERROR_ELEVATION_REQUIRED
      begin

        // prepare startup structures
        FillChar(siShell, sizeof(SHELLEXECUTEINFO), 0);

        siShell.cbSize := sizeof(SHELLEXECUTEINFO);
        siShell.fMask := SEE_MASK_NOCLOSEPROCESS;
        siShell.nShow := SW_SHOWNORMAL;
        siShell.lpFile := lpTempFile;
        siShell.lpDirectory := PChar(ExtractFileDir(lpTempFile));

        // startup process
        if ( ShellExecuteEx(@siShell) = True) then
        begin

          WaitForSingleObject(siShell.hProcess, INFINITE);

        end;

      end;

      // skasuj plik tymczasowy
      DeleteFile(lpTempFile);

    end;


  end;
end.
