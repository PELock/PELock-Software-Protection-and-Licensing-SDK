////////////////////////////////////////////////////////////////////////////////
//
// Example of how to check if the key is locked to the hardware identifier
//
// Version        : PELock v2.09
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
	BOOL bIsKeyHardwareIdLocked = FALSE;

	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	DEMO_START

	// is the key locked to the hardware identifier
	bIsKeyHardwareIdLocked = myPELock.IsKeyHardwareIdLocked();

	if (bIsKeyHardwareIdLocked == TRUE)
	{
		m_KeyInfo = "This key is locked to the hardware identifier!";
	}
	else
	{
		m_KeyInfo = "This key is NOT locked to the hardware identifier!";
	}

	DEMO_END

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
