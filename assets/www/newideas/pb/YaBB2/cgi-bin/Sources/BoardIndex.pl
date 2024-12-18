###############################################################################
# BoardIndex.pl                                                               #
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

$boardindexplver="1 Gold Beta4";

sub BoardIndex {
	# Open the file with all categories
	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);

	my( $memcount, $latestmember ) = &MembershipGet;
	&LoadUser($latestmember);
	$thelatestmember = qq~$txt{'201'}: <a href="$scripturl?action=viewprofile&username=$latestmember">$userprofile{$latestmember}->[1]</a>~;
	$totalm = 0;
	$totalt = 0;

	for( $catnum = 0; $catnum < @categories; $catnum++ ) {
		chomp $categories[$catnum];
		$curcat = $categories[$catnum];
		open(FILE, "$boardsdir/$curcat.cat");
		&lock(FILE);
		$catname{$curcat} = <FILE>;
		chomp $catname{$curcat};
		$cataccess{$curcat} = <FILE>;
		chomp $cataccess{$curcat};
		@{$catboards{$curcat}} = <FILE>;
		&unlock(FILE);
		close(FILE);
		@membergroups = split( /,/, $cataccess{$curcat} );
		$openmemgr{$curcat} = 0;
		foreach $tmpa (@membergroups) {
			if( $tmpa eq $settings[7]) { $openmemgr{$curcat} = 1; last; }
		}
		if( ! $cataccess{$curcat} || $settings[7] eq 'Administrator' ) {
			$openmemgr{$curcat} = 1;
		}
		unless( $openmemgr{$curcat} ) { next; }
		foreach $curboard (@{$catboards{$curcat}}) {
			chomp $curboard;
			( $threadcount, $messagecount, $lastposttime, $lastposter ) = &BoardCountGet($curboard);
			$lastposttime{$curboard} = $lastposttime eq 'N/A' || ! $lastposttime ? $txt{'470'} : &timeformat($lastposttime);
			$lastpostrealtime{$curboard} = $lastposttime eq 'N/A' || ! $lastposttime ? '' : $lastposttime;
			if( $lastposter =~ m~\AGuest-(.*)~ ) {
				$lastposter = $1;
				$lastposterguest{$curboard} = 1;
			}
			$lastposter{$curboard} = $lastposter eq 'N/A' || ! $lastposter ? $txt{'470'} : $lastposter;
			$messagecount{$curboard} = $messagecount || 0;
			$threadcount{$curboard} = $threadcount || 0;
			$totalm += $messagecount;
			$totalt += $threadcount;
		}
	}
	$yytitle = "$txt{'18'}";
	&header;

	print <<"EOT";
<table width=100% align="center">
<tr>
	<td valign=bottom><IMG SRC="$imagesdir/open.gif" BORDER=0> $mbname</td>
	<td align=right>$txt{'19'}: $memcount<br>
$txt{'94'} $totalm $txt{'95'} $totalt $txt{'64'}
EOT
	if ($showlatestmember == 1) {
		print <<"EOT";
	<br>$thelatestmember
EOT
	}
	print <<"EOT";
</td>
</tr>
</table>
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
EOT

	if($shownewsfader == 1) {
		print <<"EOT";
<tr>
	<td bgcolor="$color{'windowbg2'}" valign=top colspan=6 height=45>
	<SCRIPT LANGUAGE="JavaScript1.2" TYPE="text/javascript">
	<!--
	NS4 = (document.layers);
	IE4 = (document.all);
	   FDRboxWid = 650;
	   FDRboxHgt = 45;
	   FDRborWid = 4;
	   FDRborCol = "$color{'windowbg2'}";
	   FDRborSty = "solid";
	   FDRbackCol = "$color{'windowbg2'}";
	   FDRboxPad = 4;

	   FDRtxtAln = "center";
	   FDRlinHgt = "11pt";
	   FDRfntFam = "Verdana";
	   FDRfntCol = "$color{'fadertext2'}";
	   FDRfntSiz = "10pt";
	   FDRfntWgh = "bold";
	   FDRfntSty = "normal";
	   FDRlnkCol = "#000080";
	   FDRlnkDec = "underline";
	   FDRhovCol = "#800000";

	   FDRgifSrc = "$imagesdir/fade.gif";
	   FDRgifInt = 60;

	   FDRblendInt = 7;
	   FDRblendDur = 1;
	   FDRmaxLoops = 100;

	   FDRendWithFirst = true;
	   FDRreplayOnClick = true;

	   FDRjustFlip = false;
	   FDRhdlineCount = 1;
	//-->
	</SCRIPT>

	<SCRIPT LANGUAGE='JavaScript1.2' TYPE='text/javascript'>
	prefix="";
	arNews = [
	"<font color=\\"$color{'fadertext'}\\">$txt{'102'}</font>","",
EOT
		for($i=0;$i<@newsmessages;$i++) {
			$newsmessages[$i] =~ s/\n//g;
			$newsmessages[$i] =~ s/\r//g;
			if($i != 0)
				{print ",\n";}
			$message = $newsmessages[$i];
			if($enable_ubbc) {
				&MakeSmileys;
				$sender = 'News';
				&DoUBBC;
			}
			$message =~ s/\"/\\\"/g;
			print qq~"$message",""~;
		}
		print <<"EOT";
	]
	</SCRIPT>
	<SCRIPT LANGUAGE='JavaScript1.2' SRC='$faderpath' TYPE='text/javascript'></SCRIPT>
	  <div align="center">
		<div id="elFader" style="position:relative;visibility:hidden;width:500;">
		<font face="Verdana, Arial" size=2>News Fader for DHTML Browser.</font>
		</div>
	  </div>
	</td>
</tr>
EOT
	}
	print <<"EOT";
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}" width=10><font size=2>&nbsp;</font></td>
	<td class="title1" bgcolor="$color{'titlebg'}"><font class="text1" color="$color{'titletext'}" size=2>$txt{'20'}</font></td>
	<td class="title1" bgcolor="$color{'titlebg'}" nowrap align=center><font class="text1" color="$color{'titletext'}" size=2>$txt{'330'}</font></td>
	<td class="title1" bgcolor="$color{'titlebg'}" nowrap align=center><font class="text1" color="$color{'titletext'}" size=2>$txt{'21'}</font></td>
	<td class="title1" bgcolor="$color{'titlebg'}" width="150" nowrap align=center><font class="text1" color="$color{'titletext'}" size=2>$txt{'22'}</font></td>
	<td class="title1" bgcolor="$color{'titlebg'}" nowrap><font class="text1" color="$color{'titletext'}" size=2>$txt{'12'}</font></td>
</tr>
EOT

	foreach $curcat (@categories) {
		unless( $openmemgr{$curcat} ) { next; }
		print <<"EOT";
<tr>
	<td colspan=6 class="cat1" bgcolor="$color{'catbg'}"><font size=2>$catname{$curcat}</font></td>
</tr>
EOT
		foreach $curboard (@{$catboards{$curcat}}) {
			chomp $curboard;
			open(FILE, "$boardsdir/$curboard.dat");
			&lock(FILE);
			$curboardname = <FILE>;
			chomp $curboardname;
			$curboarddescr = <FILE>;
			chomp $curboarddescr;
			$curboardmods = <FILE>;
			chomp $curboardmods;
			&unlock(FILE);
			close(FILE);
			%moderators = ();
			foreach $curuser (split(/\|/, $curboardmods)) {
				&LoadUser($curuser);
				$moderators{$curuser} = $userprofile{$curuser}->[1];

			}
			$showmods = '';
			while( $tmpa = each(%moderators) ) {
				$showmods .= qq~<a href="$scripturl?action=viewprofile&username=$tmpa">$moderators{$tmpa}</a>, ~;
			}
			$showmods =~ s/, \Z//;
			$dlp = &getlog($curboard);
			if( $lastposttime{$curboard} ne $txt{'470'} && $username ne 'Guest' && $dlp < stringtotime( $lastpostrealtime{$curboard} ) ) {
				$new = qq~<img src="$imagesdir/on.gif" alt="$txt{'333'}" border="0">~;
			}
			else {
				$new = qq~<img src="$imagesdir/off.gif" alt="$txt{'334'}" border="0">~;
			}
			$lastposter = $lastposter{$curboard};
			unless( $lastposterguest{$curboard} || $lastposter{$curboard} eq $txt{'470'} ) {
				&LoadUser($lastposter);
				$lastposter = $userprofile{$lastposter}->[1] || $lastposter;
			}
			$lastposter ||= $txt{'470'};
			$lastposttime ||= $txt{'470'};
			print <<"EOT";
<tr>
	<td class="form2" bgcolor="$color{'windowbg2'}" width="10" valign="top">$new</td>
	<td class="form2" bgcolor="$color{'windowbg2'}" valign=top><span class="Blacky"><a href="YaBB.pl?board=$curboard">$curboardname</a><br>
	$curboarddescr</span></td>
	<td class="form2" bgcolor="$color{'windowbg2'}" valign="middle" align=center><span class="Blacky">$threadcount{$curboard}</span></td>
	<td class="form2" bgcolor="$color{'windowbg2'}" valign="middle" align=center><span class="Blacky">$messagecount{$curboard}</span></td>
	<td class="form2" bgcolor="$color{'windowbg2'}" valign="middle" align=center><span class="Blacky">$lastposttime{$curboard}<BR>by $lastposter</span></td>
	<td class="form2" bgcolor="$color{'windowbg2'}" valign="middle"><span class="Blacky">$showmods</span></td>
</tr>
EOT
		}
	}

	$guests = 0;
	$users = '';
	open(FILE, "$vardir/log.txt");
	&lock(FILE);
	@entries = <FILE>;
	&unlock(FILE);
	close(FILE);
	foreach $curentry (@entries) {
		chomp $curentry;
		($name, $value) = split(/\|/, $curentry);
		if($name =~ /\./) { ++$guests; }
		elsif( $name ) {
			&LoadUser($name);
			$users .= qq~ <a href="$scripturl?action=viewprofile&username=$name">$userprofile{$name}->[1]</a><font size=1>,</font> \n~;
		}
	}
	$users =~ s~<font size=1>,</font> \n\Z~~;
	if( $username ne 'Guest' ) {
		$messnum = @immessages;
		print <<"EOT";
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}" colspan=6 align="center">
	<a href="$scripturl?action=markallasread"><img src="$imagesdir/markread.gif" alt="$txt{'452'}" border=0></a></td>
</tr>
EOT
	}

	print <<"EOT";
</table>
<br>
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
EOT
	if($Show_RecentBar == 1) {
		print <<"EOT";
<tr>
	<td class="title1" colspan=2 bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'214'}</font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg2'}" width=10 valign=middle align=center><img src="$imagesdir/xx.gif" border="0"></td>
	<td class="form1" bgcolor="$color{'windowbg2'}" valign=top><font size=2><A href="$scripturl?action=recent">$txt{'214'}</A></font><br>
	<font size=1>
EOT
	require "$sourcedir/Recent.pl";
	&LastPost;
	print <<"EOT";
</font>
</tr>
EOT
	}
	if($Show_MemberBar == 1) {
		print <<"EOT";
<tr>
	<td class="title1" colspan=2 bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'331'}</font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg2'}" width=10 valign=middle align=center><img src="$imagesdir/online.gif" border="0"></td>
	<td class="form1" bgcolor="$color{'windowbg2'}" valign=top><font size=2><A class="blacky" href="YaBB.pl?action=mlall">$txt{'332'}</A></font><br><span class="blacky">$txt{'200'}</span></td>
</tr>
EOT
	}
	print <<"EOT";
<tr>
	<td class="title1" colspan=2 bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'158'}</font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg2'}" width=10 valign=middle align=center><img src="$imagesdir/online.gif" border="0"></td>
	<td class="form1" bgcolor="$color{'windowbg2'}" valign=top><font size=2>$txt{'141'}: $guests <br>$txt{'142'}: $users</font></td>
</tr>
EOT

	if( $username ne 'Guest' ) {
		print <<"EOT";
<tr>
	<td class="title1" colspan=2 bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'159'}</font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg2'}" width=10 valign=middle align=center><img src="$imagesdir/pmon.gif" border="0"></td>
	<td class="form1" bgcolor="$color{'windowbg'}" valign=top><font size=2><a href="$scripturl?board=&action=im">$txt{'153'}</a></font><br><font size=1>$txt{'152'} $messnum
EOT
		if($messnum == 1) {
		print $txt{'471'};
		} else {
		print $txt{'153'};
		}
		print <<"EOT";
</font>
</td>
</tr>
EOT
}
	if( $username eq 'Guest' ) {
		print <<"EOT";
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}" colspan="2"><font size=2 class="text1" color="$color{'titletext'}">$txt{'34'}</font>
	<small><small><a href="Reminder.pl?action=input_user">($txt{'315'})</small></small></a></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg2'}" width=10 valign=middle align=center><img src="$imagesdir/pmon.gif" border="0"></td>
	<td class="form1" bgcolor="$color{'windowbg2'}" valign=top><form action="$cgi\&action=login2" method="POST">
	<table border=0>
	<tr>
		<td><font size=2>$txt{'35'}:</font></td>
		<td><font size=2><input type=text name="username" size=15></font></td>
		<td><font size=2>$txt{'36'}:</font></td>
		<td><font size=2><input type=password name="passwrd" size=10></font> &nbsp;</td>
		<td><font size=2>$txt{'497'}:</font></td>
		<td><font size=2><input type=text name="cookielength" size=4 maxlength="4" value="$Cookie_Length"> &nbsp;</font></td>
		<td><font size=2>$txt{'508'}:</font></td>
		<td><font size=2><input type=checkbox name="cookieneverexp"></font></td>
		<td align=center colspan=2><input type=submit value="$txt{'34'}"></td>
	</tr>
	</table></td>
</tr></form>
EOT
	}

	print <<"EOT";
</table>
<table border=0 width=100%>
<tr>
	<td align="left" width="250"><font size="1">
<img src="$imagesdir/on.gif" border=0 alt="$txt{'333'}"><font size="1" face="Verdana, Arial"> $txt{'333'}</font><br>
<img src="$imagesdir/off.gif" border=0 alt="$txt{'334'}"><font size="1" face="Verdana, Arial"> $txt{'334'}</font>
</td>
	<td align="right" valign=top><FONT SIZE="1" FACE="Verdana, Arial" COLOR="#8C9A7A">
	$txt{'463'}</FONT></td>
</tr></table>
EOT
	&footer;
	exit;
}

sub MarkAllRead {
	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	my @categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	my( $curcat, $curcatname, $curcataccess, @catboards, @membergroups, $openmemgr, $curboard );
	foreach $curcat (@categories) {
		chomp $curcat;
		open(FILE, "$boardsdir/$curcat.cat");
		&lock(FILE);
		$curcatname = <FILE>;
		$curcataccess = <FILE>;
		chomp $curcatname;
		chomp $curcataccess;
		@catboards = <FILE>;
		&unlock(FILE);
		close(FILE);
		@membergroups = split( /,/, $curcataccess );
		$openmemgr = 0;
		foreach (@membergroups) {
			if( $_ eq $settings[7]) { $openmemgr = 1; last; }
		}
		if( ! $curcataccess || $settings[7] eq 'Administrator' ) {
			$openmemgr = 1;
		}
		unless( $openmemgr ) { next; }
		foreach $curboard (@catboards) {
			chomp $curboard;
			&modlog("$curboard--mark");
			&modlog($curboard);
		}
	}
	&dumplog;
	&BoardIndex;
}
1;