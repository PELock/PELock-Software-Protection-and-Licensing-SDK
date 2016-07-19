// keygeneratorDlg.h : header file
//

#if !defined(AFX_KEYGENERATORDLG_H__22CD5807_2CF6_11D9_A6F0_0060087D3389__INCLUDED_)
#define AFX_KEYGENERATORDLG_H__22CD5807_2CF6_11D9_A6F0_0060087D3389__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CKeygeneratorDlg dialog

class CKeygeneratorDlg : public CDialog
{
// Construction
public:
	CKeygeneratorDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CKeygeneratorDlg)
	enum { IDD = IDD_KEYGENERATOR_DIALOG };
	CButton	m_UseCreationDate;
	CDateTimeCtrl	m_KeyCreation;
	CButton	m_CustomIntegers;
	CEdit	m_KeyInteger8;
	CEdit	m_KeyInteger7;
	CEdit	m_KeyInteger6;
	CEdit	m_KeyInteger5;
	CEdit	m_KeyInteger4;
	CEdit	m_KeyInteger3;
	CEdit	m_KeyInteger2;
	CEdit	m_KeyInteger1;
	CButton	m_KeyData;
	CEdit	m_Data4;
	CEdit	m_Data3;
	CEdit	m_Data2;
	CEdit	m_Data1;
	CEdit	m_HardwareId;
	CButton	m_UseExpiration;
	CDateTimeCtrl	m_KeyExpiration;
	CEdit	m_Username;
	CEdit	m_Project;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CKeygeneratorDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CKeygeneratorDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnSelect();
	afx_msg void OnGenerate();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_KEYGENERATORDLG_H__22CD5807_2CF6_11D9_A6F0_0060087D3389__INCLUDED_)
