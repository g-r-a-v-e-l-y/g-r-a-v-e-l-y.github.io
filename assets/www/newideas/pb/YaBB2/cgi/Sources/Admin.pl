###############################################################################
# Admin.pl                                                                    #
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

$adminplver="1 Gold Beta4";

sub Admin {
	&is_admin;
	$yytitle = "$txt{'2'}";
	# Load data for the 'remove old messages' feature
	open(FILE, "$vardir/oldestmes.txt");
	&lock(FILE);
	$maxdays = <FILE>;
	&unlock(FILE);
	close(FILE);
	# Open the file with all categories
	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	$yytitle = "$txt{'208'}";
	open(FILE, "$memberdir/memberlist.txt");
	&lock(FILE);
	@memberlist = <FILE>;
	&unlock(FILE);
	$memcount = @memberlist;
	close(FILE);
	# First we're going to count how many threads and messages are posted
	$totalm=0;
	$totalt=0;
       	foreach $curcat (@categories) {
		$curcat =~ s/\n//g;
		$curcat =~ s/\r//g;
		open(CAT, "$boardsdir/$curcat.cat");
		&lock(CAT);
		@catinfo = <CAT>;
		&unlock(CAT);
		close(CAT);
		$catinfo[1] =~ s/\n//g;
		$catinfo[1] =~ s/\r//g;
		if($catinfo[1] ne "") {
			if($settings[7] ne "Administrator" && $settings[7] ne "$catinfo[1]") { next; }
		}
		$curcatname="$catinfo[0]";
		foreach $curboard (@catinfo) {
			if($curboard ne "$catinfo[0]" && $curboard ne "$catinfo[1]") {
				$curboard =~ s/\n//g;
				$curboard =~ s/\r//g;
				open(BOARDDATA, "$boardsdir/$curboard.txt");
				&lock(BOARDDATA);
				@messages = <BOARDDATA>;
				&unlock(BOARDDATA);
				close(BOARDDATA);
				$tm = @messages;
				($dummy, $dummy, $dummy, $dummy, $lp) = split(/\|/, $messages[0]);
				$boardinfo[2] =~ s/\n//g;
				$boardinfo[2] =~ s/\r//g;
				$messagecount=0;
				for ($a = 0; $a < @messages; $a++) {
					($dm,$dm,$dm,$dm,$dm,$mreplies,$dm) = split(/\|/,$messages[$a]);
					$messagecount++;
					$messagecount=$messagecount+$mreplies;
				}
				if($lp eq "") { $lp="N/A"; }
				$totalm=$totalm+$messagecount;
				$totalt=$totalt+$tm;
	                	$avgtop=$totalt/$memcount;
	                	$avgmsg=$totalm/$memcount;
			}
		}
	}

	&header;
	print <<"EOT";
<table width="90%" class="adminheadertable" align="center">
  <tr>
    <td width="350" bgcolor="$color{'titlebg'}" height="23">
      <p align="center"><font size="4" color="$color{'titletext'}">$txt{'424'}</font></td>
    <td width="6" bgcolor="$color{'titlebg'}" height="23">&nbsp;</td>
    <td width="460" bgcolor="$color{'titlebg'}" height="23">
      <p align="center"><font size="4" color="$color{'titletext'}">$txt{'208'}</font></td>
  </tr>
  <tr>
    <td width="350" height="21"></td>
    <td rowspan="15" width="6"></td>
    <td rowspan="15" width="639">
      <p align="center"><font size="2">Welcome $settings[1] ($username)</p>
      <table border="0" cellpadding="0" cellspacing="0" width="75%">
	<tr>
	  <td width="45%"><font size="2">$txt{'488'}</td>
	  <td width="55%"><font size="2">$memcount</td>
	</tr>
	<tr>
	  <td width="45%"><font size="2">$txt{'489'}</td>
	  <td width="55%"><font size="2">$totalm</td>
	</tr>
	<tr>
	  <td width="45%"><font size="2">$txt{'490'}</td>
	  <td width="55%"><font size="2">$totalt</td>
	</tr>
      </table>
	<p><form action="$cgi&action=removeoldthreads" method="POST">
	<font size="2">$txt{'124'} <input type=text name="maxdays" size=2 value="$maxdays">
	<input type=submit value="$txt{'31'}"></form>
      <table border="0" cellpadding="0" cellspacing="0" width="95%">
	<tr>
	  <td width="50%"><font size="2">$txt{'425'}:</font></td>
	  <td width="50%"><font size="1">$YaBBversion</font>/<img src="http://www.yabb.org/versioncheck.gif"></td>
	</tr>
      </table>
      <p><font size="2">Credits:
      <BR><font size="2"><i>This Release:</i> Ze0|ntrus, plushpuffin, Popeye, [CV]XXL, DaveB, DaveG, CareyP, Taren, and the rest :)</font>
      <BR><font size="2"><i>YaBB 1 Final:</i> Zef Hemel, Jeff Lewis, Christian Land, Ze0, Peter Crouch and a bunch of others we want to thank!</font
      </td>
  </tr>
  <tr>
    <td width="400" bgcolor="$color{'windowbg'}" height="21"><font size="3">$txt{'426'}</td>
  </tr>
  <tr>
    <td width="400" bgcolor="$color{'windowbg2'}" height="21"><font size="2"><a href="$cgi&action=viewmembers">$txt{'5'}</a><br>
    <a href="$cgi&action=modmemgr">$txt{'8'}</a><br>
    <a href="$cgi&action=mailing">$txt{'6'}</a><br>
    <a href="$cgi&action=ipban">$txt{'206'}</a><br>
    <a href="$cgi&action=setreserve">$txt{'207'}</a><br><br>
    </td>
  </tr>
  <tr>
    <td width="400" bgcolor="$color{'windowbg'}" height="21"><font size="3">$txt{'427'}</td>
  </tr>
  <tr>
    <td width="400" bgcolor="$color{'windowbg2'}" height="21"><font size="2"><a href="$cgi&action=managecats">$txt{'3'}</a><br>
    <a href="$cgi&action=manageboards">$txt{'4'}</a><br>
    <a href="$cgi&action=modtemp">$txt{'216'}</a><BR>
    <a href="$cgi&action=modsettings">$txt{'222'}</a><BR><br>
    </td>
  </tr>
  <tr>
    <td width="400" bgcolor="$color{'windowbg'}" height="1"><font size="3">$txt{'428'}</td>
  </tr>
  <tr>
    <td width="400" bgcolor="$color{'windowbg2'}" height="21"><font size="2"><a href="$cgi&action=editnews">$txt{'7'}</a><br>
    <a href="$cgi&action=setcensor">$txt{'135'}</a><br>
    <a href="$cgi&action=clean_log">$txt{'202'}</a><br>
    <a href="$cgi&action=detailedversion">$txt{'429'}</a><br><br>
    </td>
  </tr>
  <tr>
    <td width="400" bgcolor="$color{'windowbg'}" height="1"><font size="3">$txt{'501'}</td>
  </tr>
  <tr>
    <td width="400" bgcolor="$color{'windowbg2'}" height="21"><font size="2"><a href="$cgi&action=boardrecount">$txt{'502'}</a><br>
    </td>
  </tr>
  <tr>
    <td width="400" bgcolor="$color{'windowbg2'}" height="21"><font size="2"><a href="$cgi&action=membershiprecount">$txt{'504'}</a><br>
    </td>
  </tr>
  <tr>
    <td width="234" bgcolor="$color{'windowsbg2'}" height="21"><font size="2">&nbsp;</font></td>
  </tr>
</table>
EOT

	&footer;
	exit;
}


sub AdminMembershipRecount {
	&is_admin;
	$yytitle = $txt{'504'};
	&header;
	&MembershipCountTotal;
	print qq~$txt{'505'}~;
	&footer;
	exit;
}

sub AdminBoardRecount {
	&is_admin;
	$yytitle = $txt{'502'};
	my( $curcat, $curcatname, $curcataccess );
	my( @categories, @catboards );
	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	foreach $curcat (@categories) {
		chomp $curcat;
		open(FILE, "$boardsdir/$curcat.cat");
		&lock(FILE);
		chomp( $curcatname = <FILE> );
		chomp( $curcataccess = <FILE> );
		@catboards = <FILE>;
		&unlock(FILE);
		close(FILE);
		foreach (@catboards) {
			chomp;
			&BoardCountTotals($_);
		}
	}
	&header;
	print qq~$txt{'503'}~;
	&footer;
	exit;
}

sub ViewMembers {
	&is_admin;
	# Load member list
	open(FILE, "$memberdir/memberlist.txt");
	&lock(FILE);
	@memberlist = <FILE>;
	&unlock(FILE);
	close(FILE);
	$yytitle = "$txt{'9'}";
	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'9'}</font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}"><font size=2><ul>
EOT
	foreach $curmem (@memberlist) {
		$curmem =~ s/[\n\r]//g;
		print "<li><a href=\"$cgi\&action=viewprofile\&username=$curmem\">$curmem</a>";
	}
	print <<"EOT";
</ul></font></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub MailingList {
	&is_admin;
	open(FILE, "$memberdir/memberlist.txt");
	&lock(FILE);
	@memberlist = <FILE>;
	&unlock(FILE);
	close(FILE);
	$yytitle = "$txt{'6'}";
	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'6'}</font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}"><font size=2><form><textarea cols=60 rows=6>
EOT
	foreach $curmem (@memberlist) {
		$curmem =~ s/[\n\r]//g;
		open(FILE, "$memberdir/$curmem.dat");
		&lock(FILE);
		@settings = <FILE>;
		&unlock(FILE);
		close(FILE);
		$email = "$settings[2]";
		$email =~ s/[\n\r]//g;
		print "$email\;";
	}
	print <<"EOT";
</textarea></form></font></td>
</tr>
<tr>
	<td bgcolor="$color{'titlebg'}"><font size=2 color="$color{'titletext'}">$txt{'338'}</font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}"><font size=2>
<form action="$cgi&action=ml" method="POST">
<input type=text name="subject" size=30 value="Subject"><br><br>
<textarea cols=60 rows=6 name=message>
Message
</textarea><br><br>
<input type=submit value="$txt{'339'}">
</form></font></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub ml {
	open(FILE, "$memberdir/memberlist.txt");
	&lock(FILE);
	@memberlist = <FILE>;
	&unlock(FILE);
	close(FILE);
foreach $curmem (@memberlist) {
	$curmem =~ s/\n//g;
	open(FILE, "$memberdir/$curmem.dat");
	&lock(FILE);
	@settings = <FILE>;
	&unlock(FILE);
	close(FILE);
	$email = "$settings[2]";
	$email =~ s/\n//g;
	$pass = "$settings[0]";
	$pass =~ s/\n//g;
	$name = "$curmem";
	$name =~ s/\n//g;

open (MAIL, "|$mailprog -t");
print MAIL "To: $email\n";
print MAIL "From: $webmaster_email\n";
print MAIL "Subject: $FORM{'subject'}\n";
print MAIL <<"EOT";

$FORM{'message'}

$txt{'491'} $name $txt{'492'} $pass

EOT
	close MAIL;

}
	print "Location: $cgi\&action=admin\n\n";
	exit;
}

sub EditNews {
	&is_admin;
	open(FILE, "$vardir/news.txt");
	&lock(FILE);
	@newsitems = <FILE>;
	&unlock(FILE);
	close(FILE);
	$yytitle = "$txt{'7'}";
	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'7'}</font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}"><font size=2><form action="$cgi&action=editnews2" method="POST">
	<textarea cols=60 rows=6 name="news" style="width:100%">
EOT
	foreach $curnews (@newsitems) {
		$curnews =~ s/[\n\r]//g;
		print "$curnews\n";
	}
	print <<"EOT";
</textarea><br><input type=submit value="$txt{'10'}"></form></font></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub EditNews2 {
	&is_admin;
	open(FILE, ">$vardir/news.txt");
	&lock(FILE);
	print FILE "$FORM{'news'}";
	&unlock(FILE);
	close(FILE);
	print "Location: $cgi\&action=admin\n\n";
	exit;
}

sub EditMemberGroups {
	&is_admin;
	open(FILE, "$vardir/membergroups.txt");
	&lock(FILE);
	@lines = <FILE>;
	&unlock(FILE);
	close(FILE);
	$yytitle = "$txt{'8'}";
	$rest="";
	foreach $curl (@lines) {
		if($curl ne "$lines[0]" && $curl ne "$lines[1]" && $curl ne "$lines[2]" && $curl ne "$lines[3]" && $curl ne "$lines[4]") {
			$rest="$rest$curl";
		}
	}
	$lines[0] =~ s/[\n\r]//g;
	$lines[1] =~ s/[\n\r]//g;
	$lines[2] =~ s/[\n\r]//g;
	$lines[3] =~ s/[\n\r]//g;
	$lines[4] =~ s/[\n\r]//g;
	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'8'}</font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}"><font size=2>
<form action="$cgi&action=modmemgr2" method="POST">
<table border=0>
<tr>
	<td><font size=2>$txt{'11'}:</font></td>
	<td><input type=text name="admin" size=30 value="$lines[0]"></td>
</tr>
<tr>
	<td><font size=2>$txt{'12'}:</font></td>
	<td><input type=text name="moderator" size=30 value="$lines[1]"></td>
</tr>
<tr>
	<td><font size=2>$txt{'13'}</font></td>
	<td><input type=text name="junior" size=30 value="$lines[2]"></td>
</tr>
<tr>
	<td><font size=2>$txt{'14'}:</font></td>
	<td><input type=text name="full" size=30 value="$lines[3]"></td>
</tr>
<tr>
	<td><font size=2>$txt{'15'}:</font></td>
	<td><input type=text name="senior" size=30 value="$lines[4]"></td>
</tr>
</table>
$txt{'16'}:<br>
<textarea name="additional" cols=30 rows=5>$rest</textarea><br>
<input type=submit value="$txt{'17'}">
</form></font></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub EditMemberGroups2 {
	&is_admin;
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
	&is_admin;
	open(FILE, "$vardir/censor.txt");
	&lock(FILE);
	@censored = <FILE>;
	&unlock(FILE);
	close(FILE);
	$yytitle = "$txt{'135'}";
	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'135'}</font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}"><font size=2><form action="$cgi&action=setcensor2" method="POST">
$txt{'136'}<br>
	<textarea cols=60 rows=6 name="censored" style="width:100%">
EOT
	foreach $cur (@censored) {
		print "$cur";
	}
	print <<"EOT";
</textarea><br><input type=submit value="$txt{'10'}"></form></font></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub SetCensor2 {
	&is_admin;
	open(FILE, ">$vardir/censor.txt");
	&lock(FILE);
	print FILE "$FORM{'censored'}";
	&unlock(FILE);
	close(FILE);
	print "Location: $cgi\&action=admin\n\n";
	exit;
}

sub clean_log {
	&is_admin;
	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'2'}</font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}"><font size=2>$txt{'203'}
<a href="$cgi&action=do_clean_log">$txt{'163'}</a>&nbsp;&nbsp;<a href="$cgi">$txt{'164'}</a><br>
</font></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub do_clean_log {
	&is_admin;
	# Overwrite with a blank file
	open (FILE, ">$vardir/log.txt");
	print FILE "";
	close FILE;
	goto &Admin;
	exit;
}
sub ipban {
	&is_admin;
	open(FILE, "$vardir/ban.txt");
	&lock(FILE);
	@ipban = <FILE>;
	&unlock(FILE);
	close(FILE);
	$yytitle = "$txt{'340'}";
	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=1 cellpadding=4>
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'340'}</font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}"><font size=2><form action="$cgi&action=ipban2" method="POST">
	<textarea cols=60 rows=6 name="ban" style="width:100%">
EOT
	foreach $curban (@ipban) {
		$curban =~ s/\n//g;
		print "$curban\n";
	}
	print <<"EOT";
</textarea><br><input type=submit value="$txt{'10'}"></form></font></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub ipban2 {
	&is_admin;
	open(FILE, ">$vardir/ban.txt");
	&lock(FILE);
	print FILE "$FORM{'ban'}";
	&unlock(FILE);
	close(FILE);
	print "Location: $cgi\&action=admin\n\n";
	exit;
}

# Build 10

sub SetReserve {
	&is_admin;
	open(FILE, "$vardir/reserve.txt") || open(FILE, ">$vardir/reserve.txt");
	&lock(FILE);
	@reserved = <FILE>;
	&unlock(FILE);
	close(FILE);
	open(FILE, "$vardir/reservecfg.txt") || open(FILE, ">$vardir/reservecfg.txt");
	&lock(FILE);
	@reservecfg = <FILE>;
	&unlock(FILE);
	close(FILE);
	$yytitle = "$txt{'341'}";
	$reservecfg[0] =~ s/\n//g;
	$reservecfg[1] =~ s/\n//g;
	$reservecfg[2] =~ s/\n//g;
	$reservecfg[3] =~ s/\n//g;
	$reservecfg[0] =~ s/\r//g;
	$reservecfg[1] =~ s/\r//g;
	$reservecfg[2] =~ s/\r//g;
	$reservecfg[3] =~ s/\r//g;

	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
	<td bgcolor="$color{'titlebg'}"><font size=2 color="$color{'titletext'}">$txt{'341'}</font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}"><font size=2><form action="$cgi&action=setreserve2" method="POST">$txt{'342'}<br>
	<textarea cols=60 rows=6 name="reserved" style="width:100%">
EOT
	foreach $cur (@reserved) {
		print "$cur";
	}
	print <<"EOT";
	</textarea><br>
	<font size=2><input type=checkbox name="matchword" value="checked" $reservecfg[0]></font>
	<font size=2>$txt{'343'}</font><br>
	<font size=2><input type=checkbox name="matchcase" value="checked" $reservecfg[1]></font>
	<font size=2>$txt{'344'}</font><br>
	<font size=2><input type=checkbox name="matchuser" value="checked" $reservecfg[2]></font>
	<font size=2>$txt{'345'}</font><br>
	<font size=2><input type=checkbox name="matchname" value="checked" $reservecfg[3]></font>
	<font size=2>$txt{'346'}</font><br>
	<input type=submit value="$txt{'10'}"></form></font></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub SetReserve2 {
	&is_admin;
	open(FILE, ">$vardir/reserve.txt");
	&lock(FILE);
	print FILE "$FORM{'reserved'}";
	&unlock(FILE);
	close(FILE);
	open(FILE, ">$vardir/reservecfg.txt");
	&lock(FILE);
	print FILE "$FORM{'matchword'}\n";
	print FILE "$FORM{'matchcase'}\n";
	print FILE "$FORM{'matchuser'}\n";
	print FILE "$FORM{'matchname'}\n";
	&unlock(FILE);
	close(FILE);
	print "Location: $cgi\&action=admin\n\n";
	exit;
}

sub ModifyTemplate {
	&is_admin;
	open(FILE, "$boarddir/template.html");
	&lock(FILE);
	@template = <FILE>;
	&unlock(FILE);
	close(FILE);
	$fulltemplate = join( "", @template );
	$yytitle = "$txt{'216'}";
	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'216'}</font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}"><font size=2><form action="$cgi&action=modtemp2" method="POST">
	<textarea rows=30 cols=95 wrap=virtual name="template" style="width:100%">$fulltemplate</textarea>
<br><input type=submit value="$txt{'10'}"></form></font></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub ModifyTemplate2 {
	&is_admin;
	open(FILE, ">$boarddir/template.html");
	&lock(FILE);
	print FILE "$FORM{'template'}";
	&unlock(FILE);
	close(FILE);
	print "Location: $cgi\&action=admin\n\n";
	exit;
}

sub ver_detail {
	&loadfiles;
	&is_admin;
	$yytitle = "$txt{'429'}";
	&header;
	print <<"EOT";
<table border=0 width="70%" cellspacing=1 bgcolor="#000000" align="center">
<tr>
	<td bgcolor="$color{'titlebg'}"><font size=2 color="$color{'titletext'}">$txt{'2'}</font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}"><font size=2><center>$txt{'429'}
<P>
<table border=0 bgcolor="#dbdbdb">

<tr><td width="30%"><font size=2>$txt{'495'}</td><td><font size=2>$txt{'494'}</td><td><font size=2>$txt{'493'}</td></tr>

<tr><td width="30%"><font size=2>$txt{'496'}</td><td><font size=2>$YaBBversion</td><td><img src="http://www.yabb.org/versioninfo/versioncheck.gif"></td></tr>

<tr><td width="30%"><font size=2>YaBB.pl</td><td><font size=2>$YaBBplver</td><td><img src="http://www.yabb.org/versioninfo/yabbplver.gif"></td></tr>

<tr><td width="30%"><font size=2>Admin.pl</td><td><font size=2>$adminplver</td><td><img src="http://www.yabb.org/versioninfo/adminplver.gif"></td></tr>

<tr><td width="30%"><font size=2>BoardIndex.pl</td><td><font size=2>$boardindexplver</td><td><img src="http://www.yabb.org/versioninfo/boardindexplver.gif"></td></tr>

<tr><td width="30%"><font size=2>Display.pl</td><td><font size=2>$displayplver</td><td><img src="http://www.yabb.org/versioninfo/displayplver.gif"></td></tr>

<tr><td width="30%"><font size=2>ICQPager.pl</td><td><font size=2>$icqpagerplver</td><td><img src="http://www.yabb.org/versioninfo/icqpagerplver.gif"></td></tr>

<tr><td width="30%"><font size=2>InstantMessage.pl</td><td><font size=2>$instantmessageplver</td><td><img src="http://www.yabb.org/versioninfo/instantmessageplver.gif"></td></tr>

<tr><td width="30%"><font size=2>Load.pl</td><td><font size=2>$loadplver</td><td><img src="http://www.yabb.org/versioninfo/loadplver.gif"></td></tr>

<tr><td width="30%"><font size=2>LockThread.pl</td><td><font size=2>$lockthreadplver</td><td><img src="http://www.yabb.org/versioninfo/lockthreadplver.gif"></td></tr>

<tr><td width="30%"><font size=2>LogInOut.pl</td><td><font size=2>$loginoutplver</td><td><img src="http://www.yabb.org/versioninfo/loginoutplver.gif"></td></tr>

<tr><td width="30%"><font size=2>Maintenance.pl</td><td><font size=2>$maintenanceplver</td><td><img src="http://www.yabb.org/versioninfo/maintenanceplver.gif"></td></tr>

<tr><td width="30%"><font size=2>ManageBoards.pl</td><td><font size=2>$manageboardsplver</td><td><img src="http://www.yabb.org/versioninfo/manageboardsplver.gif"></td></tr>

<tr><td width="30%"><font size=2>ManageCats.pl</td><td><font size=2>$managecatsplver</td><td><img src="http://www.yabb.org/versioninfo/managecatsplver.gif"></td></tr>

<tr><td width="30%"><font size=2>Memberlist.pl</td><td><font size=2>$memberlistplver</td><td><img src="http://www.yabb.org/versioninfo/memberlistplver.gif"></td></tr>

<tr><td width="30%"><font size=2>MessageIndex.pl</td><td><font size=2>$messageindexplver</td><td><img src="http://www.yabb.org/versioninfo/messageindexplver.gif"></td></tr>

<tr><td width="30%"><font size=2>ModifyMessage.pl</td><td><font size=2>$modifymessageplver</td><td><img src="http://www.yabb.org/versioninfo/modifymessageplver.gif"></td></tr>

<tr><td width="30%"><font size=2>MoveThread.pl</td><td><font size=2>$movethreadplver</td><td><img src="http://www.yabb.org/versioninfo/movethreadplver.gif"></td></tr>

<tr><td width="30%"><font size=2>Notify.pl</td><td><font size=2>$notifyplver</td><td><img src="http://www.yabb.org/versioninfo/notifyplver.gif"></td></tr>

<tr><td width="30%"><font size=2>Post.pl</td><td><font size=2>$postplver</td><td><img src="http://www.yabb.org/versioninfo/postplver.gif"></td></tr>

<tr><td width="30%"><font size=2>Profile.pl</td><td><font size=2>$profileplver</td><td><img src="http://www.yabb.org/versioninfo/profileplver.gif"></td></tr>

<tr><td width="30%"><font size=2>Recent.pl</td><td><font size=2>$recentplver</td><td><img src="http://www.yabb.org/versioninfo/recentplver.gif"></td></tr>

<tr><td width="30%"><font size=2>Register.pl</td><td><font size=2>$registerplver</td><td><img src="http://www.yabb.org/versioninfo/registerplver.gif"></td></tr>

<tr><td width="30%"><font size=2>RemoveOldThreads.pl</td><td><font size=2>$removeoldthreadsplver</td><td><img src="http://www.yabb.org/versioninfo/removeoldthreadsplver.gif"></td></tr>

<tr><td width="30%"><font size=2>RemoveThread.pl</td><td><font size=2>$removethreadplver</td><td><img src="http://www.yabb.org/versioninfo/removethreadplver.gif"></td></tr>

<tr><td width="30%"><font size=2>Search.pl</td><td><font size=2>$searchplver</td><td><img src="http://www.yabb.org/versioninfo/searchplver.gif"></td></tr>

<tr><td width="30%"><font size=2>Security.pl</td><td><font size=2>$securityplver</td><td><img src="http://www.yabb.org/versioninfo/securityplver.gif"></td></tr>

<tr><td width="30%"><font size=2>Subs.pl</td><td><font size=2>$subsplver</td><td><img src="http://www.yabb.org/versioninfo/subsplver.gif"></td></tr>

</table>
</font></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub ModifySettings {
	&is_admin;
	$yytitle = "$txt{'222'}";
	&header;
	print <<"EOT";
<table border=0 width=75% cellspacing=1 bgcolor="$color{'bordercolor'}" align="center">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}" colspan=2><font size=2 class="text1" color="$color{'titletext'}">$txt{'222'}</font></td>
</tr>
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}" colspan=2><font size=2 class="text1" color="$color{'titletext'}"><i>$txt{'347'}</font></td>
</tr>
<form action="$cgi&action=modsettings2" method="POST">
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'348'}</font></td>
EOT
$checked = "";
if ($maintenance == 1) { $checked = "checked" }
print <<"EOT";
	<td class="form2" bgcolor="$color{'windowbg2'}" width="50"><input type=checkbox name="maintenance" $checked></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'349'}</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><select name="language">
EOT
opendir(DIR, "$boarddir") || die "$txt{'230'} ($boarddir) :: $!";
@contents = readdir(DIR);
closedir(DIR);
foreach $line (@contents){
	($name, $extension) = split (/\./, $line);
	if ($extension eq "lng"){
		$selected = "";
		if ($line eq $language) { $selected = " selected" }
		print "    <option value=\"$line\"$selected>$name\n";
	}
}
print <<"EOT";
</select></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'350'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="mbname" size="20" value="$mbname"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'351'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="boardurl" size="35" value="$boardurl"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'432'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="cookielength" size="20" value="$Cookie_Length"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'352'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="cookieusername" size="20" value="$cookieusername"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'353'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="cookiepassword" size="20" value="$cookiepassword"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'354'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="mailprog" size="20" value="$mailprog"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'407'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="smtp_server" size="20" value="$smtp_server"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'404'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}">
EOT
$checked = "";
if ($mailtype == 0) { $mts1 = " selected"; } elsif ($mailtype == 1) { $mts2 = " selected"; }
print <<"EOT";
<select name="mailtype" size=1>
<option value="0"$mts1>$txt{'405'}
<option value="1"$mts2>$txt{'406'}
</select></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'355'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="webmaster_email" size="20" value="$webmaster_email"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'408'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="timeout" size="3" value="$timeout"></td>
</tr>
<tr>
	<td colspan=2><HR size=1 noshade width=100%></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'356'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="boarddir" size="20" value="$boarddir"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'357'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="datadir" size="20" value="$datadir"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'358'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="memberdir" size="20" value="$memberdir"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'359'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="boardsdir" size="20" value="$boardsdir"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'360'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="sourcedir" size="20" value="$sourcedir"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'361'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="vardir" size="20" value="$vardir"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'423'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="facesurl" size="35" value="$facesurl"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'362'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="facesdir" size="35" value="$facesdir"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'363'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="imagesdir" size="35" value="$imagesdir"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'364'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="helpfile" size="35" value="$helpfile"></td>
</tr>
<tr>
	<td colspan=2><HR size=1 noshade width=100%></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'365'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="titlebg" size="20" value="$color{'titlebg'}"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'366'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="titletext" size="20" value="$color{'titletext'}"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'367'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="windowbg" size="20" value="$color{'windowbg'}"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'368'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="windowbg2" size="20" value="$color{'windowbg2'}"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'369'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="catbg" size="20" value="$color{'catbg'}"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'370'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="bordercolor" size="20" value="$color{'bordercolor'}"></td>
</tr>
<tr>
	<td colspan=2><HR size=1 noshade width=100%></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">Use text menu instead of images?</font></td>
EOT
$checked = "";
if ($MenuType == 1) { $checked = "checked" }
print <<"EOT";
	<td class="form2" bgcolor="$color{'windowbg2'}" width="50"><input type=checkbox name="menutype" $checked></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'479'}</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}" width="50">
EOT
if ($timeselected == 6) { $tsl6 = " selected" } elsif ($timeselected == 5) { $tsl5 = " selected" } elsif ($timeselected == 4) { $tsl4 = " selected" } elsif ($timeselected == 3) { $tsl3 = " selected" } elsif ($timeselected == 2) { $tsl2 = " selected" } else { $tsl1 = " selected" }
print <<"EOT";
		<select name="timeselect" size=1>
	         <option value="1"$tsl1>$txt{'480'}
	         <option value="5"$tsl4>$txt{'484'}
	         <option value="4"$tsl4>$txt{'483'}
	         <option value="2"$tsl2>$txt{'481'}
	         <option value="3"$tsl3>$txt{'482'}
	         <option value="6"$tsl3>$txt{'485'}
		</select>
	</td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'371'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="timeoffset" size="10" value="$timeoffset"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'372'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="TopAmmount" size="10" value="$TopAmmount"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'373'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="MembersPerPage" size="10" value="$MembersPerPage"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'374'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="maxdisplay" size="10" value="$maxdisplay"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'375'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="maxmessagedisplay" size="10" value="$maxmessagedisplay"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'376'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="max_log_days_old" size="10" value="$max_log_days_old"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'498'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="maxmesslen" size="10" value="$MaxMessLen"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'377'}</font></td>
EOT
$checked = "";
if ($insert_original == 1) { $checked = "checked" }
print <<"EOT";
	<td class="form2" bgcolor="$color{'windowbg2'}" width="50"><input type=checkbox name="insert_original" $checked></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'378'}</font></td>
EOT
$checked = "";
if ($enable_ubbc == 1) { $checked = "checked" }
print <<"EOT";
	<td class="form2" bgcolor="$color{'windowbg2'}" width="50"><input type=checkbox name="enable_ubbc" $checked></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'379'}</font></td>
EOT
$checked = "";
if ($enable_news == 1) { $checked = "checked" }
print <<"EOT";
	<td class="form2" bgcolor="$color{'windowbg2'}" width="50"><input type=checkbox name="enable_news" $checked></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'380'}</font></td>
EOT
$checked = "";
if ($enable_guestposting == 1) { $checked = "checked" }
print <<"EOT";
	<td class="form2" bgcolor="$color{'windowbg2'}" width="50"><input type=checkbox name="enable_guestposting" $checked></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'381'}</font></td>
EOT
$checked = "";
if ($enable_notification == 1) { $checked = "checked" }
print <<"EOT";
	<td class="form2" bgcolor="$color{'windowbg2'}" width="50"><input type=checkbox name="enable_notification" $checked></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'382'}</font></td>
EOT
$checked = "";
if ($showlatestmember == 1) { $checked = "checked" }
print <<"EOT";
	<td class="form2" bgcolor="$color{'windowbg2'}" width="50"><input type=checkbox name="showlatestmember" $checked></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'509'}</font></td>
EOT
$checked = "";
if ($Show_RecentBar == 1) { $checked = "checked" }
print <<"EOT";
	<td class="form2" bgcolor="$color{'windowbg2'}" width="50"><input type=checkbox name="showrecentbar" $checked></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'510'}</font></td>
EOT
$checked = "";
if ($Show_MemberBar == 1) { $checked = "checked" }
print <<"EOT";
	<td class="form2" bgcolor="$color{'windowbg2'}" width="50"><input type=checkbox name="showmemberbar" $checked></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'383'}</font></td>
EOT
$checked = "";
if ($showmodify == 1) { $checked = "checked" }
print <<"EOT";
	<td class="form2" bgcolor="$color{'windowbg2'}" width="50"><input type=checkbox name="showmodify" $checked></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'384'}</font></td>
EOT
$checked = "";
if ($showuserpic == 1) { $checked = "checked" }
print <<"EOT";
	<td class="form2" bgcolor="$color{'windowbg2'}" width="50"><input type=checkbox name="showuserpic" $checked></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'385'}</font></td>
EOT
$checked = "";
if ($showusertext == 1) { $checked = "checked" }
print <<"EOT";
	<td class="form2" bgcolor="$color{'windowbg2'}" width="50"><input type=checkbox name="showusertext" $checked></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'386'}</font></td>
EOT
$checked = "";
if ($showgenderimage == 1) { $checked = "checked" }
print <<"EOT";
	<td class="form2" bgcolor="$color{'windowbg2'}" width="50"><input type=checkbox name="showgenderimage" $checked></td>
</tr>
<tr>
	<td colspan=2><HR size=1 noshade width=100%></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'387'}</font></td>
EOT
$checked = "";
if ($shownewsfader == 1) { $checked = "checked" }
print <<"EOT";
	<td class="form2" bgcolor="$color{'windowbg2'}" width="50"><input type=checkbox name="shownewsfader" $checked></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'388'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="fadertext" size="20" value="$color{'fadertext'}"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'389'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="fadertext2" size="20" value="$color{'fadertext2'}"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'390'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="faderpath" size="35" value="$faderpath"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'506'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="ubbcjspath" size="35" value="$ubbcjspath"></td>
</tr>
<tr>
	<td colspan=2><HR size=1 noshade width=100%></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'476'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="userpic_width" size="10" value="$userpic_width"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'477'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="userpic_height" size="10" value="$userpic_height"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'478'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="userpic_limits" size="30" value="$userpic_limits"></td>
</tr>
<tr>
	<td colspan=2><HR size=1 noshade width=100%></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'391'}</font></td>
EOT
$checked = "";
if ($use_flock == 0) { $fls1 = " selected" } elsif ($use_flock == 1) { $fls2 = " selected" } elsif ($use_flock == 2) { $fls3 = " selected" }
print <<"EOT";
	<td class="form2" bgcolor="$color{'windowbg2'}" width="50"><select name="use_flock" size=1>
<option value="0"$fls1>$txt{'401'}
<option value="1"$fls2>$txt{'402'}
<option value="2"$fls3>$txt{'403'}
</select></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'392'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="LOCK_EX" size="10" value="$LOCK_EX"></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="right"><font class="text1" color="$color{'titletext'}">$txt{'393'}:</font></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><input type=text name="LOCK_UN" size="10" value="$LOCK_UN"></td>
</tr>
<tr>
	<td class="form2" bgcolor="$color{'windowbg2'}" colspan="2" align="center" valign="middle">
	<input type=submit value="$txt{'10'}">
	</td>
</tr>
</table></form>
EOT
	&footer;
	exit;
}

sub ModifySettings2 {
	&is_admin;
	open(FILE, ">$boarddir/Settings.pl");
	&lock(FILE);

	# fix the email address
	$email = $FORM{'webmaster_email'};
	$email =~ s/\@/\\@/gi;

	# Set as 0 or 1 if box was checked or not
	$maint = $FORM{'maintenance'};
	if ($maint eq "on") { $maint = "1" }
	else { $maint = "0" }
	$orig = $FORM{'insert_original'};
	if ($orig eq "on") { $orig = "1" }
	else { $orig = "0" }
	$ubbc = $FORM{'enable_ubbc'};
	if ($ubbc eq "on") { $ubbc = "1" }
	else { $ubbc = "0" }
	$news = $FORM{'enable_news'};
	if ($news eq "on") { $news = "1" }
	else { $news = "0" }
	$guestp = $FORM{'enable_guestposting'};
	if ($guestp eq "on") { $guestp = "1" }
	else { $guestp = "0" }
	$notif = $FORM{'enable_notification'};
	if ($notif eq "on") { $notif = "1" }
	else { $notif = "0" }
	$latest = $FORM{'showlatestmember'};
	if ($latest eq "on") { $latest = "1" }
	else { $latest = "0" }
	$recentbar = $FORM{'showrecentbar'};
	if ($recentbar eq "on") { $recentbar = "1" }
	else { $recentbar = "0" }
	$memberbar = $FORM{'showmemberbar'};
	if ($memberbar eq "on") { $memberbar = "1" }
	else { $memberbar = "0" }
	$modify = $FORM{'showmodify'};
	if ($modify eq "on") { $modify = "1" }
	else { $modify = "0" }
	$pic = $FORM{'showuserpic'};
	if ($pic eq "on") { $pic = "1" }
	else { $pic = "0" }
	$text = $FORM{'showusertext'};
	if ($text eq "on") { $text = "1" }
	else { $text = "0" }
	$gender = $FORM{'showgenderimage'};
	if ($gender eq "on") { $gender = "1" }
	else { $gender = "0" }
	$fader = $FORM{'shownewsfader'};
	if ($fader eq "on") { $fader = "1" }
	else { $fader = "0" }
	$flock = $FORM{'use_flock'};
	$mentype = $FORM{'menutype'};
	if ($mentype eq "on") { $mentype = "1" }
	else { $mentype = "0" }

	# If empty fields are submitted, set them to default-values to save yabb from crashing
	if ($FORM{'timeout'} eq "" || !exists $FORM{'timeout'}) { $FORM{'timeout'} = 0; }
	if ($FORM{'timeoffset'} eq "" || !exists $FORM{'timeoffset'}) { $FORM{'timeoffset'} = 0; }
	if ($FORM{'TopAmmount'} eq "" || !exists $FORM{'TopAmmount'}) { $FORM{'TopAmmount'} = 25; }
	if ($FORM{'MembersPerPage'} eq "" || !exists $FORM{'MembersPerPage'}) { $FORM{'MembersPerPage'} = 20; }
	if ($FORM{'maxdisplay'} eq "" || !exists $FORM{'maxdisplay'}) { $FORM{'maxdisplay'} = 20; }
	if ($FORM{'maxmessagedisplay'} eq "" || !exists $FORM{'maxmessagedisplay'}) { $FORM{'maxmessagedisplay'} = 20; }
	if ($FORM{'max_log_days_old'} eq "" || !exists $FORM{'max_log_days_old'}) { $FORM{'max_log_days_old'} = 21; }
	if ($FORM{'LOCK_EX'} eq "" || !exists $FORM{'LOCK_EX'}) { $FORM{'LOCK_EX'} = 2; }
	if ($FORM{'LOCK_UN'} eq "" || !exists $FORM{'LOCK_UN'}) { $FORM{'LOCK_UN'} = 8; }
	if ($FORM{'cookielength'} eq "" || $FORM{'cookielength'} < 5) { $FORM{'cookielength'} = 60; }
	if ($FORM{'maxmesslen'} eq "" || $FORM{'maxmesslen'} > 5000) { $FORM{'maxmesslen'} = 5000; }

	print FILE qq~###############################################################################
# Settings.pl                                                                 #
###############################################################################
# YaBB: Yet another Bulletin Board                                            #
# Open-Source Project started by Zef Hemel (zef\@zefnet.com)                   #
# Software Version: YaBB 1 Gold - Beta4                                       #
# =========================================================================== #
# Software Distributed by:    www.yabb.org                                    #
# Support, News, Updates at:  www.yabb.org/cgi-bin/support/YaBB.pl            #
# =========================================================================== #
# Copyright (c) 2000-2001 YaBB - All Rights Reserved                          #
# Software by: The YaBB Development Team                                      #
###############################################################################


########## Board Info ##########
# Note: these settings must be properly changed for YaBB to work

\$maintenance = $maint;						# Set to 1 to enable Maintenance mode
\$language = "$FORM{'language'}";                     		# Change to language pack you want to use
\$mbname = "$FORM{'mbname'}";					# The name of your YaBB forum
\$boardurl = "$FORM{'boardurl'}";				# URL of your board's folder (without trailing '/')
\$Cookie_Length = $FORM{'cookielength'};			# Cookies will expire after XX minutes of person logging in (they will be logged out after)
\$cookieusername = "$FORM{'cookieusername'}";			# Name of the username cookie
\$cookiepassword = "$FORM{'cookiepassword'}";			# Name of the password cookie
\$mailprog = "$FORM{'mailprog'}";				# Location of your sendmail program
\$webmaster_email = "$email";					# Your e-mail address
\$smtp_server = "$FORM{'smtp_server'}";				# SMTP-Server
\$mailtype = $FORM{'mailtype'};					# 0 - sendmail, 1 - SMTP
\$timeout = $FORM{'timeout'};					# Minimum time between 2 postings from the same IP


########## Directories/Files ##########
# Note: directories other than \$imagesdir do not have to be changed unless you move things

\$boarddir = "$FORM{'boarddir'}"; 				# The absolute path to the board's folder (usually can be left as '.')
\$datadir = "$FORM{'datadir'}";         			# Directory with messages
\$memberdir = "$FORM{'memberdir'}";        			# Directory with member files
\$boardsdir = "$FORM{'boardsdir'}";         			# Directory with board data files
\$sourcedir = "$FORM{'sourcedir'}";        			# Directory with YaBB source files
\$vardir = "$FORM{'vardir'}";         				# Directory with variable files
\$facesurl = "$FORM{'facesurl'}";				# URL to your avatars folder
\$facesdir = "$FORM{'facesdir'}";				# Absolute Path to your avatars folder
\$imagesdir = "$FORM{'imagesdir'}";				# URL to your images directory
\$helpfile = "$FORM{'helpfile'}";				# Location of your help file


########## Colors ##########
# Note: equivalent to colors in CSS tag of template.html, so set to same colors preferrably
# for browsers without CSS compatibility and for some items that don't use the CSS tag

\$color{'titlebg'} = "$FORM{'titlebg'}";			# Background color of the 'title-bar'
\$color{'titletext'} = "$FORM{'titletext'}";			# Color of text in the 'title-bar' (above each 'window')
\$color{'windowbg'} = "$FORM{'windowbg'}";			# Background color for messages/forms etc.
\$color{'windowbg2'} = "$FORM{'windowbg2'}";			# Background color for messages/forms etc.
\$color{'catbg'} = "$FORM{'catbg'}";				# Background color for category (at Board Index)
\$color{'bordercolor'} = "$FORM{'bordercolor'}";		# Table Border color for some tables


########## Features ##########

\$MenuType = $mentype;						# 1 for text menu or anything else for images menu
\$timeselected = $FORM{'timeselect'};			# Select your preferred output Format of Time and Date
\$timeoffset = $FORM{'timeoffset'};				# Time Offset (so if your server is EST, this would be set to -1 for CST)
\$TopAmmount = $FORM{'TopAmmount'};				# No. of top posters to display on the top members list
\$MembersPerPage = $FORM{'MembersPerPage'};			# No. of members to display per page of Members List - All
\$maxdisplay = $FORM{'maxdisplay'};				# Maximum of topics to display
\$maxmessagedisplay = $FORM{'maxmessagedisplay'};		# Maximum of messages to display
\$insert_original = $orig;					# Set to 1 if you want the original message included when replying...
\$enable_ubbc = $ubbc;						# Set to 1 if you want to enable UBBC (Uniform Bulletin Board Code)
\$max_log_days_old = $FORM{'max_log_days_old'};			# If an entry in the user's log is older than ... days remove it
								# Set to 0 if you want it disabled
\$MaxMessLen = $FORM{'maxmesslen'};  					# Maximum Allowed Characters in a Posts (required <= 5000)

\$enable_news = $news;						# Set to 1 to turn news on, or 0 to set news off
\$enable_guestposting = $guestp;				# Set to 0 if do not allow 1 is allow.
\$enable_notification = $notif;					# Allow e-mail notification
\$showlatestmember = $latest;					# Set to 1 to display "Welcome Newest Member" on the Board Index
\$Show_RecentBar = $recentbar;						# Set to 1 to display the Recent Posts bar on Board Index
\$Show_MemberBar = $memberbar;						# Set to 1 to display the Members List table row on Board Index
\$showmodify = $modify;						# Set to 1 to display "Last modified: Realname - Date" under each message
\$showuserpic = $pic;						# Set to 1 to display each member's picture in the message view (by the ICQ.. etc.)
\$showusertext = $text;						# Set to 1 to display each member's personal text in the message view (by the ICQ.. etc.)
\$showgenderimage = $gender;					# Set to 1 to display each member's gender in the message view (by the ICQ.. etc.)


########## NewsFader ##########

\$shownewsfader = $fader;					# 1 to allow or 0 to disallow NewsFader javascript on the Board Index
								# If 0, you'll have no news at all unless you put <yabb news> tag
								# back into template.html!!!
\$color{'fadertext'}  = "$FORM{'fadertext'}";			# Color of text in the NewsFader ("The Latest News" color)
\$color{'fadertext2'}  = "$FORM{'fadertext2'}";			# Color of text in the NewsFader (news color)
\$faderpath = "$FORM{'faderpath'}";				# Web path to your 'fader.js'


########## UBBC JS Path ##########

\$ubbcjspath = "$FORM{'ubbcjspath'}";	# Web path to your 'ubbc.js' REQUIRED for post/modify to work properly!


########## MemberPic Settings ##########

\$userpic_width = $FORM{'userpic_width'};			# Set pixel size to which the selfselected userpics are resized, 0 disables this limit
\$userpic_height = $FORM{'userpic_height'};			# Set pixel size to which the selfselected userpics are resized, 0 disables this limit
\$userpic_limits = "$FORM{'userpic_limits'}";	# Text To Describe The Limits


########## File Locking ##########

\$LOCK_EX = $FORM{'LOCK_EX'};					# You can probably keep this as they are set now
\$LOCK_UN = $FORM{'LOCK_UN'};					# You can probably keep this as they are set now
\$use_flock = $flock;						# Set to 0 if your server doesn't support file locking, 1 for *ix Systems and 2 for Win-Servers

1;
~;
	&unlock(FILE);
	close(FILE);

	$password = crypt("$settings[0]",$pwseed);
	$Cookie_Len = "$FORM{'cookielength'}";
	&SetCookieExp;

	### Kill old Cookie and set new one
	print 'Set-Cookie: ' . $cookieusername . '=;';
	print ' expires=Mon, 01-Jan-2000 00:00:00 GMT;';
	print "\n";
	print 'Set-Cookie: ' . $cookiepassword . '=;';
	print ' expires=Mon, 01-Jan-2000 00:00:00 GMT;';
	print "\n";
	print 'Set-Cookie: ' . $FORM{'cookieusername'} . '=' . $username . ';';
	print ' expires=' . $Cookie_Exp_Date . ';';
	print "\n";
	print 'Set-Cookie: ' . $FORM{'cookiepassword'} . '=' . $password . ';';
	print ' expires=' . $Cookie_Exp_Date . ';';
	print "\n";
	print "Location: $cgi\&action=admin\n\n";
	exit;
}

1;