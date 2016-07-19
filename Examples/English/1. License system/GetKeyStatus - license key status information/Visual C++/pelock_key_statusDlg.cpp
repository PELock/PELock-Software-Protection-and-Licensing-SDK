////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read license key status information
//
// Version        : PELock v2.0
// Language       : C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "pelock_key_status.h"
#include "pelock_key_statusDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CPelock_key_statusDlg dialog

CPelock_key_statusDlg::CPelock_key_statusDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CPelock_key_statusDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CPelock_key_statusDlg)
	m_KeyInfo = _T("");
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CPelock_key_statusDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPelock_key_statusDlg)
	DDX_Text(pDX, IDC_DAYS, m_KeyInfo);
	DDV_MaxChars(pDX, m_KeyInfo, 256);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CPelock_key_statusDlg, CDialog)
	//{{AFX_MSG_MAP(CPelock_key_statusDlg)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPelock_key_statusDlg message handlers

BOOL CPelock_key_statusDlg::OnInitDialog()
{
	CPELock myPELock;
	int dwKeyStatus = myPELock.PELOCK_KEY_NOT_FOUND;

	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// read license key status information
	dwKeyStatus = myPELock.GetKeyStatus();

	switch (dwKeyStatus)
	{

	//
	// key is valid (so the code between DEMO_START and DEMO_END should be executed)
	//
	case PELOCK_KEY_OK:

		DEMO_START

		m_KeyInfo = "License key is valid.";

		DEMO_END

		break;

	//
	// invalid format of the key (corrupted)
	//
	case PELOCK_KEY_INVALID:

		m_KeyInfo = "License key is invalid (corrupted)!";
		break;

	//
	// license key was on the blocked keys list (stolen)
	//
	case PELOCK_KEY_STOLEN:

		m_KeyInfo = "License key is blocked!";
		break;

	//
	// hardware identifier is different from the one used to encrypt license key
	//
	case PELOCK_KEY_WRONG_HWID:

		m_KeyInfo = "Hardware identifier doesn't match to the license key!";
		break;

	//
	// license key is expired (not active)
	//
	case PELOCK_KEY_EXPIRED:

		m_KeyInfo = "License key is expired!";
		break;

	//
	// license key not found
	//
	case PELOCK_KEY_NOT_FOUND:
	default:

		m_KeyInfo = "License key not found.";
		break;
	}

	UpdateData(FALSE);

	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CPelock_key_statusDlg::OnPaint()
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
HCURSOR CPelock_key_statusDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}
