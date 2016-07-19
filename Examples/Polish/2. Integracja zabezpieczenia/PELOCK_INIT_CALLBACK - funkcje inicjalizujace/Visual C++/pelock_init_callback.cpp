////////////////////////////////////////////////////////////////////////////////
//
// Przyklad uzycia makr dla funkcji inicjalizujacych PELOCK_INIT_CALLBACK
//
// Wersja         : PELock v2.0
// Jezyk          : C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"

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
void pelock_initalization_callback_1(HINSTANCE hInstance, DWORD dwReserved)
{
	// znacznik funkcji inicjalizujacej
	PELOCK_INIT_CALLBACK

	// funkcje inicjalizujace sa wywolywane tylko jeden raz,
	// wiec mozna dodatkowo wymazac ich kod po wykonaniu,
	// korzystajac z makr CLEAR_START i CLEAR_END
	CLEAR_START

	dwSecretValue1 = 2;

	CLEAR_END
}

//
// druga funkcja inicjalizujaca, mozna umiescic dowolna liczbe funkcji inicjalizujacych
//
void pelock_initalization_callback_2(HINSTANCE hInstance, DWORD dwReserved)
{
	// znacznik funkcji inicjalizujacej
	PELOCK_INIT_CALLBACK

	// funkcje inicjalizujace sa wywolywane tylko jeden raz,
	// wiec mozna dodatkowo wymazac ich kod po wykonaniu,
	// korzystajac z makr CLEAR_START i CLEAR_END
	CLEAR_START

	dwSecretValue2 = 2;

	CLEAR_END
}

int main(int argc, char *argv[])
{
	printf("Wynik obliczenia 2 + 2 = %lu\n", dwSecretValue1 + dwSecretValue2);

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	// ochrona przed optymalizacjami kompilatora
	if ( (&pelock_initalization_callback_1 == NULL) || (&pelock_initalization_callback_2 == NULL) )
	{
		return 0;
	}

	return 0;
}
