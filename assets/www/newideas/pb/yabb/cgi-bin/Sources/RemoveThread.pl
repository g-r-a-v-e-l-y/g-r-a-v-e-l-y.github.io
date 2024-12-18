###############################################################################
# RemoveThread.pl                                                             #
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

$removethreadplver="1 Gold Beta4";

sub RemoveThread {
	$yytitle = "$txt{'246'}";
	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><p>$txt{'63'}</p></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}"><p>
$txt{'162'}<br>
<a href="$cgi&action=removethread2&thread=$INFO{'thread'}">$txt{'163'}</a> - <a href="$cgi&action=display&num=$INFO{'thread'}">$txt{'164'}</a>
</p></td>
</tr>
</table>
EOT
	&footer;
	exit;

}

sub RemoveThread2 {
	$thread = $INFO{'thread'};
	my( $threadcount, $messagecount, $lastposttime, $lastposter, $tmpa, $tmpb, $checknum );
	if((!exists $moderators{$username}) && $settings[7] ne "Administrator") {
		&fatal_error("$txt{'73'}");
	}

	open (FILE, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.dat");
	&lock(FILE);
	@threads = <FILE>;
	&unlock(FILE);
	close (FILE);
	open (FILE, ">$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.dat");
	&lock(FILE);
	$checknum = 0;
	for ($a = 0; $a < @threads; $a++) {
		($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mattach) = split(/\|/,$threads[$a]);
		$mattach =~ s/[\n\r]//g;
		if ($mnum ne $thread) { print FILE "$threads[$a]"; }
		else { $checknum = $a + 1; $tmpb = $mreplies + 1; }
	}
	&unlock(FILE);
	close(FILE);
	if( $checknum ) {
		( $threadcount, $messagecount, $lastposttime, $lastposter ) = &BoardCountGet($currentboard);
		--$threadcount;
		$messagecount -= $tmpb;
		if( $checknum == 1 ) {
			($mnum2, $tmpb, $tmpb, $tmpb, $lastposttime) = split(/\|/, $threads[1]);
			if( $mnum2 ) {
				open(FILE, "$datadir/$mnum2.data");
				&lock(FILE);
				$tmpa = <FILE>;
				&unlock(FILE);
				close(FILE);
				($tmpa, $lastposter) = split(/\|/, $tmpa);
			}
			else {
				$lastposttime = 'N/A';
				$lastposter = 'N/A';
			}
		}
		&BoardCountSet( $currentboard, $threadcount, $messagecount, $lastposttime, $lastposter );
	}

	unlink("$datadir/$thread.txt");
	unlink("$datadir/$thread.mail");
	unlink("$datadir/$thread.data");
	&dumplog($currentboard);
	print "Location: $cgi\n\n";
	exit;
}

1;