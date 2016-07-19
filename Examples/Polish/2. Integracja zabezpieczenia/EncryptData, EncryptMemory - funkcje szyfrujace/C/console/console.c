////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak uzyc wbudowanych funkcji szyfrujacych (szyfr strumieniowy)
//
// Wersja         : PELock v2.0
// Jezyk          : C/C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include "pelock.h"

unsigned char szSecretData[] = "SEKRET";
unsigned char szKey[] = "987654321";

#define DUMP_HEX(data, len) { size_t i = 0; for (i = 0; i < len; i++) printf("%02X ", data[i]); }

void print_plaintext(void)
{
	// niezaszyfrowane dane
	printf("Niezaszyfrowane dane (string) : %s\n", szSecretData);
	printf("Niezaszyfrowane dane (hex)    :");
	DUMP_HEX(szSecretData, sizeof(szSecretData));
	printf("\n");
}

void print_encrypted(void)
{
	printf("\nZaszyfrowane dane (hex)       : ");
	DUMP_HEX(szSecretData, sizeof(szSecretData));
	printf("\n\n");

}

void print_decrypted(void)
{
	printf("Odszyfrowane dane (string)    : %s\n", szSecretData);
	printf("Odszyfrowane dane (hex)       : ");
	DUMP_HEX(szSecretData, sizeof(szSecretData));
	printf("\n");
}

int main(int argc, char *argv[])
{
	//
	// Algorytm szyfrujacy jest staly i nie bedzie zmieniany
	// w przyszlosci, wiec mozna bez obaw szyfrowac wszelkiego
	// rodzaju dane aplikacji jak pliki konfiguracyjne, bazy danych etc.
	//

	printf("Testowanie funkcji EncryptData() i DecryptData()\n");
	printf("------------------------------------------------\n");
	print_plaintext();

	// szyfruj dane
	EncryptData(szKey, sizeof(szKey), szSecretData, sizeof(szSecretData));
	print_encrypted();

	// odszyfruj dane
	DecryptData(szKey, sizeof(szKey), szSecretData, sizeof(szSecretData));
	print_decrypted();

	//
	// Szyfruj i deszyfruj pamiec w tym samym procesie. Aplikacja
	// uruchomiona w innym procesie nie bedzie w stanie odszyfrowac
	// danych.
	//

	printf("\n\nTestowanie funkcji EncryptMemory() i DecryptMemory() (bez klucza)\n");
	printf("-----------------------------------------------------------------\n");
	print_plaintext();

	// szyfruj dane
	EncryptMemory(szSecretData, sizeof(szSecretData));
	print_encrypted();

	// odszyfruj dane
	DecryptMemory(szSecretData, sizeof(szSecretData));
	print_decrypted();

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
