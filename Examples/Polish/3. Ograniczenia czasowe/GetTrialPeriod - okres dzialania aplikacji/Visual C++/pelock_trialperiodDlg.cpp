////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dane o ograniczeniu czasowym (okres testowy)
//
// Wersja         : PELock v2.0
// Jezyk          : C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "pelock_trialperiod.h"
#include "pelock_trialperiodDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CPelock_trialperiodDlg dialog

CPelock_trialperiodDlg::CPelock_trialperiodDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CPelock_trialperiodDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CPelock_trialperiodDlg)
	m_PeriodEnd = _T("");
	m_PeriodStart = _T("");
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CPelock_trialperiodDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPelock_trialperiodDlg)
	DDX_Text(pDX, IDC_PERIOD_END, m_PeriodEnd);
	DDV_MaxChars(pDX, m_PeriodEnd, 256);
	DDX_Text(pDX, IDC_PERIOD_START, m_PeriodStart);
	DDV_MaxChars(pDX, m_PeriodStart, 256);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CPelock_trialperiodDlg, CDialog)
	//{{AFX_MSG_MAP(CPelock_trialperiodDlg)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPelock_trialperiodDlg message handlers

BOOL CPelock_trialperiodDlg::OnInitDialog()
{
	CPELock myPELock;
	SYSTEMTIME stPeriodStart, stPeriodEnd;

	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// odczytaj dane o ograniczeniu czasowym
	if (myPELock.GetTrialPeriod(&stPeriodStart, &stPeriodEnd) != 0)
	{
		m_PeriodStart.Format("Poczatek okresu %u.%u.%u", stPeriodStart.wDay, stPeriodStart.wMonth, stPeriodStart.wYear);
		m_PeriodEnd.Format("Koniec okresu %u.%u.%u", stPeriodEnd.wDay, stPeriodEnd.wMonth, stPeriodEnd.wYear);
	}
	else
	{
		// kod pelnej wersji
		m_PeriodStart = "Brak ograniczen.";
		m_PeriodEnd = "";
	}

	// update controls
	UpdateData(FALSE);

	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CPelock_trialperiodDlg::OnPaint()
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
HCURSOR CPelock_trialperiodDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}
