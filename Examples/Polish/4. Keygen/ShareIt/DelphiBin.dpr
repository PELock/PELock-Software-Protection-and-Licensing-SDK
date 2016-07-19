////////////////////////////////////////////////////////////////////////////////
//
// Generator kluczy dla systemu ShareIt
//
// ShareIt SDK    : SDK 3 File Revision 3
// Wersja         : PELock v2.0
// Jezyk          : Delphi/Pascal
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

program DelphiEXE;

// console application
{$APPTYPE CONSOLE}

uses
  KeyIntf in 'KeyIntf.pas',
  KeyUser in 'KeyUser.pas';

begin
  TMyKeyGen.Run;;
end.

