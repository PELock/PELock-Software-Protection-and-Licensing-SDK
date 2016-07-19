// pelock_setkeyDlg.h : header file
//

#if !defined(AFX_PELOCK_SETKEYDLG_H__AEAA7747_39A3_11D9_A6F0_0060087D3389__INCLUDED_)
#define AFX_PELOCK_SETKEYDLG_H__AEAA7747_39A3_11D9_A6F0_0060087D3389__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CPelock_setkeyDlg dialog

class CPelock_setkeyDlg : public CDialog
{
// Construction
public:
	CPelock_setkeyDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CPelock_setkeyDlg)
	enum { IDD = IDD_PELOCK_SETKEY_DIALOG };
	CEdit	m_Username;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPelock_setkeyDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CPelock_setkeyDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PELOCK_SETKEYDLG_H__AEAA7747_39A3_11D9_A6F0_0060087D3389__INCLUDED_)
