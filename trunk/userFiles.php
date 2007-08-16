<?php
/**
 * ...
 * @author Dustin Sparks
 * @version 0.1
 */
$username = $_REQUEST['username'];
$password = $_REQUEST['password'];
$video    = $_REQUEST['video'];

if(!isset($username))$username = 'pixelmixer';
if(!isset($password))$password = '9842365';
if(!isset($video))      $video = 'video';

$dir = 'users/'. $username . '/' . $video .'/xml';
$dh  = opendir($dir);

while (false !== ($filename = readdir($dh))) {
    $files[] = $filename;
}

rsort($files);

array_pop($files);
array_pop($files);

echo "files=";
for($i =0; $i < count($files); $i++)
{
	echo $files[$i];
	
	if($i != count($files)-1)
	{
		echo ",";
	}
}
?>