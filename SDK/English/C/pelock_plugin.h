////////////////////////////////////////////////////////////////////////////////
//
// Plugin interface description for PELock v2.0 by Bartosz Wójcik
//
// Language       : C/C++
// Support e-mail : support@pelock.com
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#ifndef __PELOCK_PLUGIN__
#define __PELOCK_PLUGIN__

#define PLUGIN_INTERFACE_VERSION 1		// interface version


//
// procedure prototypes
//
typedef void (__stdcall * PE_MEMCPY)(void * restrict s1, const void * restrict s2, size_t n);
typedef void (__stdcall * PE_MEMSET)(void *s, int c, size_t n);

typedef size_t (__stdcall * PE_STRLEN)(const char *s);
typedef char * (__stdcall * PE_STRCPY)(char * restrict s1, const char * restrict s2);
typedef char * (__stdcall * PE_STRCAT)(char * restrict s1, const char * restrict s2);

typedef char * (__stdcall * PE_DEBUGGER_DETECTED)(void);

typedef BOOL (__stdcall * PE_GETVERSIONEXA) (LPOSVERSIONINFO lpVersionInformation);

typedef HMODULE (__stdcall * PE_GETMODULEHANDLEA) (LPCTSTR lpModuleName);
typedef DWORD (__stdcall * PE_GETMODULEFILENAMEA) (HMODULE hModule, LPTSTR lpFilename, DWORD nSize);

typedef HINSTANCE (__stdcall * PE_LOADLIBRARYA) (LPCTSTR lpLibFileName);
typedef BOOL (__stdcall * PE_FREELIBRARY) (HMODULE hLibModule);
typedef FARPROC (__stdcall * PE_GETPROCADDRESS) (HMODULE hModule, LPCSTR lpProcName);

typedef LPVOID (__stdcall * PE_VIRTUALALLOC) (LPVOID lpAddress, DWORD dwSize, DWORD flAllocationType, DWORD flProtect);
typedef BOOL (__stdcall * PE_VIRTUALFREE) (LPVOID lpAddress, DWORD dwSize, DWORD dwFreeType);

typedef int (__stdcall * PE_MESSAGEBOXA) (HWND hWnd, LPCTSTR lpText, LPCTSTR lpCaption, UINT uType);
typedef int (__cdecl * PE_WSPRINTFA) (LPTSTR lpOut, LPCTSTR lpFmt, ...);

typedef HANDLE (__stdcall * PE_CREATETHREAD) (LPSECURITY_ATTRIBUTES lpThreadAttributes, DWORD dwStackSize, LPTHREAD_START_ROUTINE lpStartAddress, LPVOID lpParameter, DWORD dwCreationFlags, LPDWORD lpThreadId);
typedef VOID (__stdcall * PE_SLEEP) (DWORD dwMilliseconds);

typedef VOID (__stdcall * PE_EXITPROCESS) (UINT uExitCode);


//
// plugin interface for external code
//
typedef struct _PLUGIN_INTERFACE {

// internal data
	PBYTE			pe_delta;		// virtual address of plugin code
	DWORD			pe_size;		// plugin's code size in bytes

	HMODULE			pe_imagebase;		// module imagebase
	DWORD			pe_imagesize;		// image size
	DWORD			pe_temp;		// (for your usage)

// memory manipulation
	PE_MEMCPY		pe_memcpy;		// __stdcall void *memcpy(void * restrict s1, const void * restrict s2, size_t n);
	PE_MEMSET		pe_memset;		// __stdcall void *memset(void *s, int c, size_t n);

// string functions
	PE_STRLEN		pe_strlen;		// __stdcall size_t strlen(const char *s)
	PE_STRCPY		pe_strcpy;		// __stdcall char *strcpy(char * restrict s1, const char * restrict s2);
	PE_STRCAT		pe_strcat;		// __stdcall char *strcat(char * restrict s1, const char * restrict s2);

// debugger detected procedure
	PE_DEBUGGER_DETECTED	pe_debugger_detected;	// __stdcall void debugger_detected();

// standard WinApi functions
	PE_GETVERSIONEXA	pe_GetVersionExA;	// BOOL GetVersionEx(LPOSVERSIONINFO lpVersionInformation);

	PE_GETMODULEHANDLEA	pe_GetModuleHandleA;	// HMODULE GetModuleHandle(LPCTSTR lpModuleName);
	PE_GETMODULEFILENAMEA	pe_GetModuleFileNameA;	// DWORD GetModuleFileName(HMODULE hModule, LPTSTR lpFilename, DWORD nSize);

	PE_LOADLIBRARYA		pe_LoadLibraryA;	// HINSTANCE LoadLibrary(LPCTSTR lpLibFileName);
	PE_FREELIBRARY		pe_FreeLibrary;		// BOOL FreeLibrary(HMODULE hLibModule);
	PE_GETPROCADDRESS	pe_GetProcAddress;	// FARPROC GetProcAddress(HMODULE hModule, LPCSTR lpProcName);

	PE_VIRTUALALLOC		pe_VirtualAlloc;	// LPVOID VirtualAlloc(LPVOID lpAddress, DWORD dwSize, DWORD flAllocationType, DWORD flProtect);
	PE_VIRTUALFREE		pe_VirtualFree;		// BOOL VirtualFree(LPVOID lpAddress, DWORD dwSize, DWORD dwFreeType);

	PE_MESSAGEBOXA		pe_MessageBoxA;		// int MessageBox(HWND hWnd, LPCTSTR lpText, LPCTSTR lpCaption, UINT uType);
	PE_WSPRINTFA		pe_wsprintfA;		// int wsprintf(LPTSTR lpOut, LPCTSTR lpFmt, ...);

	PE_CREATETHREAD		pe_CreateThread;	// HANDLE CreateThread(LPSECURITY_ATTRIBUTES lpThreadAttributes, DWORD dwStackSize, LPTHREAD_START_ROUTINE lpStartAddress, LPVOID lpParameter, DWORD dwCreationFlags, LPDWORD lpThreadId);
	PE_SLEEP		pe_Sleep;		// VOID Sleep(DWORD dwMilliseconds);

	PE_EXITPROCESS		pe_ExitProcess;		// VOID ExitProcess(UINT uExitCode);

} PLUGIN_INTERFACE, *PPLUGIN_INTERFACE;

#endif // __PELOCK_PLUGIN__