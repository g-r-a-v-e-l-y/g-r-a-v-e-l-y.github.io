###############################################################################
# Display.pl                                                                  #
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

$displayplver="1 Gold Beta4";

sub Display {
	my $viewnum = $INFO{'num'};
	if( $viewnum =~ /\D/ ) { &fatal_error($txt{'337'}); }
	$maxmessagedisplay ||= 10;
	my($buffer,$views,$lastposter,$tmpa,$tmpb,,$moderators,$counter,$max,$pageindex,$msubthread,$mnum,$mstate,$mdate,$msub,$mname,$memail,$mreplies,$musername,$micon,$noposting,$threadclass,$notify,$max,$start,$bgcolornum,$userpic_tmpwidth,$userpic_tmpheight,$windowbg,$mattach,$mip,$mns,$mlm,$mlmb,$lastmodified,$postinfo,$star,$sendm,$topicdate);
	my(@censored,@userprofile,@messages,@bgcolors);
	my(%memberinfo,%memberstar,%icqad,%memberinfo);
	if( $currentboard ) { &DPPrivate; }
	open(FILE,"$vardir/membergroups.txt") || &fatal_error("$txt{'23'} membergroups.txt");
	&lock(FILE);
	@membergroups = <FILE>;
	&unlock(FILE);
	close(FILE);
	open(FILE,"$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
	&lock(FILE);
	while( $buffer = <FILE> ) {
		($mnum,$tmpa,$tmpa,$tmpa,$mdate) = split(/\|/,$buffer);
		if( $mnum eq $viewnum ) { last; }
	}
	&unlock(FILE);
	close(FILE);

	&dumplog($mnum,$mdate);

	open(FILE, "$datadir/$viewnum.data") || &fatal_error("$txt{'23'} $viewnum.data");
	&lock(FILE);
	$tmpa = <FILE>;
	&unlock(FILE);
	close(FILE);

	( $tmpa, $tmpb ) = split( /\|/, $tmpa );
	$tmpa++;

	open(FILE,"+>$datadir/$viewnum.data") || &fatal_error("$txt{'23'} $viewnum.data");
	&lock(FILE);
	print FILE qq~$tmpa|$tmpb~;
	&unlock(FILE);
	close(FILE);

	($mnum,$msubthread,$mname,$memail,$mdate,$mreplies,$musername,$micon,$mstate) = split( /\|/, $buffer );
	$noposting = $viewnum eq $mnum && $mstate == 1 ? 1 : 0;

	if( $mstate == 1 ) { $threadclass = 'locked'; }
	elsif( $mreplies > 24 ) { $threadclass = 'veryhotthread'; }
	elsif( $mreplies > 14 ) { $threadclass = 'hotthread'; }
	elsif( $mstate == 0 ) { $threadclass = 'thread'; }

	open(FILE,"$vardir/censor.txt");
	&lock(FILE);
	while( chomp( $buffer = <FILE> ) ) {
		($tmpa,$tmpb) = split(/=/,$buffer);
		push(@censored,[$tmpa,$tmpb]);
		$msubthread =~ s/\Q$tmpa\E/$tmpb/gi;
	}
	&unlock(FILE);
	close(FILE);

	$yytitle = $msubthread;
	&header;

	$moderators = " (";
	$moderators .= scalar keys %moderators == 1 ? "$txt{'298'}: " : "$txt{'299'}: ";
	while( $tmpa = each(%moderators) ) {
		$moderators .= qq~<a href="$scripturl?&action=viewprofile&username=$tmpa">$moderators{$tmpa}</a>, ~;
	}
	$moderators =~ s/, \Z/)/;

	if( $enable_notification ) {
		$notify = qq~<a href="$cgi&action=notify&thread=$viewnum"><img src="$imagesdir/notify.gif" alt="$txt{'131'}" border="0"></a>~;
	}
	&jumpto;

	$max = $mreplies + 1;
	$start = $INFO{'start'} || 0;
	if( $start > $max ) { $start = ( ( int( $max / $maxmessagedisplay ) || 1 ) - 1 ) * $maxmessagedisplay; }
	$tmpa = 1;
	for( $counter = 0; $counter < $max; $counter += $maxmessagedisplay ) {
		$pageindex .= $start == $counter ? qq~$tmpa ~ : qq~<a href="$cgi&action=display&num=$viewnum&start=$counter">$tmpa</a> ~;
		$tmpa++;
	}

	print << "EOT";
<table width=100% cellpadding=0 cellspacing=0>
  <tr>
    <td valign=bottom colspan="2"><spacn class="treenav">
    <img src="$imagesdir/open.gif" border=0>&nbsp;&nbsp;
    <a href="$scripturl">$mbname</a>
    <br>
    <img src="$imagesdir/tline.gif" border=0><IMG SRC="$imagesdir/open.gif"  border=0>&nbsp;&nbsp;
    <a href="$cgi">$boardname</a><br>
    <img SRC="$imagesdir/tline3.gif" border=0><IMG SRC="$imagesdir/open.gif" border=0>&nbsp;&nbsp;
    $msubthread
    </span> $moderators</span></td>
  </tr><tr height="30">
    <td bgcolor="$color{'catbg'}" align="left" valign="middle"><span class="blacky">$txt{'139'}: </span>$pageindex
    </td>
    <td bgcolor="$color{'catbg'}" align="right" valign="middle"><a href="$cgi&action=post&num=$viewnum&title=$txt{'116'}&start=$start"><img src="$imagesdir/reply.gif" alt="$txt{'146'}" border="0"></a>$notify<a href="Printpage.pl?board=$currentboard&num=$viewnum" target="_blank"><img src="$imagesdir/print.gif" alt="$txt{'465'}" border=0></a></td>
  </tr>
</table>
<table border=0 width=100% cellspacing=1 cellpadding=3  bgcolor="$color{'bordercolor'}">
  <tr>
    <td class="title1" bgcolor="$color{'titlebg'}"><table border=0 cellspacing=0 cellpadding=0><tr><td><font size=2 class="text1" color="$color{'titletext'}"><img src="$imagesdir/$threadclass.gif"></td><td><font size=2 class="text1" color="$color{'titletext'}">&nbsp;$txt{'29'}</font></td></tr></table></td>
    <td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'118'}: $msubthread</font></td>
  </tr>
EOT

	@bgcolors = ( $color{windowbg}, $color{windowbg2} );
	$bgcolornum = scalar @bgcolors;
	$userpic_tmpwidth = $userpic_width ? qq~ width="$userpic_width"~ : '';
	$userpic_tmpheight = $userpic_height ? qq~ height="$userpic_height"~ : '';
	$counter = 0;

	open(FILE,"$datadir/$viewnum.txt") || &fatal_error("$txt{'23'} $viewnum.txt");
	&lock(FILE);

	while( $counter < $start && ( $buffer = <FILE> ) ) {
		$counter++;
	}

	$#messages = $maxmessagedisplay - 1;
	for( $counter = 0; $counter < $maxmessagedisplay && ( $buffer = <FILE> ); $counter++ ) {
		$messages[$counter] = $buffer;
	}
	&unlock(FILE);
	close(FILE);
	$#messages = $counter - 1;

	$counter = $start;

	foreach (@messages) {
		$windowbg = $bgcolors[($counter % $bgcolornum)];
		chomp;
		($msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $message, $mns, $mlm, $mlmb) = split(/[\|]/, $_);
		if( $mlm ) {
			$mlm = &timeformat($mlm);
			$lastmodified = qq~<BR><hr size="1" noshade width="100%" align="left"><i>$txt{'211'}: $mlmb - $mlm</i>~;
		}
		else {
			$mlm = '-';
			$lastmodified = '';
		}
		$msub ||= $txt{'24'};
		$messdate = &timeformat($mdate);
		$mip = $settings[7] eq 'Administrator' ? $mip : "$txt{'511'}";
		$sendm = '';

		if( $musername ne 'Guest' && ( $userprofile{$musername} || -e("$memberdir/$musername.dat") ) ) {
			if( $username ne 'Guest' ) {
				$sendm = qq~ <a href="$cgi&action=imsend&to=$musername"><img src="$imagesdir/message.gif" alt="$txt{'466'}" border="0"></a>~;
			}
			if( exists $userprofile{$musername} ) {
				@userprofile = @{$userprofile{$musername}};
				$star = $memberstar{$musername};
				$memberinfo = $memberinfo{$musername};
				$icqad = $icqad{$musername};
			}
			else {
				&LoadUser($musername);
				@userprofile = @{$userprofile{$musername}};
				$userprofile[5] =~ s~\&\&~<br>~g;
				$userprofile[5] = $userprofile[5] ? qq~<BR><BR><hr size="1" noshade width="40%" align="left">$userprofile[5]~ : '';
				$userprofile[4] = $userprofile[4] && $userprofile[4] ne q~http://~ ? qq~<a href="$userprofile[4]" target="_blank"><img src="$imagesdir/www.gif" alt="$txt{'96'}" border="0"></a>~ : '';
				if( $userprofile[8] && $userprofile !~ m~\D~ ) {
					$icqad{$musername} = qq~<a href="http://wwp.icq.com/scripts/search.dll?to=$userprofile[8]" target="_blank"><img src="$imagesdir/icqadd.gif" alt="$userprofile[8]" border="0"></a>~;
					$userprofile[8] = qq~<a href="$cgi&action=icqpager&UIN=$userprofile[8]" target="_blank"><img src="http://wwp.icq.com/scripts/online.dll?icq=$userprofile[8]&img=5" alt="$userprofile[8]" border="0"></a>~;
				}
				else {
					$icqad{$musername} = '';
					$userprofile[8] = '';
				}
				$userprofile[9] = $userprofile[9] ? qq~<a href="aim:goim?screenname=$userprofile[9]&message=Hi.+Are+you+there?"><img src="$imagesdir/aim.gif" alt="$userprofile[9]" border="0"></a>~ : '';
				if( $userprofile[10] && $userprofile !~ m~\D~ ) {
					$yimon{$musername} = qq~<img SRC="http://opi.yahoo.com/online?u=$userprofile[10]&m=g&t=0" NOSAVE BORDER=0 alt="$userprofile[10]">~;
					$userprofile[10] = $userprofile[10] ? qq~<a href="http://edit.yahoo.com/config/send_webmesg?.target=$userprofile[10]" target="_blank"><img src="$imagesdir/yim.gif" alt="$userprofile[10]" border="0"></a>~ : '';
				}
				if( $showgenderimage ) {
					$userprofile[11] = lc $userprofile[11];
					$userprofile[11] = $userprofile[11] ? qq~<font size="1">$txt{'231'}: <img src="$imagesdir/$userprofile[11].gif" border="0" alt="$userprofile[11]"><br>~ : '';
				}
				$userprofile[12] = $showusertext ? qq~$userprofile[12]<br>~ : '';
				if( $showuserpic ) {
					$userprofile[13] ||= 'blank.gif';
					$userprofile[13] = $userprofile[13] =~ m~\Ahttp://~ ? qq~<br><img src="$userprofile[13]"$userpic_tmpwidth$userpic_tmpheight border="0"><br><br>~ : qq~<br><img src="$facesurl/$userprofile[13]" border="0"><br><br>~;
				}
				@{$userprofile{$musername}} = @userprofile;
				if( $userprofile[6] > 500 ) {
					$memberinfo = $membergroups[4];
					$star = qq~<img src="$imagesdir/star.gif" border="0" alt="*"><img src="$imagesdir/star.gif" border="0" alt="*"><img src="$imagesdir/star.gif" border="0" alt="*"><img src="$imagesdir/star.gif" border="0" alt="*"><img src="$imagesdir/star.gif" border="0" alt="*">~;
				}
				elsif( $userprofile[6] > 250 ) {
					$memberinfo = $membergroups[4];
					$star = qq~<img src="$imagesdir/star.gif" border="0" alt="*"><img src="$imagesdir/star.gif" border="0" alt="*"><img src="$imagesdir/star.gif" border="0" alt="*"><img src="$imagesdir/star.gif" border="0" alt="*">~;
				}
				elsif( $userprofile[6] > 100 ) {
					$memberinfo = $membergroups[4];
					$star = qq~<img src="$imagesdir/star.gif" border="0" alt="*"><img src="$imagesdir/star.gif" border="0" alt="*"><img src="$imagesdir/star.gif" border="0" alt="*">~;
				}
				elsif( $userprofile[6] > 50 ) {
					$memberinfo = $membergroups[3];
					$star = qq~<img src="$imagesdir/star.gif" border="0" alt="*"><img src="$imagesdir/star.gif" border="0" alt="*">~;
				}
				else {
					$memberinfo = $membergroups[2];
					$star = qq~<img src="$imagesdir/star.gif" border="0" alt="*">~;
				}
				if( exists $moderators{$musername} ) {
					$memberinfo = $membergroups[1]
				}
				if( $userprofile[7] ) {
					$memberinfo = $userprofile[7];
				}
				if( $memberinfo eq 'Administrator' ) {
					$memberinfo = $membergroups[0];
				}
				$memberinfo{$musername} = $memberinfo;
				$memberstar{$musername} = $star;
			}
			$usernamelink = qq~<a href="$scripturl?board=$currentboard&action=viewprofile&username=$musername"><font size="2">$mname</font></a>~;
			$postinfo = qq~$txt{'26'}: $userprofile[6]<br>~;
			$memail = $userprofile[2];
		}
		else {
			$usernamelink = qq~<font size="2">$mname</font>~;
			$postinfo = '';
			$star = '';
			$memberinfo = $txt{'28'};
			$icqad = '';
			@userprofile = ();
		}
		$message .= $userprofile[5] . $lastmodified;
		$ns = $mns;
		foreach (@censored) {
			($tmpa,$tmpb) = @{$_};
			$message =~ s~\Q$tmpa\E~$tmpb~gi;
			$msub =~ s~\Q$tmpa\E~$tmpb~gi;
		}
		if($enable_ubbc) { &DoUBBC; }
		print << "EOT";
<tr>
<td bgcolor="$windowbg" width=140 valign=top rowspan=2>
	$usernamelink<br>
	<font size=1>$memberinfo<br>
	$star<br><br>
	$postinfo<br>
	$userprofile[13]$userprofile[12]$userprofile[11]
	$userprofile[8] $icqad{$musername} &nbsp; $userprofile[10] $yimon{$musername} &nbsp; $userprofile[9]
	</font>
</td>
<td bgcolor="$windowbg" valign=top height="100%">
	<table border=0 cellspacing=0 cellpadding=0 width=100%><tr>
	<td valign="middle"> &nbsp;<img src="$imagesdir/$micon.gif"> <font size=2>&nbsp;<a name="$counter"></a>
	$msub</font> &nbsp;&nbsp;<font size=1>($txt{'30'}: $messdate)</td>
	<td align="right" valign="middle"><font size=1>$txt{'512'}: $mip</font></td></tr></table>
	<hr width="100%" noshade size="2"></font>
<font size=2>
$message
</font>
</td>
</tr>
<tr height="16">
	<td bgcolor="$windowbg"><table border=0 cellspacing=0 cellpadding=0 width="100%" height="16"><tr><td>
	&nbsp; $userprofile[4] &nbsp;<a href="mailto:$memail"><img src="$imagesdir/email.gif" alt="$txt{'69'}" border=0></a> &nbsp;$sendm
	</td>
	<td align=right nowrap valign="middle"><font size="-3">$txt{'146'} #$counter</font> <a href="$cgi&action=post&num=$viewnum&quote=$counter&title=$txt{'116'}&start=$start"><img src="$imagesdir/quote.gif" alt="$txt{'145'}" border=0></a> <a href="$cgi&action=modify&message=$counter&thread=$viewnum"><img src="$imagesdir/modify.gif" alt="$txt{'66'}" border=0></a>
EOT
		if(exists $moderators{$username} || $settings[7] eq 'Administrator') {
print << "EOT";
<a href="$cgi&action=modify2&thread=$viewnum&id=$counter&d=1"><img src="$imagesdir/delete.gif" alt="$txt{'121'}" border=0></a></font></td>
EOT
}
print << "EOT";
</td></tr></table></td>
</tr>
EOT
;
		$counter++;
	}

	print << "EOT";
</table>
<table border=0 width=100% cellpadding=0 cellspacing=0>
  <tr height="30">
    <td bgcolor="$color{'catbg'}" align="left" colspan="2"><font size=2>$txt{'139'}:
$pageindex
    </font></td>
    <td bgcolor="$color{'catbg'}" align=right><a href="$cgi&action=post&num=$viewnum&title=$txt{'116'}&start=$start"><img src="$imagesdir/reply.gif" alt="$txt{'146'}" border="0"></a>$notify<a href="Printpage.pl?board=$currentboard&num=$viewnum" target="_blank"><img src="$imagesdir/print.gif" alt="$txt{'465'}" border=0></a></td>
  </tr>
EOT
  print << "EOT";
  <tr>
    <td align="left" colspan="2">
    <font size=2>
EOT
	if(exists $moderators{$username} || $settings[7] eq 'Administrator') {
		print << "EOT";
	 $txt{'137'}: <a href="$cgi&action=movethread&thread=$viewnum">$txt{'132'}</a>,
	<a href="$cgi&action=removethread&thread=$viewnum">$txt{'63'}</a>,
	<a href="$cgi&action=lock&thread=$viewnum">$txt{'104'}</a>
EOT
	}
	print << "EOT";
    </font></td>
    <td align="right"><form action="$scripturl" method="GET">
    <font size=1>$txt{'160'}: <select name="board">$selecthtml</select> <input type=submit value="$txt{'161'}"></form></td>
  </tr>
</table>
EOT
	&footer;
	exit;
}
