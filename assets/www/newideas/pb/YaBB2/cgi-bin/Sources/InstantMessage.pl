###############################################################################
# InstantMessage.pl                                                           #
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

$instantmessageplver="1 Gold Beta4";

sub IMIndex {

	if ($username eq "Guest") {
		&fatal_error("$txt{'147'}");
	}

	# Read all messages
	open(FILE, "$memberdir/$username.msg");
	&lock(FILE);
	@messages = <FILE>;
	&unlock(FILE);
	close(FILE);

	# Read Membergroups
	$yytitle = "$txt{'143'}";
	open(FILE, "$vardir/membergroups.txt");
	&lock(FILE);
	@membergroups = <FILE>;
	&unlock(FILE);
	close(FILE);

	# Read list of censored words
	open(CENSOR, "$vardir/censor.txt");
	&lock(CENSOR);
	@censored = <CENSOR>;
	&unlock(CENSOR);
	close(CENSOR);

	&header;

	print <<"EOT";
<table border=0 width=100% cellspacing=0>
<tr>
	<td valign=bottom><font size=2>
	<IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
	<A href="$boardurl/YaBB.pl">$mbname</A>
	<br>
	<IMG SRC="$imagesdir/tline.gif" BORDER=0><IMG SRC="$imagesdir/open.gif"  BORDER=0>&nbsp;&nbsp;
	<a href="$cgi&action=im">$txt{'144'}</A>
	<br>
	<IMG SRC="$imagesdir/tline3.gif" BORDER=0><IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
	$txt{'316'}
	</td>
<td align=right valign=bottom>
EOT
	if(@messages>0) {
		print "<a href=\"$cgi&action=imremoveall&caller=1\"><img src=\"$imagesdir/im_delete.gif\" border=0 alt=\"$txt{'412'} $txt{'316'}\"></a>";
	}

	print <<"EOT";
<a href="$cgi&action=imoutbox"><img src="$imagesdir/im_outbox.gif" border=0 alt="$txt{'320'}"></a><a href="$cgi&action=imsend"><img src="$imagesdir/im_new.gif" border=0 alt="$txt{'321'}"></a><a href="$cgi&action=im"><img src="$imagesdir/im_reload.gif" border=0 alt="$txt{'322'}"></a><a href="$cgi&action=imprefs"><img src="$imagesdir/im_config.gif" border=0 alt="$txt{'323'}"></a>
</td>
</table>
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
 <td class="title1" bgcolor="$color{'titlebg'}" width="300"><font size=2 class="text1" color="$color{'titletext'}">&nbsp;$txt{'317'}</font></td>
 <td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'318'}</font></td>
 <td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'319'}</font></td>
 <td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">&nbsp;</font></td>
</tr>
EOT

	# Display Message if there are no Messages in Users Inbox
	if(@messages==0) {
		print <<"EOT";
<tr>
	<td class="form1" colspan=4 bgcolor="$color{'windowbg'}"><font size=2>$txt{'151'}</font></td>
</tr>
EOT
	}

	# Display all available Messages
	$second="$color{'windowbg2'}";

	for ($a = 0; $a < @messages; $a++) {

		if($second eq "$color{'windowbg'}") {
			$second="$color{'windowbg2'}";
		} else {
			$second="$color{'windowbg'}";
		}

		($musername[$a], $msub[$a], $mdate[$a], $mmessage[$a], $messageid[$a], $mips[$a]) = split(/\|/,$messages[$a]);

	        # Lets set ID to $a if we've got an old message

	        if ($messageid[$a] < 100) {
			$messageid[$a] = $a;
	        }

		$name = "$mname[$a]";
		$date = "$mdate[$a]";
		$mydate = &timeformat($date);
		$subject = "$msub[$a]";

		if($subject eq "") {
			$subject="$txt{'24'}";
		}

		print "<tr>";
	        print "<td class=\"form2\" bgcolor=\"$second\" width=300><font size=2>$mydate</font></td>";
	        print "<td class=\"form2\" bgcolor=\"$second\"><font size=2>$musername[$a]</font></td>";
	        print "<td class=\"form2\" bgcolor=\"$second\"><font size=2><a href=\"#$messageid[$a]\">$subject</a></font></td>";
		print "<td class=\"form2\" bgcolor=\"$second\"><font size=2><a href=\"$cgi&action=imremove&caller=1&id=$messageid[$a]\">$txt{'31'}</a></font></td>";
		print "</tr>";

	}

print <<"EOT";
</table>
EOT
	# Output all messages
	if(@messages!=0) {
	print <<"EOT";
<br>
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
 <td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">&nbsp;$txt{'29'}</font></td>
 <td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'118'}</font></td>
</tr>
EOT

	if(@messages==0) {
		print <<"EOT";
<tr>
	<td class="form1" colspan=2 bgcolor="$color{'windowbg'}"><font size=2>$txt{'151'}</font></td>
</tr>
EOT
	}

	$second="$color{'windowbg2'}";

	for ($a = 0; $a < @messages; $a++) {
		if($second eq "$color{'windowbg'}") {
			$second="$color{'windowbg2'}";
		} else {
			$second="$color{'windowbg'}";
		}

		($musername[$a], $msub[$a], $mdate[$a], $mmessage[$a], $messageid[$a]) = split(/\|/,$messages[$a]);

	        # Lets set ID to $a if we've got an old message
	        if ($messageid[$a] < 100) { $messageid[$a] = $a; }

		$subject = "$msub[$a]";

		if($subject eq "") { $subject="$txt{'24'}"; }

		$mmessage[$a] =~ s/[\n\r]//g;
		$message="$mmessage[$a]";
		$name = "$mname[$a]";
		$date = "$mdate[$a]";
		$mydate = &timeformat($date);
		$ip = "$mip[$a]";
		$postinfo="";
		$signature="";
		$viewd="";
		$icq="";
		$star="";
		$aim="";
		$yim="";

		open(FILE, "$memberdir/$musername[$a].dat");
		&lock(FILE);
		@memset = <FILE>;
		&unlock(FILE);
		close(FILE);

		$postinfo = "$txt{'26'}: $memset[6]<br>";
		# Link moved to user's name
		#$viewd = " \| <a href=\"$cgi\&action=viewprofile\&username=$musername[$a]\">$txt{'27'}</a><br>";
		$memberinfo = "$membergroups[2]";
		$star="<img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\">";
		if($memset[6] > 50) {
			$memberinfo = "$membergroups[3]";
			$star="<img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\">";
		}
		if($memset[6] > 100) {
			$memberinfo = "$membergroups[4]";
			$star="<img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\">";
		}
		if($memset[6] > 250) {
			$memberinfo = "$membergroups[4]";
			$star="<img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\">";
		}
		if($memset[6] > 500) {
			$memberinfo = "$membergroups[4]";
			$star="<img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\">";
		}
		if($boardmoderator eq "$musername[$a]") { $memberinfo = "$membergroups[1]"; }
		if($memset[7] ne "\n") { $memberinfo = "$memset[7]"; }
		if($memberinfo eq "$Administrator\n") { $memberinfo = "$membergroups[0]"; }
		$signature = "$memset[5]";
		$signature =~ s/\&\&/<br>/g;

		if($memset[5] eq "\n"){	$signature= ""; }
		else { $signature = "<BR><BR><hr size=1 noshade width=40\% align=left>$signature"; }
		$memset[8] =~ s/[\n\r]//g;
		if($memset[8] ne "") {
	        if(!($memset[8] =~ /\D/)) {
			$icq="<a href=\"$cgi\&action=icqpager&UIN=$memset[8]\" target=_blank><img src=\"http://wwp.icq.com/scripts/online.dll?icq=$memset[8]&img=5\" alt =\"$memset[8]\" border=0></a>";
		}
		$memset[9] =~ s/[\n\r]//g;
		if($memset[9] ne "") {
			$aim = "<a href=\"aim:goim?screenname=$memset[9]&message=Hi.+Are+you+there?\" target=_blank><img SRC=\"$imagesdir/aim.gif\" alt=\"$memset[9]\" border=\"0\"></a>";
		}
		$memset[10] =~ s/[\n\r]//g;
		if($memset[10] ne "") {
			$yim = "<a href=\"http://edit.yahoo.com/config/send_webmesg?.target=$memset[10]\" target=_blank><img SRC=\"$imagesdir/yim.gif\" alt=\"$memset[10]\" border=\"0\"></a>";
		}
		}
		$message = "$message\n$signature";
		if($enable_ubbc) { &DoUBBC; }
		$url="";
		if($memset[4] ne "\n" && $memset[4] ne "http://\n" && $musername[$a] ne "Guest") {
			$url= "<a href=\"$memset[4]\" target=\"_blank\">$txt{'515'}</a> \| ";
		}

		foreach $censor (@censored) {
			$censor =~ s/\n//g;
			($word, $censored) = split(/\=/, $censor);
			$message =~ s/$word/$censored/gi;
			$subject =~ s/$word/$censored/gi;
		}

		print <<"EOT";
<tr>
	<td class=\"form2\" bgcolor="$second" width=140 valign=top rowspan=2>
	<font size=2><a href=\"$cgi\&action=viewprofile\&username=$musername[$a]\">$memset[1]</a></font><br>
	<font size=1>$memberinfo<br>
	$star<br><br>
	$postinfo<br>
	$icq &nbsp; $yim &nbsp; $aim
	</font></td>
	<td class=\"form2\" bgcolor="$second" valign=top>
	<table border=0 cellspacing=0 cellpadding=0 width=100%>
<tr>
	<td width=100%><a name="$messageid[$a]"><font size=1>&nbsp;$subject</font></td>
	<td align=right nowrap><font size=1>$txt{'30'}: $mydate</font></td>
</tr>
</table>
	<hr></font>
<font size=2>
$message
</font></td>
</tr>
<tr>
	<td class=\"form2\" bgcolor="$second"><table border=0 cellspacing=0 cellpadding=0 width=100%><tr><td><font size=1>
$url<a href="mailto:$memset[2]">E-Mail</a>$viewd
</font></td><td align=right>
<font size=1><a href="$cgi&action=imsend&caller=1&num=$a&quote=1&to=$musername[$a]">$txt{'145'}</a> | <a href="$cgi&action=imsend&caller=1&num=$a&reply=1&to=$musername[$a]">$txt{'146'}</a> | <a href="$cgi&action=imremove&caller=1&caller=1&id=$messageid[$a]">$txt{'154'}</a></font></td></tr></table></td>
</tr>
EOT
;
	}
	print <<"EOT";
</table>
<font size=2><a href="$cgi&action=imsend">$txt{'148'}</a></font>
EOT
}
	&footer;
	exit;
}

sub IMOutbox {
	if ($username eq "Guest") { &fatal_error("$txt{'147'}"); }

	open(FILE, "$memberdir/$username.dat");
	&lock(FILE);
	@memset = <FILE>;
	&unlock(FILE);
	close(FILE);

	# Read all messages
	open(FILE, "$memberdir/$username.outbox");
	&lock(FILE);
	@messages = <FILE>;
	&unlock(FILE);
	close(FILE);

	# Read Membergroups
	$yytitle = "$txt{'143'}";
	open(FILE, "$vardir/membergroups.txt");
	&lock(FILE);
	@membergroups = <FILE>;
	&unlock(FILE);
	close(FILE);

	# Read list of censored words
	open(CENSOR, "$vardir/censor.txt");
	&lock(CENSOR);
	@censored = <CENSOR>;
	&unlock(CENSOR);
	close(CENSOR);

	&header;

	print <<"EOT";
<table border=0 width=100% cellspacing=0>
<tr>
	<td valign=bottom><font size=2>
	<IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
	<A href="$boardurl/YaBB.pl">$mbname</A>
	<br>
	<IMG SRC="$imagesdir/tline.gif" BORDER=0><IMG SRC="$imagesdir/open.gif"  BORDER=0>&nbsp;&nbsp;
	<a href="$cgi&action=im">$txt{'144'}</A>
	<br>
	<IMG SRC="$imagesdir/tline3.gif" BORDER=0><IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
	$txt{'320'}
	</td>
<td align=right valign=bottom>
EOT
	if(@messages>0) {
		print "<a href=\"$cgi&action=imremoveall&caller=2\"><img src=\"$imagesdir/im_delete.gif\" border=0 alt=\"$txt{'412'} $txt{'320'}\"></a>";
	}
	print <<"EOT";
<a href="$cgi&action=im"><img src="$imagesdir/im_inbox.gif" border=0 alt="$txt{'316'}"></a><a href="$cgi&action=imsend"><img src="$imagesdir/im_new.gif" border=0 alt="$txt{'321'}"></a><a href="$cgi&action=im"><img src="$imagesdir/im_reload.gif" border=0 alt="$txt{'322'}"></a><a href="$cgi&action=imprefs"><img src="$imagesdir/im_config.gif" border=0 alt="$txt{'323'}"></a>
</td>
</table>
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
 <td class="title1" bgcolor="$color{'titlebg'}" width="300"><font size=2 class="text1" color="$color{'titletext'}">&nbsp;$txt{'317'}</font></td>
 <td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'324'}</font></td>
 <td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'319'}</font></td>
 <td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">&nbsp;</font></td>
</tr>
EOT

	# Display Message if there are no Messages in Users Outbox
	if(@messages==0) {
		print <<"EOT";
<tr>
	<td class="form1" colspan=4 bgcolor="$color{'windowbg'}"><font size=2>$txt{'151'}</font></td>
</tr>
EOT
	}

	# Display all available Messages
	$second="$color{'windowbg2'}";
	for ($a = 0; $a < @messages; $a++) {

		if($second eq "$color{'windowbg'}") {
			$second="$color{'windowbg2'}";
		} else {
			$second="$color{'windowbg'}";
		}

		($musername[$a], $msub[$a], $mdate[$a], $mmessage[$a], $messageid[$a], $mips[$a]) = split(/\|/,$messages[$a]);

	        # Lets set ID to $a if we've got an old message

	        if ($messageid[$a] < 100) {
			$messageid[$a] = $a;
	        }

		$name = "$mname[$a]";
		$date = "$mdate[$a]";
		$mydate = &timeformat($date);
		$subject = "$msub[$a]";

		if($subject eq "") {
			$subject="$txt{'24'}";
		}

		print "<tr>";
	        print "<td class=\"form2\" bgcolor=\"$second\" width=300><font size=2>$mydate</font></td>";
	        print "<td class=\"form2\" bgcolor=\"$second\"><font size=2>$musername[$a]</font></td>";
	        print "<td class=\"form2\" bgcolor=\"$second\"><font size=2><a href=\"#$messageid[$a]\">$subject</a></font></td>";
		print "<td class=\"form2\" bgcolor=\"$second\"><font size=2><a href=\"$cgi&action=imremove&caller=2&id=$messageid[$a]\">delete</a></font></td>";
		print "</tr>";

	}

print <<"EOT";
</table>
EOT

	# Output all messages
	if(@messages!=0) {
	print <<"EOT";
<br>
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
 <td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">&nbsp;$txt{'29'}</font></td>
 <td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'118'}</font></td>
</tr>
EOT

	if(@messages==0) {
		print <<"EOT";
<tr>
	<td class="form1" colspan=2 bgcolor="$color{'windowbg'}"><font size=2>$txt{'151'}</font></td>
</tr>
EOT
	}

	$second="$color{'windowbg2'}";

	for ($a = 0; $a < @messages; $a++)
	{
		if($second eq "$color{'windowbg'}")
		{
			$second="$color{'windowbg2'}";
		}
		else
		{
			$second="$color{'windowbg'}";
		}

		($musername[$a], $msub[$a], $mdate[$a], $mmessage[$a], $messageid[$a]) = split(/\|/,$messages[$a]);

	        # Lets set ID to $a if we've got an old message

	        if ($messageid[$a] < 100) {
			$messageid[$a] = $a;
	        }

		$subject = "$msub[$a]";

		if($subject eq "") {
			$subject="$txt{'24'}";
		}

		$mmessage[$a] =~ s/[\n\r]//g;
		$message="$mmessage[$a]";
		$name = "$mname[$a]";
		$date = "$mdate[$a]";
		$mydate = &timeformat($date);
		$ip = "$mip[$a]";
		$postinfo="";
		$signature="";
		$viewd="";
		$icq="";
		$star="";
		$aim="";
		$yim="";

		$postinfo = "$txt{'26'}: $memset[6]<br>";
		# Link moved to user's name
		#$viewd = " \| <a href=\"$cgi\&action=viewprofile\&username=$musername[$a]\">$txt{'27'}</a><br>";
		$memberinfo = "$membergroups[2]";
		$star="<img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\">";
		if($memset[6] > 50) {
			$memberinfo = "$membergroups[3]";
			$star="<img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\">";
		}
		if($memset[6] > 100) {
			$memberinfo = "$membergroups[4]";
			$star="<img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\">";
		}
		if($memset[6] > 250) {
			$memberinfo = "$membergroups[4]";
			$star="<img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\">";
		}
		if($memset[6] > 500) {
			$memberinfo = "$membergroups[4]";
			$star="<img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\"><img src=\"$imagesdir/star.gif\" alt=\"\" border=\"0\">";
		}
		if($boardmoderator eq "$musername[$a]") { $memberinfo = "$membergroups[1]"; }
		if($memset[7] ne "\n") { $memberinfo = "$memset[7]"; }
		if($memberinfo eq "$Administrator\n") { $memberinfo = "$membergroups[0]"; }
		$signature = "$memset[5]";
		$signature =~ s/\&\&/<br>/g;
		$signature = "<hr width=40\% align=left>$signature";
		$memset[8] =~ s/[\n\r]//g;
		if($memset[8] ne "") {
	        if(!($memset[8] =~ /\D/)) {
			$icq="<a href=\"$cgi\&action=icqpager&UIN=$memset[8]\" target=\"_blank\"><img src=\"http://wwp.icq.com/scripts/online.dll?icq=$memset[8]&img=5\" alt =\"$memset[8]\" border=0></a>";
		}
		$memset[9] =~ s/[\n\r]//g;
		if($memset[9] ne "") {
			$aim = "<a href=\"aim:goim?screenname=$memset[9]&message=Hi.+Are+you+there?\" target=_blank><img SRC=\"$imagesdir/aim.gif\" alt=\"$memset[9]\" border=\"0\"></a>";
		}
		$memset[10] =~ s/[\n\r]//g;
		if($memset[10] ne "") {
			$yim = "<a href=\"http://edit.yahoo.com/config/send_webmesg?.target=$memset[10]\" target=_blank><img SRC=\"$imagesdir/yim.gif\" alt=\"$memset[10]\" border=\"0\"></a>";
		}
		}
		$message = "$message\n$signature";
		if($enable_ubbc) { &DoUBBC; }
		$url="";
		if($memset[4] ne "\n" && $memset[4] ne "http://\n" && $musername[$a] ne "Guest") {
			$url= "<a href=\"$memset[4]\" target=\"_blank\">$txt{'515'}</a> \| ";
		}

		foreach $censor (@censored) {
			$censor =~ s/\n//g;
			($word, $censored) = split(/\=/, $censor);
			$message =~ s/$word/$censored/g;
			$subject =~ s/$word/$censored/g;
		}

		print <<"EOT";
<tr>
	<td class=\"form2\" bgcolor="$second" width=140 valign=top rowspan=2>
	<font size=2><a href=\"$cgi\&action=viewprofile\&username=$musername[$a]\">$memset[1]</a></font><br>
	<font size=1>$memberinfo<br>
	$star<br><br>
	$postinfo<br>
	$icq &nbsp; $yim &nbsp; $aim
	</font></td>
	<td class=\"form2\" bgcolor="$second" valign=top>
	<table border=0 cellspacing=0 cellpadding=0 width=100%>
<tr>
	<td width=100%><font size=1><a name="$messageid[$a]">&nbsp;$subject</font></td>
	<td align=right nowrap><font size=1>$txt{'30'}: $mydate</font></td>
</tr>
</table>
	<hr></font>
<font size=2>
$message
</font></td>
</tr>
<tr>
	<td class=\"form2\" bgcolor="$second"><table border=0 cellspacing=0 cellpadding=0 width=100%><tr><td><font size=1>
$url<a href="mailto:$memset[2]">E-Mail</a>$viewd
</font></td><td align=right>
<font size=1><a href="$cgi&action=imsend&caller=2&num=$a&quote=1&to=$musername[$a]">$txt{'145'}</a> | <a href="$cgi&action=imsend&caller=2&num=$a&reply=1&to=$musername[$a]">$txt{'146'}</a> | <a href="$cgi&action=imremove&caller=2&id=$messageid[$a]">$txt{'154'}</a></font></td></tr></table></td>
</tr>
EOT
;
	}
	print <<"EOT";
</table>
<font size=2><a href="$cgi&action=imsend">$txt{'148'}</a></font>
EOT
}
	&footer;
	exit;
}

sub IMRemove
{
	if($username eq "Guest") { &fatal_error("$txt{'147'}"); }

	if ($INFO{'caller'} == 1) { open(FILE, "$memberdir/$username.msg"); }
	elsif ($INFO{'caller'} == 2) { open(FILE, "$memberdir/$username.outbox"); }

	&lock(FILE);
	@messages = <FILE>;
	&unlock(FILE);
	close(FILE);

	if ($INFO{'caller'} == 1) { open(FILE, ">$memberdir/$username.msg"); }
	elsif ($INFO{'caller'} == 2) { open(FILE, ">$memberdir/$username.outbox"); }
	&lock(FILE);

	for ($a = 0; $a < @messages; $a++) {
		# ONLY delete MSG with correct ID
		($musername, $msub, $mdate, $mmessage, $messageid, $mips) = split(/\|/,$messages[$a]);

		$messageid =~ s/[\n\r]//g; # this line is necessary !!!

		# If Message-ID is < 100, user has used the old IM before
		if ($messageid < 100 ) {
			if($a ne $INFO{'id'}) { print FILE "$messages[$a]"; }
		} else {
	 		if($messageid ne "$INFO{'id'}") { print FILE "$messages[$a]"; }
      		}
   	}

   	&unlock(FILE);
   	close(FILE);
	if ($INFO{'caller'} == 1) { print "Location: $cgi\&action=im\n\n"; }
	else { print "Location: $cgi\&action=imoutbox\n\n"; }

}

sub IMPost {
	if($username eq "Guest") { &fatal_error("$txt{'147'}"); }

	$yytitle="$txt{'148'}";
	&header;
	if($INFO{'num'} ne "") {
		if($INFO{'caller'} == 1) { open(FILE, "$memberdir/$username.msg"); }
		else { open(FILE, "$memberdir/$username.outbox"); }

		&lock(FILE);
		@messages = <FILE>;
		&unlock(FILE);
		close(FILE);

		($mfrom, $msubject, $mdate, $mmessage, $mip) = split(/\|/,$messages[$INFO{'num'}]);
		$msubject =~ s/Re: //g;

		if($INFO{'quote'} == 1) {
			$mmessage =~ s/<br>/\n/g;
			$form_message =~ s/\[quote\](\S+?)\[\/quote\]//isg;
			$form_message =~ s/\[(\S+?)\]//isg;
			$form_message = "\n\n\[quote\]$mmessage\[/quote\]";
			$form_subject = "Re: $msubject";
		}
		if($INFO{'reply'} == 1) { $form_subject = "Re: $msubject"; }
	}

	if ($form_subject eq "") { $form_subject = "$txt{'24'}"; }

	print <<"EOT";
<table border=0 width=100% cellspacing=0>
<tr>
	<td valign=bottom><font size=2>
	<IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
	<A href="$boardurl/YaBB.pl">$mbname</A>
	<br>
	<IMG SRC="$imagesdir/tline.gif" BORDER=0><IMG SRC="$imagesdir/open.gif"  BORDER=0>&nbsp;&nbsp;
	<a href="$cgi&action=im">$txt{'144'}</A>
	<br>
	<IMG SRC="$imagesdir/tline3.gif" BORDER=0><IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
	$txt{'321'}
	</td>
<td align=right valign=bottom>
EOT
	print <<"EOT";
<a href="$cgi&action=im"><img src="$imagesdir/im_inbox.gif" border=0 alt="$txt{'316'}"></a><a href="$cgi&action=imoutbox"><img src="$imagesdir/im_outbox.gif" border=0 alt="$txt{'320'}"></a><a href="$cgi&action=im"><img src="$imagesdir/im_reload.gif" border=0 alt="$txt{'322'}"></a><a href="$cgi&action=imprefs"><img src="$imagesdir/im_config.gif" border=0 alt="$txt{'323'}"></a>
</td>
</table>
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
 <tr>
  <td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'148'}</font></td>
 </tr>
 <tr>
  <td class="form1" bgcolor="$color{'windowbg'}">
   <form action="$cgi&action=imsend2" method=post>
    <table border=0>
     <tr>
      <td>
       <font size=2>$txt{'150'}:</font>
      </td>
      <td>
       <font size=2><input type=text name="to" value="$INFO{'to'}" size="20" maxlength="50"></font>
      </td>
     </tr>
     <tr>
      <td>
       <font size=2>$txt{'70'}:</font>
      </td>
      <td>
       <font size=2><input type=text name="subject" value="$form_subject" size="40" maxlength="50"></font>
      </td>
     </tr>
     <tr>
      <td valign=top>
       <font size=2>$txt{'469'}:</font>
      </td>
      <td>
       <font size=2><textarea name=message rows=10 cols=50 wrap=physical>$form_message</textarea>
      </td>
     </tr>
     <tr>
      <td align=center colspan=2>
       <input type=submit value="$txt{'148'}">
       <input type=reset value="$txt{'329'}">
      </td>
     </tr>
    </table>
   </form>
  </td>
 </tr>
</table>
EOT
	&footer;
	exit;
}

sub IMPost2
{
	# Check Ignore-List
	if (-e("$memberdir/$FORM{'to'}.imconfig")) {
		open(FILE, "$memberdir/$FORM{'to'}.imconfig");
		&lock(FILE);
		@imconfig = <FILE>;
		&unlock(FILE);
		close(FILE);

		# Build Ignore-List
		$imconfig[0] =~ s/[\n\r]//g;
		$imconfig[1] =~ s/[\n\r]//g;

		@ignore = split(/\|/,$imconfig[0]);

		# If User is on Recepients Ignor-List, show Error-Message
		foreach $igname (@ignore) {
			if ($igname eq $username) { &fatal_error("You are not allowed to send Instant Messages to this User!"); }
		}

	}

	# Create unique Message ID = Time & ProccessID
	$messageid = $^T.$$;

	$subject = $FORM{'subject'};
	$message = $FORM{'message'};
	if (length($message)>$MaxMessLen) { &fatal_error("$txt{'499'}"); }

	&fatal_error("$txt{'77'}") unless($subject);
	&fatal_error("$txt{'78'}") unless($message);

	$mmessage = $message;
	$msubject = $subject;

	$subject =~ s/\&/\&amp;/g;
	$message =~ s/\&/\&amp;/g;
	$subject =~ s/"/\&quot;/g;
	$message =~ s/"/\&quot;/g;
	$subject =~ s/  / \&nbsp;/g;
	$message =~ s/  / \&nbsp;/g;

	$subject =~ s/</&lt;/g;
	$subject =~ s/>/&gt;/g;
	$subject =~ s/\|/\&#124;/g;
	$message =~ s/</&lt;/g;
	$message =~ s/>/&gt;/g;
	$message =~ s/\t/ \&nbsp; \&nbsp; \&nbsp;/g;
	$message =~ s/\cM//g;
	$message =~ s/\n/<br>/g;
	$message =~ s/\|/\&#124;/g;

	if (!(-e("$memberdir/$FORM{'to'}.dat"))) {  &fatal_error("$txt{'149'}"); }

	# Add message to outbox
	if(-e("$memberdir/$username.outbox")) { open (FILE, ">>$memberdir/$username.outbox"); }
	else { open (FILE, ">$memberdir/$username.outbox"); }

	&lock(FILE);
	print FILE "$FORM{'to'}\|$subject\|$date\|$message\|$messageid\|$ENV{'REMOTE_ADDR'}\n";
	&unlock(FILE);
	close (FILE);

	# Send message to user
	open (FILE, ">>$memberdir/$FORM{'to'}.msg");
	&lock(FILE);
	print FILE "$username\|$subject\|$date\|$message\|$messageid\|$ENV{'REMOTE_ADDR'}\n";
	&unlock(FILE);
	close(FILE);

	# Send notification
	if ($imconfig[1]==1) {
		open (FILE, "$memberdir/$FORM{'to'}.dat");
		&lock(FILE);
		@recepient = <FILE>;
		&unlock(FILE);
		close(FILE);
		$mydate = &timeformat($date);
		$recepient[2] =~ s/[\n\r]//g; # get eMail-Adress

		if ($recepient[2] ne "") {
			&sendmail("$recepient[2]","New Instant-Message ($msubject)","($mydate) $settings[1] has sent you the following Instant Message:\n\n->*<-\n\n$mmessage\n\n->*<-");
		}
	}

	print "Location: $cgi\&action=im\n\n";
	exit;
}

sub IMPreferences {

	if ($username eq "Guest") { &fatal_error("$txt{'147'}"); }

	if (-e("$memberdir/$username.imconfig")) {
		open(FILE, "$memberdir/$username.imconfig");
		&lock(FILE);
		@imconfig = <FILE>;
		&unlock(FILE);
		close(FILE);
	}

	$imconfig[0] =~ s/[\n\r]//g;
	$imconfig[0] =~ s/\|/\n/g;
	$imconfig[1] =~ s/[\n\r]//g;

	if ($imconfig[1]) {
		$sel0="";
		$sel1=" selected";
	} else {
		$sel0=" selected";
		$sel1="";
	}

	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=0>
<tr>
	<td valign=bottom><font size=2>
	<IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
	<A href="$boardurl/YaBB.pl">$mbname</A>
	<br>
	<IMG SRC="$imagesdir/tline.gif" BORDER=0><IMG SRC="$imagesdir/open.gif"  BORDER=0>&nbsp;&nbsp;
	<a href="$cgi&action=im">$txt{'144'}</A>
	<br>
	<IMG SRC="$imagesdir/tline3.gif" BORDER=0><IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
	$txt{'323'}
	</td>
<td align=right valign=bottom>
EOT
	print <<"EOT";
<a href="$cgi&action=im"><img src="$imagesdir/im_inbox.gif" border=0 alt="$txt{'316'}"></a><a href="$cgi&action=imoutbox"><img src="$imagesdir/im_outbox.gif" border=0 alt="$txt{'320'}"></a><a href="$cgi&action=imsend"><img src="$imagesdir/im_new.gif" border=0 alt="$txt{'321'}"></a><a href="$cgi&action=im"><img src="$imagesdir/im_reload.gif" border=0 alt="$txt{'322'}"></a>
</td>
</table>
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
 <tr>
  <td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'323'}</font></td>
 </tr>
 <tr>
  <td class="form1" bgcolor="$color{'windowbg'}">
   <form action="$cgi&action=imprefs2" method=post>
    <table border=0>
     <tr>
      <td valign=top>
       <font size=2>$txt{'325'}:</font><br><font size=1>$txt{'326'}</font>
      </td>
      <td>
       <font size=2><textarea name=ignore rows=10 cols=50 wrap=virtual>$imconfig[0]</textarea></font>
      </td>
     </tr>
     <tr>
      <td valign=top>
       <font size=2>$txt{'327'}:</font>
      </td>
      <td>
       <font size=2>
	<select name="notify">
	 <option value="0"$sel0>$txt{'164'}
	 <option value="1"$sel1>$txt{'163'}
	</select>
       </font>
      </td>
     </tr>
     <tr>
      <td>
      	&nbsp;
      </td>
      <td>
       <input type=submit value="$txt{'328'}">
       <input type=reset value="$txt{'329'}">
      </td>
     </tr>
    </table>
   </form>
  </td>
 </tr>
</table>
EOT
	&footer;
	exit;
}

sub IMPreferences2 {
	if($username eq "Guest") { &fatal_error("$txt{'147'}"); }

	$ignorelist = "$FORM{'ignore'}";
	$notify = "$FORM{'notify'}";

	$ignorelist =~ s/[\n\r]/\|/g;
	$ignorelist =~ s/\|\|/\|/g;
	$notify =~ s/[\n\r]//g;

	open(FILE, ">$memberdir/$username.imconfig");
	&lock(FILE);

	print FILE $ignorelist."\n";
	print FILE $notify."\n";

	&unlock(FILE);
	close(FILE);

	print "Location: $cgi\&action=imprefs\n\n";
	exit;
}

sub KillAll {
	if($username eq "Guest") { &fatal_error("$txt{'147'}"); }

	if ($INFO{'caller'} == 1) {
		unlink("$memberdir/$username.msg");
		print "Location: $cgi\&action=im\n\n";
	} elsif ($INFO{'caller'} == 2) {
		unlink("$memberdir/$username.outbox");
		print "Location: $cgi\&action=imoutbox\n\n";
	}
}

sub KillAllQuery {
	if($username eq "Guest") { &fatal_error("$txt{'147'}"); }

	$yytitle = "$txt{'412'} ";

	if ($INFO{'caller'} == 1) {
		$yytitle .= $txt{'316'};
		$query = "$txt{'412'} $txt{'316'}";
		$cgi2 = "$cgi\&action=imremoveall2&caller=1";
		$cgi .= "\&action=im";
	} elsif ($INFO{'caller'} == 2) {
		$yytitle .= $txt{'320'};
		$query = "$txt{'412'} $txt{'320'}";
		$cgi2 = "$cgi\&action=imremoveall2&caller=2";
		$cgi .= "\&action=imoutbox";
	}

	&header;
	print <<"EOT";
<table border=0 width=80% cellspacing=1 bgcolor="$color{'bordercolor'}" align="center">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$query</font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}"><font size=2>
$txt{'413'}<br>
<a href="$cgi2">$txt{'163'}</a> - <a href="$cgi">$txt{'164'}</a>
</font></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

1;
