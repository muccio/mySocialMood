<?php  
/*       
    API Demo 
   
    This script provides a RESTful API interface for a web application
 
    Input:
 
        $_GET['format'] = [ json | html | xml ]
        $_GET['method'] = []
 
    Output: A formatted HTTP response
 
    Author: Mark Roland
 
    History:
        11/13/2012 - Created
 
*/
  
// --- Step 1: Initialize variables and functions
 
/**
 * Deliver HTTP Response
 * @param string $format The desired HTTP response content type: [json, html, xml]
 * @param string $api_response The desired HTTP response data
 * @return void
 **/
 
 function xml2array($contents, $get_attributes = 1, $priority = 'tag')
{
    
    if (!function_exists('xml_parser_create'))
    {
        return array ();
    }
    $parser = xml_parser_create('');
    
    xml_parser_set_option($parser, XML_OPTION_TARGET_ENCODING, "UTF-8");
    xml_parser_set_option($parser, XML_OPTION_CASE_FOLDING, 0);
    xml_parser_set_option($parser, XML_OPTION_SKIP_WHITE, 1);
    xml_parse_into_struct($parser, trim($contents), $xml_values);
    xml_parser_free($parser);
    if (!$xml_values)
        return; //Hmm...
    $xml_array = array ();
    $parents = array ();
    $opened_tags = array ();
    $arr = array ();
    $current = & $xml_array;
    $repeated_tag_index = array (); 
    foreach ($xml_values as $data)
    {
        unset ($attributes, $value);
        extract($data);
        $result = array ();
        $attributes_data = array ();
        if (isset ($value))
        {
            if ($priority == 'tag')
                $result = $value;
            else
                $result['value'] = $value;
        }
        if (isset ($attributes) and $get_attributes)
        {
            foreach ($attributes as $attr => $val)
            {
                if ($priority == 'tag')
                    $attributes_data[$attr] = $val;
                else
                    $result['attr'][$attr] = $val; //Set all the attributes in a array called 'attr'
            }
        }
        if ($type == "open")
        { 
            $parent[$level -1] = & $current;
            if (!is_array($current) or (!in_array($tag, array_keys($current))))
            {
                $current[$tag] = $result;
                if ($attributes_data)
                    $current[$tag . '_attr'] = $attributes_data;
                $repeated_tag_index[$tag . '_' . $level] = 1;
                $current = & $current[$tag];
            }
            else
            {
                if (isset ($current[$tag][0]))
                {
                    $current[$tag][$repeated_tag_index[$tag . '_' . $level]] = $result;
                    $repeated_tag_index[$tag . '_' . $level]++;
                }
                else
                { 
                    $current[$tag] = array (
                        $current[$tag],
                        $result
                    ); 
                    $repeated_tag_index[$tag . '_' . $level] = 2;
                    if (isset ($current[$tag . '_attr']))
                    {
                        $current[$tag]['0_attr'] = $current[$tag . '_attr'];
                        unset ($current[$tag . '_attr']);
                    }
                }
                $last_item_index = $repeated_tag_index[$tag . '_' . $level] - 1;
                $current = & $current[$tag][$last_item_index];
            }
        }
        elseif ($type == "complete")
        {
            if (!isset ($current[$tag]))
            {
                $current[$tag] = $result;
                $repeated_tag_index[$tag . '_' . $level] = 1;
                if ($priority == 'tag' and $attributes_data)
                    $current[$tag . '_attr'] = $attributes_data;
            }
            else
            {
                if (isset ($current[$tag][0]) and is_array($current[$tag]))
                {
                    $current[$tag][$repeated_tag_index[$tag . '_' . $level]] = $result;
                    if ($priority == 'tag' and $get_attributes and $attributes_data)
                    {
                        $current[$tag][$repeated_tag_index[$tag . '_' . $level] . '_attr'] = $attributes_data;
                    }
                    $repeated_tag_index[$tag . '_' . $level]++;
                }
                else
                {
                    $current[$tag] = array (
                        $current[$tag],
                        $result
                    ); 
                    $repeated_tag_index[$tag . '_' . $level] = 1;
                    if ($priority == 'tag' and $get_attributes)
                    {
                        if (isset ($current[$tag . '_attr']))
                        { 
                            $current[$tag]['0_attr'] = $current[$tag . '_attr'];
                            unset ($current[$tag . '_attr']);
                        }
                        if ($attributes_data)
                        {
                            $current[$tag][$repeated_tag_index[$tag . '_' . $level] . '_attr'] = $attributes_data;
                        }
                    }
                    $repeated_tag_index[$tag . '_' . $level]++; //0 and 1 index is already taken
                }
            }
        }
        elseif ($type == 'close')
        {
            $current = & $parent[$level -1];
        }
    }
    return ($xml_array);
}


function url_get_contents ($Url) {
    if (!function_exists('curl_init')){ 
        die('CURL is not installed!');
    }
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $Url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $output = curl_exec($ch);
    curl_close($ch);
    return $output;
}

function reverseGeo($latitude,$longitude){
	//41.86683/12.48454
	$xml_url = "http://nominatim.openstreetmap.org/reverse?format=xml&lat=".$latitude."&lon=".$longitude."&zoom=18&addressdetails=1&accept-language=en-GB";
	$xml_content = url_get_contents($xml_url);
	$array_ = xml2array($xml_content);
	$city = $array_["reversegeocode"]["addressparts"]["city"];
	$state = $array_["reversegeocode"]["addressparts"]["country_code"];
	//echo($city.",".$state);
	return $city.",".$state;
}

function apn_push($user,$mood,$message,$device_id,$type=1){
	//apn push http://synesthesiadesign.net/push/simplepush.php?format=json&method=push&device=a56713a5d85aa4962d8987ba53c229cb481e4a8b4e0b2b17f882da4acca8ee40&message=ciccioculo
	//$milliseconds = round(microtime(true) * 1000);
	if($type==1){
		$messaggio = $user."-".$mood."-".$message;//.":".$milliseconds;
		$messaggio = str_replace(' ', '%20', $messaggio);
	}
	else{
		$messaggio = $message;
	}
	$push_url = "http://synesthesiadesign.net/push/simplepush.php?format=json&method=push&device=".$device_id."&message=".$messaggio."&type=".$type;
	//echo("<BR>".$push_url."<BR>");
	$push_content = url_get_contents($push_url);
	
	//echo("<BR>".$push_content."<BR>");
	return $push_content['data'];
}

function send_instant_message($sender,$user,$message){
	db_connection();
	//inserisci messaggio in database server
	$query = "INSERT INTO notifications VALUES (NOW(),(select id from users where username='".$user."'),(select id from users where username='".$sender."'),'".$message."')";
	$result = mysql_query($query) or die("Query INSERT non valida: " . mysql_error());
	
	
	$sql = "SELECT device_id from devices where user_id=(select id from users where username='".$user."')";
	$result = mysql_query($sql) or die("Query select non valida: " . mysql_error());
	while($row = mysql_fetch_array($result)){
		$device_id=$row['device_id'];
		if(strlen($device_id)==64) {//a56713a5d85aa4962d8987ba53c229cb481e4a8b4e0b2b17f882da4acca8ee40
			//echo($user." message sent ".$message.$device_id."<br>");
			apn_push($user,"message:",$sender."--".$message,$device_id);
		}
	}
	
	return "messageSent";
}

function deliver_response($format, $api_response){
 
    // Define HTTP responses
    $http_response_code = array(
        200 => 'OK',
        400 => 'Bad Request',
        401 => 'Unauthorized',
        403 => 'Forbidden',
        404 => 'Not Found'
    );
 
    // Set HTTP Response
    header('HTTP/1.1 '.$api_response['status'].' '.$http_response_code[ $api_response['status'] ]);
 
    // Process different content types
    if( strcasecmp($format,'json') == 0 ){
 
        // Set HTTP Response Content Type
        header('Content-Type: application/json; charset=utf-8');
 
        // Format data into a JSON response
        $json_response = json_encode($api_response);
 
        // Deliver formatted data
        echo $json_response;
 
    }elseif( strcasecmp($format,'xml') == 0 ){
 
        // Set HTTP Response Content Type
        header('Content-Type: application/xml; charset=utf-8');
 
        // Format data into an XML response (This is only good at handling string data, not arrays)
        $xml_response = '<?xml version="1.0" encoding="UTF-8"?>'."\n".
            '<response>'."\n".
            "\t".'<code>'.$api_response['code'].'</code>'."\n".
            "\t".'<data>'.$api_response['data'].'</data>'."\n".
            '</response>';
 
        // Deliver formatted data
        echo $xml_response;
 
    }else{
 
        // Set HTTP Response Content Type (This is only good at handling string data, not arrays)
        header('Content-Type: text/html; charset=utf-8');
 
        // Deliver formatted data
        echo $api_response['data'];
 
    }
 
    // End script process
    exit;
 
}
 
// Define whether an HTTPS connection is required
$HTTPS_required = FALSE;
 
// Define whether user authentication is required
$authentication_required = FALSE;
 
// Define API response codes and their related HTTP response
$api_response_code = array(
    0 => array('HTTP Response' => 400, 'Message' => 'Unknown Error'),
    1 => array('HTTP Response' => 200, 'Message' => 'Success'),
    2 => array('HTTP Response' => 403, 'Message' => 'HTTPS Required'),
    3 => array('HTTP Response' => 401, 'Message' => 'Authentication Required'),
    4 => array('HTTP Response' => 401, 'Message' => 'Authentication Failed'),
    5 => array('HTTP Response' => 404, 'Message' => 'Invalid Request'),
    6 => array('HTTP Response' => 400, 'Message' => 'Invalid Response Format')
);
 
// Set default HTTP response of 'ok'
$response['code'] = 0;
$response['status'] = 404;
$response['data'] = NULL;
 
// --- Step 2: Authorization
 
// Optionally require connections to be made via HTTPS
if( $HTTPS_required && $_SERVER['HTTPS'] != 'on' ){
    $response['code'] = 2;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
    $response['data'] = $api_response_code[ $response['code'] ]['Message']; 
 
    // Return Response to browser. This will exit the script.
    deliver_response($_GET['format'], $response);
}
 
// Optionally require user authentication
if( $authentication_required ){
 
    if( empty($_POST['username']) || empty($_POST['password']) ){
        $response['code'] = 3;
        $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
        $response['data'] = $api_response_code[ $response['code'] ]['Message'];
    }
 
    // Return an error response if user fails authentication. This is a very simplistic example
    // that should be modified for security in a production environment
    elseif( $_POST['username'] != 'foo' && $_POST['password'] != 'bar' ){
        $response['code'] = 4;
        $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
        $response['data'] = $api_response_code[ $response['code'] ]['Message'];
    }
 
}
// --- db operations ---
$con;
function db_connection(){
	$database_name="ximarios_mariosalvucci";
	$database_user="ximarios_social";
	$database_psw="d9(A-p#K0&WV";
	$con = mysql_connect("localhost",$database_user,$database_psw);
	if (!$con){	
		//echo('Could not connect: ' . mysql_error());	
		return false;
	}
	else{
		//echo('conn ok - ');
	}
	if(mysql_select_db($database_name, $con)){
		//echo('db selection ok - ');
	}
	else{
		return false;
		//echo('db selection error - ');
	}
}

function sendMail($to, $from, $from_name, $sub, $msg){
	// Send mail with HTML tags ( http://coursesweb.net/ )
	$eol = "\r\n";             // to add new row
	
	// Define the headers for From and HTML
	$headers = "From: " . $from_name . "<" . $from . ">".$eol;
	$headers .= "MIME-Version: 1.0" . $eol;
	$headers .= "Content-type: text/html; charset=iso-8859-1" . $eol;
	
	// sends data to mail server.
	// Returns TRUE if the mail was successfully accepted for delivery, FALSE otherwise
	if (mail($to, stripslashes($sub), stripslashes($msg), $headers)) return true;
		else return false;
}

function register_new_user($usr,$psw,$email){
	//create confirmation id
	
	$key = $usr . $email . date('mY');
	$key = md5($key);
				
	db_connection();
	$query = "INSERT INTO users(username,password,email,confirm) VALUES ('".$usr."','".$psw."','".$email."','".$key."')";
	//echo($query);
	$result = mysql_query($query) or die("Query non valida: " . mysql_error());
	
	mysql_close($con);
	//send email to user
	// The message
	$message = 'to activate your account follow this link: <a href="http://www.mariosalvucci.com/rest/confirm.php?user='.$usr.'&key='.$key.'>activate</a>';
	
	// In case any of our lines are larger than 70 characters, we should use wordwrap()
	//$message = wordwrap($message, 70, "\r\n");
	
	// Send
	$to = $email;           // receiver of the mail
	$from = 'social@social.net';            // sender e-mail address
	$from_name = 'social tests';
	$subject = 'Subject of the mail';
	$message = '<h3>Message from Social Network</h3>
	  <div style="color:blue;">Dear <b>'.$usr.'</b> if you want to activate ,<br />
	  your account <em>please</em> follow: <a href="http://www.mariosalvucci.com/rest/confirm.php?user='.$usr.'&key='.$key.'">activate</a></div>';
	
	// Calls the sendMail() to send mail, outputs message if the mail was accepted for delivery or not
	if(sendMail($to, $from, $from_name, $subject, $message)) {
	  //echo 'The mail successfully sent';
	}
	else return false;
	return true;
}

function getfollowers($user){
	db_connection();
	$result = mysql_query("SELECT followers from users where username='".$user."'") or die("Query non valida: " . mysql_error());
	$encoded_friends="";
	while($row = mysql_fetch_array($result)){
		$encoded_friends=$row['followers'];
	}
	$followers_user_ids = explode(",", $encoded_friends);
	//var_dump($followers_user_ids);
	mysql_close($con);
	return $followers_user_ids;
}

function setMood($user,$mood,$message,$lat,$long){
	$user_id = -1;
	db_connection();
	//get user sharing setting
	$result = mysql_query("select sharing_type,id from users where username='".$user."'") or die("Query select sharing type non valida: " . mysql_error());
	$sharing_type = -1;
	while($row = mysql_fetch_array($result)){
		$sharing_type=$row['sharing_type'];
		$user_id=$row['id'];
	}
	//reverse geo actual lat-long
	$rev_geo = explode(",",reverseGeo($lat,$long));
	$current_city = $rev_geo[0];
	$current_state = $rev_geo[1];
	
	//set geo based on sharing type
	switch($sharing_type){
		case 0:
			$lat = 0.0;
			$long = 0.0;
		break;
		case 2://city
			$result = mysql_query("select geo_lat,geo_lng from meta_location where local_name='".$current_city."' and iso like '".$current_state."%'") or die("Query select state coord: " . mysql_error());
			while($row = mysql_fetch_array($result)){
				$lat=$row['geo_lat'];
				$long=$row['geo_lng'];
			}
		break;
		case 3://state
			$result = mysql_query("select geo_lat,geo_lng from meta_location where iso='".$current_state."'") or die("Query select state coord: " . mysql_error());
			while($row = mysql_fetch_array($result)){
				$lat=$row['geo_lat'];
				$long=$row['geo_lng'];
			}
		break;
		default:
		case 1:
		break;
	}
	
	$result = mysql_query("update users set mood='".$mood."', message='".$message."', latitude='".$lat."', longitude='".$long."', city='".$current_city."', state='".$current_state."', last_update=NOW() where username='".$user."'") or die("Query non valida: " . mysql_error());
	//notifica i followers del cambiamento stato
	$my_followers = array();
	$my_followers = getfollowers($user);
	foreach($my_followers as $follower_id){
		$id_numerico = intval($follower_id);
		//echo('id:'.$id_numerico.'<br>');
		$sql = "SELECT device_id from devices where user_id=".$id_numerico."";
		$result = mysql_query($sql) or die("Query non valida: " . mysql_error());
		while($row = mysql_fetch_array($result)){
			$device_id=$row['device_id'];
			if(strlen($device_id)==64) {//a56713a5d85aa4962d8987ba53c229cb481e4a8b4e0b2b17f882da4acca8ee40
				//echo('id:'.$id_numerico."push:".$device_id."<br>");
				//aggiorna il campo notifiche dell'user destinatario
				$query = "update users set notifications_count = notifications_count+1 where id=".$id_numerico;
				$result_interna = mysql_query($query) or die("Query non valida: " . mysql_error());
				//legge il campo aggiornato
				
				$query = "select notifications_count from users where id=".$id_numerico;
				$result_interna = mysql_query($query) or die("Query non valida: " . mysql_error());
				while($row_inner = mysql_fetch_array($result_interna)){
					$message = $row_inner['notifications_count'];
				}
				//invia push al device del follower
				apn_push($user,$mood,$message,$device_id,0);
				//inserisce notifica in tabella notifiche
				$query = "INSERT INTO notifications VALUES (NOW(),'".$id_numerico."','".$user_id."','"."MOOD UPDATE-".$message."')";
				$result_interna = mysql_query($query) or die("Query non valida: " . mysql_error());
			}
		}				
	}
	mysql_close($con);
	return true;
}

function setPosition($user,$lat,$long){
	db_connection();
	//get user sharing setting
	$result = mysql_query("select sharing_type from users where username='".$user."'") or die("Query select sharing type non valida: " . mysql_error());
	$sharing_type = -1;
	while($row = mysql_fetch_array($result)){
		$sharing_type=$row['sharing_type'];
	}
	//reverse geo actual lat-long
	$rev_geo = explode(",",reverseGeo($lat,$long));
	$current_city = $rev_geo[0];
	$current_state = $rev_geo[1];
	//set geo based on sharing type
	switch($sharing_type){
		case 0:
			$lat = 0.0;
			$long = 0.0;
		break;
		case 2://city
			$result = mysql_query("select geo_lat,geo_lng from meta_location where local_name='".$current_city."' and iso like '".$current_state."%'") or die("Query select state coord: " . mysql_error());
			while($row = mysql_fetch_array($result)){
				$lat=$row['geo_lat'];
				$long=$row['geo_lng'];
			}
		break;
		case 3://state
			$result = mysql_query("select geo_lat,geo_lng from meta_location where iso='".$current_state."'") or die("Query select state coord: " . mysql_error());
			while($row = mysql_fetch_array($result)){
				$lat=$row['geo_lat'];
				$long=$row['geo_lng'];
			}
		break;
		default:
		case 1:
		break;
	}
	//update position in db
	$result = mysql_query("update users set latitude='".$lat."', longitude='".$long."', city='".$current_city."', state='".$current_state."', last_update=NOW() where username='".$user."'") or die("Query non valida: " . mysql_error());
	mysql_close($con);
	return true;
}
function get_position_sharing_type($user){
	$sharing_type_array= array();
	db_connection();
	$result = mysql_query("SELECT sharing_type from users where username='".$user."'") or die("Query non valida: " . mysql_error());
	while($row = mysql_fetch_array($result)){
		$sharing_type_array['type']=intval($row['sharing_type']);
	}
	mysql_close($con);
	return $sharing_type_array;
}

function getMood($user){
	$mood=-1;
	$mood_array = array();
	db_connection();
	$result = mysql_query("SELECT * from users where username='".$user."'") or die("Query non valida: " . mysql_error());
	//echo($result);
	while($row = mysql_fetch_array($result)){
		//echo($row['email']);
		$mood_array['mood']=intval($row['mood']);
		$mood_array['message']=$row['message'];
	}
	//echo($mood_array);
	mysql_close($con);
	return $mood_array;
}


function getfriends($user){
	db_connection();
	$friends_list = array();
	
	$result = mysql_query("SELECT friends from users where username='".$user."'") or die("Query non valida: " . mysql_error());
	$encoded_friends="";
	while($row = mysql_fetch_array($result)){
		$encoded_friends=$row['friends'];
	}
	$friends_user_names = explode(",", $encoded_friends);
	//echo(count($friends_user_names)."<BR>");
	if(count($friends_user_names)<1) return $friends_list;
	foreach($friends_user_names as $row_name){
		$sql = "SELECT * from users where id='".$row_name."'";
		//echo($sql."<br>");
		$result = mysql_query($sql) or die("Query non valida: " . mysql_error());
		//echo("result = ".$result."<br>");
		while($row = mysql_fetch_array($result)){
			$user_details = array('username'=>$row['username'],'mood'=>$row['mood'],'lat'=>$row['latitude'],'long'=>$row['longitude'],'upd'=>$row['last_update'],'message'=>$row['message']);
			//echo("details: ".$user_details['username']." ".$user_details['mood']."<br>");
			array_push($friends_list,$user_details);
		}
	}
	//echo(count($friends_list)."<br>");
	mysql_close($con);
	return $friends_list;
}


function getfollowers_data($user){
	db_connection();
	$friends_list = array();
	
	$result = mysql_query("SELECT followers from users where username='".$user."'") or die("Query non valida: " . mysql_error());
	$encoded_friends="";
	while($row = mysql_fetch_array($result)){
		$encoded_friends=$row['followers'];
	}
	$friends_user_names = explode(",", $encoded_friends);
	//echo(count($friends_user_names)."<BR>");
	if(count($friends_user_names)<1) return $friends_list;
	foreach($friends_user_names as $row_name){
		$sql = "SELECT * from users where id='".$row_name."'";
		//echo($sql."<br>");
		$result = mysql_query($sql) or die("Query non valida: " . mysql_error());
		//echo("result = ".$result."<br>");
		while($row = mysql_fetch_array($result)){
			$user_details = array('username'=>$row['username'],'mood'=>$row['mood'],'lat'=>$row['latitude'],'long'=>$row['longitude'],'upd'=>$row['last_update'],'message'=>$row['message']);
			//echo("details: ".$user_details['username']." ".$user_details['mood']."<br>");
			array_push($friends_list,$user_details);
		}
	}
	//echo(count($friends_list)."<br>");
	mysql_close($con);
	return $friends_list;
}

function set_position_sharing_type($user,$share){
	db_connection();
	
	$result = mysql_query("update users set sharing_type=".$share." where username='".$user."'") or die("Query non valida: " . mysql_error());
	//notifica i followers del cambiamento stato
	mysql_close($con);
	return true;
}

function getPosition($user){
	db_connection();
	$coordinates = array();
	
	$result = mysql_query("SELECT latitude,longitude from users where username='".$user."'") or die("Query non valida: " . mysql_error());
	$lat=0;
	$lon=0;
	while($row = mysql_fetch_array($result)){
		$lat=$row['latitude'];
		$lon=$row['longitude'];
	}
	array_push($coordinates,array('latitude'=>$lat,'longitude'=>$lon));
	
	mysql_close($con);
	return $coordinates;
}


function searchPeople($query){
	db_connection();
	$friends_list = array();
	
	
	//$sql = "SELECT * from users where id='".$row_name."'";
	$sql = "SELECT * from users where username like '".$query."%'";
	//echo($sql."<br>");
	$result = mysql_query($sql);
	//echo("result = ".$result."<br>");
	if($result==false){
		array_push($friends_list,array('username'=>"sql error",'mood'=>"sql error",'lat'=>"sql error",'long'=>"sql error",'upd'=>"sql error"));
		return $friends_list;
	}
	if(mysql_num_rows($result)==0){
		array_push($friends_list,array('username'=>"no results",'mood'=>"no results",'lat'=>"no results",'long'=>"no results",'upd'=>"no results"));
		return $friends_list;
	}
	while($row = mysql_fetch_array($result)){
		$user_details = array('username'=>$row['username'],'mood'=>$row['mood'],'lat'=>$row['latitude'],'long'=>$row['longitude'],'upd'=>$row['last_update']);
		//echo("details: ".$user_details['username']." ".$user_details['mood']."<br>");
		array_push($friends_list,$user_details);
	}
	
	//echo(count($friends_list)."<br>");
	mysql_close($con);
	return $friends_list;
}

function login($user,$psw,$device_id){
	db_connection();
	$user_id = -1;
	$sql = "SELECT * from users where active=1 and username='".$user."' and password='".$psw."'";
	$result = mysql_query($sql) or die("Query select non valida: " . mysql_error());
	if(mysql_num_rows($result)!=1){
		return false;
	}
	else{
		$row = mysql_fetch_array($result);
		$user_id = $row['id'];
		//aggiorna o inserisce record per device id
		$sql = "SELECT count(*) as total from devices where user_id=".$user_id;
		$result=mysql_query($sql);
		$data=mysql_fetch_assoc($result);
		//echo($data."<br>");
		if($data['total']==1){
			//echo('upd'.$user_id);
			$sql = "update devices set device_id ='".$device_id."' where user_id='".$user_id."'";
			$result = mysql_query($sql) or die("Query update non valida: " . mysql_error());
		}
		else{
			//echo('ins');
			$sql = "insert into devices values ('".$user_id."','".$device_id."','ios')";
			$result = mysql_query($sql) or die("Query insert non valida: " . mysql_error());
		}
	}
	mysql_close($con);
	return true;
}

function get_locations($lastupdate){
	db_connection();
	$locations=array();
	$result = mysql_query("SELECT * from meta_location where used=1") or die("Query non valida: " . mysql_error());
	if(mysql_num_rows($result)>0){
		while($row = mysql_fetch_array($result)){
			$loc_details = array('loc'=>$row['local_name'],'mood'=>$row['mood'],'lat'=>$row['geo_lat'],'long'=>$row['geo_lng'], 'stats'=>$row['stats']);
			//echo("details: ".$user_details['username']." ".$user_details['mood']."<br>");
			array_push($locations,$loc_details);
		}
	}
	mysql_close($con);
	return $locations;
}

function add_follower($user_id,$follower_id){
	db_connection();
	
	
	$result = mysql_query("SELECT followers from users where id='".$user_id."'") or die("Query non valida: " . mysql_error());
	$encoded_followers="";
	while($row = mysql_fetch_array($result)){
		$encoded_followers=$row['followers'];
	}
	$encoded_followers.=$follower_id.",";
	$result = mysql_query("update users set followers='".$encoded_followers."' where id='".$user_id."'") or die("Query non valida: " . mysql_error());
	
	mysql_close($con);
}

function addfriend($user,$friend){
	db_connection();
	$user_id=0;
	$friend_id=0;
	$result = mysql_query("SELECT id from users where active=1 and username='".$user."'") or die("Query non valida: " . mysql_error());
	if(mysql_num_rows($result)!=1){
		return false;
	}
	while($row = mysql_fetch_array($result)){
		$user_id=$row['id'];
	}
	
	$result = mysql_query("SELECT id from users where active=1 and username='".$friend."'") or die("Query non valida: " . mysql_error());
	if(mysql_num_rows($result)!=1){
		return false;
	}
	while($row = mysql_fetch_array($result)){
		$friend_id=$row['id'];
	}
	if($user_id==$friend_id) return false;
		
	$result = mysql_query("SELECT friends from users where username='".$user."'") or die("Query non valida: " . mysql_error());
	$encoded_friends="";
	while($row = mysql_fetch_array($result)){
		$encoded_friends=$row['friends'];
	}
	//check already friend
	$friends_user_names = explode(",", $encoded_friends);
	foreach($friends_user_names as $id){
		if($id==$friend_id)
			return false;
	}
	///
	$encoded_friends.=$friend_id.",";
	$result = mysql_query("update users set friends='".$encoded_friends."' where id='".$user_id."'") or die("Query non valida: " . mysql_error());
	mysql_close($con);
	
	add_follower($friend_id,$user_id);
	
	$message = $user." added you as friend";
	send_instant_message($user,$friend,$message);
	return true;
}

function remove_friend($user,$friend){
	db_connection();
	$user_id=0;
	$friend_id=0;
	$result = mysql_query("SELECT id from users where active=1 and username='".$user."'") or die("Query non valida: " . mysql_error());
	if(mysql_num_rows($result)!=1){
		return false;
	}
	while($row = mysql_fetch_array($result)){
		$user_id=$row['id'];
	}
	
	$result = mysql_query("SELECT id from users where active=1 and username='".$friend."'") or die("Query non valida: " . mysql_error());
	if(mysql_num_rows($result)!=1){
		return false;
	}
	while($row = mysql_fetch_array($result)){
		$friend_id=$row['id'];
	}
	if($user_id==$friend_id) return false;
	
	
	$result = mysql_query("SELECT friends from users where username='".$user."'") or die("Query non valida: " . mysql_error());
	$encoded_friends="";
	while($row = mysql_fetch_array($result)){
		$encoded_friends=$row['friends'];
	}
	//remove friend
	$encoded_friends = str_replace($friend_id.",","",$encoded_friends);
	//echo($encoded_friends .'<br>');
	$result = mysql_query("update users set friends='".$encoded_friends."' where id='".$user_id."'") or die("Query non valida: " . mysql_error());
	mysql_close($con);
	return true;
}

function remove_follower($user,$follower){
	db_connection();
	$user_id=0;
	$follower_id=0;
	$result = mysql_query("SELECT id from users where active=1 and username='".$user."'") or die("Query non valida: " . mysql_error());
	if(mysql_num_rows($result)!=1){
		return false;
	}
	while($row = mysql_fetch_array($result)){
		$user_id=$row['id'];
	}
	
	$result = mysql_query("SELECT id from users where active=1 and username='".$follower."'") or die("Query non valida: " . mysql_error());
	if(mysql_num_rows($result)!=1){
		return false;
	}
	while($row = mysql_fetch_array($result)){
		$follower_id=$row['id'];
	}
	if($user_id==$follower_id) return false;
	
	
	$result = mysql_query("SELECT followers from users where username='".$user."'") or die("Query non valida: " . mysql_error());
	$encoded_followers="";
	while($row = mysql_fetch_array($result)){
		$encoded_followers=$row['followers'];
	}
	//remove follower
	$encoded_followers = str_replace($follower_id.",","",$encoded_followers);
	//echo($encoded_friends .'<br>');
	$result = mysql_query("update users set followers='".$encoded_followers."' where id='".$user_id."'") or die("Query non valida: " . mysql_error());
	mysql_close($con);
	
	//invia messaggio rimozione da follower
	
	remove_friend($follower,$user);
	
	$message = $user." removed you from his followers";
	send_instant_message($user,$follower,$message);
	
	return true;
}

function check_notifications($user){
	db_connection();
	$result = mysql_query("SELECT id from users where username='".$user."'") or die("Query non valida: " . mysql_error());
	$userid=-1;
	while($row = mysql_fetch_array($result)){
		$userid=$row['id'];
	}
	//echo('userid:'.$userid);
	$sql = "SELECT count(*) from notifications where to_=".$userid;
	//echo($sql);
	$result = mysql_query($sql) or die("Query non valida: " . mysql_error());
	$row = mysql_fetch_row($result);
	//echo('righe:'.$row);
	
	$result_array = array();
	$result_array['notifications']=intval($row);
	mysql_close($con);
	return $result_array;
}

function reset_notifications_count($user){
	db_connection();
	
	$result = mysql_query("update users set notifications_count=0 where username='".$user."'") or die("Query non valida: " . mysql_error());
	//notifica i followers del cambiamento stato
	mysql_close($con);
	return true;
}

function get_notifications($user){
	db_connection();
	$notifications=array();
	$result = mysql_query("SELECT * from notifications where to_=(select id from users where username='".$user."') or from_=(select id from users where username='".$user."') order by data asc") or die("Query non valida: " . mysql_error());
	if(mysql_num_rows($result)>0){
		while($row = mysql_fetch_array($result)){
			$destinatario="";
			$mittente="";
			$query_interna_result = mysql_query("SELECT username from users where id=".$row['to_']."") or die("Query select user non valida: " . mysql_error());
			if(mysql_num_rows($query_interna_result)>0){
				while($row_interna = mysql_fetch_array($query_interna_result)){
					$destinatario=$row_interna['username'];
				}
			}
			$query_interna_result = mysql_query("SELECT username from users where id=".$row['from_']."") or die("Query select user non valida: " . mysql_error());
			if(mysql_num_rows($query_interna_result)>0){
				while($row_interna = mysql_fetch_array($query_interna_result)){
					$mittente=$row_interna['username'];
				}
			}
			
			$notification_details = array('data'=>$row['data'],'to'=>$destinatario,'from'=>$mittente,'message'=>$row['message']);
			//echo("details: ".$user_details['username']." ".$user_details['mood']."<br>");
			array_push($notifications,$notification_details);
		}
	}
	mysql_close($con);
	return $notifications;
}

function test_loc(){
	db_connection();
	//azzera tutti i campi used di meta_location
	$result = mysql_query("update meta_location set used=0, mood=0, users=0") or die("Query non valida: " . mysql_error());
	
	//query totale users per city
	$sql = "SELECT city,state,avg(mood) as avgmood,count(*) as tot from users group by city";
	$result = mysql_query($sql) or die("errore: ".mysql_error());
	
	while($row = mysql_fetch_array($result)){
		echo("details: ".$row['tot']." ".$row['avgmood']." ".$row['city']." ".$row['state']."<br>");
		//aggiorna used e mood
		$update = mysql_query("update meta_location set used=1, users='".$row['tot']."', mood='".$row['avgmood']."' where local_name='".$row['city']."' and iso like '".$row['state']."%'") or die("Query non valida: " . mysql_error());
	}
	mysql_close($con);
	return "tester";
}
// --- Step 3: Process Request
 
// Method A: Say Hello to the API
/*if( strcasecmp($_GET['method'],'hello') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
    $response['data'] = '40.5-45.7';  
}*/

if( strcasecmp($_GET['method'],'login') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
    if(login($_GET['user'],$_GET['psw'],$_GET['device_id'])){
		$response['data'] = 'loginOK';
	}
	else{
		$response['data'] = 'loginERROR';
	}
	
}

if( strcasecmp($_GET['method'],'getmood') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
	$mood_data = array();
	array_push($mood_data,getMood($_GET['user']));
    $response['data'] = $mood_data[0];
}

if( strcasecmp($_GET['method'],'setmood') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
    if(setMood($_GET['user'],$_GET['mood'],$_GET['message'],$_GET['lat'],$_GET['long'])){
		$response['data'] = 'moodSetOk';
	}
}

if( strcasecmp($_GET['method'],'get_position_sharing_type') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
	$share_data = array();
	array_push($share_data,get_position_sharing_type($_GET['user']));
    $response['data'] = $share_data[0];
}

if( strcasecmp($_GET['method'],'set_position_sharing_type') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
    if(set_position_sharing_type($_GET['user'],$_GET['share'])){
		$response['data'] = 'sharingTypeSetOK';
	}
}

if( strcasecmp($_GET['method'],'reset_notifications_count') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
    if(reset_notifications_count($_GET['user'])){
		$response['data'] = 'reset_notifications_countOK';
	}
}

if( strcasecmp($_GET['method'],'setposition') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
    if(setPosition($_GET['user'],$_GET['lat'],$_GET['long'])){
		$response['data'] = 'positionSetOk';
	}
}

if( strcasecmp($_GET['method'],'getposition') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
	$response['data'] = getPosition($_GET['user']);
}

if( strcasecmp($_GET['method'],'getfriends') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
	$friends = array();
	array_push($friends, getfriends($_GET['user']));
	
    {
		$response['data'] = $friends[0];
	} 
	//sleep(4);
} 
if( strcasecmp($_GET['method'],'getfollowers_data') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
	$friends = array();
	array_push($friends, getfollowers_data($_GET['user']));
	
    {
		$response['data'] = $friends[0];
	} 
	//sleep(4);
} 
if( strcasecmp($_GET['method'],'search_people') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
	$friends = array();
	array_push($friends, searchPeople($_GET['query']));
	
    {
		$response['data'] = $friends[0];
	} 
	//sleep(4);
} 

if( strcasecmp($_GET['method'],'new_user') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
    if(register_new_user($_GET['user'],$_GET['password'],$_GET['email'])){
		$response['data'] = 'registrationOK';
	}
}
 
if( strcasecmp($_GET['method'],'add_friend') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
    if(addfriend($_GET['user'],$_GET['friend'])){
		$response['data'] = 'addfriendOK';
	}
	else{
		$response['data'] = 'addfriendERROR';
	}
}
 
if( strcasecmp($_GET['method'],'get_locations') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
    $response['data'] = get_locations($_GET['last_update']);
}

if( strcasecmp($_GET['method'],'check_notifications') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
    $response['data'] = check_notifications($_GET['user']);
}

if( strcasecmp($_GET['method'],'get_notifications') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
    $response['data'] = get_notifications($_GET['user']);
}

if( strcasecmp($_GET['method'],'send_message') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
    $response['data'] = send_instant_message($_GET['sender'],$_GET['user'],$_GET['message']);
}

if( strcasecmp($_GET['method'],'test') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
    $response['data'] = getfollowers('ziffo');
}

if( strcasecmp($_GET['method'],'remove_friend') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
    if(remove_friend($_GET['user'],$_GET['friend'])){
		$response['data'] = 'remove_friendOK';
	}
	else{
		$response['data'] = 'remove_friendERROR';
	}
}

if( strcasecmp($_GET['method'],'remove_follower') == 0){
    $response['code'] = 1;
    $response['status'] = $api_response_code[ $response['code'] ]['HTTP Response'];
    if(remove_follower($_GET['user'],$_GET['follower'])){
		$response['data'] = 'remove_followerOK';
	}
	else{
		$response['data'] = 'remove_followerERROR';
	}
}


//http://www.mariosalvucci.com/rest/?method=send_message&format=json&user=ziffo&message=culo.%20ryg
// --- Step 4: Deliver Response
//apn push http://synesthesiadesign.net/push/simplepush.php?format=json&method=push&device=a56713a5d85aa4962d8987ba53c229cb481e4a8b4e0b2b17f882da4acca8ee40&message=ciccioculo
// Return Response to browser 

deliver_response($_GET['format'], $response);
 
?>
            