<?php
/**
 * ...
 * @author Dustin Sparks
 * @version 0.1
 */
$username = 'pixelmixer';
$password = '9842365';

$dir = 'users/'. $username . '/video/xml';

if ($handle = opendir($dir)) {
    echo "var $username"."Files:Array = new Array(";
    while (false !== ($file = readdir($handle))) {
		if(true !== is_dir($file))
		{
			echo "$file,";
		}
    }
	echo ");";
    closedir($handle);
}
?>