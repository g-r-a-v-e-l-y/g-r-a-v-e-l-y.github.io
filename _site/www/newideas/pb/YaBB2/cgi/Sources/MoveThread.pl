###############################################################################
# BoardIndex.pl                                                               #
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

$movethreadplver="1 Gold Beta4";

sub MoveThread {
	&is_admin2;
	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	$yytitle = "$txt{'132'}";
	$boardlist="";
	foreach $curcat (@categories) {
		$curcat =~ s/[\n\r]//g;
		open(CAT, "$boardsdir/$curcat.cat");
		&lock(CAT);
		@catinfo = <CAT>;
		&unlock(CAT);
		close(CAT);
		$catinfo[1] =~ s/[\n\r]//g;
		$curcatname="$catinfo[0]";
		foreach $curboard (@catinfo) {
			if($curboard ne "$catinfo[0]" && $curboard ne "$catinfo[1]") {
				$curboard =~ s/[\n\r]//g;
				$boardlist="$boardlist<option>$curboard";
			}
		}
	}
	############################
	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'132'}</b></font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}"><font size=2>
<form action="$cgi&action=movethread2&thread=$INFO{'thread'}" method="POST">
<b>$txt{'133'}:</b> <select name="toboard">$boardlist</select>
<input type=submit value="$txt{'132'}">
</form>
</font></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub MoveThread2 {
	&is_admin2;
	$thread=$INFO{'thread'};
	$toboard = $FORM{'toboard'};
	open (FILE, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
	&lock(FILE);
	@threads = <FILE>;
	&unlock(FILE);
	close (FILE);
	$checknum = 0;
	for ($a = 0; $a < @threads; $a++) {
		$_ = $threads[$a];
		chomp;
		($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mattach) = split(/\|/,$_);
		if ($mnum eq $thread) {
			$mobileline = $threads[$a];
			$threads[$a] = '';
			$checknum = $a + 1;
			$mobilenum = $mnum;
			$mobiledate = $mdate;
			$mobileposts = $mreplies + 1;
			last;
		}
	}
	open (FILE, ">$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
	&lock(FILE);
	print FILE @threads;
	&unlock(FILE);
	close(FILE);

	unless( $checknum ) {
		&fatal_error(qq~$txt{'472'}: $thread $currentboard -&gt; $toboard~);
	}
	( $threadcount, $messagecount, $lastposttime, $lastposter ) = &BoardCountGet($currentboard);
	--$threadcount;
	$messagecount -= $mobileposts;
	if( $checknum == 1 ) {
		$_ = $threads[1];
		chomp;
		($mnuma, $tmpa, $tmpa, $tmpa, $lastposttime) = split(/\|/, $_);
		if( $mnuma ) {
			open(FILE, "$datadir/$mnuma.data");
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

	open (FILE, "$boardsdir/$toboard.txt") || &fatal_error("$txt{'23'} $toboard.txt");
	&lock(FILE);
	@threads = <FILE>;
	&unlock(FILE);
	close (FILE);

	$mobiletime = stringtotime($mobiledate);
	$checknum = 0;
	for ($a = 0; $a < @threads; $a++) {
		$_ = $threads[$a];
		chomp;
		($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mattach) = split(/\|/,$_);
		$mtime = stringtotime($mdate);
		if ($mobiletime >= $mtime) { last; }
	}

	( $threadcount, $messagecount, $lastposttime, $lastposter ) = &BoardCountGet($toboard);
	++$threadcount;
	$messagecount += $mobileposts;
	if( $a == 0 ) {
		if( $mobilenum ) {
			open(FILE, "$datadir/$mobilenum.data");
			&lock(FILE);
			$tmpa = <FILE>;
			&unlock(FILE);
			close(FILE);
			($tmpa, $lastposter) = split(/\|/, $tmpa);
			$lastposttime = $mobiledate;
		}
		else {
			$lastposttime = 'N/A';
			$lastposter = 'N/A';
		}
	}
	$threads[$a] = $mobileline . $threads[$a];
	&BoardCountSet( $toboard, $threadcount, $messagecount, $lastposttime, $lastposter );

	open (FILE, ">$boardsdir/$toboard.txt") || &fatal_error("$txt{'23'} $toboard.txt");
	&lock(FILE);
	print FILE @threads;
	&unlock(FILE);
	close(FILE);

	print qq~Location: $scripturl?board=$toboard&action=display&num=$thread$blah\n\n~;
	exit;

}

1;