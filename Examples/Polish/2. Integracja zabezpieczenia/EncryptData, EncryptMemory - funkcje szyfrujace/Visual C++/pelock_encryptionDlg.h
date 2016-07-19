// pelock_encryptionDlg.h : header file
//

#if !defined(AFX_PELOCK_ENCRYPTIONDLG_H__AB0AE6D7_2F39_11D9_A6F0_0060087D3389__INCLUDED_)
#define AFX_PELOCK_ENCRYPTIONDLG_H__AB0AE6D7_2F39_11D9_A6F0_0060087D3389__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CPelock_encryptionDlg dialog

class CPelock_encryptionDlg : public CDialog
{
// Construction
public:
	CPelock_encryptionDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CPelock_encryptionDlg)
	enum { IDD = IDD_PELOCK_ENCRYPTION_DIALOG };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPelock_encryptionDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CPelock_encryptionDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnEncryptData();
	afx_msg void OnEncryptMemory();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PELOCK_ENCRYPTIONDLG_H__AB0AE6D7_2F39_11D9_A6F0_0060087D3389__INCLUDED_)
