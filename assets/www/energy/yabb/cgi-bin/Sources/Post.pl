###############################################################################
# Post.pl                                                                     #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Zef Hemel                                    #
###############################################################################

sub Post {
	if($username eq "Guest" && $enable_guestposting == 0) {
		&fatal_error("$txt{'165'}");
	}
	open(FILE, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
	&lock(FILE);
	@threads = <FILE>;
	&unlock(FILE);
	close(FILE);
	for ($x = 0; $x < @threads; $x++) {
($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split(/\|/,$threads[$x]);
		if ($INFO{'num'} eq $mnum && $mstate==1) {
			&fatal_error("$txt{'90'}");
			$x=@threads;
		}
	}
	
	if($enable_notification) {
	 $notification = <<"EOT";
<tr>
	<td><b>$txt{'131'}:</b><//td>
	<td><input type=checkbox name="notify" value="x"></td>
</tr>
EOT
	}

	$title="$INFO{'title'}";
	&header;
	if($realname ne "") { $name_field = "$realname<input type=hidden name=name value=\"$realname\">"; }
	else { $name_field = "<input type=text name=name size=50 value=\"$form_name\">"; }
	if($realemail ne "") { $email_field = "$realemail<input type=hidden name=email value=\"$realemail\">"; }
	else { $email_field = "<input type=text name=email size=50 value=\"$form_name\">"; }

	if($INFO{'num'} ne "") {
		open(FILE, "$datadir/$INFO{'num'}.txt") || &fatal_error("$txt{'23'} $INFO{'num'}.txt");
		&lock(FILE);
		@messages = <FILE>;
		&unlock(FILE);
		close(FILE);
		($msubject, $mname, $memail, $mdate, $musername, $micon, $mattache, $mip, $mmessage) = split(/\|/,$messages[0]);
		$msubject =~ s/Re: //g;
		$form_subject = "Re: $msubject";

		if($INFO{'quote'} ne "") {
			($msubject, $mname, $memail, $mdate, $musername, $micon, $mattache, $mip, $mmessage) = split(/\|/,$messages[$INFO{'quote'}]);
			$form_message="$mmessage";
			$form_message =~ s/\[quote\](\S+?)\[\/quote\]//isg;
			$form_message =~ s/\[(\S+?)\]//isg;
			$form_message =~ s/<br>/\n/g;
			$form_message = "\n\n\[quote\]$form_message\[/quote\]";
			$msubject =~ s/Re: //g;
			$form_subject = "Re: $msubject";
		}
	}
	print <<"EOT";
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$title</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}">
<form action="$cgi&action=post2&start=$INFO{'start'}" method=post name="creator">
<input type=hidden name=followto value=$INFO{'num'}>
<table border=0>
<tr>
	<td><b>$txt{'68'}:</b></td>
	<td>$name_field</td>
</tr>
<tr>
	<td><b>$txt{'69'}:</b></td>
	<td>$email_field</td>
</tr>
<tr>
	<td><b>$txt{'70'}:</b></td>
	<td><input type=text name="subject" value="$form_subject" size="40" maxlength="50"></td>
</tr>
<tr>
	<td><b>$txt{'71'}:</b></td>
	<td><script language="javascript">
function showimage()
{
//alert("$imagesdir/"+document.creator.icon.options[document.creator.icon.selectedIndex].value+".gif");
document.images.icons.src="$imagesdir/"+document.creator.icon.options[document.creator.icon.selectedIndex].value+".gif";
}
</script>
<select name="icon" onChange="showimage()">
	<option value="xx">Standard
	<option value="thumbup">Thumb Up
	<option value="thumbdown">Thumb Down
	<option value="exclamation">Exclamation point
	<option value="question">Question mark
	<option value="lamp">Lamp
	<option value="smiley">Smiley
	<option value="angry">Angry
	<option value="cheesy">Cheesy
	<option value="laugh">Laugh
	<option value="sad">Sad
	<option value="wink">Wink
        <option value="heart">Heart
	</select>
	<img src="$imagesdir/xx.gif" name="icons" width="16" height="16" border=0 hspace=15></td>
</tr>
<tr>
	<td valign=top><b>$txt{'72'}:</b></td>
	<td><textarea name=message rows=10 cols=50 wrap=virtual>$form_message</textarea></td>
</tr>
$notification
<tr>
	<td align=center colspan=2><input type=submit value="$txt{'105'}">
	<input type=reset value="Reset Form"></td>
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

sub Post2 {
	if($username eq "Guest" && $enable_guestposting == 0) {
		&fatal_error("$txt{'165'}");
	}

	$name = $FORM{'name'};
	$email = $FORM{'email'};
	$subject = $FORM{'subject'};
	$message = $FORM{'message'};
	$icon = "$FORM{'icon'}";

	&fatal_error("$txt{'75'}") unless($name);
	&fatal_error("$txt{'76'}") unless($email);
	&fatal_error("$txt{'77'}") unless($subject);
	&fatal_error("$txt{'78'}") unless($message);

	$name =~ s/\&/\&amp;/g;
	$email =~ s/\&/\&amp;/g;
	$subject =~ s/\&/\&amp;/g;
	$message =~ s/\&/\&amp;/g;
	$name =~ s/"/\&quot;/g;
	$email =~ s/"/\&quot;/g;
	$subject =~ s/"/\&quot;/g;
	$message =~ s/"/\&quot;/g;
	$name =~ s/  / \&nbsp;/g;
	$email =~ s/  / \&nbsp;/g;
	$subject =~ s/  / \&nbsp;/g;
	$message =~ s/  / \&nbsp;/g;
	$name =~ s/</&lt;/g;
	$name =~ s/>/&gt;/g;
	$name =~ s/\|//g;
	$email =~ s/</&lt;/g;
	$email =~ s/>/&gt;/g;
	$email =~ s/\|//g;
	$subject =~ s/</&lt;/g;
	$subject =~ s/>/&gt;/g;
	$subject =~ s/\|//g;
	$message =~ s/</&lt;/g;
	$message =~ s/>/&gt;/g;
	$message =~ s/\t/ \&nbsp; \&nbsp; \&nbsp;/g;
	$message =~ s/\cM//g;
	$message =~ s/\n/<br>/g;
	$message =~ s/\|//g;

	if($FORM{'followto'} eq "") {
		open(FILE, "$vardir/number.txt");
		&lock(FILE);
		$postnum = <FILE>;
		$postnum =~ s/\n//g;
		$postnum =~ s/\r//g;
		++$postnum;
		&unlock(FILE);
		close(FILE);
		open(FILE, ">$vardir/number.txt");
		&lock(FILE);
		print FILE "$postnum";
		&unlock(FILE);
		close(FILE);
	}
	
	open (FILE, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.dat");
	&lock(FILE);
	@messages = <FILE>;
	&unlock(FILE);
	close (FILE);
	open (FILE, ">$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.dat");
	&lock(FILE);
	$followto = $FORM{'followto'};
	if($followto eq "") {
		print FILE "$postnum\|$subject\|$name\|$email\|$date\|0\|$musername\|$FORM{'icon'}\|0\|$message\n";
		print FILE @messages;
	} else {
		for ($a = 0; $a < @messages; $a++) {
			($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mattach) = split(/\|/,$messages[$a]);
			$mattach =~ s/\n//g;
			$mattach =~ s/\r//g;
			++$mreplies;
			if ($mnum == $followto) {
				print FILE "$mnum\|$msub\|$mname\|$memail\|$date\|$mreplies\|$musername\|$micon\|$mattach\n";
			}
		}
		for ($a = 0; $a < @messages; $a++) {
			($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mattach) = split(/\|/,$messages[$a]);
			$mattach =~ s/\n//g;
			$mattach =~ s/\r//g;
			if ($mnum == $followto) { } else { print FILE "$messages[$a]"; }
		}
	}
	&unlock(FILE);
	close(FILE);

	if($username ne "Guest") {
		$settings[6] =~ s/\n//g;
		$settings[6] =~ s/\r//g;
		++$settings[6];
		open(FILE, ">$memberdir/$username.dat");
		&lock(FILE);
		print FILE "$settings[0]\n";
		print FILE "$settings[1]\n";
		print FILE "$settings[2]\n";
		print FILE "$settings[3]\n";
		print FILE "$settings[4]\n";
		print FILE "$settings[5]\n";
		print FILE "$settings[6]\n";
		print FILE "$settings[7]\n";
		print FILE "$settings[8]\n";
		&unlock(FILE);
		close(FILE);
	}

	if(-e("$datadir/$followto.txt")) {
		open(FILE, ">>$datadir/$followto.txt") || &fatal_error("$txt{'23'} $followto.txt");
	} else {
		open(FILE, ">$datadir/$postnum.txt") || &fatal_error("$txt{'23'} $postnum.txt");
	}
	&lock(FILE);
	print FILE "$subject\|$name\|$email\|$date\|$username\|$icon\|0\|$ENV{REMOTE_ADDR}\|$message\n";
	&unlock(FILE);
	close (FILE);
	
	if(-e("$datadir/$followto.txt")) {
		$thread="$followto";
	} else {
		$thread="$postnum";
	}
	if(-e("$datadir/$thread.mail")) { &NotifyUsers; }
	#$cookiename="$currentboard$cookieusername$username";
	#print 'Set-Cookie: ' . $cookiename . '=' . $date . ';';
	#print ' expires=' . $Cookie_Exp_Date . ';';
	#print "\n";
	$writedate = "$date";
	&writelog("$currentboard");


	if($FORM{'notify'}) {
		require "$sourcedir/Notify.pl";
		print "Location: $cgi\&action=notify2\&thread=$thread\n\n"; }
	else { 	print "Location: $cgi\&action=display\&num=$thread\&start=$INFO{'start'}\n\n"; }
	exit;
}

sub NotifyUsers {
	open(FILE, "$datadir/$thread.mail");
	@mails = <FILE>;
	close(FILE);
	foreach $curmail (@mails) {
		$curmail =~ s/\n//g;
		$curmail =~ s/\r//g;
		open (MAIL, "|$mailprog -t");
		print MAIL "To: $curmail\n";
		print MAIL "From: $webmaster_email\n";
		print MAIL "Subject: $txt{'127'}\: $subject\n\n";
		print MAIL <<"EOT";
$txt{'128'} $subject $txt{'129'} $cgi&action=display&num=$thread

$txt{'130'}
EOT
		close(MAIL);
	}
}

##################################################### ADDITION HERE VV

sub doshowthread {

	if (@messages) { # start if messages exist, then display

	print qq~
	
	<table cellspacing=1 cellpadding=0 width=600 align=center bgcolor=#ffffff>
	<tr><td>
	<table cellspacing=1 cellpadding=2 width=600 align=center bgcolor="$color{'windowbg'}">
	<tr><td bgcolor="$color{'titlebg'}" colspan=2><font color="$color{'titletext'}">
	<b>Thread Summary</b>
	</td></tr>
	
	~;
	require "$sourcedir/Display.pl";

	foreach $line (@messages) { #start for each
	
	($trash, $tempname, $trash, $tempdate, $trash, $trash, $trash, $trash, $temppost) = split(/\|/,$line);
	
	$message = "$temppost";	
	&DoUBBC;
print qq~

<tr bgcolor="$color{'catbg'}"><td align=left>
<font size=1>Posted by: $tempname</font></td>
<td bgcolor="$color{'catbg'}" align=right>
<font size=1>Posted on: $tempdate</font></td>
</tr>
<tr><td colspan=2 bgcolor="$color{'windowbg2'}">
<font size=1>$message</font>
</td></tr>

~;
	} #end for each

print "</table></td></tr></table>\n";

 } # end if messages exist
 
 else { print "<!--no summary-->"; }



}

##################################################### ADDITION HERE ^^






1;
