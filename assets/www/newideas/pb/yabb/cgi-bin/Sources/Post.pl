###############################################################################
# Post.pl                                                                     #
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

$postplver="1 Gold Beta4";

sub Post {
	if($username eq 'Guest' && $enable_guestposting == 0) { &fatal_error("$txt{'165'}"); }
	if($currentboard ne '') { &DPPrivate; }
	else { &fatal_error($txt{'1'}); }

	my $threadid = $INFO{'num'};
	my $quotemsg = $INFO{'quote'};

	open(FILE, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
	&lock(FILE);
	@threads = <FILE>;
	&unlock(FILE);
	close(FILE);

	for ($x = 0; $x < @threads; $x++) {
		chomp $threads[$x];
		($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split(/\|/,$threads[$x]);
		if ($threadid eq $mnum ) {
			if( $mstate == 1 ) {
				&fatal_error($txt{'90'});
			}
			last;
		}
	}


	$notification = ! $enable_notification || $username eq 'Guest' ? '' : <<"EOT";
<tr>
	<td align="right"><p>$txt{'131'}:</p></td>
	<td><p><input type=checkbox name="notify" value="x"></p></td>
</tr>
EOT

	$yytitle=$INFO{'title'};
	&header;

	$name_field = $realname eq '' ? qq~<input type=text name=name size=50 value="$form_name">~ : qq~$realname~;

	$email_field = $realemail eq '' ? qq~<input type=text name=email size=50 value="$form_name">~ : qq~$realemail~;

	if( $threadid ne '' ) {
		open(FILE, "$datadir/$threadid.txt") || &fatal_error("$txt{'23'} $threadid.txt");
		&lock(FILE);
		@messages = <FILE>;
		&unlock(FILE);
		close(FILE);

		if($quotemsg ne '') {
			($msubject, $mname, $memail, $mdate, $musername, $micon, $mattache, $mip, $mmessage, $mns) = split(/\|/,$messages[$quotemsg]);
			$form_message="$mmessage";
			$form_message =~ s/\[quote\](\S+?)\[\/quote\]//isg;
			$form_message =~ s/\[(\S+?)\]//isg;
			$form_message =~ s/<br>/\n/g;

			$quotestart = int( $quotemsg / $maxmessagedisplay ) * $maxmessagedisplay;
			$form_message = qq~\n\n\[quote author=$mname link=board=$currentboard&num=$threadid&start=$quotestart#$quotemsg date=$mdate\]$form_message\[/quote\]~;
			$msubject =~ s/\bre:\s+//ig;
			$form_subject = "Re: $msubject";
		}
		else {
			($msubject, $mname, $memail, $mdate, $musername, $micon, $mattache, $mip, $mmessage, $mns) = split(/\|/,$messages[0]);
			$msubject =~ s/\bre:\s+//ig;
			$form_subject = "Re: $msubject";
		}
	}
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
	<td class="title1" bgcolor="$color{'titlebg'}"><p>$yytitle</p></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}">
<form action="$cgi&action=post2" method="post" name="postmodify" onSubmit="submitonce(this);">
<input type="hidden" name="threadid" value="$threadid">
<table border=0 cellpadding="3">
<tr>
	<td align="right"><p>$txt{'68'}:</p></td>
	<td><p>$name_field</p></td>
</tr>
<tr>
	<td align="right"><p>$txt{'69'}:</p></td>
	<td><p>$email_field</p></td>
</tr>
<tr>
	<td align="right"><p>$txt{'70'}:</p></td>
	<td><p><input type=text name="subject" value="$form_subject" size="40" maxlength="50"></p></td>
</tr>
<tr>
	<td align="right"><p>$txt{'71'}:</p></td>
	<td>
<select name="icon" onChange="showimage()">
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
	<img src="$imagesdir/xx.gif" name="icons" border=0 hspace=15></td>
</tr>
<tr>
<td align="right"><p>$txt{'252'}:</p></td>
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
else { document.write("<p>$txt{'215'}</p>"); }
//-->
</script>
<noscript>
<p>$txt{'215'}</p>
</noscript>

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
else { document.write("<p>$txt{'215'}</p>"); }
//-->
</script>
<noscript>
<p>$txt{'215'}</p>
</noscript>

</td>
</tr>
<tr>
<td align="right"><p>$txt{'297'}:</p></td>
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
else { document.write("<p>$txt{'215'}</p>"); }
//-->
</script>
<noscript>
<p>$txt{'215'}</p>
</noscript>
</td>
</tr>
<tr>
	<td valign=top align="right"><p>$txt{'72'}:</p></td>
	<td><p><textarea name=message rows=12 cols=52 wrap=virtual>$form_message</textarea></td>
</tr>
$notification
<tr>
	<td align="right"><p>$txt{'276'}:</p><BR><BR></td>
	<td><input type=checkbox name="ns" value="NS"> <p> $txt{'277'}</p><BR><BR></td>
</tr>
<tr>
	<td align="center" colspan="2">
	<input type="hidden" name="waction" value="preview">
	<input type="submit" name="preview" value="$txt{'507'}" onClick="WhichClicked('preview');">
	<input type="submit" name="post" value="$txt{'105'}" onClick="WhichClicked('post');">
	<input type="reset" value="$txt{'278'}">
	</td>
</tr>
<tr>
<td colspan=2></td>
</tr>
</table></form>
</td>
</tr>
</table>
EOT
	&doshowthread;
	&footer;
	exit;
}

sub Preview {

	$name = $FORM{'name'};
	$email = $FORM{'email'};
	$subject = $FORM{'subject'};
	$message = $FORM{'message'};
 	$icon = $FORM{'icon'};
	$ns = $FORM{'ns'};
	$threadid = $FORM{'threadid'};
	$notify = $FORM{'notify'};
	if (length($subject) > 50) { $subject = substr($subject,0,50); }
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
	&CheckIcon;

	if ($username eq 'Guest') {
		open(FILE, "$memberdir/memberlist.txt");
		&lock(FILE);
		@memberlist = <FILE>;
		&unlock(FILE);
		close(FILE);
		if(exists $memberlist{$name}) { &fatal_error($txt{'100'}); }
		for ($a = 0; $a < @memberlist; $a++) {
			chomp $memberlist[$a];
			open(FILE2, "$memberdir/$memberlist[$a].dat");
			&lock(FILE2);
			$tmpa = <FILE2>;
			$realname = <FILE2>;
			&unlock(FILE2);
			close(FILE2);
			chomp $realname;
			if ($realname eq $name) { &fatal_error($txt{'100'}); }
		}
	}
	if($enable_ubbc) { &DoUBBC; }
	$yytitle = "$txt{'507'} - $subject";
	if( $FORM{'waction'} eq 'previewmodify' ) {
		$destination = 'modify2';
		$submittxt = $txt{'10'};
	}
	else {
		$destination = 'post2';
		$submittxt = $txt{'105'};
	}

	$csubject = $subject;
	open(FILE,"$vardir/censor.txt");
	&lock(FILE);
	while( chomp( $buffer = <FILE> ) ) {
		($tmpa,$tmpb) = split(/=/,$buffer);
		push(@censored,[$tmpa,$tmpb]);
		$csubject =~ s/\Q$tmpa\E/$tmpb/gi;
		$message =~ s/\Q$tmpa\E/$tmpb/gi;
	}
	&unlock(FILE);
	close(FILE);

	&header;
	print<<"EOT";
<script language="JavaScript1.2" src="$ubbcjspath" type="text/javascript"></script>
<table border=0 width="70%" cellspacing=1 bgcolor="$color{'bordercolor'}" align="center">
  <tr>
    <td class="title1" bgcolor="$color{'titlebg'}"><p>$csubject</p></td>
  </tr><tr>
    <td class="form1" bgcolor="$color{'windowbg'}"><p>$message</p></td>
  </tr><tr>
    <td align="center" valign="middle" bgcolor="$color{'titlebg'}">
    <form action="$cgi&action=$destination" method="post" name="postmodify" onSubmit="submitonce(this);">
    <input type="hidden" name="threadid" value="$FORM{'threadid'}">
    <input type="hidden" name="postid" value="$FORM{'postid'}">
    <input type="hidden" name="name" value="$FORM{'name'}">
    <input type="hidden" name="email" value="$FORM{'email'}">
    <input type="hidden" name="subject" value="$FORM{'subject'}">
    <input type="hidden" name="notify" value="$FORM{'notify'}">
EOT
	$FORM{'message'} =~ s/\&/\&amp;/g;
	$FORM{'message'} =~ s/"/\&quot;/g;
	$FORM{'message'} =~ s/  / \&nbsp;/g;
	$FORM{'message'} =~ s/</&lt;/g;
	$FORM{'message'} =~ s/>/&gt;/g;
	$FORM{'message'} =~ s/\t/ \&nbsp; \&nbsp; \&nbsp;/g;
	$FORM{'message'} =~ s/\cM//g;
	$FORM{'message'} =~ s~(\S{80})(?=\S)~$1\n~g;
	$FORM{'message'} =~ s/\|/\&#124;/g;
print<<"EOT";
    <input type="hidden" name="message" value="$FORM{'message'}">
    <input type="hidden" name="icon" value="$FORM{'icon'}">
    <input type="hidden" name="ns" value="$FORM{'ns'}">
    <input type="submit" name="donepreview" value="$submittxt">
    </td>
  </tr>
</table>
<center><BR><a href="javascript:history.go(-1)">$txt{'250'}</a></center>
</form>
EOT
&footer;
exit;
}

sub Post2 {
	if($username eq 'Guest' && $enable_guestposting == 0) {	&fatal_error($txt{'165'}); }
	if($currentboard ne '') { &DPPrivate; }

	if(!$settings[2]) {
		$FORM{'name'} =~ s/\A\s+//;
		$FORM{'name'} =~ s/\s+\Z//;
		&fatal_error($txt{'75'}) unless ($FORM{'name'} ne "");
		&fatal_error("$txt{'500'}") if(($FORM{'email'} =~ /(@.*@)|(\.\.)|(@\.)|(\.@)|(^\.)|(\.$)/) || ($FORM{'email'} !~ /^.+@\[?(\w|[-.])+\.[a-zA-Z]{2,4}|[0-9]{1,4}\]?$/));
		&fatal_error("$txt{'243'}") if($FORM{'email'} !~ /^[0-9A-Za-z@\._\-]+$/);
	}
	$name = $FORM{'name'};
	$email = $FORM{'email'};
	$subject = $FORM{'subject'};
	$message = $FORM{'message'};
 	$icon = $FORM{'icon'};
	$ns = $FORM{'ns'};
	$threadid = $FORM{'threadid'};
	$notify = $FORM{'notify'};

	if($name && $email) {
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
	}

	&fatal_error($txt{'75'}) unless($username || $name);
	&fatal_error($txt{'76'}) unless($settings[2] || $email);
	&fatal_error($txt{'77'}) unless($subject);
	&fatal_error($txt{'78'}) unless($message);
	if (length($message)>$MaxMessLen) { &fatal_error($txt{'499'}); }

	if( $FORM{'waction'} eq 'preview' ) { &Preview; }
	&spam_protection;

	if (length($subject) > 50) { $subject = substr($subject,0,50); }
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
	&CheckIcon;

	if(-e("$datadir/.txt")) { unlink("$datadir/.txt"); }

	if ($username ne 'Guest') {
		$name = $settings[1];
		$email = $settings[2];
	} else {
		open(FILE, "$memberdir/memberlist.txt") || &fatal_error("$txt{'23'} $memberlist.txt");
		&lock(FILE);
		@memberlist = <FILE>;
		&unlock(FILE);
		close(FILE);
		$testname = lc $name;
		for ($a = 0; $a < @memberlist; $a++) {
			chomp $memberlist[$a];
			open(FILE2, "$memberdir/$memberlist[$a].dat") || &fatal_error("$txt{'23'} $memberlist[$a].dat");
			&lock(FILE2);
			$tmpa = <FILE2>;
			$realname = <FILE2>;
			&unlock(FILE2);
			close(FILE2);
			chomp $realname;
			$realname = lc $realname;
			$membername = lc $memberlist[$a];
			if ($realname eq $testname || $membername eq $testname) { &fatal_error($txt{'100'}); }
		}

		open(FILE, "$vardir/reserve.txt") || &fatal_error("$txt{'23'} reserve.txt");
		&lock(FILE);
		@reserve = <FILE>;
		&unlock(FILE);
		close(FILE);
		open(FILE, "$vardir/reservecfg.txt") || &fatal_error("$txt{'23'} reservecfg.txt");
		&lock(FILE);
		@reservecfg = <FILE>;
		&unlock(FILE);
		close(FILE);
		for( $a = 0; $a < @reservecfg; $a++ ) {
			chomp $reservecfg[$a];
		}
		$matchword = $reservecfg[0] eq 'checked';
		$matchcase = $reservecfg[1] eq 'checked';
		$matchuser = $reservecfg[2] eq 'checked';
		$matchname = $reservecfg[3] eq 'checked';
		$namecheck = $matchcase eq 'checked' ? $name : lc $name;

		foreach $reserved (@reserve) {
			chomp $reserved;
			$reservecheck = $matchcase ? $reserved : lc $reserved;
			if ($matchname) {
				if ($matchword) {
					if ($namecheck eq $reservecheck) { &fatal_error("$txt{'244'} $reserved"); }
				}
				else {
					if ($namecheck =~ $reservecheck) { &fatal_error("$txt{'244'} $reserved"); }
				}
			}
		}
	}

	if($threadid eq '') {
		$newthreadid = time;
		$i=0;
		if (-e "$datadir/$newthreadid.txt") {
			while (-e "$datadir/$newthreadid$i.txt") { ++$i; }
			$newthreadid="$newthreadid$i";
		}
	}
	else { $newthreadid = ''; }

	open (FILE, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.dat");
	&lock(FILE);
	@messages = <FILE>;
	&unlock(FILE);
	close (FILE);

	open (FILE, ">$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.dat");
	&lock(FILE);
	if($newthreadid) {
		print FILE qq~$newthreadid|$subject|$name|$email|$date|0|$username|$icon|0\n~;
		print FILE @messages;
		open(TFILE, ">$datadir/$newthreadid.txt") || &fatal_error("$txt{'23'} $newthreadid.txt");
		&lock(TFILE);
		print TFILE qq~$subject|$name|$email|$date|$username|$icon|0|$ENV{REMOTE_ADDR}|$message|$ns|\n~;
		&unlock(TFILE);
		close(TFILE);
		$mreplies = 0;
	} else {
		for ($a = 0; $a < @messages; $a++) {
			$_ = $messages[$a];
			chomp;
			($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split(/\|/,$_);
			if ($mnum == $threadid) {
				++$mreplies;
				print FILE qq~$mnum|$msub|$mname|$memail|$date|$mreplies|$musername|$micon|$mstate\n~;
				$messages[$a] = '';
				last;
			}
		}
		print FILE @messages;
		open(TFILE, ">>$datadir/$threadid.txt") || &fatal_error("$txt{'23'} $threadid.txt");
		&lock(TFILE);
		print TFILE qq~$subject|$name|$email|$date|$username|$icon|0|$ENV{REMOTE_ADDR}|$message|$ns|\n~;
		&unlock(TFILE);
		close(TFILE);
	}
	&unlock(FILE);
	close(FILE);

	if($username ne 'Guest') {
		$settings[6] =~ s/[\n\r]//g;
		++$settings[6];
		open(FILE, ">$memberdir/$username.dat") || &fatal_error("$txt{'23'} $username.dat");
		&lock(FILE);
		foreach (@settings) {
			print FILE qq~$_\n~;
		}
		&unlock(FILE);
		close(FILE);
	}

	$thread = $newthreadid || $threadid;

	&doaddition;
	if(-e("$datadir/$thread.mail")) {
		&NotifyUsers;
	}

	&dumplog($currentboard,$date);

	# Let's figure out what page to show #
	$start=0;
	$pageindex = int($mreplies / $maxmessagedisplay);
	$start = $pageindex * $maxmessagedisplay;

	if($notify) {
		require "$sourcedir/Notify.pl";
		print "Location: $cgi&action=notify2&thread=$thread\n\n";
	}
	else { print "Location: $cgi&action=display&num=$thread&start=$start\n\n"; }

	exit;
}

sub NotifyUsers {
	if($currentboard ne '') { &DPPrivate; }
	open(FILE, "$datadir/$thread.mail");
	@mails = <FILE>;
	close(FILE);
	foreach $curmail (@mails) {
		chomp $curmail;
		if ($curmail ne $settings[2]) {
			&sendmail($curmail,"$txt{'127'}\: $subject","$txt{'128'} $subject $txt{'129'} $cgi&action=display&num=$thread\n$txt{'130'}");
		}
	}
}

sub doshowthread {
	my(@censored);
	open(FILE,"$vardir/censor.txt");
	&lock(FILE);
	while( chomp( $buffer = <FILE> ) ) {
		($tmpa,$tmpb) = split(/=/,$buffer);
		push(@censored,[$tmpa,$tmpb]);
		$msubthread =~ s/\Q$tmpa\E/$tmpb/gi;
	}
	&unlock(FILE);
	close(FILE);

	if (@messages) {
		print qq~
	<table cellspacing=1 cellpadding=0 width=100% align=center bgcolor="$color{'bordercolor'}">
	<tr><td>
	<table class="form1" cellspacing=1 cellpadding=2 width=100% align=center bgcolor="$color{'windowbg'}">
	<tr><td class="title1" bgcolor="$color{'titlebg'}" colspan=2><p>
	$txt{'468'}
	</td></tr>~;
		foreach $line (@messages) { #start for each

			($trash, $tempname, $trash, $tempdate, $trash, $trash, $trash, $trash, $temppost) = split(/\|/,$line);
			$tempdate = &timeformat($tempdate);
			$message = "$temppost";
			foreach (@censored) {
				($tmpa,$tmpb) = @{$_};
				$message =~ s~\Q$tmpa\E~$tmpb~gi;
			}
			if($enable_ubbc) { &DoUBBC; }
			print qq~

<tr class="cat1" bgcolor="$color{'catbg'}"><td align=left>
<p>$txt{'279'}: $tempname</p></td>
<td class="cat1" bgcolor="$color{'catbg'}" align=right>
<p>$txt{'280'}: $tempdate</p></td>
</tr>
<tr><td class="form2" colspan=2 bgcolor="$color{'windowbg2'}">
<p>$message</p>
</td></tr>~;
		}
		print "</table></td></tr></table>\n";
	}
	else { print "<!--no summary-->"; }
}

sub doaddition {

		open(FILE, "+>$boardsdir/$currentboard.poster");
		&lock(FILE);
		print FILE $name;
		&unlock(FILE);
		close(FILE);


		open(FILE2, "$datadir/$thread.data");
		&lock(FILE2);
		$tempinfo = <FILE2>;
		&unlock(FILE2);
		close(FILE2);

		($views, $lastposter) = split(/\|/,$tempinfo);

		my( $threadcount, $messagecount, $lastposttime, $lastposter ) = &BoardCountGet($currentboard);
		++$messagecount;
		unless( $FORM{'threadid'} ) {
			++$threadcount;
		}
		$myname = $username eq 'Guest' ? qq~Guest-$name~ : $username;
		&BoardCountSet( $currentboard, $threadcount, $messagecount, $date, $myname );

		open(FILE2, "+>$datadir/$thread.data");
		&lock(FILE2);
		print FILE2 "$views|$myname";
		&unlock(FILE2);
		close(FILE2);
}

1;
