// pelock_setkey.h : main header file for the PELOCK_SETKEY application
//

#if !defined(AFX_PELOCK_SETKEY_H__AEAA7745_39A3_11D9_A6F0_0060087D3389__INCLUDED_)
#define AFX_PELOCK_SETKEY_H__AEAA7745_39A3_11D9_A6F0_0060087D3389__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CPelock_setkeyApp:
// See pelock_setkey.cpp for the implementation of this class
//

class CPelock_setkeyApp : public CWinApp
{
public:
	CPelock_setkeyApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPelock_setkeyApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CPelock_setkeyApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PELOCK_SETKEY_H__AEAA7745_39A3_11D9_A6F0_0060087D3389__INCLUDED_)
