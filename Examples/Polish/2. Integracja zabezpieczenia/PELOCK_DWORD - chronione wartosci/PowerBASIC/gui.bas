'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad uzycia chronionych wartosci PELOCK_DWORD
'//
'// Wersja         : PELock v2.0
'// Jezyk          : PowerBASIC
'// Autor          : Bartosz Wójcik (support@pelock.com)
'// Strona domowa  : https://www.pelock.com
'//
'///////////////////////////////////////////////////////////////////////////////

#COMPILE EXE
%USEMACROS = 1

#INCLUDE "win32api.inc"
#INCLUDE "pelock.inc"

FUNCTION PBMAIN () AS LONG

    DIM i AS DWORD, x AS DWORD, y AS DWORD
    DIM int_array(5) AS DWORD

    i = 0
    x = 0
    y = 5

    ' mozesz uzywac PELOCK_DWORD() gdzie tylko chcesz, poniewaz zawsze
    ' bedzie zwracac okreslona wartosc liczbowa, bledne wartosci beda
    ' zwracane TYLKO I WYLACZNIE, gdy ktos usunie zabezpieczenie PELock'a
    ' z wczesniej zabezpieczonej aplikacji
    FOR i = 0 TO PELOCK_DWORD(3)

        MSGBOX STR$(i)

    NEXT

    ' uzyj makra PELOCK_SIZEOF (makro uzywa wewnetrznie PELOCK_DWORD do ochrony wartosci)
    ' zamiast operatora sizeof
    MSGBOX "sizeof(i) =" & STR$(PELOCK_SIZEOF(i))

    ' najlepszy sposobem na ochrone aplikacji przed pelnym zlamaniem
    ' jest uzywanie PELOCK_DWORD we wszelkiego rodzaju obliczeniach
    x = (1024 * y) + PELOCK_DWORD(&HFFFFFFFF)

    ' chronionych wartosci PELOCK_DWORD mozna takze uzywac do
    ' przekazywania stalych flag funkcjom WinApi
    MessageBox(BYVAL %NULL, "PELock's protected constants", "Hello world :)", PELOCK_DWORD( %MB_ICONINFORMATION ) )

    ' inicjalizuj wartosci liczbowe
    int_array(0) = PELOCK_DWORD(0)
    int_array(1) = PELOCK_DWORD(&HFF) + 100


END FUNCTION
