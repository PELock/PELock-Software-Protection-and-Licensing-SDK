////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak wykorzystac procedure callback systemu ograniczenia czasowego
//
// Wersja         : PELock v2.0
// Jezyk          : C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "pelock_trialcallback.h"
#include "pelock_trialcallbackDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CPelock_trialcallbackApp

BEGIN_MESSAGE_MAP(CPelock_trialcallbackApp, CWinApp)
	//{{AFX_MSG_MAP(CPelock_trialcallbackApp)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG
	ON_COMMAND(ID_HELP, CWinApp::OnHelp)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPelock_trialcallbackApp construction

CPelock_trialcallbackApp::CPelock_trialcallbackApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CPelock_trialcallbackApp object

CPelock_trialcallbackApp theApp;

/////////////////////////////////////////////////////////////////////////////
// CPelock_trialcallbackApp initialization

BOOL CPelock_trialcallbackApp::InitInstance()
{
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

	CPelock_trialcallbackDlg dlg;
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

//
// wstaw do tej procedury kod konczacy program, zamykajacy uchwyty itp.
//
// zwracane wartosci:
//
// 1 - aplikacja zostanie zamknieta
// 0 - aplikacja bedzie dzialac, nawet mimo przekroczenia czasu testowego
//
int TrialExpired()
{
	TRIAL_EXPIRED

	AfxMessageBox("Czas dzia³ania wersji tymczasowej w³aœnie siê zakoñczy³!");
	AfxGetApp()->m_pMainWnd->CloseWindow();

	// or close it by yourself eg. with ExitProcess(0)
	return 1;
}
