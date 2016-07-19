////////////////////////////////////////////////////////////////////////////////
//
// Wrapper
//
// If you're unable to include DEMO (or any other kind of encryption macro)
// in your source code (for example .NET applications), you can use use
// this template to create wrapped version of your application.
//
// It's recommended to use it only in special cases, when there's no other
// way to include encryption markers in your own source code.
//
// Version        : PELock v2.0
// Language       : Delphi/Pascal
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

program wrapper;

uses
  Windows, ShellAPI, SysUtils, Clipbrd;

// include resources for the wrapper (icon etc.)
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

    szInfo := Format('%s' + #13#10#13#10 + '(copied to the clipboard, use CTRL-V to paste it)', [ szHardwareId ]);

    MessageBox(0, PChar(szInfo), 'Your hardware identifier', MB_ICONINFORMATION);

    ExitProcess(1);

  end;

end;

begin

  // display hardware identifier in case of missing license key
  //ShowHardwareInCaseOfInvalidLicense

  dwFileSize := 0;

  // encryption markers
  {$I DEMO_START.INC}
  asm

  call @get_size
  @org_pos:

  // main executable file (binary dump)
  {$I EXECUTABLE_FILE.INC}

  @get_size:
  pop eax
  mov lpFilePtr,eax
  mov edx,offset @get_size
  sub edx,eax
  mov dwFileSize,edx

  // skip DEMO_END macro, because it would encrypt our file in the memory again
  jmp @skip_demo_end

  //{$I DEMO_END.INC}
  DB $EB,$06,$EB,$FB,$EB,$FA,$EB,$FC,$EB,$06,$CD,$20,$EB,$FD,$CD,$20,$EB,$07,$EB,$FB,$EB,$FA,$EB,$FC,$C8

  @skip_demo_end:
  end;

  if (dwFileSize <> 0) then
  begin

    // create file in %TEMP% directory
    GetTempPath(512, lpTempPath);
    GetTempFileName(lpTempPath, 'wrp', GetTickCount(), lpTempFile);
    lstrcat(lpTempFile, '.exe');

    hFileHandle := CreateFile(lpTempFile, GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_HIDDEN, 0);

    // check file handle
    if (hFileHandle <> INVALID_HANDLE_VALUE) then
    begin

      // write file contents
      WriteFile(hFileHandle, lpFilePtr^, dwFileSize, dwWritten, nil);

      // set end of file
      SetEndOfFile(hFileHandle);

      // close file
      CloseHandle(hFileHandle);

      // prepare startup structures
      FillChar(lpSi, sizeof(STARTUPINFO), 0);
      FillChar(lpPi, sizeof(PROCESS_INFORMATION), 0);
      lpSi.cb := sizeof(STARTUPINFO);

      // startup process
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

      // check process
      if (bOK <> False) then
      begin

        // wait till it ends
        WaitForSingleObject(lpPi.hProcess, INFINITE);

        // close process handles
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

      // delete file
      DeleteFile(lpTempFile);

    end;


  end;
end.
