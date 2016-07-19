////////////////////////////////////////////////////////////////////////////////
//
// Example of how to check PELock protection presence
//
// Version        : PELock v2.0
// Language       : C/C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include "pelock.h"

int main(int argc, char *argv[])
{
	// check PELock protection (call all functions), you should call it
	// from the procedures that are not used often
	printf("Detect PELock protection presence:\n\n");

	if (IsPELockPresent1() == TRUE)
	{
		printf("1st method - PELock detected\n");
	}
	else
	{
		printf("1st method - PELock protection not found!\n");
	}

	if (IsPELockPresent2() == TRUE)
	{
		printf("2nd method - PELock detected\n");
	}
	else
	{
		printf("2nd method - PELock protection not found!\n");
	}

	if (IsPELockPresent3() == TRUE)
	{
		printf("3rd method - PELock detected\n");
	}
	else
	{
		printf("3rd method - PELock protection not found!\n");
	}

	if (IsPELockPresent4() == TRUE)
	{
		printf("4th method - PELock detected\n");
	}
	else
	{
		printf("4th method - PELock protection not found!\n");
	}

	if (IsPELockPresent5() == TRUE)
	{
		printf("5th method - PELock detected\n");
	}
	else
	{
		printf("5th method - PELock protection not found!\n");
	}

	if (IsPELockPresent6() == TRUE)
	{
		printf("6th method - PELock detected\n");
	}
	else
	{
		printf("6th method - PELock protection not found!\n");
	}

	if (IsPELockPresent7() == TRUE)
	{
		printf("7th method - PELock detected\n");
	}
	else
	{
		printf("7th method - PELock protection not found!\n");
	}

	if (IsPELockPresent8() == TRUE)
	{
		printf("8th method - PELock detected\n");
	}
	else
	{
		printf("8th method - PELock protection not found!\n");
	}

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;
}
