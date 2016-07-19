////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak sprawdzic obecnosc zabezpieczenia PELock'a
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
	char szUsername[PELOCK_MAX_USERNAME];

	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	//
	// jesli zabezpieczysz aplikacje, procedury sprawdzajace
	// obecnosc zabezpieczenia ZAWSZE beda zwracaly wartosc True,
	// w przeciwym wypadku oznaczaloby to, ze zabezpieczenie
	// zostalo usuniete z pliku przez jego zlamanie/rozpakowanie
	// i mozesz (powinienes), zrobic jedna z ponizszych rzeczy:
	//
	// - zamknij aplikacje (kiedy nie jest to spodziewane,
	//   skorzystaj z procedur timera)
	// - uszkodz jakis obszar pamieci
	// - zainicjalizuj jakies zmienne blednymi wartosciami
	// - wywolaj wyjatki (RaiseException())
	// - spowoduj blad w obliczeniach (jest to bardzo trudne
	//   do wysledzenia dla osoby, ktora probuje zlamac aplikacje,
	//   jesli taka nie do konca zlamana aplikacja zostanie
	//   opublikowana i tak nie bedzie dzialac poprawnie)
	//
	// - NIE WYSWIETLAJ ZADNYCH INFORMACJI, ZE ZABEZPIECZENIE
	//   ZOSTALO USUNIETE, JEST TO NAJGORSZA RZECZ, KTORA
	//   MOZNA ZROBIC, GDYZ POZWALA TO ZNALEZC ODWOLANIA
	//   DO FUNKCJI SPRAWDZAJACYCH I TYM SAMYM ICH USUNIECIE
	//
	// uzyj wyobrazni :)
	//
	if (myPELock.IsPELockPresent5() == FALSE)
	{
		ExitProcess(1);
	}

	//
	// odczytaj dane zarejestrowanego uzytkownika
	//
	DEMO_START

	// odczytaj dane z klucza
	myPELock.GetRegistrationName(szUsername);

	m_Username = szUsername;

	DEMO_END

	//
	// jesli brak klucza licencyjnego ciag m_Username bedzie pusty
	// wiec aplikacja nie jest zarejestrowana
	//
	CRYPT_START

	if (m_Username.IsEmpty())
	{
		m_Username = "Wersja niezarejestrowana";
	}

	CRYPT_END

	// uaktualnij kontrolki (DDE)
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
