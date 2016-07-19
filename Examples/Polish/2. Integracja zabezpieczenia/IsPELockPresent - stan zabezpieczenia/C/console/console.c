////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak sprawdzic obecnosc zabezpieczenia PELock'a
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

int main(int argc, char *argv[])
{
	// jesli zabezpieczysz aplikacje, procedury sprawdzajace
	// obecnosc zabezpieczenia ZAWSZE beda zwracaly wartosc TRUE,
	// w przeciwym wypadku oznaczaloby to, ze zabezpieczenie
	// zostalo usuniete z pliku przez jego zlamanie/rozpakowanie
	// i mozesz (powinienes), zrobic jedna z ponizszych rzeczy:
	//
	// - zamknij aplikacje (kiedy nie jest to spodziewane,
	//   skorzystaj z procedur timera)
	// - uszkodz jakis obszar pamieci
	// - zainicjalizuj jakies zmienne blednymi wartosciami
	// - wywolaj wyjatki (RaiseException())
	// - spowoduj blad w obliczeniach (jest to bardzo trudne
	//   do wysledzenia dla osoby, ktora probuje zlamac aplikacje,
	//   jesli taka nie do konca zlamana aplikacja zostanie
	//   opublikowana i tak nie bedzie dzialac poprawnie)
	//
	// - NIE WYSWIETLAJ ZADNYCH INFORMACJI, ZE ZABEZPIECZENIE
	//   ZOSTALO USUNIETE, JEST TO NAJGORSZA RZECZ, KTORA
	//   MOZNA ZROBIC, GDYZ POZWALA TO ZNALEZC ODWOLANIA
	//   DO FUNKCJI SPRAWDZAJACYCH I TYM SAMYM ICH USUNIECIE
	//
	// uzyj wyobrazni :)

	printf("Sprawdzanie obecnosci zabezpieczenia PELock'a:\n\n");

	if (IsPELockPresent1() == TRUE)
	{
		printf("1 metoda - PELock wykryty\n");
	}
	else
	{
		printf("1 metoda - zabezpiecenie PELock'a nie zostalo wykryte!\n");
	}

	if (IsPELockPresent2() == TRUE)
	{
		printf("2 metoda - PELock wykryty\n");
	}
	else
	{
		printf("2 metoda - zabezpiecenie PELock'a nie zostalo wykryte!\n");
	}

	if (IsPELockPresent3() == TRUE)
	{
		printf("3 metoda - PELock wykryty\n");
	}
	else
	{
		printf("3 metoda - zabezpiecenie PELock'a nie zostalo wykryte!\n");
	}

	if (IsPELockPresent4() == TRUE)
	{
		printf("4 metoda - PELock wykryty\n");
	}
	else
	{
		printf("4 metoda - zabezpiecenie PELock'a nie zostalo wykryte!\n");
	}

	if (IsPELockPresent5() == TRUE)
	{
		printf("5 metoda - PELock wykryty\n");
	}
	else
	{
		printf("5 metoda - zabezpiecenie PELock'a nie zostalo wykryte!\n");
	}

	if (IsPELockPresent6() == TRUE)
	{
		printf("6 metoda - PELock wykryty\n");
	}
	else
	{
		printf("6 metoda - zabezpiecenie PELock'a nie zostalo wykryte!\n");
	}

	if (IsPELockPresent7() == TRUE)
	{
		printf("7 metoda - PELock wykryty\n");
	}
	else
	{
		printf("7 metoda - zabezpiecenie PELock'a nie zostalo wykryte!\n");
	}

	if (IsPELockPresent8() == TRUE)
	{
		printf("8 metoda - PELock wykryty\n");
	}
	else
	{
		printf("8 metoda - zabezpiecenie PELock'a nie zostalo wykryte!\n");
	}

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
