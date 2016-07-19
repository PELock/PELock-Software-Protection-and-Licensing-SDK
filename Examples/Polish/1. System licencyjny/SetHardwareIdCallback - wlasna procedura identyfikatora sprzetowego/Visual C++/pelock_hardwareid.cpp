////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac identyfikator sprzetowy
//
// Wersja         : PELock v2.0
// Jezyk          : C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "pelock_hardwareid.h"
#include "pelock_hardwareidDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CPelock_hardwareidApp

BEGIN_MESSAGE_MAP(CPelock_hardwareidApp, CWinApp)
	//{{AFX_MSG_MAP(CPelock_hardwareidApp)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG
	ON_COMMAND(ID_HELP, CWinApp::OnHelp)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPelock_hardwareidApp construction

CPelock_hardwareidApp::CPelock_hardwareidApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}

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
DWORD WINAPI CustomHardwareId(BYTE lpcHardwareId[8])
{
	//
	// kopiuj wlasny identyfikator sprzetowy do wyjsciowego bufora (8 bajtow)
	//
	// identyfikator sprzetowy moze byc utworzony z:
	//
	// - identyfikatora klucza sprzetowego (dongle)
	// - informacji z systemu operacyjnego
	// - etc.
	//
	for (int i = 0; i < 8 ; i++)
	{
		lpcHardwareId[i] = i + 1;
	}

	// zwroc 1, co oznacza sukces
	return 1;
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CPelock_hardwareidApp object

CPelock_hardwareidApp theApp;

/////////////////////////////////////////////////////////////////////////////
// CPelock_hardwareidApp initialization

BOOL CPelock_hardwareidApp::InitInstance()
{
	CPELock myPELock;

	// ustaw wlasna procedure callback dla identyfikatora sprzetowego
	// (nalezy wlaczyc odpowiednia opcje w zakladce SDK)
	myPELock.SetHardwareIdCallback(&CustomHardwareId);

	// przeladuj klucz rejestracyjny (z domyslnych lokalizacji)
	myPELock.ReloadRegistrationKey();

	AfxEnableControlContainer();

	// Standard initialization
	// If you are not using these features and wish to reduce the size
	//  of your final executable, you should remove from the following
	//  the specific initialization routines you do not need.

#ifdef _AFXDLL
	Enable3dControls();			// Call this when using MFC in a shared DLL
#else
	Enable3dControlsStatic();	// Call this when linking to MFC statically
#endif

	CPelock_hardwareidDlg dlg;
	m_pMainWnd = &dlg;
	int nResponse = dlg.DoModal();
	if (nResponse == IDOK)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with OK
	}
	else if (nResponse == IDCANCEL)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with Cancel
	}

	// Since the dialog has been closed, return FALSE so that we exit the
	//  application, rather than start the application's message pump.
	return FALSE;
}
