###############################################################################
# Display.pl                                                                  #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Zef Hemel                                    #
###############################################################################

sub Display {
	$viewnum = $INFO{'num'};
	if ($viewnum !~ /^[0-9]+$/){ &fatal_error("This field only accepts numbers from 0-9" ); }
	open(FILE, "$vardir/membergroups.txt");
	&lock(FILE);
	@membergroups = <FILE>;
	&unlock(FILE);
	close(FILE);
	open(FILE, "$datadir/$viewnum.txt") || &fatal_error("$txt{'23'} $viewnum.txt");
	&lock(FILE);
	@messages = <FILE>;
	&unlock(FILE);
	close(FILE);
	($msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $mmessage) = split(/\|/,$messages[@messages-1]);
#	$cookiename="$viewnum$cookieusername$username";
	# Custom cookie setting (couldn't get the cookie.lib thing to work)
#	print 'Set-Cookie: ' . $cookiename . '=' . $mdate . ';';
#	print ' expires=' . $Cookie_Exp_Date . ';';
#	print "\n";
	$writedate = "$mdate";
	&writelog("$viewnum");

#############
	open(FILE, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
	&lock(FILE);
	@threads = <FILE>;
	&unlock(FILE);
	close(FILE);
	$noposting=0;
	for ($x = 0; $x < @threads; $x++) {
($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split(/\|/,$threads[$x]);
		if ($viewnum eq $mnum && $mstate==1) {
			$noposting=1;
		}
		if($viewnum eq $mnum) { $x = @threads; }
	}
	if($mstate==0) { $type="thread"; }
	if($mreplies>=15) { $type="hotthread"; }
	if($mreplies>=25) { $type="veryhotthread"; }
	if($mstate==1) { $type="locked"; }
	#############
	($msub[0], $mname[0], $memail[0], $mdate[0], $musername[0], $micon[0], $mattach[0], $mip[0], $mmessage[0]) = split(/\|/,$messages[0]);
	##################
	$title="$msub[0]";
	&header;
	open(CENSOR, "$vardir/censor.txt");
	&lock(CENSOR);
	@censored = <CENSOR>;
	&unlock(CENSOR);
	close(CENSOR);
	foreach $censor (@censored) {
		$censor =~ s/\n//g;
		$censor =~ s/\r//g;
		($word, $censored) = split(/\=/, $censor);
		$msub[0] =~ s/$word/$censored/g;
	}
	##################
	if($enable_notification) {
		$notification = <<"EOT";
<a href="$cgi&action=notify&thread=$viewnum"><img src="$imagesdir/notify.gif" width=70 height=18 alt="" border="0"></a>
EOT
	}
	&jumpto;
	if($INFO{'start'} ne "") { $start="$INFO{'start'}"; } else { $start=0; }
	print <<"EOT";
<table width=600>
<tr>
	<td valign=bottom><b><a href="$boardurl/YaBB.pl">$mbname</a>:
<a href="$cgi">$boardname</a>: <a href="$cgi&action=display&num=$viewnum">$msub[0]</a></b></font></td>
	<td align=right><p><a href="Printpage.pl?board=$currentboard&num=$viewnum" target="_blank"><img src="$imagesdir/print.gif" width=36 height=16 alt="Printable Page" border=0></a><br><a href="$cgi&action=post&num=$viewnum&title=$txt{'116'}&start=$start"><p>reply</P></a>$notification</td>
</tr>
</table>
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><table border=0 cellspacing=0 cellpadding=0><tr><td><font color="$color{'titletext'}"><img src="$imagesdir/$type.gif"></td><td><font color="$color{'titletext'}">&nbsp;<b>$txt{'29'}</b></font></td></tr></table></td>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'118'}: $msub[0]</b></font></td>
</tr>
EOT
	for ($a = $start; $a < @messages; $a++) {
		++$numshown;
		if($second eq "$color{'windowbg'}") { $second="$color{'windowbg2'}"; }
		else { $second="$color{'windowbg'}"; }
		($msub[$a], $mname[$a], $memail[$a], $mdate[$a], $musername[$a], $micon[$a], $mattach[$a], $mip[$a],  $mmessage[$a]) = split(/\|/,$messages[$a]);

		$subject = "$msub[$a]";
		if($subject eq "") { $subject="$txt{'24'}"; }
		$mmessage[$a] =~ s/\n//g;
		$message="$mmessage[$a]";
		$name = "$mname[$a]";
		$date = "$mdate[$a]";
		
		if($settings[7] eq "Administrator") { $ip = "$mip[$a]"; }
		else { $ip = "Logged"; }
		
		$removed=0;
		if(!(-e("$memberdir/$musername[$a].dat"))) { $removed=1; }
		$postinfo="";
		$signature="";
		$viewd="";
		$icq="";
		$star="";
		$sendm="";
		if($musername[$a] ne "Guest" && $removed==0) {
			if($username ne "Guest") {
				$sendm = " <a href=\"$cgi\&action=imsend\&to=$musername[$a]\"><img src=\"$imagesdir/message.gif\" width=53 height=16 alt=\"Send message\" border=0></a>";
			}
			open(FILE, "$memberdir/$musername[$a].dat");
			&lock(FILE);
			@memset = <FILE>;
			&unlock(FILE);
			close(FILE);
			$postinfo = "$txt{'26'}: $memset[6]<br>";
			$viewd = " <a href=\"$cgi\&action=viewprofile\&username=$musername[$a]\">profile</a>";
			$memberinfo = "$membergroups[2]";
			$star=<<"EOT";
<img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0">
EOT
			if($memset[6] > 50) {
				$memberinfo = "$membergroups[3]";
				$star=<<"EOT";
<img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0">
EOT
			}
			if($memset[6] > 100) {
				$memberinfo = "$membergroups[4]";
				$star=<<"EOT";
<img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0">
EOT
			}
			if($memset[6] > 250) {
				$memberinfo = "$membergroups[4]";
				$star=<<"EOT";
<img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0">
EOT
			}
			if($memset[6] > 500) {
				$memberinfo = "$membergroups[4]";
				$star=<<"EOT";
<img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0">
EOT
			}
			if($boardmoderator eq "$musername[$a]") { $memberinfo = "$membergroups[1]"; }
			if($memset[7] ne "\n") { $memberinfo = "$memset[7]"; }
			if($memberinfo eq "Administrator\n") { $memberinfo = "$membergroups[0]"; }
			$signature = "$memset[5]";
			$signature =~ s/\&\&/<br>/g;
			if($signature ne "") {
				$signature = "<br>-----------------<br>$signature";
			}
			$memset[8] =~ s/\n//g;
			$memset[8] =~ s/\r//g;
			if(!($memset[8] =~ /\D/) && $memset[8] ne "") {
				$icq = "<a href=\"http://www.icq.com/$memset[8]\" target=_blank><img src=\"http://wwp.icq.com/scripts/online.dll?icq=$memset[8]&img=5\" alt =\"$memset[8]\" border=0></a>";
			}

		} else { $memberinfo = "$txt{'28'}"; }
		$message = "$message\n$signature";
		if($enable_ubbc) {
			&DoUBBC;
		}
		$url="";
		if($memset[3] ne "\n" && $musername[$a] ne "Guest") {
			$url= " <a href=\"$memset[4]\"><img src=\"$imagesdir/www.gif\" width=34 height=17 alt=\"WWW\" border=0></a>";
		}
		##################
		foreach $censor (@censored) {
			$censor =~ s/\n//g;
			$censor =~ s/\r//g;
			($word, $censored) = split(/\=/, $censor);
			$message =~ s/$word/$censored/g;
			$subject =~ s/$word/$censored/g;
		}
		##################
		if ($settings[7] ne "Administrator") {
			$ip = "Logged";
		} 
		print <<"EOT";
<tr>
	<td bgcolor="$second" width=140 valign=top rowspan=2>
	<b>$name</b><br>
	<font size=1>$memberinfo<br>
	$star<br><br>
	$postinfo<br>
	$icq
	</font></td>
	<td bgcolor="$second" valign=top>
	<table border=0 cellspacing=0 cellpadding=0 width=600>
<tr>
	<td><img src="$imagesdir/$micon[$a].gif" width=16 height=16></td>
	<td width=600><font size=1>&nbsp;<b>$subject</b></font></td>
	<td align=right nowrap><font size=1><b>$txt{'30'}:</b> $date</font></td>
</tr>
</table>
	<hr></font>
<p>
$message
<div align=right><img src="$imagesdir/ip.gif" border=0 align=top> $ip</div>
</P>
</td>
</tr>
<tr>
	<td bgcolor="$second"><table border=0 cellspacing=0 cellpadding=0 width=600><tr><td><font size=1>
$url <a href="mailto:$memail[$a]"><img src="$imagesdir/email.gif" width=33 height=16 alt="E-Mail" border=0></a>$viewd$sendm
</font></td><td align=right>
<font size=1><a href="$cgi&action=post&num=$viewnum&quote=$a&title=$txt{'116'}&start=$start"><img src="$imagesdir/quote.gif" width=39 height=16 alt="Quote" border=0></a> <a href="$cgi&action=modify&message=$a&thread=$viewnum"><img src="$imagesdir/modify.gif" width=43 height=16 alt="Modify" border=0></a> <a href="$cgi&action=modify2&thread=$viewnum&id=$a&d=1"><img src="$imagesdir/delete.gif" width=38 height=17 alt="Delete" border=0></a></font></td></tr></table></td>
</tr>
EOT
;
		if ($numshown >= $maxmessagedisplay) { $a = @messages; }
	}
print <<"EOT";
</table>
<table border=0 width=600 cellspacing=0 cellpadding=0>
<tr>
	<td><b>$txt{'139'}:</b>
EOT
$nummessages=@messages;
$c=0;
while(($c*$maxmessagedisplay)<$nummessages) {
	$viewc = $c+1;
	$strt = ($c*$maxmessagedisplay);
	if($start == $strt) {
		print <<"EOT";
$viewc
EOT
	} else {
		print <<"EOT";
<a href="$cgi&action=display&num=$viewnum&start=$strt">$viewc</a>
EOT
	}
	++$c;
}
print <<"EOT";
</td><td align=center>
<b>$txt{'137'}:</b> <a href="$cgi&action=movethread&thread=$viewnum">$txt{'132'}</a>,
<a href="$cgi&action=removethread&thread=$viewnum">$txt{'63'}</a>,
<a href="$cgi&action=lock&thread=$viewnum">$txt{'104'}</a></font></td>
	<td align=right><p><a href="$cgi&action=post&num=$viewnum&title=$txt{'116'}&start=$start">reply</a>$notification</td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub DoUBBC {
	###### Uniform Bulletin Board Code (UBBC) ########
	if ($message =~ /^\#nosmileys/ ) { 
		$message =~ s/^\#nosmileys//; 
	} else { 
		$message =~ s/\:\)/\<img src=$imagesdir\/smiley\.gif\>/g;
		$message =~ s/\:\-\)/\<img src=$imagesdir\/smiley\.gif\>/g;
		$message =~ s|\;\)|\<img src=$imagesdir\/wink.gif\>|g;
		$message =~ s|\;\-\)|\<img src=$imagesdir\/wink.gif\>|g;
		$message =~ s|\:D|\<img src=$imagesdir\/cheesy.gif\>|g;
		$message =~ s|\;D|\<img src=$imagesdir\/grin.gif\>|g;
		$message =~ s|\)\:\(|\<img src=$imagesdir\/angry.gif\>|g;
		$message =~ s|\:\-\(|\<img src=$imagesdir\/sad.gif\>|g;
		$message =~ s|\:\(|\<img src=$imagesdir\/sad.gif\>|g;
		$message =~ s|\:o|\<img src=$imagesdir\/shocked.gif\>|g;
		$message =~ s|8\)|\<img src=$imagesdir\/cool.gif\>|g;
		$message =~ s|\?\?\?|\<img src=$imagesdir\/huh.gif\>|g;
                $message =~ s|\<\3|\<img src=$imagesdir\/heart\.gif\>|/g;
	}
	
	$message =~ s|\[\[|\{\{|g;
	$message =~ s|\]\]|\}\}|g;
	$message =~ s|\n\[|\[|g;
	$message =~ s|\]\n|\]|g;
	$message =~ s|<br>| <br>|g;
	$message =~ s|\[hr\]\n|\<hr width=40\% align=left>|g;
	$message =~ s|\[hr\]|\<hr width=40\% align=left>|g;

	$message =~ s/\[url\](\S+?)\[\/url\]/<a href=\"$1\"\ target=\"_blank\">$1<\/a>/isg;
	
	$message =~ s/\[url=http:\/\/(\S+?)\]/<a href=\"http:\/\/$1\"\ target=\"_blank\">/isg;
	$message =~ s/\[url=(\S+?)\]/<a href=\"http:\/\/$1\"\ target=\"_blank\">/isg;
	$message =~ s/\[\/url\]/<\/a>/isg;
	$message =~ s/\ http:\/\/(\S+?)\ / <a href=\"http:\/\/$1\"\ target=\"_blank\">http\:\/\/$1<\/a> /isg;
	$message =~ s/<br>http:\/\/(\S+?)\ /<br><a href=\"http:\/\/$1\"\ target=\"_blank\">http\:\/\/$1<\/a>/isg;
	$message =~ s/^http:\/\/(\S+?)\ /<a href=\"http:\/\/$1\"\ target=\"_blank\">http\:\/\/$1<\/a>/isg;

	$message =~ s/\[b\]/<b>/isg;
	$message =~ s/\[\/b\]/<\/b>/isg;

	$message =~ s/\[i\]/<i>/isg;
	$message =~ s/\[\/i\]/<\/i>/isg;

	$message =~ s/\[u\]/<u>/isg;
	$message =~ s/\[\/u\]/<\/u>/isg;
	
#	$message =~ s/\[url\](.+?)\[\/url\]/<a href=\"$1\">$1<\/a>/isg;
	$message =~ s/\[img\](.+?)\[\/img\]/<img src=\"$1\">/isg;
	
	$message =~ s/\[color=(\S+?)\]/<font color=\"$1\">/isg;
	$message =~ s/\[\/color\]/<\/font>/isg;
	
	$message =~ s/\[quote\]<br>(.+?)<br>\[\/quote\]/<blockquote><hr>$1<hr><\/blockquote>/isg;
	$message =~ s/\[quote\](.+?)\[\/quote\]/<blockquote><hr><b>$1<\/b><hr><\/blockquote>/isg;

	$message =~ s/\\http:\/\/(\S+)/<a href=\"http:\/\/$1\"\ target=\"_blank\">http:\/\/$1<\/a>/isg;
	
	$message =~ s/\[fixed\]/<font face=\"Courier New\">/isg;
	$message =~ s/\[\/fixed\]/<\/font>/isg;

	$message =~ s/\[sup\]/<sup>/isg;
	$message =~ s/\[\/sup\]/<\/sup>/isg;

	$message =~ s/\[sub\]/<sub>/isg;
	$message =~ s/\[\/sub\]/<\/sub>/isg;

	$message =~ s/\[center\]/<center>/isg;
	$message =~ s/\[\/center\]/<\/center>/isg;

	$message =~ s/\[list\]/<ul>/isg;
	$message =~ s/\[\*\]/<li>/isg;
	$message =~ s/\[\/list\]/<\/ul>/isg;

	$message =~ s/\[pre\]/<pre>/isg;
	$message =~ s/\[\/pre\]/<\/pre>/isg;

	$message =~ s/\[code\](.+?)\[\/code\]/<blockquote><font size=\"1\" face=\"Courier New\">code:<\/font><hr><font face=\"Courier New\"><pre>$1<\/pre><\/font><hr><\/blockquote>/isg;

	$message =~ s/\\(\S+?)\@(\S+)/<a href=\"mailto:$1\@$2\"\>$1\@$2<\/a>/ig;

	$message =~ s/\[email=(\S+?)\]/<a href=\"mailto:$1\">/isg;
	$message =~ s/\[\/email\]/<\/a>/isg;

	$message =~ s|\{\{|\[|g;
	$message =~ s|\}\}|\]|g;
	######################
}


1;
