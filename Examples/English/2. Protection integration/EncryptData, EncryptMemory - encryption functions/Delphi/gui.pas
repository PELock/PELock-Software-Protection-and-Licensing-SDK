////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use built-in encryption functions (stream cipher)
//
// Version        : PELock v2.0
// Language       : Delphi/Pascal
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

//
// in order to use PELock unit and PELock macros you need to copy its files to
// the application directory or you can add unit and macro's path to the:
//
// Menu -> Tools -> Environment Options -> Library -> Library path
//
unit gui;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, PELock, ExtCtrls;

type
  TfrmMain = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    btnEncryptData: TButton;
    btnEncryptMemory: TButton;
    procedure Button1Click(Sender: TObject);
    procedure btnEncryptDataClick(Sender: TObject);
    procedure btnEncryptMemoryClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  frmMain.Close;
end;

procedure TfrmMain.btnEncryptDataClick(Sender: TObject);
var
  test: string;
  test_len: integer;

  key: string;
  key_len: integer;

  output_size: integer;

begin

  test := 'Sample string';
  test_len := Length(test);

  key := '9876543210';
  key_len := Length(key);

  //
  // Encryption algorithm is constant and it's not going to be
  // changed in the future, so you can use it to encrypt
  // all kind of application files like configs, databases etc.
  //
  Application.MessageBox(PChar(test), 'Plain string', MB_OK);

  output_size := EncryptData(PByteArray(key), key_len, PByteArray(test), test_len);

  Application.MessageBox(PChar(test), 'Encrypted string', MB_OK);

  output_size := DecryptData(PByteArray(key), key_len, PByteArray(test), test_len);

  Application.MessageBox(PChar(test), 'Decrypted string', MB_OK);

end;

procedure TfrmMain.btnEncryptMemoryClick(Sender: TObject);
var
  test: string;
  test_len: integer;

  output_size: integer;

begin

  test := 'Sample string';
  test_len := Length(test);

  //
  // Encrypt and decrypt memory in the same process. An application
  // running in a different process will not be able to decrypt the
  // data.
  //
  Application.MessageBox(PChar(test), 'Plain string (keyless encryption)', MB_OK);

  output_size := EncryptMemory(PByteArray(test), test_len);

  Application.MessageBox(PChar(test), 'Encrypted string (keyless encryption)', MB_OK);

  output_size := DecryptMemory(PByteArray(test), test_len);

  Application.MessageBox(PChar(test), 'Decrypted string (keyless encryption)', MB_OK);

end;

end.
