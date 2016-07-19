////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak sprawdzic obecnosc zabezpieczenia PELock'a
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
	// inicjalizuj klase PELock
	PELock myPELock = new PELock;

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

	writef("Sprawdzanie obecnosci zabezpieczenia PELock'a:\n\n");

	if (myPELock.IsPELockPresent1() == TRUE)
	{
		writef("1 metoda - PELock wykryty\n");
	}
	else
	{
		writef("1 metoda - zabezpiecenie PELock'a nie zostalo wykryte!\n");
	}

	if (myPELock.IsPELockPresent2() == TRUE)
	{
		writef("2 metoda - PELock wykryty\n");
	}
	else
	{
		writef("2 metoda - zabezpiecenie PELock'a nie zostalo wykryte!\n");
	}

	if (myPELock.IsPELockPresent3() == TRUE)
	{
		writef("3 metoda - PELock wykryty\n");
	}
	else
	{
		writef("3 metoda - zabezpiecenie PELock'a nie zostalo wykryte!\n");
	}

	if (myPELock.IsPELockPresent4() == TRUE)
	{
		writef("4 metoda - PELock wykryty\n");
	}
	else
	{
		writef("4 metoda - zabezpiecenie PELock'a nie zostalo wykryte!\n");
	}

	if (myPELock.IsPELockPresent5() == TRUE)
	{
		writef("5 metoda - PELock wykryty\n");
	}
	else
	{
		writef("5 metoda - zabezpiecenie PELock'a nie zostalo wykryte!\n");
	}

	if (myPELock.IsPELockPresent6() == TRUE)
	{
		writef("6 metoda - PELock wykryty\n");
	}
	else
	{
		writef("6 metoda - zabezpiecenie PELock'a nie zostalo wykryte!\n");
	}

	if (myPELock.IsPELockPresent7() == TRUE)
	{
		writef("7 metoda - PELock wykryty\n");
	}
	else
	{
		writef("7 metoda - zabezpiecenie PELock'a nie zostalo wykryte!\n");
	}

	if (myPELock.IsPELockPresent8() == TRUE)
	{
		writef("8 metoda - PELock wykryty\n");
	}
	else
	{
		writef("8 metoda - zabezpiecenie PELock'a nie zostalo wykryte!\n");
	}

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
