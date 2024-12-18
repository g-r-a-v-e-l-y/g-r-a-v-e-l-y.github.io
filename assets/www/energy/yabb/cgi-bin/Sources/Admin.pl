###############################################################################
# Admin.pl                                                                    #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Zef Hemel                                    #
###############################################################################

sub Admin {
	# Only allow Adminstrators to access the admin
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	$title = "$txt{'2'}";
	# Load data for the 'remove old messages' feature
	open(FILE, "$vardir/oldestmes.txt");
	&lock(FILE);
	$maxdays = <FILE>;
	&unlock(FILE);
	close(FILE);
	&header;
	print <<"EOT";
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'2'}</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}">
<a href="$cgi&action=managecats">$txt{'3'}</a><br>
<a href="$cgi&action=manageboards">$txt{'4'}</a><br>
<a href="$cgi&action=viewmembers">$txt{'5'}</a><br>
<a href="$cgi&action=mailing">$txt{'6'}</a><br>
<a href="$cgi&action=editnews">$txt{'7'}</a><br>
<a href="$cgi&action=modmemgr">$txt{'8'}</a><br>
<a href="$cgi&action=setcensor">$txt{'135'}</a><br>
<form action="$cgi&action=removeoldthreads" method="POST">
<b>$txt{'124'}</b> <input type=text name="maxdays" size=2 value="$maxdays">
<input type=submit value="$txt{'31'}">
</form>
</td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub ViewMembers {
	# Only allow Adminstrators to access the admin
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	# Load member list
	open(FILE, "$memberdir/memberlist.txt");
	&lock(FILE);
	@memberlist = <FILE>;
	&unlock(FILE);
	close(FILE);
	$title = "$txt{'9'}";
	&header;
	print <<"EOT";
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'9'}</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}"><ul>
EOT
	foreach $curmem (@memberlist) {
		$curmem =~ s/\n//g;
		$curmem =~ s/\r//g;
		print "<li><a href=\"$cgi\&action=viewprofile\&username=$curmem\">$curmem</a>";
	}
	print <<"EOT";
</ul></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub MailingList {
	# Only allow Adminstrators to access the admin
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	open(FILE, "$memberdir/memberlist.txt");
	&lock(FILE);
	@memberlist = <FILE>;
	&unlock(FILE);
	close(FILE);
	$title = "$txt{'6'}";
	&header;
	print <<"EOT";
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'6'}</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}"><form><textarea cols=60 rows=6>
EOT
	foreach $curmem (@memberlist) {
		$curmem =~ s/\n//g;
		$curmem =~ s/\n//g;
		open(FILE, "$memberdir/$curmem.dat");
		&lock(FILE);
		@settings = <FILE>;
		&unlock(FILE);
		close(FILE);
		$email = "$settings[2]";
		$email =~ s/\n//g;
		$email =~ s/\r//g;
		print "$email\;";
	}
	print <<"EOT";
</textarea></form></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub EditNews {
	# Only allow Adminstrators to access the admin
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	open(FILE, "$vardir/news.txt");
	&lock(FILE);
	@newsitems = <FILE>;
	&unlock(FILE);
	close(FILE);
	$title = "$txt{'7'}";
	&header;
	print <<"EOT";
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'7'}</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}"><p><form action="$cgi&action=editnews2" method="POST">
	<textarea cols=60 rows=6 name="news" style="width:100%">
EOT
	foreach $curnews (@newsitems) {
		$curnews =~ s/\n//g;
		$curnews =~ s/\r//g;
		print "$curnews\n";
	}
	print <<"EOT";
</textarea><br><input type=submit value="$txt{'10'}"></form></p></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub EditNews2 {
	# Only allow Adminstrators to access the admin
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	open(FILE, ">$vardir/news.txt");
	&lock(FILE);
	print FILE "$FORM{'news'}";
	&unlock(FILE);
	close(FILE);
	print "Location: $cgi\&action=admin\n\n";
	exit;
}

sub EditMemberGroups {
	# Only allow Adminstrators to access the admin
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	open(FILE, "$vardir/membergroups.txt");
	&lock(FILE);
	@lines = <FILE>;
	&unlock(FILE);
	close(FILE);
	$title = "$txt{'8'}";
	$rest="";
	foreach $curl (@lines) {
		if($curl ne "$lines[0]" && $curl ne "$lines[1]" && $curl ne "$lines[2]" && $curl ne "$lines[3]" && $curl ne "$lines[4]") {
			$rest="$rest$curl";
		}
	}
	$lines[0] =~ s/\n//g;
	$lines[1] =~ s/\n//g;
	$lines[2] =~ s/\n//g;
	$lines[3] =~ s/\n//g;
	$lines[4] =~ s/\n//g;
	$lines[0] =~ s/\r//g;
	$lines[1] =~ s/\r//g;
	$lines[2] =~ s/\r//g;
	$lines[3] =~ s/\r//g;
	$lines[4] =~ s/\r//g;
	&header;
	print <<"EOT";
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'8'}</font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}">
<form action="$cgi&action=modmemgr2" method="POST">
<table border=0>
<tr>
	<td><p><b>$txt{'11'}:</b></td>
	<td><input type=text name="admin" size=30 value="$lines[0]"></td>
</tr>
<tr>
	<td><b>$txt{'12'}:</b></td>
	<td><input type=text name="moderator" size=30 value="$lines[1]"></td>
</tr>
<tr>
	<td><b>$txt{'13'}</b></td>
	<td><input type=text name="junior" size=30 value="$lines[2]"></td>
</tr>
<tr>
	<td><b>$txt{'14'}:</b></td>
	<td><input type=text name="full" size=30 value="$lines[3]"></td>
</tr>
<tr>
	<td><b>$txt{'15'}:</b></td>
	<td><input type=text name="senior" size=30 value="$lines[4]"></td>
</tr>
</table>
<b>$txt{'16'}:</b><br>
<textarea name="additional" cols=30 rows=5>$rest</textarea><br>
<input type=submit value="$txt{'17'}">
</form></p></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub EditMemberGroups2 {
	# Only allow Adminstrators to access the admin
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	open(FILE, ">$vardir/membergroups.txt");
	&lock(FILE);
	print FILE "$FORM{'admin'}\n";
	print FILE "$FORM{'moderator'}\n";
	print FILE "$FORM{'junior'}\n";
	print FILE "$FORM{'full'}\n";
	print FILE "$FORM{'senior'}\n";
	print FILE "$FORM{'additional'}";
	&unlock(FILE);
	close(FILE);
	print "Location: $cgi\&action=admin\n\n";
	exit;
}

sub SetCensor {
	# Only allow Adminstrators to access the admin
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	open(FILE, "$vardir/censor.txt");
	&lock(FILE);
	@censored = <FILE>;
	&unlock(FILE);
	close(FILE);
	$title = "$txt{'135'}";
	&header;
	print <<"EOT";
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'135'}</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}"><form action="$cgi&action=setcensor2" method="POST">
$txt{'136'}<br>
	<textarea cols=60 rows=6 name="censored" style="width:100%">
EOT
	foreach $cur (@censored) {
		print "$cur";
	}
	print <<"EOT";
</textarea><br><input type=submit value="$txt{'10'}"></form></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub SetCensor2 {
	# Only allow Adminstrators to access the admin
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	open(FILE, ">$vardir/censor.txt");
	&lock(FILE);
	print FILE "$FORM{'censored'}";
	&unlock(FILE);
	close(FILE);
	print "Location: $cgi\&action=admin\n\n";
	exit;
}

1;