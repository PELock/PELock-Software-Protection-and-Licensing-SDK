;///////////////////////////////////////////////////////////////////////////////
;//
;// Opis interfejsu wtyczki
;//
;// Wersja         : PELock v2.0
;// Jezyk          : PureBasic
;// Autor          : Bartosz Wójcik (support@pelock.com)
;// Strona domowa  : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

#PLUGIN_INTERFACE_VERSION  = 1          ; wersja interfejsu

;
; interfejs komunikacyjny wtyczki
;
Structure PLUGIN_INTERFACE

; wewnetrzne dane
    *pe_delta.b                         ; wirtualny adres kodu wtyczki w pamieci
    pe_size.l                           ; rozmiar kodu wtyczki w bajtach

    pe_imagebase.l                      ; baza obrazu w pamieci
    pe_imagesize.l                      ; rozmiar obrazu
    pe_temp.l                           ; (na twoj uzytek)

; manipulacja na pamieci
    *pe_memcpy                          ; __stdcall void *memcpy(void * restrict s1, const void * restrict s2, size_t n);
    *pe_memset                          ; __stdcall void *memset(void *s, int c, size_t n);

; funkcje ciagow znakowych
    *pe_strlen                          ; __stdcall size_t strlen(const char *s)
    *pe_strcpy                          ; __stdcall char *strcpy(char * restrict s1, const char * restrict s2);
    *pe_strcat                          ; __stdcall char *strcat(char * restrict s1, const char * restrict s2);

; procedura wykrycia debuggera
    *pe_debugger_detected               ; __stdcall void debugger_detected();

; standardowe funkcje WinApi
    *pe_GetVersionExA                   ; BOOL GetVersionEx(LPOSVERSIONINFO lpVersionInformation);

    *pe_GetModuleHandleA                ; HMODULE GetModuleHandle(LPCTSTR lpModuleName);
    *pe_GetModuleFileNameA              ; DWORD GetModuleFileName(HMODULE hModule, LPTSTR lpFilename, DWORD nSize);

    *pe_LoadLibraryA                    ; HINSTANCE LoadLibrary(LPCTSTR lpLibFileName);
    *pe_FreeLibrary                     ; BOOL FreeLibrary(HMODULE hLibModule);
    *pe_GetProcAddress                  ; FARPROC GetProcAddress(HMODULE hModule, LPCSTR lpProcName);

    *pe_VirtualAlloc                    ; LPVOID VirtualAlloc(LPVOID lpAddress, DWORD dwSize, DWORD flAllocationType, DWORD flProtect);
    *pe_VirtualFree                     ; BOOL VirtualFree(LPVOID lpAddress, DWORD dwSize, DWORD dwFreeType);

    *pe_MessageBoxA                     ; int MessageBox(HWND hWnd, LPCTSTR lpText, LPCTSTR lpCaption, UINT uType);
    *pe_wsprintfA                       ; int wsprintf(LPTSTR lpOut, LPCTSTR lpFmt, ...);

    *pe_CreateThread                    ; HANDLE CreateThread(LPSECURITY_ATTRIBUTES lpThreadAttributes, DWORD dwStackSize, LPTHREAD_START_ROUTINE lpStartAddress, LPVOID lpParameter, DWORD dwCreationFlags, LPDWORD lpThreadId);
    *pe_Sleep                           ; VOID Sleep(DWORD dwMilliseconds);

    *pe_ExitProcess                     ; VOID ExitProcess(UINT uExitCode);

EndStructure
