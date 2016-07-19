////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use built-in encryption functions (stream cipher)
//
// Version        : PELock v2.0
// Language       : D
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

import std.stdio;
import std.string;
import core.stdc.stdio;
import core.sys.windows.windows;
import PELock;

char[] szSecretData = "SECRET".dup;
char[] szKey = "987654321".dup;

void DUMP_HEX(PBYTE data, DWORD len)
{
	for (DWORD i = 0; i < len; i++)
	{
		writef("%02X ", data[i]);
	}
}

void print_plaintext()
{
	// plain data
	writef("Plain data (string)     : %s\n", szSecretData);
	writef("Plain data (hex)        : ");
	DUMP_HEX(cast(PBYTE)szSecretData.ptr, szSecretData.length);
	writef("\n");
}

void print_encrypted()
{
	writef("\nEncrypted data (hex)    : ");
	DUMP_HEX(cast(PBYTE)szSecretData.ptr, szSecretData.length);
	writef("\n\n");
}

void print_decrypted()
{
	writef("Decrypted data (string) : %s\n", szSecretData);
	writef("Decrypted data (hex)    : ");
	DUMP_HEX(cast(PBYTE)szSecretData.ptr, szSecretData.length);
	writef("\n");
}

int main(string args[])
{
	// initialize PELock class
	PELock myPELock = new PELock;

	//
	// Encryption algorithm is constant and it's not going to be
	// changed in the future, so you can use it to encrypt
	// all kind of application files like configs, databases etc.
	//

	writef("Testing EncryptData() and DecryptData() functions\n");
	writef("-------------------------------------------------\n");

	print_plaintext();

	// encrypt data
	myPELock.EncryptData(szKey.ptr, szKey.length, szSecretData.ptr, szSecretData.length);
	print_encrypted();

	// decrypt data
	myPELock.DecryptData(szKey.ptr, szKey.length, szSecretData.ptr, szSecretData.length);
	print_decrypted();

	//
	// Encrypt and decrypt memory in the same process. An application
	// running in a different process will not be able to decrypt the
	// data.
	//

	writef("\n\nTesting EncryptMemory() and DecryptMemory() functions (keyless)\n");
	writef("-------------------------------------------------------------------\n");
	print_plaintext();

	// encrypt data
	myPELock.EncryptMemory(szSecretData.ptr, szSecretData.length);
	print_encrypted();

	// decrypt data
	myPELock.DecryptMemory(szSecretData.ptr, szSecretData.length);
	print_decrypted();

	writef("\n\nPress any key to exit . . .");

	getchar();

	return 0;
}
