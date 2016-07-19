////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak uzywac makra szyfrujace DEMO_START i DEMO_END
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
	// kod pomiedzy makrami DEMO_START i DEMO_END bedzie zaszyfrowany
	// w zabezpieczonym pliku i nie bedzie dostepny (wykonany) bez
	// poprawnego klucza licencyjnego
	mixin(DEMO_START);

	writef("Witaj w pelnej wersji mojej aplikacji!");

	mixin(DEMO_END);

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
