// pelock_trialcallback.h : main header file for the PELOCK_TRIALCALLBACK application
//

#if !defined(AFX_PELOCK_TRIALCALLBACK_H__D46952E5_5B94_11D9_A6F1_0060087D3389__INCLUDED_)
#define AFX_PELOCK_TRIALCALLBACK_H__D46952E5_5B94_11D9_A6F1_0060087D3389__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CPelock_trialcallbackApp:
// See pelock_trialcallback.cpp for the implementation of this class
//

class CPelock_trialcallbackApp : public CWinApp
{
public:
	CPelock_trialcallbackApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPelock_trialcallbackApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CPelock_trialcallbackApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PELOCK_TRIALCALLBACK_H__D46952E5_5B94_11D9_A6F1_0060087D3389__INCLUDED_)
