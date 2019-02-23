////////////////////////////////////////////////////////////////////////////////
//
// Przyklad jak sprawdzic czy klucz jest zablokowany na sprzetowy identyfikator
//
// Wersja         : PELock v2.09
// Jezyk          : D
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

import std.stdio;
import std.string;
import core.stdc.stdio;
import core.sys.windows.windows;
import PELock;

int main(string args[])
{
	// inicjalizuj klase PELock
	PELock myPELock = new PELock;

	mixin(DEMO_START);

	// czy klucz jest zablokowany na sprzetowy identyfikator
	BOOL bIsKeyHardwareIdLocked = myPELock.IsKeyHardwareIdLocked();

	if (bIsKeyHardwareIdLocked == TRUE)
	{
		writef("Ten klucz jest zablokowany na sprzetowy identyfikator!");
	}
	else
	{
		writef("Ten klucz NIE jest zablokowany na sprzetowy identyfikator!");
	}

	mixin(DEMO_END);

	writef("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");

	getchar();

	return 0;
}
