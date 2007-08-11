<?php
/**
 * ...
 * @author Dustin Sparks
 * @version 0.1
 */
 
$username = $_POST['username'];
$password = $_POST['password'];
$videoname= $_POST['name'];
$xml = $_POST['xml'];

if(!isset($username)) $username = "pixelmixer";
if(!isset($videoname)) $videoname = "video1";

	$today = time();
	$logfile = $today."_log.xml";
	$dir = "users";
	$dir2 = $username;
	$dir3 = $videoname;
	$dir4 = "xml";
	$dir5 = "video";
	$saveLocation=$dir .'/'. $dir2 . '/'. $dir3 . '/'. $dir4 . '/' . $logfile;
	$logMessage = stripslashes($xml);
	
	if(!is_dir($dir) || !is_dir($dir2) || !is_dir($dir3) || !is_dir($dir4))
	{
	   if(!is_dir("$dir")) mkdir($dir,"0755");
	   if(!is_dir("$dir/$dir2"))mkdir("$dir/$dir2","0755");
	   if(!is_dir("$dir/$dir2/$dir3"))mkdir("$dir/$dir2/$dir3","0755");
	   if(!is_dir("$dir/$dir2/$dir3/$dir4"))mkdir("$dir/$dir2/$dir3/$dir4","0755");
	   if(!is_dir("$dir/$dir2/$dir3/$dir5"))mkdir("$dir/$dir2/$dir3/$dir5","0755");
	}
	
	
	if (!$handle = fopen($saveLocation, "a"))
	{
		 //ERROR, DO SOMETHING
		 exit;
	}
	else
	{
		 if(fwrite($handle,$logMessage)===FALSE)
		 {
			  //ERROR, DO SOMETHING
			  exit;
		 }
		echo "var result:String = \"$logfile\";";
		fclose($handle);
	}
	
	
?>