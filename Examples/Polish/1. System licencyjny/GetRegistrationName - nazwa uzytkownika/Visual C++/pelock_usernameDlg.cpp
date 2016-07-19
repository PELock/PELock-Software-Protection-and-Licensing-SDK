////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak odczytac dane zarejestrowanego uzytkownika z klucza licencyjnego
//
// Wersja         : PELock v2.0
// Jezyk          : C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "pelock_username.h"
#include "pelock_usernameDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CPelock_usernameDlg dialog

CPelock_usernameDlg::CPelock_usernameDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CPelock_usernameDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CPelock_usernameDlg)
	m_Username = _T("");
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CPelock_usernameDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPelock_usernameDlg)
	DDX_Text(pDX, IDC_USERNAME, m_Username);
	DDV_MaxChars(pDX, m_Username, 1024);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CPelock_usernameDlg, CDialog)
	//{{AFX_MSG_MAP(CPelock_usernameDlg)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPelock_usernameDlg message handlers

#pragma optimize("", off)
BOOL CPelock_usernameDlg::OnInitDialog()
{
	CPELock myPELock;
	char szUsername[512];

	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	//
	// odczytaj i ustaw nazwe zarejestrowanego uzytkownika, kod pomiedzy
	// markerami DEMO, wiec nie wykona sie bez klucza licencyjnego
	//
	DEMO_START

	// odczytaj nazwe zarejestrowanego uzytkownika z klucza
	myPELock.GetRegistrationName(szUsername, 512);

	m_Username = szUsername;

	DEMO_END


	//
	// jesli nie ma klucza licencyjnego, zmienna m_Username bedzie pusta
	// i mozemy zalozyc, ze aplikacja jest niezarejestrowana
	//
	CRYPT_START

	if (m_Username.IsEmpty())
	{
		m_Username = "Aplikacja niezarejstrowana";
	}

	CRYPT_END

	// update dialog's controls (DDE)
	UpdateData(FALSE);

	return TRUE;  // return TRUE  unless you set the focus to a control
}
#pragma optimize("", on)

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CPelock_usernameDlg::OnPaint()
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
HCURSOR CPelock_usernameDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}
