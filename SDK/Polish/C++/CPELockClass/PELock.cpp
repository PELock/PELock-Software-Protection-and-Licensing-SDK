////////////////////////////////////////////////////////////////////////////////
//
// Klasa CPELock
//
// Wersja         : PELock v2.09
// Jezyk          : C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "PELock.h"

// wylacz ostrzezenia zwiazane z konwersja typow
#ifdef _MSC_VER
#pragma warning(push)
#pragma warning(disable:4311)
#endif

//////////////////////////////////////////////////////////////////////
// Konstruktor/Destruktor
//////////////////////////////////////////////////////////////////////

CPELock::CPELock()
{
}

CPELock::~CPELock()
{
}

// odczytaj informacje o statusie klucza licencyjnego
int CPELock::GetKeyStatus()
{
	return (::GetWindowText((HWND)-17, NULL, 256));
}

// czy klucz jest zablokowany na sprzetowy identyfikator
BOOL CPELock::IsKeyHardwareIdLocked()
{
	return (::GetWindowText((HWND)-24, NULL, 128));
}

// odczytaj nazwe zarejestrowanego uzytkownika z klucza licencyjnego
int CPELock::GetRegistrationName(LPTSTR szRegistrationName, int nMaxCount)
{
	return (::GetWindowText((HWND)-1, szRegistrationName, nMaxCount));
}

// odczytaj dane rejestracyjne jako tablice bajtow
int CPELock::GetRawRegistrationName(LPVOID lpRegistrationRawName, int nMaxCount)
{
	return (::GetWindowText((HWND)-21, (LPTSTR)lpRegistrationRawName, nMaxCount));
}

// odczytaj nazwe zarejestrowanego uzytkownika z klucza licencyjnego jako CString
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

// ustaw sciezke klucza licencyjnego (inna niz katalog programu)
int CPELock::SetRegistrationKey(LPTSTR szRegistrationKeyPath)
{
	return (::GetWindowText((HWND)-2, szRegistrationKeyPath, 256));
}

// ustaw dane licencyjne z bufora pamieci
int CPELock::SetRegistrationData(LPCVOID lpBuffer, int iSize)
{
	return (::GetWindowText((HWND)-7, (LPTSTR)lpBuffer, iSize));
}

// ustaw dane licencyjne z bufora tekstowego (w formacie MIME Base64)
int CPELock::SetRegistrationText(LPTSTR szRegistrationKey)
{
	return (::GetWindowText((HWND)-22, szRegistrationKey, 0));
}

// deaktywuj biezacy klucz licencyjny, blokuj mozliwosc ustawienia nowego klucza
void CPELock::DisableRegistrationKey(BOOL bPermamentLock)
{
	::GetWindowText((HWND)-14, NULL, bPermamentLock);
}

// przeladuj klucz rejestracyjny z domyslnych lokalizacji
int CPELock::ReloadRegistrationKey()
{
	return ::GetWindowText((HWND)-16, NULL, 256);
}

// odczytaj wartosci zapisane w kluczu licencyjnym
int CPELock::GetKeyData(int iValue)
{
	return (::GetWindowText((HWND)-3, NULL, iValue));
}

// odczytaj wartosci zapisane w kluczu jako bity
BOOL CPELock::IsFeatureEnabled(int iIndex)
{
	return (::GetWindowText((HWND)-6, NULL, iIndex));
}

// odczytaj wartosci liczbowe zapisane w kluczu (od 1-16)
unsigned int CPELock::GetKeyInteger(int iIndex)
{
	return ((unsigned int)::GetWindowText((HWND)-8, NULL, iIndex));
}

// odczytaj sprzetowy identyfikator dla biezacego komputera
int CPELock::GetHardwareId(LPTSTR szHardwareId, int nMaxCount)
{
	return (::GetWindowText((HWND)-4, szHardwareId, nMaxCount));
}

// odczytaj sprzetowy identyfikator dla biezacego komputera jako CString
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

// ustaw procedure callback do czytania wlasnego identyfikatora sprzetowego
int CPELock::SetHardwareIdCallback(LPHARDWARE_ID_CALLBACK lpHardwareIdFunc)
{
	return (::GetWindowText((HWND)-20, (LPTSTR)lpHardwareIdFunc, 256));
}

// odczytaj date wygasniecia klucza licencyjnego
int CPELock::GetKeyExpirationDate(SYSTEMTIME * lpSystemTime)
{
	return (::GetWindowText((HWND)-5, (LPTSTR)lpSystemTime, 256));
}

// odczytaj date utworzenia klucza licencyjnego
int CPELock::GetKeyCreationDate(SYSTEMTIME * lpSystemTime)
{
	return (::GetWindowText((HWND)-15, (LPTSTR)lpSystemTime, 256));
}

// odczytaj czas wykorzystania klucza (od jego ustawienia) */
int CPELock::GetKeyRunningTime(SYSTEMTIME * lpRunningTime)
{
	return (::GetWindowText((HWND)-23, (LPTSTR)lpRunningTime, 256));
}

// odczytaj liczbe dni w okresie testowym
int CPELock::GetTrialDays(int *dwTotalDays, int *dwLeftDays)
{
	return (::GetWindowText((HWND)-10, (LPTSTR)dwTotalDays, (int)dwLeftDays));
}

// odczytaj liczbe uruchomien w okresie testowym
int CPELock::GetTrialExecutions(int *dwTotalExecutions, int *dwLeftExecutions)
{
	return (::GetWindowText((HWND)-11, (LPTSTR)dwTotalExecutions, (int)dwLeftExecutions));
}

// pobierz date wygasniecia aplikacji
int CPELock::GetExpirationDate(SYSTEMTIME * lpExpirationDate)
{
	return (::GetWindowText((HWND)-12, (LPTSTR)lpExpirationDate, 256));
}

// pobierz dane o okresie testowym
int CPELock::GetTrialPeriod(SYSTEMTIME * lpPeriodBegin, SYSTEMTIME * lpPeriodEnd)
{
	return (::GetWindowText((HWND)-13, (LPTSTR)lpPeriodBegin, (int)lpPeriodEnd));
}


//
// wbudowane funkcje szyfrujace
//

// funkcje szyfrujace (szyfr strumieniowy)
int CPELock::EncryptData(LPCVOID lpKey, int dwKeyLen, LPVOID lpBuffer, int nSize)
{
	return ((int)::DeferWindowPos( (HDWP)lpKey, (HWND)-1, (HWND)dwKeyLen, (int)lpBuffer, (int)nSize, 1, 0, 0 ));
}

int CPELock::DecryptData(LPCVOID lpKey, int dwKeyLen, LPVOID lpBuffer, int nSize)
{
	return ((int)::DeferWindowPos( (HDWP)lpKey, (HWND)-1, (HWND)dwKeyLen, (int)lpBuffer, (int)nSize, 0, 0, 0 ));
}

// szyfrowanie danych kluczami dla biezacej sesji procesu
int CPELock::EncryptMemory(LPVOID lpBuffer, int nSize)
{
	return ((int)::DeferWindowPos( NULL, (HWND)-1, NULL, (int)lpBuffer, (int)nSize, 1, 0, 0 ));
}

int CPELock::DecryptMemory(LPVOID lpBuffer, int nSize)
{
	return ((int)::DeferWindowPos( NULL, (HWND)-1, NULL, (int)lpBuffer, (int)nSize, 0, 0, 0 ));
}


//
// funkcje sprawdzania obecnosci zabezpieczenia PELock'a
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
// chronione wartosci PELock'a
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
