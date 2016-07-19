//////////////////////////////////////////////////////////////////////////
//
// Custom compression library header file
//
// Version        : PELock v2.0
// Language       : C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
//////////////////////////////////////////////////////////////////////////

//
// error codes (anything != 0 is treated like an error, so you can define
// your own codes)
//
#define COMPRESSION_OK 0
#define COMPESSION_ERROR_PARAM 1


typedef HINSTANCE (WINAPI *PLOADLIBRARY)(LPCTSTR lpLibFileName);
typedef FARPROC (WINAPI *PGETPROCADDRESS)(HMODULE hModule, LPCSTR lpProcName);
typedef LPVOID (WINAPI *PVIRTUALALLOC)(LPVOID lpAddress, DWORD dwSize, DWORD flAllocationType, DWORD flProtect);
typedef BOOL (WINAPI *PVIRTUALFREE)(LPVOID lpAddress, DWORD dwSize, DWORD dwFreeType);

//
// WinApi procedures available to the decompression routine
//
#pragma pack (1)
typedef struct _DEPACK_INTERFACE {

	PLOADLIBRARY lpLoadLibrary;
	PGETPROCADDRESS lpGetProcAddress;
	PVIRTUALALLOC lpVirtualAlloc;
	PVIRTUALFREE lpVirtualFree;

} DEPACK_INTERFACE, *PDEPACK_INTERFACE;
#pragma pack ()


//
// export helper macro
//
// PELock is very flexible and it can recognize export names in C & C++ format
// (decorated, with or without underscore etc.) but it's recommended to use
// C style export names
//
#define EXPORT_C_STYLE
#ifdef EXPORT_C_STYLE
#define EXPORT extern "C" __declspec(dllexport)
#else
#define EXPORT __declspec(dllexport)
#endif

// callback procedure declaration
typedef DWORD (WINAPI *PCOMPRESSION_PROGRESS)(DWORD dwInputPosition, DWORD dwOutputPosition, DWORD Reserved);
typedef PCOMPRESSION_PROGRESS LPCOMPRESSION_PROGRESS;
