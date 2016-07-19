////////////////////////////////////////////////////////////////////////////////
//
// ShareIt keygen example
//
// ShareIt SDK    : SDK 3 File Revision 3
// Version        : PELock v2.0
// Language       : C/C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
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

