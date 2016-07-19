////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use PELOCK_INIT_CALLBACK macros
//
// Version        : PELock v2.0
// Language       : D
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

import std.stdio;
import std.string;
import core.stdc.stdio;
import core.sys.windows.windows;
import PELock;

static int dwSecretValue1 = 0;
static int dwSecretValue2 = 0;

//
// initialization callbacks are called only once before application
// start, it can be used to initialize sensitive variables, it is
// called only for the protected applications, so if the protection
// gets removed those functions won't be called (extra protection
// against code unpacking)
//
// those function has to be used somewhere in the code, so it won't
// be removed by the compiler optimizations (which in most cases
// removes unused and unreferenced functions), you can use a simple
// trick to protect against it, check the function pointer anywhere
// in the code eg.:
//
// if ((&pelock_initalization_callback_1 == NULL) return 0;
//
// also keep in mind that those functions are called before
// application initialization code, so if your application
// depends on some libraries (either static or dynamic), make
// sure to keep this code simple without any references to those
// libraries and their functions
//
extern (Windows) void pelock_initalization_callback_1(HINSTANCE hInstance, DWORD dwReserved)
{
	// initialization callback marker
	mixin(PELOCK_INIT_CALLBACK);

	// initialization callbacks are called only once, so
	// it's safe to erase its code after execution
	mixin(CLEAR_START);

	dwSecretValue1 = 2;

	mixin(CLEAR_END);
}

//
// second callback, you can place as many callbacks as you want
//
extern (Windows) void pelock_initalization_callback_2(HINSTANCE hInstance, DWORD dwReserved)
{
	// initialization callback marker
	mixin(PELOCK_INIT_CALLBACK);

	// initialization callbacks are called only once, so
	// it's safe to erase its code after execution
	mixin(CLEAR_START);

	dwSecretValue2 = 2;

	mixin(CLEAR_END);
}

int main(string args[])
{
	writef("Calculation result 2 + 2 = %d\n", dwSecretValue1 + dwSecretValue2);

	writef("\n\nPress any key to exit . . .");

	getchar();

	// protection against compiler optimizations (so it doesn't remove unreferenced functions)
	if ( (&pelock_initalization_callback_1 == null) || (&pelock_initalization_callback_2 == null) )
	{
		pelock_initalization_callback_1(null, 0);
		pelock_initalization_callback_2(null, 0);
	}

	return 0;
}
