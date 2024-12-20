###############################################################################
# MessageIndex.pl                                                             #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Zef Hemel                                    #
###############################################################################

sub MessageIndex {
open (FILE, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
&lock(FILE);
@messages = <FILE>;
&unlock(FILE);
close(FILE);

$messagecount = 0;
$threadcount = 0;

for ($a = 0; $a < @messages; $a++) {

	($mnum[$a],$msub[$a],$mname[$a],$memail[$a],$mdate[$a],$mreplies[$a],$musername[$a],$micon[$a],$mstate[$a]) = split(/\|/,$messages[$a]);

	$messagecount++;
	if ($mfollow[$a] == 1) {
		$threadcount++;
	}
	$micon[$a] =~ s/\n//g;
	$micon[$a] =~ s/\r//g;

}
#$cookiename="$currentboard$cookieusername$username";
#print 'Set-Cookie: ' . $cookiename . '=' . $mdate[0] . ';';
#print ' expires=' . $Cookie_Exp_Date . ';';
#print "\n";
$writedate = "$mdate[0]";
&writelog("$currentboard");

$title = "$boardname";
&header;
if ($maxdisplay > 0 && @messages > $maxdisplay) {
	$themax = $maxdisplay
} else {
	$themax = "all";
}	
print <<"EOT";
<table width=600>
<tr>
	<td><b><a href="$boardurl/YaBB.pl">$mbname</a>: <a href="$cgi">$boardname</a></b></td>
	<td align=right><a href="$cgi&action=post&title=Start+new+thread">new thread</a></td>
</tr>
</table>

<table border=0 width=600 cellspacing=1 cellpadding=2 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}" width=16>&nbsp;</td>
	<td bgcolor="$color{'titlebg'}" width=16>&nbsp;</td>
	<td bgcolor="$color{'titlebg'}" width="50%"><font color="$color{'titletext'}"><b>$txt{'70'}</b></font></td>
	<td bgcolor="$color{'titlebg'}" width="20%"><font color="$color{'titletext'}"><b>$txt{'109'}</b></font></td>
	<td bgcolor="$color{'titlebg'}" width="10%" align=center><font color="$color{'titletext'}"><b>$txt{'110'}</b></font></td>
	<td bgcolor="$color{'titlebg'}" width="20%" align=center><font color="$color{'titletext'}"><b>$txt{'111'}</b></font></td>
EOT
if($INFO{'start'} eq "") { $start=0; } else { $start="$INFO{'start'}"; }
$numshown=0;
open(CENSOR, "$vardir/censor.txt");
&lock(CENSOR);
@censored = <CENSOR>;
&unlock(CENSOR);
close(CENSOR);

for ($b = $start; $b < @messages; $b++) {
	++$numshown;
	if($mstate[$b]==0) { $type="thread"; }
	if($mreplies[$b]>=15) { $type="hotthread"; }
	if($mreplies[$b]>=25) { $type="veryhotthread"; }
	if($mstate[$b]==1) { $type="locked"; }
#	$cookiename="$mnum[$b]$cookieusername$username";
#	&GetCookies("$cookiename");
#	foreach (split(/; /,$ENV{'HTTP_COOKIE'})) {
#       ($cookie,$value) = split(/=/);
#	   if($cookiename eq "$cookie") { $cvalue="$value"; }
#    }
	$dlp = &readlog("$mnum[$b]");
	$new="";
	$date1="$mdate[$b]";
	$date2="$date";
	&calcdifference;
	if($dlp ne "$date1" && $result <= $max_log_days_old && $username ne "Guest") {
		$new = "<img src=\"$imagesdir/new.gif\" width=28 heigt=11 alt=\"New\">";
	}
	if($musername[$b] ne "Guest") {
#		$mname[$b] = "<a href=\"$cgi\&action=viewprofile\&username=$musername[$b]\">$mname[$b]</a>";
	}
	##################
	foreach $censor (@censored) {
		$censor =~ s/\n//g;
		$censor =~ s/\r//g;
		($word, $censored) = split(/\=/, $censor);
		$msub[$b] =~ s/$word/$censored/g;
	}
	##################
	$nummessages=$mreplies[$b]+1;
	$c=0;
	$pages="";
	if($nummessages>$maxmessagedisplay) {
		while(($c*$maxmessagedisplay)<$nummessages) {
			$viewc = $c+1;
			$strt = ($c*$maxmessagedisplay);
			$pages = <<"EOT";
$pages<a href="$cgi&action=display&num=$mnum[$b]&start=$strt">$viewc</a>
EOT
			++$c;
		}
		$pages =~ s/\n$//g;
		$pages = "<font size=1>($pages)</font>";
	}

	print <<"EOT";
<tr>
	<td width=16 bgcolor="$color{'windowbg2'}"><img src="$imagesdir/$type.gif"></td>
	<td width=16 bgcolor="$color{'windowbg2'}"><img src="$imagesdir/$micon[$b].gif" width=16 height=16 alt="" border="0" align=middle></td>
	<td valing=top width="50%" bgcolor="$color{'windowbg'}"><a href="$cgi&action=display&num=$mnum[$b]"><b>$msub[$b]</b></a> $new $pages</td>
	<td valing=top width="20%" bgcolor="$color{'windowbg2'}">$mname[$b]</td>
	<td valing=top width="10%" align=center bgcolor="$color{'windowbg'}">$mreplies[$b]</td>
	<td valing=top width="20%" align=center bgcolor="$color{'windowbg2'}"><font size=1>$mdate[$b]</font></td>
</tr>
EOT
	if ($numshown >= $maxdisplay && $INFO{'view'} ne 'all') { $b = @messages; }
}
print <<"EOT";
</table>
<table border=0 width=600>
<tr><td>
<b>$txt{'139'}:</b>
EOT
$nummessages=@messages;
$c=0;
while(($c*$maxdisplay)<$nummessages) {
	$viewc = $c+1;
	$strt = ($c*$maxdisplay);
	if($start == $strt) {
		print <<"EOT";
$viewc
EOT
	} else {
		print <<"EOT";
<a href="$cgi&action=messageindex&start=$strt">$viewc</a>
EOT
	}
	++$c;
}
&jumpto;
print <<"EOT";
</td><td align=right>
<a href="$cgi&action=post&title=Start+new+thread">New Thread</a>
</tr></table>
EOT
&footer;
exit;
}

1;
