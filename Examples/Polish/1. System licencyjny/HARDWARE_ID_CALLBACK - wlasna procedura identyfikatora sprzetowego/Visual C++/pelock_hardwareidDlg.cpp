////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak ustawic wlasna procedure callback identyfikatora sprzetowego,
// wykorzystujac makro HARDWARE_ID_CALLBACK
//
// Wersja         : PELock v2.0
// Jezyk          : C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "pelock_hardwareid.h"
#include "pelock_hardwareidDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CPelock_hardwareidDlg dialog

CPelock_hardwareidDlg::CPelock_hardwareidDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CPelock_hardwareidDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CPelock_hardwareidDlg)
	m_HardwareId = _T("");
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CPelock_hardwareidDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPelock_hardwareidDlg)
	DDX_Text(pDX, IDC_HARDWAREID, m_HardwareId);
	DDV_MaxChars(pDX, m_HardwareId, 128);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CPelock_hardwareidDlg, CDialog)
	//{{AFX_MSG_MAP(CPelock_hardwareidDlg)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPelock_hardwareidDlg message handlers

#pragma optimize("", off)
BOOL CPelock_hardwareidDlg::OnInitDialog()
{
	CPELock myPELock;
	char szHardwareId[128];

	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	//
	// aby bylo mozliwe odczytanie identyfikatora sprzetowego
	// wymagane jest choc 1 makro DEMO
	//
	DEMO_START

	szHardwareId[0] = 0;

	DEMO_END

	//
	// odczytaj sprzetowy identyfikator, nie mozna umieszczac tego kodu
	// pomiedzy makrami DEMO, bo bez klucza licencyjnego ten kod bylby
	// nieosiagalny
	//
	CRYPT_START

	myPELock.GetHardwareId(szHardwareId, sizeof(szHardwareId));

	m_HardwareId = szHardwareId;

	UpdateData(FALSE);

	CRYPT_END


	return TRUE;  // return TRUE  unless you set the focus to a control
}
#pragma optimize("", on)

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CPelock_hardwareidDlg::OnPaint()
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
HCURSOR CPelock_hardwareidDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}
