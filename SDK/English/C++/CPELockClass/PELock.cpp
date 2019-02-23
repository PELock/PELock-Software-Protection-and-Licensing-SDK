////////////////////////////////////////////////////////////////////////////////
//
// CPELock class
//
// Version        : PELock v2.09
// Language       : C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "PELock.h"

// disable casting warnings
#ifdef _MSC_VER
#pragma warning(push)
#pragma warning(disable:4311)
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CPELock::CPELock()
{
}

CPELock::~CPELock()
{
}

// get registration key status information
int CPELock::GetKeyStatus()
{
	return (::GetWindowText((HWND)-17, NULL, 256));
}

// is the key locked to the hardware identifier
BOOL CPELock::IsKeyHardwareIdLocked()
{
	return (::GetWindowText((HWND)-24, NULL, 128));
}

// retrieve registration name from license key file
int CPELock::GetRegistrationName(LPTSTR szRegistrationName, int nMaxCount)
{
	return (::GetWindowText((HWND)-1, szRegistrationName, nMaxCount));
}

// get raw registration data (read username as a raw byte array)
int CPELock::GetRawRegistrationName(LPVOID lpRegistrationRawName, int nMaxCount)
{
	return (::GetWindowText((HWND)-21, (LPTSTR)lpRegistrationRawName, nMaxCount));
}

// retrieve registration name from license key file as a CString
#ifdef __AFXSTR_H__
CString CPELock::GetRegistrationName()
{
	CString szRegistrationName = _T("");
	TCHAR *szTemp = new TCHAR[PELOCK_MAX_USERNAME];

	if (szTemp != NULL)
	{
		if (::GetWindowText((HWND)-1, szTemp, PELOCK_MAX_USERNAME) != 0)
		{
			szRegistrationName = szTemp;
		}

		delete [] szTemp;
	}

	return szRegistrationName;
}
#endif

// set license key path
int CPELock::SetRegistrationKey(LPTSTR szRegistrationKeyPath)
{
	return (::GetWindowText((HWND)-2, szRegistrationKeyPath, 256));
}

// set license data from the memory buffer
int CPELock::SetRegistrationData(LPCVOID lpBuffer, int iSize)
{
	return (::GetWindowText((HWND)-7, (LPTSTR)lpBuffer, iSize));
}

// set license data from the text buffer (in MIME Base64 format)
int CPELock::SetRegistrationText(LPTSTR szRegistrationKey)
{
	return (::GetWindowText((HWND)-22, szRegistrationKey, 0));
}

// disable current registration key, do not allow to set a new key again
void CPELock::DisableRegistrationKey(BOOL bPermamentLock)
{
	::GetWindowText((HWND)-14, NULL, bPermamentLock);
}

// reload registration key from the default search locations
int CPELock::ReloadRegistrationKey()
{
	return ::GetWindowText((HWND)-16, NULL, 256);
}

// get user defined key data
int CPELock::GetKeyData(int iValue)
{
	return (::GetWindowText((HWND)-3, NULL, iValue));
}

// get selected bit from key data
BOOL CPELock::IsFeatureEnabled(int iIndex)
{
	return (::GetWindowText((HWND)-6, NULL, iIndex));
}

// get key integers (from 1-16)
unsigned int CPELock::GetKeyInteger(int iIndex)
{
	return ((unsigned int)::GetWindowText((HWND)-8, NULL, iIndex));
}

// get hardware id
int CPELock::GetHardwareId(LPTSTR szHardwareId, int nMaxCount)
{
	return (::GetWindowText((HWND)-4, szHardwareId, nMaxCount));
}

// get hardware id as a CString
#ifdef __AFXSTR_H__
CString CPELock::GetHardwareId()
{
	CString szHardwareId = _T("");
	TCHAR *szTemp = new TCHAR[64];

	if (szTemp != NULL)
	{
		if (::GetWindowText((HWND)-4, szTemp, 64) != 0)
		{
			szHardwareId = szTemp;
		}

		delete [] szTemp;
	}

	return szHardwareId;
}
#endif

// set hardware id callback routine
int CPELock::SetHardwareIdCallback(LPHARDWARE_ID_CALLBACK lpHardwareIdFunc)
{
	return (::GetWindowText((HWND)-20, (LPTSTR)lpHardwareIdFunc, 256));
}

// get key expiration date
int CPELock::GetKeyExpirationDate(SYSTEMTIME * lpSystemTime)
{
	return (::GetWindowText((HWND)-5, (LPTSTR)lpSystemTime, 256));
}

// get key creation date
int CPELock::GetKeyCreationDate(SYSTEMTIME * lpSystemTime)
{
	return (::GetWindowText((HWND)-15, (LPTSTR)lpSystemTime, 256));
}

// get key running time (since it was set)
int CPELock::GetKeyRunningTime(SYSTEMTIME * lpRunningTime)
{
	return (::GetWindowText((HWND)-23, (LPTSTR)lpRunningTime, 256));
}

// get trial days
int CPELock::GetTrialDays(int *dwTotalDays, int *dwLeftDays)
{
	return (::GetWindowText((HWND)-10, (LPTSTR)dwTotalDays, (int)dwLeftDays));
}

// get trial executions
int CPELock::GetTrialExecutions(int *dwTotalExecutions, int *dwLeftExecutions)
{
	return (::GetWindowText((HWND)-11, (LPTSTR)dwTotalExecutions, (int)dwLeftExecutions));
}

// get expiration date
int CPELock::GetExpirationDate(SYSTEMTIME * lpExpirationDate)
{
	return (::GetWindowText((HWND)-12, (LPTSTR)lpExpirationDate, 256));
}

// get trial period
int CPELock::GetTrialPeriod(SYSTEMTIME * lpPeriodBegin, SYSTEMTIME * lpPeriodEnd)
{
	return (::GetWindowText((HWND)-13, (LPTSTR)lpPeriodBegin, (int)lpPeriodEnd));
}


//
// built-in encryption functions
//

// encryption functions (stream cipher)
int CPELock::EncryptData(LPCVOID lpKey, int dwKeyLen, LPVOID lpBuffer, int nSize)
{
	return ((int)::DeferWindowPos( (HDWP)lpKey, (HWND)-1, (HWND)dwKeyLen, (int)lpBuffer, (int)nSize, 1, 0, 0 ));
}

int CPELock::DecryptData(LPCVOID lpKey, int dwKeyLen, LPVOID lpBuffer, int nSize)
{
	return ((int)::DeferWindowPos( (HDWP)lpKey, (HWND)-1, (HWND)dwKeyLen, (int)lpBuffer, (int)nSize, 0, 0, 0 ));
}

// encrypt memory with current session keys
int CPELock::EncryptMemory(LPVOID lpBuffer, int nSize)
{
	return ((int)::DeferWindowPos( NULL, (HWND)-1, NULL, (int)lpBuffer, (int)nSize, 1, 0, 0 ));
}

int CPELock::DecryptMemory(LPVOID lpBuffer, int nSize)
{
	return ((int)::DeferWindowPos( NULL, (HWND)-1, NULL, (int)lpBuffer, (int)nSize, 0, 0, 0 ));
}


//
// check PELock's protection presence
//

BOOL CPELock::IsPELockPresent1()
{
	return ( GetAtomName(0, NULL, 256) == 1 ? TRUE : FALSE );
}

BOOL CPELock::IsPELockPresent2()
{
	return ( LockFile(NULL, 128, 0, 512, 0) == 1 ? TRUE : FALSE );
}

BOOL CPELock::IsPELockPresent3()
{
	return ( MapViewOfFile(NULL, FILE_MAP_COPY, 0, 0, 1024) != NULL ? TRUE : FALSE );
}

BOOL CPELock::IsPELockPresent4()
{
	return ( SetWindowRgn(NULL, NULL, FALSE) == 1 ? TRUE : FALSE );
}

BOOL CPELock::IsPELockPresent5()
{
	return ( GetWindowRect(NULL, NULL) == 1 ? TRUE : FALSE );
}

BOOL CPELock::IsPELockPresent6()
{
	return ( GetFileAttributes(NULL) == 1 ? TRUE : FALSE );
}

BOOL CPELock::IsPELockPresent7()
{
	return ( GetFileTime(NULL, NULL, NULL, NULL) == 1 ? TRUE : FALSE );
}

BOOL CPELock::IsPELockPresent8()
{
	return ( SetEndOfFile(NULL) == 1 ? TRUE : FALSE );
}


//
// PELock's protected constants
//

#ifdef PELOCK_DWORD_CLASS

DWORD CPELock::PELOCK_DWORD(DWORD dwValue, DWORD dwRandomizer, DWORD dwMagic1, DWORD dwMagic2)
{
	DWORD dwReturnValue = 0, dwParams[3] = { 0 };
	DWORD dwDecodedValue = dwValue - dwRandomizer;

	dwParams[0] = dwDecodedValue;
	dwParams[1] = dwMagic1;
	dwParams[2] = dwMagic2;

	if (GetWindowText( (HWND)-9, (LPTSTR)&dwReturnValue, (int)&dwParams[0]) != 0)
	{
		return dwReturnValue;
	}

	return dwDecodedValue;
}

#endif

#ifdef _MSC_VER
#pragma warning(pop)
#endif
