;ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
;บ                                                                                            บ
;บ PELock - Bartosz W๓jcik                                                                    บ
;บ                                                                                            บ
;บ ฏ opis interfejsu wtyczki                                                                  บ
;บ ฏ skladnia masm - pobierz masm ze strony http://www.masm32.com                             บ
;บ ฏ do czytania tego kodu najlepiej nadaje sie font terminal                                 บ
;บ                                                                                            บ
;ศออออออออออออออออออออออออออออออออออออออออออออออออออออออนsupport@pelock.comฬอนwww.pelock.comฬอผ

PLUGIN_INTERFACE_VERSION	equ 1		; wersja interfejsu

;ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
; interfejs komunikacyjny wtyczki
;ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
PLUGIN_INTERFACE struct

; wewnetrzne dane
	pe_delta		dd ?		; wirtualny adres kodu wtyczki w pamieci
	pe_size			dd ?		; rozmiar kodu wtyczki w bajtach

	pe_imagebase		dd ?		; baza obrazu w pamieci
	pe_imagesize		dd ?		; rozmiar obrazu
	pe_temp			dd ?		; (na twoj uzytek)

; manipulacja na pamieci
	pe_memcpy		dd ?		; __stdcall void *memcpy(void * restrict s1, const void * restrict s2, size_t n);
	pe_memset		dd ?		; __stdcall void *memset(void *s, int c, size_t n);

; funkcje ciagow znakowych
	pe_strlen		dd ?		; __stdcall size_t strlen(const char *s);
	pe_strcpy		dd ?		; __stdcall char *strcpy(char * restrict s1,const char * restrict s2);
	pe_strcat		dd ?		; __stdcall char *strcat(char * restrict s1,const char * restrict s2);

; procedura wykrycia debuggera
	pe_debugger_detected	dd ?		; __stdcall void debugger_detected();

; standardowe funkcje WinApi
	pe_GetVersionExA	dd ?		; BOOL GetVersionEx(LPOSVERSIONINFO lpVersionInformation);

	pe_GetModuleHandleA	dd ?		; HMODULE GetModuleHandle(LPCTSTR lpModuleName);
	pe_GetModuleFileNameA	dd ?		; DWORD GetModuleFileName(HMODULE hModule, LPTSTR lpFilename, DWORD nSize);

	pe_LoadLibraryA		dd ?		; HINSTANCE LoadLibrary(LPCTSTR lpLibFileName);
	pe_FreeLibrary		dd ?		; BOOL FreeLibrary(HMODULE hLibModule);
	pe_GetProcAddress	dd ?		; FARPROC GetProcAddress(HMODULE hModule, LPCSTR lpProcName);

	pe_VirtualAlloc		dd ?		; LPVOID VirtualAlloc(LPVOID lpAddress, DWORD dwSize, DWORD flAllocationType, DWORD flProtect);
	pe_VirtualFree		dd ?		; BOOL VirtualFree(LPVOID lpAddress, DWORD dwSize, DWORD dwFreeType);

	pe_MessageBoxA		dd ?		; int MessageBox(HWND hWnd, LPCTSTR lpText, LPCTSTR lpCaption, UINT uType);
	pe_wsprintfA		dd ?		; int wsprintf(LPTSTR lpOut, LPCTSTR lpFmt, ...);

	pe_CreateThread		dd ?		; HANDLE CreateThread(LPSECURITY_ATTRIBUTES lpThreadAttributes, DWORD dwStackSize, LPTHREAD_START_ROUTINE lpStartAddress, LPVOID lpParameter, DWORD dwCreationFlags, LPDWORD lpThreadId);
	pe_Sleep		dd ?		; VOID Sleep(DWORD dwMilliseconds);

	pe_ExitProcess		dd ?		; VOID ExitProcess(UINT uExitCode);

PLUGIN_INTERFACE ends
