<?php
	////////////////////////////////////////////////////////////////////////////////
	//
	// PHP + CGI-BIN przyklad uzycia biblioteki generatora kluczy licencyjnych
	//
	// Wersja         : PELock v2.0
	// Jezyk          : PHP
	// Autor          : Bartosz Wójcik (support@pelock.com)
	// Strona domowa  : https://www.pelock.com
	//
	////////////////////////////////////////////////////////////////////////////////

	// zalacz biblioteke generatora kluczy PELock
	include 'keygen.php';

	// ustaw parametry dla generatora kluczy
	$keygen_params = array();
	$keygen_params["szKeygenUrl"] = "http://www.example.com/cgi-bin/keygen.cgi";
	//$keygen_params["szProjectFile"] = "/home/users/bartek/public_html/example.com/keygen/test.plk";
	$keygen_params["szProjectFile"] = getcwd()."/test.plk";
	$keygen_params["bUpdateProject"] = "1";
	$keygen_params["szKeyFile"] = "key.lic";
	$keygen_params["dwOutputFormat"] = KEY_FORMAT_BIN;
	$keygen_params["bOutputText"] = "0";
	$keygen_params["szUsername"] = iconv("UTF-8", "WINDOWS-1250", "Bartosz Wójcik");

	// generuj klucz poprzez wywolanie generatora cgi-bin
	echo pelock_keygen($keygen_params, $error_message);
?>