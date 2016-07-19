////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak uzyc wbudowanych funkcji szyfrujacych (szyfr strumieniowy)
//
// Wersja         : PELock v2.0
// Jezyk          : D
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

import std.stdio;
import std.string;
import core.stdc.stdio;
import core.sys.windows.windows;
import PELock;

char[] szSecretData = "SEKRET".dup;
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
	// niezaszyfrowane dane
	writef("Niezaszyfrowane dane (string) : %s\n", szSecretData);
	writef("Niezaszyfrowane dane (hex)    : ");
	DUMP_HEX(cast(PBYTE)szSecretData.ptr, szSecretData.length);
	writef("\n");
}

void print_encrypted()
{
	writef("\nZaszyfrowane dane (hex)       : ");
	DUMP_HEX(cast(PBYTE)szSecretData.ptr, szSecretData.length);
	writef("\n\n");
}

void print_decrypted()
{
	writef("Odszyfrowane dane (string)    : %s\n", szSecretData);
	writef("Odszyfrowane dane (hex)       : ");
	DUMP_HEX(cast(PBYTE)szSecretData.ptr, szSecretData.length);
	writef("\n");
}

int main(string args[])
{
	// inicjalizuj klase PELock
	PELock myPELock = new PELock;

	//
	// Algorytm szyfrujacy jest staly i nie bedzie zmieniany
	// w przyszlosci, wiec mozna bez obaw szyfrowac wszelkiego
	// rodzaju dane aplikacji jak pliki konfiguracyjne, bazy danych etc.
	//

	writef("Testowanie funkcji EncryptData() i DecryptData()\n");
	writef("------------------------------------------------\n");

	print_plaintext();

	// szyfruj dane
	myPELock.EncryptData(szKey.ptr, szKey.length, szSecretData.ptr, szSecretData.length);
	print_encrypted();

	// odszyfruj dane
	myPELock.DecryptData(szKey.ptr, szKey.length, szSecretData.ptr, szSecretData.length);
	print_decrypted();

	//
	// Szyfruj i deszyfruj pamiec w tym samym procesie. Aplikacja
	// uruchomiona w innym procesie nie bedzie w stanie odszyfrowac
	// danych.
	//

	writef("\n\nTestowanie funkcji EncryptMemory() i DecryptMemory() (bez klucza)\n");
	writef("-----------------------------------------------------------------\n");
	print_plaintext();

	// szyfruj dane
	myPELock.EncryptMemory(szSecretData.ptr, szSecretData.length);
	print_encrypted();

	// odszyfruj dane
	myPELock.DecryptMemory(szSecretData.ptr, szSecretData.length);
	print_decrypted();

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
