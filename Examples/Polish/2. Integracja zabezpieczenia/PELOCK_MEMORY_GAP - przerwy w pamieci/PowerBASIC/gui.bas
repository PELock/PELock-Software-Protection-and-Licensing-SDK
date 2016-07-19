'///////////////////////////////////////////////////////////////////////////////
'//
'// Przyklad wykorzystania makra ochrony pamieci PELOCK_MEMORY_GAP
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

    ' makro spowoduje, ze po uruchomieniu aplikacji w pamieci aplikacji
    ' zostanie umieszczony obszar niedostepny dla samej aplikacji (jedynie
    ' w obszarze makra), stanowi to dodatkowe zabezpieczenie przed zrzucaniem
    ' pamieci aplikacji (dumping), makro to nie ma zadnego wplywu na dzialanie
    ' aplikacji i moze byc umieszczane w dowolnych punktach programu
    PELOCK_MEMORY_GAP

    MSGBOX "Witaj swiecie!"

END FUNCTION
