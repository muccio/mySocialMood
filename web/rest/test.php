<?php
	$database_name="ximarios_mariosalvucci";
	$database_user="ximarios_social";
	$database_psw="d9(A-p#K0&WV";
	$con = mysql_connect("localhost",$database_user,$database_psw);
	if (!$con){	
		echo('Could not connect: ' . mysql_error());	
		return false;
	}
	else{
		//echo('conn ok - ');
	}
	if(mysql_select_db($database_name, $con)){
		//echo('db selection ok - ');
	}
	else{
		echo('db selection error - ');
		return false;
	}
	$result = mysql_query("SELECT * from users ") or die("Query non valida: " . mysql_error());
	//$result = mysql_query("update users set mood='".$mood."', latitude='".$lat."', longitude='".$long."', last_update=NOW() where username='".$user."'") or die("Query non valida: " . mysql_error());
	//echo($result);
	while($row = mysql_fetch_array($result)){
		echo($row['username']." ".$row['email']." ".$row['code']." ".$row['active']." ".$row['latitude']." ".$row['longitude']." ".$row['mood']." ".$row['last_update']."<br>");
	}
	mysql_close($con);
	
	$message = 'to activate your account follow this link: <a href="http://www.mariosalvucci.com/rest/confirm.php?user=pippo&key=pluto>activate</a>';
	
	// In case any of our lines are larger than 70 characters, we should use wordwrap()
	//$message = wordwrap($message, 70, "\r\n");
	
	// Send
	

?>