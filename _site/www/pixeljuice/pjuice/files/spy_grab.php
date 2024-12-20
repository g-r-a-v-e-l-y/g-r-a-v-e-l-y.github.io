<?php
/*
Options : decide now whether you want to
thumbnail or archive the images. If you dont
have imageMagik on the server, you probably
want to leave $thumb empty
*/

$thumb="1";
$archive="0";
$comments="0";

/*
users can set up an array of spy variables
by url. fopen has ftp and https support so
a login and password may be set. This is not
ssh or anything so if possible, create a
user just for doing spies on the remote machine.
*/

$remoteServer="http://pixeljuice.dhs.org:81/spy/";
$login="";
$password="";

/*
mirrors for the local stuff...
*/
$localDir="/opt/www/grant.outerbody.com/html/spy/";
$thumbDir="/opt/www/grant.outerbody.com/html/spy/thumbs/";

/*
filenames for the spies on the remote server
add or remove vars as needed
*/

$whichSpy=array("local"=> array(
                      "desktop"=>"spy.jpg",
                      "dvdplayer"=>"dvd.jpg",
                      "work"=>"work.jpg",
                      "linux"=>"debian.jpg"
                      ),
                  "remote"=>array(
                      "desktop"=>"spy.jpg",
                      "dvdplayer"=>"dvd.jpg",
                      "work"=>"work.jpg",
                      "linux"=>"debian.jpg"
                      ),
                  "local_thumb"=>array(
                      "desktop"=>"spy_thumb.jpg",
                      "dvdplayer"=>"dvd_thumb.jpg",
                      "work"=>"work_thumb.jpg",
                      "linux"=>"debian_thumb.jpg"
                      )
               );
/*
set $webFile and $localFile via javascript? have
to keep it out of the url
*/

$webFile = $remoteServer . $whichSpy[remote][desktop];
$localFile = $localDir . $whichSpy[local][desktop];
$thumbFile = $thumbDir . $whichSpy[local_thumb][desktop];

/*
imageMagik voodoo :)
fill magikArgs with whatever you want. the thumb size is just
a var so that it can be set easily via the gooey
*/

$thumbsApp="mogrify ";
$thumbSize="80 ";
$magikArgs="-scale ";


/*
you have to declare an estimate file size for the jpg
because binaries don't have eof declarations like text
this is in bytes... be careful here ;)
*/

$spySize="2000000";

/*
there are a lot of things missing so far, like
the linked comments setup and whatnot.. fuck it
lets get rockin
*/

$wgetCall="wget $webFile -O $localFile";
system($wgetCall);
$systemCall="$thumbsApp $magikArgs $thumbSize $thumbFile";
system($systemCall);

/*Grabbing the date for the local file*/
$spyTime=date("Y-m-d_G.i.s", filemtime($localFile));
?>

