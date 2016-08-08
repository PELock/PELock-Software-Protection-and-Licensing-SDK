////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak ustawic klucz licencyjny z danych bufora pamieci
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

// domyslna wartosc
unsigned char name[PELOCK_MAX_USERNAME] = "Wersja niezarejestrowana";
void *keydata = NULL;
int keysize = 0;
FILE *keyfile = NULL;
int dwStatus = 0;

int main(int argc, char *argv[])
{
	// otworz plik zawierajacy dane licencyjne, dane
	// moga byc zapisane gdziekolwiek, np. na kluczu
	// sprzetowym, na dysku cd-rom itd.
	keyfile = fopen("c:\\key.lic", "rb");

	if (keyfile != NULL)
	{
		// ustaw wskaznik pliku na jego koniec
		fseek(keyfile, 0, SEEK_END);

		// rozmiar pliku (biezaca pozycja - koniec pliku)
		keysize = ftell(keyfile);

		// z powrotem ustaw wskaznik na poczatek pliku (offset 0)
		fseek(keyfile, 0, SEEK_SET);

		// sprawdz rozmiar pliku, gdzie sa zapisane dane licencyjne
		if (keysize != 0)
		{
			// zaalokuj pamiec, gdzie odczytamy dane licencyjne
			keydata = malloc(keysize);

			// sprawdz, czy udalo sie zaalokowac pamiec
			if (keydata != NULL)
			{
				// odczytaj zawartosc pliku z danymi licencyjnymi
				if (fread(keydata, keysize, 1, keyfile) != 0)
				{
					// ustaw dane licencyjne poprzez procedure
					// PELock'a, od tej pory wszystkie zabezpieczone
					// fragmenty kodu makrami szyfrujacymi beda
					// dostepne
					dwStatus = SetRegistrationData(keydata, keysize);
				}

				// zwolnij pamiec
				free(keydata);
			}
		}

		// zamknij uchwyt pliku
		fclose(keyfile);
	}

	// niektore kompilatory C (Pelles C, LCC) wymagaja, aby kod korzystajacy z markerow
	// znajdowal sie bezposrednio za klamrami warunkowymi {}, w przeciwnym wypadku
	// zabezpieczona aplikacja moze nie dzialac poprawnie, jest to zwiazane z organizacja
	// stosu przez te kompilatory

	// sprawdz kod bledu z funkcji SetRegistrationKey
	if (dwStatus == 1)
	{
		// jesli plik zawieral poprawne dane licencyjne, odczytaj
		// dane zarejestrowanego uzytkownika
		DEMO_START

		GetRegistrationName(name, sizeof(name));

		DEMO_END
	}

	// wyswietl informacje o rejestracji lub domyslna
	// wiadomosc "Program niezarejestrowany"
	printf("Program zarejestrowany dla %s\n", name);

	printf("\nNacisnij dowolny klawisz, aby kontynuowac . . .\n");

	getch();

	return 0;
}
