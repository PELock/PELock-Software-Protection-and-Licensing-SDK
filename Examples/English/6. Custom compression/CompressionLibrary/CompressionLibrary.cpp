////////////////////////////////////////////////////////////////////////////////
//
// Custom compression library example
//
// Version        : PELock v2.0
// Language       : C++
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"

// compression algorithm name (for logging purposes)
const char szCompressionName[] = "CCX";

//
// DWORD __stdcall Compress(const PBYTE lpInput, DWORD dwInput, PBYTE lpOutput, PDWORD lpdwOutput, LPCOMPRESSION_PROGRESS lpCompressionProgress, const char *lpszConfig, DWORD Reserved)
//
// compression routine
//
// [in]
// lpInput - data source to compress
// dwInput - input data size in bytes
// lpOutput - output buffer (already allocated by PELock, it's bigger than input data size, so the ratio can be negative)
// lpdwOutput - pointer to DWORD to receive output data (compressed) size
// lpCompressionProgress - callback routine
// lpszConfig - pointer to the current configuration file path (either pelock.ini or project file path)
// Reserved - for future use, set to 0
//
// [out]
// 0 for success, anything != 0 for an error
//
EXPORT DWORD __stdcall Compress(const PBYTE lpInput, DWORD dwInput, PBYTE lpOutput, PDWORD lpdwOutput, LPCOMPRESSION_PROGRESS lpCompressionProgress, const char *lpszConfig, DWORD Reserved)
{
	PBYTE lpIn = NULL, lpOut = NULL;
	DWORD i = 0;

	//
	// check input params (altrough it's almost impossible it will be invalid)
	//
	if ( (lpInput == NULL) || (dwInput == 0) || (lpOutput == NULL) )
	{
		return COMPESSION_ERROR_PARAM;
	}

	// helper variables
	lpIn = lpInput;
	lpOut = lpOutput;

	//
	// store decompressed buffer size (so that decompression routine knows that size)
	//
	*(DWORD *)lpOut = dwInput;
	lpOut += sizeof(DWORD);

	//
	// compression routine (in our case copy bytes from input to output buffer)
	//
	for (i = 0; i < dwInput; i++)
	{
		*lpOut++ = *lpIn++;

		// call callback procedure with input and output positions (offsets)
		// call it once per 1 kB
		if ((i % 1024) == 0)
		{
			lpCompressionProgress(i, i, 0);
		}
	}

	// 100% done
	lpCompressionProgress(i, i, 0);

	//
	// set compressed size (in our case it's the same as the input size + size of additional DWORD)
	//
	if (lpdwOutput != NULL)
	{
		*lpdwOutput = dwInput + sizeof(DWORD);
	}

	//
	// return 0 (success), anything != 0 is treated like an error
	//
	return COMPRESSION_OK;
}

//
// DWORD __cdecl DecompressionProc(PDEPACK_INTERFACE lpDepackInterface, PVOID lpInputData, PVOID lpOutputData)
//
// decompression routine (raw code), this code will be binded to the main loader code
// of a PELock, so you must follow some rules:
//
// * all registers (except EAX) MUST BE preserved (use pushad and popad), flags can be destroyed
// * you must return decompressed size in EAX
// * this routine is __cdecl, you SHOULD NOT fix the stack with ret 12
// * you can use lpInputData as a temporary buffer
//
// [in]
// lpDepackInterface - pointer to the DEPACK_INTERFACE structure, it gives access to the
// WinApi functions, you can create very complex decompression procedures with it
// lpInputData - compressed data
// lpOutputData - where to put decompressed data
//
// [out]
// size of decompressed data
//
__declspec(naked) DWORD DecompressionRoutine(PDEPACK_INTERFACE lpDepackInterface, PVOID lpInputData, PVOID lpOutputData)
{
	__asm
	{
		pushad							// save all registers

		mov	ebx, dword ptr [esp + 36]	// lpDepackInterface (table with WinApi procedures)
		mov	esi, dword ptr [esp + 40]	// lpInputData
		mov	edi, dword ptr [esp + 44]	// lpOutputData

		mov	eax, dword ptr[esi]			// 1st DWORD of an input data indicates size of compressed data (our own format)
		add	esi,4
		mov	dword ptr [esp + 28], eax	// return decompressed data size (it will be returned in EAX after return)

		mov	ecx,eax						// decompression code (in our case it's simple memcpy routine)
		shr	ecx,2
		and	eax,3
		rep	movsd
		mov	ecx,eax
		rep	movsb

		popad							// restore all registers (EAX = decompressed data size)

		retn							// return (retn = ret 0, our routine is __cdecl, DO NOT use ret 12!)

		_emit 0xAA						// code marker, so we can calculate size of the decompression
		_emit 0xFF						// routine manually
		_emit 0xFF						//
		_emit 0xAA						//
	}
}

//
// void __stdcall DecompressionProc(PVOID **lppDecompProc, DWORD *lpdwDecompProc, DWORD Reserved)
//
// returns pointer to the decompression routine & its size
//
// [in]
// Reserved - it should be 0
//
// [out]
// lppDecompProc - pointer to receive decompression routine address
// lpdwDecompProc - DWORD to receive decompression routine size
//
// [notes]
// this procedure is called only ONCE per session, so you can generate decompression code
// dynamically (eg. using polymorphic engine), then at DLL_PROCESS_DETACH you can release
// its memory
//
EXPORT void __stdcall DecompressionProc(PVOID *lppDecompProc, PDWORD lpdwDecompProc, DWORD Reserved)
{
	DWORD dwDecompProc = 0;
	PBYTE lpDecompProc = (PBYTE)&DecompressionRoutine;
	BYTE cMarker[] = { 0xAA, 0xFF, 0xFF, 0xAA };

	// find marker in decompression code
	for (dwDecompProc = 0; dwDecompProc < 1024; dwDecompProc++)
	{
		if (memcmp(&lpDecompProc[dwDecompProc], cMarker, sizeof(cMarker) ) == 0)
		{
			break;
		}
	}

	*lppDecompProc = (PVOID)&DecompressionRoutine;
	*lpdwDecompProc = dwDecompProc;
}

//
// const char * __stdcall Name(DWORD Reserved)
//
// compression algorithm name
//
// [in]
// Reserved - for future use, set to 0
//
// [out]
// compression algorithm name (ansi)
//
EXPORT const char * __stdcall Name(DWORD Reserved)
{
	return szCompressionName;
}

//
// void __stdcall Configure(HWND hParent, const char *lpszConfig, DWORD Reserved)
//
// display configuration dialog / about box
//
// [in]
// hWndParent - handle to owner window (main PELock's window)
// lpszConfig - pointer to the current configuration file path (either pelock.ini or project file path)
// Reserved   - for future use, set to 0
//
EXPORT void __stdcall Configure(HWND hWndParent, const char *lpszConfig, DWORD Reserved)
{
	MessageBox(hWndParent, szCompressionName, lpszConfig, MB_ICONINFORMATION);
}

//
// entrypoint
//
BOOL APIENTRY DllMain(HINSTANCE hModule, DWORD ul_reason_for_call, LPVOID lpReserved)
{
	switch(ul_reason_for_call)
	{
	// initialize (allocate memory buffers etc.)
	case DLL_PROCESS_ATTACH:

		DisableThreadLibraryCalls(hModule);
		break;

	// cleanup
	case DLL_PROCESS_DETACH:

		break;
	}

	return TRUE;
}
