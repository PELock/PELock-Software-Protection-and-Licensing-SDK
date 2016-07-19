////////////////////////////////////////////////////////////////////////////////
//
// Przyklad uzycia makr dla funkcji inicjalizujacych PELOCK_INIT_CALLBACK
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

static int dwSecretValue1 = 0;
static int dwSecretValue2 = 0;

//
// funkcje inicjalizujace sa wywolywane tylko raz po uruchomieniu
// aplikacji, moga byc uzywane do inicjalizacji waznych wartosci,
// sa one wywolywane tylko w przypadku zabezpieczonych aplikacji,
// wiec jesli zabezpiecznie zostanie usuniete, te funkcje nie
// zostana wywolane (dodatkowa ochrona przed rozpakowaniem kodu)
//
// funkcje inicjalizujace musza byc gdzies uzywane w kodzie, aby
// kompilator w trakcie optymalizacji ich nie usunal (co zdarza
// sie w wiekszosci przypadkow, gdy kompilator napotka nieuzywane
// funkcje), mozna w takim przypadku skorzystac z prostej sztuczki
// sprawdzajac w dowolnym miejscu aplikacji wskaznik do funkcji
// inicjalizujacej np.:
//
// if ((&pelock_initalization_callback_1 == NULL) return 0;
//
// nalezy rowniez pamietac, ze te funkcje sa wywolywane przed
// kodem inicjalizujacym aplikacje, wiec jesli twoja aplikacja
// polega na dodatkowych bibliotekach (statycznych lub
// dynamicznych), ktore same wymagaja inicjalizacji, upewnij
// sie, zeby funkcje oznaczone PELOCK_INIT_CALLBACK byly proste
// i nie wykorzystywaly dodatkowych bibliotek i ich funkcji
//
extern (Windows) void pelock_initalization_callback_1(HINSTANCE hInstance, DWORD dwReserved)
{
	// znacznik funkcji inicjalizujacej
	mixin(PELOCK_INIT_CALLBACK);

	// funkcje inicjalizujace sa wywolywane tylko jeden raz,
	// wiec mozna dodatkowo wymazac ich kod po wykonaniu,
	// korzystajac z makr CLEAR_START i CLEAR_END
	mixin(CLEAR_START);

	dwSecretValue1 = 2;

	mixin(CLEAR_END);
}

//
// druga funkcja inicjalizujaca, mozna umiescic dowolna liczbe funkcji inicjalizujacych
//
extern (Windows) void pelock_initalization_callback_2(HINSTANCE hInstance, DWORD dwReserved)
{
	// znacznik funkcji inicjalizujacej
	mixin(PELOCK_INIT_CALLBACK);

	// funkcje inicjalizujace sa wywolywane tylko jeden raz,
	// wiec mozna dodatkowo wymazac ich kod po wykonaniu,
	// korzystajac z makr CLEAR_START i CLEAR_END
	mixin(CLEAR_START);

	dwSecretValue2 = 2;

	mixin(CLEAR_END);
}

int main(string args[])
{
	writef("Wynik obliczenia 2 + 2 = %d\n", dwSecretValue1 + dwSecretValue2);

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	// ochrona przed optymalizacjami kompilatora
	if ( (&pelock_initalization_callback_1 == null) || (&pelock_initalization_callback_2 == null) )
	{
		pelock_initalization_callback_1(null, 0);
		pelock_initalization_callback_2(null, 0);
	}

	return 0;
}
