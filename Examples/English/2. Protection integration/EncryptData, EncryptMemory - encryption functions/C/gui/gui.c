////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use built-in encryption functions (stream cipher)
//
// Version        : PELock v2.0
// Language       : C/C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include <windows.h>
#include <commctrl.h>
#include <stdio.h>
#include <math.h>
#include "gui.h"
#include "pelock.h"

void EncryptDataTest(HWND hDlg)
{
	unsigned char szSecretData[] = "SECRET";
	unsigned char szKey[] = "987654321";

	//
	// Encryption algorithm is constant and it's not going to be
	// changed in the future, so you can use it to encrypt
	// all kind of application files like configs, databases etc.
	//
	MessageBox(hDlg, szSecretData, "Plain string", MB_OK);

	// encrypt data
	EncryptData(szKey, sizeof(szKey), szSecretData, sizeof(szSecretData));

	MessageBox(hDlg, szSecretData, "Encrypted string", MB_OK);

	// decrypt data
	DecryptData(szKey, sizeof(szKey), szSecretData, sizeof(szSecretData));

	MessageBox(hDlg, szSecretData, "Decrypted string", MB_OK);
}

void EncryptMemoryTest(HWND hDlg)
{
	unsigned char szSecretData[] = "SECRET";

	//
	// Encrypt and decrypt memory in the same process. An application
	// running in a different process will not be able to decrypt the
	// data.
	//
	MessageBox(hDlg, szSecretData, "Plain string (testing keyless encryption)", MB_OK);

	// encrypt data
	EncryptMemory(szSecretData, sizeof(szSecretData));

	MessageBox(hDlg, szSecretData, "Encrypted string (keyless encryption)", MB_OK);

	// decrypt data
	DecryptMemory(szSecretData, sizeof(szSecretData));

	MessageBox(hDlg, szSecretData, "Decrypted string (keyless decryption)", MB_OK);
}

BOOL CALLBACK DlgProc(HWND hDlg, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch (uMsg)
	{
		// initialization of main window
		case WM_INITDIALOG:

			SetWindowText(hDlg, "PELock Test");

			return TRUE;

		case WM_COMMAND:

			switch (LOWORD (wParam))
			{
				case IDB_ENCRYPT_DATA:

					EncryptDataTest(hDlg);
					break;

				case IDB_ENCRYPT_MEMORY:

					EncryptMemoryTest(hDlg);
					break;

				case IDCANCEL:

					EndDialog(hDlg, 0);
					break;
			}

			break;
	}

	return FALSE;
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	INITCOMMONCONTROLSEX iccControls = { sizeof(INITCOMMONCONTROLSEX), ICC_WIN95_CLASSES | ICC_DATE_CLASSES };

	// initialize common controls
	InitCommonControlsEx(&iccControls);

	DialogBox(hInstance, MAKEINTRESOURCE(DLG_MAIN), 0, DlgProc);

	return 0;
}
