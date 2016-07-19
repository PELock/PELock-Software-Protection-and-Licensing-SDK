;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º                                                                                            º
;º PELock - Bartosz Wójcik                                                                    º
;º                                                                                            º
;º ¯ plugin sample code                                                                       º
;º ¯ masm syntax - get masm from http://www.masm32.com                                        º
;º ¯ best viewed with terminal font                                                           º
;º                                                                                            º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹support@pelock.comÌÍ¹www.pelock.comÌÍ¼

	.686					; up to p4
	.mmx					; +mmx
	.xmm					; +sse, +sse2
	.k3d					; +amd
	.model flat,stdcall

; libraries (change absolute paths to match your MASM installation directory)
	includelib	e:\dev\masm\lib\kernel32.lib
	includelib	e:\dev\masm\lib\user32.lib

; include files
	include		e:\dev\masm\include\kernel32.inc
	include		e:\dev\masm\include\user32.inc
	include		e:\dev\masm\include\windows.inc

; plugin structure description
	include		pelock_plugin.inc

; data section
.data
	lpszPluginFile	db 'pelock_plugin.bin',0
	lpszWriteOk	db 'Plugin file successfully created!',0
	lpszWriteErr	db 'Cannot create file with plugin code!',0

; code section (with READ-WRITE flags, so you can modify plugin code in this section)
.code
_start:

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; save plugin code to the file
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	push	_plugin_procedure_size		; plugin code size
	push	offset _plugin_procedure	; plugin procedure
	push	offset lpszPluginFile		; output filename
	call	_save_plugin			; save it

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; check error code from _save_plugin and display message dialog
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	mov	edx,offset lpszWriteOk
	mov	ecx,MB_ICONINFORMATION

	test	eax,eax				; check error code from _save_plugin
	je	@f				; if its 0 then display success message

	mov	edx,offset lpszWriteErr		; otherwise error message
	mov	ecx,MB_ICONASTERISK
@@:
	push	ecx				; dialog type
	push	offset lpszPluginFile		; display filename as a caption
	push	edx				; text
	push	0				; hWndOwner
	call	MessageBoxA			; display message

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; before exit simulate plugin call
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	push	offset _plugin_procedure
	call	_simulate_call

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; exit process
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	push	0				; exit code
	call	ExitProcess			; exit


;ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
;
; _save_plugin proc uses esi edi ebx, lpszFilename:dword
;
; [in]
; lpszFilename - filename where to save plugin's code
; lpCodeBuffer - pointer to the plugin's code
; dwCodeBuffer - plugin code buffer size
;
; [out]
; 0 - success, 1 - errror
;
; [modified registers]
; EAX, ECX, EDX
;
;ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ

_save_plugin proc uses esi edi ebx, lpszFilename:dword, lpCodeBuffer:dword, dwCodeBuffer:dword

	local	dwNumberOfBytesWritten:dword	; local variable

	sub	ebx,ebx				; EBX = 0

	mov	esi,lpszFilename		; check parameter
	test	esi,esi
	je	_save_plugin_error

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; create a new file
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	push	ebx				; hTemplate
	push	FILE_ATTRIBUTE_NORMAL		; dwFlagsAndAttributes
	push	CREATE_ALWAYS			; dwCreationDistribution
	push	ebx				; lpSecurityAttributes
	push	ebx				; dwShareMode
	push	GENERIC_READ or GENERIC_WRITE	; dwDesiredAccess
	push	esi				; lpFileName
	call	CreateFileA			; create new file
	cmp	eax,-1				; check return value (INVALID_HANDLE_VALUE)
	je	_save_plugin_error		; 

	xchg	eax,edi				; file handle to EDI

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; write to file
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	lea	eax,dwNumberOfBytesWritten

	push	ebx				; lpOverlapped
	push	eax				; lpNumberOfBytesWritten
	push	dwCodeBuffer			; nNumberOfBytesToWrite
	push	lpCodeBuffer			; lpBuffer
	push	edi				; hFile
	call	WriteFile			; write plugin's code
	xchg	eax,esi				; error code

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; close file
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	push	edi				; file handle
	call	CloseHandle			; close file

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; check error code from WriteFile
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	test	esi,esi
	je	_save_plugin_error

	sub	eax,eax				; 0 success
	jmp	_save_plugin_exit		; return value

_save_plugin_error:

	mov	eax,1				; store error code in EAX

_save_plugin_exit:

	ret					; return with error code

_save_plugin endp


;ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
;
; _simulate_call proc uses esi edi ebx, lpPluginCode:dword
;
; [in]
; lpPluginCode - pointer to the plugin's code
;
; [out]
; none
;
; [modified registers]
; EAX, ECX, EDX
;
;ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ

_simulate_call proc uses esi edi ebx, lpPluginCode:dword

	local	lpPi:PLUGIN_INTERFACE

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; fill out PLUGIN_INTERFACE structure
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	lea	esi,lpPi
	assume	esi:ptr PLUGIN_INTERFACE

; internal data
	mov	[esi].pe_imagebase,400000h	; module imagebase
	mov	[esi].pe_imagesize,1000h	; image size
	mov	[esi].pe_temp,0			; (for your usage)

; memory manipulation
;	mov	[esi].pe_memcpy,offset memcpy	; __stdcall void *memcpy(void * restrict s1, const void * restrict s2, size_t n);
;	mov	[esi].pe_memset,offset memset	; __stdcall void *memset(void *s, int c, size_t n);

; string functions
;	mov	[esi].pe_strlen,offset strlen	; __stdcall size_t strlen(const char *s);
;	mov	[esi].pe_strcpy,offset strcpy	; __stdcall char *strcpy(char * restrict s1,const char * restrict s2);
;	mov	[esi].pe_strcat,offset strcat	; __stdcall char *strcat(char * restrict s1,const char * restrict s2);

; standard WinApi functions
	mov	eax,offset GetModuleHandleA
	mov	[esi].pe_GetModuleHandleA,eax	; HMODULE GetModuleHandle(LPCTSTR lpModuleName);

	mov	eax,offset GetModuleFileNameA
	mov	[esi].pe_GetModuleFileNameA,eax	; DWORD GetModuleFileName(HMODULE hModule, LPTSTR lpFilename, DWORD nSize);

	mov	eax,offset LoadLibraryA
	mov	[esi].pe_LoadLibraryA,eax	; HINSTANCE LoadLibrary(LPCTSTR lpLibFileName);

	mov	eax,offset FreeLibrary
	mov	[esi].pe_FreeLibrary,eax	; BOOL FreeLibrary(HMODULE hLibModule);

	mov	eax,offset GetProcAddress
	mov	[esi].pe_GetProcAddress,eax	; FARPROC GetProcAddress(HMODULE hModule, LPCSTR lpProcName);

	mov	eax,offset VirtualAlloc
	mov	[esi].pe_VirtualAlloc,eax	; LPVOID VirtualAlloc(LPVOID lpAddress, DWORD dwSize, DWORD flAllocationType, DWORD flProtect);

	mov	eax,offset VirtualFree
	mov	[esi].pe_VirtualFree,eax	; BOOL VirtualFree(LPVOID lpAddress, DWORD dwSize, DWORD dwFreeType);

	mov	eax,offset MessageBoxA
	mov	[esi].pe_MessageBoxA,eax	; int MessageBox(HWND hWnd, LPCTSTR lpText, LPCTSTR lpCaption, UINT uType);

	mov	eax,offset wsprintfA
	mov	[esi].pe_wsprintfA,eax		; int wsprintf(LPTSTR lpOut, LPCTSTR lpFmt, ...);

	mov	eax,offset CreateThread
	mov	[esi].pe_CreateThread,eax	; HANDLE CreateThread(LPSECURITY_ATTRIBUTES lpThreadAttributes, DWORD dwStackSize, LPTHREAD_START_ROUTINE lpStartAddress, LPVOID lpParameter, DWORD dwCreationFlags, LPDWORD lpThreadId);

	mov	eax,offset ExitProcess
	mov	[esi].pe_ExitProcess,eax	; VOID ExitProcess(UINT uExitCode);

	pushfd					; save all flags
	pushad					; save all registers

	push	esi				; &PLUGIN_INTERFACE
	call	lpPluginCode			; call plugin code

	popad					; restore all registers
	popfd					; restore all flags

	ret					; return

_simulate_call endp


;ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
;
; _plugin_procedure proc uses esi edi ebx, lpPluginInterface:dword
;
; sample plugin code
;
; [in]
; lpPluginInterface - filled PELock's plugin interface structure
;
; [out]
; you can return whatever you want
;
; [info]
; __stdcall calling convention, you must preserve ESP register, all other registers
; can be destroyed (including EBP)
;
; lpPluginStructure is destroyed after return from the plugin code, so you can't
; pass it as a param to threads etc.
;
;ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ

_plugin_procedure proc uses esi edi ebx, lpPluginInterface:dword

	mov	esi,lpPluginInterface		; filled PLUGIN_INTERFACE structure
	assume	esi:ptr PLUGIN_INTERFACE

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; let's ask user if he want to continue or exit
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	push	MB_YESNO			; dialog type
	call	@f				; return address will point to the
	db	'Question',0			; string 'Question'
@@:	call	@f
	db	'Would you like to continue?',0
@@:	push	0				; hWndOwner
	call	[esi].pe_MessageBoxA		; display message

	cmp	eax,IDYES			; did user select "Yes"
	je	_continue_execution		; if so, continue, otherwise exit

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; exit
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	push	1				; error code
	call	[esi].pe_ExitProcess		; exit process

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; return from plugin code (continue execution)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
_continue_execution:

	ret					; return to the loader's code and continue
						; execution
_plugin_procedure endp
_plugin_procedure_size equ $-_plugin_procedure	; plugin code size

end _start
