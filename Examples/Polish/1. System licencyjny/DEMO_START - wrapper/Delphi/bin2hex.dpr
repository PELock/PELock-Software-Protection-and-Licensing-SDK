////////////////////////////////////////////////////////////////////////////////
//
// PELock, Bartosz Wojcik
//
// Konwerter binarny (bin -> hex dump)
//
////////////////////////////////////////////////////////////////////////////////

program bin2hex;

uses
  Windows, SysUtils, Dialogs;

var
  hInputFile  : DWORD;
  dwInputFile : integer;

  hOutputFile : DWORD;

  cOneByte    : char;
  szTemp      : string;
  lpTemp      : PChar;

  ofnSelect   : TOpenDialog;

  dwRead      : DWORD;
  dwWritten   : DWORD;

  i, j        : integer;

begin

  // utworz obiekt TOpenDialog
  ofnSelect := TOpenDialog.Create(nil);

  // inicjalizuj dialog wyboru pliku
  ofnSelect.Title := 'Select file to convert';
  ofnSelect.Filter := 'All files (*.*)|*.*';
  ofnSelect.Options := [ofFileMustExist, ofHideReadOnly];

  if (ofnSelect.Execute = False) then Exit;

  // otworz wybrany plik
  hInputFile := CreateFile(PChar(ofnSelect.Files[0]), GENERIC_READ, 0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

  if (hInputFile = INVALID_HANDLE_VALUE) then
  begin
    MessageBox(0, 'Nie mo¿na otworzyæ wybranego pliku!', 'B³¹d', MB_ICONERROR);
    Exit;
  end;

  // check file size
  dwInputFile := GetFileSize(hInputFile, nil);

  if (dwInputFile = 0) then
  begin
    CloseHandle(hInputFile);
    MessageBox(0, 'Wybrany plik jest pusty!', 'B³¹d', MB_ICONERROR);
    Exit;
  end;

  // utworz plik wyjsciowy
  hOutputFile := CreateFile(PChar(ofnSelect.Files[0] + '.inc'), GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);

  if (hOutputFile = INVALID_HANDLE_VALUE) then
  begin
    CloseHandle(hInputFile);
    MessageBox(0, 'Nie mo¿na utworzyæ pliku wyjœciowego!', 'B³¹d', MB_ICONERROR);
    Exit;
  end;

  // konwertuj plik binarny na zrzut pamieci
  j := 0;

  for i := 0 to dwInputFile - 1 do
  begin

    if (j = 16) then j := 0;

    ReadFile(hInputFile, cOneByte, 1, dwRead, nil);

    if (j = 0) then WriteFile(hOutputFile, 'db ', 3, dwWritten, nil);

    szTemp := Format('$%.2X', [Integer(cOneByte)]);

    lpTemp := PChar(szTemp);

    WriteFile(hOutputFile, lpTemp^, 3, dwWritten, nil);

    Inc(j);

    if (j <> 16) and (i <> (dwInputFile - 1)) then WriteFile(hOutputFile, ', ', 2, dwWritten, nil);

    if (j = 16) then WriteFile(hOutputFile, #13#10, 2, dwWritten, nil);

  end;

  // ustaw rozmiar wyjsciowego pliku
  SetEndOfFile(hOutputFile);

  // zamknij uchwyty
  CloseHandle(hInputFile);
  CloseHandle(hOutputFile);

  // zwolnij obiekt TOpenDialog
  ofnSelect.Free;

  // wyswietl informacje
  MessageBox(0, 'Plik zosta³ pomyœlnie przekonwertowany.', 'Zrobione', MB_ICONINFORMATION);
end.
