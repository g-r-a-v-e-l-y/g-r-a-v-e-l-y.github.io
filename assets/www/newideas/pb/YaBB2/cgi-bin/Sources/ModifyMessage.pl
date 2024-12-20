###############################################################################
# ModifyMessage.pl                                                            #
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

$modifymessageplver="1 Gold Beta4";

sub ModifyMessage {
	if($username eq 'Guest') { &fatal_error($txt{'223'}); }

	my $threadid = $INFO{'thread'};
	my $postid = int( $INFO{'message'} );

	open(FILE, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
	&lock(FILE);
	@threads = <FILE>;
	&unlock(FILE);
	close(FILE);

	for ($x = 0; $x < @threads; $x++) {
		chomp $threads[$x];
		($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split(/\|/,$threads[$x]);
		if ($threadid eq $mnum && $mstate==1) {
			if( $mstate == 1 ) {
				&fatal_error($txt{'90'});
			}
			last;
		}
	}

	$yytitle = "$txt{'66'}";

	open (FILE, "$datadir/$threadid.txt") || &fatal_error("$txt{'23'} $threadid.txt");
	&lock(FILE);
	@messages = <FILE>;
	&unlock(FILE);
	close(FILE);

	$curmessage = $messages[$postid];
	chomp $curmessage;
	($msubject, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip,  $mmessage, $mns, $mlm, $mlmb) = split(/\|/,$messages[$postid]);

	if($musername ne $username && (!exists $moderators{$username}) && $settings[7] ne 'Administrator' ) {
		&fatal_error($txt{'67'});
	}

	$lastmodification = $mlm ? &timeformat($mlm) : '-';
	$nosmiley = $mns ? ' checked' : '';

	$mmessage =~ s/<br>/\n/ig;

	&header;
print <<"EOT";
<script language="JavaScript1.2" src="$ubbcjspath" type="text/javascript"></script>

<script language="JavaScript1.2" type="text/javascript">
<!--
function showimage()
{
	document.images.icons.src="$imagesdir/"+document.postmodify.icon.options[document.postmodify.icon.selectedIndex].value+".gif";
}
//-->
</script>

<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'66'}</font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}">
<form action="$cgi&action=modify2" method=post name="postmodify" onSubmit="submitonce(this);">
<input type=hidden name="postid" value="$postid">
<input type=hidden name="threadid" value="$threadid">
<table border="0" cellpadding="3">
<tr>
	<td align="right"><font size=2>$txt{'68'}:</font></td>
	<td><font size=2>$mname</font></td>
</tr>
<tr>
	<td align="right"><font size=2>$txt{'69'}:</font></td>
	<td><font size=2>$memail</font></td>
</tr>
<tr>
	<td align="right"><font size=2>$txt{'70'}:</font></td>
	<td><font size=2><input type=text name="subject" value="$msubject" size="40" maxlength="50"></font></td>
</tr>
<tr>
	<td align="right"><font size=2>$txt{'71'}:</font></td>
	<td>
<select name="icon" onChange="showimage()">
	<option value="$micon">$txt{'112'}
	<option value="$micon">------------
	<option value="xx">$txt{'281'}
	<option value="thumbup">$txt{'282'}
	<option value="thumbdown">$txt{'283'}
	<option value="exclamation">$txt{'284'}
	<option value="question">$txt{'285'}
	<option value="lamp">$txt{'286'}
	<option value="smiley">$txt{'287'}
	<option value="angry">$txt{'288'}
	<option value="cheesy">$txt{'289'}
	<option value="laugh">$txt{'290'}
	<option value="sad">$txt{'291'}
	<option value="wink">$txt{'292'}
	</select>
	<img src="$imagesdir/$micon.gif" name="icons" border=0 hspace=15></td>
</tr>
<tr>
<td align="right"><font size=2>$txt{'252'}:</font></td>
<td valign=middle>
<script language="JavaScript1.2" type="text/javascript">
<!--
if((navigator.appName == "Netscape" && navigator.appVersion.charAt(0) >= 4) || (navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.charAt(0) >= 4) || (navigator.appName == "Opera" && navigator.appVersion.charAt(0) >= 4)) {
	document.write("<a href=javascript:bold()><img src='$imagesdir/bold.gif' align=bottom width=23 height=22 alt='$txt{'253'}' border=0></a>");
	document.write("<a href=javascript:italicize()><img src='$imagesdir/italicize.gif' align=bottom width=23 height=22 alt='$txt{'254'}' border='0'></a>");
	document.write("<a href=javascript:underline()><img src='$imagesdir/underline.gif' align=bottom width=23 height=22 alt='$txt{'255'}' border='0'></a>");
	document.write("<a href=javascript:strike()><img src='$imagesdir/strike.gif' align=bottom width=23 height=22 alt='$txt{'441'}' border='0'></a>");
	document.write("<a href=javascript:glow()><img src='$imagesdir/glow.gif' align=bottom width=23 height=22 alt='$txt{'442'}' border='0'></a>");
	document.write("<a href=javascript:shadow()><img src='$imagesdir/shadow.gif' align=bottom width=23 height=22 alt='$txt{'443'}' border='0'></a>");
	document.write("<a href=javascript:move()><img src='$imagesdir/move.gif' align=bottom width=23 height=22 alt='$txt{'439'}' border='0'></a>");
	document.write("<a href=javascript:pre()><img src='$imagesdir/pre.gif' align=bottom width=23 height=22 alt='$txt{'444'}' border='0'></a>");
	document.write("<a href=javascript:left()><img src='$imagesdir/left.gif' align=bottom width=23 height=22 alt='$txt{'445'}' border='0'></a>");
	document.write("<a href=javascript:center()><img src='$imagesdir/center.gif' align=bottom width=23 height=22 alt='$txt{'256'}' border='0'></a>");
	document.write("<a href=javascript:right()><img src='$imagesdir/right.gif' align=bottom width=23 height=22 alt='$txt{'446'}' border='0'></a>");
}
else { document.write("<font size=1>$txt{'215'}</font>"); }
//-->
</script>

<select name="color" onChange="showcolor(this.options[this.selectedIndex].value)">
	<option value="Black" selected>$txt{'262'}</option>
	<option value="Red">$txt{'263'}</option>
	<option value="Yellow">$txt{'264'}</option>
	<option value="Pink">$txt{'265'}</option>
	<option value="Green">$txt{'266'}</option>
	<option value="Orange">$txt{'267'}</option>
	<option value="Purple">$txt{'268'}</option>
	<option value="Blue">$txt{'269'}</option>
	<option value="Beige">$txt{'270'}</option>
	<option value="Brown">$txt{'271'}</option>
	<option value="Teal">$txt{'272'}</option>
	<option value="Navy">$txt{'273'}</option>
	<option value="Maroon">$txt{'274'}</option>
	<option value="LimeGreen">$txt{'275'}</option>
</select>
<br>
<script language="JavaScript1.2" type="text/javascript">
<!--
if((navigator.appName == "Netscape" && navigator.appVersion.charAt(0) >= 4) || (navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.charAt(0) >= 4) || (navigator.appName == "Opera" && navigator.appVersion.charAt(0) >= 4)) {
	document.write("<a href=javascript:flash()><img src='$imagesdir/flash.gif' align=bottom width=23 height=22 alt='$txt{'433'}' border='0'></a>");
	document.write("<a href=javascript:hyperlink()><img src='$imagesdir/url.gif' align=bottom width=23 height=22 alt='$txt{'257'}' border='0'></a>");
	document.write("<a href=javascript:ftp()><img src='$imagesdir/ftp.gif' align=bottom width=23 height=22 alt='$txt{'434'}' border='0'></a>");
	document.write("<a href=javascript:image()><img src='$imagesdir/img.gif' align=bottom width=23 height=22 alt='$txt{'435'}' border='0'></a>");
	document.write("<a href=javascript:emai1()><img src='$imagesdir/email2.gif' align=bottom width=23 height=22 alt='$txt{'258'}' border='0'></a>");
	document.write("<a href=javascript:table()><img src='$imagesdir/table.gif' align=bottom width=23 height=22 alt='$txt{'436'}' border='0'></a>");
	document.write("<a href=javascript:trow()><img src='$imagesdir/tr.gif' align=bottom width=23 height=22 alt='$txt{'437'}' border='0'></a>");
	document.write("<a href=javascript:tcol()><img src='$imagesdir/td.gif' align=bottom width=23 height=22 alt='$txt{'449'}' border='0'></a>");
	document.write("<a href=javascript:superscript()><img src='$imagesdir/sup.gif' align=bottom width=23 height=22 alt='$txt{'447'}' border='0'></a>");
	document.write("<a href=javascript:subscript()><img src='$imagesdir/sub.gif' align=bottom width=23 height=22 alt='$txt{'448'}' border='0'></a>");
	document.write("<a href=javascript:teletype()><img src='$imagesdir/tele.gif' align=bottom width=23 height=22 alt='$txt{'440'}' border='0'></a>");
	document.write("<a href=javascript:showcode()><img src='$imagesdir/code.gif' align=bottom width=23 height=22 alt='$txt{'259'}' border='0'></a>");
	document.write("<a href=javascript:quote()><img src='$imagesdir/quote2.gif' align=bottom width=23 height=22 alt='$txt{'260'}' border='0'></a>");
	document.write("<a href=javascript:list()><img src='$imagesdir/list.gif' align=bottom width=23 height=22 alt='$txt{'261'}' border='0'></a>");

}
else { document.write("<font size=1>$txt{'215'}</font>"); }
//-->
</script>
</td>
</tr>
<tr>
<td align="right"><font size=2>$txt{'297'}:</font></td>
<td valign=middle>
<script language="JavaScript1.2" type="text/javascript">
<!--
if((navigator.appName == "Netscape" && navigator.appVersion.charAt(0) >= 4) || (navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.charAt(0) >= 4) || (navigator.appName == "Opera" && navigator.appVersion.charAt(0) >= 4)) {
	document.write("<a href=javascript:smiley()><img src='$imagesdir/smiley.gif' align=bottom alt='$txt{'287'}' border='0'></a> ");
	document.write("<a href=javascript:wink()><img src='$imagesdir/wink.gif' align=bottom alt='$txt{'292'}' border='0'></a> ");
	document.write("<a href=javascript:cheesy()><img src='$imagesdir/cheesy.gif' align=bottom alt='$txt{'289'}' border='0'></a> ");
	document.write("<a href=javascript:grin()><img src='$imagesdir/grin.gif' align=bottom alt='$txt{'293'}' border='0'></a> ");
	document.write("<a href=javascript:angry()><img src='$imagesdir/angry.gif' align=bottom alt='$txt{'288'}' border='0'></a> ");
	document.write("<a href=javascript:sad()><img src='$imagesdir/sad.gif' align=bottom alt='$txt{'291'}' border='0'></a> ");
	document.write("<a href=javascript:shocked()><img src='$imagesdir/shocked.gif' align=bottom alt='$txt{'294'}' border='0'></a> ");
	document.write("<a href=javascript:cool()><img src='$imagesdir/cool.gif' align=bottom alt='$txt{'295'}' border='0'></a> ");
	document.write("<a href=javascript:huh()><img src='$imagesdir/huh.gif' align=bottom alt='$txt{'296'}' border='0'></a> ");
	document.write("<a href=javascript:rolleyes()><img src='$imagesdir/rolleyes.gif' align=bottom alt='$txt{'450'}' border='0'></a> ");
	document.write("<a href=javascript:tongue()><img src='$imagesdir/tongue.gif' align=bottom alt='$txt{'451'}' border='0'></a> ");
}
else { document.write("<font size=1>$txt{'215'}</font>"); }
//-->
</script>
</td>
</tr>
<tr>
	<td valign=top align="right"><font size=2>$txt{'72'}:</font></td>
	<td><font size=2><textarea name=message rows=12 cols=52 wrap=virtual>$mmessage</textarea></td>
</tr>
<tr>
	<td valign=top align="right"><font size=2>$txt{'211'}:</font></td>
	<td><font size=2>$lastmodification</td>
</tr>
<tr>
      <td align="right"><font size=2>$txt{'276'}:</font><BR><BR></td>
      <td><font size=2><input type=checkbox name="ns" value="NS"$nosmiley></font>
      <font size=1>$txt{'277'}</font><BR><BR></td>
</tr>
<tr>
	<td align=center colspan=2>
	<input type="hidden" name="waction" value="previewmodify">
	<input type="submit" name="previewmodify" value="$txt{'507'}" onClick="WhichClicked('previewmodify');">
	<input type="submit" name="postmodify" value="$txt{'10'}" onClick="WhichClicked('postmodify');">
	<input type="submit" name="deletemodify" value="$txt{'31'}" onClick="WhichClicked('deletemodify');">
	<input type="reset" value="$txt{'278'}">
	</td>
</tr>
</table></form>
</td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub ModifyMessage2 {
	if($username eq 'Guest') { &fatal_error($txt{'223'}); }
	if( $FORM{'waction'} eq 'previewmodify' ) {
		require "$sourcedir/Post.pl";
		&Preview;
	}
	my( $deletepost, $threadid, $postid );
	$deletepost = $INFO{'d'} eq '1' || $FORM{'waction'} eq 'deletemodify';
	if( $deletepost ) {
		if( $FORM{'waction'} eq 'deletemodify' ) {
			$INFO{'id'} = $FORM{'postid'};
			$INFO{'thread'} = $FORM{'threadid'};
		}
		elsif( $INFO{'d'} eq 1 && $settings[7] ne 'Administrator' && ! exists $moderators{$username} ) {
			&fatal_error($txt{'73'});
		}
		$threadid = $INFO{'thread'};
		$postid = $INFO{'id'};
	}
	else {
		$threadid = $FORM{'threadid'};
		$postid = $FORM{'postid'};
	}

	open(FILE, "$datadir/$threadid.txt") || &fatal_error("$txt{'23'} $threadid.txt");
	&lock(FILE);
	@messages = <FILE>;
	&unlock(FILE);
	close(FILE);

	if( $postid >= 0 && $postid < @messages ) {
		($msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $mmessage, $mns, $mlm, $mlmb) = split( /\|/, $messages[$postid]);
		unless( $musername eq $username || exists $moderators{$username} || $settings[7] eq 'Administrator' ) {
			&fatal_error($txt{'67'});
		}
	}
	else { &fatal_error("BAD post number $postid"); }

	open(FILE, "$boardsdir/$currentboard.txt");
	&lock(FILE);
	@threads = <FILE>;
	&unlock(FILE);
	close(FILE);
	for( $threadnum = 0; $threadnum < @threads; $threadnum++ ) {
		($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mattach) = split( /\|/, $threads[$threadnum] );
		chomp $mattach;
		if( $mnum == $threadid ) {
			$threadfound = 1;
			last;
		}
	}

	unless( $threadfound ) {
		&fatal_error($txt{'472'});
	}

	if( $deletepost ) {
		--$mreplies;
		$postkilled = 1;
		if( $mreplies < 0 ) {
			$threads[$threadnum] = '';
			$threadkilled = 1;
			unlink("$datadir/$mnum.txt");
			unlink("$datadir/$mnum.mail");
			unlink("$datadir/$mnum.data");
			if( $threadnum == 0 ) {
				($mnum2, $tmpa, $tmpa, $tmpa, $mdate2) = split( /\|/, $threads[1] );
				if( $mnum2 ) {
					$newlastposttime = $mdate2;
					open(FILE, "$datadir/$mnum2.data");
					&lock(FILE);
					$tmpa = <FILE>;
					&unlock(FILE);
					close(FILE);
					($views,$newlastposter) = split(/\|/, $tmpa);
				}
				else {
					$newlastposttime = 'N/A';
					$newlastposter = 'N/A';
				}
			}
		}
		else {
			if( $postid == $#messages ) {
				($tmpa,$tmpa,$tmpa,$mdate) = split( /\|/, $messages[$postid-1] );
			}
			$threads[$threadnum] = qq~$mnum|$msub|$mname|$memail|$mdate|$mreplies|$musername|$micon|$mattach\n~;
			$messages[$postid] = '';
			if( $postid == $#messages ) {
				my $lastpostid = $postid - 1;
				chomp $messages[$lastpostid];
				($msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $mmessage, $mns, $mlm, $mlmb) = split( /\|/, $messages[$lastpostid] );
				if( $threadnum == 0 ) {
					$newlastposttime = $mdate;
					$newlastposter = $mname
				}
				open(FILE, "$datadir/$mnum.data");
				&lock(FILE);
				$tmpa = <FILE>;
				&unlock(FILE);
				close(FILE);
				($views,$tmpa) = split(/\|/, $tmpa);
				open(FILE, ">$datadir/$mnum.data");
				&lock(FILE);
				print FILE qq~$views|$mname~;
				&unlock(FILE);
				close(FILE);
			}
			open(FILE, ">$datadir/$threadid.txt") || &fatal_error("$txt{'23'} $threadid.txt");
			&lock(FILE);
			print FILE @messages;
			&unlock(FILE);
			close(FILE);
		}
		if( $musername ne 'Guest' ) {
			open(FILE, "$memberdir/$musername.dat");
			&lock(FILE);
			@userprofile = <FILE>;
			&unlock(FILE);
			close(FILE);
			chomp $userprofile[6];
			--$userprofile[6];
			$userprofile[6] .= "\n";
			open(FILE, "$memberdir/$musername.dat");
			&lock(FILE);
			print FILE @userprofile;
			&unlock(FILE);
			close(FILE);
		}
	}
	else {
		# not $deletepost
		$name = $FORM{'name'};
		$email = $FORM{'email'};
		$subject = $FORM{'subject'};
		$message = $FORM{'message'};
		$icon = $FORM{'icon'};
		$ns = $FORM{'ns'};
		&CheckIcon;

		$name =~ s/\&/\&amp;/g;
		$name =~ s/"/\&quot;/g;
		$name =~ s/  / \&nbsp;/g;
		$name =~ s/</&lt;/g;
		$name =~ s/>/&gt;/g;
		$name =~ s/\|/\&#124;/g;
		$email =~ s/\&/\&amp;/g;
		$email =~ s/"/\&quot;/g;
		$email =~ s/  / \&nbsp;/g;
		$email =~ s/</&lt;/g;
		$email =~ s/>/&gt;/g;
		$email =~ s/\|//g;
		$subject =~ s/\&/\&amp;/g;
		$subject =~ s/"/\&quot;/g;
		$subject =~ s/  / \&nbsp;/g;
		$subject =~ s/</&lt;/g;
		$subject =~ s/>/&gt;/g;
		$subject =~ s/\|/\&#124;/g;
		$message =~ s/\&/\&amp;/g;
		$message =~ s/"/\&quot;/g;
		$message =~ s/  / \&nbsp;/g;
		$message =~ s/</&lt;/g;
		$message =~ s/>/&gt;/g;
		$message =~ s/\t/ \&nbsp; \&nbsp; \&nbsp;/g;
		$message =~ s/\cM//g;
		$message =~ s~(\S{80})(?=\S)~$1\n~g;
		$message =~ s/\n/<br>/g;
		$message =~ s/\|/\&#124;/g;
		if( $postid == 0 ) {
			$msub = $subject;
		}
		$threads[$threadnum] = qq~$mnum|$msub|$mname|$memail|$mdate|$mreplies|$musername|$micon|$mattach\n~;
		($msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $mmessage, $mns, $mlm, $mlmb) = split( /\|/, $messages[$postid]);
		$lm = $showmodify == 1 ? $date : '';
		$messages[$postid] = qq~$subject|$mname|$memail|$mdate|$musername|$icon|0|$ENV{'REMOTE_ADDR'}|$message|$ns|$lm|$realname\n~;
		open(FILE, ">$datadir/$threadid.txt") || &fatal_error("$txt{'23'} $threadid.txt");
		&lock(FILE);
		print FILE @messages;
		&unlock(FILE);
		close(FILE);
	}
	open(FILE, ">$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
	&lock(FILE);
	print FILE @threads;
	&unlock(FILE);
	close(FILE);

	if( $postkilled ) {
		my( $threadcount, $messagecount, $lastposttime, $lastposter ) = &BoardCountGet($currentboard);
		--$messagecount;
		if( $threadkilled ) {
			--$threadcount;
		}
		&BoardCountSet( $currentboard, $threadcount, $messagecount, $newlastposttime || $lastposttime, $newlastposter || $lastposter );
	}

	if ($threadkilled) { print qq~Location: $cgi\n\n~; }
	else { print qq~Location: $cgi&action=display&num=$threadid\n\n~; }

	&dumplog($currentboard);
	exit;
}

1;