<?php
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
db_connection();
$user = $_GET['user'];
$key = $_GET['key'];
$result = mysql_query("update users set active=1 where username='".$user."' and confirm='".$key."'") or die("Query non valida: " . mysql_error());

echo('account active');
//echo($_GET['user']."---".$_GET['key']);
?>