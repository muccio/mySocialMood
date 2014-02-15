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

function update_locations(){
	db_connection();
	//azzera tutti i campi used di meta_location
	$result = mysql_query("update meta_location set used=0, mood=0, users=0, stats='no data available'") or die("Query non valida: " . mysql_error());
	
	//query totale users per city
	$sql = "SELECT city,state,avg(mood) as avgmood,count(*) as tot from users group by city";
	$result = mysql_query($sql) or die("errore: ".mysql_error());
	
	while($row = mysql_fetch_array($result)){
		$stats = "details:<br>users-".$row['tot']."<br>average Mood-".$row['avgmood']."<br>City-".$row['city']."<br>State-".$row['state'];
		echo($stats);
		//aggiorna used e mood
		$update = mysql_query("update meta_location set used=1, stats='".$stats."', users='".$row['tot']."', mood='".$row['avgmood']."' where local_name='".$row['city']."' and iso like '".$row['state']."%'") or die("Query non valida: " . mysql_error());
		
	}
	echo('db updated');
	return true;
}

update_locations();
//echo("locations updated");
?>