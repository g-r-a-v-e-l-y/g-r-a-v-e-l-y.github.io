###############################################################################
# RemoveThread.pl                                                             #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Zef Hemel                                    #
###############################################################################

sub RemoveThread {
	$title = "About to remove thread";
	&header;
	print <<"EOT";
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'63'}</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}"><font>
$txt{'162'}<br>
<b><a href="$cgi&action=removethread2&thread=$INFO{'thread'}">$txt{'163'}</a> - <a href="$cgi&action=display&num=$INFO{'thread'}">$txt{'164'}</a></b>
</font></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub RemoveThread2 {
	$thread = $INFO{'thread'};
	$boardmoderator =~ s|\n||g;
	$boardmoderator =~ s|\r||g;
	if($username ne "$boardmoderator" && $settings[7] ne "Administrator") { &fatal_error("$txt{'73'}"); }

	open (FILE, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.dat");
	&lock(FILE);
	@threads = <FILE>;
	&unlock(FILE);
	close (FILE);
	open (FILE, ">$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.dat");
	&lock(FILE);
	for ($a = 0; $a < @threads; $a++) {
		($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mattach) = split(/\|/,$threads[$a]);
		$mattach =~ s/\n//g;
		$mattach =~ s/\r//g;
		if ($mnum ne "$thread") { print FILE "$threads[$a]"; }
	}
	&unlock(FILE);
	close(FILE);
	unlink("$datadir/$thread.txt");
	unlink("$datadir/$thread.mail");
	print "Location: $cgi\n\n";
	exit;
}

1;