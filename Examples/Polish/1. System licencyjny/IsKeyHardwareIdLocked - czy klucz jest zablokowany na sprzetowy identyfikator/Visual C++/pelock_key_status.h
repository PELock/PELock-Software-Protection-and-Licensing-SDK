// pelock_key_status.h : main header file for the PELOCK_KEY_STATUS application
//

#if !defined(AFX_PELOCK_KEY_STATUS_H__C0E5C2C5_5AAF_11D9_A6F1_0060087D3389__INCLUDED_)
#define AFX_PELOCK_KEY_STATUS_H__C0E5C2C5_5AAF_11D9_A6F1_0060087D3389__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CPelock_key_statusApp:
// See pelock_key_status.cpp for the implementation of this class
//

class CPelock_key_statusApp : public CWinApp
{
public:
	CPelock_key_statusApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPelock_key_statusApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CPelock_key_statusApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PELOCK_KEY_STATUS_H__C0E5C2C5_5AAF_11D9_A6F1_0060087D3389__INCLUDED_)
