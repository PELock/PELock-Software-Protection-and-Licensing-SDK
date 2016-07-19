<?php
	////////////////////////////////////////////////////////////////////////////////
	//
	// PHP + CGI-BIN keygen usage example
	//
	// Version        : PELock v2.0
	// Language       : PHP
	// Author         : Bartosz Wójcik (support@pelock.com)
	// Web page       : https://www.pelock.com
	//
	////////////////////////////////////////////////////////////////////////////////

	// include PELock keygen library
	include 'keygen.php';

	// setup keygen parameters
	$keygen_params = array();
	$keygen_params["szKeygenUrl"] = "http://www.example.com/cgi-bin/keygen.cgi";
	$keygen_params["szProjectFile"] = "test.plk";
	//$keygen_params["szProjectFile"] = "/home/users/bartek/public_html/example.com/keygen/test.plk";
	//$keygen_params["szProjectFile"] = getcwd()."/test.plk";
	$keygen_params["bUpdateProject"] = "1";
	$keygen_params["szKeyFile"] = "key.lic";
	$keygen_params["dwOutputFormat"] = KEY_FORMAT_BIN;
	$keygen_params["bOutputText"] = "0";
	$keygen_params["szUsername"] = iconv("UTF-8", "windows-1250", "Bartosz Wójcik");

	// call cgi-bin keygen
	echo pelock_keygen($keygen_params, $error_message);
?>