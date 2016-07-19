;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad jak wykorzystac procedure callback systemu ograniczenia czasowego
;//
;// Wersja         : PELock v2.0
;// Jezyk          : PureBasic
;// Autor          : Bartosz Wójcik (support@pelock.com)
;// Strona domowa  : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\Polish\PureBasic\"
XIncludeFile "pelock.pb"

;
; wstaw do tej procedury kod konczacy program, zamykajacy uchwyty itp.
;
; zwracane wartosci:
;
; 1 - aplikacja zostanie zamknieta
; 0 - aplikacja bedzie dzialac, nawet mimo przekroczenia czasu testowego
;
Procedure TrialExpired()

    ; to makro musi znajdowac sie na poczatku procedury callback
    TRIAL_EXPIRED

    MessageBox_(hMainDialog, "Ta aplikacja wygasla, prosze zakupic pelna wersje!", "Uwaga", #MB_ICONWARNING)

    ; mozna samemu zakonczyc aplikacje lub pozostawic to loaderowi PELock'a,
    ; aby zamknac aplikacje, zwroc wartosc 1
    End 1 ;ExitProcess_(1)

    ;ProcedureReturn 1

EndProcedure

; start

    ; utworz nowe okno dialogowe
    If OpenWindow(0, 0, 0, 200, 100, "PELock Test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

      ; dodaj kontrolki do okna dialogowego
      If CreateGadgetList(WindowID(0))

        TextGadget(0, 8, 8, 280, 25, "To jest wersja testowa!")
        ButtonGadget(1, 8, 65, 70, 25, "&Zamknij")

      EndIf

    EndIf

    ; wyswietl okno dialogowe
    Repeat

      EventID = WaitWindowEvent()

      If EventID = #PB_Event_Gadget

        If EventGadget() = 1

          CloseWindow(0)
          End

          ; sztuczne wywolanie procedury, zeby kompilator nie usunal
          ; jej z kodu z powodu optymalizacji!
          TrialExpired()

        EndIf


      EndIf

    Until EventID = #PB_Event_CloseWindow
