;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad wtyczki
;//
;// Wersja         : PELock v2.0
;// Jezyk          : PureBasic
;// Autor          : Bartosz Wójcik (support@pelock.com)
;// Strona domowa  : https://www.pelock.com
;//
;//////////////////////////////////////////////////////////////////////////////

XIncludeFile "pelock_plugin.pb"

; Global pointer To the PLUGIN_INTERFACE Structure
Global *g_lpPluginInterface.PLUGIN_INTERFACE

; beeping thread handle
Global g_hBeepThread.l

;///////////////////////////////////////////////////////////////////////////////
;//
;// procedura beepera
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
;// procedura wtyczki
;//
;// uwagi!
;//
;// w bibliotece wtyczki mozesz korzystac z oryginalnych funkcji WinApi/RTL np.
;//
;// ExitProcess_(0)
;// Len(lpszString)
;//
;// lub mozesz skorzystac z procedur dostepnych poprzez strukture interfejsu
;// PLUGIN_INTERFACE:
;//
;// CallFunctionFast(*lpPluginInterface\pe_ExitProcess, 0)
;// CallFunctionFast(*lpPluginInterface\pe_strlen, lpszString)
;//
;// ostrzezenie!
;//
;// wszystkie procedury dostepne poprzez interfejs PLUGIN_INTERFACE sa wersjami
;// ANSI (kompatybilne ze wszystkimi wersjami systemow Windows), wiec nie mozna
;// uzywac ich z parametrami UNICODE (typ danych wchar etc.)!
;// Jesli we wtyczce chcesz skorzystac z funkcji obslugujacych unicode, skorzystaj
;// z oryginalnych funkcji WinApi/RTL, a nie tych dostepnych poprzez interfejs wtyczki
;// PLUGIN_INTERFACE.
;//
;///////////////////////////////////////////////////////////////////////////////

ProcedureDLL Plugin(*lpPluginInterface.PLUGIN_INTERFACE)

     dwThreadId.l

     ; sprawdz parametr wejsciowy
     If (*lpPluginInterface = #Null)

         ProcedureReturn

     EndIf

     ; zapisz wskaznik do interfejsu wtyczki do globalnej zmiennej
     *g_lpPluginInterface = *lpPluginInterface

     ; uruchom watek, ktory bedzie odgrywal dzwiek z glosnika systemowego
     g_hBeepThread = CallFunctionFast(*lpPluginInterface\pe_CreateThread, #Null, 0, @BeepProc(), #Null, 0, @dwThreadId)

     ; wyswietl informacje i wroc do kodu aplikacji
     MessageBox_(#Null, "Witaj swiecie! Czy slyszysz dzwieki z glosnika? :)", "Wtyczka dla PELock", #MB_ICONINFORMATION)

     ;DebugBreak_()

EndProcedure

;///////////////////////////////////////////////////////////////////////////////
;//
;// Punkty wejsciowe biblioteki DLL dla jezyka PureBasic
;//
;///////////////////////////////////////////////////////////////////////////////

ProcedureDLL AttachProcess(Instance)
EndProcedure

ProcedureDLL DetachProcess(Instance)

    ; wyswietl informacje przy wyladowaniu wtyczki, wtyczki w formie plikow DLL
    ; sa wyladowane pod koniec dzialania aplikacji
    MessageBox_(#Null, "Wtyczka konczy dzialanie.", "Wtyczka dla PELock", MB_ICONINFORMATION);

    ; zakoncz watek
    TerminateThread_(g_hBeepThread, 1);

EndProcedure

ProcedureDLL AttachThread(Instance)
EndProcedure

ProcedureDLL DetachThread(Instance)
EndProcedure

; ExecutableFormat=Shared Dll
; EOF
