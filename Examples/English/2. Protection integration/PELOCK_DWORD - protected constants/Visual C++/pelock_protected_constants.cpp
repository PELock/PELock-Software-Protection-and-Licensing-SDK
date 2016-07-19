////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use PELock's protected constants
//
// Version        : PELock v2.0
// Language       : C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"

// CPELock class declaration
CPELock g_PELock;

int main(int argc, char* argv[])
{

	for (unsigned int i = 0; i < g_PELock.PELOCK_DWORD(5); i++)
	{
		printf("Iteration no. %u\n", i);
	}

	unsigned int x = g_PELock.PELOCK_DWORD(100) + g_PELock.PELOCK_DWORD(200);

	printf("Result = %u\n", x);

	printf("\n\nPress any key to exit . . .");

	getch();

	return 0;

}
