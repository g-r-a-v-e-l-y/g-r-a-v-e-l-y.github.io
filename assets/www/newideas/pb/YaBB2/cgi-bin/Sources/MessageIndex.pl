###############################################################################
# MessageIndex.pl                                                             #
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

$messageindexplver="1 Gold Beta4";

sub MessageIndex {
	&DPPrivate;
	my $start = $INFO{'start'} || 0;
	my( $counter, $buffer, $tmpa, $tmpb, $pages, $showmods, $mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate, $dlp, $threadlength, $threaddate );
	my( @threads, @censored );
	my( $threadcount, $messagecount, $lastposttime, $lastposter ) = &BoardCountGet($currentboard);
	my $maxindex = $INFO{'view'} eq 'all' ? $threadcount : $maxdisplay;

	if( $start > $threadcount ) { $start = int( $threadcount % $maxindex ) * $maxindex; }

	$tmpa = 1;
	for( $counter = 0; $counter < $threadcount; $counter += $maxindex ) {
		$pageindex .= $start == $counter ? qq~$tmpa ~ : qq~<a href="$cgi&action=messageindex&start=$counter">$tmpa</a> ~;
		++$tmpa;
	}

	open(FILE, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
	&lock(FILE);
	$counter = 0;
	$tmpa = '';
	if( $counter < $start && ( $buffer = <FILE> ) ) {
		$tmpa = $buffer;
		$counter++;
	}
	while( $counter < $start && ( $buffer = <FILE> ) ) {
		$counter++;
	}

	$#threads = $maxindex - 1;
	$counter = 0;
	while( $counter < $maxindex && ( $buffer = <FILE> ) ) {
		chomp $buffer;
		$threads[$counter] = $buffer;
		$counter++;
	}
	&unlock(FILE);
	close(FILE);
	$#threads = $counter - 1;

	$tmpa ||= $threads[0];
	($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split( /\|/, $tmpa );
	&dumplog($currentboard);

	if( scalar keys %moderators > 0 ) {
		if( scalar keys %moderators == 1 ) {
			$showmods = qq~($txt{'298'}: ~;
		}
		else {
			$showmods = qq~($txt{'299'}: ~;
		}
		while( $_ = each(%moderators) ) {
			$showmods .= qq~<a href="$scripturl?action=viewprofile&username=$_">$moderators{$_}</a>, ~;
		}
		$showmods =~ s/, \Z/)/;
	}

	open(FILE,"$vardir/censor.txt");
	&lock(FILE);
	while( chomp( $buffer = <FILE> ) ) {
		($tmpa,$tmpb) = split(/=/,$buffer);
		push(@censored,[$tmpa,$tmpb]);
	}
	&unlock(FILE);
	close(FILE);

	$yytitle = $boardname;
	&header;

	print << "EOT";
<table width=100% cellpadding=0 cellspacing=0>
  <tr>
    <td><font size=2>
    <IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
    <a href="$scripturl">$mbname</a><br>
    <IMG SRC="$imagesdir/tline.gif" BORDER=0><IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
    $boardname
    $showmods</font></td>
  </tr>
</table>
<table width="100%" cellpadding=3 cellspacing=0 bgcolor="$color{'catbg'}">
  <tr height="30">
    <td align="left">
    <font size=2>$txt{'139'}: $pageindex
</font></td>
	<td bgcolor="$color{'catbg'}" align=right>
EOT
	if ($username ne 'Guest') {
		print << "EOT";
	<a href="$cgi&action=markasread"><img src="$imagesdir/markread.gif" alt="$txt{'300'}" border=0></a>
EOT
}
	print << "EOT";
	<a href="$cgi&action=post&title=$txt{'464'}"><img src="$imagesdir/new_thread.gif" alt="$txt{'33'}" border="0"></a>
	</td>
</tr>
</table>
<table border=0 width=100% cellspacing=1 cellpadding=2 bgcolor="$color{'bordercolor'}">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}" width=16><font size=2>&nbsp;</font></td>
	<td class="title1" bgcolor="$color{'titlebg'}" width=16><font size=2>&nbsp;</font></td>
	<td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'70'}</font></td>
	<td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'109'}</font></td>
	<td class="title1" bgcolor="$color{'titlebg'}" align=center><font size=2 class="text1" color="$color{'titletext'}">$txt{'110'}</font></td>
	<td class="title1" bgcolor="$color{'titlebg'}" align=center><font size=2 class="text1" color="$color{'titletext'}">$txt{'301'}</font></td>
	<td class="title1" bgcolor="$color{'titlebg'}" align=center><font size=2 class="text1" color="$color{'titletext'}">$txt{'111'}</font></td>
EOT

	$counter = $start;
	foreach( @threads ) {
		($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split( /\|/, $_ );
		if( $mstate == 1 ) { $threadclass = 'locked'; }
		elsif( $mreplies > 24 ) { $threadclass = 'veryhotthread'; }
		elsif( $mreplies > 14 ) { $threadclass = 'hotthread'; }
		elsif( $mstate == 0 ) { $threadclass = 'thread'; }
		$dlp = &getlog($mnum);
		$threaddate = stringtotime($mdate);
		if( $dlp != $threaddate && $username ne 'Guest' && &getlog("$currentboard--mark") < $threaddate ) {
			$new = qq~<img src="$imagesdir/new.gif" alt="$txt{'302'}">~;
		}
		else {
			$new = '';
		}
		if( $musername ne 'Guest' ) {
			&LoadUser($musername);
			$mname = $userprofile{$musername}->[1];
			$mname = qq~<a href="$scripturl?action=viewprofile&username=$musername" alt="$txt{'27'}: $musername">$mname</a>~;
		}

		foreach (@censored) {
			($tmpa,$tmpb) = @{$_};
			$msub =~ s~\Q$tmpa\E~$tmpb~gi;
		}

		$threadlength = $mreplies + 1;
		$pages = '';
		if( $threadlength > $maxmessagedisplay ) {
			$tmpa = 1;
			for( $tmpb = 0; $tmpb < $threadlength; $tmpb += $maxmessagedisplay ) {
				$pages .= qq~<a href="$cgi&action=display&num=$mnum&start=$tmpb">$tmpa</a>\n~;
				++$tmpa;
			}
			$pages =~ s/\n\Z//;
			$pages = qq~<font size="1">($pages)</font>~;
		}
		open(FILE, "$datadir/$mnum.data");
		&lock(FILE);
		$tmpa = <FILE>;
		&unlock(FILE);
		close(FILE);
		($views, $lastposter) = split(/\|/, $tmpa);
		if( $lastposter =~ m~\AGuest-(.*)~ ) {
			$lastposter = $1;
		}
		else {
			&LoadUser($lastposter);
		}
		$lastpostername = $userprofile{$lastposter}->[1] || $lastposter || $txt{'470'};
		$views = $views ? $views - 1 : 0;
		$mydate = &timeformat($mdate);
		print << "EOT";
<tr>
	<td class="form2" valign=middle align=center width=16 bgcolor="$color{'windowbg2'}"><img src="$imagesdir/$threadclass.gif"></td>
	<td class="form2" valign=middle align=center width=16 bgcolor="$color{'windowbg2'}"><img src="$imagesdir/$micon.gif" alt="" border="0" align=middle></td>
	<td class="form1" valign=middle bgcolor="$color{'windowbg'}"><font size=2><a href="$cgi&action=display&num=$mnum">$msub</a> $new $pages</font></td>
	<td class="form2" valign=middle bgcolor="$color{'windowbg2'}"><font size=2>$mname</font></td>
	<td class="form1" valign=middle align=center bgcolor="$color{'windowbg'}"><font size=2>$mreplies</font></td>
	<td class="form1" valign=middle align=center bgcolor="$color{'windowbg'}"><font size=2>$views</font></td>
	<td class="form2" valign=middle align=center bgcolor="$color{'windowbg2'}"><font size=1>$mydate<br>by $lastpostername</font></td>
</tr>
EOT
		++$counter;
	}

	print << "EOT";
</table>
<table border=0 width=100% cellpadding=3 cellspacing=0>
  <tr height="30">
    <td bgcolor="$color{'catbg'}" align=left colspan="2">
    <font size=2>$txt{'139'}: $pageindex
</font></td>
    <td bgcolor="$color{'catbg'}" align=right>
EOT
	if ($username ne 'Guest') {
		print << "EOT";
	<a href="$cgi&action=markasread"><img src="$imagesdir/markread.gif" alt="$txt{'300'}" border=0></a>
EOT
	}
	&jumpto;

	print <<"EOT";
	<a href="$cgi&action=post&title=$txt{'464'}"><img src="$imagesdir/new_thread.gif" alt="$txt{'33'}" border="0"></a>
    </td>
</tr><tr>
    <td align="left" valign="middle"><font size=1>
    <img src="$imagesdir/hotthread.gif"> $txt{'454'}
    <BR><img src="$imagesdir/veryhotthread.gif"> $txt{'455'}</td>
    <td align="left" valign="middle"><font size=1>
    <img src="$imagesdir/locked.gif"> $txt{'456'}
    <BR><img src="$imagesdir/thread.gif"> $txt{'457'}</font></td>
    <td align="right" valign="middle"><form action="YaBB.pl" method="GET">
    <font size=1>$txt{'160'}: <select name="board">$selecthtml</select> <input type=submit value="$txt{'161'}"></form></td>
  </tr>
</table>
EOT
	&footer;
	exit;
}

sub MarkRead {
	&dumplog("$currentboard--mark");
	&MessageIndex;
}
1;