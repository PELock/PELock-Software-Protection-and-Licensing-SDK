// pelock_usernameDlg.h : header file
//

#if !defined(AFX_PELOCK_USERNAMEDLG_H__AB0AE6D7_2F39_11D9_A6F0_0060087D3389__INCLUDED_)
#define AFX_PELOCK_USERNAMEDLG_H__AB0AE6D7_2F39_11D9_A6F0_0060087D3389__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CPelock_usernameDlg dialog

class CPelock_usernameDlg : public CDialog
{
// Construction
public:
	CPelock_usernameDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CPelock_usernameDlg)
	enum { IDD = IDD_PELOCK_USERNAME_DIALOG };
	CString	m_Username;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPelock_usernameDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CPelock_usernameDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PELOCK_USERNAMEDLG_H__AB0AE6D7_2F39_11D9_A6F0_0060087D3389__INCLUDED_)
