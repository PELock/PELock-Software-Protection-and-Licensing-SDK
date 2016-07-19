;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad uzycia makr punktow kontrolnych PELOCK_CPUID
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
; wstawiaj makra PELOCK_CPUID w rzadko uzywanych procedurach
; co spowoduje, ze znalezienie tych makr bedzie bardzo trudne
; dla kogos, kto bedzie probowal zlamac zabezpieczona aplikacje
;
Procedure rarely_used_procedure()

    ; ukryty marker
    PELOCK_CPUID

EndProcedure

; start

    Dim dwImportantArray.l(4)

    dwImportantArray(0) = 100

    ;
    ; makra punktow kontrolnych w zaden sposob nie zaklocaja
    ; pracy aplikacji, jesli jednak ktos bedzie chcial uruchomic
    ; zlamana lub rozpakowana aplikacje, kod makra PELOCK_CPUID
    ; wywola wyjatek, tak ze zlamana/rozpakowana aplikacja nie
    ; bedzie w efekcie dzialac poprawnie (nie bedzie funkcjonalna)
    ;
    PELOCK_CPUID

    ;
    ; mozesz wylapac wyjatki spowodowane przez PELOCK_CPUID
    ; po usunieciu zabezpieczenia i obsluzyc ta sytuacje wedle
    ; wlasnego uznania
    ;
    OnErrorGoto(?ProtectionRemoved)

        PELOCK_CPUID

        Goto ProtectionPresent

    ProtectionRemoved:

        ;
        ; - zamknij aplikacje
        ; - uszkodz pamiec aplikacji
        ; - wylacz jakies kontrolki
        ; - zmien jakies wazne zmienne
        ;
        ; NIE WYSWIETLAJ ZADNYCH INFORMACJI OSTRZEGAWCZYCH!!!
        ;
        dwImportantArray(0) = 4

    ProtectionPresent:

    MessageRequester("PELock", "Wynik obliczenia 100 + 100 = " + Str(dwImportantArray(0) + dwImportantArray(0)) )
