<?PHP
$spymusic=0;
$WebFile = "http://pixeljuice.dhs.org:81/music/winamp";
$homefile = fopen ($WebFile, "r");
while (!feof($homefile)) {
$buffer=fgets($homefile,4096);
$spymusic=$buffer;
}
fclose($homefile);
?>
<!doctype html public "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<head>
<title>pixeljuice spy2</title>

<meta http-equiv="expires" content="-1">
</head>
<body>
  <div id="main"><p>
<?php echo $spymusic ?>
</p>
  </div>

</body>
</html>

