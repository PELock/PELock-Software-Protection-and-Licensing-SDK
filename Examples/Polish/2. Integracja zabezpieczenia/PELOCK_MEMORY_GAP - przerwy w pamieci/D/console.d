////////////////////////////////////////////////////////////////////////////////
//
// Przyklad wykorzystania makra ochrony pamieci PELOCK_MEMORY_GAP
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
	// makro spowoduje, ze po uruchomieniu aplikacji w pamieci aplikacji
	// zostanie umieszczony obszar niedostepny dla samej aplikacji (jedynie
	// w obszarze makra), stanowi to dodatkowe zabezpieczenie przed zrzucaniem
	// pamieci aplikacji (dumping), makro to nie ma zadnego wplywu na dzialanie
	// aplikacji i moze byc umieszczane w dowolnych punktach programu
	mixin(PELOCK_MEMORY_GAP);

	writef("Witaj swiecie!");

	mixin(CRYPT_END);

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
