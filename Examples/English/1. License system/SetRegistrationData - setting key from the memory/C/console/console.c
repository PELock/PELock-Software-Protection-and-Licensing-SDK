////////////////////////////////////////////////////////////////////////////////
//
// Setting license key from the memory buffer
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

// default value
unsigned char name[PELOCK_MAX_USERNAME] = "Evaluation version";
void *keydata = NULL;
int keysize = 0;
FILE *keyfile = NULL;
int dwStatus = 0;

int main(int argc, char *argv[])
{
	// open keyfile
	keyfile = fopen("c:\\key.lic", "rb");

	if (keyfile != NULL)
	{
		// set file pointer at the end of file
		fseek(keyfile, 0, SEEK_END);

		// keyfile size (current file position)
		keysize = ftell(keyfile);

		// set file pointer at the file start (0 offset)
		fseek(keyfile, 0, SEEK_SET);

		// check key size
		if (keysize != 0)
		{
			// allocate memory for the keydata
			keydata = malloc(keysize);

			// check allocated memory pointer
			if (keydata != NULL)
			{
				// read file
				if (fread(keydata, keysize, 1, keyfile) != 0)
				{
					// set license data
					dwStatus = SetRegistrationData(keydata, keysize);
				}

				// release memory
				free(keydata);
			}
		}

		// close file handle
		fclose(keyfile);
	}

	// sometimes it's necessary to enclose DEMO markers within (LCC compiler bug)
	// {} brackets, otherwise code between DEMO markers won't be decrypted
	if (dwStatus == 1)
	{
		DEMO_START

		// get registered user name
		GetRegistrationName(name, sizeof(name));

		DEMO_END
	}

	// show registered user name
	printf("Registered to %s\n", name);

	printf("\nPress any key to exit . . .\n");

	getch();

	return 0;
}
