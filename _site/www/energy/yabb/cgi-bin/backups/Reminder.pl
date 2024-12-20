#!/usr/bin/perl
#
###############################################################################
# YaBB.pl                                                                     #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Pim Raeskin                                  #
###############################################################################

require "Settings.pl";
require "$sourcedir/Subs.pl";

&get_date;
&readform;
$cgi = "$boardurl/YaBB.pl\?board=$currentboard";

if($username eq "") { $username = "Guest"; }

# Write log
open(LOG, "$vardir/log.txt");
&lock(LOG);
@entries = <LOG>;
&unlock(LOG);
close(LOG);
open(LOG, ">$vardir/log.txt");
&lock(LOG);
$field="$username";
$field = "$ENV{'REMOTE_ADDR'}";
print LOG "$field\|$date\n";
foreach $curentry (@entries) {
	$curentry =~ s/\n//g;
	($name, $value) = split(/\|/, $curentry);
	$date1="$value";
	$date2="$date";
	&calctime;
	if($name ne "$field" && $result <= 15) {
		print LOG "$curentry\n";
	}
}
&unlock(LOG);
close(LOG);

# Load board information
if($currentboard ne "") {
	open(FILE, "$boardsdir/$currentboard.dat");
	&lock(FILE);
	@boardinfo=<FILE>;
	&unlock(FILE);
	close(FILE);
	$boardinfo[0] =~ s/\n//g;
	$boardinfo[2] =~ s/\n//g;
	$boardinfo[0] =~ s/\r//g;
	$boardinfo[2] =~ s/\r//g;
	$boardname = "$boardinfo[0]";
	$boardmoderator = "$boardinfo[2]";
	open(MODERATOR, "$memberdir/$boardmoderator.dat");
	&lock(MODERATOR);
	@modprop = <MODERATOR>;
	&unlock(MODERATOR);
	close(MODERATOR);
	$moderatorname = "$modprop[1]";
	$moderatorname =~ s/\n//g;
 }
$thisprogram = "Reminder.pl";

$title="Password Reminder";

&readform;

&header;

if ($ENV{'QUERY_STRING'} =~ /input_user/i) {
   &input;
   &footer;
   exit;
   }

 use CGI;
 use LWP::Simple;

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
 print "<br><a href=\"javascript:history.back(-1)\">$txt{'193'}</a><br>\n";
 &footer;

 exit;

sub email {

$subject = "$txt{'36'} $mbname : $name";

open (MAIL, "|$mailprog -t") || &mailprog_error;
print MAIL "To: $email\n";
print MAIL "From: $webmaster_email\n";
print MAIL "Subject: $subject\n";
print MAIL <<"EOT";
$name,

$txt{'35'}, $txt{'36'} $mbname:
$txt{'35'}: $user
$txt{'36'}: $password
Status: $status

$mbname Team
EOT
     close MAIL;
}

sub input {
print <<EOM;
<br><b>$mbname $txt{'36'} $txt{'194'}</b><br><br>
<form action="Reminder.pl?user=">
$txt{'35'}: <input type="text" name="user">
<input type="submit" value="Send"></form>
EOM
}

 sub mailprog_error {
 print "<br><center><b>Mailprogram error.<br>Send email to <a href=\"mailto:$webmaster_email\">Webmaster</a> to ask for password.</b></center>\n";
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
