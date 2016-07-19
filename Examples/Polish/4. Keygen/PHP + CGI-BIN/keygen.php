<?php

////////////////////////////////////////////////////////////////////////////////
//
// PHP + CGI-BIN keygen library
//
// Version        : PELock v2.0
// Language       : PHP
// Author         : Bartosz Wójcik (support@pelock.com)
// Web page       : https://www.pelock.com
//
////////////////////////////////////////////////////////////////////////////////

//
// output key formats
//
define("KEY_FORMAT_BIN", 0);
define("KEY_FORMAT_REG", 1);
define("KEY_FORMAT_TXT", 2);

//
// main keygen function
//
// $keygen_params    - an array with keygen parameters (see test.php for the
//                     complete list of parameters)
// &$error_message   - this string will receive error message in case of error
// $use_curl_library - use cURL library to send a POST request, please note,
//                     that the cURL library might not be available everywhere
//
function pelock_keygen($keygen_params, &$error_message, $use_curl_library = false)
{
	// default return value
	$key = "";

	// keygen parameters
	$post_params = array();

	// build keygen parameters
	foreach($keygen_params as $array_key => $array_value)
	{
		if ($key !== "szKeygenUrl")
		{
			$post_params[$array_key] = $array_value;
		}
	}

	// send a request to the cgi-bin keygen
	if ($use_curl_library == false)
	{
		$result = post_request($keygen_params["szKeygenUrl"], $post_params);
	}
	else
	{
		$result = post_request_curl($keygen_params["szKeygenUrl"], $post_params);
	}

	// detect keygen errors
	if ( (empty($result) == false) && (substr($result, 0, 14) !== "[KEYGEN ERROR]") )
	{
		if ($keygen_params["bOutputText"] == 1)
		{
			$key = $result;
		}
		else
		{
			// a dialog box with Save file as... will be displayed
			header("Content-Type:application/octet-stream; name=\"".$keygen_params["szKeyFile"]."\"");
			header("Content-Transfer-Encoding: binary");
			header("Content-Disposition: attachment; filename=\"".$keygen_params["szKeyFile"]."\"");

			echo $result;

			exit(0);
		}
	}
	else
	{
		$error_message = $result;
	}

	return $key;
}

//
// send a POST request
//
function post_request($url, $data)
{
	$params = array('http' => array(
		'method' => 'POST',
		'content' => http_build_query($data)
		));

	$ctx = stream_context_create($params);

	$fp = @fopen($url, 'rb', false, $ctx);

	if (!$fp)
	{
		return "";
	}

	//$meta = stream_get_meta_data($fp);
	//var_dump($meta['wrapper_data']);

	$response = @stream_get_contents($fp);

	if ($response === false)
	{
		return "";
	}

	return $response;
}

//
// send a POST request using cURL library
//
function post_request_curl($url, $data)
{
	$ch = curl_init();

	foreach($data as $key => $value)
	{
		$fields_string .= $key.'='.$value.'&';
	}

	$fields_string = rtrim($fields_string, '&');

	// url
	curl_setopt($ch, CURLOPT_URL, $url);

	// number of parameters
	curl_setopt($ch, CURLOPT_POST, count($data));

	// POST parameters
	curl_setopt($ch, CURLOPT_POSTFIELDS, $fields_string);

	// user agent
	curl_setopt($ch, CURLOPT_USERAGENT, "PELock v2.0 Keygen");

	// return only result
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

	// query URL
	$result = curl_exec($ch);

	// close session
	curl_close($ch);

	// return result
	return $result;
}

?>