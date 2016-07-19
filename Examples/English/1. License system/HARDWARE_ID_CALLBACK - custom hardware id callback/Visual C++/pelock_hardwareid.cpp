////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read hardware identifier
//
// Version        : PELock v2.0
// Language       : C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
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

/////////////////////////////////////////////////////////////////////////////
// The one and only CPelock_hardwareidApp object

CPelock_hardwareidApp theApp;

//
// custom hardware id callback
//
// return values:
//
// 1 - hardware identifier successfully generated
// 0 - an error occured, for example when dongle key was
//     not present), please note that any further calls to
//     GetHardwareId() or functions to set/reload
//     registration key locked to hardware id will fail
//     in this case (error codes will be returned)
//
DWORD WINAPI CustomHardwareId(BYTE lpcHardwareId[8])
{
	//
	// copy custom hardware identifier to output buffer (8 bytes)
	//
	// you can create custom hardware identifier from:
	//
	// - dongle (hardware key) hardware identifier
	// - operating system information
	// - etc.
	//
	for (int i = 0; i < 8 ; i++)
	{
		lpcHardwareId[i] = i + 1;
	}

	// return 1 to indicate success
	return 1;
}

/////////////////////////////////////////////////////////////////////////////
// CPelock_hardwareidApp initialization

BOOL CPelock_hardwareidApp::InitInstance()
{
	CPELock myPELock;

	// set our own hardware id callback routine (you need to enable
	// proper option in SDK tab)
	myPELock.SetHardwareIdCallback(&CustomHardwareId);

	// reload registration key (from default locations)
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
