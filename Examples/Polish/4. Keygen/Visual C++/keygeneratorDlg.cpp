////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use keygen library to generate license keys
//
// Version        : PELock v2.0
// Language       : C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "keygenerator.h"
#include "keygeneratorDlg.h"
#include "keygen.h"

#pragma comment(lib, "keygen.lib")

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CKeygeneratorDlg dialog

CKeygeneratorDlg::CKeygeneratorDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CKeygeneratorDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CKeygeneratorDlg)
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CKeygeneratorDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CKeygeneratorDlg)
	DDX_Control(pDX, IDC_CREATION, m_UseCreationDate);
	DDX_Control(pDX, IDC_KEYCREATION, m_KeyCreation);
	DDX_Control(pDX, IDC_KEY_INTEGERS, m_CustomIntegers);
	DDX_Control(pDX, IDC_INT_8, m_KeyInteger8);
	DDX_Control(pDX, IDC_INT_7, m_KeyInteger7);
	DDX_Control(pDX, IDC_INT_6, m_KeyInteger6);
	DDX_Control(pDX, IDC_INT_5, m_KeyInteger5);
	DDX_Control(pDX, IDC_INT_4, m_KeyInteger4);
	DDX_Control(pDX, IDC_INT_3, m_KeyInteger3);
	DDX_Control(pDX, IDC_INT_2, m_KeyInteger2);
	DDX_Control(pDX, IDC_INT_1, m_KeyInteger1);
	DDX_Control(pDX, IDC_KEYDATA, m_KeyData);
	DDX_Control(pDX, IDC_DATA4, m_Data4);
	DDX_Control(pDX, IDC_DATA3, m_Data3);
	DDX_Control(pDX, IDC_DATA2, m_Data2);
	DDX_Control(pDX, IDC_DATA1, m_Data1);
	DDX_Control(pDX, IDC_HARDWAREID, m_HardwareId);
	DDX_Control(pDX, IDC_EXPIRATION, m_UseExpiration);
	DDX_Control(pDX, IDC_KEYEXPIRATION, m_KeyExpiration);
	DDX_Control(pDX, IDC_USERNAME, m_Username);
	DDX_Control(pDX, IDC_PROJECT, m_Project);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CKeygeneratorDlg, CDialog)
	//{{AFX_MSG_MAP(CKeygeneratorDlg)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_SELECT, OnSelect)
	ON_BN_CLICKED(IDC_GENERATE, OnGenerate)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CKeygeneratorDlg message handlers

BOOL CKeygeneratorDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// TODO: Add extra initialization here
	SetDlgItemInt(IDC_DATA1, 1);
	SetDlgItemInt(IDC_DATA2, 2);
	SetDlgItemInt(IDC_DATA3, 3);
	SetDlgItemInt(IDC_DATA4, 4);

	SetDlgItemInt(IDC_INT_1, 1);
	SetDlgItemInt(IDC_INT_2, 2);
	SetDlgItemInt(IDC_INT_3, 3);
	SetDlgItemInt(IDC_INT_4, 4);
	SetDlgItemInt(IDC_INT_5, 5);
	SetDlgItemInt(IDC_INT_6, 6);
	SetDlgItemInt(IDC_INT_7, 7);
	SetDlgItemInt(IDC_INT_8, 8);

	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CKeygeneratorDlg::OnPaint()
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
HCURSOR CKeygeneratorDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

//////////////////////////////////////////////////////////////////////////
//
// pozwol uzytkownikowi wybrac plik projektu, dla ktorego zostana
// wygenerowane klucze licencyjne
//
//////////////////////////////////////////////////////////////////////////

void CKeygeneratorDlg::OnSelect()
{
	// inicjalizuj okno wyboru plikow
	CFileDialog fileDlg( TRUE, NULL, NULL, OFN_FILEMUSTEXIST | OFN_HIDEREADONLY, "Pliki Projektu PELocka (*.plk)|*.plk|Wszystkie Pliki (*.*)|*.*||", this);

	// ustaw nazwe okienka z wyborem plikow
	fileDlg.m_ofn.lpstrTitle = "Wybierz plik projektu";

	// wyswietl okno z wyborem plikow
	if ( fileDlg.DoModal() == IDOK)
	{
		CString szProjectFile = fileDlg.GetPathName();

		m_Project.SetWindowText(szProjectFile);
	}
}

//////////////////////////////////////////////////////////////////////////
//
// tworzenie klucza
//
//////////////////////////////////////////////////////////////////////////

void CKeygeneratorDlg::OnGenerate()
{
CFileDialog saveDlg(FALSE, "lic", "key.lic", OFN_FILEMUSTEXIST | OFN_HIDEREADONLY, "Klucze licencyjne (key.lic)|key.lic||", this);
CString szUserName, szProjectPath, szHardwareId;

PBYTE lpKeyData = NULL;
DWORD dwKeyDataSize = 0;
unsigned int dwStatus = 0, dwAdditionalData = 0;
CFile hKeyfile;
KEYGEN_PARAMS kpKeygenParams;
DWORD dwResult = 0;

	if (m_Project.GetWindowTextLength() != 0 && m_Username.GetWindowTextLength() != 0)
	{
		///////////////////////////////////////////////////////////////////////////////
		//
		// wypelnij strukture PELOCK_KEYGEN_PARAMS
		//
		///////////////////////////////////////////////////////////////////////////////

		// zaalokuj pamiec potrzebna do utworzenia klucza licencyjnego
		lpKeyData = new BYTE[PELOCK_SAFE_KEY_SIZE];

		// odczytaj sciezke pliku projektu oraz nazwe uzytkownika
		m_Username.GetWindowText(szUserName);
		m_Project.GetWindowText(szProjectPath);

		// wskaznik do bufora wyjsciowego na klucz licencyjny (musi byc odpowiednio duzy)
		kpKeygenParams.lpOutputBuffer = lpKeyData;

		// wskaznik do wartosci DWORD, gdzie zostanie zapisany rozmiar wygenerowanego klucza
		kpKeygenParams.lpdwOutputSize = &dwKeyDataSize;

		// wyjsciowy format klucza
		// KEY_FORMAT_BIN - binarny klucz
		// KEY_FORMAT_REG - klucz w formie zrzutu rejestru Windows
		// KEY_FORMAT_TXT - klucz tekstowy (w formacie MIME Base64)
		kpKeygenParams.dwOutputFormat = KEY_FORMAT_BIN;

		// sciezka do odpowiedniego pliku projektu
		kpKeygenParams.lpszProjectPath = szProjectPath;

		// czy uzywamy tekstowego bufora z zawartoscia pliku projektu (zamiast samego pliku projektu)?
		kpKeygenParams.bProjectBuffer = FALSE;

		// czy automatycznie dodac uzytkownika, dla ktorego generowany jest klucz do pliku projektu?
		kpKeygenParams.bUpdateProject = FALSE;

		// wskaznik do wartosci BOOL, gdzie zostanie zapisany status czy udalo sie dodac uzytkownika do pliku projektu
		kpKeygenParams.lpbProjectUpdated = NULL;

		// wskaznik do nazwy uzytkownika (lub innych danych licencyjnych, moga to byc dane binarne etc.)
		kpKeygenParams.lpszUsername = szUserName;

		// rozmiar nazwy uzytkownika lub innych danych licencyjnych (max. 8192 znakow/bajtow)
		kpKeygenParams.dwUsernameLength = szUserName.GetLength();

		// czy korzystac z blokady na sprzetowy identyfikator?
		if (m_HardwareId.GetWindowTextLength() != 0)
		{
			m_HardwareId.GetWindowText(szHardwareId);
			kpKeygenParams.bSetHardwareLock = TRUE;

			// ciag znakow identyfikatora sprzetowego
			kpKeygenParams.lpszHardwareId = szHardwareId;
		}
		else
		{
			kpKeygenParams.bSetHardwareLock = FALSE;
			kpKeygenParams.lpszHardwareId = NULL;
		}

		// czy zaszyfrowac nazwe uzytkownika i dodatkowe pola klucza wedlug identyfikatora sprzetowego
		kpKeygenParams.bSetHardwareEncryption = FALSE;

		// czy ustawic dodatkowe wartosci liczbowe w kluczu licencyjnym
		if (m_CustomIntegers.GetCheck() == BST_CHECKED)
		{
			// ustaw dodatkowe wartosci liczbowe w kluczu
			kpKeygenParams.bSetKeyIntegers = TRUE;

			// 16 dodatkowych wartosci liczbowych, ktore zostana zapisane w kluczu (jesli byla ustawiona flaga)
			kpKeygenParams.dwKeyIntegers[0] = GetDlgItemInt(IDC_INT_1);
			kpKeygenParams.dwKeyIntegers[1] = GetDlgItemInt(IDC_INT_2);
			kpKeygenParams.dwKeyIntegers[2] = GetDlgItemInt(IDC_INT_3);
			kpKeygenParams.dwKeyIntegers[3] = GetDlgItemInt(IDC_INT_4);
			kpKeygenParams.dwKeyIntegers[4] = GetDlgItemInt(IDC_INT_5);
			kpKeygenParams.dwKeyIntegers[5] = GetDlgItemInt(IDC_INT_6);
			kpKeygenParams.dwKeyIntegers[6] = GetDlgItemInt(IDC_INT_7);
			kpKeygenParams.dwKeyIntegers[7] = GetDlgItemInt(IDC_INT_8);
			kpKeygenParams.dwKeyIntegers[8] = GetDlgItemInt(IDC_INT_9);
			kpKeygenParams.dwKeyIntegers[9] = GetDlgItemInt(IDC_INT_10);
			kpKeygenParams.dwKeyIntegers[10] = GetDlgItemInt(IDC_INT_11);
			kpKeygenParams.dwKeyIntegers[11] = GetDlgItemInt(IDC_INT_12);
			kpKeygenParams.dwKeyIntegers[12] = GetDlgItemInt(IDC_INT_13);
			kpKeygenParams.dwKeyIntegers[13] = GetDlgItemInt(IDC_INT_14);
			kpKeygenParams.dwKeyIntegers[14] = GetDlgItemInt(IDC_INT_15);
			kpKeygenParams.dwKeyIntegers[15] = GetDlgItemInt(IDC_INT_16);
		}
		else
		{
			kpKeygenParams.bSetKeyIntegers = FALSE;
		}

		// czy ustawic date utworzenia klucza licencyjnego
		if (m_UseCreationDate.GetCheck() == BST_CHECKED)
		{
			// odczytaj i ustaw date utworzenia klucza
			m_KeyCreation.GetTime(&kpKeygenParams.stKeyCreation);
			kpKeygenParams.bSetKeyCreationDate = TRUE;
		}
		else
		{
			kpKeygenParams.bSetKeyCreationDate = FALSE;
		}

		// czy ustawic date wygasniecia klucza licencyjnego
		if (m_UseExpiration.GetCheck() == BST_CHECKED)
		{
			// odczytaj i ustaw date wygasniecia klucza
			m_KeyExpiration.GetTime(&kpKeygenParams.stKeyExpiration);
			kpKeygenParams.bSetKeyExpirationDate = TRUE;
		}
		else
		{
			kpKeygenParams.bSetKeyCreationDate = FALSE;
		}

		// czy ustawic dodatkowe opcje bitowe (m.in. obsluga sekcji FEATURE_x_START)
		if (m_KeyData.GetCheck() == BST_CHECKED)
		{
			// dodatkowe opcje bitowe jako 4 bajty
			kpKeygenParams.dwKeyData1 = (BYTE)GetDlgItemInt(IDC_DATA1);
			kpKeygenParams.dwKeyData2 = (BYTE)GetDlgItemInt(IDC_DATA2);
			kpKeygenParams.dwKeyData3 = (BYTE)GetDlgItemInt(IDC_DATA3);
			kpKeygenParams.dwKeyData4 = (BYTE)GetDlgItemInt(IDC_DATA4);

			kpKeygenParams.bSetFeatureBits = TRUE;
		}
		else
		{
			kpKeygenParams.bSetFeatureBits = FALSE;
		}

		///////////////////////////////////////////////////////////////////////////////
		//
		// utworz klucz licencyjny
		//
		///////////////////////////////////////////////////////////////////////////////

		dwResult = Keygen(&kpKeygenParams);

		switch (dwResult)
		{
		// klucz licencyjny poprawnie wygenerowany
		case KEYGEN_SUCCESS:

			// ustaw tytul okienka z wyborem, gdzie ma byc zapisany klucz
			saveDlg.m_ofn.lpstrTitle = "Zapisz klucz jako";

			// wyswietl okno
			if ( saveDlg.DoModal() == IDOK)
			{
				// utworz na dysku nowy plik
				if (hKeyfile.Open(saveDlg.GetPathName(), CFile::modeCreate | CFile::modeWrite) )
				{
					// zapisz dane licencyjne do pliku
					hKeyfile.Write(lpKeyData, dwKeyDataSize);

					// zamknij uchwyt pliku
					hKeyfile.Close();

					AfxMessageBox("Klucz licencyjny zostal poprawnie wygenerowany!", MB_ICONINFORMATION);
				}
				else
				{
					AfxMessageBox("Nie mozna utworzyc pliku klucza licencyjnego " + saveDlg.GetPathName());
				}
			}

			break;

		// nieprawidlowe parametry wejsciowe (lub brakujace parametry)
		case KEYGEN_INVALID_PARAMS:

			AfxMessageBox("Niepoprawne parametry wejsciowe (sprawdz strukture PELOCK_KEY_PARAMS)!", MB_ICONEXCLAMATION);
			break;

		// nieprawidlowy plik projektu
		case KEYGEN_INVALID_PROJECT:

			AfxMessageBox("Nieprawidlowy plik projektu, byc moze jest on uszkodzony!", MB_ICONEXCLAMATION);
			break;

		// blad alokacji pamieci w procedurze Keygen()
		case KEYGEN_OUT_MEMORY:

			AfxMessageBox("Zabraklo pamieci do wygenerowania klucza!", MB_ICONEXCLAMATION);
			break;

		// blad generacji danych klucza licencyjnego
		case KEYGEN_DATA_ERROR:

			AfxMessageBox("Wystapil blad podczas generowania danych licencyjnych, prosze skontaktowac sie z autorem!", MB_ICONEXCLAMATION);
			break;

		// nieznane bledy
		default:

			AfxMessageBox("Nieznany blad, prosze skontaktowac sie z autorem!", MB_ICONEXCLAMATION);
			break;
		}

		// zwolnij pamiec
		delete [] lpKeyData;

	}

}
