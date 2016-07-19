// pelock_expirationDlg.h : header file
//

#if !defined(AFX_PELOCK_EXPIRATIONDLG_H__4D4DFA87_5AA5_11D9_A6F1_0060087D3389__INCLUDED_)
#define AFX_PELOCK_EXPIRATIONDLG_H__4D4DFA87_5AA5_11D9_A6F1_0060087D3389__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CPelock_expirationDlg dialog

class CPelock_expirationDlg : public CDialog
{
// Construction
public:
	CPelock_expirationDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CPelock_expirationDlg)
	enum { IDD = IDD_PELOCK_EXPIRATION_DIALOG };
	CString	m_Info;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPelock_expirationDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CPelock_expirationDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PELOCK_EXPIRATIONDLG_H__4D4DFA87_5AA5_11D9_A6F1_0060087D3389__INCLUDED_)
