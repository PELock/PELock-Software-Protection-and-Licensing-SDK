////////////////////////////////////////////////////////////////////////////////
//
// Przyklad wykorzystania makr zamazujacych kod CLEAR_START i CLEAR_END
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

uint i = 0, j = 0;

void initialize_app()
{
	// kod pomiedzy makrami CLEAR_START i CLEAR_END bedzie zaszyfrowany
	// w zabezpieczonym pliku, po wykonaniu tego kodu, zostanie on
	// zamazany w pamieci, ponowna proba wykonania kodu, spowoduje
	// ze zostanie on ominiety (tak jakby go tam nie bylo)
	mixin(CLEAR_START);

	i = 1;
	j = 2;

	mixin(CLEAR_END);
}

int main(string args[])
{
	// inicjalizuj aplikacje
	initialize_app();

	// kod pomiedzy markerami CRYPT_START i CRYPT_END bedzie zaszyfrowany
	// w zabezpieczonym pliku
	mixin(CRYPT_START);

	writef("Witaj swiecie!");

	mixin(CRYPT_END);

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
