<?php
$webFile = "http://65.8.36.37:81/spy/local/spy.jpg";
$localFile = "/opt/www/grant.outerbody.com/html/spy/spy.jpg";
$thumbFile = "/opt/www/grant.outerbody.com/html/spy/thumbs/spy.jpg";
$spyImage = fopen ($webFile, "rb");
$localSpy = fopen ($localFile, "wb");
$thumbSpy = fopen ($thumbFile, "wb");
$buffer=fread($spyImage,2000000);
fwrite($localSpy,$buffer,2000000);
fwrite($thumbSpy,$buffer,2000000);
fclose ($spyImage);
fclose($localSpy);
fclose($thumbSpy);
$magikArgs = "-scale 200";
$spyTime=date("Y-m-d_G.i.s", filemtime($localFile));
system("mogrify $magikArgs $thumbFile");
?>

