###############################################################################
# BoardIndex.pl                                                               #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Zef Hemel                                    #
###############################################################################

sub BoardIndex {
	# Open the file with all categories
	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	$title = "$txt{'18'}";
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
			if($settings[7] ne "Administrator" && $settings[7] ne "$catinfo[1]") {
				next;
			}
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
			}
		}
	}
	# Now we're printing the categories and boards
	&header;
	print <<"EOT";
<table width=600>
<tr>
	<td valign=bottom><b><a href="$boardurl/YaBB.pl">$mbname</a></b></td>
	<td align=right>$txt{'19'}: $memcount<br>
$txt{'94'} $totalm $txt{'95'} $totalt $txt{'64'}</td>
</tr>
</table>
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}" width=10>&nbsp;</td>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'20'}</b></font></td>
	<td bgcolor="$color{'titlebg'}" nowrap align=center><font color="$color{'titletext'}"><b>Threads</b></font></td>
	<td bgcolor="$color{'titlebg'}" nowrap align=center><font color="$color{'titletext'}"><b>$txt{'21'}</b></font></td>
	<td bgcolor="$color{'titlebg'}" nowrap align=center><font color="$color{'titletext'}"><b>$txt{'22'}</b></font></td>
	<td bgcolor="$color{'titlebg'}" nowrap><font color="$color{'titletext'}"><b>$txt{'12'}</b></font></td>
</tr>
EOT
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
			if($settings[7] ne "Administrator" && $settings[7] ne "$catinfo[1]") {
				next;
			}
		}
		$curcatname="$catinfo[0]";
		print <<"EOT";
<tr>
	<td bgcolor="$color{'catbg'}" width=10 valign=top><img src="$imagesdir/cat.gif" width=18 height=18 alt="" border="0"></td>
	<td colspan=5 bgcolor="$color{'catbg'}"><b>$curcatname</b></td>
</tr>
EOT
		foreach $curboard (@catinfo) {
			# Open the categegory file and list all boards in it
			if($curboard ne "$catinfo[0]" && $curboard ne "$catinfo[1]") {
				$curboard =~ s/\n//g;
				$curboard =~ s/\r//g;
				open(BOARD, "$boardsdir/$curboard.dat");
				&lock(BOARD);
				@boardinfo = <BOARD>;
				&unlock(BOARD);
				close(BOARD);
				$curboardname="$boardinfo[0]";
				$descr="$boardinfo[1]";
				open(BOARDDATA, "$boardsdir/$curboard.txt");
				&lock(BOARDDATA);
				@messages = <BOARDDATA>;
				&unlock(BOARDDATA);
				close(BOARDDATA);
				$tm = @messages;
				if(@messages == 0) { $tm="<font size=-1>N/A</font>"; }
				($dummy, $dummy, $dummy, $dummy, $lp) = split(/\|/, $messages[0]);
				$boardinfo[2] =~ s/\n//g;
				$boardinfo[2] =~ s/\r//g;
				$messagecount=0;
				for ($a = 0; $a < @messages; $a++) {
					($dm,$dm,$dm,$dm,$dm,$mreplies,$dm) = split(/\|/,$messages[$a]);
					$messagecount++;
					$messagecount=$messagecount+$mreplies;
				}

				open(MODERATOR, "$memberdir/$boardinfo[2].dat");
				&lock(MODERATOR);
				@modprop = <MODERATOR>;
				&unlock(MODERATOR);
				close(MODERATOR);
				$moderator = "$modprop[1]";
				if($lp eq "") { $lp="N/A"; }
				#$cookiename="$curboard$cookieusername$username";
				#foreach (split(/; /,$ENV{'HTTP_COOKIE'})) {
			    #   ($cookie,$value) = split(/=/);
				#   if($cookiename eq "$cookie") { $cvalue="$value"; }
			    #}
				$dlp = &readlog("$curboard");
#				$dlp = "$cvalue";
				$new="";
				if($dlp ne "$lp" && $lp ne "N/A" && $username ne "Guest") {
					$new = "<img src=\"$imagesdir/new.gif\" width=28 heigt=11 alt=\"New\">";
				}
				print <<"EOT";
<tr>
	<td bgcolor="$color{'windowbg2'}" width=10 valign=top><img src="$imagesdir/board.gif" width=16 height=16 alt="" border="0"></td>
	<td bgcolor="$color{'windowbg2'}" width=* valign=top><b><a href="YaBB.pl?board=$curboard">$curboardname</a>$new</b><br>
	$descr</td>
	<td bgcolor="$color{'windowbg2'}" valign=top width=* align=center>$tm</td>
	<td bgcolor="$color{'windowbg2'}" valign=top width=* align=center>$messagecount</td>
	<td bgcolor="$color{'windowbg2'}" valign=top width=* align=center>$lp</td>
	<td bgcolor="$color{'windowbg2'}" valign=top width=*>$moderator</td>
</tr>
EOT
			}
		}
	}
	$guests=0;
	$users="";
	open(LOG, "$vardir/log.txt");
	&lock(LOG);
	@entries = <LOG>;
	&unlock(LOG);
	close(LOG);
	foreach $curentry (@entries) {
		$curentry =~ s/\n//g;
		$curentry =~ s/\r//g;
		($name, $value) = split(/\|/, $curentry);
		if($name =~ /\./) { ++$guests }
		else {
			open(MEM, "$memberdir/$name.dat");
			&lock(MEM);
			@sett = <MEM>;
			&unlock(MEM);
			close(MEM);
			$sett[1] =~ s/\n//g;
			$sett[1] =~ s/\r//g;
			$users = "$users <a href=\"$cgi\&action=viewprofile\&username=$name\">$sett[1]</a>\n"; }
	}
if($username ne "Guest") { 
		open(IM, "$memberdir/$username.msg"); 
		&lock(IM); 
		@immessages = <IM>; 
		&unlock(IM); 
		close(IM); 
		$mnum = @immessages; 
		$messnum = "$mnum"; 
}
if($mnum eq "1") { 
		$s = "" 
} 
	else { 
		$s ="s" 
}

	print <<"EOT";
<tr>
	<td colspan=6 bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>Members</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg2'}" width=10 valign=middle align=center><img src="$imagesdir/online.gif" alt="online" border="0"></td>
	<td bgcolor="$color{'windowbg2'}" valign=top colspan=5><b><A href="YaBB.pl?action=mlall">Members List</A></b><br><font size=1>See who is registered at this board.</font>
</td>
</tr>
<tr>
	<td colspan=6 bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'158'}</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg2'}" width=10 valign=middle align=center><img src="$imagesdir/online.gif" alt="online" border="0"></td>
	<td bgcolor="$color{'windowbg2'}" valign=top colspan=5>$txt{'141'}: $guests <br>$txt{'142'}: $users</td>
</tr>
EOT
	if($username ne "Guest") {
		print <<"EOT";
<tr>
	<td colspan=6 bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'159'}</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg2'}" width=10 valign=middle align=center><img src="$imagesdir/pmon.gif" alt="" border="0"></td>
	<td bgcolor="$color{'windowbg'}" valign=top colspan=5><b><a href=\"$cgi\&action=im\">$txt{'153'}</a></b><br><font size=1>$txt{'152'} $mnum $txt{'153'}$s</font>
</td>
</tr>
EOT
	}
print <<"EOT";
</table> 
EOT
	&footer;
	exit;
}

1;
