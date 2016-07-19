////////////////////////////////////////////////////////////////////////////////
//
// Setting license key from the memory buffer
//
// Version        : PELock v2.0
// Language       : C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "pelock_setkey.h"
#include "pelock_setkeyDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CPelock_setkeyDlg dialog

CPelock_setkeyDlg::CPelock_setkeyDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CPelock_setkeyDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CPelock_setkeyDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CPelock_setkeyDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPelock_setkeyDlg)
	DDX_Control(pDX, IDC_USERNAME, m_Username);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CPelock_setkeyDlg, CDialog)
	//{{AFX_MSG_MAP(CPelock_setkeyDlg)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPelock_setkeyDlg message handlers

BOOL CPelock_setkeyDlg::OnInitDialog()
{
	CPELock myPELock;
	CFile myKeyfile;
	int dwKeyfile;
	CFileException fileException;
	LPVOID lpBuffer;
	char lpszUsername[PELOCK_MAX_USERNAME];

	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// open keyfile from the A:\ drive
	if (myKeyfile.Open("A:\\key.lic", CFile::modeRead | CFile::typeBinary, &fileException))
	{
		dwKeyfile = myKeyfile.GetLength();

		// check file size
		if (dwKeyfile != 0)
		{
			// allocate memory for keyfile data
			lpBuffer = new byte[myKeyfile.GetLength()];

			// read keyfile into memory buffer
			myKeyfile.Read(lpBuffer, dwKeyfile);

			// set keyfile's data
			myPELock.SetRegistrationData(lpBuffer, dwKeyfile);

			// release memory buffer
			delete [] lpBuffer;
		}

		// close file handle
		myKeyfile.Close();
	}

	// set default registration name (it should be set
	// even without a valid key, so don't put it between DEMO markers)
	CLEAR_START

	strcpy(lpszUsername, "Unregistered version");

	CLEAR_END


	// if there's a valid key, execute code between DEMO markers
	// and set key's owner name, this code should be included only
	// between DEMO markers!!!
	DEMO_START

	// read registration name
	myPELock.GetRegistrationName(lpszUsername);

	DEMO_END


	// finally set registration name, or leave "Unregistered version" string
	CRYPT_START

	m_Username.SetWindowText(lpszUsername);

	CRYPT_END

	// TODO: Add extra initialization here

	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CPelock_setkeyDlg::OnPaint()
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
HCURSOR CPelock_setkeyDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}
