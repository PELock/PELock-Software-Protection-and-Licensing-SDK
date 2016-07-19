// pelock_trialexecutionsDlg.h : header file
//

#if !defined(AFX_PELOCK_TRIALEXECUTIONSDLG_H__5DC51207_5A9A_11D9_A6F1_0060087D3389__INCLUDED_)
#define AFX_PELOCK_TRIALEXECUTIONSDLG_H__5DC51207_5A9A_11D9_A6F1_0060087D3389__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CPelock_trialexecutionsDlg dialog

class CPelock_trialexecutionsDlg : public CDialog
{
// Construction
public:
	CPelock_trialexecutionsDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CPelock_trialexecutionsDlg)
	enum { IDD = IDD_PELOCK_TRIALEXECUTIONS_DIALOG };
	CButton	m_Continue;
	CProgressCtrl	m_Progress;
	CStatic	m_ExecutionsLeft;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPelock_trialexecutionsDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CPelock_trialexecutionsDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PELOCK_TRIALEXECUTIONSDLG_H__5DC51207_5A9A_11D9_A6F1_0060087D3389__INCLUDED_)
