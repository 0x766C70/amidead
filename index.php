<!doctype html>

<html lang="en">
<head>
  <meta charset="utf-8">

  <title>amidead</title>
  <meta name="description" content="The HTML5 Herald">
  <meta name="vlp" content="amidead_project">
</head>
<body>
I'm not dead !
<?php
	$file = 'log';
	$today = date("Y-m-d")."T".date("H:i:s");
	file_put_contents($file, $today."\n", FILE_APPEND | LOCK_EX);
?>
</body>
</html>
