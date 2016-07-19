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
// select project file
//
//////////////////////////////////////////////////////////////////////////

void CKeygeneratorDlg::OnSelect()
{
	// create instance
	CFileDialog fileDlg( TRUE, NULL, NULL, OFN_FILEMUSTEXIST | OFN_HIDEREADONLY, "PELock's Projects (*.plk)|*.plk|All Files (*.*)|*.*||", this);

	// set dialog's caption
	fileDlg.m_ofn.lpstrTitle = "Please select project file";

	// invoke select file dialog
	if ( fileDlg.DoModal() == IDOK)
	{
		CString szProjectFile = fileDlg.GetPathName();

		m_Project.SetWindowText(szProjectFile);
	}
}

//////////////////////////////////////////////////////////////////////////
//
// key generation
//
//////////////////////////////////////////////////////////////////////////

void CKeygeneratorDlg::OnGenerate()
{
	CFileDialog saveDlg(FALSE, "lic", "key.lic", OFN_FILEMUSTEXIST | OFN_HIDEREADONLY, "Keyfile (key.lic)|key.lic||", this);
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
		// fill PELOCK_KEYGEN_PARAMS structure
		//
		///////////////////////////////////////////////////////////////////////////////

		// allocate memory for key data
		lpKeyData = new BYTE[PELOCK_SAFE_KEY_SIZE];

		// read project file path and username
		m_Username.GetWindowText(szUserName);
		m_Project.GetWindowText(szProjectPath);

		// output buffer pointer (it must be large engough)
		kpKeygenParams.lpOutputBuffer = lpKeyData;

		// pointer to the DWORD where key size will be stored
		kpKeygenParams.lpdwOutputSize = &dwKeyDataSize;

		// output key format
		// KEY_FORMAT_BIN - binary key
		// KEY_FORMAT_REG - Windows registry key dump
		// KEY_FORMAT_TXT - text key (in MIME Base64 format)
		kpKeygenParams.dwOutputFormat = KEY_FORMAT_BIN;

		// project file path
		kpKeygenParams.lpszProjectPath = szProjectPath;

		// are we using text buffer with project file contents (instead of project file)?
		kpKeygenParams.bProjectBuffer = FALSE;

		// check update flag, when this option is selected, add user name to
		// the current project file userlist
		kpKeygenParams.bUpdateProject = FALSE;

		// we don't care about update status
		kpKeygenParams.lpbProjectUpdated = NULL;

		// user name pointer
		kpKeygenParams.lpszUsername = szUserName;

		// username length (max. 8192 chars)
		kpKeygenParams.dwUsernameLength = szUserName.GetLength();

		// use hardware id locking
		if (m_HardwareId.GetWindowTextLength() != 0)
		{
			m_HardwareId.GetWindowText(szHardwareId);
			kpKeygenParams.bSetHardwareLock = TRUE;

			// hardware id string
			kpKeygenParams.lpszHardwareId = szHardwareId;
		}
		else
		{
			kpKeygenParams.bSetHardwareLock = FALSE;
			kpKeygenParams.lpszHardwareId = NULL;
		}

		// encrypt user name and custom key fields with hardware id
		kpKeygenParams.bSetHardwareEncryption = FALSE;

		// custom integer values
		if (m_CustomIntegers.GetCheck() == BST_CHECKED)
		{
			// set key integers
			kpKeygenParams.bSetKeyIntegers = TRUE;

			// 16 custom key values
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

		// set key creation date
		if (m_UseCreationDate.GetCheck() == BST_CHECKED)
		{
			// read key expiration date
			m_KeyCreation.GetTime(&stCreationDate);
			kpKeygenParams.bSetKeyCreationDate = TRUE;
		}
		else
		{
			kpKeygenParams.bSetKeyCreationDate = FALSE;
		}

		// set key expiration date
		if (m_UseExpiration.GetCheck() == BST_CHECKED)
		{
			// read key expiration date
			m_KeyExpiration.GetTime(&kpKeygenParams.stKeyExpiration);
			kpKeygenParams.bSetKeyExpirationDate = TRUE;
		}
		else
		{
			kpKeygenParams.bSetKeyCreationDate = FALSE;
		}

		// set feature bits
		if (m_KeyData.GetCheck() == BST_CHECKED)
		{
			// features bits as single bytes
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
		// generate key data
		//
		///////////////////////////////////////////////////////////////////////////////

		dwResult = Keygen(&kpKeygenParams);

		switch (dwResult)
		{
		// key successfully generated
		case KEYGEN_SUCCESS:

			// set dialog's caption
			saveDlg.m_ofn.lpstrTitle = "Save keyfile as";

			// invoke select file dialog
			if (saveDlg.DoModal() == IDOK)
			{
				// create new file
				if (hKeyfile.Open(saveDlg.GetPathName(), CFile::modeCreate | CFile::modeWrite) )
				{
					// write keyfile
					hKeyfile.Write(lpKeyData, dwKeyDataSize);

					// close file
					hKeyfile.Close();

					AfxMessageBox("Key file successfully generated!", MB_ICONINFORMATION);
				}
				else
				{
					AfxMessageBox("Cannot create file " + saveDlg.GetPathName());
				}
			}

			break;

		// invalid input params (or missing params)
		case KEYGEN_INVALID_PARAMS:

			AfxMessageBox("Invalid input params (check PELOCK_KEY_PARAMS structure)!", MB_ICONEXCLAMATION);
			break;

		// invalid project file
		case KEYGEN_INVALID_PROJECT:

			AfxMessageBox("Invalid project file, please check it, maybe it's missing some data!", MB_ICONEXCLAMATION);
			break;

		// out of memory in Keygen() procedure
		case KEYGEN_OUT_MEMORY:

			AfxMessageBox("Out of memory!", MB_ICONEXCLAMATION);
			break;

		// data generation error
		case KEYGEN_DATA_ERROR:

			AfxMessageBox("Error while generating license key data, please contact with author!", MB_ICONEXCLAMATION);
			break;

		// unknown errors
		default:

			AfxMessageBox("Unknown error, please contact with author!", MB_ICONEXCLAMATION);
			break;
		}

		// free keyfile buffer
		delete [] lpKeyData;

	}

}
