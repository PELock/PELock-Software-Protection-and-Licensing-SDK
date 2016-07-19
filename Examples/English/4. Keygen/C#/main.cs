////////////////////////////////////////////////////////////////////////////////
//
// Example of how to use keygen library to generate license keys
//
// Version        : PELock v2.0
// Language       : C#
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
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
			// build project path name
			//
			///////////////////////////////////////////////////////////////////////////////

			string szProjectPath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), "test.plk");

			///////////////////////////////////////////////////////////////////////////////
			//
			// fill PELOCK_KEYGEN_PARAMS structure
			//
			///////////////////////////////////////////////////////////////////////////////

			// output buffer pointer (it must be large engough)
			IntPtr lpKeyData = Marshal.AllocHGlobal(Keygenerator.PELOCK_SAFE_KEY_SIZE);
			kpKeygenParams.lpOutputBuffer = lpKeyData;

			// pointer to the DWORD where key size will be stored
			IntPtr lpdwKeyDataSize = Marshal.AllocHGlobal(Marshal.SizeOf(typeof(uint)));
			kpKeygenParams.lpdwOutputSize = lpdwKeyDataSize;

			// output key format
			// KEY_FORMAT_BIN - binary key
			// KEY_FORMAT_REG - Windows registry key dump
			// KEY_FORMAT_TXT - text key (in MIME Base64 format)
			kpKeygenParams.dwOutputFormat = Keygenerator.KEY_FORMAT_BIN;

			// project file path
			kpKeygenParams.KeygenProjectPtr.lpszProjectPath = szProjectPath;

			// are we using text buffer with project file contents (instead of project file)?
			kpKeygenParams.bProjectBuffer = false;

			// add user to the project file
			kpKeygenParams.bUpdateProject = false;

			// pointer to the BOOL that will receive update status
			kpKeygenParams.lpbProjectUpdated = IntPtr.Zero;

			// user name pointer
			string szUsername = "Laura Palmer";
			ASCIIEncoding ASCII = new ASCIIEncoding();
			UnicodeEncoding UNICODE = new UnicodeEncoding();

			// allocate memory for the user name
			kpKeygenParams.KeygenUsernamePtr.lpszUsername = new byte[Keygenerator.PELOCK_MAX_USERNAME];

			// ASCII/UNICODE encoding
			//kpKeygenParams.KeygenUsernamePtr.lpszUsername = ASCII.GetBytes(szUsername);
			kpKeygenParams.KeygenUsernamePtr.lpUsernameRawData = UNICODE.GetBytes(szUsername);

			// username length (max. 8192 chars)
			//kpKeygenParams.KeygenUsernameSize.dwUsernameLength = ASCII.GetByteCount(szUsername);
			kpKeygenParams.KeygenUsernameSize.dwUsernameLength = UNICODE.GetByteCount(szUsername);

			// use hardware id locking
			kpKeygenParams.bSetHardwareLock = false;

			// encrypt user name and custom key fields with hardware id
			kpKeygenParams.bSetHardwareEncryption = false;

			// hardware id string
			kpKeygenParams.lpszHardwareId = "";

			// set key integers
			kpKeygenParams.bSetKeyIntegers = false;

			// 16 custom key values
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

			// set key creation date
			kpKeygenParams.bSetKeyCreationDate = true;

			// key creation date
			DateTime dtLocalTime = DateTime.Now;
			kpKeygenParams.stKeyCreation.wDay = (ushort)dtLocalTime.Day;
			kpKeygenParams.stKeyCreation.wMonth = (ushort)dtLocalTime.Month;
			kpKeygenParams.stKeyCreation.wYear = (ushort)dtLocalTime.Year;

			// set key expiration date
			kpKeygenParams.bSetKeyExpirationDate = false;

			// key expiration date
			//kpKeygenParams.stKeyExpiration.wDay = 01;
			//kpKeygenParams.stKeyExpiration.wMonth = 01;
			//kpKeygenParams.stKeyExpiration.wYear = 2012;

			// set feature bits
			kpKeygenParams.bSetFeatureBits = true;

			// features bits as a DWORD, 4 BYTEs or 32 bits
			//kpKeygenParams.KeygenFeatures.dwFeatureBits = 0xFFFFFFFF;
			//kpKeygenParams.KeygenFeatures.dwKeyData.dwKeyData1 = 128;
			kpKeygenParams.KeygenFeatures.bFeatures.bFeature1 = 1;

			///////////////////////////////////////////////////////////////////////////////
			//
			// generate key data
			//
			///////////////////////////////////////////////////////////////////////////////

			uint dwResult = Keygenerator.Keygen(ref kpKeygenParams);

			switch (dwResult)
			{
				// key successfully generated
				case Keygenerator.KEYGEN_SUCCESS:

					try
					{
						string[] szFileNames = new string[] { "key.lic", "key.reg", "key.txt" };

						// save license key data to file
						FileStream hFile = new FileStream(szFileNames[kpKeygenParams.dwOutputFormat], FileMode.Create);

						BinaryWriter binWriter = new BinaryWriter(hFile);

						// read output key size (from an unmanaged memory pointer)
						int dwKeyDataSize = Marshal.ReadInt32(lpdwKeyDataSize);

						// allocate Byte[] array
						Byte[] bytesKeyData = new byte[dwKeyDataSize];

						// copy unmanaged memory with key contents into managed Byte[] array
						Marshal.Copy(lpKeyData, bytesKeyData, 0, dwKeyDataSize);

						// write output file
						binWriter.Write(bytesKeyData);

						Console.Write("Key file successfully generated!");

						hFile.Close();
					}
					catch (System.Exception ex)
					{
						Console.Write("Couldn't create key file {0}!", ex.Message);
					}

					break;

				// invalid input params (or missing params)
				case Keygenerator.KEYGEN_INVALID_PARAMS:

					Console.Write("Invalid input params (check PELOCK_KEY_PARAMS structure)!");
					break;

				// invalid project file
				case Keygenerator.KEYGEN_INVALID_PROJECT:

					Console.Write("Invalid project file, please check it, maybe it's missing some data!");
					break;

				// out of memory in Keygen() procedure
				case Keygenerator.KEYGEN_OUT_MEMORY:

					Console.Write("Out of memory!");
					break;

				// data generation error
				case Keygenerator.KEYGEN_DATA_ERROR:

					Console.Write("Error while generating license key data, please contact with author!");
					break;

				// unknown errors
				default:

					Console.Write("Unknown error, please contact with author!");
					break;
			}

			// release memory
			Marshal.FreeHGlobal(lpKeyData);
			Marshal.FreeHGlobal(lpdwKeyDataSize);

			Console.Write("\n\nPress any key to exit . . .");
			_getch();
		}
	}
}
