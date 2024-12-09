###############################################################################
# ModifyMessage.pl                                                            #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Zef Hemel                                    #
###############################################################################

sub ModifyMessage {
	open(FILE, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
	&lock(FILE);
	@threads = <FILE>;
	&unlock(FILE);
	close(FILE);
	for ($x = 0; $x < @threads; $x++) {
($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split(/\|/,$threads[$x]);
		if ($INFO{'thread'} eq $mnum && $mstate==1) {
			&fatal_error("$txt{'90'}");
			$x=@threads;
		}
	}

	$title = "$txt{'66'}";
	$viewnum = $INFO{'message'};
	$viewnum = int ( $viewnum );

	open (FILE, "$datadir/$INFO{'thread'}.txt") || &fatal_error("$txt{'23'} $INFO{'thread'}.txt");
	&lock(FILE);
	@messages = <FILE>;
	&unlock(FILE);
	close(FILE);

	($msubject, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip,  $mmessage) = split(/\|/,$messages[$viewnum]);
	$mmessage =~ s/<br>/\n/g;

	$boardmoderator =~ s|\n||g;
	$boardmoderator =~ s|\r||g;
	if($musername ne "$username" && $boardmoderator ne "$username" && $settings[7] ne "Administrator" || $username eq "Guest") {
		&fatal_error("$txt{'67'}");
	}

	&header;
print <<"EOT";
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'66'}</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}">
<form action="$cgi&action=modify2" method=post name="creator">
<input type=hidden name="viewnum" value="$viewnum">
<input type=hidden name="thread" value="$INFO{'thread'}">
<table border=0>
<tr>
	<td><b>$txt{'68'}:</b></td>
	<td>$mname</td>
</tr>
<tr>
	<td><b>$txt{'69'}:</b></td>
	<td>$memail</td>
</tr>
<tr>
	<td><b>$txt{'70'}:</b></td>
	<td><input type=text name="subject" value="$msubject"></td>
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
	<option value="$micon">$txt{'112'}
	<option value="$micon">------------
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
	<img src="$imagesdir/$micon.gif" name="icons" width="16" height="16" border=0 hspace=15></td>
</tr>
<tr>
	<td valign=top><b>$txt{'72'}:</b></td>
	<td><textarea name=message rows=10 cols=50 wrap=virtual>$mmessage</textarea></td>
</tr>
<tr>
	<td align=center colspan=2>
	<input type=submit name="moda" value="$txt{'17'}">
	<input type=submit name="moda" value="$txt{'31'}">
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
	if($INFO{'d'} eq "1") {
		if($username ne "$boardmoderator" && $settings[7] ne "Administrator") { &fatal_error("$txt{'73'}"); }
		$FORM{'viewnum'} = "$INFO{'id'}";
		$FORM{'thread'} = $INFO{'thread'};
		$FORM{'moda'} = "$txt{'31'}";
	}

	open (FILE, "$datadir/$FORM{'thread'}.txt") || &fatal_error("$txt{'23'} $FORM{'thread'}.txt");
	&lock(FILE);
	@messages = <FILE>;
	&unlock(FILE);
	close(FILE);

for ($a = 0; $a < @messages; $a++) {
	($msub[$a], $mname[$a], $memail[$a], $mdate[$a], $musername[$a], $micon[$a], $mattach[$a], $mip[$a],  $mmessage[$a]) = split(/\|/,$messages[$a]);
}

	open (FILE, ">$datadir/$FORM{'thread'}.txt") || &fatal_error("$txt{'23'} $FORM{'thread'}.txt");
	&lock(FILE);
	$fatalerr=0;
	for ($x = 0; $x < @messages; $x++) {
		if ($FORM{'viewnum'} eq $x) {
			if($FORM{'moda'} eq "$txt{'31'}") {
				open (F, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.dat");
				&lock(F);
				@threads = <F>;
				&unlock(F);
				close (F);
				open (F, ">$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.dat");
				&lock(F);
				for ($a = 0; $a < @threads; $a++) {
					if($x == (@messages-1)) { $tdate="$mdate[@messages-2]"; }
					else { $tdate="$mdate[$x]"; }
					($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mattach) = split(/\|/,$threads[$a]);
					$mattach =~ s/\n//g;
					$mattach =~ s/\r//g;
					--$mreplies;
					if ($mnum == $FORM{'thread'}) {
						print F 	"$mnum\|$msub\|$mname\|$memail\|$tdate\|$mreplies\|$musername\|$micon\|$mattach\n";
					} else { print F "$threads[$a]"; }
				}
				&unlock(F);
				close(F);
				#####################
				if($musername[$x] ne "Guest") {
					open(MEMBER, "$memberdir/$musername[$x].dat");
					&lock(MEMBER);
					@memset=<MEMBER>;
					&unlock(MEMBER);
					close(MEMBER);
					$memset[6] =~ s/\n//g;
					$memset[6] =~ s/\r//g;
					--$memset[6];
					open(MEMBER, ">$memberdir/$musername[$x].dat");
					&lock(MEMBER);
					print MEMBER "$memset[0]";
					print MEMBER "$memset[1]";
					print MEMBER "$memset[2]";
					print MEMBER "$memset[3]";
					print MEMBER "$memset[4]";
					print MEMBER "$memset[5]";
					print MEMBER "$memset[6]\n";
					print MEMBER "$memset[7]";
					print MEMBER "$memset[8]";
					&unlock(MEMBER);
					close(MEMBER);
				}
				#####################
			} else {
				$name = $FORM{'name'};
				$email = $FORM{'email'};
				$subject = $FORM{'subject'};
				$message = $FORM{'message'};
				$icon = $FORM{'icon'};

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
				
				if($FORM{'viewnum'}==0) {
					open (F, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.dat");
					&lock(F);
					@threads = <F>;
					&unlock(F);
					close (F);
					open (F, ">$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.dat");
					&lock(F);
					for ($a = 0; $a < @threads; $a++) {
						($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mattach) = split(/\|/,$threads[$a]);
						$mattach =~ s/\n//g;
						$mattach =~ s/\r//g;
						if ($mnum eq "$FORM{'thread'}") {
							print F 	"$mnum\|$subject\|$mname\|$memail\|$mdate\|$mreplies\|$musername\|$icon\|$mattach\n";
						} else { print F "$threads[$a]"; }
					}
					&unlock(F);
					close(F);
				}

				print FILE "$subject\|$mname[$x]\|$memail[$x]\|$date\|$musername[$x]\|$icon\|0\|$ENV{REMOTE_ADDR}\|$message\n";
			}
		}
		else {
			print FILE $messages[$x];
		}
#		if($FORM{'viewnum'} eq "$mnum[$x]" && $mfollow[$x+1] > $mfollow[$x] && $FORM{'moda'} eq "Delete") {
# $fatalerr=1; }
	}
	&unlock (FILE);
	close (FILE);
	if($fatalerr == 1) { &fatal_error("$txt{'74'}"); }

	print "Location: $cgi\&action=display\&num=$FORM{'thread'}\n\n";
	exit;
}

1;
