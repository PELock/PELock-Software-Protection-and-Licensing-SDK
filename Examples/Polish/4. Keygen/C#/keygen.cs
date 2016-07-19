////////////////////////////////////////////////////////////////////////////////
//
// Plik naglowkowy biblioteki generatora kluczy licencyjnych
//
// Wersja         : PELock v2.0
// Jezyk          : C#
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

using System;
using System.Runtime.InteropServices;

namespace PELock
{
	/// <summary>
	/// Deklaracje stalych wartosci i struktur dla generatory kluczy PELock
	/// </summary>
	public class Keygenerator
	{
		// max. rozmiar nazwy uzytkownika zapisanej w kluczu, wlaczajac konczace zero
		public const int PELOCK_MAX_USERNAME = 8193;

		// safe buffer size for key data
		public const int PELOCK_SAFE_KEY_SIZE = (40*1024);

		// formaty wyjsciowe kluczy

		// klucz w formie binarnej
		public const int KEY_FORMAT_BIN = 0;

		// klucz w formie zrzutu rejestru Windows (.reg)
		public const int KEY_FORMAT_REG = 1;

		// klucz tekstowy (w formacie MIME Base64)
		public const int KEY_FORMAT_TXT = 2;

		// kody bledow dla Keygen()

		// dane licencyjne poprawnie wygenerowane
		public const int KEYGEN_SUCCESS = 0;

		// nieprawidlowe parametry (lub brakujace)
		public const int KEYGEN_INVALID_PARAMS = 1;

		// nieprawidlowy plik projektu (np. uszkodzony)
		public const int KEYGEN_INVALID_PROJECT = 2;

		// brak pamieci
		public const int KEYGEN_OUT_MEMORY = 3;

		// wewnetrzny blad podczas generowania klucza
		public const int KEYGEN_DATA_ERROR = 4;

		// kody bledow dla VerifyKey()

		// dane licencyjne poprawnie zweryfikowane
		public const int KEYGEN_VERIFY_SUCCESS = 0;

		// nieprawidlowe parametry (lub brakujace)
		public const int KEYGEN_VERIFY_INVALID_PARAMS = 1;

		// nieprawidlowy plik projektu (np. uszkodzony)
		public const int KEYGEN_VERIFY_INVALID_PROJECT = 2;

		// brak pamieci
		public const int KEYGEN_VERIFY_OUT_MEMORY = 3;

		// blad podczas weryfikowania poprawnosci klucza
		public const int KEYGEN_VERIFY_DATA_ERROR = 4;

		// nie mozna otworzyc pliku klucza
		public const int KEYGEN_VERIFY_FILE_ERROR = 5;

		/// <summary>
		/// nazwa pliku projektu lub wskaznik do danych projektu w pamieci
		/// </summary>
		[StructLayoutAttribute(LayoutKind.Explicit)]
		public struct KeygenProjectPtrUnion
		{
			// sciezka pliku projektu
			[FieldOffsetAttribute(0), MarshalAsAttribute(UnmanagedType.LPStr)]
			public string lpszProjectPath;

			// bufor tekstowy z zawartoscia pliku projektu
			[FieldOffsetAttribute(0), MarshalAsAttribute(UnmanagedType.LPStr)]
			public string lpszProjectBuffer;
		}

		/// <summary>
		/// nazwa uzytkownika lub dowolne inne dane np. w formie
		/// binarnej
		/// </summary>
		[StructLayoutAttribute(LayoutKind.Explicit)]
		public struct KeygenUsernamePtrUnion
		{
			// wskaznik do nazwy uzytkownika
			[FieldOffsetAttribute(0)]
			public byte[] lpszUsername;

			// wskaznik do innych danych licencyjnych (dowolnych, np. binarnych)
			[FieldOffsetAttribute(0)]
			public byte[] lpUsernameRawData;
		}

		/// <summary>
		/// rozmiar nazwy uzytkownika lub innych danych licencyjnych
		/// </summary>
		[StructLayoutAttribute(LayoutKind.Explicit)]
		public struct KeygenUsernameSizeUnion
		{
			// rozmiar nazwy uzytkownika (max. 8192 znakow)
			[FieldOffsetAttribute(0)]
			public int dwUsernameLength;

			// rozmiar danych binarnych (max. 8192 bajtow)
			[FieldOffsetAttribute(0)]
			public int dwUsernameRawSize;
		}

		/// <summary>
		/// dodatkowe opcje jako 4 bajty
		/// </summary>
		[StructLayoutAttribute(LayoutKind.Sequential)]
		public struct dwKeyDataStruct
		{
			public byte dwKeyData1;
			public byte dwKeyData2;
			public byte dwKeyData3;
			public byte dwKeyData4;
		}

		/// <summary>
		/// dodatkowe opcje jako 32 bity
		/// </summary>
		[StructLayoutAttribute(LayoutKind.Sequential)]
		public struct bFeaturesStruct
		{
			public uint dwFeatures;

			public uint bFeature1
			{
				get { return ((uint)((this.dwFeatures & 1u))); }
				set { this.dwFeatures = ((uint)((value | this.dwFeatures))); }
			}

			public uint bFeature2
			{
				get { return ((uint)(((this.dwFeatures & 2u) / 2))); }
				set { this.dwFeatures = ((uint)(((value * 2) | this.dwFeatures))); }
			}

			public uint bFeature3
			{
				get { return ((uint)(((this.dwFeatures & 4u) / 4))); }
				set { this.dwFeatures = ((uint)(((value * 4) | this.dwFeatures))); }
			}

			public uint bFeature4
			{
				get { return ((uint)(((this.dwFeatures & 8u) / 8))); }
				set { this.dwFeatures = ((uint)(((value * 8) | this.dwFeatures))); }
			}

			public uint bFeature5
			{
				get { return ((uint)(((this.dwFeatures & 16u) / 16))); }
				set { this.dwFeatures = ((uint)(((value * 16) | this.dwFeatures))); }
			}

			public uint bFeature6
			{
				get { return ((uint)(((this.dwFeatures & 32u) / 32))); }
				set { this.dwFeatures = ((uint)(((value * 32) | this.dwFeatures))); }
			}

			public uint bFeature7
			{
				get { return ((uint)(((this.dwFeatures & 64u) / 64))); }
				set { this.dwFeatures = ((uint)(((value * 64) | this.dwFeatures))); }
			}

			public uint bFeature8
			{
				get { return ((uint)(((this.dwFeatures & 128u) / 128))); }
				set { this.dwFeatures = ((uint)(((value * 128) | this.dwFeatures))); }
			}

			public uint bFeature9
			{
				get { return ((uint)(((this.dwFeatures & 256u) / 256))); }
				set { this.dwFeatures = ((uint)(((value * 256) | this.dwFeatures))); }
			}

			public uint bFeature10
			{
				get { return ((uint)(((this.dwFeatures & 512u) / 512))); }
				set { this.dwFeatures = ((uint)(((value * 512) | this.dwFeatures))); }
			}

			public uint bFeature11
			{
				get { return ((uint)(((this.dwFeatures & 1024u) / 1024))); }
				set { this.dwFeatures = ((uint)(((value * 1024) | this.dwFeatures))); }
			}

			public uint bFeature12
			{
				get { return ((uint)(((this.dwFeatures & 2048u) / 2048))); }
				set { this.dwFeatures = ((uint)(((value * 2048) | this.dwFeatures))); }
			}

			public uint bFeature13
			{
				get { return ((uint)(((this.dwFeatures & 4096u) / 4096))); }
				set { this.dwFeatures = ((uint)(((value * 4096) | this.dwFeatures))); }
			}

			public uint bFeature14
			{
				get { return ((uint)(((this.dwFeatures & 8192u) / 8192))); }
				set { this.dwFeatures = ((uint)(((value * 8192) | this.dwFeatures))); }
			}

			public uint bFeature15
			{
				get { return ((uint)(((this.dwFeatures & 16384u) / 16384))); }
				set { this.dwFeatures = ((uint)(((value * 16384) | this.dwFeatures))); }
			}

			public uint bFeature16
			{
				get { return ((uint)(((this.dwFeatures & 32768u) / 32768))); }
				set { this.dwFeatures = ((uint)(((value * 32768) | this.dwFeatures))); }
			}

			public uint bFeature17
			{
				get { return ((uint)(((this.dwFeatures & 65536u) / 65536))); }
				set { this.dwFeatures = ((uint)(((value * 65536) | this.dwFeatures))); }
			}

			public uint bFeature18
			{
				get { return ((uint)(((this.dwFeatures & 131072u) / 131072))); }
				set { this.dwFeatures = ((uint)(((value * 131072) | this.dwFeatures))); }
			}

			public uint bFeature19
			{
				get { return ((uint)(((this.dwFeatures & 262144u) / 262144))); }
				set { this.dwFeatures = ((uint)(((value * 262144) | this.dwFeatures))); }
			}

			public uint bFeature20
			{
				get { return ((uint)(((this.dwFeatures & 524288u) / 524288))); }
				set { this.dwFeatures = ((uint)(((value * 524288) | this.dwFeatures))); }
			}

			public uint bFeature21
			{
				get { return ((uint)(((this.dwFeatures & 1048576u) / 1048576))); }
				set { this.dwFeatures = ((uint)(((value * 1048576) | this.dwFeatures))); }
			}

			public uint bFeature22
			{
				get { return ((uint)(((this.dwFeatures & 2097152u) / 2097152))); }
				set { this.dwFeatures = ((uint)(((value * 2097152) | this.dwFeatures))); }
			}

			public uint bFeature23
			{
				get { return ((uint)(((this.dwFeatures & 4194304u) / 4194304))); }
				set { this.dwFeatures = ((uint)(((value * 4194304) | this.dwFeatures))); }
			}

			public uint bFeature24
			{
				get { return ((uint)(((this.dwFeatures & 8388608u) / 8388608))); }
				set { this.dwFeatures = ((uint)(((value * 8388608) | this.dwFeatures))); }
			}

			public uint bFeature25
			{
				get { return ((uint)(((this.dwFeatures & 16777216u) / 16777216))); }
				set { this.dwFeatures = ((uint)(((value * 16777216) | this.dwFeatures))); }
			}

			public uint bFeature26
			{
				get { return ((uint)(((this.dwFeatures & 33554432u) / 33554432))); }
				set { this.dwFeatures = ((uint)(((value * 33554432) | this.dwFeatures))); }
			}

			public uint bFeature27
			{
				get { return ((uint)(((this.dwFeatures & 67108864u) / 67108864))); }
				set { this.dwFeatures = ((uint)(((value * 67108864) | this.dwFeatures))); }
			}

			public uint bFeature28
			{
				get { return ((uint)(((this.dwFeatures & 134217728u) / 134217728))); }
				set { this.dwFeatures = ((uint)(((value * 134217728) | this.dwFeatures))); }
			}

			public uint bFeature29
			{
				get { return ((uint)(((this.dwFeatures & 268435456u) / 268435456))); }
				set { this.dwFeatures = ((uint)(((value * 268435456) | this.dwFeatures))); }
			}

			public uint bFeature30
			{
				get { return ((uint)(((this.dwFeatures & 536870912u) / 536870912))); }
				set { this.dwFeatures = ((uint)(((value * 536870912) | this.dwFeatures))); }
			}

			public uint bFeature31
			{
				get { return ((uint)(((this.dwFeatures & 1073741824u) / 1073741824))); }
				set { this.dwFeatures = ((uint)(((value * 1073741824) | this.dwFeatures))); }
			}

			public uint bFeature32
			{
				get { return ((uint)(((this.dwFeatures & 2147483648u) / 2147483648))); }
				set { this.dwFeatures = ((uint)(((value * 2147483648) | this.dwFeatures))); }
			}
		}

		/// <summary>
		/// dodatkowe opcje bitowe w formie DWORDa, 4 bajtow lub 32 bitow
		/// </summary>
		[StructLayoutAttribute(LayoutKind.Explicit)]
		public struct KeygenFeaturesUnion
		{
			// dodatkowe opcje bitowe w formie DWORDa
			[FieldOffsetAttribute(0)]
			public uint dwFeatureBits;

			// dodatkowe opcje bitowe w formie 4 bajtow
			[FieldOffsetAttribute(0)]
			public dwKeyDataStruct dwKeyData;

			// dodatkowe opcje bitowe w postaci 32 bitow
			[FieldOffsetAttribute(0)]
			public bFeaturesStruct bFeatures;
		}

		/// <summary>
		/// plik klucza lub bufor pamieci z zawartoscia klucza
		/// </summary>
		[StructLayoutAttribute(LayoutKind.Explicit)]
		public struct KeygenKeyPtrUnion
		{
			// sciezka pliku klucza (wejscie)
			[FieldOffsetAttribute(0), MarshalAsAttribute(UnmanagedType.LPStr)]
			public string lpszKeyPath;

			// bufor pamieci z zawartoscia klucza (wejscie)
			[FieldOffsetAttribute(0)]
			public byte[] lpKeyBuffer;
		}

		/// <summary>
		/// struktura opisujaca date
		/// <summary>
		[StructLayoutAttribute(LayoutKind.Sequential, Pack = 1, Size = 16)]
		public struct SYSTEMTIME
		{
			public ushort wYear;
			public ushort wMonth;
			public ushort wDayOfWeek;
			public ushort wDay;
			public ushort wHour;
			public ushort wMinute;
			public ushort wSecond;
			public ushort wMilliseconds;
		}

		/// <summary>
		/// struktura opisujaca parametry dla generowanego klucza
		/// <summary>
		[StructLayoutAttribute(LayoutKind.Sequential)]
		public struct KEYGEN_PARAMS
		{
			// wskaznik bufora na dane wyjsciowe (musi byc odpowiednio duzy)
			public IntPtr lpOutputBuffer;

			// wskaznik na wartosc DWORD, gdzie zostanie zapisany rozmiar danych licencynych
			public IntPtr lpdwOutputSize;

			// wyjsciowy format klucza (klucz w formie binarnej, w formie zrzutu rejestru Windows etc.)
			public uint dwOutputFormat;

			// nazwa pliku projektu lub wskaznik do danych projektu w pamieci
			public KeygenProjectPtrUnion KeygenProjectPtr;

			// czy lpszProjectBuffer wskazuje na bufor tekstowy zamiast na plik
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bProjectBuffer;

			// flaga okreslajaca czy ma byc uaktualniony plik projektu (czy dodac uzytkownika)
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bUpdateProject;

			// wskaznik do wartosci BOOL, gdzie zostanie zapisany status uaktualnienia projektu
			public IntPtr lpbProjectUpdated;

			// wskaznik do nazwy uzytkownika lub dowolnych innych danych licencyjnych
			public KeygenUsernamePtrUnion KeygenUsernamePtr;

			// rozmiar nazwy uzytkownika lub dowolnych innych danych licencyjnych (max. 8192 znakow/bajtow)
			public KeygenUsernameSizeUnion KeygenUsernameSize;

			// czy uzyc blokowania licencji na identyfikator sprzetowy
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bSetHardwareLock;

			// czy zaszyfrowac nazwe uzytkownika i dodatkowe pola klucza wedlug identyfikatora sprzetowego
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bSetHardwareEncryption;

			// identyfikator sprzetowy
			[MarshalAsAttribute(UnmanagedType.LPStr)]
			public string lpszHardwareId;

			// czy ustawic dodatkowe wartosci liczbowe klucza
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bSetKeyIntegers;

			// dodatkowych 8 wartosci liczbowych klucza
			[MarshalAsAttribute(UnmanagedType.ByValArray, SizeConst=16, ArraySubType=UnmanagedType.U4)]
			public uint[] dwKeyIntegers;

			// czy ustawic date utworzenia klucza
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bSetKeyCreationDate;

			// data utworzenia klucza
			public IntPtr lpKeyCreation;

			// czy ustawic date wygasniecia klucza
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bSetKeyExpirationDate;

			// data wygasniecia klucza
			public IntPtr lpKeyExpiration;

			// czy ustawic dodatkowe opcje bitowe klucza (obsluga sekcji FEATURE_x_START)
			[MarshalAsAttribute(UnmanagedType.Bool)] 
			public bool bSetFeatureBits;

			// dodatkowe opcje bitowe
			public KeygenFeaturesUnion KeygenFeatures;
		}

		/// <summary>
		/// struktura opisujaca parametry dla weryfikacji klucza
		/// <summary>
		[StructLayoutAttribute(LayoutKind.Sequential)]
		public struct KEYGEN_VERIFY_PARAMS
		{
			// sciezka do pliku klcuza lub bufor pamieci z zawartoscia klucza (input)
			public KeygenKeyPtrUnion lpKeyPtr;

			// czy lpKeyBuffer wskazuje na bufor z zawartoscia klucza (wejscie)
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bKeyBuffer;

			// rozmiar klucza w buforze lpKeyBuffer (wejscie)
			public uint dwKeyBufferSize;

			// nazwa pliku projektu lub wskaznik do danych projektu w pamieci (wejscie)
			public KeygenProjectPtrUnion KeygenProjectPtr;

			// czy lpszProjectBuffer wskazuje na bufor tekstowy zamiast na plik (wejscie)
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bProjectBuffer;

			// wyjsciowy format klucza (klucz w formie binarnej, w formie zrzutu rejestru Windows etc.)
			public uint dwOutputFormat;

			// wskaznik do nazwy uzytkownika lub dowolnych innych danych licencyjnych
			public KeygenUsernamePtrUnion KeygenUsernamePtr;

			// rozmiar nazwy uzytkownika lub dowolnych innych danych licencyjnych (max. 8192 znakow/bajtow)
			public KeygenUsernameSizeUnion KeygenUsernameSize;

			// czy uzyte jest blokowanie licencji na identyfikator sprzetowy
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bHardwareLock;

			// czy nazwa uzytkownika i dodatkowe pola klucza sa zaszyfrowane wedlug identyfikatora sprzetowego
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bHardwareEncryption;

			// czy ustawione sa dodatkowe wartosci liczbowe klucza
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bKeyIntegers;

			// dodatkowych 16 wartosci liczbowych klucza
			[MarshalAsAttribute(UnmanagedType.ByValArray, SizeConst=16, ArraySubType=UnmanagedType.U4)]
			public uint[] dwKeyIntegers;

			// czy ustawiona jest data utworzenia klucza
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bKeyCreationDate;

			// data utworzenia klucza
			public IntPtr lpKeyCreation;

			// czy ustawiona jest data wygasniecia klucza
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bKeyExpirationDate;

			// data wygasniecia klucza
			public IntPtr lpKeyExpiration;

			// czy ustawione sa dodatkowe opcje bitowe klucza (obsluga sekcji FEATURE_x_START)
			[MarshalAsAttribute(UnmanagedType.Bool)] 
			public bool bFeatureBits;

			// dodatkowe opcje bitowe
			public KeygenFeaturesUnion KeygenFeatures;

			// suma kontrolna klucza (moze byc wykorzystana do umieszczenia go na liscie zablokowanych kluczy)
			[MarshalAsAttribute(UnmanagedType.ByValArray, SizeConst=32, ArraySubType=UnmanagedType.U1)]
			public byte[] cChecksum;
		}

		// prototyp funkcji Keygen()
		//[UnmanagedFunctionPointerAttribute(CallingConvention.StdCall)]
		//public delegate uint PELOCK_KEYGEN(ref KEYGEN_PARAMS lpKeygenParams);

		// prototyp funkcji VerifyKey()
		//[UnmanagedFunctionPointerAttribute(CallingConvention.StdCall)]
		//public delegate uint PELOCK_VERIFY_KEY(ref KEYGEN_VERIFY_PARAMS lpKeygenVerifyParams);

		[DllImportAttribute("keygen.dll", EntryPoint="Keygen", CallingConvention=CallingConvention.StdCall)]
		public static extern uint Keygen(ref KEYGEN_PARAMS lpKeygenParams);

		[DllImportAttribute("keygen.dll", EntryPoint="VerifyKey", CallingConvention=CallingConvention.StdCall)]
		public static extern uint VerifyKey(ref KEYGEN_VERIFY_PARAMS lpKeygenVerifyParams);
	}
}