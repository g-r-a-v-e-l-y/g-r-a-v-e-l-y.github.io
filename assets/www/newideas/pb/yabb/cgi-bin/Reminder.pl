#!C:/web/perl/bin

###############################################################################
# Reminder.pl                                                                 #
###############################################################################
# YaBB: Yet another Bulletin Board                                            #
# Open-Source Project started by Zef Hemel (zef@zefnet.com)                   #
# Software Version: YaBB 1 Gold Beta4                                         #
# =========================================================================== #
# Software Distributed by:    www.yabb.org                                    #
# Support, News, Updates at:  www.yabb.org/cgi-bin/support/YaBB.pl            #
# =========================================================================== #
# Copyright (c) 2000-2001 YaBB - All Rights Reserved                          #
# Software by: The YaBB Development Team                                      #
###############################################################################

if( $ENV{'SERVER_SOFTWARE'} =~ /IIS/ ) {
	$yyIIS = 1;
	$0 =~ m~(.*)(\\|/)~;
	$yypath = $1;
	$yypath =~ s~\\~/~g;
	chdir($yypath);
	push(@INC,$yypath);
	print "HTTP/1.0 200 OK\n";
}

require "Settings.pl";
require "$language";
require "$sourcedir/Load.pl";
require "$sourcedir/Subs.pl";
require "$sourcedir/Security.pl";

$reminderplver="1 Gold Beta4";

&get_date;
&readform;
$cgi = "$boardurl/YaBB.pl\?board=$currentboard";

if($username eq "") { $username = "Guest"; }

### Write log ###
&WriteLog;

### Load board information ###
&LoadBoard;

$thisprogram = "Reminder.pl";
$yytitle="Password Reminder";

&readform;
&header;

if ($ENV{'QUERY_STRING'} =~ /input_user/i) {
   &input;
   &footer;
   exit;
   }

 use CGI;

 $cgi = new CGI;
 $user = $cgi->param('user');

 open(FILE, "$memberdir/$user.dat") || &no_user_error;

 &lock(FILE);
 @settings=<FILE>;
 &unlock(FILE);
 close(FILE);
 $password = $settings[0];
 $name = $settings[1];
 $email = $settings[2];
 $status = $settings[7];

 chop($name);
 chop($email);
 chop($password);
 chop($status);

 &email;

 print "<br><center><b>$txt{'192'}</b></center>";
 print "<br><center><a href=\"javascript:history.back(-2)\">$txt{'193'}</a></center><br>\n";
 &footer;

 exit;

sub email {
	$subject = "$txt{'36'} $mbname : $name";
	&sendmail($email,$subject,"$name,\n\n$txt{'35'}, $txt{'36'} $mbname:\n$txt{'35'}: $user\n$txt{'36'}: $password\nStatus: $status\n\n$mbname Team");
}

sub input {
print <<EOM;
<center>
<br><b>$mbname $txt{'36'} $txt{'194'}</b><br><br>
<form action="Reminder.pl?user=">
$txt{'35'}: <input type="text" name="user">
<input type="submit" value="$txt{'339'}"></form>
</center>
EOM
}

 sub mailprog_error {
 print "<br><center><b>$txt{'394'}<br>$txt{'395'} <a href=\"mailto:$webmaster_email\">Webmaster</a> $txt{'396'}.</b></center>\n";
 print "<br><a href=\"javascript:history.back(-1)\">Back</a><br>\n";
 &footer;
 exit;
 }
 sub no_user_error {
 print "<br><center><b>$txt{'40'}</b></center>\n";
 print "<br><a href=\"javascript:history.back(-1)\">$txt{'193'}</a><br>\n";
 &footer;
 exit;
 }
