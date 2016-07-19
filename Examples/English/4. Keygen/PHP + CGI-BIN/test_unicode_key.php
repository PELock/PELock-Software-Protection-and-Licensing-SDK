<?php
	////////////////////////////////////////////////////////////////////////////////
	//
	// PHP + CGI-BIN keygen usage example (UNICODE key generation)
	//
	// Version        : PELock v2.0
	// Language       : PHP
	// Author         : Bartosz Wójcik (support@pelock.com)
	// Web page       : https://www.pelock.com
	//
	////////////////////////////////////////////////////////////////////////////////

	//
	// include PELock keygen library
	//
	include 'keygen.php';

	//
	// setup keygen parameters
	//
	$keygen_params = array();

	//
	// CGI-BIN keygen URL, you need to upload the keygen to the
	// CGI-BIN directory on your server and add execution rights
	// for it e.g. by using "chmod +x keygen" command
	//
	// *** this parameter is required ***
	//
	$keygen_params["szKeygenUrl"] = "http://www.example.com/cgi-bin/keygen.cgi";

	//
	// project file name, project file has to be uploaded in the
	// keygen cgi-bin directory or it can be a full path (it has
	// to start with "/"), please make sure it's not possible
	// to download this file from the server!!!
	//
	// *** this parameter is required ***
	//
	//$keygen_params["szProjectFile"] = "test.plk";
	//$keygen_params["szProjectFile"] = "/home/users/bartek/public_html/example.com/keygen/test.plk";
	//$keygen_params["szProjectFile"] = getcwd()."/test.plk";

	//
	// project file contents in MIME Base64 format, use it
	// instead of szProjectFile parameter
	//
	// *** this parameter is optional ***
	//
	$keygen_params["szProjectBuffer"] = base64_encode(file_get_contents("test.plk"));

	//
	// if szProjectFile parameter is provided and username is passed via
	// szUsername parameter, CGI-BIN keygen will add the user to the
	// .PLK project file (it must be writeable!)
	//
	// *** this parameter is optional ***
	//
	$keygen_params["bUpdateProject"] = "0";

	//
	// are we using szProjectBuffer or szProjectFile
	// set to 1 if you are passing project file contents via szProjectBuffer
	//
	// *** this parameter is required ***
	//
	$keygen_params["bProjectBuffer"] = "1";

	//
	// output key format (binary file, registry dump, text file etc.)
	//
	// 0 - KEY_FORMAT_BIN (raw bytes)
	// 1 - KEY_FORMAT_REG (Windows registry dump)
	// 2 - KEY_FORMAT_TXT (MIME Base64 encoded key)
	//
	// *** this parameter is required ***
	//
	$keygen_params["dwOutputFormat"] = KEY_FORMAT_TXT;

	//
	// keyfile name shown in the download dialog (save as ...)
	//
	// *** this parameter is required ***
	//
	$extenstions = array("lic", "reg", "txt");
	$keygen_params["szKeyFile"] = "key.".$extenstions[$keygen_params["dwOutputFormat"]];

	//
	// output key as a text, if you don't set this parameter, a download
	// dialog will be displayed to download the key and the script will
	// end up its execution
	//
	// *** this parameter is optional ***
	//
	$keygen_params["bOutputText"] = "1";

	//
	// plain text username, default (ansi) username encoding is WINDOWS-1250
	//
 	// *** this parameter is required ***
	//
	//$keygen_params["szUsername"] = iconv("UTF-8", "WINDOWS-1250", "Laura Palmer");

	//
	// or MIME Base64 encoded username, by using Base64 encoding,
	// you can use any binary data (and its encoding, eg. UNICODE)
	// for the username field
	//
	// *** this parameter is required only if szUsername is not provided ***
	//
	//$keygen_params["lpUsernameRawData"] = base64_encode("Laura Palmer");

	// UNICODE string encoded in base64 format from the UTF-8 intput
	setlocale(LC_CTYPE, 'pl_PL');
	$keygen_params["lpUsernameRawData"] = base64_encode(iconv("UTF-8", "UTF-16LE", "Laura Palmer"));

	//
	// use hardware id locking
	//
	// *** this parameter is optional, you don't need to set it ***
	//
	$keygen_params["bSetHardwareLock"] = "0";

	//
	// encrypt user name and custom key fields with hardware id
	//
	// *** this parameter is optional, you don't need to set it ***
	//
	$keygen_params["bSetHardwareEncryption"] = "0";

	//
	// hardware id string (16 bytes)
	//
 	// *** if bSetHardwareLock is set to 1 this parameter is required ***
	//
	$keygen_params["szHardwareId"] = "FFFFFFFFFFFFFFFF";

	//
	// set key integers
	//
	// *** this parameter is optional, you don't need to set it ***
	//
	$keygen_params["bSetKeyIntegers"] = "1";

	//
	// key integers, you can set only selected integers if you want
	//
	// *** these parameters are optional, you don't need to set it ***
	//
	$keygen_params["dwKeyIntegers0"]  = "0";
	$keygen_params["dwKeyIntegers1"]  = "1";
	$keygen_params["dwKeyIntegers2"]  = "2";
	$keygen_params["dwKeyIntegers3"]  = "3";
	$keygen_params["dwKeyIntegers4"]  = "4";
	$keygen_params["dwKeyIntegers5"]  = "5";
	$keygen_params["dwKeyIntegers6"]  = "6";
	$keygen_params["dwKeyIntegers7"]  = "7";
	$keygen_params["dwKeyIntegers8"]  = "8";
	$keygen_params["dwKeyIntegers9"]  = "9";
	$keygen_params["dwKeyIntegers10"] = "10";
	$keygen_params["dwKeyIntegers11"] = "11";
	$keygen_params["dwKeyIntegers12"] = "12";
	$keygen_params["dwKeyIntegers13"] = "13";
	$keygen_params["dwKeyIntegers14"] = "14";
	$keygen_params["dwKeyIntegers15"] = "15";

	//
	// set key creation date
	//
	// *** this parameter is optional, you don't need to set it ***
	//
	$keygen_params["bSetKeyCreationDate"] = "1";

	//
	// key creation date (in day-month-year format)
	//
	// *** this parameter is optional, you don't need to set it ***
	//
	$keygen_params["stKeyCreation"] = "1-1-1980";

	//
	// set key expiration date
	//
	// *** this parameter is optional, you don't need to set it ***
	//
	$keygen_params["bSetKeyExpirationDate"] = "1";

	//
	// key creation date (in day-month-year format)
	//
	// *** this parameter is optional, you don't need to set it ***
	//
	$keygen_params["stKeyExpiration"] = "1-1-2012";

	//
	// set feature bits, use one of the following options:
	//
	// dwFeatureBits          - as a DWORD (32 bit hex value)
	// dwKeyData1..dwKeyData4 - as 4 BYTES (8 bit integers from 0-255 range)
	// bFeature1..bFeature32  - as 32 bits (0 or 1 values)
	//
	// *** this parameter is optional, you don't need to set it ***
	//
	$keygen_params["bSetFeatureBits"] = "1";

	//
	// from which variable read the feature bits
	//
	// 0 - read 32 bit hex value from dwSetFeatureBitsOpt parameter
	// 1 - read 8 bit integers from dwKeyData1..dwKeyData4 parameters
	// 2 - read feature bits from bFeature1..bFeature32 parameters
	//
	// *** this parameter is optional, you don't need to set it ***
	// *** default option is set to 0 if this parameter is not set ***
	//
	$keygen_params["dwSetFeatureBitsOpt"] = "2";

	// features bits as a DWORD (32 bit hex value)
	$keygen_params["dwFeatureBits"] = "80000000";

	// feature bits as a BYTES (8 bit integers from 0-255 range)
	$keygen_params["dwKeyData1"] = "0";
	$keygen_params["dwKeyData2"] = "63";
	$keygen_params["dwKeyData3"] = "127";
	$keygen_params["dwKeyData4"] = "255";

	// feature bits
	$keygen_params["bFeature1"] = "1";
	$keygen_params["bFeature2"] = "1";
	$keygen_params["bFeature3"] = "1";
	$keygen_params["bFeature4"] = "1";
	$keygen_params["bFeature5"] = "1";
	$keygen_params["bFeature6"] = "1";
	$keygen_params["bFeature7"] = "1";
	$keygen_params["bFeature8"] = "1";
	$keygen_params["bFeature9"] = "1";
	$keygen_params["bFeature10"] = "1";
	$keygen_params["bFeature11"] = "1";
	$keygen_params["bFeature12"] = "1";
	$keygen_params["bFeature13"] = "1";
	$keygen_params["bFeature14"] = "1";
	$keygen_params["bFeature15"] = "1";
	$keygen_params["bFeature16"] = "1";
	$keygen_params["bFeature17"] = "1";
	$keygen_params["bFeature18"] = "1";
	$keygen_params["bFeature19"] = "1";
	$keygen_params["bFeature20"] = "1";
	$keygen_params["bFeature21"] = "1";
	$keygen_params["bFeature22"] = "1";
	$keygen_params["bFeature23"] = "1";
	$keygen_params["bFeature24"] = "1";
	$keygen_params["bFeature25"] = "1";
	$keygen_params["bFeature26"] = "1";
	$keygen_params["bFeature27"] = "1";
	$keygen_params["bFeature28"] = "1";
	$keygen_params["bFeature29"] = "1";
	$keygen_params["bFeature30"] = "1";
	$keygen_params["bFeature31"] = "1";
	$keygen_params["bFeature32"] = "1";

	// call cgi-bin keygen
	$key = pelock_keygen($keygen_params, $error_message);

	if (empty($key) == false)
	{
		echo $key;
	}
	else
	{
		echo $error_message;
	}
?>