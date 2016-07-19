////////////////////////////////////////////////////////////////////////////////
//
// Przyklad wykorzystania makr szyfrujacych FILE_CRYPT_START i FILE_CRYPT_END
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

int main(string args[])
{
	// kod pomiedzy makrami FILE_CRYPT_START i FILE_CRYPT_END bedzie zaszyfrowany
	// w zabezpieczonym pliku (jako klucz szyfrujacy uzyty jest dowolny plik)
	mixin(FILE_CRYPT_START);

	writef("Witaj swiecie!");

	mixin(FILE_CRYPT_END);

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
