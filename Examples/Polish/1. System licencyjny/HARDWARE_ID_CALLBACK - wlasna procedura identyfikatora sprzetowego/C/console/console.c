////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak ustawic wlasna procedure callback identyfikatora sprzetowego,
// wykorzystujac makro HARDWARE_ID_CALLBACK
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

unsigned char hardware_id[PELOCK_MAX_HARDWARE_ID] = { 0 }, name[PELOCK_MAX_USERNAME] = { 0 };

//
// wlasna procedura callback identyfikatora sprzetowego
//
// zwracane wartosci:
//
// 1 - identyfikator sprzetowy poprawnie wygenerowany
// 0 - wystapil blad, przykladowo klucz sprzetowy nie
//     byl obecny), nalezy zauwazyc, ze w tej sytuacji
//     wszystkie wywolania do GetHardwareId() oraz
//     procedur ustawiajacych badz przeladowujacych klucz
//     zablokowany na sprzetowy identyfikator nie beda
//     funkcjonowaly (beda zwracane kody bledow)
//
int custom_hardware_id(unsigned char output[8])
{
	int i = 0;

	// ten marker bedzie uzyty do zlokalizowania procedury custom_hardware_id()
	// (nalezy wczesniej wlaczyc odpowiednia opcje w zakladce SDK)
	HARDWARE_ID_CALLBACK

	//
	// kopiuj wlasny identyfikator sprzetowy do wyjsciowego bufora (8 bajtow)
	//
	// identyfikator sprzetowy moze byc utworzony z:
	//
	// - identyfikatora klucza sprzetowego (dongle)
	// - informacji z systemu operacyjnego
	// - etc.
	//
	for (i = 0; i < 8 ; i++)
	{
		output[i] = i + 1;
	}

	// zwroc 1, co oznacza sukces
	return 1;
}

int main(int argc, char *argv[])
{
	// odczytaj identyfikator sprzetowy do bufora hardware_id
	GetHardwareId(hardware_id, sizeof(hardware_id));

	// aby w ogole mozna bylo skorzystac z funkcji GetHardwareId()
	// wymagane jest, zeby program zawieral chociaz jedno makro DEMO_START
	// lub FEATURE_x_START, bez tego caly system licencyjny bedzie nieaktywny
	DEMO_START

	// odczytaj dane zarejestrowanego uzytkownika
	GetRegistrationName(name, sizeof(name));

	// wyswietl dane zarejestrowanego uzytkownika
	printf("Program zarejestrowany dla %s", name);

	DEMO_END

	// wyswietl sprzetowy identyfikator w przypadku, gdy aplikacja
	// nie jest jeszcze zarejestrowana
	if (strlen(name) == 0)
	{
		printf("Aplikacja niezarejestrowana, przy rejestracji prosze podac ten ID %s", hardware_id);
	}

	printf("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getch();

	return 0;
}
