////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use built-in encryption functions (stream cipher)
//
// Version        : PELock v2.0
// Language       : C/C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include "pelock.h"

unsigned char szSecretData[] = "SECRET";
unsigned char szKey[] = "987654321";

#define DUMP_HEX(data, len) { size_t i = 0; for (i = 0; i < len; i++) printf("%02X ", data[i]); }

void print_plaintext(void)
{
	// plain data
	printf("Plain data (string)     : %s\n", szSecretData);
	printf("Plain data (hex)        : ");
	DUMP_HEX(szSecretData, sizeof(szSecretData));
	printf("\n");
}

void print_encrypted(void)
{
	printf("\nEncrypted data (hex)    : ");
	DUMP_HEX(szSecretData, sizeof(szSecretData));
	printf("\n\n");

}

void print_decrypted(void)
{
	printf("Decrypted data (string) : %s\n", szSecretData);
	printf("Decrypted data (hex)    : ");
	DUMP_HEX(szSecretData, sizeof(szSecretData));
	printf("\n");
}

int main(int argc, char *argv[])
{
	//
	// Encryption algorithm is constant and it's not going to be
	// changed in the future, so you can use it to encrypt
	// all kind of application files like configs, databases etc.
	//

	printf("Testing EncryptData() and DecryptData() functions\n");
	printf("-------------------------------------------------\n");
	print_plaintext();

	// encrypt data
	EncryptData(szKey, sizeof(szKey), szSecretData, sizeof(szSecretData));
	print_encrypted();

	// decrypt data
	DecryptData(szKey, sizeof(szKey), szSecretData, sizeof(szSecretData));
	print_decrypted();

	//
	// Encrypt and decrypt memory in the same process. An application
	// running in a different process will not be able to decrypt the
	// data.
	//

	printf("\n\nTesting EncryptMemory() and DecryptMemory() functions (keyless)\n");
	printf("---------------------------------------------------------------\n");
	print_plaintext();

	// encrypt data
	EncryptMemory(szSecretData, sizeof(szSecretData));
	print_encrypted();

	// decrypt data
	DecryptMemory(szSecretData, sizeof(szSecretData));
	print_decrypted();

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;
}
