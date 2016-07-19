////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read registered user name from the license key
//
// Version        : PELock v2.0
// Language       : C/C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include <windows.h>
#include <string.h>
#include <stdio.h>
#include <conio.h>
#include "pelock.h"

unsigned char name[256] = { 0 };
unsigned char *token = NULL;
unsigned char separators[] = "\r\n";
int i = 0;

int main(int argc, char *argv[])
{
	DEMO_START

	// read registered user name
	GetRegistrationName(name, sizeof(name));

	DEMO_END

	// check registered user name length (0 - key not present)
	if (strlen(name) != 0)
	{
		// split registration name (ignore empty lines)
		token = strtok(name, separators);

		// print all lines (empty lines are not displayed!)
		while (token != NULL)
		{
			printf("Registration line %u = \"%s\"\n", ++i, token);

			token = strtok(NULL, separators);
		}
	}
	else
	{
		printf("Evaluation version");
	}

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;
}
