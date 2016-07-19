////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak uzyc wbudowanych funkcji szyfrujacych (szyfr strumieniowy)
//
// Wersja         : PELock v2.0
// Jezyk          : C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "pelock_encryption.h"
#include "pelock_encryptionDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CPelock_encryptionDlg dialog

CPelock_encryptionDlg::CPelock_encryptionDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CPelock_encryptionDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CPelock_encryptionDlg)
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CPelock_encryptionDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPelock_encryptionDlg)
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CPelock_encryptionDlg, CDialog)
	//{{AFX_MSG_MAP(CPelock_encryptionDlg)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_ENCRYPT_DATA, OnEncryptData)
	ON_BN_CLICKED(IDC_ENCRYPT_MEMORY, OnEncryptMemory)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPelock_encryptionDlg message handlers

#pragma optimize("", off)
BOOL CPelock_encryptionDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// update dialog's controls (DDE)
	UpdateData(FALSE);

	return TRUE;  // return TRUE  unless you set the focus to a control
}
#pragma optimize("", on)

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CPelock_encryptionDlg::OnPaint()
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
HCURSOR CPelock_encryptionDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

void CPelock_encryptionDlg::OnEncryptData() 
{
	CPELock myPELock;

	unsigned char szSecretData[] = "SECRET";
	unsigned char szKey[] = "987654321";
	
	//
	// Algorytm szyfrujacy jest staly i nie bedzie zmieniany
	// w przyszlosci, wiec mozna bez obaw szyfrowac wszelkiego
	// rodzaju dane aplikacji jak pliki konfiguracyjne, bazy danych etc.
	//
	MessageBox((const char *)szSecretData, "Niezaszyfrowany string", MB_OK);
	
	// encrypt data
	myPELock.EncryptData(szKey, sizeof(szKey), szSecretData, sizeof(szSecretData));
	
	MessageBox((const char *)szSecretData, "Zaszyfrowany string", MB_OK);
	
	// decrypt data
	myPELock.DecryptData(szKey, sizeof(szKey), szSecretData, sizeof(szSecretData));
	
	MessageBox((const char *)szSecretData, "Odszyfrowany string", MB_OK);
}

void CPelock_encryptionDlg::OnEncryptMemory() 
{
	CPELock myPELock;

	unsigned char szSecretData[] = "SECRET";
	
	//
	// Szyfruj i deszyfruj pamiec w tym samym procesie. Aplikacja
	// uruchomiona w innym procesie nie bedzie w stanie odszyfrowac
	// danych.
	//
	MessageBox((const char *)szSecretData, "Niezaszyfrowany string (testowanie szyfrowania bez klucza)", MB_OK);
	
	// encrypt data
	myPELock.EncryptMemory(szSecretData, sizeof(szSecretData));
	
	MessageBox((const char *)szSecretData, "Zaszyfrowany string (szyfrowanie bez klucza)", MB_OK);
	
	// decrypt data
	myPELock.DecryptMemory(szSecretData, sizeof(szSecretData));
	
	MessageBox((const char *)szSecretData, "Odszyfrowany string (deszyfrowania bez klucza)", MB_OK);

	
}
