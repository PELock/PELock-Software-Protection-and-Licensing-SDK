////////////////////////////////////////////////////////////////////////////////
//
// Keygen library header
//
// Version        : PELock v2.0
// Language       : C#
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

using System;
using System.Runtime.InteropServices;

namespace PELock
{
	/// <summary>
	/// PELock's keygenerator constants and structures
	/// </summary>
	public class Keygenerator
	{
		// max size of registered user name stored in the keyfile
		public const int PELOCK_MAX_USERNAME = 8193;

		// safe buffer size for key data		
		public const int PELOCK_SAFE_KEY_SIZE = (40*1024);

		// output key formats

		// binary key (raw bytes)
		public const int KEY_FORMAT_BIN = 0;

		// Windows registry key dump (.reg)
		public const int KEY_FORMAT_REG = 1;

		// text key (in MIME Base64 format)
		public const int KEY_FORMAT_TXT = 2;

		// Keygen() return values

		// key successfully generated
		public const int KEYGEN_SUCCESS = 0;

		// invalid params
		public const int KEYGEN_INVALID_PARAMS = 1;

		// invalid project file
		public const int KEYGEN_INVALID_PROJECT = 2;

		// out of memory
		public const int KEYGEN_OUT_MEMORY = 3;

		// error while generating key data
		public const int KEYGEN_DATA_ERROR = 4;

		// VerifyKey() return values

		// key successfully verified
		public const int KEYGEN_VERIFY_SUCCESS = 0;

		// invalid params
		public const int KEYGEN_VERIFY_INVALID_PARAMS = 1;

		// invalid project file
		public const int KEYGEN_VERIFY_INVALID_PROJECT = 2;

		// out of memory
		public const int KEYGEN_VERIFY_OUT_MEMORY = 3;

		// error while verifying key data
		public const int KEYGEN_VERIFY_DATA_ERROR = 4;

		// cannot open key file
		public const int KEYGEN_VERIFY_FILE_ERROR = 5;

		/// <summary>
		/// project file path or project file contents as a text buffer
		/// </summary>
		[StructLayoutAttribute(LayoutKind.Explicit)]
		public struct KeygenProjectPtrUnion
		{
			// project file path
			[FieldOffsetAttribute(0), MarshalAsAttribute(UnmanagedType.LPStr)]
			public string lpszProjectPath;

			// project file text buffer
			[FieldOffsetAttribute(0), MarshalAsAttribute(UnmanagedType.LPStr)]
			public string lpszProjectBuffer;
		}

		/// <summary>
		/// you can store either username in the key or a raw
		/// data bytes
		/// </summary>
		[StructLayoutAttribute(LayoutKind.Explicit)]
		public struct KeygenUsernamePtrUnion
		{
			// user name pointer
			[FieldOffsetAttribute(0)]
			public byte[] lpszUsername;

			// raw data pointer
			[FieldOffsetAttribute(0)]
			public byte[] lpUsernameRawData;
		}

		/// <summary>
		/// size of username string or size of raw data bytes
		/// </summary>
		[StructLayoutAttribute(LayoutKind.Explicit)]
		public struct KeygenUsernameSizeUnion
		{
			// username length (max. 8192 chars)
			[FieldOffsetAttribute(0)]
			public int dwUsernameLength;

			// raw data size (max. 8192 bytes)
			[FieldOffsetAttribute(0)]
			public int dwUsernameRawSize;
		}

		/// <summary>
		/// feature bits as a BYTES
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
		/// feature bits
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
		/// feature bits as a DWORD and as a 4 bytes
		/// </summary>
		[StructLayoutAttribute(LayoutKind.Explicit)]
		public struct KeygenFeaturesUnion
		{
			// features bits as a DWORD
			[FieldOffsetAttribute(0)]
			public uint dwFeatureBits;

			// feature bits as a BYTES
			[FieldOffsetAttribute(0)]
			public dwKeyDataStruct dwKeyData;

			// feature bits
			[FieldOffsetAttribute(0)]
			public bFeaturesStruct bFeatures;
		}

		/// <summary>
		/// key file or memory buffer with key file contents
		/// </summary>
		[StructLayoutAttribute(LayoutKind.Explicit)]
		public struct KeygenKeyPtrUnion
		{
			// key file path (input)
			[FieldOffsetAttribute(0), MarshalAsAttribute(UnmanagedType.LPStr)]
			public string lpszKeyPath;

			// key file buffer (input)
			[FieldOffsetAttribute(0)]
			public byte[] lpKeyBuffer;
		}

		/// <summary>
		/// structure for the date
		/// </summary>
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
		/// keygen params
		/// <summary>
		[StructLayoutAttribute(LayoutKind.Sequential)]
		public struct KEYGEN_PARAMS
		{
			// output buffer pointer (it must be large engough)
			public IntPtr lpOutputBuffer;

			// pointer to the DWORD where key size will be stored
			public IntPtr lpdwOutputSize;

			// output key format (binary key, Windows registry key dump etc.)
			public uint dwOutputFormat;

			// project file path or text buffer with project file contents
			public KeygenProjectPtrUnion KeygenProjectPtr;

			// is lpszProjectBuffer valid text buffer instead of file path
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bProjectBuffer;

			// add user to the project file
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bUpdateProject;

			// pointer to the BOOL that will receive update status
			public IntPtr lpbProjectUpdated;

			// username or raw data pointer
			public KeygenUsernamePtrUnion KeygenUsernamePtr;

			// username of raw data size
			public KeygenUsernameSizeUnion KeygenUsernameSize;

			// use hardware id locking
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bSetHardwareLock;

			// encrypt user name and custom key fields with hardware id
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bSetHardwareEncryption;

			// hardware id string
			[MarshalAsAttribute(UnmanagedType.LPStr)]
			public string lpszHardwareId;

			// set key integers
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bSetKeyIntegers;

			// custom key values
			[MarshalAsAttribute(UnmanagedType.ByValArray, SizeConst=16, ArraySubType=UnmanagedType.U4)]
			public uint[] dwKeyIntegers;

			// set key creation date
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bSetKeyCreationDate;

			// key creation date
			public SYSTEMTIME stKeyCreation;

			// set key expiration date
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bSetKeyExpirationDate;

			// key expiration date
			public SYSTEMTIME stKeyExpiration;

			// set feature bits
			[MarshalAsAttribute(UnmanagedType.Bool)] 
			public bool bSetFeatureBits;

			// features (additional key data)
			public KeygenFeaturesUnion KeygenFeatures;
		}

		/// <summary>
		/// keygen verify params
		/// <summary>
		[StructLayoutAttribute(LayoutKind.Sequential)]
		public struct KEYGEN_VERIFY_PARAMS
		{
			// file file path/memory buffer (input)
			public KeygenKeyPtrUnion lpKeyPtr;

			// is lpKeyBuffer valid memory buffer with key contents (input)
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bKeyBuffer;

			// lpKeyBuffer memory size (input)
			public uint dwKeyBufferSize;

			// project file path or text buffer with project file contents (input)
			public KeygenProjectPtrUnion KeygenProjectPtr;

			// is lpszProjectBuffer valid text buffer instead of file path (input)
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bProjectBuffer;

			// input key format (binary key, Windows registry key dump etc.)
			public uint dwOutputFormat;

			// username or raw data pointer
			public KeygenUsernamePtrUnion KeygenUsernamePtr;

			// username or raw data size
			public KeygenUsernameSizeUnion KeygenUsernameSize;

			// is hardware id locking used
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bHardwareLock;

			// is user name and custom key fields encrypted with a hardware id
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bHardwareEncryption;

			// are key integers set
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bKeyIntegers;

			// custom key values
			[MarshalAsAttribute(UnmanagedType.ByValArray, SizeConst=16, ArraySubType=UnmanagedType.U4)]
			public uint[] dwKeyIntegers;

			// is key creation date set
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bKeyCreationDate;

			// key creation date
			public SYSTEMTIME stKeyCreation;

			// is key expiration date set
			[MarshalAsAttribute(UnmanagedType.Bool)]
			public bool bKeyExpirationDate;

			// key expiration date
			public SYSTEMTIME stKeyExpiration;

			// are feature bits set
			[MarshalAsAttribute(UnmanagedType.Bool)] 
			public bool bFeatureBits;

			// features (additional key data)
			public KeygenFeaturesUnion KeygenFeatures;

			// key checksum (it can be used to put a key on the blacklist)
			[MarshalAsAttribute(UnmanagedType.ByValArray, SizeConst=32, ArraySubType=UnmanagedType.U1)]
			public byte[] cChecksum;
		}

		// Keygen() function prototype
		//[UnmanagedFunctionPointerAttribute(CallingConvention.StdCall)]
		//public delegate uint PELOCK_KEYGEN(ref KEYGEN_PARAMS lpKeygenParams);

		// VerifyKey() function prototype
		//[UnmanagedFunctionPointerAttribute(CallingConvention.StdCall)]
		//public delegate uint PELOCK_VERIFY_KEY(ref KEYGEN_VERIFY_PARAMS lpKeygenVerifyParams);

		[DllImportAttribute("keygen.dll", EntryPoint="Keygen", CallingConvention=CallingConvention.StdCall)]
		public static extern uint Keygen(ref KEYGEN_PARAMS lpKeygenParams);

		[DllImportAttribute("keygen.dll", EntryPoint="VerifyKey", CallingConvention=CallingConvention.StdCall)]
		public static extern uint VerifyKey(ref KEYGEN_VERIFY_PARAMS lpKeygenVerifyParams);
	}
}