////////////////////////////////////////////////////////////////////////////////
//
// Przyklad biblioteki kompresji uzytkownika
//
// Wersja         : PELock v2.0
// Jezyk          : C++
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

//
// kody bledow (wszystko != 0 bedzie traktowane jako blad, mozna definiowac wlasne kody
// bledow, gdyz w przypadku bledu beda one zalogowane, w glowym oknie logujacym)
//
#define COMPRESSION_OK 0
#define COMPESSION_ERROR_PARAM 1


typedef HINSTANCE (WINAPI *PLOADLIBRARY)(LPCTSTR lpLibFileName);
typedef FARPROC (WINAPI *PGETPROCADDRESS)(HMODULE hModule, LPCSTR lpProcName);
typedef LPVOID (WINAPI *PVIRTUALALLOC)(LPVOID lpAddress, DWORD dwSize, DWORD flAllocationType, DWORD flProtect);
typedef BOOL (WINAPI *PVIRTUALFREE)(LPVOID lpAddress, DWORD dwSize, DWORD dwFreeType);

//
// procedury WinApi dostepne dla procedury dekompresji
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
// pomocnicze makro pozwalajace opisac eksportowane procedury
//
// PELock potrafi rozpoznac nazwy procedur biblioteki kompresji w roznych formatach
// jak np. C i C++ (dekorowane, z lub bez podkreslenia etc.) jednak zalecane jest stosowanie
// nazw procedur eksportowanych w formacie C
//
#define EXPORT_C_STYLE
#ifdef EXPORT_C_STYLE
#define EXPORT extern "C" __declspec(dllexport)
#else
#define EXPORT __declspec(dllexport)
#endif

// prototyp procedury callback wykorzystywanej podczas kompresji danych (do aktualizacji paska postepu)
typedef DWORD (WINAPI *PCOMPRESSION_PROGRESS)(DWORD dwInputPosition, DWORD dwOutputPosition, DWORD Reserved);
typedef PCOMPRESSION_PROGRESS LPCOMPRESSION_PROGRESS;
