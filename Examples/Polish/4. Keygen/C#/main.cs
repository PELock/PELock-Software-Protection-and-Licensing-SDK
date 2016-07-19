////////////////////////////////////////////////////////////////////////////////
//
// Przyklad uzycia biblioteki generatora kluczy licencyjnych
//
// Wersja         : PELock v2.0
// Jezyk          : C#
// Autor          : Bartosz Wójcik (support@pelock.com)
// Strona domowa  : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

using System;
using System.Text;
using System.IO;
using System.Reflection;
using System.Runtime;
using System.Runtime.InteropServices;
using PELock;

namespace KeygeneratorTest
{
	/// <summary>
	/// Summary description for Program.
	/// </summary>
	class Program
	{
		[DllImport("msvcrt")]
		static extern int _getch();

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main(string[] args)
		{
			Keygenerator.KEYGEN_PARAMS kpKeygenParams = new Keygenerator.KEYGEN_PARAMS();

			///////////////////////////////////////////////////////////////////////////////
			//
			// zbuduj sciezke do pliku projektu, w ktorym zapisane sa klucze szyfrujace
			//
			///////////////////////////////////////////////////////////////////////////////

			string szProjectPath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), "test.plk");

			///////////////////////////////////////////////////////////////////////////////
			//
			// wypelnij strukture PELOCK_KEYGEN_PARAMS
			//
			///////////////////////////////////////////////////////////////////////////////

			// wskaznik do bufora wyjsciowego na klucz licencyjny (musi byc odpowiednio duzy)
			IntPtr lpKeyData = Marshal.AllocHGlobal(Keygenerator.PELOCK_SAFE_KEY_SIZE);
			kpKeygenParams.lpOutputBuffer = lpKeyData;

			// wskaznik do wartosci DWORD, gdzie zostanie zapisany rozmiar wygenerowanego klucza
			IntPtr lpdwKeyDataSize = Marshal.AllocHGlobal(Marshal.SizeOf(typeof(uint)));
			kpKeygenParams.lpdwOutputSize = lpdwKeyDataSize;

			// wyjsciowy format klucza
			// KEY_FORMAT_BIN - binarny klucz
			// KEY_FORMAT_REG - klucz w formie zrzutu rejestru Windows
			// KEY_FORMAT_TXT - klucz tekstowy (w formacie MIME Base64)
			kpKeygenParams.dwOutputFormat = Keygenerator.KEY_FORMAT_BIN;

			// sciezka do odpowiedniego pliku projektu
			kpKeygenParams.KeygenProjectPtr.lpszProjectPath = szProjectPath;

			// czy uzywamy tekstowego bufora z zawartoscia pliku projektu (zamiast samego pliku projektu)?
			kpKeygenParams.bProjectBuffer = false;

			// czy automatycznie dodac uzytkownika, dla ktorego generowany jest klucz do pliku projektu?
			kpKeygenParams.bUpdateProject = false;

			// wskaznik do wartosci BOOL, gdzie zostanie zapisany status czy udalo sie dodac uzytkownika do pliku projektu
			kpKeygenParams.lpbProjectUpdated = IntPtr.Zero;

			//  wskaznik do nazwy uzytkownika (lub innych danych licencyjnych, moga to byc dane binarne etc.)
			string szUsername = "Laura Palmer";
			ASCIIEncoding ASCII = new ASCIIEncoding();
			UnicodeEncoding UNICODE = new UnicodeEncoding();

			// alokuj pamiec na nazwe uzytkownika
			kpKeygenParams.KeygenUsernamePtr.lpszUsername = new byte[Keygenerator.PELOCK_MAX_USERNAME];

			// kodowanie znakow ASCII/UNICODE
			//kpKeygenParams.KeygenUsernamePtr.lpszUsername = ASCII.GetBytes(szUsername);
			kpKeygenParams.KeygenUsernamePtr.lpUsernameRawData = UNICODE.GetBytes(szUsername);

			// rozmiar nazwy uzytkownika lub innych danych licencyjnych (max. 8192 znakow/bajtow)
			//kpKeygenParams.KeygenUsernameSize.dwUsernameLength = ASCII.GetByteCount(szUsername);
			kpKeygenParams.KeygenUsernameSize.dwUsernameLength = UNICODE.GetByteCount(szUsername);

			// flaga czy korzystac z blokady na sprzetowy identyfikator?
			kpKeygenParams.bSetHardwareLock = false;

			// czy zaszyfrowac nazwe uzytkownika i dodatkowe pola klucza wedlug identyfikatora sprzetowego
			kpKeygenParams.bSetHardwareEncryption = false;

			// ciag znakow identyfikatora sprzetowego
			kpKeygenParams.lpszHardwareId = "";

			// czy ustawic dodatkowe wartosci liczbowe w kluczu licencyjnym
			kpKeygenParams.bSetKeyIntegers = false;

			// 16 dodatkowych wartosci liczbowych, ktore zostana zapisane w kluczu (jesli byla ustawiona flaga)
			kpKeygenParams.dwKeyIntegers = new uint[16];
			kpKeygenParams.dwKeyIntegers[0] = 1;
			kpKeygenParams.dwKeyIntegers[1] = 2;
			kpKeygenParams.dwKeyIntegers[2] = 3;
			kpKeygenParams.dwKeyIntegers[3] = 4;
			kpKeygenParams.dwKeyIntegers[4] = 5;
			kpKeygenParams.dwKeyIntegers[5] = 6;
			kpKeygenParams.dwKeyIntegers[6] = 7;
			kpKeygenParams.dwKeyIntegers[7] = 8;
			kpKeygenParams.dwKeyIntegers[8] = 9;
			kpKeygenParams.dwKeyIntegers[9] = 10;
			kpKeygenParams.dwKeyIntegers[10] = 11;
			kpKeygenParams.dwKeyIntegers[11] = 12;
			kpKeygenParams.dwKeyIntegers[12] = 13;
			kpKeygenParams.dwKeyIntegers[13] = 14;
			kpKeygenParams.dwKeyIntegers[14] = 15;
			kpKeygenParams.dwKeyIntegers[15] = 16;

			// flaga czy ustawic date utworzenia klucza
			kpKeygenParams.bSetKeyCreationDate = true;

			// data utworzenia klucza (SYSTEMTIME)
			DateTime dtLocalTime = DateTime.Now;
			kpKeygenParams.stKeyCreation.wDay = (ushort)dtLocalTime.Day;
			kpKeygenParams.stKeyCreation.wMonth = (ushort)dtLocalTime.Month;
			kpKeygenParams.stKeyCreation.wYear = (ushort)dtLocalTime.Year;

			// flaga czy ustawic date wygasniecia klucza
			kpKeygenParams.bSetKeyExpirationDate = false;

			// data wygasniecia klucza
			//kpKeygenParams.stKeyExpiration.wDay = 01;
			//kpKeygenParams.stKeyExpiration.wMonth = 01;
			//kpKeygenParams.stKeyExpiration.wYear = 2012;

			// flaga czy ustawic dodatkowe znaczniki bitowe (obsluga m.in. sekcji FEATURE_x_START)
			kpKeygenParams.bSetFeatureBits = true;

			// znaczniki bitowe w postaci wartosci DWORD, 4 bajtow lub 32 bitow
			//kpKeygenParams.KeygenFeatures.dwFeatureBits = 0xFFFFFFFF;
			//kpKeygenParams.KeygenFeatures.dwKeyData.dwKeyData1 = 128;
			kpKeygenParams.KeygenFeatures.bFeatures.bFeature1 = 1;

			///////////////////////////////////////////////////////////////////////////////
			//
			// utworz klucz licencyjny
			//
			///////////////////////////////////////////////////////////////////////////////

			uint dwResult = Keygenerator.Keygen(ref kpKeygenParams);

			switch (dwResult)
			{
				// klucz licencyjny poprawnie wygenerowany
				case Keygenerator.KEYGEN_SUCCESS:

					try
					{
						string[] szFileNames = new string[] { "key.lic", "key.reg", "key.txt" };

						// zapisz dane klucza licencyjnego do pliku
						FileStream hFile = new FileStream(szFileNames[kpKeygenParams.dwOutputFormat], FileMode.Create);

						BinaryWriter binWriter = new BinaryWriter(hFile);

						// odczytaj rozmiar wygenerowanego klucza (ze wskaznika pamieci typu unmanaged)
						int dwKeyDataSize = Marshal.ReadInt32(lpdwKeyDataSize);

						// alokuj tablice Byte[]
						Byte[] bytesKeyData = new byte[dwKeyDataSize];

						// kopiuj zawartosc klucza z pamieci typu unmanaged do tablicy Byte[]
						Marshal.Copy(lpKeyData, bytesKeyData, 0, dwKeyDataSize);

						// zapisz plik wyjsciowy
						binWriter.Write(bytesKeyData);

						Console.Write("Klucz licencyjny zostal poprawnie wygenerowany!");

						hFile.Close();
					}
					catch (System.Exception ex)
					{
						Console.Write("Nie mozna utworzyc pliku klucza licencyjnego {0}!", ex.Message);
					}

					break;

				// nieprawidlowe parametry wejsciowe (lub brakujace parametry)
				case Keygenerator.KEYGEN_INVALID_PARAMS:

					Console.Write("Niepoprawne parametry wejsciowe (sprawdz strukture PELOCK_KEY_PARAMS)!");
					break;

				// nieprawidlowy plik projektu
				case Keygenerator.KEYGEN_INVALID_PROJECT:

					Console.Write("Nieprawidlowy plik projektu, byc moze jest on uszkodzony!");
					break;

				// blad alokacji pamieci w procedurze Keygen()
				case Keygenerator.KEYGEN_OUT_MEMORY:

					Console.Write("Zabraklo pamieci do wygenerowania klucza!");
					break;

				// blad generacji danych klucza licencyjnego
				case Keygenerator.KEYGEN_DATA_ERROR:

					Console.Write("Wystapil blad podczas generowania danych licencyjnych, prosze skontaktowac sie z autorem!");
					break;

				// nieznane bledy
				default:

					Console.Write("Nieznany blad, prosze skontaktowac sie z autorem!");
					break;
			}

			// zwolnij pamiec
			Marshal.FreeHGlobal(lpKeyData);
			Marshal.FreeHGlobal(lpdwKeyDataSize);

			Console.Write("\n\nNacisnij dowolny klawisz, aby kontynuowac . . .");
			_getch();
		}
	}
}
