<?php
/**
 * ...
 * @author Dustin Sparks
 * @version 0.1
 */
$username = $_REQUEST['username'];
$password = $_REQUEST['password'];

if(!isset($username))$username = 'pixelmixer';
if(!isset($password))$password = '9842365';

$dir = 'users/';
$dh  = opendir($dir);

while (false !== ($filename = readdir($dh))) {
    $users[] = $filename;
}

rsort($users);

array_pop($users);
array_pop($users);

echo "users=";
for($i =0; $i < count($users); $i++)
{
	echo $users[$i];
	
	if($i != count($users)-1)
	{
		echo ",";
	}
}
?>