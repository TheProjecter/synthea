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

$dir = 'users/'. $username . '/' . $video .'/video';
$dh  = opendir($dir);

while (false !== ($filename = readdir($dh))) {
    $videos[] = $filename;
}

rsort($videos);

array_pop($videos);
array_pop($videos);

echo "videos=";
for($i =0; $i < count($videos); $i++)
{
	echo $videos[$i];
	
	if($i != count($videos)-1)
	{
		echo ",";
	}
}
?>