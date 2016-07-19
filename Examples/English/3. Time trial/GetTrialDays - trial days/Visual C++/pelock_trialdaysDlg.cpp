////////////////////////////////////////////////////////////////////////////////
//
// Example of how to read trial info (number of trial days)
//
// Version        : PELock v2.0
// Language       : C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "pelock_trialdays.h"
#include "pelock_trialdaysDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CPelock_trialdaysDlg dialog

CPelock_trialdaysDlg::CPelock_trialdaysDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CPelock_trialdaysDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CPelock_trialdaysDlg)
	m_TrialInfo = _T("");
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CPelock_trialdaysDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPelock_trialdaysDlg)
	DDX_Text(pDX, IDC_DAYS, m_TrialInfo);
	DDV_MaxChars(pDX, m_TrialInfo, 256);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CPelock_trialdaysDlg, CDialog)
	//{{AFX_MSG_MAP(CPelock_trialdaysDlg)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPelock_trialdaysDlg message handlers

BOOL CPelock_trialdaysDlg::OnInitDialog()
{
	CPELock myPELock;
	int dwTotalDays = 0, dwLeftDays = 0;
	int dwTrialStatus = myPELock.PELOCK_TRIAL_ABSENT;

	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	CLEAR_START

	// get time trial information
	dwTrialStatus = myPELock.GetTrialDays(&dwTotalDays, &dwLeftDays);

	switch(dwTrialStatus)
	{

	//
	// time trial is active
	//
	case myPELock.PELOCK_TRIAL_ACTIVE:

		if (dwLeftDays == 0)
		{
			m_TrialInfo = "This is the last day of your time trial!";
		}
		else
		{
			m_TrialInfo.Format("%u days left out of %u", dwLeftDays, dwTotalDays);
		}

		break;

	//
	// trial expired, display custom nagscreen and close application
	//
	case myPELock.PELOCK_TRIAL_EXPIRED:

		m_TrialInfo = "This version has expired and it will be closed!";

		break;

	//
	// trial options are not enabled for this file
	//
	case myPELock.PELOCK_TRIAL_ABSENT:
	default:

		m_TrialInfo = "No time trial limits.";

		break;
	}

	CLEAR_END

	UpdateData(FALSE);

	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CPelock_trialdaysDlg::OnPaint()
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
HCURSOR CPelock_trialdaysDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}
