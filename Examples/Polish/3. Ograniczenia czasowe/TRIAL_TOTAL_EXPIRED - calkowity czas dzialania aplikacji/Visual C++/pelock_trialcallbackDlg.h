// pelock_trialcallbackDlg.h : header file
//

#if !defined(AFX_PELOCK_TRIALCALLBACKDLG_H__D46952E7_5B94_11D9_A6F1_0060087D3389__INCLUDED_)
#define AFX_PELOCK_TRIALCALLBACKDLG_H__D46952E7_5B94_11D9_A6F1_0060087D3389__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CPelock_trialcallbackDlg dialog

class CPelock_trialcallbackDlg : public CDialog
{
// Construction
public:
	CPelock_trialcallbackDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CPelock_trialcallbackDlg)
	enum { IDD = IDD_PELOCK_TRIALCALLBACK_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPelock_trialcallbackDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CPelock_trialcallbackDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PELOCK_TRIALCALLBACKDLG_H__D46952E7_5B94_11D9_A6F1_0060087D3389__INCLUDED_)
