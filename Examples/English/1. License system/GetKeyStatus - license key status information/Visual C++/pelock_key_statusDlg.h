// pelock_key_statusDlg.h : header file
//

#if !defined(AFX_PELOCK_KEY_STATUSDLG_H__C0E5C2C7_5AAF_11D9_A6F1_0060087D3389__INCLUDED_)
#define AFX_PELOCK_KEY_STATUSDLG_H__C0E5C2C7_5AAF_11D9_A6F1_0060087D3389__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CPelock_key_statusDlg dialog

class CPelock_key_statusDlg : public CDialog
{
// Construction
public:
	CPelock_key_statusDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CPelock_key_statusDlg)
	enum { IDD = IDD_PELOCK_KEY_STATUS_DIALOG };
	CString	m_KeyInfo;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPelock_key_statusDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CPelock_key_statusDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PELOCK_KEY_STATUSDLG_H__C0E5C2C7_5AAF_11D9_A6F1_0060087D3389__INCLUDED_)
