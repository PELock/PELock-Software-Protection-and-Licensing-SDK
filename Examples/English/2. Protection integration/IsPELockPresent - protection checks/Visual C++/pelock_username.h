// pelock_username.h : main header file for the PELOCK_USERNAME application
//

#if !defined(AFX_PELOCK_USERNAME_H__AB0AE6D5_2F39_11D9_A6F0_0060087D3389__INCLUDED_)
#define AFX_PELOCK_USERNAME_H__AB0AE6D5_2F39_11D9_A6F0_0060087D3389__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CPelock_usernameApp:
// See pelock_username.cpp for the implementation of this class
//

class CPelock_usernameApp : public CWinApp
{
public:
	CPelock_usernameApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPelock_usernameApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CPelock_usernameApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PELOCK_USERNAME_H__AB0AE6D5_2F39_11D9_A6F0_0060087D3389__INCLUDED_)
