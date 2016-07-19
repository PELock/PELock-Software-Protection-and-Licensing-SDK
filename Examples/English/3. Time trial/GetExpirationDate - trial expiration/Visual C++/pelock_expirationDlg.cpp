////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read trial info (expiration date)
//
// Version        : PELock v2.0
// Language       : C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "pelock_expiration.h"
#include "pelock_expirationDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CPelock_expirationDlg dialog

CPelock_expirationDlg::CPelock_expirationDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CPelock_expirationDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CPelock_expirationDlg)
	m_Info = _T("");
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CPelock_expirationDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPelock_expirationDlg)
	DDX_Text(pDX, IDC_INFO, m_Info);
	DDV_MaxChars(pDX, m_Info, 512);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CPelock_expirationDlg, CDialog)
	//{{AFX_MSG_MAP(CPelock_expirationDlg)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPelock_expirationDlg message handlers

BOOL CPelock_expirationDlg::OnInitDialog()
{
	CPELock myPELock;
	SYSTEMTIME stExpirationDate;
	int dwTrialStatus = myPELock.PELOCK_TRIAL_ABSENT;

	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	//
	// read trial expiration info
	//
	dwTrialStatus = myPELock.GetExpirationDate(&stExpirationDate);

	switch(dwTrialStatus)
	{
	case myPELock.PELOCK_TRIAL_ACTIVE:

		m_Info.Format("Application v1.0 beta, it will expire on %u/%u/%u", stExpirationDate.wDay, stExpirationDate.wMonth, stExpirationDate.wYear);
		break;

	case myPELock.PELOCK_TRIAL_EXPIRED:

		m_Info = "This application has expired!";
		break;

	case myPELock.PELOCK_TRIAL_ABSENT:
	default:

		m_Info = "Application v1.0 stable release";
		break;
	}

	UpdateData(FALSE);

	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CPelock_expirationDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CPelock_expirationDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}
