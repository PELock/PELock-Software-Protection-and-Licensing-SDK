;///////////////////////////////////////////////////////////////////////////////
;//
;// Przyklad uzycia chronionych wartosci PELOCK_DWORD
;//
;// Wersja         : PELock v2.0
;// Jezyk          : PureBasic
;// Autor          : Bartosz Wójcik (support@pelock.com)
;// Strona domowa  : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\Polish\PureBasic\"
XIncludeFile "pelock.pb"

; start

    Dim int_array.l(5)

    i.l = 0
    x.l = 0
    y.l = 5

    ; mozesz uzywac PELOCK_DWORD() gdzie tylko chcesz, poniewaz zawsze
    ; bedzie zwracac okreslona wartosc liczbowa, bledne wartosci beda
    ; zwracane TYLKO I WYLACZNIE, gdy ktos usunie zabezpieczenie PELock'a
    ; z wczesniej zabezpieczonej aplikacji
    For i = 0 To PELOCK_DWORD(3)

        MessageRequester("PELock", Str(i))

    Next

    ; uzyj makra PELOCK_SIZEOF (makro uzywa wewnetrznie PELOCK_DWORD do ochrony wartosci)
    ; zamiast operatora sizeof
    MessageRequester("PELock", "sizeof(i) = " + Str(PELOCK_SIZEOF(i)) )

    ; najlepszy sposobem na ochrone aplikacji przed pelnym zlamaniem
    ; jest uzywanie PELOCK_DWORD we wszelkiego rodzaju obliczeniach
    x = (1024 * y) + PELOCK_DWORD(-1)

    ; chronionych wartosci PELOCK_DWORD mozna takze uzywac do
    ; przekazywania stalych flag funkcjom WinApi
    MessageBox_(#Null, "PELock's protected constants", "Hello world :)", PELOCK_DWORD( #MB_ICONINFORMATION ) )

    ; inicjalizuj wartosci liczbowe
    int_array(0) = PELOCK_DWORD(0)
    int_array(1) = PELOCK_DWORD($FF) + 100
