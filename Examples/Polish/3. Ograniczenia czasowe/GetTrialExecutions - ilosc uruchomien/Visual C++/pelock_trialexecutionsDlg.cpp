////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dane o ograniczeniu czasowym (ilosc uruchomien)
//
// Wersja         : PELock v2.0
// Jezyk          : C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "pelock_trialexecutions.h"
#include "pelock_trialexecutionsDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CPelock_trialexecutionsDlg dialog

CPelock_trialexecutionsDlg::CPelock_trialexecutionsDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CPelock_trialexecutionsDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CPelock_trialexecutionsDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CPelock_trialexecutionsDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPelock_trialexecutionsDlg)
	DDX_Control(pDX, IDOK, m_Continue);
	DDX_Control(pDX, IDC_PROGRESS, m_Progress);
	DDX_Control(pDX, IDC_EXECUTIONS_LEFT, m_ExecutionsLeft);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CPelock_trialexecutionsDlg, CDialog)
	//{{AFX_MSG_MAP(CPelock_trialexecutionsDlg)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPelock_trialexecutionsDlg message handlers

BOOL CPelock_trialexecutionsDlg::OnInitDialog()
{
	CPELock myPELock;
	CString myWarning;
	int dwExecsTotal = 0, dwExecsLeft = 0;
	int dwTrialStatus = myPELock.PELOCK_TRIAL_ABSENT;

	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// read time trial information
	dwTrialStatus = myPELock.GetTrialExecutions(&dwExecsTotal, &dwExecsLeft);

	switch (dwTrialStatus)
	{

	//
	// system ograniczenia czasowego jest aktywny
	//
	case myPELock.PELOCK_TRIAL_ACTIVE:

		// display info how many executions left
		if (dwExecsLeft == 0)
		{
			myWarning = "Mozesz przetestowac ta aplikacje po raz ostatni.";
		}
		else
		{
			myWarning.Format("Pozostalo %u uruchomien.", dwExecsLeft);
		}

		m_ExecutionsLeft.SetWindowText(myWarning);

		// update progress bar position
		m_Progress.SetRange(0, dwExecsTotal);
		m_Progress.SetPos(dwExecsLeft);

		break;

	//
	// okres testowy wygasl, wyswietl wlasna informacje i zamknij aplikacje
	// kod zwracany tylko jesli bedzie wlaczona byla opcja
	// "Pozwol aplikacji na dzialanie po wygasnieciu" w przeciwnym wypadku
	// aplikacja jest automatycznie zamykana
	//
	case myPELock.PELOCK_TRIAL_EXPIRED:

		m_ExecutionsLeft.SetWindowText("Ta aplikacja wygasla i bedzie zamknieta!");

		// wylacz button kontynuacji, gdy aplikacja wygasla
		m_Continue.EnableWindow(FALSE);
		break;

	//
	// ograniczenia czasowe nie sa wlaczone dla tej aplikacji
	// lub aplikacja zostala zarejestrowana
	//
	case myPELock.PELOCK_TRIAL_ABSENT:
	default:

		m_ExecutionsLeft.SetWindowText("Brak ograniczen czasowych lub aplikacja zostala zarejestrowana.");
		break;
	}

	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CPelock_trialexecutionsDlg::OnPaint()
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
HCURSOR CPelock_trialexecutionsDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}
