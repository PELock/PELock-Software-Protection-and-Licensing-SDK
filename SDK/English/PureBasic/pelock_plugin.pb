;///////////////////////////////////////////////////////////////////////////////
;//
;// Plugin interface description
;//
;// Version        : PELock v2.0
;// Language       : PureBasic
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

#PLUGIN_INTERFACE_VERSION = 1           ; Interface version

;
; plugin interface for external code
;
Structure PLUGIN_INTERFACE

; internal data
    *pe_delta.b                         ; virtual address of plugin code
    pe_size.l                           ; plugin's code size in bytes

    pe_imagebase.l                      ; module imagebase
    pe_imagesize.l                      ; image size
    pe_temp.l                           ; (for your usage)

; memory manipulation
    *pe_memcpy                          ; __stdcall void *memcpy(void * restrict s1, const void * restrict s2, size_t n);
    *pe_memset                          ; __stdcall void *memset(void *s, int c, size_t n);

; string functions
    *pe_strlen                          ; __stdcall size_t strlen(const char *s)
    *pe_strcpy                          ; __stdcall char *strcpy(char * restrict s1, const char * restrict s2);
    *pe_strcat                          ; __stdcall char *strcat(char * restrict s1, const char * restrict s2);

; debugger detected procedure
    *pe_debugger_detected               ; __stdcall void debugger_detected();

; standard WinApi functions
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
