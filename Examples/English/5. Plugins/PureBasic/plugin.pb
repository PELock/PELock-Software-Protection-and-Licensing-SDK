;///////////////////////////////////////////////////////////////////////////////
;//
;// Plugin example
;//
;// Version        : PELock v2.0
;// Language       : PureBasic
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

XIncludeFile "pelock_plugin.pb"

; Global pointer To the PLUGIN_INTERFACE Structure
Global *g_lpPluginInterface.PLUGIN_INTERFACE

; beeping thread handle
Global g_hBeepThread.l


;///////////////////////////////////////////////////////////////////////////////
;//
;// beep procedure
;//
;///////////////////////////////////////////////////////////////////////////////

Procedure BeepProc(lpParameter)

    Repeat

        MessageBeep_(-1)
        Sleep_(1000)

    ForEver

EndProcedure


;///////////////////////////////////////////////////////////////////////////////
;//
;// plugin procedure
;//
;// quick tip!
;//
;// you can use either original WinApi/RTL functions in your plugin eg.
;//
;// ExitProcess_(0)
;// Len(lpszString)
;//
;// or you can use procedures available via PLUGIN_INTERFACE structure
;//
;// CallFunctionFast(*lpPluginInterface\pe_ExitProcess, 0)
;// CallFunctionFast(*lpPluginInterface\pe_strlen, lpszString)
;//
;// warning!
;//
;// all procedures inside PLUGIN_INTERFACE are ANSI (compatible with all
;// Windows versions), so you CAN'T use UNICODE with it (wchar types etc.)!
;// If you want to use unicode functions, use original WinApi/RTL functions,
;// and not those available via PLUGIN_INTERFACE.
;//
;///////////////////////////////////////////////////////////////////////////////

ProcedureDLL Plugin(*lpPluginInterface.PLUGIN_INTERFACE)

     dwThreadId.l

     ; verify input parameter
     If (*lpPluginInterface = #Null)

         ProcedureReturn

     EndIf

     ; store interface pointer in global variable
     *g_lpPluginInterface = *lpPluginInterface

     ; let the beeping begins :)
     g_hBeepThread = CallFunctionFast(*lpPluginInterface\pe_CreateThread, #Null, 0, @BeepProc(), #Null, 0, @dwThreadId)

     ; display message box
     MessageBox_(#Null, "Hello World! Can you hear the beeping? :)", "PELock Plugin", #MB_ICONINFORMATION)

     ;DebugBreak_()

EndProcedure


;///////////////////////////////////////////////////////////////////////////////
;//
;// PureBasic DLL entrypoints
;//
;///////////////////////////////////////////////////////////////////////////////

ProcedureDLL AttachProcess(Instance)
EndProcedure

ProcedureDLL DetachProcess(Instance)

    ; display message at the exit, DLL plugins are detached at
    ; the end of application
    MessageBox_(#Null, "Terminating plugin.", "PELock Plugin", #MB_ICONINFORMATION)

    ; terminate beeping thread
    TerminateThread_(g_hBeepThread, 1)


EndProcedure

ProcedureDLL AttachThread(Instance)
EndProcedure

ProcedureDLL DetachThread(Instance)
EndProcedure

; ExecutableFormat=Shared Dll
; EOF