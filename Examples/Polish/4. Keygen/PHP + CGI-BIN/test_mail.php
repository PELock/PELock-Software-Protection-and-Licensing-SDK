<?php
	////////////////////////////////////////////////////////////////////////////////
	//
	// PHP + CGI-BIN przyklad uzycia biblioteki generatora kluczy licencyjnych
	// do utworzenia klucza i wyslania go na e-mail uzytkownika
	//
	// Wersja         : PELock v2.0
	// Jezyk          : PHP
	// Autor          : Bartosz Wójcik (support@pelock.com)
	// Strona domowa  : https://www.pelock.com
	//
	////////////////////////////////////////////////////////////////////////////////

	//
	// zalacz biblioteke generatora kluczy PELock
	//
	include 'keygen.php';

	//
	// pobierz wejsciowe parametry
	//
	// test.mail.php?username=test&email=support@pelock.com
	//
	$username = $_REQUEST["username"];
	$email = $_REQUEST["email"];

	if ( empty($username) == true || empty($email) == true )
	{
		die("Proszę podać poprawne parametry np. test_mail.php?username=bartek&email=support@pelock.com");
	}

	//
	// ustaw parametry dla generatora kluczy
	//
	$keygen_params = array();

	//
	// URL generatora w formacie CGI-BIN, ktory nalezy wgrac na serwer do katalogu
	// CGI-BIN i przydzielic mu prawa do wykonywania, np. poprzez wykonanie
	// polecenia "chmod +x keygen"
	//
	// *** ten parametr jest wymagany ***
	//
	$keygen_params["szKeygenUrl"] = "http://www.example.com/cgi-bin/keygen.cgi";

	//
	// nazwa pliku projektu, dla ktorego generujemy klucz, plik musi znajdowac
	// sie na serwerze w katalogu z generatorem cgi-bin, mozna tez podac pelna
	// sciezke do pliku (musi sie zaczynac od znaku "/"), prosze sie upewnic, ze
	// po wgraniu pliku na serwer nie bedzie mozliwe jego sciagniecie poprzez
	// przegladarke www!!!
	//
	// *** ten parametr jest wymagany ***
	//
	$keygen_params["szProjectFile"] = "test.plk";
	//$keygen_params["szProjectFile"] = "/home/users/bartek/public_html/example.com/keygen/test.plk";
	//$keygen_params["szProjectFile"] = getcwd()."/test.plk";

	//
	// zawartosc pliku projektu w formacie MIME Base64, mozna uzyc tego parametru
	// zamiast nazwy pliku projektu
	//
	// *** ten parametr jest opcjonalny ***
	//
	//$keygen_params["szProjectBuffer"] = base64_encode(file_get_contents("test.plk"));

	//
	// flaga okreslajaca czy uzywamy szProjectBuffer czy szProjectFile
	// ustaw na 1 jesli przekazujesz zawartosc pliku projektu przez szProjectBuffer
	//
	// *** ten parametr jest opcjonalny ***
	//
	$keygen_params["bProjectBuffer"] = "0";

	//
	// jesli podany jest parametr szProjectFile oraz nazwa uzytkownika jest przekazana
	// poprzez parametr szUsername, generator kluczy CGI-BIN doda takiego uzytkownika
	// do pliku projektu .PLK (plik musi posiadac atrybuty do zapisu!)
	//
	// *** ten parametr jest opcjonalny ***
	//
	$keygen_params["bUpdateProject"] = "0";

	//
	// wyjsciowy format klucza (binarny plik, zrzut rejestru, tekstowy plik etc.)
	//
	// 0 - KEY_FORMAT_BIN (binarny plik)
	// 1 - KEY_FORMAT_REG (zrzut rejestru Windows)
	// 2 - KEY_FORMAT_TXT (tekstowy plik w formacie MIME Base64)
	//
	// *** ten parametr jest wymagany ***
	//
	$keygen_params["dwOutputFormat"] = KEY_FORMAT_BIN;

	//
	// nazwa pliku pokazywana w dialogu Zapisz jako... (dla bOutputText = 0)
	//
	// *** ten parametr jest wymagany ***
	//
	$extenstions = array("lic", "reg", "txt");
	$keygen_params["szKeyFile"] = "key.".$extenstions[$keygen_params["dwOutputFormat"]];

	//
	// zwroc zawartosc klucza jako bufor tekstowy, jesli ten parametr nie
	// bedzie ustawiony na 1, po wygenerowaniu klucza w przegladarce pojawi
	// sie okno pozwalajace zapisac wygenerowany klucz (Zapisz jako...)
	//
	// *** ten parametr jest opcjonalny ***
	//
	$keygen_params["bOutputText"] = "1";

	//
	// nazwa uzytkownika w pliku licencyjnym, domyslnie (ansni) nazwa jest
	// zakodowana w formacie WINDOWS-1250
	//
 	// *** ten parametr jest wymagany ***
	//
	$keygen_params["szUsername"] = iconv("UTF-8", "WINDOWS-1250", $username);

	//
	// opcjonalnie nazwa uzytkownika zakodowana w formacie MIME Base64, co pozwala
	// uzyc dowolnych danych w kluczu (np. binarnych), oraz dowolnego kodowania
	// znakow (np. UNICODE)
	//
	// *** ten parametr jest wymagany jesli szUsername nie zostal uzyty ***
	//
	//$keygen_params["lpUsernameRawData"] = base64_encode("Laura Palmer");

	// string w formacie UNICODE zakodowany w base64 z kodowania UTF-8
	//setlocale(LC_CTYPE, 'pl_PL');
	//$keygen_params["lpUsernameRawData"] = base64_encode(iconv("UTF-8", "UTF-16LE", "Laura Palmer"));

	//
	// czy zablokowac klucz na sprzetowy identyfikator
	//
	// *** ten parametr jest opcjonalny i nie musisz go ustawiac ***
	//
	$keygen_params["bSetHardwareLock"] = "0";

	//
	// zaszyfruj nazwe uzytkownika i dane klucza sprzetowym identyfikatorem
	//
	// *** ten parametr jest opcjonalny i nie musisz go ustawiac ***
	//
	$keygen_params["bSetHardwareEncryption"] = "0";

	//
	// sprzetowy identyfikator (16 bajtow)
	//
 	// *** jesli bSetHardwareLock jest ustawiony na 1, ten parametr musi byc ustawiony ***
	//
	$keygen_params["szHardwareId"] = "FFFFFFFFFFFFFFFF";

	//
	// czy ustawic dodatkowe wartosci liczbowe klucza
	//
	// *** ten parametr jest opcjonalny i nie musisz go ustawiac ***
	//
	$keygen_params["bSetKeyIntegers"] = "1";

	//
	// dodatkowe wartosci liczbowe klucza key integers, mozesz ustawic tylko
	// wybrane wartosci (nie trzeba wszystkich ustawiac)
	//
	// *** te parametry sa opcjonalne i nie musisz ich ustawiac ***
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
	// ustaw date utworzenia klucza
	//
	// *** ten parametr jest opcjonalny i nie musisz go ustawiac ***
	//
	$keygen_params["bSetKeyCreationDate"] = "1";

	//
	// data utworzenia klucza (w formacie dzien-miesiac-rok)
	//
	// *** ten parametr jest opcjonalny i nie musisz go ustawiac ***
	//
	$keygen_params["stKeyCreation"] = "1-1-1980";

	//
	// ustaw date wygasniecia klucza
	//
	// *** ten parametr jest opcjonalny i nie musisz go ustawiac ***
	//
	$keygen_params["bSetKeyExpirationDate"] = "1";

	//
	// data wygasniecia klucza (w formacie dzien-miesiac-rok)
	//
	// *** ten parametr jest opcjonalny i nie musisz go ustawiac ***
	//
	$keygen_params["stKeyExpiration"] = "1-1-2012";

	//
	// ustaw dodatkowe opcje bitowe, mozna uzyc nastepujacych wartosci:
	//
	// dwFeatureBits          - opcje jako DWORD (32 bitowa wartosc hex)
	// dwKeyData1..dwKeyData4 - opcje jako 4 BAJTY (8 bitowe wartosci z zakresu 0-255)
	// bFeature1..bFeature32  - opcje jako 32 bity (o wartosciach 0 lub 1)
	//
	// *** ten parametr jest opcjonalny i nie musisz go ustawiac ***
	//
	$keygen_params["bSetFeatureBits"] = "1";

	//
	// parametr okresla, z ktorego elementu zostana odczytane opcje bitowe
	//
	// 0 - odczytaj 32 bitowa wartosc hex z parametru dwSetFeatureBits
	// 1 - odczytaj 4 wartosci 8 bitowe z parametrow dwKeyData1..dwKeyData4
	// 2 - odczytaj 32 wartosci z parametrow bFeature1..bFeature32
	//
	// *** ten parametr jest opcjonalny i nie musisz go ustawiac ***
	// *** default option is set to 0 if this parameter is not set ***
	//
	$keygen_params["dwSetFeatureBitsOpt"] = "2";

	// dodatkowe opcje jako 1 DWORD (32 bitowa wartosc hex)
	$keygen_params["dwFeatureBits"] = "80000000";

	// dodatkowe opcje jako 4 BAJTY (8 bitowe wartosci z zakresu 0-255)
	$keygen_params["dwKeyData1"] = "0";
	$keygen_params["dwKeyData2"] = "63";
	$keygen_params["dwKeyData3"] = "127";
	$keygen_params["dwKeyData4"] = "255";

	// dodatkowe opcje jako 32 bity
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

	//
	// generuj klucz poprzez wywolanie generatora cgi-bin
	//
	$key = pelock_keygen($keygen_params, $error_message);

	// jesli klucz jest pusty, to znaczy, ze nie udalo sie wygenerowac klucza
	if (empty($key) == false)
	{
		// zmien kodowanie z UTF-8 na przyjazne programom pocztowym
		$cp_out = "WINDOWS-1250";
		$cp_in = "UTF-8";

		// temat wiadomosci
		$subject = "Twój klucz licencyjny";

		// dodatkowe naglowki
		$headers =  "From: Bartosz Wójcik <support@pelock.com>\r\n";
		$headers .= "Reply-To: Bartosz Wójcik <support@pelock.com>\r\n";
		
		switch($keygen_params["dwOutputFormat"])
		{
		case KEY_FORMAT_BIN:

			// tresc wiadomosci
			$message = "Cześć,\n\nTwój klucz licencyjny jest załączony do tego maila (plik ".$keygen_params["szKeyFile"].").";

			// zalacznik
			$content = chunk_split(base64_encode($key));
			$uid = md5(uniqid(time()));
			$filename = $keygen_params["szKeyFile"];

			$headers .= "MIME-Version: 1.0\n";
			$headers .= "Content-Type: multipart/mixed; boundary=\"".$uid."\"\n\n";
			$headers .= "This is a multi-part message in MIME format.\n";
			$headers .= "--".$uid."\n";
			$headers .= "Content-type:text/plain; charset=".$cp_out."\n";
			$headers .= "Content-Transfer-Encoding: 7bit\n\n";
			$headers .= str_replace("\r\n", "\n", $message)."\n\n";
			$headers .= "--".$uid."\n";
			$headers .= "Content-Type: application/octet-stream; name=\"".$filename."\"\n";
			$headers .= "Content-Transfer-Encoding: base64\n";
			$headers .= "Content-Disposition: attachment; filename=\"".$filename."\"\n\n";
			$headers .= $content."\n\n";
			$headers .= "--".$uid."--";

			$message = "";

			break;

		case KEY_FORMAT_REG:

			// tresc wiadomosci
			$message = "Cześć,\n\nTwój klucz licencyjny jest załączony do tego maila (plik ".$keygen_params["szKeyFile"].").";

			// zalacznik
			$content = chunk_split(base64_encode($key));
			$uid = md5(uniqid(time()));
			$filename = $keygen_params["szKeyFile"];

			$headers .= "MIME-Version: 1.0\n";
			$headers .= "Content-Type: multipart/mixed; boundary=\"".$uid."\"\n\n";
			$headers .= "This is a multi-part message in MIME format.\n";
			$headers .= "--".$uid."\n";
			$headers .= "Content-type:text/plain; charset=".$cp_out."\n";
			$headers .= "Content-Transfer-Encoding: 7bit\n\n";
			$headers .= str_replace("\r\n", "\n", $message)."\n\n";
			$headers .= "--".$uid."\n";
			$headers .= "Content-Type: application/octet-stream; name=\"".$filename."\"\n";
			$headers .= "Content-Transfer-Encoding: base64\n";
			$headers .= "Content-Disposition: attachment; filename=\"".$filename."\"\n\n";
			$headers .= $content."\n\n";
			$headers .= "--".$uid."--";

			$message = "";

			break;

		case KEY_FORMAT_TXT:

			// tresc wiadomosci
			$message = "Cześć,\n\nTo twój klucz licencyjny (kopiuj i wklej go):\n\n$key\n\nDziękuję!";

			break;
		}

		$email = iconv($cp_in, $cp_out, $email);
		$subject = iconv($cp_in, $cp_out, $subject);
		$message = iconv($cp_in, $cp_out, $message);
		$message = str_replace("\r\n", "\n", $message);
		$headers = iconv($cp_in, $cp_out, $headers);

		// wyslij email do uzytkownika z kluczem licencyjnym
		@mail($email, $subject, $message, $headers);
	}
	else
	{
		die($error_message);
	}

	exit();
?>